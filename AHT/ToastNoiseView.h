//
//  ToastNoiseView.h
//  AHT
//
//  Created by Troy DeMar on 2/26/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Borders.h"

@interface ToastNoiseView : UIView {
    IBOutlet UIView *view;
    IBOutlet UILabel *headerLbl, *fixLbl;
    IBOutlet UITextView *descTextView;
    
    UIView *circle;
    NSTimer *timer;
    
    CGFloat size;
    NSTimeInterval interval;
    int currentSpeed;
}

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UILabel *headerLbl, *fixLbl;
@property (strong, nonatomic) UITextView *descTextView;


- (void)speed1;
- (void)speed2;
- (void)speed3;
- (void)speed4;
- (void)speed5;
- (void)speed6;

@end
