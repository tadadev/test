//
//  PreviousResultsViewController.h
//  AHT
//
//  Created by Troy DeMar on 3/7/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVTableView.h"
#import "JBBarChartView.h"
#import "TestResult.h"

@interface PreviousResultsViewController : UIViewController <HVTableViewDelegate, HVTableViewDataSource, JBBarChartViewDataSource, JBBarChartViewDelegate> {
    IBOutlet UIView *tableContainer;
    IBOutlet HVTableView *dataTableView;
    IBOutlet UIButton *tapButton;
    
    //TestResult *result;
}

@property (strong, nonatomic) UIView *tableContainer;
@property (strong, nonatomic) HVTableView *dataTableView;
@property (strong, nonatomic) UIButton *tapButton;
@property (strong, nonatomic) TestResult *result;

@end
