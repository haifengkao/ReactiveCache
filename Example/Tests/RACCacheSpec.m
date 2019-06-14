//
//  RACCacheSpec.m
//  Tests
//
//  Created by Hai Feng Kao on 2016/03/15.
//

@import Kiwi;
@import ReactiveObjC;
@import ReactiveCache;
#import "RACSignal+Operations.h"

@import AltHaneke; // for image decompress

SPEC_BEGIN(RACImageCacheSpec)

describe(@"RACDataCache", ^{
    let(testee, ^{ // Occurs before each enclosed "it"
        return [[RACDataCache alloc] initWithName:@"original" diskCapacity:1000.0];
    });
    
    let(done, ^{ // Occurs before each enclosed "it"
        return @(0);
    });
    
    it(@"should get the data", ^{
        NSNumber* num = @(42);
        [testee setObject:num forKey:@"key"];
        
        RACSignal* signal = [testee objectForKey:@"key"];
        // setObject is on another thread
        // it is possible that objectForKey is fired before the object is set
        [signal subscribeNext:^(NSNumber* val) {
            NSAssert(val, @"should get the cached nsnumber successfully");
            done = @(1);
        } error:^(NSError *error) {
            [[error should] beNil];
        }];
        
        [[expectFutureValue(done) shouldEventuallyBeforeTimingOutAfter(20000)] beTrue];
    });
});

describe(@"RACImageCache", ^{

    let(testee, ^{ // Occurs before each enclosed "it"
        return [[RACImageCache alloc] initWithName:@"original"];
    });
    let(done, ^{ // Occurs before each enclosed "it"
        return @(0);
    });
    let(removed, ^{ // Occurs before each enclosed "it"
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

        // it takes some time (different thread) to set the image
        NSAssert([NSThread isMainThread], @"Pass only guaranteed to work in main thread");
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; //wait for 0.1 second
    });
    
    afterEach(^{ // Occurs after each enclosed "it"

        // we got to wait for all data to be removed
        // otherwise the removal process might conflict with other test cases
        [testee removeAll:^(){
            removed = @(1);
        }];
        [[expectFutureValue(removed) shouldEventuallyBeforeTimingOutAfter(20)] beTrue];
    });
    
    specify(^{
        [[testee shouldNot] beNil];
    });

    it(@"should use md5 as the filename", ^{

        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; //wait for 0.1 second
        NSURL* url = [testee urlForKey:@"hi.png"];
        
        [[url.lastPathComponent should] equal:@"2f74810068f5603a6f154eaa692316dc.png"];
    });

    it(@"should get the image path from cache", ^{
        NSURL* url = [testee urlForKey:imageUrl.absoluteString];

        [[expectFutureValue(url) shouldNot] beNil];
    });
    
    it(@"should get the cache size", ^{
        RACSignal* signal = [testee objectForKey:imageUrl.absoluteString];
        // setObject is on another thread
        // it is possible that objectForKey is fired before the object is set
        [signal subscribeNext:^(UIImage* image) {
            NSAssert(image, @"should get the cached image successfully");
            done = @(1);
        } error:^(NSError *error) {
            [[error should] beNil];
        }];
        
        
        [[expectFutureValue(done) shouldEventuallyBeforeTimingOutAfter(20000)] beTrue];
        [[@(testee.cacheSize) should] beGreaterThan:@(0)];
    });
    
    it(@"should get the image from cache", ^{
        RACSignal* signal = [testee objectForKey:imageUrl.absoluteString];
        // setObject is on another thread
        // it is possible that objectForKey is fired before the object is set
        [signal subscribeNext:^(UIImage* image) {
            NSAssert(image, @"should get the cached image successfully");
            done = @(1);
        } error:^(NSError *error) {
            [[error should] beNil];
        }];

        [[expectFutureValue(done) shouldEventuallyBeforeTimingOutAfter(20000)] beTrue];
    });

    it(@"should get the file attributes from the cache", ^{
        RACSignal* signal = [testee objectForKeyEx:imageUrl.absoluteString];
        // setObject is on another thread
        // it is possible that objectForKey is fired before the object is set
        [signal subscribeNext:^(RACTuple* tuple) {
            RACTupleUnpack(UIImage* image, NSDictionary* attributes) = tuple;
            NSAssert(image, @"should get the cached image successfully");
            [[image shouldNot] beNil];
            [[attributes[NSFileSize] should] beGreaterThan:@(0)];
            done = @(1);
        } error:^(NSError *error) {
            [[error should] beNil];
        }];

        [[expectFutureValue(done) shouldEventuallyBeforeTimingOutAfter(20000)] beTrue];
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

describe(@"UIImage extension", ^{
    let(img, ^{ // Occurs before each enclosed "it"
        return [UIImage imageNamed:@"hpc18.png"];
    });
    
    it(@"should decompress image", ^{
        UIImage* decompressed = [img hnk_decompressedImage];
        [[decompressed shouldNot] beNil];
    });
});

SPEC_END
