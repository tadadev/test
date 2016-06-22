//
//  TestManager.m
//  HearingTest
//
//  Created by Martin Ceperley on 7/10/14.
//  Copyright (c) 2014 Knotable. All rights reserved.
//

#import "TestManager.h"

static int STARTING_TEST_TONE_DECIBELS = 50;

@implementation TestManager

+ (TestManager *)sharedInstance
{
    static TestManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[TestManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.usingAppleHeadphones = YES;
        self.userEnteredEmail = nil;
        self.testToneDecibels = STARTING_TEST_TONE_DECIBELS;
    }
    return self;
}

- (void)resetTest{
    self.testToneDecibels = STARTING_TEST_TONE_DECIBELS;
}


@end
