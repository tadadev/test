//
//  FrequencyCollectionViewCell.h
//  AHT
//
//  Created by Troy DeMar on 3/15/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNCircleChart.h"

@interface FrequencyCollectionViewCell : UICollectionViewCell {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *view, *lineView;
    IBOutlet UILabel *leftLabel, *rightLabel;
    IBOutlet UITextView *textView;
    
    PNCircleChart *chartL, *chartR;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *view, *lineView;
@property (strong, nonatomic) UILabel *leftLabel, *rightLabel;
@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) PNCircleChart *chartL, *chartR;


- (void)resizeScrollViewMethod;

@end
