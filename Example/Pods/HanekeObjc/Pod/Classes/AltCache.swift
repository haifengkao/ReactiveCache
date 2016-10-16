import AltHaneke

public class AltCache<T: DataConvertible where T.Result == T, T : DataRepresentable> : HanekeCache<T, AltDiskCache, NSCache> {
 
    public override init(name: String) {
        super.init(name: name)
    }

    public func cachePath(formatName: String) -> String {
        if let (_, _, diskCache) = self.formats[formatName] {
           return diskCache.path
        } else {
           assert(false, "the format name is invalid")
        }
        
        return ""
    }

    // path the original Cache.swift's removeAll
    public override func removeAll(completion: (() -> ())? = nil) {
        let group = dispatch_group_create();
        for (_, (_, memoryCache, diskCache)) in self.formats {
            memoryCache.removeAllObjects()
            dispatch_group_enter(group)
            diskCache.removeAllData {
                dispatch_group_leave(group)
            }
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let timeout = dispatch_time(DISPATCH_TIME_NOW, Int64(60 * NSEC_PER_SEC))
            if dispatch_group_wait(group, timeout) != 0 {
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
                dispatch_async(dispatch_get_main_queue()) {
                    completion()
                }
            }
        }
    }
}
