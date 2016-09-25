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
- (RACSignal*)objectForKey:(NSString *)key;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
@end

@interface RACCache : NSObject<RACCache>
- (instancetype)initWithName:(NSString*)name cacheType:(RACCacheType)cacheType;
- (instancetype)initWithName:(NSString*)name cacheType:(RACCacheType)cacheType diskCapacity:(uint64_t)diskCapacity NS_DESIGNATED_INITIALIZER;
- (RACSignal*)objectForKey:(NSString *)key;
- (void)remove:(NSString*)key;
- (void)removeAll;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
- (RACSignal*)fetchURLSignal:(NSURL*)url;
@end
