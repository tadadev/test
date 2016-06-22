//
//  ToastManager.m
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ToastManager.h"
#import "ToastViewController.h"
#import "DataSurrogate.h"

@implementation ToastManager
@synthesize volumeView;
@synthesize delegate;

+ (instancetype)manager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



- (instancetype)init {
    self = [super init];
    if (self) {
//        UIWindow *notificationWindow = [[CRToastWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIWindow *notificationWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        notificationWindow.backgroundColor = [UIColor clearColor];
        notificationWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        notificationWindow.windowLevel = UIWindowLevelStatusBar;
        notificationWindow.windowLevel = UIWindowLevelNormal;

        //notificationWindow.rootViewController = [ToastViewController new];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        notificationWindow.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ToastController"];
        
        notificationWindow.rootViewController.view.clipsToBounds = YES;
        self.notificationWindow = notificationWindow;
//        self.notifications = [@[] mutableCopy];
        
        
        self.noiseLock = NO;
        self.headphoneLock = NO;
    }
    return self;
}




+ (id <ToastDelegate>)delegate{
    return [ToastManager manager].delegate;
}


+ (void)beginToastMonitor{
    [[ToastManager manager] beginMonitor];
}


+ (void)endToastMonitor{
    [[ToastManager manager] endMonitor];
}


+ (void)showDidHear{
    [[ToastManager manager] applyToastAlert:ToastAlertDidHear];
}


+ (void)toastDidHear:(BOOL)ans{
    NSLog(@"Toast Manager Heard");
    [[ToastManager manager] toastDidHear:ans];
}


+ (void)toastEmail{
    [[ToastManager manager] emailToast];
}


+ (void)toastEmailDismiss{
    [[ToastManager manager] emailToastDismiss];
}


+ (void)toastsComplete{
    [[ToastManager manager] removeAllToast];
}






- (void)beginMonitor{
    monitoring = YES;
    
    //Headphones
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChanged) name:AVAudioSessionRouteChangeNotification object:nil];
    
    //Volume
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    

    //Noise & Headpones
    [NoiseManager sharedInstance].delegate = self;
    [[NoiseManager sharedInstance] startMeasuring];
    noiseMonitoring = YES;
    
    [self audioRouteChanged];
}


- (void)endMonitor{
    monitoring = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];

    [[NoiseManager sharedInstance] stopMeasuring];
    [NoiseManager sharedInstance].delegate = nil;
    noiseMonitoring = NO;
}




- (void)applyToastAlert2:(ToastAlert)alert{
    
    ToastViewController *toastVC = (ToastViewController *)_notificationWindow.rootViewController;
    //[toastVC toastAlert:alert];
    
    
    //Noise
    //Headphone
    
    if (!isToasted) {
        NSLog(@"-----applyToastAlert----");
        isToasted = YES;
        _currentAlert = alert;
    
        //Delegate to TestController
        if (alert!= ToastAlertHelpConfirm && delegate && [delegate respondsToSelector:@selector(toastInterupt)])
            [delegate toastInterupt];
        
        //Show Toast Window
        _notificationWindow.hidden = NO;
        
        
        if (_noiseLock)
            [toastVC toastAlert:alert];
        
        else if (_headphoneLock)
            [toastVC toastAlert:alert];

        
    }
    
}
- (void)applyToastOK{

    if (!noisy && plugged) {
        isToasted = NO;

        NSLog(@"All OK, Confirm");
        ToastViewController *toastVC = (ToastViewController *)_notificationWindow.rootViewController;
        [toastVC toastAlert:ToastAlertHelpConfirm];
    }
    
    else {
        if (_noiseLock && _currentAlert!=ToastAlertNoise) {
            isToasted = NO;
            [self applyToastAlert:ToastAlertNoise];
        }
        else if (_headphoneLock && _currentAlert!=ToastAlertHeadphone) {
            isToasted = NO;
            [self applyToastAlert:ToastAlertHeadphone];
        }
    }
    
}




- (void)applyToastAlert:(ToastAlert)alert{
    @synchronized(self){
        [self printAlert:alert];
        
        
        //Alert Currently Show?
        if (!isToasted) {
            //Show Alert
            [self showAlert:alert];
        }
        
        else {
            
            //Is New Alert = Confirm Alert?
            if (alert != ToastAlertNoiseConfirm &&
                alert != ToastAlertHeadphoneConfirm &&
                alert != ToastAlertVolumeConfirm) {
                NSLog(@"--Is NOT a Confirm Alert--");

                //Currently Showing Confirm?
                if (_currentAlert != ToastAlertHelpConfirm) {
                    //tmd added
                    
                    if (_currentAlert != ToastAlertDidHear) {
                        //Flag
                        [self flagAlert:alert];
                    }
                    
                    else {
                        //Flag Current Alert
                        [self flagAlert:_currentAlert];
                        
                        //Show New Alert
                        [self showAlert:alert];
                    }
                    
                }
                else{
                    //Show Alert
                    [self showAlert:alert];
                }
            }
            
            else{
                NSLog(@"--Is a Confrim Alert--");
                //Has Flag?
                if (![self hasAlertFlag]) {
                    //Show Alert
                    [self showAlert:ToastAlertHelpConfirm];
                }
                else {
                    
                    //Is the Confirm Alert for the Currently Showing Alert
                    if (![self isTopMostConfirmAlert:alert]) {
                        //Remove Flag
                        [self removeFlagAlert:alert];
                    }
                    
                    else {
                        //Remove Flag
                        //Alert currently showing = NO
                        //Repost Flagged Alert
                        [self repostFlaggedAlert];
                    }
                }
            }
        }
        
    }
    
}


- (void)printAlert:(ToastAlert)alert{
    /*
    
    NSLog(@"------------------------");
    NSLog(@"------------------------");

    if (alert == ToastAlertNoise) {
        NSLog(@"Alert Noise");
    }
    
    else if (alert == ToastAlertHeadphone) {
        NSLog(@"Alert Headphone");
    }
    
    else if (alert == ToastAlertVolume) {
        NSLog(@"Alert Volume");
    }
    
    else if (alert == ToastAlertHelpConfirm) {
        NSLog(@"Alert Confirm");
    }
    
    else if (alert == ToastAlertNoiseConfirm) {
        NSLog(@"Alert Noise Confirm");
    }
    
    else if (alert == ToastAlertHeadphoneConfirm) {
        NSLog(@"Alert Headphone Confirm");
    }
    
    else if (alert == ToastAlertVolumeConfirm) {
        NSLog(@"Alert Volume Confirm");
    }
    
    else if (alert == ToastAlertDidHear) {
        NSLog(@"Alert Did You Hear");
    }
     
    */
}



- (void)showAlert:(ToastAlert)alert{
    NSLog(@"Show alert");
    //Show Only if not Current Alert
    if (_currentAlert == alert) {
        NSLog(@"return insteaD");
        return;
    }
    
    
    isToasted = YES;
    _currentAlert = alert;
    
    //Delegate to TestController
    if ([self shouldInteruptForAlert:alert] && delegate && [delegate respondsToSelector:@selector(toastInterupt)])
        [delegate toastInterupt];
    
    //Show Toast Window
    _notificationWindow.hidden = NO;
    
    //VC Show Alert
    ToastViewController *toastVC = (ToastViewController *)_notificationWindow.rootViewController;
    [toastVC toastAlert:alert];
}


- (void)repostFlaggedAlert{
    ToastAlert alert;
    if (flag_Noise){
        flag_Noise = NO;
        alert = ToastAlertNoise;
        NSLog(@"---Reposting Noise(Flag)---");
    }
    
    else if (flag_Headphone){
        flag_Headphone = NO;
        alert = ToastAlertHeadphone;
        NSLog(@"---Reposting Headphone(Flag)---");
    }
    
    else if (flag_Volume){
        flag_Volume = NO;
        alert = ToastAlertVolume;
        NSLog(@"---Reposting Volume(Flag)---");
    }
    
    else if (flag_DidHear){
        flag_DidHear = NO;
        alert = ToastAlertDidHear;
        NSLog(@"---Reposting DidHear(Flag)---");
    }
    
    else {
        NSLog(@"Unknown Flag");
    }
    
    isToasted = NO;
    [self applyToastAlert:alert];
}


- (void)flagAlert:(ToastAlert)alert{
    if (alert == ToastAlertNoise) {
        NSLog(@"Flagging Noise");
        flag_Noise = YES;
    }
    
    else if (alert == ToastAlertHeadphone) {
        NSLog(@"Flagging Headphone");
        flag_Headphone = YES;
    }
    
    else if (alert == ToastAlertVolume) {
        NSLog(@"Flagging Volume");
        flag_Volume = YES;
    }
    
    else if (alert == ToastAlertDidHear) {
        NSLog(@"Flagging Did Hear");
        flag_DidHear = YES;
    }
}


- (void)removeFlagAlert:(ToastAlert)confirm{
    if (confirm == ToastAlertNoiseConfirm) {
        NSLog(@"UnFlagging Noise");
        flag_Noise = NO;
    }
    
    else if (confirm == ToastAlertHeadphoneConfirm) {
        NSLog(@"UnFlagging Headphone");
        
        flag_Headphone = NO;
    }
    
    else if (confirm == ToastAlertVolumeConfirm) {
        NSLog(@"UnFlagging Volume");
        
        flag_Volume = NO;
    }
}


- (BOOL)hasAlertFlag{
    if (flag_Noise || flag_Headphone || flag_Volume || flag_DidHear) {
        NSLog(@"Has an Alert Flag");
        return YES;
    }
    
    return NO;
}


- (BOOL)isTopMostConfirmAlert:(ToastAlert)confirm{
    if (_currentAlert == ToastAlertNoise) {
        if (confirm == ToastAlertNoiseConfirm) {
            return YES;
        }
    }
    
    else if (_currentAlert == ToastAlertHeadphone) {
        if (confirm == ToastAlertHeadphoneConfirm) {
            return YES;
        }
    }
    
    else if (_currentAlert == ToastAlertVolume) {
        if (confirm == ToastAlertVolumeConfirm) {
            return YES;
        }
    }
    
    return NO;
}


- (BOOL)shouldInteruptForAlert:(ToastAlert)alert{
    if (alert == ToastAlertNoise || alert == ToastAlertHeadphone || alert == ToastAlertVolume)
        return YES;
    
    return NO;
}








- (void)removeAllToast{
    _notificationWindow.hidden = YES;
    isToasted = NO;
    _currentAlert = 0;
    
    if (delegate && [delegate respondsToSelector:@selector(toastCompleted)]) {
        [delegate toastCompleted];
    }
}

- (void)toastDidHear:(BOOL)ans{
    _notificationWindow.hidden = YES;
    isToasted = NO;
    _currentAlert = 0;
    
    if (delegate && [delegate respondsToSelector:@selector(toastDidHearTone:)]) {
        [delegate toastDidHearTone:ans];
    }
    
}


- (void)emailToast{
    //Show Toast Window
    _notificationWindow.hidden = NO;
    
    //VC Show Email
    ToastViewController *toastVC = (ToastViewController *)_notificationWindow.rootViewController;
    [toastVC applyEmail];
}

- (void)emailToastDismiss{
    _notificationWindow.hidden = YES;
    
}






#pragma mark - NoiseDelegate Methods

- (void)noiseValueUpdated:(float)value{

    //NSLog(@"Noise: %f; Threshold: %f", value, [[DataSurrogate sharedInstance] threshold]);
    //NSLog(@"TakeTestController - Noise: %f", value);
    
    if (value > [[DataSurrogate sharedInstance] threshold])
        noisy = YES;
    else
        noisy = NO;
    
    
    //Noise Meter
    if (_noiseLock) {
        ToastViewController *toastVC = (ToastViewController *)_notificationWindow.rootViewController;
        [toastVC updateNoiseIndicator:value];
    }
    
    
    
    
    if (noisy && !_noiseLock) {
        _noiseLock = YES;
        [self applyToastAlert:ToastAlertNoise];
    }
    
    
    else if (!noisy && _noiseLock) {
        _noiseLock = NO;
        //[self applyToastAlert:ToastAlertHelpConfirm];
        //[self applyToastOK];
        //[self performSelector:@selector(applyToastOK) withObject:nil afterDelay:0.35];
        [self applyToastAlert:ToastAlertNoiseConfirm];
    }
    
}

- (void)noiseValueUpdated2:(float)value{
    
    //NSLog(@"Noise: %f; Threshold: %f", value, [[DataSurrogate sharedInstance] threshold]);
    //NSLog(@"TakeTestController - Noise: %f", value);
    
    
}




# pragma Headphones

- (BOOL)isHeadsetPluggedIn{
    BOOL retval = NO;
    
#if TARGET_IPHONE_SIMULATOR
    retval = YES;
#endif
    
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            retval = YES;
    }
    return retval;
}

- (void)audioRouteChanged2{
    plugged = [self isHeadsetPluggedIn];
    NSLog(@"is headset plugged in? %d", plugged);
    
    if (!plugged && !_headphoneLock) {
        _headphoneLock = YES;
        [self applyToastAlert:ToastAlertHeadphone];
    }
    
    else if (plugged && _headphoneLock) {
        _headphoneLock = NO;
        //[self applyToastOK];
        [self performSelector:@selector(applyToastOK) withObject:nil afterDelay:0.35];

    }
}


- (void)audioRouteChanged{
    [self performSelectorOnMainThread:@selector(audioRouteChangedMain) withObject:nil waitUntilDone:NO];
}

- (void)audioRouteChangedMain{
    plugged = [self isHeadsetPluggedIn];
    NSLog(@"ToastManager: is headset plugged in? %d", plugged);
    
    
    
    
    
    //Headphone Alert
    if (!plugged && !_headphoneLock) {
        _headphoneLock = YES;
        [self applyToastAlert:ToastAlertHeadphone];
    }
    
    else if (plugged && _headphoneLock) {
        _headphoneLock = NO;
        [self applyToastAlert:ToastAlertHeadphoneConfirm];
    }
    
    
    //Remove Noise Lock Alert & Volume Lock Alert (If applicable)
    if (!plugged) {
        if (_noiseLock) {
            //cancel noise lock
            noisy = NO;
            _noiseLock = NO;
            [self applyToastAlert:ToastAlertNoiseConfirm];
        }
        
        if (_volumeLock) {
            //cancel volume lock
            _volumeLock = NO;
            [self applyToastAlert:ToastAlertVolumeConfirm];
        }
    }
    
    
    
    //Monitoring
    if (plugged && monitoring && !noiseMonitoring) {    //Re-enable Noise Monitor
        [[NoiseManager sharedInstance] startMeasuring];
        noiseMonitoring = YES;
    }
    
    else if (!plugged && monitoring && noiseMonitoring) {  //Stop Noise Listener
        [[NoiseManager sharedInstance] stopMeasuring];
        noiseMonitoring = NO;
    }
    
}




#pragma Volume

- (void)volumeChanged:(NSNotification *)note{
    
    
    NSNumber *volumeNum = note.userInfo[VOLUME_PROPERTY];
    //NSLog(@"Toast Manager:Volume: %f", volumeNum.floatValue);
    
    if (volumeNum.floatValue < 1.0f && !_volumeLock) {   //Only care about Volume if Headphone is plugged in
        _volumeLock = YES;
        [self applyToastAlert:ToastAlertVolume];
    }
    
    else if (volumeNum.floatValue == 1.0f && _volumeLock) {
        _volumeLock = NO;
        [self applyToastAlert:ToastAlertVolumeConfirm];
    }
    
}





/* *************  TESTING ******************** */

+ (void)startToast {
    [[ToastManager manager] testToast];
}

- (void)testToast{
    _notificationWindow.hidden = NO;

    
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 50)];
    //view.backgroundColor = [UIColor orangeColor];
    //[_notificationWindow.rootViewController.view addSubview:view];

}

+ (void)endToasts {
    //[[ToastManager manager] removeAllToast];
}






+ (void)simulateNoise{
    [[ToastManager manager] applyToastAlert:ToastAlertNoise];
}

+ (void)simulateHeadphones{
    [[ToastManager manager] applyToastAlert:ToastAlertHeadphone];
}

+ (void)simulateVolume{
    [[ToastManager manager] applyToastAlert:ToastAlertVolume];
}

+ (void)simulateDidHear{
    [[ToastManager manager] applyToastAlert:ToastAlertDidHear];
}

+ (void)simulateThanks{
    [[ToastManager manager] applyToastAlert:ToastAlertHelpConfirm];
}




- (void)attemptTestPause{
    
    if (delegate && [delegate respondsToSelector:@selector(sendPause)]) {
        [delegate sendPause];
    }
}

- (void)attemptTestResume{
    if (delegate && [delegate respondsToSelector:@selector(sendResume)]) {
        [delegate sendResume];
    }
}









@end
