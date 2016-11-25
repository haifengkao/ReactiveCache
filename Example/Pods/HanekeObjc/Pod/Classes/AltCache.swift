import AltHaneke

open class AltCache<T: DataConvertible> : HanekeCache<T, AltDiskCache, NSCache<AnyObject, AnyObject>> where T.Result == T, T : DataRepresentable {
 
    public override init(name: String) {
        super.init(name: name)
    }

    // path the original Cache.swift's removeAll
    open override func removeAll(_ completion: (() -> ())? = nil) {
        let group = DispatchGroup();
        for (_, (_, memoryCache, diskCache)) in self.formats {
            memoryCache.removeAllObjects()
            group.enter()
            diskCache.removeAllData {
                group.leave()
            }
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let timeout = DispatchTime.now() + Double(Int64(60 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
            if group.wait(timeout: timeout) == DispatchTimeoutResult.timedOut {
                Log.error("removeAll timed out waiting for disk caches")
            }
            // HF: remove the cache path will stop the cache from writing any other data
            // HF: until the cache object is recreated
            // let path = self.cachePath
            // do {
            //     try NSFileManager.defaultManager().removeItemAtPath(path)
            // } catch {
            //     Log.error("Failed to remove path \(path)", error as NSError)
            // }
            if let completion = completion {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
