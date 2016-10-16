import AltHaneke

@objc public class StringCache : NSObject {
    public typealias T = String
    public typealias FetchType = StringFetch

    let cache : AltCache<T>
    public override init(){
        assert(false, "please specify the cache name")
        self.cache = AltCache<T>(name: "default")
    }

    public init(name: String) {
        self.cache = AltCache<T>(name: name)
    }

    public func cachePath(formatName: String) -> String{
        return self.cache.cachePath(formatName)
    }

    public func addFormat(name name: String, diskCapacity : UInt64 = UINT64_MAX, transform: ((T) -> (T))? = nil) {
        let format = Format<T>(name: name, diskCapacity: diskCapacity, transform: transform)
        return self.cache.addFormat(format)
    }

    public func set(value value: T, key: String, formatName: String, success succeed: ((T) -> ())? = nil) {
        self.cache.set(value: value, key: key, formatName: formatName, success: succeed)
    }

    public func remove(key key: String, formatName: String) {
        self.cache.remove(key: key, formatName: formatName)
    }

    public func removeAll(completion: (() -> ())? = nil) {
        self.cache.removeAll(completion)
    }

    public func fetch(key key: String, formatName: String, failure fail : FetchType.Failer? = nil, success succeed : FetchType.Succeeder? = nil) -> FetchType {
        let fetch = self.cache.fetch(key: key, formatName: formatName, failure: fail, success: succeed)
        return FetchType(fetch: fetch);
    }

    public func fetch(URL URL : NSURL, formatName: String,  failure fail : FetchType.Failer? = nil, success succeed : FetchType.Succeeder? = nil) -> FetchType {
        let fetch = self.cache.fetch(URL: URL, formatName: formatName, failure: fail, success: succeed)
        return FetchType(fetch: fetch);
    }
}

@objc public class StringFetch : NSObject {
    public typealias T = String
    public typealias Succeeder = (T) -> ()
    public typealias Failer = (NSError?) -> ()

    let fetch : Fetch<T>
    public init(fetch: Fetch<T>){
        self.fetch = fetch
    }
    public func onSuccess(onSuccess: Succeeder) -> Self {
        self.fetch.onSuccess(onSuccess)
        return self
    }
    public func onFailure(onFailure: Failer) -> Self {
        self.fetch.onFailure(onFailure)
        return self
    }
}

