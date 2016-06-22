//
//  ErrorView.h
//  AHT
//
//  Created by Troy DeMar on 3/10/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorView : UIView {
    IBOutlet UIView *view;
    IBOutlet UITextView *textView;
    IBOutlet UIButton *closeBtn;
}

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *closeBtn;

@end
