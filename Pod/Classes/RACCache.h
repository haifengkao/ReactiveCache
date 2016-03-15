//
//  RACCache.h
//  Pods
//
//  Created by Hai Feng Kao on 2015/6/15.
//
//

#import <Foundation/Foundation.h>
#import <RACSignal.h>
@protocol RACCache
- (RACSignal*)objectForKey:(NSString *)key;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
@end

@interface RACCache : NSObject<RACCache>

@end
