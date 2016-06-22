//
//  ListTableViewCell.h
//  AHT
//
//  Created by Troy DeMar on 3/7/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNCircleChart.h"

@interface ListTableViewCell : UITableViewCell {
    IBOutlet UILabel *dateLabel, *timeLabel;
    
    PNCircleChart *highChartL, *highChartR, *midChartL, *midChartR, *lowChartL, *lowChartR;
    UILabel *highLabel, *midLabel, *lowLabel;
}

@property (strong, nonatomic) UILabel *dateLabel, *timeLabel;
@property (strong, nonatomic) PNCircleChart *highChartL, *highChartR, *midChartL, *midChartR, *lowChartL, *lowChartR;


- (void)resizeViewMethod;

@end
