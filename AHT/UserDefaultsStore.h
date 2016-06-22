//
//  UserDefaultsStore.h
//  Mynd
//
//  Created by Shuaib on 01/07/2014.
//  Copyright (c) 2014 Appurava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsStore : NSObject

+ (UserDefaultsStore *)shared;



#pragma Test Results

- (void)saveLeftResponses:(NSDictionary *)leftResponses rightResponses:(NSDictionary *)rightResponses;
- (NSDictionary *)leftResponses;
- (NSDictionary *)rightResponses;

//#pragma Day ONE Reset
//- (void)dayOneReset;

@end
