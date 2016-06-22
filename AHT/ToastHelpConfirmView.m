//
//  ToastHelpConfirmView.m
//  AHT
//
//  Created by Troy DeMar on 2/26/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ToastHelpConfirmView.h"

@implementation ToastHelpConfirmView
@synthesize view, headerLbl, descTextView, dismissBtn;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ToastHelpConfirmView" owner:self options:nil];
        self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.view];

        NSLog(@"Width: %f", frame.size.width);
        
        self.userInteractionEnabled = YES;
        //        self.accessibilityLabel = NSStringFromClass([self class]);
        //        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        
//        UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 30)];
        headerLbl.userInteractionEnabled = NO;
        headerLbl.text = TOAST_THANKS_H;
        headerLbl.textAlignment = NSTextAlignmentCenter;
        headerLbl.font = [UIFont fontWithName:@"GTWalsheim-Bold" size:24];

//        [self addSubview:headerLbl];
        
        
//        UITextView *descTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, frame.size.width-(20*2), 60)];
        descTextView.editable = NO;
        descTextView.text = TOAST_THANKS_D;
        descTextView.textAlignment = NSTextAlignmentCenter;
        descTextView.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
//        [self addSubview:descTextView];
        
        
        dismissBtn.layer.borderWidth = 1.0f;
        dismissBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        dismissBtn.layer.cornerRadius = 3.0f;
        
    }
    return self;
}

@end
