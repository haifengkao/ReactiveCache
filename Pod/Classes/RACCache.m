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
@import AltHaneke;

@interface RACCache()
@property (strong) ImageCache* cache;
@property (strong) NSCache* signalCache; //WARNING! NSCache seems to be broken in iOS 7 (https://gist.github.com/nicklockwood/8025593)
@property (strong) NSString* formatName;
@property (strong) NetworkManager* manager;
@end
@implementation RACCache

- (instancetype)init
{
    return [self initWithName:@"rac_original"];
}

- (instancetype)initWithName:(NSString*)name
{
    return [self initWithName:name diskCapacity:UINT64_MAX];
}

- (instancetype)initWithName:(NSString*)name diskCapacity:(uint64_t)diskCapacity
{
    if (self = [super init])
    {
        _manager = [NetworkManager sharedInstance];
        _cache = [[ImageCache alloc] initWithName:name];
        _signalCache = [[NSCache alloc] init];
        _formatName = @"rac_original";
        [_cache addFormatWithName:_formatName diskCapacity:diskCapacity transform: nil];
    }

    return self;
}

- (void)setURLSessionConfiguration:(NSURLSessionConfiguration*)configuration
{
    if (configuration) {
        self.manager = [[NetworkManager alloc] initWithConfiguration:configuration];
    } 
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
        id fetch = [self.cache fetchWithURL:url
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
