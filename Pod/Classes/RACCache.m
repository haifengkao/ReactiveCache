//
//  RACCache.m
//  Pods
//
//  Created by Hai Feng Kao on 2015/6/15.
//
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RACCache.h"
#import "RACEXTSCope.h"
#import "RACSubject.h"
#import "RACDisposable.h"
#import "RACSignal+Operations.h"
@import HanekeObjc;
@import Haneke;
@interface RACCache()
@property (strong) ImageCache* cache;
@property (strong) NSCache* signalCache; //WARNING! NSCache seems to be broken in iOS 7 (https://gist.github.com/nicklockwood/8025593)
@property (strong) NSString* formatName;
@end
@implementation RACCache

- (instancetype)initWithName:(NSString*)name
{
    if (self = [super init])
    {
        _cache = [[ImageCache alloc] initWithName:name];
        _signalCache = [[NSCache alloc] init];
        _formatName = @"original";
    }

    return self;
}

- (void)remove:(NSString*)key
{
    [self.cache removeWithKey:key formatName:self.formatName];
}

- (void)removeAll 
{
    return [self.cache removeAll];
}

- (RACSignal*)objectForKey:(NSString *)key
{
    NSParameterAssert(key);
    if (!key) { return nil; }

    RACSignal* cachedSignal = [self.signalCache objectForKey:key];
    if (cachedSignal) {
        // we will put the same ongoing http requests together to save some bandwidth
        return cachedSignal;
    }

    @weakify(self);
    RACSignal* signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
    {
        @strongify(self);
        [self.cache fetchWithKey:key 
                     formatName:self.cache.OriginalFormatName
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
    replayLazily] 
    finally: ^(){
        @strongify(self);
        [self.signalCache removeObjectForKey:key];
    }]; 

    if (signal) {
        [self.signalCache setObject:signal forKey:key];
    } 

    return signal;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    NSParameterAssert(object);
    NSParameterAssert(key);

    if (!object || !key ) { return; }

    [self.cache setWithValue:object key:key formatName:self.formatName success:nil]; 
 }

- (RACSignal*)fetchURLSignal:(NSURL*)url
{
    NSString* key = url.absoluteString;

    if (!key) {
        return nil;
    }

    RACSignal* cachedSignal = [self.signalCache objectForKey:key];
    if (cachedSignal) {
        // we will put the same ongoing http requests together to save some bandwidth
        return cachedSignal;
    }

    @weakify(self);
    RACSignal* signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
    {
        @strongify(self);
        [self.cache fetchWithURL:url 
                     formatName:self.cache.OriginalFormatName
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
    replayLazily] 
    finally: ^(){
        @strongify(self);
        [self.signalCache removeObjectForKey:key];
    }]; 

    if (signal) {
        [self.signalCache setObject:signal forKey:key];
    } 

    return signal;
}

@end
