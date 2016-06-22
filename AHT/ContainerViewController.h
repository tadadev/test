//
//  ContainerViewController.h
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestResult.h"

@interface ContainerViewController : UIViewController

@property (strong, nonatomic) NSString *currentSegueIdentifier;


- (void)toHome;
- (void)toTest;
- (void)toResultsList;
- (void)toResults;
- (void)toContact;

//- (void)openResults;
- (void)openTOS;


- (void)toResult:(TestResult *)result;




// test
- (void)menuAction;

@end
