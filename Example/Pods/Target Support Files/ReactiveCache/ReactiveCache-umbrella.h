#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "RACCache.h"
#import "RACDataCache.h"
#import "RACImageCache.h"

FOUNDATION_EXPORT double ReactiveCacheVersionNumber;
FOUNDATION_EXPORT const unsigned char ReactiveCacheVersionString[];

