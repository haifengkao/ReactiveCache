import AltHaneke
import Alamofire

public class AltCache<T: DataConvertible where T.Result == T, T : DataRepresentable> : HanekeCache<T, AltDiskCache, NSCache> {
 
    public var networkManager: NetworkManager = NetworkManager.sharedInstance

    public override init(name: String) {
        super.init(name: name)
    }

    public override func fetch(URL URL : NSURL, formatName: String, failure fail: Fetch<T>.Failer? = nil, success succeed: Fetch<T>.Succeeder? = nil) -> Fetch<T> {

        // warning! networkManager might be changed at any moment, you need to store it
        let manager = self.networkManager.manager
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
    let internalManager: Manager 

    public static let sharedInstance: NetworkManager = {
        return NetworkManager()
    }()

    public convenience override init() {
        self.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    public init(configuration: NSURLSessionConfiguration) {
        self.internalManager = NetworkManager.createManager(configuration)
        super.init()
    }

    public var manager: Manager {
        get{ return internalManager }
    }

    static func createManager(configuration: NSURLSessionConfiguration) -> Manager{
        let delegate = Manager.SessionDelegate()
        let session = NSURLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        let manager = Manager(session: session, delegate:delegate)

        if let manager = manager {
            return manager
        } else {
            assert(false, "do you have the correct session delegate?")
            return Manager()
        }
    }
}
