//
//  TestItem.h
//  HearingTest
//
//  Created by Martin Ceperley on 6/16/14.
//  Copyright (c) 2014 Knotable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestItem : NSObject

@property (nonatomic, readonly) BOOL hasSound;
@property (nonatomic, readonly) NSString *frequency;
@property (nonatomic, readonly) float decibels;
@property (nonatomic, readonly) BOOL left;
@property (nonatomic, readonly) BOOL right;

@property (nonatomic, assign) BOOL response;
@property (nonatomic, readonly) BOOL responded;
@property (nonatomic, readonly) BOOL correct;

@property (nonatomic, assign) float noiseLevel;


- (id) initWithFrequency:(NSString *)frequency decibels:(float)decibels left:(BOOL)left right:(BOOL)right;

- (id) initNoSound;


@end
