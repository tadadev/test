//
//  ResultsListViewController.h
//  AHT
//
//  Created by Troy DeMar on 3/6/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

//@interface ResultsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
@interface ResultsListViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *dataTableView;
    IBOutlet UITextView *resultsTextView;
}

@property (strong, nonatomic) UITableView *dataTableView;
@property (strong, nonatomic) UITextView *resultsTextView;

@end
