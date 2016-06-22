//
//  ToastViewController.m
//  AHT
//
//  Created by Troy DeMar on 2/25/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ToastViewController.h"
#import "Reachability.h"
#import "DataSurrogate.h"
#import "ToastNoiseView.h"
#import "ToastHeadphoneView.h"
#import "ToastVolumeView.h"
#import "ToastHelpConfirmView.h"
#import "ToastDidHearView.h"
#import "EmailManager.h"
#import "OMPromise.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "NSDate-Utilities.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <CreateSend/CreateSend.h>


const CGFloat toastHeight = 280;


@interface ToastViewController ()

@end

@implementation ToastViewController
@synthesize accessoryView, textField;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //iRate Delegate
    [iRate sharedInstance].delegate = self;
    
    
    
    //NSLog(@"Toast ViewController DidLoad");
    //NSLog(@"Size: %f x %f", self.view.frame.size.width, self.view.frame.size.height);
    
    //Set View as keyboard accessory
    //textField.inputAccessoryView = self.accessoryView;
    //textField.inputView = accessoryView;
    
    
    emailView = [[EmailCaptureView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [emailView.dismissBtn addTarget:self action:@selector(emailDismiss:) forControlEvents:UIControlEventTouchUpInside];
    [emailView.dismissBtn2 addTarget:self action:@selector(emailDismiss:) forControlEvents:UIControlEventTouchUpInside];
    [emailView.sendBtn addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    emailView.emailTextField.delegate = self;
    emailView.hidden = YES;
    [self.view addSubview:emailView];
//    textField.inputAccessoryView = emailView;
    
    
    //ToastNoiseView *v = [[ToastNoiseView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    //textField.inputAccessoryView = v;
    
    
    
    [self initialSetup];
    //[self testPane];
}


- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setActive:YES error:nil];
    [audioSession addObserver:self
                   forKeyPath:@"outputVolume"
                      options:0
                      context:nil];
}


- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setActive:YES error:nil];
    [audioSession addObserver:self
                   forKeyPath:@"outputVolume"
                      options:0
                      context:nil];
}



- (void)initialSetup{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;

    //Background View
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    bgView.backgroundColor = [UIColor darkGrayColor];
    bgView.alpha = 0.7;
    [self.view insertSubview:bgView atIndex:0];
    [self.view addSubview:bgView];

    
    //Toast Container
    toastContainer = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, toastHeight)];
    toastContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toastContainer];
    

    //Noise Toast View
//    noiseView = [[NoiseToastView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
//    [toastContainer addSubview:noiseView];
    
    
//    //ToasView
//    CGFloat toastHeight = 250;
//    UIView *toastView = [[UIView alloc] initWithFrame:CGRectMake(0, height-toastHeight, width, toastHeight)];
//    toastView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:toastView];

    
    

}


- (void)displayError:(NSString *)msg{
    [textField becomeFirstResponder];
    [textField resignFirstResponder];
    
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
//    CGFloat width = emailView.frame.size.width;
//    CGFloat height = emailView.frame.size.height;
    CGFloat w = 260;
    CGFloat h = 165;
    
    errView = [[ErrorView alloc] initWithFrame:CGRectMake(width/2 - w/2, height/2 - h/2, w, h)];
    [errView.closeBtn addTarget:self action:@selector(closeError:) forControlEvents:UIControlEventTouchUpInside];
    errView.textView.text = msg;
    
    errView.alpha = 0;
    [self.view addSubview:errView];
    
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        errView.alpha = 1;
        
    } completion:nil];
    
}





/* ************* TEST **************** */
- (void)testPane{
    //TestPane
    CGFloat width = self.view.frame.size.width;

    UIView *testPane = [[UIView alloc] initWithFrame:CGRectMake(0, 250, width, 50)];
    testPane.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:testPane];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(5, 10, 50, 30);
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 setTitle:@"Noise" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(noiseAlert) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(65, 10, 80, 30);
    btn2.backgroundColor = [UIColor whiteColor];
    [btn2 setTitle:@"Headphone" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(headphoneAlert) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn3.frame = CGRectMake(155, 10, 60, 30);
    btn3.backgroundColor = [UIColor whiteColor];
    [btn3 setTitle:@"Volume" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(volumeAlert) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn3];
    
    
    
    UIButton *btnX = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnX.frame = CGRectMake(225, 10, 20, 30);
    btnX.backgroundColor = [UIColor whiteColor];
    [btnX setTitle:@"X" forState:UIControlStateNormal];
    [btnX addTarget:self action:@selector(cancelAlert) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btnX];
    
    
    UIButton *btnR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnR.frame = CGRectMake(255, 10, 20, 30);
    btnR.backgroundColor = [UIColor whiteColor];
    [btnR setTitle:@"R" forState:UIControlStateNormal];
    //[btnR addTarget:self action:@selector(redoAlert) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btnR];
    
}

- (void)noiseAlert{
    [self toastAlert:ToastAlertNoise];
}

- (void)headphoneAlert{
    [self toastAlert:ToastAlertHeadphone];
}

- (void)volumeAlert{
    [self toastAlert:ToastAlertVolume];
}

- (void)cancelAlert{
    [self toastAlert:ToastAlertHelpConfirm];
}

- (void)redoAlert{
    //Stop Dismisal
    NSLog(@"Stop Animation");
    [toastContainer.layer removeAllAnimations];
    
    //Post Alert
    SEL sel = @selector(toastAlert:);
    ToastAlert t = ToastAlertNoise;
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:sel]];
    [inv setSelector:sel];
    [inv setTarget:self];
    
    [inv setArgument:&t atIndex:2];
    [inv performSelector:@selector(invoke) withObject:nil afterDelay:0.1];
    
}

/* ************************************ */


/*
- (BOOL)shouldDismissToast{
    //If Currently Shown Alert != Confirm THEN NO
    if (_currentAlert == ToastAlertNoise ||
        _currentAlert == ToastAlertHeadphone ||
        _currentAlert == ToastAlertVolume) {
        NSLog(@"Should Dismiss NO");
        return NO;
    }
    
    NSLog(@"Should Dismiss YES");
    return YES;
}


- (void)dismissToast{
    if (![self shouldDismissToast] && !isAnimatingOff)
        return;
    
    NSLog(@"VC: Dismiss Toast");
    isAnimatingOff = YES;
    
    CGFloat height = self.view.frame.size.height;
    CGRect newRect = CGRectMake(0, height, toastContainer.frame.size.width, toastContainer.frame.size.height);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        toastContainer.frame = newRect;
    } completion:^(BOOL finished) {
        isVisible = NO;
        isAnimatingOff = NO;
        _currentAlert = 0;
        
        [currentToast removeFromSuperview];
        currentToast = nil;
        
        if (finished)
            [ToastManager toastsComplete];
        else
            NSLog(@"Animation Did Not Finish");
    }];
    
    

}



- (void)toastAlert:(ToastAlert)alert{
    //Check if Animating Off
    if (isTransitioning || isAnimatingOff) {
        NSLog(@"Animating Off");
        
        //Stop Animation
        [toastContainer.layer removeAllAnimations];
        
        //Post Alert
        SEL sel = @selector(applyToastAlert:);
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:sel]];
        [inv setSelector:sel];
        [inv setTarget:self];
        [inv setArgument:&alert atIndex:2];
        [inv performSelector:@selector(invoke) withObject:nil afterDelay:0.1];
    }
    
    else {
        NSLog(@"Not Animating On");

        [self applyToastAlert:alert];
    }
}


- (void)applyToastAlert:(ToastAlert)alert{
    
    [self printAlert:alert];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;

    if (!isVisible) {
        isVisible = YES;
        _currentAlert = alert;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ToastVolumeView *volumeToast;
            ToastDidHearView *didHearToast;
            
            //Set Toast Alert View
            switch (alert) {
                case ToastAlertNoise:
                    currentToast = [[ToastNoiseView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
                    [toastContainer addSubview:currentToast];
                    break;
                    
                    
                case ToastAlertHeadphone:
                    currentToast = [[ToastHeadphoneView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
                    [toastContainer addSubview:currentToast];
                    break;
                    
                    
                case ToastAlertVolume:
                    volumeToast = [[ToastVolumeView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
                    [volumeToast.volumeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    
                    currentToast = volumeToast;
                    [toastContainer addSubview:currentToast];
                    break;
                
                    
                case ToastAlertHelpConfirm:
                    //NSLog(@"Confrim");
                    currentToast = [[ToastHelpConfirmView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
                    [toastContainer addSubview:currentToast];
                    break;
                    
                    
                case ToastAlertDidHear:
                    didHearToast = [[ToastDidHearView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
                    [didHearToast.noBtn addTarget:self action:@selector(testToneHit:) forControlEvents:UIControlEventTouchUpInside];
                    [didHearToast.yesBtn addTarget:self action:@selector(testToneHit:) forControlEvents:UIControlEventTouchUpInside];

                    currentToast = didHearToast;
                    [toastContainer addSubview:currentToast];
                    break;
                    
                    
                default:
                    NSLog(@"--------BLANK SPACE!!!-----------");
                    break;
            }
            
            
            //Animate On
            NSLog(@"--Animate On--");
            CGRect newFrame = CGRectMake(0,
                                         height-toastContainer.frame.size.height,
                                         toastContainer.frame.size.width,
                                         toastContainer.frame.size.height);
            
            [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                toastContainer.frame = newFrame;
                
                
            } completion:^(BOOL finished) {

            }];

            
        });
        
    }
    
    else {
        _currentAlert = alert;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            ToastVolumeView *volumeToast;
            ToastDidHearView *didHearToast;

            //Set Toast Alert View
            switch (alert) {
                case ToastAlertNoise:
                    //NSLog(@"NOISE");
                    nextToast = [[ToastNoiseView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
                    nextToast.alpha = 0;
                    [toastContainer addSubview:nextToast];
                    break;
                    
                    
                case ToastAlertHeadphone:
                    //NSLog(@"HEADPHONE");
                    nextToast = [[ToastHeadphoneView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
                    nextToast.alpha = 0;
                    [toastContainer addSubview:nextToast];
                    break;
                    
                    
                case ToastAlertVolume:
                    //NSLog(@"VOLUME");
                    volumeToast = [[ToastVolumeView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
                    [volumeToast.volumeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    volumeToast.alpha = 0;
                    nextToast = volumeToast;
                    
                    [toastContainer addSubview:nextToast];
                    break;
                    
                    
                case ToastAlertHelpConfirm:
                    //NSLog(@"Confrim");
                    nextToast = [[ToastHelpConfirmView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
                    nextToast.alpha = 0;
                    [toastContainer addSubview:nextToast];
                    break;
                    
                    
                case ToastAlertDidHear:
                    didHearToast = [[ToastDidHearView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
                    [didHearToast.noBtn addTarget:self action:@selector(testToneHit:) forControlEvents:UIControlEventTouchUpInside];
                    [didHearToast.yesBtn addTarget:self action:@selector(testToneHit:) forControlEvents:UIControlEventTouchUpInside];
                    
                    nextToast = didHearToast;
                    [toastContainer addSubview:nextToast];
                    break;
                    
                default:
                    NSLog(@"--------BLANK SPACE!!!-----------");
                    break;
            }
            
            
            //Animate Current Off
            //Animagte Next On
            NSLog(@"--Transition--");
            isTransitioning = YES;
            currentToast.userInteractionEnabled = NO;
            
            [UIView animateWithDuration:0.8 animations:^{
                currentToast.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.8 animations:^{
                    nextToast.alpha = 1.0;
                } completion:^(BOOL finished) {
                    isTransitioning = NO;
                    
                    [currentToast removeFromSuperview];
                    currentToast = nextToast;
                    nextToast = nil;
                    
                    if (alert == ToastAlertHelpConfirm) {
                        //Close Alert
                        [self performSelector:@selector(dismissToast) withObject:nil afterDelay:1.5];
                        //[self dismissToast];
                    }
                }];
                
                
            }];
            

        });
        
    }
    
}
*/



- (void)applyEmail{
    bgView.hidden = YES;
    emailView.hidden = NO;
    emailView.sendBtn.enabled = NO;
    
    emailView.dismissBtn.hidden = NO;
//    emailView.instrLbl.hidden = NO;
    emailView.emailLabel.hidden = NO;
    emailView.emailTextField.hidden = NO;
    emailView.sendBtn.hidden = NO;
    emailView.textView.hidden = NO;

    
    emailView.thanksLabel.hidden = YES;
    emailView.dismissBtn2.hidden = YES;
    
    [emailView.sendBtn setTitle:@"Submit" forState:UIControlStateNormal];
    [emailView.sendBtn setTitle:@"Submit" forState:UIControlStateDisabled];
    [emailView.sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [textField becomeFirstResponder];
    
    [emailView.emailTextField becomeFirstResponder];
}




- (void)toastAlert:(ToastAlert)alert{
    
    if (isVisible) {
        
        if (isAnimatingOff) {
            //Stop Animation
            NSLog(@"Stop Animation");

            [toastContainer.layer removeAllAnimations];
            
            //Remove from Superview
            currentToast.alpha = 0;
            [currentToast removeFromSuperview];
            currentToast = nil;

            //Flags
            isAnimatingOff = NO;
            isVisible = NO;
            
            //Animate Up & Flag
            [self applyToastAlert:alert];

            isVisible = YES;
        }
        
        else {
            //Transition
            [self applyToastAlert:alert];
        }
    }
    
    else {
        //Animate Up & Flag
        [self applyToastAlert:alert];
        isVisible = YES;
    }
}


- (void)applyToastAlert:(ToastAlert)alert{
    [self printAlert:alert];
    
    //Animate Up
    if (!isVisible) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createCurrentToastAlert:alert];
            [self animateUpToast];
            
        });
    }

    
    //Transition
    else {

        dispatch_async(dispatch_get_main_queue(), ^{

            if (!isTransitioning) {
                [self createNextToastAlert:alert];
                [self transitionToasts];
                
            }
            
            else {
                NSLog(@"-----Cancel Transition-------");
                
                [currentToast.layer removeAllAnimations];
                [nextToast.layer removeAllAnimations];
                [toastContainer.layer removeAllAnimations];
                currentToast.alpha = 0;
                nextToast.alpha = 0;
                
                [currentToast removeFromSuperview];
                currentToast = nextToast;
                nextToast = nil;
                
                isTransitioning = NO;
                [self createNextToastAlert:alert];
                [self transitionToasts2];
                
            }

        });
    }
    
}


- (void)createCurrentToastAlert:(ToastAlert)alert{
    CGFloat width = self.view.frame.size.width;
    
    ToastVolumeView *volumeToast;
    ToastHelpConfirmView *confirmToast;
    ToastDidHearView *didHearToast;
    
    //Set Toast Alert View
    switch (alert) {
        case ToastAlertNoise:
            currentToast = [[ToastNoiseView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
            [toastContainer addSubview:currentToast];
            break;
            
            
        case ToastAlertHeadphone:
            currentToast = [[ToastHeadphoneView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
            [toastContainer addSubview:currentToast];
            break;
            
            
        case ToastAlertVolume:
            volumeToast = [[ToastVolumeView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
            [volumeToast.volumeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            currentToast = volumeToast;
            [toastContainer addSubview:currentToast];
            break;
            
            
        case ToastAlertHelpConfirm:
            //Here for Test Pane
            confirmToast = [[ToastHelpConfirmView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
            [confirmToast.dismissBtn addTarget:self action:@selector(confirmDismiss:) forControlEvents:UIControlEventTouchUpInside];
            
            currentToast = confirmToast;
            [toastContainer addSubview:currentToast];
            break;
            
            
        case ToastAlertDidHear:
            didHearToast = [[ToastDidHearView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
            [didHearToast.noBtn addTarget:self action:@selector(testToneHit:) forControlEvents:UIControlEventTouchUpInside];
            [didHearToast.yesBtn addTarget:self action:@selector(testToneHit:) forControlEvents:UIControlEventTouchUpInside];
            
            currentToast = didHearToast;
            [toastContainer addSubview:currentToast];
            break;
            
            
        default:
            NSLog(@"--------BLANK SPACE!!!-----------");
            break;
    }
}


- (void)createNextToastAlert:(ToastAlert)alert{
    CGFloat width = self.view.frame.size.width;
    
    ToastVolumeView *volumeToast;
    ToastHelpConfirmView *confirmToast;
    ToastDidHearView *didHearToast;
    
    //Set Toast Alert View
    switch (alert) {
        case ToastAlertNoise:
            //NSLog(@"NOISE");
            nextToast = [[ToastNoiseView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
            nextToast.alpha = 0;
            [toastContainer addSubview:nextToast];
            break;
            
            
        case ToastAlertHeadphone:
            //NSLog(@"HEADPHONE");
            nextToast = [[ToastHeadphoneView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
            nextToast.alpha = 0;
            [toastContainer addSubview:nextToast];
            break;
            
            
        case ToastAlertVolume:
            //NSLog(@"VOLUME");
            volumeToast = [[ToastVolumeView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
            [volumeToast.volumeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            volumeToast.alpha = 0;
            nextToast = volumeToast;
            
            [toastContainer addSubview:nextToast];
            break;
            
            
        case ToastAlertHelpConfirm:
            //NSLog(@"Confrim");
            confirmToast = [[ToastHelpConfirmView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
            [confirmToast.dismissBtn addTarget:self action:@selector(confirmDismiss:) forControlEvents:UIControlEventTouchUpInside];
            confirmToast.alpha = 0;
            nextToast = confirmToast;
            [toastContainer addSubview:nextToast];
            break;
            
            
        case ToastAlertDidHear:
            didHearToast = [[ToastDidHearView alloc] initWithFrame:CGRectMake(0, 0, width, toastHeight)];
            [didHearToast.noBtn addTarget:self action:@selector(testToneHit:) forControlEvents:UIControlEventTouchUpInside];
            [didHearToast.yesBtn addTarget:self action:@selector(testToneHit:) forControlEvents:UIControlEventTouchUpInside];
            
            nextToast = didHearToast;
            [toastContainer addSubview:nextToast];
            break;
            
        default:
            NSLog(@"--------BLANK SPACE!!!-----------");
            break;
    }
}


- (void)animateUpToast{
    CGFloat height = self.view.frame.size.height;

    CGRect newFrame = CGRectMake(0,
                                 height-toastContainer.frame.size.height,
                                 toastContainer.frame.size.width,
                                 toastContainer.frame.size.height);
    
    [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        toastContainer.frame = newFrame;
        
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)transitionToasts{
    NSLog(@"Transition Begins");
    isTransitioning = YES;
    currentToast.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.8 animations:^{
        
        currentToast.alpha = 0;
        
    } completion:^(BOOL finished) {
        NSLog(@"Completion Block");

        if (finished) {
            NSLog(@"1: Transition Finished");
            
            [UIView animateWithDuration:0.8 animations:^{
                nextToast.alpha = 1.0;
            } completion:^(BOOL finished) {
                
                if (finished) {
                    NSLog(@"2: Transition Finished");
                    
                    isTransitioning = NO;
                    
                    [currentToast removeFromSuperview];
                    currentToast = nextToast;
                    nextToast = nil;
                    
                }
                else
                    NSLog(@"2: Transition DID NOT FINISH");

            }];
        }

    }];
}


- (void)transitionToasts2{
    currentToast.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:1.8
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         NSLog(@"Transition Begins");
                         isTransitioning = YES;
                         
                         nextToast.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         NSLog(@"Completion Block");
                         
                         if (finished) {
                             NSLog(@"1: Transition Finished");
                             
                             [currentToast removeFromSuperview];
                             currentToast = nextToast;
                             nextToast = nil;
                         }
                         else
                             NSLog(@"1: Transition DID NOT FINISH");
                     }];
}



- (void)dismissToast{
    isAnimatingOff = YES;
    
    CGFloat height = self.view.frame.size.height;
    CGRect newRect = CGRectMake(0, height, toastContainer.frame.size.width, toastContainer.frame.size.height);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        toastContainer.frame = newRect;
    } completion:^(BOOL finished) {
        
        
        if (finished) {
            NSLog(@"Animation-Dismiss finished");
            isAnimatingOff = NO;
            isVisible = NO;
            
            [currentToast removeFromSuperview];
            currentToast = nil;
            
            [ToastManager toastsComplete];
        }
//        else
//            NSLog(@"Animation-Dismiss DID NOT finished");
        
    }];
    
}




- (void)printAlert:(ToastAlert)alert{
    NSLog(@" ");
    NSLog(@" ");

    NSLog(@"-----VC:-----");
    
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
    
    NSLog(@" ");
    NSLog(@" ");

}





#pragma mark - IBAction Methods

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([currentToast isKindOfClass:[ToastVolumeView class]]) {

        if ([keyPath isEqual:@"outputVolume"]) {
//            NSLog(@"volume changed!");
            float vol = [[AVAudioSession sharedInstance] outputVolume];
            
            ToastVolumeView *volumeToast = (ToastVolumeView *)currentToast;
            volumeToast.volumeLbl.text = [NSString stringWithFormat:@"%i", (int)roundf(vol*100)];
            
        }
    }
}

-(IBAction)sliderValueChanged:(UISlider *)slider{
//    NSLog(@"sliderValueChanged");
//    NSLog(@"value: %f", slider.value);
    
    if ([currentToast isKindOfClass:[ToastVolumeView class]]) {
        //NSLog(@"IS Volume View Class");
        
        ToastVolumeView *volumeToast = (ToastVolumeView *)currentToast;
        volumeToast.volumeViewSlider.value = slider.value;
        volumeToast.volumeLbl.text = [NSString stringWithFormat:@"%i", (int)roundf(slider.value*100)];
        
        if (slider.value == 1.0f) {
            [volumeToast.volumeSlider removeTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            volumeToast.volumeSlider.enabled = NO;
        }
    }
    else {
        //NSLog(@"NOT Volume View Class");
    }
    
    
    
}


//- (IBAction)testToneNo:(id)sender{
//    ((UIButton *)sender).enabled = NO;
//    
//}

/*
- (IBAction)testToneHit:(id)sender{
    UIButton *btn = (UIButton *)sender;
    ToastDidHearView *view = (ToastDidHearView *)btn.superview;
    view.noBtn.enabled = NO;
    view.yesBtn.enabled = NO;
    
    BOOL ans;
    if (btn.tag == 0)
        ans = NO;
    else
        ans = YES;
    
    
    if (![self shouldDismissToast] && !isAnimatingOff)
        return;
    
    NSLog(@"VC: Dismiss Toast");
    isAnimatingOff = YES;
    
    CGFloat height = self.view.frame.size.height;
    CGRect newRect = CGRectMake(0, height, toastContainer.frame.size.width, toastContainer.frame.size.height);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        toastContainer.frame = newRect;
    } completion:^(BOOL finished) {
        isVisible = NO;
        isAnimatingOff = NO;
        _currentAlert = 0;
        
        [currentToast removeFromSuperview];
        currentToast = nil;
        
        if (finished)
            [ToastManager toastDidHear:ans];
        else
            NSLog(@"Animation Did Not Finish");
    }];
    
    
}
*/

- (IBAction)testToneHit:(id)sender{
    UIButton *btn = (UIButton *)sender;
    ToastDidHearView *view = (ToastDidHearView *)btn.superview;
    view.noBtn.enabled = NO;
    view.yesBtn.enabled = NO;
    
    BOOL ans;
    if (btn.tag == 0)
        ans = NO;
    else
        ans = YES;
    
    
//    if (![self shouldDismissToast] && !isAnimatingOff)
//        return;
    
//    NSLog(@"VC: Dismiss Toast");
    
    
    isAnimatingOff = YES;
    
    CGFloat height = self.view.frame.size.height;
    CGRect newRect = CGRectMake(0, height, toastContainer.frame.size.width, toastContainer.frame.size.height);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        toastContainer.frame = newRect;
    } completion:^(BOOL finished) {
        
        
        
        if (finished) {
            [currentToast removeFromSuperview];
            currentToast = nil;
            
            isAnimatingOff = NO;
            isVisible = NO;
            
            [ToastManager toastDidHear:ans];
        }
    }];
    
    
}

- (IBAction)confirmDismiss:(id)sender{
    //Dismiss Toast
    [self dismissToast];
}








- (IBAction)emailDismiss:(id)sender{
    [textField becomeFirstResponder];
    [textField resignFirstResponder];
    
    emailView.emailTextField.text = @"";
    textField.text = @"";
    [emailView.sendBtn setTitle:@"Submit" forState:UIControlStateDisabled];

    
    [ToastManager toastEmailDismiss];
    
    bgView.hidden = NO;
}

- (IBAction)sendEmail:(id)sender {
    
    //Check Email
//    BOOL validEmail = [EmailManager isValidEmail:emailView.emailTextField.text];
//    if (validEmail) {
//    }
//    else {
//        [self displayError:EMAIL_ERROR];
//    }
    
    Reachability *network = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [network currentReachabilityStatus];
    if (status == NotReachable) {
        //No Connection
        NSLog(@"No Connection");
        //[self displayError:EMAIL_NETWORK_ERROR];
        [emailView.sendBtn setTitle:@"Enable wifi and try again" forState:UIControlStateNormal];
        [emailView.sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    else {
        //Connection
        NSLog(@"Connection");
        [emailView.sendBtn setTitle:@"Sending" forState:UIControlStateDisabled];
        [emailView.sendBtn setEnabled:NO];
        
        OMPromise *promise2 = [EmailManager sendEmailTo:emailView.emailTextField.text];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

        [promise2 fulfilled:^(id result) {
            NSLog(@"Sending result success!");
            
            [emailView.emailTextField resignFirstResponder];
            
            emailView.dismissBtn.hidden = YES;
//            emailView.instrLbl.hidden = YES;
            emailView.emailLabel.hidden = YES;
            emailView.emailTextField.hidden = YES;
            emailView.sendBtn.hidden = YES;
            emailView.textView.hidden = YES;
            
            emailView.thanksLabel.hidden = NO;
            emailView.dismissBtn2.hidden = NO;
            
            
            //Analytics
            //Google
            [tracker set:kGAIScreenName value:@"Thank You Screen"];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"email_submission"     // Event category (required)
                                                                  action:@"success"  // Event action (required)
                                                                   label:nil          // Event label
                                                                   value:nil] build]];    // Event value
            
            //FB
            [FBSDKAppEvents logEvent:@"Thank You Screen"];
            [FBSDKAppEvents logEvent:@"Email_Submission" parameters:@{@"Submission":@"Success"}];

            
            
            //Mailchimp Email Distribution (removed)
            //NSDictionary *params = @{@"id": MAILCHIMP_LIST, @"email": @{@"email": emailView.emailTextField.text}, @"merge_vars": @{@"groupings": @[@{@"name": MAILCHIMP_GROUPING, @"groups": @[MAILCHIMP_GRP_NAME1]}]}};
            //[[ChimpKit sharedKit] callApiMethod:@"lists/subscribe" withParams:params andDelegate:self];

            
             //Campaign Monitor Email Distribution
             CSAPI *API = [[CSAPI alloc] initWithAPIKey:CAMPAIGN_MON_API];
             NSArray *customFields = @[[CSCustomField customFieldWithKey:@"Groups" value:CAMPAIGN_MON_GRP]];
             
             
             [API subscribeToListWithID:CAMPAIGN_MON_LIST
             emailAddress:emailView.emailTextField.text
             name:@""
             shouldResubscribe:YES
             customFields:customFields
             completionHandler:^(NSString *subscribedAddress) {
             NSLog(@"Successfully subscribed %@", subscribedAddress);
             } errorHandler:^(NSError *error) {
             NSLog(@"Something went wrong: %@", error);
             }];
            
            
            
            //Rate
            //[[iRate sharedInstance] promptIfNetworkAvailable];
            //[[iRate sharedInstance] promptForRating];
            [self performSelector:@selector(askToRate:) withObject:nil afterDelay:1.0];
            
            
        }];
        
        [promise2 failed:^(NSError *error) {
            NSLog(@"Sending result Failed!");
            
            [emailView.sendBtn setTitle:@"Submit" forState:UIControlStateDisabled];
            [emailView.sendBtn setEnabled:YES];
            [emailView.sendBtn setTitle:@"Try Again" forState:UIControlStateNormal];
            [emailView.sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            
            //Analytics
            //Google
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"email_submission"     // Event category (required)
                                                                  action:@"fail"  // Event action (required)
                                                                   label:nil          // Event label
                                                                   value:nil] build]];    // Event value
            
            //FB
            [FBSDKAppEvents logEvent:@"Email_Submission" parameters:@{@"Submission":@"Fail"}];

            
        }];
        
        
    }
    
    
    
    
    
//    CGFloat width = self.view.frame.size.width;
//    CGFloat height = self.view.frame.size.height;
//    CGRect newFrame = CGRectMake(0, height-toastHeight, width, toastHeight);
//    
//    emailConfmView = [[EmailConfirmationView alloc] initWithFrame:newFrame];
//    [emailConfmView.dismissBtn addTarget:self action:@selector(emailDismiss:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:emailConfmView];
//    
//    [textField becomeFirstResponder];
//    [textField resignFirstResponder];
    

}

- (IBAction)closeError:(id)sender{
    [errView removeFromSuperview];
    
    [textField becomeFirstResponder];
    
    [emailView.emailTextField becomeFirstResponder];
}


- (IBAction)askToRate:(id)sender {
    //Rate
    //[[iRate sharedInstance] promptIfNetworkAvailable];
    [[iRate sharedInstance] promptForRating];
}



#pragma Noise

- (void)updateNoiseIndicator:(float)value{
    float t = [[DataSurrogate sharedInstance] threshold];
    float range = t / 5;
    
    if ([currentToast isKindOfClass:[ToastNoiseView class]]) {
        ToastNoiseView *noiseView = (ToastNoiseView *)currentToast;
        
        if (value <= t) {
            NSLog(@"1:  %f", t);
            [noiseView speed1];
        }
        
        else if (value > t && value <= (t-range*1)) {
            NSLog(@"2:  %f to %f", t, (t-range*1));
            [noiseView speed2];

        }else if (value > (t-range*1) && value <= (t-range*2)) {
            NSLog(@"3:  %f to %f", (t-range*1), (t-range*2));
            [noiseView speed3];

        }else if (value > (t-range*2) && value <= (t-range*3)) {    //-24 to -16
            NSLog(@"4:  %f to %f", (t-range*2), (t-range*3));
            [noiseView speed4];

        }else if (value > (t-range*3) && value <= (t-range*4 -4)) {    //-16 to -12
            NSLog(@"5:  %f to %f", (t-range*3), (t-range*4 -4));
            [noiseView speed5];

        }else {
            NSLog(@"6:");
            [noiseView speed6];

        }
    }
}


#pragma Volume

- (BOOL)isHeadsetPluggedIn{
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

- (void)volumeChanged:(NSNotification *)note{
//    if(![self isHeadsetPluggedIn])
//        return;
    NSLog(@"ToastVC:volumeChanged");

    
    if (currentToast && [currentToast isKindOfClass:[ToastVolumeView class]]) {
        NSNumber *volumeNum = note.userInfo[VOLUME_PROPERTY];
        ToastVolumeView *volumeToast = (ToastVolumeView *)currentToast;
        volumeToast.volumeSlider.value = volumeNum.floatValue;
        
        //NSLog(@"--volume: %f--", volumeNum.floatValue);

    }
}



#pragma UITextFieldDelegate Methods

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //NSLog(@"String: %@", string);
    
    [emailView.sendBtn setTitle:@"Submit" forState:UIControlStateNormal];
    [emailView.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    
    //Check Email
    BOOL validEmail = [self validateEmailWithString:emailView.emailTextField.text];
    
    if (validEmail) {
        emailView.sendBtn.enabled = YES;
        emailView.sendBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
    else {
        emailView.sendBtn.enabled = NO;
        emailView.sendBtn.layer.borderColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0].CGColor;

    }

    
    if ([string isEqualToString:@"\n"])
        return NO;
    
    return YES;
}



#pragma mark - iRateDelegate Methods

- (BOOL)iRateShouldPromptForRating {
    //Already Rated
    if ([iRate sharedInstance].ratedThisVersion)
        return NO;
    
    else {
        //Declined to Rate
        if ([iRate sharedInstance].declinedThisVersion)
            return NO;
        
        else {
            //Check Last Reminded more than X days (1)
            //NSDate *remindDate = [[iRate sharedInstance].lastReminded dateByAddingTimeInterval:45];
            NSDate *remindDate = [[iRate sharedInstance].lastReminded dateByAddingDays:1];
            
            if ([remindDate isLaterThanDate:[NSDate date]])
                return NO;
        }
    }
    
    return YES;
}

@end
