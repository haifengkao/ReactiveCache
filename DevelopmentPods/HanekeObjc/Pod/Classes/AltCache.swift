import AltHaneke
import Alamofire

public class AltCache<T: DataConvertible where T.Result == T, T : DataRepresentable> : HanekeCache<T, AltDiskCache, NSCache> {
 
    public override init(name: String) {
        super.init(name: name)
    }

    public override func fetch(URL URL : NSURL, formatName: String, failure fail: Fetch<T>.Failer? = nil, success succeed: Fetch<T>.Succeeder? = nil) -> Fetch<T> {
        let manager = NetworkManager.sharedInstance
        let fetcher = AltNetworkFetcher<T>(URL: URL, manager: manager)
        return self.fetch(fetcher: fetcher, formatName: formatName, failure: fail, success: succeed)
    }

    public func cachePath(formatName: String) -> String {
        if let (_, _, diskCache) = self.formats[formatName] {
           return diskCache.path
        } else {
           assert(false, "the format name is invalid")
        }
        
        return ""
    }
}

@objc public class NetworkManager : NSObject
{
    /**
        A shared instance of `Manager`, used by top-level Alamofire request methods, and suitable for use directly 
        for any ad hoc requests.
    */
    public static let sharedInstance: Manager = {
        let delegate = Manager.SessionDelegate()
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)

        let manager = Manager.init(session: session, delegate:delegate)

        if let manager = manager {
            return manager
        } else {
            assert(false, "do you have the correct session delegate?")
            return Manager()
        }
    }()
}
