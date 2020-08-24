//
//  RACDataCache.h
//  Classes
//
//  Created by Hai Feng Kao on 2016/09/30.
//
//

#import "RACCache.h"

@interface RACDataCache : RACCache

- (instancetype)initWithName:(NSString*)name diskCapacity:(uint64_t)diskCapacity NS_DESIGNATED_INITIALIZER;
@end
