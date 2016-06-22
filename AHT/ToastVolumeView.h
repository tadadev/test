//
//  ToastVolumeView.h
//  AHT
//
//  Created by Troy DeMar on 2/26/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Borders.h"

@interface ToastVolumeView : UIView {
    IBOutlet UIView *view;
    IBOutlet UILabel *headerLbl, *volumeLbl, *fixLbl;
    IBOutlet UITextView *descTextView;
    
    UISlider *volumeSlider, *volumeViewSlider;
}

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UILabel *headerLbl, *volumeLbl, *fixLbl;
@property (strong, nonatomic) UITextView *descTextView;

@property (strong, nonatomic) UISlider *volumeSlider, *volumeViewSlider;


@end
