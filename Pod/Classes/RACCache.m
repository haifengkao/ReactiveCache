//
//  RACCache.m
//  Pods
//
//  Created by Lono on 2015/6/15.
//
//

#import "RACCache.h"
#import <RACEXTSCope.h>
#import <RACSubject.h>
#import <RACDisposable.h>
#import <RACSignal+Operations.h>
#import <TMCache.h>

@interface RACCache()
@property (atomic, strong) TMMemoryCache* cache;
@property (atomic, strong) TMDiskCache* diskCache;
@end
@implementation RACCache

- (RACSignal*)objectForKey:(NSString *)key
{
    NSParameterAssert(key);
    
    RACSignal* dataSignal = [self.cache objectForKey:key];
    
    if (nil == dataSignal) {
        @weakify(self);
        dataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [self.diskCache objectForKey:key block:^(TMDiskCache *cache, NSString *key, id<NSCoding> object, NSURL *fileURL) {
                
                if (nil == object) {
                    [subscriber sendError:nil];
                } else {
                    [subscriber sendNext:object];
                    [subscriber sendCompleted];
                }
            }];
            
            return [RACDisposable new];
        }];
        
        // we may have racing condition here
        
        if (dataSignal) {
            [self.cache setObject:dataSignal.replayLazily forKey:key];
        }
    }
    
    return dataSignal;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    NSParameterAssert(object);
    NSParameterAssert(key);
    
    RACSignal* signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (nil == object) {
                [subscriber sendError:nil];
            } else {
                [subscriber sendNext:object];
                [subscriber sendCompleted];
            }
        return [RACDisposable new];
    }] replayLazily];
    
    if (signal) {
        [self.cache setObject:signal forKey:key];
    } else {
        // remove old data
        [self.cache removeObjectForKey:key];
    }
    
    [self.diskCache setObject:object forKey:key block:^(TMDiskCache *cache, NSString *key, id<NSCoding> object, NSURL *fileURL) {
        
    }];
}
@end
