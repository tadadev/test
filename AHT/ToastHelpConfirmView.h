//
//  ToastHelpConfirmView.h
//  AHT
//
//  Created by Troy DeMar on 2/26/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastHelpConfirmView : UIView {
    IBOutlet UIView *view;
    IBOutlet UILabel *headerLbl;
    IBOutlet UITextView *descTextView;
    IBOutlet UIButton *dismissBtn;
}

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UILabel *headerLbl;
@property (strong, nonatomic) UITextView *descTextView;
@property (strong, nonatomic) UIButton *dismissBtn;

@end
