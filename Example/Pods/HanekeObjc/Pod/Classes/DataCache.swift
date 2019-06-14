import AltHaneke

@objc public class DataCache : NSObject {
    public typealias T = Data
    public typealias FetchType = DataFetch

    let cache : AltCache<T>
    @objc public override init(){
        assert(false, "please specify the cache name")
        self.cache = AltCache<T>(name: "default")
    }

    @objc public init(name: String) {
        self.cache = AltCache<T>(name: name)
    }

    @objc public func size(formatName: String) -> NSNumber{
        let diskCache = self.diskCache(formatName: formatName)
        if let diskCache = diskCache {
            return NSNumber(value: diskCache.size)
        }
        return NSNumber(value: 0.0)
    }

    @objc public func cachePath(_ formatName: String) -> String{
        let diskCache = self.diskCache(formatName: formatName)
        if let diskCache = diskCache {
            return diskCache.path
        }
        return ""
    }

    @objc public func pathForKey(_ key: String, formatName: String) -> String {
        let diskCache = self.diskCache(formatName: formatName)
        if let diskCache = diskCache {
            return diskCache.path(forKey: key)
        }
        return ""
    }

    public func diskCache(formatName: String) -> AltDiskCache? {
        if let (_, _, diskCache) = self.cache.formats[formatName] {
            return diskCache
        }
        return nil
    }

    @objc public func addFormat(name: String, diskCapacity : UInt64 = UINT64_MAX, transform: ((T) -> (T))? = nil) {
        let format = Format<T>(name: name, diskCapacity: diskCapacity, transform: transform)
        return self.cache.addFormat(format)
    }

    @objc public func set(value: T, key: String, formatName: String, success succeed: ((T) -> ())? = nil) {
        self.cache.set(value: value, key: key, formatName: formatName, success: succeed)
    }

    @objc public func remove(key: String, formatName: String) {
        self.cache.remove(key: key, formatName: formatName)
    }

    @objc public func removeAll(_ completion: (() -> ())? = nil) {
        self.cache.removeAll(completion)
    }

    @objc public func fetch(key: String, formatName: String, failure fail : FetchType.Failer? = nil, success succeed : FetchType.Succeeder? = nil) -> FetchType {
        let fetch = self.cache.fetch(key: key, formatName: formatName, failure: fail, success: succeed)
        return FetchType(fetch: fetch);
    }

}

@objc public class DataFetch : NSObject {
    public typealias T = Data
    public typealias Succeeder = (T) -> ()
    public typealias Failer = (Error?) -> ()

    let fetch : Fetch<T>
    public init(fetch: Fetch<T>){
        self.fetch = fetch
    }
    @objc @discardableResult open func onSuccess(_ onSuccess: @escaping Succeeder) -> Self {
        self.fetch.onSuccess(onSuccess)
        return self
    }
    @objc @discardableResult open func onFailure(_ onFailure: @escaping Failer) -> Self {
        self.fetch.onFailure(onFailure)
        return self
    }
}
