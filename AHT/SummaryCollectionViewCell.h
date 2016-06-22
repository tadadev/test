//
//  SummaryCollectionViewCell.h
//  AHT
//
//  Created by Troy DeMar on 3/15/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryCollectionViewCell : UICollectionViewCell {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *view;
    IBOutlet UILabel *dateLabel, *scoreLabel;
    IBOutlet UITextView *textView;

    BOOL sizeSet;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UILabel *dateLabel, *scoreLabel;
@property (strong, nonatomic) UITextView *textView;

- (void)resizeScrollViewMethod;


@end
