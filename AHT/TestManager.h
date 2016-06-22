//
//  TestManager.h
//  HearingTest
//
//  Created by Martin Ceperley on 7/10/14.
//  Copyright (c) 2014 Knotable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestManager : NSObject

+ (TestManager *)sharedInstance;
- (void)resetTest;


@property (nonatomic, assign) BOOL usingAppleHeadphones;

@property (nonatomic, copy) NSString *userEnteredEmail;

@property (nonatomic, assign) int testToneDecibels;

@end
