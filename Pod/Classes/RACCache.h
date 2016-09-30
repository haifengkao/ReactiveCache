//
//  RACCache.h
//  Pods
//
//  Created by Hai Feng Kao on 2015/6/15.
//
//

#import <Foundation/Foundation.h>
@class RACSignal;

typedef NS_ENUM(NSUInteger, RACCacheType) {
    RACCacheImage,
    RACCacheData,
};

@protocol RACCache
// get the object from the cache
// will return error if the object is not found
- (RACSignal*)objectForKey:(NSString *)key;
// put the object in the cache
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
- (void)remove:(NSString*)key;
- (void)removeAll;

@optional
// get the tuple (object, object attributes) from the cache
// will return error if the object is not found
- (RACSignal*)objectForKeyExt:(NSString *)key;
// return the cache size in bytes
- (double)cacheSize;
@end

@interface RACCache : NSObject<RACCache>
- (instancetype)initWithName:(NSString*)name cacheType:(RACCacheType)cacheType;
- (instancetype)initWithName:(NSString*)name cacheType:(RACCacheType)cacheType diskCapacity:(uint64_t)diskCapacity NS_DESIGNATED_INITIALIZER;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
- (RACSignal*)objectForKey:(NSString *)key;
- (void)remove:(NSString*)key;
- (void)removeAll;
- (RACSignal*)fetchURLSignal:(NSURL*)url;
@end
