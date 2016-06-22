//
//  ErrorView.m
//  AHT
//
//  Created by Troy DeMar on 3/10/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ErrorView.h"

@implementation ErrorView
@synthesize view, textView, closeBtn;

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
        [[NSBundle mainBundle] loadNibNamed:@"ErrorView" owner:self options:nil];
        [self addSubview:self.view];
        
        self.view.layer.cornerRadius = 5.0f;

        
        //textView.text = EMAIL_CONFIRMATION;
        
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
