import AltHaneke

@objc public class ImageCache : NSObject {
    public typealias T = UIImage
    public typealias FetchType = ImageFetch

    let cache : AltCache<T>
    public override init(){
        assert(false, "please specify the cache name")
        self.cache = AltCache<T>(name: "default")
    }

    public init(name: String) {
        self.cache = AltCache<T>(name: name)
    }

    public func cachePath(_ formatName: String) -> String{
        return self.cache.cachePath(formatName)
    }

    public func pathForKey(_ key: String, formatName: String) -> String {
        return self.cache.pathForKey(key, formatName: formatName);
    }

    public func addFormat(_ name: String, diskCapacity : UInt64 = UINT64_MAX, transform: ((T) -> (T))? = nil) {
        let format = Format<T>(name: name, diskCapacity: diskCapacity, transform: transform)
        return self.cache.addFormat(format)
    }

    public func set(_ value: T, key: String, formatName: String, success succeed: ((T) -> ())? = nil) {
        self.cache.set(value: value, key: key, formatName: formatName, success: succeed)
    }

    public func remove(_ key: String, formatName: String) {
        self.cache.remove(key: key, formatName: formatName)
    }

    public func removeAll(_ completion: (() -> ())? = nil) {
        self.cache.removeAll(completion)
    }

    public func fetch(_ key: String, formatName: String, failure fail : FetchType.Failer? = nil, success succeed : FetchType.Succeeder? = nil) -> FetchType {
        let fetch = self.cache.fetch(key: key, formatName: formatName, failure: fail, success: succeed)
        return FetchType(fetch: fetch);
    }

}

@objc public class ImageFetch : NSObject {
    public typealias T = UIImage
    public typealias Succeeder = (T) -> ()
    public typealias Failer = (Error?) -> ()

    let fetch : Fetch<T>
    public init(fetch: Fetch<T>){
        self.fetch = fetch
    }
    @discardableResult open func onSuccess(_ onSuccess: @escaping Succeeder) -> Self {
        self.fetch.onSuccess(onSuccess)
        return self
    }
    @discardableResult open func onFailure(_ onFailure: @escaping Failer) -> Self {
        self.fetch.onFailure(onFailure)
        return self
    }
}
