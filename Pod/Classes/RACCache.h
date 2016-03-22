//
//  RACCache.h
//  Pods
//
//  Created by Hai Feng Kao on 2015/6/15.
//
//

#import <Foundation/Foundation.h>
#import "RACSignal.h"

@protocol RACCache
- (RACSignal*)objectForKey:(NSString *)key;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
@end

@interface RACCache : NSObject<RACCache>
- (void)setURLSessionConfiguration:(NSURLSessionConfiguration*)configuration;
- (instancetype)initWithName:(NSString*)name;
- (instancetype)initWithName:(NSString*)name diskCapacity:(uint64_t)diskCapacity NS_DESIGNATED_INITIALIZER;
- (RACSignal*)objectForKey:(NSString *)key;
- (void)remove:(NSString*)key;
- (void)removeAll;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
- (RACSignal*)fetchURLSignal:(NSURL*)url;
@end
