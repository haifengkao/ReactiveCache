//
//  RACCacheSpec.m
//  Tests
//
//  Created by Hai Feng Kao on 2016/03/15.
//

#import <Kiwi/Kiwi.h>
#import "RACImageCache.h"
#import "RACSignal.h"

SPEC_BEGIN(RACImageCacheSpec)

describe(@"RACImageCache", ^{

    let(testee, ^{ // Occurs before each enclosed "it"
        return [[RACImageCache alloc] initWithName:@"original"];
    });
    let(done, ^{ // Occurs before each enclosed "it"
        return @(0);
    });
    let(imageUrl, ^{ // Occurs before each enclosed "it"
        return [NSURL URLWithString:@"http://www.bing.com/s/a/hpc18.png"];
    });
    
    beforeAll(^{ // Occurs once
    });
    
    afterAll(^{ // Occurs once
    });
    
    beforeEach(^{ // Occurs before each enclosed "it"
        UIImage* img = [UIImage imageNamed:@"hpc18.png"];
        [testee setObject:img forKey:imageUrl.absoluteString];
    });
    
    afterEach(^{ // Occurs after each enclosed "it"
    });
    
    specify(^{
        [[testee shouldNot] beNil];
    });
    
    it(@"should get the image from cache", ^{
        RACSignal* signal = [testee objectForKey:imageUrl.absoluteString];
        [signal subscribeNext:^(UIImage* image) {
            NSAssert(image, @"should get the cached image successfully");
            done = @(1);
        }];
        [[expectFutureValue(done) shouldEventually] beTrue];
    });
    
    it(@"should remove the image from cache", ^{
        [testee remove:imageUrl.absoluteString];
        RACSignal* signal = [testee objectForKey:imageUrl.absoluteString];
        [signal subscribeNext:^(UIImage* image) {
            NSAssert(NO, @"should not return anything");
            } error:^(NSError* error) {
                done = @(1);
            }];
        [[expectFutureValue(done) shouldEventually] beTrue];
    });
});

SPEC_END
