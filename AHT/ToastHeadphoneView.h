//
//  ToastHeadphoneView.h
//  AHT
//
//  Created by Troy DeMar on 2/26/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Borders.h"

@interface ToastHeadphoneView : UIView {
    IBOutlet UIView *view;
    IBOutlet UILabel *headerLbl, *fixLbl;
    IBOutlet UITextView *descTextView;
    
}


@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UILabel *headerLbl, *fixLbl;
@property (strong, nonatomic) UITextView *descTextView;

@end
