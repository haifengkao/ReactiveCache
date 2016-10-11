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
}