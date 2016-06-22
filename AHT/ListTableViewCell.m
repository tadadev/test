//
//  ListTableViewCell.m
//  AHT
//
//  Created by Troy DeMar on 3/7/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell
@synthesize dateLabel, timeLabel;
@synthesize highChartL, highChartR, midChartL, midChartR, lowChartL, lowChartR;

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"Adding Charts");
    UIColor *topColor = [UIColor colorWithRed:238/255.0f green:141/255.0f blue:34/255.0f alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:255/255.0f green:205/255.0f blue:0/255.0f alpha:1];
    
    NSLog(@"Width: %f", self.frame.size.width);

    
    highChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(20, 70, 90, 90) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    highChartL.backgroundColor = [UIColor clearColor];
    [highChartL setStrokeColor:topColor];
    [highChartL strokeChart];
    [self addSubview:highChartL];
    
    highChartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(20, 85, 90, 60) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    highChartR.backgroundColor = [UIColor clearColor];
    [highChartR setStrokeColor:bottomColor];
    [highChartR strokeChart];
    [self addSubview:highChartR];
    
    highLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.5, 105, 20, 20)];
    highLabel.textAlignment = NSTextAlignmentCenter;
    highLabel.text = @"H";
    highLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:18];
    [self addSubview:highLabel];
    
    
    
    midChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(120, 70, 90, 90) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    midChartL.backgroundColor = [UIColor clearColor];
    [midChartL setStrokeColor:topColor];
    [midChartL strokeChart];
    [self addSubview:midChartL];
    
    midChartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(120, 85, 90, 60) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    midChartR.backgroundColor = [UIColor clearColor];
    [midChartR setStrokeColor:bottomColor];
    [midChartR strokeChart];
    [self addSubview:midChartR];
    
    midLabel = [[UILabel alloc] initWithFrame:CGRectMake(155.5, 105, 20, 20)];
    midLabel.textAlignment = NSTextAlignmentCenter;
    midLabel.text = @"M";
    midLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:18];
    [self addSubview:midLabel];
    
    
    
    lowChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(220, 70, 90, 90) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    lowChartL.backgroundColor = [UIColor clearColor];
    [lowChartL setStrokeColor:topColor];
    [lowChartL strokeChart];
    [self addSubview:lowChartL];
    
    lowChartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(220, 85, 90, 60) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    lowChartR.backgroundColor = [UIColor clearColor];
    [lowChartR setStrokeColor:bottomColor];
    [lowChartR strokeChart];
    [self addSubview:lowChartR];
    
    lowLabel = [[UILabel alloc] initWithFrame:CGRectMake(255.5, 105, 20, 20)];
    lowLabel.textAlignment = NSTextAlignmentCenter;
    lowLabel.text = @"L";
    lowLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:18];
    [self addSubview:lowLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)resizeViewMethod {
    CGFloat width = self.frame.size.width;

    //Middle
    midChartL.frame = CGRectMake(width/2 - midChartL.frame.size.height/2, midChartL.frame.origin.y, midChartL.frame.size.width, midChartL.frame.size.height);
    midChartR.frame = CGRectMake(midChartL.frame.origin.x, midChartR.frame.origin.y, midChartR.frame.size.width, midChartR.frame.size.height);
    midLabel.frame = CGRectMake(midChartL.frame.origin.x+35.5, midLabel.frame.origin.y, midLabel.frame.size.width, midLabel.frame.size.height);

    //Left
    highChartL.frame = CGRectMake(midChartL.frame.origin.x-100, highChartL.frame.origin.y, highChartL.frame.size.width, highChartL.frame.size.height);
    highChartR.frame = CGRectMake(highChartL.frame.origin.x, highChartR.frame.origin.y, highChartR.frame.size.width, highChartR.frame.size.height);
    highLabel.frame = CGRectMake(highChartL.frame.origin.x+35.5, highLabel.frame.origin.y, highLabel.frame.size.width, highLabel.frame.size.height);

    
    //Rigth
    lowChartL.frame = CGRectMake(midChartL.frame.origin.x+100, lowChartL.frame.origin.y, lowChartL.frame.size.width, lowChartL.frame.size.height);
    lowChartR.frame = CGRectMake(lowChartL.frame.origin.x, lowChartR.frame.origin.y, lowChartR.frame.size.width, lowChartR.frame.size.height);
    lowLabel.frame = CGRectMake(lowChartL.frame.origin.x+35.5, lowLabel.frame.origin.y, lowLabel.frame.size.width, lowLabel.frame.size.height);
    
}



@end
