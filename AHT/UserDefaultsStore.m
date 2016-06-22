//
//  UserDefaultsStore.m
//  Mynd
//
//  Created by Shuaib on 01/07/2014.
//  Copyright (c) 2014 Appurava. All rights reserved.
//

#import "UserDefaultsStore.h"

@interface UserDefaultsStore ()


@end

@implementation UserDefaultsStore

+ (UserDefaultsStore *)shared
{
    static UserDefaultsStore *userDefaultsStore = nil;
    if (!userDefaultsStore) {
        userDefaultsStore = [UserDefaultsStore new];
    }
    return userDefaultsStore;
}



#pragma Test Results

- (void)saveLeftResponses:(NSDictionary *)leftResponses rightResponses:(NSDictionary *)rightResponses{
    NSLog(@"Saving Left Responses: %@", leftResponses);
    NSLog(@"Saving Right Responses: %@", rightResponses);

    
    [[NSUserDefaults standardUserDefaults] setObject:leftResponses forKey:@"leftResponses"];
    [[NSUserDefaults standardUserDefaults] setObject:rightResponses forKey:@"rightResponses"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSDictionary *)leftResponses{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"leftResponses"];
    return dict;
}

- (NSDictionary *)rightResponses{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"rightResponses"];
    return dict;
}



@end
