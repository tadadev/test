//
//  SummaryCollectionViewCell.m
//  AHT
//
//  Created by Troy DeMar on 3/15/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "SummaryCollectionViewCell.h"

@implementation SummaryCollectionViewCell
@synthesize scrollView, view, dateLabel, scoreLabel, textView;


- (void)awakeFromNib{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)resizeScrollViewMethod {
    //Do your scrollview size calculation here
//    NSLog(@"Width: %f", self.frame.size.width);
    
    self.view.frame = CGRectMake(0, 0, self.frame.size.width, 600);
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, 600);
    
}

@end
