//
//  EmailCaptureView.h
//  AHT
//
//  Created by Troy DeMar on 3/9/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailCaptureView : UIView {
    IBOutlet UIView *view;
    IBOutlet UITextView *textView;
    IBOutlet UITextField *emailTextField;
    IBOutlet UIButton *dismissBtn, *sendBtn;
    
    IBOutlet UIButton *dismissBtn2;
    IBOutlet UILabel *instrLbl, *emailLabel, *thanksLabel;
    
    __weak IBOutlet NSLayoutConstraint *textFieldTop;
}

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UIButton *dismissBtn, *sendBtn;
@property (strong, nonatomic) UIButton *dismissBtn2;
@property (strong, nonatomic) UILabel *instrLbl, *emailLabel, *thanksLabel;
@end
