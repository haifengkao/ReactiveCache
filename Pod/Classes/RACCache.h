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
// get the object from the cache
// will return error if the object is not found
- (RACSignal*)objectForKey:(NSString *)key;
// put the object in the cache
- (void)setObject:(NSObject<NSCoding>*)object forKey:(NSString *)key;
- (void)remove:(NSString*)key;
- (void)removeAll:(void(^)())completion;

@optional
// get the tuple (object, object attributes) from the cache
// will return error if the object is not found
- (RACSignal*)objectForKeyExt:(NSString *)key;
// return the cache size in bytes
- (double)cacheSize;
@end

@interface RACCache : NSObject<RACCache>
@property (strong) id cache;    // the disk cache
@property (strong) NSString* formatName;

@end
