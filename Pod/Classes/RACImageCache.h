//
//  RACImageCache.h
//  Classes
//
//  Created by Hai Feng Kao on 2016/09/30.
//
//

#import <Foundation/Foundation.h>
#import "RACCache.h"

@interface RACImageCache : RACCache

- (instancetype)initWithName:(NSString*)name;
- (instancetype)initWithName:(NSString*)name diskCapacity:(uint64_t)diskCapacity NS_DESIGNATED_INITIALIZER;
@end
