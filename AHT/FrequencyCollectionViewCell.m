//
//  FrequencyCollectionViewCell.m
//  AHT
//
//  Created by Troy DeMar on 3/15/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "FrequencyCollectionViewCell.h"

@implementation FrequencyCollectionViewCell
@synthesize scrollView, view, lineView, leftLabel, rightLabel;
@synthesize textView;
@synthesize chartL, chartR;


- (void)awakeFromNib{
//    NSLog(@"awakeFromNib");
//    NSLog(@"awakeFromNib Width: %f", self.frame.size.width);
    
//    CGFloat width = self.frame.size.width;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    

    
    
    UIColor *topColor = [UIColor colorWithRed:238/255.0f green:141/255.0f blue:34/255.0f alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:255/255.0f green:205/255.0f blue:0/255.0f alpha:1];

    chartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 75, 320, 280) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:20]];
    chartL.backgroundColor = [UIColor clearColor];
    [chartL setStrokeColor:topColor];
    [chartL strokeChart];
    [self.scrollView addSubview:chartL];

    
    chartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 100, 320, 230) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:20]];
    chartR.backgroundColor = [UIColor clearColor];
    [chartR setStrokeColor:bottomColor];
    [chartR strokeChart];
    [self.scrollView addSubview:chartR];

    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 400, 300, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:176/255.0f green:176/255.0f blue:176/255.0f alpha:1];
    [self.scrollView addSubview:lineView];
    
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, lineView.frame.origin.y + 11, 300, 140)];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.text = TOAST_NOISE_D;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
    textView.textColor = [UIColor darkGrayColor];
    textView.scrollEnabled = NO;
    [self.scrollView addSubview:textView];
    
}

/*
- (id)initWithFrame:(CGRect)frame {
    if (self) {
        // Initialization code
        NSLog(@"Cell Init");
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FrequencyCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        
        
    }
    
    return self;
}
*/


- (id)initWithCoder:(NSCoder *)decoder{
    NSLog(@"initWithCoder");
    self = [super initWithCoder:decoder];
    if (self) {
        // Initialization code
//        NSLog(@"Cell Init");
//        NSLog(@"Width: %f", self.frame.size.width);
//        
//        UIColor *topColor = [UIColor colorWithRed:238/255.0f green:141/255.0f blue:34/255.0f alpha:1];
//        UIColor *bottomColor = [UIColor colorWithRed:255/255.0f green:205/255.0f blue:0/255.0f alpha:1];
//
//        
//        chartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 75, 320, 280) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:20]];
//
//        chartL = [[PNCircleChart alloc] initWithFrame:CGRectZero total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:20]];
//        
//        chartL.backgroundColor = [UIColor clearColor];
//        [chartL setStrokeColor:topColor];
//        [chartL strokeChart];
//        [self.scrollView addSubview:chartL];
//
//        chartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 100, 320, 230) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:20]];
//        chartR.backgroundColor = [UIColor clearColor];
//        [chartR setStrokeColor:bottomColor];
//        [chartR strokeChart];
//        [self addSubview:chartR];
//
//        
    }
    return self;
}



- (NSAttributedString *)attribTextForComment:(NSString *)aComment{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSAttributedString *attribText = [[NSAttributedString alloc] initWithString:aComment
                                                                     attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                                                                  NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:18],
                                                                                  NSParagraphStyleAttributeName: paragraphStyle}];
    
    
    return attribText;
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    
    
    //NSLog(@"Text: %@; Height: %f", text.string, size.height);
    return size.height;
}



- (void)resizeScrollViewMethod{
//    NSLog(@"resizeScrollViewMethod Width: %f", self.frame.size.width);
    
//    self.view.frame = CGRectMake(0, 0, self.frame.size.width, 600);

    CGFloat width = self.frame.size.width;
    CGFloat graphWidth = 320;


    chartL.frame = CGRectMake(width/2 - graphWidth/2, chartL.frame.origin.y, graphWidth, chartL.frame.size.height);
    chartR.frame = CGRectMake(width/2 - graphWidth/2, chartR.frame.origin.y, graphWidth, chartR.frame.size.height);
    
    lineView.frame = CGRectMake(10, lineView.frame.origin.y, width-20, lineView.frame.size.height);
    
    //textView.frame = CGRectMake(10, textView.frame.origin.y, width-20, textView.frame.size.height);
    textView.frame = CGRectMake(10, textView.frame.origin.y, width-20, [self textViewHeightForAttributedText:[self attribTextForComment:textView.text] andWidth:width-20]);

    
    self.scrollView.contentSize = CGSizeMake(width, textView.frame.origin.y + textView.frame.size.height + 5);
}

@end
