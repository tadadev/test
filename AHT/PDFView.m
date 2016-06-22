//
//  PDFView.m
//  AHT
//
//  Created by Troy DeMar on 4/23/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "PDFView.h"

@implementation PDFView
@synthesize view, dateLabel, lowFreq, middleFreq, highFreq;
@synthesize lowResults, midResults, highResults;
@synthesize lowLeft, lowRight, lowLeftPct, lowRightPct;
@synthesize midLeft, midRight, midLeftPct, midRightPct;
@synthesize highLeft, highRight, highLeftPct, highRightPct;
@synthesize lowDetail, midDetail, highDetail;
@synthesize contactView, disclaimerLbl;

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
        //NSLog(@"Called");
        [[NSBundle mainBundle] loadNibNamed:@"PDFView" owner:self options:nil];
        self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.view];
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];

        
    }
        
    return self;
}


@end
