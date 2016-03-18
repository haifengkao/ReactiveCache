//
//  AltNetworkFetcher.swift
//  HanekeObjc
//
//  Created by Hai Feng Kao on 3/8/16.
//  Copyright (c) 2015 Hai Feng Kao. All rights reserved.
//

import AltHaneke
import Alamofire

extension NSURLResponse {
    
    func hnk_validateLengthOfData(data: NSData) -> Bool {
        let expectedContentLength = self.expectedContentLength
        if (expectedContentLength > -1) {
            let dataLength = data.length
            return Int64(dataLength) >= expectedContentLength
        }
        return true
    }
    
}

extension NSHTTPURLResponse {
    
    func hnk_isValidStatusCode() -> Bool {
        switch self.statusCode {
        case 200...201:
            return true
        default:
            return false
        }
    }
    
}

public class AltNetworkFetcher<T : DataConvertible> : Fetcher<T> {
    
    let URL : NSURL
    let manager: Manager
    
    public init(URL: NSURL, manager: Manager) {
        self.URL = URL

        let key =  URL.absoluteString

        self.manager = manager
        super.init(key: key)
    }
    
    var task : NSURLSessionDataTask? = nil
    
    var cancelled = false

    public var progress: ((NSProgress) -> ())? = nil

    public override func fetch(failure fail : ((NSError?) -> ()),
                            success succeed : (T.Result) -> ())
    {

        self.cancelled = false
        let request = self.manager.request(
            Method.GET,
            self.URL,
            parameters: nil
        )

        if let progress = progress {
            request.progress { [weak request] bytesRead, totalBytesRead, totalBytesExpectedToRead in
                if let request = request {
                    progress(request.progress)
                }
            }
        }

        request.response { [weak self] request, response, data, error in
            if let strongSelf = self {
                strongSelf.onReceiveData(data, response: response, error: error, failure: fail, success: succeed)
            }
        }

    }
    
    public override func cancelFetch() {
        self.task?.cancel()
        self.cancelled = true
    }
    
    // MARK: Private
    
    private func onReceiveData(data: NSData!, response: NSURLResponse!, error: NSError!, failure fail: ((NSError?) -> ()), success succeed: (T.Result) -> ()) {

        if cancelled { return }
        
        let URL = self.URL
        
        if let error = error {
            if (error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled) { return }
            
            //Log.debug("Request \(URL.absoluteString) failed", error)
            dispatch_async(dispatch_get_main_queue(), { fail(error) })
            return
        }
        
        if let httpResponse = response as? NSHTTPURLResponse where !httpResponse.hnk_isValidStatusCode() {
            let description = NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)
            self.failWithCode(.InvalidStatusCode, localizedDescription: description, failure: fail)
            return
        }

        if !response.hnk_validateLengthOfData(data) {
            let localizedFormat = NSLocalizedString("Request expected %ld bytes and received %ld bytes", comment: "Error description")
            let description = String(format:localizedFormat, response.expectedContentLength, data.length)
            self.failWithCode(.MissingData, localizedDescription: description, failure: fail)
            return
        }
        
        guard let value = T.convertFromData(data) else {
            let localizedFormat = NSLocalizedString("Failed to convert value from data at URL %@", comment: "Error description")
            let description = String(format:localizedFormat, URL.absoluteString)
            self.failWithCode(.InvalidData, localizedDescription: description, failure: fail)
            return
        }

        dispatch_async(dispatch_get_main_queue()) { succeed(value) }

    }
    
    func errorWithCode(code: Int, description: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: description]
        return NSError(domain: "io.hanekeobjc", code: code, userInfo: userInfo)
    }
    
    private func failWithCode(code: HanekeGlobals.NetworkFetcher.ErrorCode, localizedDescription: String, failure fail: ((NSError?) -> ())) {
        let error = errorWithCode(code.rawValue, description: localizedDescription)
        //Log.debug(localizedDescription, error)
        dispatch_async(dispatch_get_main_queue()) { fail(error) }
    }
}
