//
//  PDFViewController.h
//  AHT
//
//  Created by Troy DeMar on 4/15/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController {
    IBOutlet UIView *leftView, *rightView;
    IBOutlet UILabel *dateLabel;
}

@property (strong, nonatomic) UIView *leftView, *rightView;
@property (strong, nonatomic) UILabel *dateLabel;
@end
