//
//  RACCacheSpec.m
//  Tests
//
//  Created by Hai Feng Kao on 2016/03/15.
//

#import <Kiwi/Kiwi.h>
#import "RACCache.h"

SPEC_BEGIN(RACCacheSpec)

describe(@"RACCache", ^{

    let(testee, ^{ // Occurs before each enclosed "it"
        return [[RACCache alloc] init];
    });
    let(done, ^{ // Occurs before each enclosed "it"
        return @(0);
    });
    
    beforeAll(^{ // Occurs once
    });
    
    afterAll(^{ // Occurs once
    });
    
    beforeEach(^{ // Occurs before each enclosed "it"
    });
    
    afterEach(^{ // Occurs after each enclosed "it"
    });
    
    specify(^{
        [[testee shouldNot] beNil];
    });
    
    it(@"should do something", ^{
        [[testee should] meetSomeExpectation];
    });
    
    it(@"asynchronous do something", ^{
        [[testee should] meetSomeExpectation];
        done = @(1);
        [[expectFutureValue(done) shouldEventually] beTrue];
    });
    
    pending(@"something unimplemented", ^{
    });

});

SPEC_END
