//
//  EmailConfirmationView.h
//  AHT
//
//  Created by Troy DeMar on 3/9/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailConfirmationView : UIView {
    IBOutlet UIView *view;
    IBOutlet UITextView *textView;
    IBOutlet UIButton *dismissBtn;

}

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *dismissBtn;

@end
