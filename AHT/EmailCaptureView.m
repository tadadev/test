//
//  EmailCaptureView.m
//  AHT
//
//  Created by Troy DeMar on 3/9/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "EmailCaptureView.h"

@implementation EmailCaptureView
@synthesize view, textView, emailTextField, dismissBtn, sendBtn;
@synthesize dismissBtn2, instrLbl, emailLabel, thanksLabel;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //Initialization Code
        //NSLog(@"Frame");
        [[NSBundle mainBundle] loadNibNamed:@"EmailCaptureView" owner:self options:nil];
        self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.view];
        
        textView.text = EMAIL_TEXT;
        
        sendBtn.layer.cornerRadius = 5.0f;
        sendBtn.layer.borderWidth = 1.0f;
        sendBtn.layer.borderColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0].CGColor;
        //sendBtn.layer.borderColor = [UIColor darkGrayColor]
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        
        if (screenHeight < 500.0f) {//480
            textFieldTop.constant = 20;
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Initialization Code

        //NSLog(@"Coder");
        
        
    }
    return self;
}



#pragma mark - IBAction Methods



@end
