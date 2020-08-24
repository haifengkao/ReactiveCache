//
//  RACImageCache.m
//  ReactiveCache
//
//  Created by Hai Feng Kao on 2016/09/30.
//
//

#import "RACImageCache.h"
@import HanekeObjc;
@import ReactiveObjC;

@implementation RACImageCache

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
        self.cache = [[ImageCache alloc] initWithName:name];
        self.formatName = @"rac_original";
        [self.cache addFormatWithName:self.formatName diskCapacity:diskCapacity transform: nil];
    }

    return self;
}

- (void)setObject:(NSObject<NSCoding>*)object forKey:(NSString *)key
{
    // image cache should store image objects
    
    NSParameterAssert([object isKindOfClass:[UIImage class]]);
    [super setObject:object forKey:key];
}

@end
