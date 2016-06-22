//
//  ToastManager.h
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NoiseManager.h"


@protocol ToastDelegate <NSObject>
@optional
- (void)toastInterupt;
- (void)toastCompleted;
- (void)toastDidHearTone:(BOOL)answer;
- (void)noiseValue:(float)value;
- (void)sendPause;
- (void)sendResume;
@end


@interface ToastManager : NSObject <NoiseDelegate> {
    BOOL monitoring, noiseMonitoring;
    BOOL isToasted;
    BOOL noisy, plugged;
    //--------------------
    
    BOOL flag_Noise, flag_Headphone, flag_Volume, flag_DidHear;
}

@property (nonatomic, strong) UIWindow *notificationWindow;
@property (nonatomic) ToastAlert currentAlert;

@property (nonatomic) BOOL noiseLock, headphoneLock, volumeLock;

@property (nonatomic, strong) MPVolumeView *volumeView;
@property (assign) id <ToastDelegate> delegate;

+ (instancetype)manager;

+ (id <ToastDelegate>)delegate;
+ (void)beginToastMonitor;
+ (void)endToastMonitor;
+ (void)showDidHear;
+ (void)toastDidHear:(BOOL)ans;
+ (void)toastEmail;
+ (void)toastEmailDismiss;
+ (void)toastsComplete;


// ----------------- TESTING ----------------
+ (void)startToast;
+ (void)endToasts;

+ (void)simulateNoise;
+ (void)simulateHeadphones;
+ (void)simulateVolume;
+ (void)simulateDidHear;
+ (void)simulateThanks;

- (void)attemptTestPause;
- (void)attemptTestResume;

//- (void)emailToast;

@end
