//
//  ResultsTableViewCell.h
//  AHT
//
//  Created by Troy DeMar on 3/6/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBBarChartView.h"

@interface ResultsTableViewCell : UITableViewCell {
    IBOutlet UILabel *freqLabel, *leftEarLabel, *rightEarLabel, *scoreLabel;
    
    IBOutlet JBBarChartView *chart;
}

@property (strong, nonatomic) UILabel *freqLabel, *leftEarLabel, *rightEarLabel, *scoreLabel;

@property (strong, nonatomic) JBBarChartView *chart;
@end
