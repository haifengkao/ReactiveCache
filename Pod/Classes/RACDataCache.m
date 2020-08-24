//
//  RACDataCache.m
//  ReactiveCache
//
//  Created by Hai Feng Kao on 2016/09/30.
//
//

#import "RACDataCache.h"
@import HanekeObjc;
@import ReactiveObjC;

@implementation RACDataCache

- (instancetype)init
{
    return [self initWithName:@"rac_original"];
}

- (instancetype)initWithName:(NSString*)name
{
    return [self initWithName:name diskCapacity:UINT64_MAX];
}

/** 
  * craete new cache
  * 
  * @param name cache folder name
  * @param diskCapacity disk capacity in bytes
  * 
  * @return return value description
  */
- (instancetype)initWithName:(NSString*)name diskCapacity:(uint64_t)diskCapacity
{
    if (self = [super init])
    {
        self.cache = [[DataCache alloc] initWithName:name];
        self.formatName = @"rac_original";
        [self.cache addFormatWithName:self.formatName diskCapacity:diskCapacity transform: nil];
    }

    return self;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    // archive the object first
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [super setObject:data forKey:key];
}

- (RACSignal*)objectForKey:(NSString *)key
{
    // unarchive the object
    RACSignal* signal = [super objectForKey:key];
    return [signal map:^(NSData* data){
        id<NSCoding> object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return object;
    }];
} 
@end
