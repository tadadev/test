//
//  PDFView.h
//  AHT
//
//  Created by Troy DeMar on 4/23/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFView : UIView {
    IBOutlet UIView *view;
    IBOutlet UILabel *dateLabel, *lowFreq, *middleFreq, *highFreq;
    IBOutlet UILabel *lowResults, *midResults, *highResults;
    IBOutlet UILabel *lowLeft, *lowRight, *lowLeftPct, *lowRightPct;
    IBOutlet UILabel *midLeft, *midRight, *midLeftPct, *midRightPct;
    IBOutlet UILabel *highLeft, *highRight, *highLeftPct, *highRightPct;
    IBOutlet UILabel *lowDetail, *midDetail, *highDetail;
    IBOutlet UIView *contactView;
    IBOutlet UILabel *disclaimerLbl;

}
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UILabel *dateLabel, *lowFreq, *middleFreq, *highFreq;
@property (strong, nonatomic) UILabel *lowResults, *midResults, *highResults;
@property (strong, nonatomic) UILabel *lowLeft, *lowRight, *lowLeftPct, *lowRightPct;
@property (strong, nonatomic) UILabel *midLeft, *midRight, *midLeftPct, *midRightPct;
@property (strong, nonatomic) UILabel *highLeft, *highRight, *highLeftPct, *highRightPct;
@property (strong, nonatomic) UILabel *lowDetail, *midDetail, *highDetail;
@property (strong, nonatomic) UIView *contactView;
@property (strong, nonatomic) UILabel *disclaimerLbl;

@end
