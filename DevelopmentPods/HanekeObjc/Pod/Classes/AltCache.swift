import AltHaneke

public class AltCache<T: DataConvertible where T.Result == T, T : DataRepresentable> : HanekeCache<T, AltDiskCache, NSCache> {
 
    public override init(name: String) {
        super.init(name: name)
    }

    public override func fetch(URL URL : NSURL, formatName: String, failure fail: Fetch<T>.Failer? = nil, success succeed: Fetch<T>.Succeeder? = nil) -> Fetch<T> {
        let fetcher = AltNetworkFetcher<T>(URL: URL)
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
