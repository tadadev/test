//
//  TestViewController.h
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ToastManager.h"
#import "KAProgressLabel.h"
#import "AHT-Swift.h"
#import "GAITrackedViewController.h"
#import "iRate.h"

@interface TestViewController : GAITrackedViewController <ToastDelegate, AVAudioPlayerDelegate, iRateDelegate>{
//@interface TestViewController : UIViewController <ToastDelegate, AVAudioPlayerDelegate>{
    IBOutlet UITextView *textView;
    IBOutlet UIImageView *doneImageView;
    IBOutlet UIView *containerView;
    IBOutlet UIButton *didYouHearButton;
    IBOutlet UILabel *headerLbl, *countdownLbl, *successLbl;
    IBOutlet UILabel *didYouHearLabel;
    IBOutlet UILabel *progressLabel;
    IBOutlet CircleProgressView *circleProgress;
    
    //KAProgressLabel *circleProgress;
    
    float noiseLevel;
    
    BOOL isToastVisible;
    
    
    CFTimeInterval delayStart, delayEnd;

    
}

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *doneImageView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIButton *didYouHearButton;
@property (strong, nonatomic) UILabel *headerLbl, *countdownLbl, *successLbl;
@property (strong, nonatomic) UILabel *didYouHearLabel;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) CircleProgressView *circleProgress;


@property (nonatomic, assign) TestStep testStep;

@property (nonatomic, assign) BOOL isSampleTone;


@end
