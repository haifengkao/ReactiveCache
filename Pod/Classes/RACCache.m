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
@property (strong) id cache;    // the disk cache
@property (strong) NSString* formatName;
@end
@implementation RACCache

- (instancetype)init
{
    return [self initWithName:@"rac_original" cacheType:RACCacheData];
}

- (instancetype)initWithName:(NSString*)name cacheType:(RACCacheType)cacheType
{
    return [self initWithName:name cacheType:cacheType diskCapacity:UINT64_MAX];
}


/** 
  * craete new cache
  * 
  * @param name cache folder name
  * @param cacheType complicated
  * @param diskCapacity disk capacity in bytes
  * 
  * @return return value description
  */
- (instancetype)initWithName:(NSString*)name cacheType:(RACCacheType)cacheType diskCapacity:(uint64_t)diskCapacity
{
    if (self = [super init])
    {
        if (cacheType == RACCacheImage) {
            _cache = [[ImageCache alloc] initWithName:name];
        } else {
            _cache = [[DataCache alloc] initWithName:name];
        }
        _formatName = @"rac_original";
        [_cache addFormatWithName:_formatName diskCapacity:diskCapacity transform: nil];
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

    @weakify(self);
    RACSignal* signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
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
    replayLazily];

    return signal;
}

@end
