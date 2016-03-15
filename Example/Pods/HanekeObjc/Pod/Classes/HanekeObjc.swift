import Haneke
@objc public class ImageCache : NSObject {
    let cache : Cache<UIImage>
    override public init() {
        self.cache = Cache<UIImage>(name: "hi")
    }
    public func removeAll() {
        self.cache.removeAll();
    }
}
