//
//  ToastDidHearView.h
//  AHT
//
//  Created by Troy DeMar on 3/3/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Borders.h"

@interface ToastDidHearView : UIView {
    IBOutlet UIView *view;
    IBOutlet UILabel *headerLbl, *fixLbl;
    IBOutlet UITextView *descTextView;
    
    UIButton *noBtn, *yesBtn;
}
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UILabel *headerLbl, *fixLbl;
@property (strong, nonatomic) UITextView *descTextView;

@property (strong, nonatomic) UIButton *noBtn, *yesBtn;


@end
