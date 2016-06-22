//
//  ResultsTableViewCell.m
//  AHT
//
//  Created by Troy DeMar on 3/6/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ResultsTableViewCell.h"


@implementation ResultsTableViewCell
@synthesize freqLabel, leftEarLabel, rightEarLabel, scoreLabel;

@synthesize chart;

- (void)awakeFromNib {
    // Initialization code
    
    /*
    chart = [[JBBarChartView alloc] init];
    chart.frame = CGRectMake(140, 45, 70, 300);
    chart.minimumValue = 0.0f;
//    chart.dataSource = self;
//    chart.delegate = self;
    chart.backgroundColor = [UIColor darkGrayColor];
//    [self.contentView addSubview:chart];
    [self.contentView insertSubview:chart atIndex:0];
    
//    [barChartView reloadData];
    chart.transform = CGAffineTransformMakeRotation(3.14/2);
    
    CGAffineTransform rotateTransform = CGAffineTransformIdentity;
    rotateTransform = CGAffineTransformRotate(rotateTransform, M_PI_2);
//    chart.transform = rotateTransform;
    
    
//    swingTransform = CGAffineTransformRotate(swingTransform, DegreesToRadians(90));
     
    */
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
