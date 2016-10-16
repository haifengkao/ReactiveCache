//
//  RACCache.m
//  Pods
//
//  Created by Hai Feng Kao on 2015/6/15.
//
//
#import <Foundation/Foundation.h>
#import "RACCache.h"
#import "RACEXTSCope.h"
#import "RACSubject.h"
#import "RACDisposable.h"
#import "RACSignal+Operations.h"
@import HanekeObjc;
@import AltHaneke;
#import "RACSignal.h"

@interface RACCache()
@end

@implementation RACCache

- (void)remove:(NSString*)key
{
    [self.cache removeWithKey:key formatName:self.formatName];
}

- (void)removeAll:(void(^)())completion
{
    return [self.cache removeAll:completion];
}

- (RACSignal*)objectForKey:(NSString *)key
{
    NSParameterAssert(key);
    if (!key) { return nil; }

    @weakify(self);
    RACSignal* signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
    {
        @strongify(self);
        [self.cache fetchWithKey:key 
                     formatName:self.formatName
                        failure:^(NSError* error){
                           [subscriber sendError:error];
                        }
                        success:^(id obj){
                            [subscriber sendNext: obj];
                            [subscriber sendCompleted];
                        }
        ];
        return [RACDisposable disposableWithBlock:^{
            // TODO: cancel is not implemented in Haneke
            //[dataTask cancel];
        }];
        
    }] 
    replayLazily];

    return signal;
}

- (void)setObject:(NSObject<NSCoding>*)object forKey:(NSString *)key
{
    NSParameterAssert(object);
    NSParameterAssert(key);
    NSAssert(self.cache, @"did you forget to set the cache?");

    if (!object || !key ) { return; }

    [self.cache setWithValue:object key:key formatName:self.formatName success:nil]; 
 }

@end
