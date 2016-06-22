//
//  ToastViewController.h
//  AHT
//
//  Created by Troy DeMar on 2/25/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToastManager.h"
#import "EmailCaptureView.h"
#import "EmailConfirmationView.h"
#import "ErrorView.h"
#import <ChimpKit/ChimpKit.h>
#import "iRate.h"

@interface ToastViewController : UIViewController<UITextFieldDelegate, ChimpKitRequestDelegate, iRateDelegate> {
    IBOutlet UIView *accessoryView;
    IBOutlet UITextField *textField;


    UIView *bgView;
    UIView *toastContainer;
    UIView *currentToast, *nextToast;
    
    EmailCaptureView *emailView;
    EmailConfirmationView *emailConfmView;
    ErrorView *errView;
    
    //NoiseToastView *noiseView;
    
    BOOL isVisible, isTransitioning, isAnimatingOff;
}

- (void)toastAlert:(ToastAlert)alert;
- (void)updateNoiseIndicator:(float)value;
- (void)applyEmail;


@property (strong, nonatomic) UIView *accessoryView;
@property (strong, nonatomic) UITextField *textField;

@property (nonatomic) ToastAlert currentAlert;

@end
