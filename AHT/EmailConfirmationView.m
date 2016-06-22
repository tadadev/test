//
//  EmailConfirmationView.m
//  AHT
//
//  Created by Troy DeMar on 3/9/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "EmailConfirmationView.h"

@implementation EmailConfirmationView
@synthesize view, textView, dismissBtn;

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
        [[NSBundle mainBundle] loadNibNamed:@"EmailConfirmationView" owner:self options:nil];
        [self addSubview:self.view];
        
        textView.text = EMAIL_CONFIRMATION;
        
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


@end
