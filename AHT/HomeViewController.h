//
//  HomeViewController.h
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

//@interface HomeViewController : UIViewController {
@interface HomeViewController : GAITrackedViewController {
    IBOutlet UIView *startView;
    IBOutlet UIButton *startBtn;
}

@property (strong, nonatomic) UIView *startView;
@property (strong, nonatomic) UIButton *startBtn;

- (IBAction)beginTest:(id)sender;

@end
