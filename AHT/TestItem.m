//
//  TestItem.m
//  HearingTest
//
//  Created by Martin Ceperley on 6/16/14.
//  Copyright (c) 2014 Knotable. All rights reserved.
//

#import "TestItem.h"

@implementation TestItem

- (id) initWithFrequency:(NSString *)frequency decibels:(float)decibels left:(BOOL)left right:(BOOL)right
{
    if (self = [super init]) {
        _frequency = frequency;
        _decibels = decibels;
        _left = left;
        _right = right;
        _hasSound = YES;
    }
    
    return self;
}

- (id) initNoSound
{
    if (self = [super init]) {
        _hasSound = NO;
    }
    
    return self;
}


- (void) setResponse:(BOOL)response
{
    _responded = YES;
    _response = response;
    _correct = (_response == _hasSound);
                
//    NSLog(@"setResponse: %d correct: %d", _response, _correct);
}
@end
