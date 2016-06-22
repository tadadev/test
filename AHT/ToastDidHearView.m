//
//  ToastDidHearView.m
//  AHT
//
//  Created by Troy DeMar on 3/3/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ToastDidHearView.h"

@implementation ToastDidHearView
@synthesize view, headerLbl, descTextView, fixLbl;
@synthesize noBtn, yesBtn;

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
        [[NSBundle mainBundle] loadNibNamed:@"ToastDidHearView" owner:self options:nil];
        self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.view];
        
        self.userInteractionEnabled = YES;
        //        self.accessibilityLabel = NSStringFromClass([self class]);
        //        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        
        [fixLbl addBottomBorderWithHeight:1.0 andColor:[UIColor colorWithRed:176/255.0f green:176/255.0f blue:176/255.0f alpha:1]];
        
        
        headerLbl.userInteractionEnabled = NO;
        headerLbl.text = TOAST_DIDHEAR_H;
        headerLbl.textAlignment = NSTextAlignmentCenter;
//        headerLbl.font = [UIFont fontWithName:@"GTWalsheim-Bold" size:28];
        
        
        descTextView.editable = NO;
        descTextView.text = TOAST_DIDHEAR_D;
        descTextView.textAlignment = NSTextAlignmentCenter;
        descTextView.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
        
        
        /*
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 80)];
        textView.userInteractionEnabled = NO;
        textView.editable = NO;
        textView.text = @"Hmm we didn't feel a tap\n\nDid you hear a tone?";
        textView.textAlignment = NSTextAlignmentCenter;
        //textView.font = [UIFont systemFontOfSize:14.0];
        textView.font = [UIFont boldSystemFontOfSize:14.0];
        [self addSubview:textView];
        */
        
        
        CGFloat bWidth = 140;
        CGFloat bHeight = 75;
        CGFloat bSpace = 2;
        CGFloat leftOver = frame.size.width - (bWidth*2) - bSpace;
        CGFloat y = frame.size.height - bHeight - 20;

        
        noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        noBtn.tag = 0;
        [noBtn setFrame:CGRectMake(leftOver/2, y, bWidth, bHeight)];
        [noBtn setTitle:@"No" forState:UIControlStateNormal];
        noBtn.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:20];
        [noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [noBtn setBackgroundColor:[UIColor whiteColor]];
        noBtn.layer.borderWidth = 1.0f;
        noBtn.layer.borderColor = [UIColor grayColor].CGColor;
        noBtn.layer.cornerRadius = 4.0f;
        [self addSubview:noBtn];
        
        
        CGFloat x2 = leftOver/2 + noBtn.frame.size.width + bSpace;
        
        yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yesBtn.tag = 1;
        [yesBtn setFrame:CGRectMake(x2, y, bWidth, bHeight)];
        [yesBtn setTitle:@"Yes" forState:UIControlStateNormal];
        yesBtn.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:20];
        [yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [yesBtn setBackgroundColor:[UIColor whiteColor]];
        yesBtn.layer.borderWidth = 1.0f;
        yesBtn.layer.borderColor = [UIColor grayColor].CGColor;
        yesBtn.layer.cornerRadius = 4.0f;
        [self addSubview:yesBtn];
        
    }
    return self;
}
@end
