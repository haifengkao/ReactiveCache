//
//  RACCache.h
//  Pods
//
//  Created by Hai Feng Kao on 2015/6/15.
//
//

#import <Foundation/Foundation.h>
@class RACSignal;

@protocol RACCache
// get the ObjectType* object from the cache
// the ObjectType depends on the Cache (ImageCache will return UIImage*)
// will return error if the object is not found
- (RACSignal*)objectForKey:(NSString *)key;
// put the object in the cache
- (void)setObject:(NSObject<NSCoding>*)object forKey:(NSString *)key;
- (void)remove:(NSString*)key;
- (void)removeAll:(void(^)())completion;

@optional
// get the tuple (ObjectType* object, NSDictionary* object_attributes) from the cache
// will return error if the object is not found
- (RACSignal*)objectForKeyEx:(NSString *)key;
// return the cache size in bytes
- (double)cacheSize;
@end

@interface RACCache : NSObject<RACCache>
@property (strong) id cache;    // the disk cache
@property (copy) NSString* formatName;

- (NSURL*)urlForKey:(NSString*)key;
- (double)cacheSize; // faster method. It is the cached size managed by HanekeSwift. Inaccurate after some data has been removed
- (double)cacheSizeRecomputed; // slower, but accurate method. it iterates through all the files in the cache's folder
@end
