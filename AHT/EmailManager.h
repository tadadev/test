//
//  EmailManager.h
//  HearingTest
//
//  Created by Martin Ceperley on 7/15/14.
//  Copyright (c) 2014 Knotable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TestResult, OMPromise;

@interface EmailManager : NSObject

+ (OMPromise *)sendEmailTo:(NSString *)email;

+ (BOOL)isValidEmail:(NSString *)email;

@end
