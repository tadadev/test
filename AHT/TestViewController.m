//
//  TestViewController.m
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "TestViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#include "ContainerViewController.h"
#import "TestManager.h"
#import "Test.h"
#import "TestItem.h"
#import "TestResult.h"
#import "StartViewController.h"
#import "ResultsViewController.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "NSDate-Utilities.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#define ARC4RANDOM_MAX      0x100000000


static NSTimeInterval beforeSoundPauseMin = 0.5;    //0.5
static NSTimeInterval beforeSoundPauseMax = 3.5;    //1.0

static NSTimeInterval afterSoundPause = 0.5;
static NSTimeInterval responseWait = 1.25;


@interface TestViewController ()
//@property (nonatomic, strong) MPVolumeView *volumeView;


@property (nonatomic, strong) Test* test;
@property (nonatomic, strong) NSDate* testStartTime;

@property (nonatomic, assign) NSUInteger currentItemIndex;

@property (nonatomic) double pauseLength;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *nextPlayer;
@property (nonatomic, assign) NSUInteger nextPlayerIndex;

@property (nonatomic, assign) NSTimer *playTimer, *pauseTimer, *responseTimer;

@property (nonatomic) BOOL isPausing, isPlaying;
@property (nonatomic) BOOL hasPausedTest, headphoneLock, noiseLock, volumeLock, earlyLock, motionLock;

@end

@implementation TestViewController
@synthesize textView, doneImageView, didYouHearButton, didYouHearLabel, progressLabel;
@synthesize headerLbl, countdownLbl, successLbl, containerView, circleProgress;

- (void)dealloc {
    NSLog(@"Dealloc");
}

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



- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[TestManager sharedInstance] resetTest];

//    textView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    
    circleProgress.trackFillColor = [UIColor colorWithRed:0/255.0f green:161/255.0f blue:220/255.0f alpha:1];
    circleProgress.trackBackgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1];
    circleProgress.progress = 0.00001;

    
    //MPVolumeView
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-1000, 0, 200, 40)];
    //volumeView.showsVolumeSlider = NO;
    volumeView.showsRouteButton = NO;
    [self.view addSubview:volumeView];
    
    
    
    //Set ToastManager Delegate
    //id<ToastDelegate> toastDel = [ToastManager delegate];
    //toastDel = self;
    [ToastManager manager].delegate = self;
    //[ToastManager manager].volumeView = volumeView;
    
    
    //iRate Delegate
    //[iRate sharedInstance].delegate = self;
    
    
    
    //Begin Toast Monitor & Pre Test
    //[ToastManager beginToastMonitor];
    [self performSelectorOnMainThread:@selector(startMonitoring) withObject:nil waitUntilDone:NO];
    [self beginPreTest];
    
    
    
    
    //------ Tesing --------
    //[self testPane];
    

    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Analytics
    //Google
    self.screenName = @"Test Screen";
    
    //FB
    [FBSDKAppEvents logEvent:@"Test Screen"];

    //Headphones
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChanged) name:AVAudioSessionRouteChangeNotification object:nil];

    //Volume
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];

}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //Tag Manager (Analytics)
    //    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    //    [dataLayer push:@{@"event": @"openScreen", @"screenName": @"Results List Screen"}];
    
    //Analytics
    //Google
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"hearing_test"     // Event category (required)
                                                          action:@"started"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
    
    //FB
    [FBSDKAppEvents logEvent:@"Hearing_Test" parameters:@{@"Test":@"Started"}];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [ToastManager manager].delegate = nil;

    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}





- (void)startMonitoring{
    [ToastManager beginToastMonitor];

}

- (void)endMonitoring{
    [ToastManager endToastMonitor];

}


- (void)setButton:(UIButton *)btn enabled:(BOOL)enabled{
    NSLog(@"SETBUTTON BOOL");
    if (enabled) {
        //[btn setBackgroundColor:[UIColor darkGrayColor]];
    }
    else {
        //[btn setBackgroundColor:[UIColor lightGrayColor]];

    }
    
    btn.enabled = enabled;
}


- (void)setIsSampleTone:(BOOL)isSampleTone{
    NSLog(@"setIsSampleTone: %@", isSampleTone ? @"yes":@"no");
    _isSampleTone = isSampleTone;
    if (_isSampleTone) {
        self.test = [[Test alloc] initSampleTone];
        self.currentItemIndex = 0;
//        self.itemCount = 1;
//        self.haveStartedTest = NO;
//        self.title = @"Trial Tone";
    }
    
    else {
        NSLog(@"NOt Sample Tone");
        self.test = [[Test alloc] init];
        self.currentItemIndex = 0;
    }
    
    
}





- (void)beginPreTest{
    [self setIsSampleTone:YES];
    
    _testStep = TestStep_Instr1;

    headerLbl.text = INSTRUCTION1_H;
    textView.text = INSTRUCTION1_D;
    
    [self setButton:didYouHearButton enabled:NO];
    
    [self performSelector:@selector(displayInstruction2) withObject:nil afterDelay:READ_PACE];
    
}


- (void)displayInstruction2{
    if (isToastVisible || self.hasPausedTest)
        return;
    
    if (_testStep == TestStep_Instr2) {
        NSLog(@"Already At Step 2");
        [self performSelector:@selector(startTest) withObject:nil afterDelay:READ_PACE];
        return;
    }
    
    
    [UIView animateWithDuration:1.0 animations:^{
        headerLbl.alpha = 0;
        textView.alpha = 0;
    } completion:^(BOOL finished) {
        
        _testStep = TestStep_Instr2;
        
        headerLbl.text = INSTRUCTION2_H;
        textView.text = INSTRUCTION2_D;
        
        [UIView animateWithDuration:1.0 animations:^{
            headerLbl.alpha = 1.0;
            textView.alpha = 1.0;
        } completion:^(BOOL finished) {
            NSLog(@"step 2 finished");
            [self performSelector:@selector(startTest) withObject:nil afterDelay:READ_PACE];
        }];
    }];
    
}


- (void)displayConfirmation{
    NSLog(@"displayConfirmation");
    if (isToastVisible || self.hasPausedTest)
        return;

    if (_testStep == TestStep_PreToneConfirm) {
        [self performSelector:@selector(displayCountdown1) withObject:nil afterDelay:READ_PACE];
        return;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        headerLbl.alpha = 0;
        textView.alpha = 0;
    } completion:^(BOOL finished) {
        
        _testStep = TestStep_PreToneConfirm;

        headerLbl.text = PRETEST_CONFIRMATION_H;
        textView.text = PRETEST_CONFIRMATION_D;
        
        [UIView animateWithDuration:1.0 animations:^{
            headerLbl.alpha = 1.0;
            textView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
            
            [self performSelector:@selector(displayCountdown1) withObject:nil afterDelay:READ_PACE];
        }];
    }];
}


- (void)displayCountdown1{
    if (isToastVisible || self.hasPausedTest)
        return;
    
    
//    if (_testStep == TestStep_Countdown) {
//        [self performSelector:@selector(displayCountdown1) withObject:nil afterDelay:READ_PACE];
//        return;
//    }
//    
//    _testStep = TestStep_Countdown;

    
    
    [didYouHearButton setHidden:YES];
    [countdownLbl setHidden:NO];
    countdownLbl.alpha = 0;
    countdownLbl.text = @"3";
    
    [UIView animateWithDuration:1.0 animations:^{
        countdownLbl.alpha = 1.0;
        
    } completion:^(BOOL finished) {
       
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
            countdownLbl.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            countdownLbl.text = @"2";
            [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
                countdownLbl.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
                    countdownLbl.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    
                    countdownLbl.text = @"1";
                    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
                        countdownLbl.alpha = 1.0;
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
                            countdownLbl.alpha = 0;
                            
                        } completion:^(BOOL finished) {
                            
                            [self setIsSampleTone:NO];
                            [self performSelector:@selector(displayTesting) withObject:nil afterDelay:0];
                            
                        }];
                        
                    }];
                    
                }];
                
            }];
            
        }];
        
    }];
}


- (void)displayTesting{
    if (isToastVisible || self.hasPausedTest)
        return;
    
    if (_testStep == TestStep_Test) {
        [self performSelector:@selector(displayCountdown1) withObject:nil afterDelay:READ_PACE];
        return;
    }

    
    //_testStep = TestStep_TestStart;
    _testStep = TestStep_Test;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        headerLbl.alpha = 0;
        textView.alpha = 0;
    } completion:^(BOOL finished) {
        
        
        headerLbl.text = TEST_INPROGRESS_RIGHT_H;
        textView.text = TEST_INPROGRESS_RIGHT_D;
        
        [UIView animateWithDuration:0.5 animations:^{
            headerLbl.alpha = 1.0;
            textView.alpha = 1.0;
        } completion:^(BOOL finished) {
            progressLabel.hidden = NO;
//            circleProgress.progress = 0.02;
            circleProgress.hidden = NO;
            [didYouHearButton setHidden:NO];

            
            NSLog(@"---Start Actual Test---");
            [self setIsSampleTone:NO];
            [self startTest];
        }];
    }];
}


- (void)displayTestComplete{
    if (isToastVisible || self.hasPausedTest)
        return;
    
    
    if (_testStep == TestStep_TestComplete) {
        [self performSelector:@selector(testFinish) withObject:nil afterDelay:2.5];
        return;
    }
    
    
    _testStep = TestStep_TestComplete;

    
    progressLabel.text = [NSString stringWithFormat:@"%i%% Complete", 100];
    circleProgress.progress = 1.0f;
    
    [UIView animateWithDuration:1.5 animations:^{
        headerLbl.alpha = 0;
        textView.alpha = 0;
        
        didYouHearButton.alpha = 0;
        circleProgress.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        successLbl.alpha = 0;
        successLbl.hidden = NO;
        successLbl.text = @"Success";
        textView.text = TEST_COMPLETE;
        
        [UIView animateWithDuration:1.0 animations:^{
            successLbl.alpha = 1.0;
            //textView.alpha = 1.0;
        
        } completion:^(BOOL finished) {
            
            
            //Calc & Show Results
            [self performSelector:@selector(testFinish) withObject:nil afterDelay:2.5];
        }];
    }];
}


- (void)continueStep{
    
    if (_testStep == TestStep_Instr1) {
        NSLog(@"TestStep_Instr1");
        [self beginPreTest];
    }
    
    else if (_testStep == TestStep_Instr2) {
        NSLog(@"TestStep_Instr2");
        [self displayInstruction2];
    }
    
    else if (_testStep == TestStep_PreToneConfirm) {
        NSLog(@"TestStep_PreToneConfirm");
        [self displayConfirmation];
    }
    
//    else if (_testStep == TestStep_Countdown) {
//        NSLog(@"TestStep_Countdown");
//        [self displayCountdown1];
//    }
    
//    else if (_testStep == TestStep_TestStart) {
//        [self displayTesting];
//    }
    
    else if (_testStep == TestStep_Test) {
        NSLog(@"TestStep_Test");

        [self playNextItem];
        didYouHearButton.enabled = YES;
    }
    
    else if (_testStep == TestStep_TestComplete) {
        NSLog(@"TestStep_TestComplete");

        [self displayTestComplete];
    }
}


- (void)startTest{
    NSLog(@"-----startTest-----");

    
    if (self.hasPausedTest)
        return;
    
    
    [self setButton:didYouHearButton enabled:YES];
    
    
    self.testStartTime = [NSDate date];

    
//    //Start right
//    self.rightProgress = 1;
//    self.circleProgress.rightProgress = 1;
//    self.circleProgress.rightActive = YES;
//    
//    if(!_isSampleTone && glbAppdel.resuming)
//        [self ResumeLastTest];
    
    
    [self playNextItem];
    
}





- (void)configureInterfaceListening:(BOOL)isListening{

    
    TestItem *item = [_test currentItem];
    if (item.left) {
        headerLbl.text = TEST_INPROGRESS_LEFT_H;
        textView.text = TEST_INPROGRESS_LEFT_D;
    }
    else if (item.right) {
        headerLbl.text = TEST_INPROGRESS_RIGHT_H;
        textView.text = TEST_INPROGRESS_RIGHT_D;
    }
    
//    NSLog(@"Completed: %i", _test.completed);
//
//    NSLog(@"-----------------------------------------");
//    NSLog(@" ");
    NSLog(@"Left Progress: %i", _test.leftProgress);
    NSLog(@"Right Progress: %i", _test.rightProgress);
//    NSLog(@" ");
//    NSLog(@"-----------------------------------------");

    int left = _test.leftProgress;
    int right = _test.rightProgress;
//    int perc = (left+right-1) * 10;
    int perc = (left+right-1);

    progressLabel.text = [NSString stringWithFormat:@"%i%% Complete", perc];
    
    double p = (double)(left + right -1)/10;
    if (p == 0)
        p = 0.00001;
    circleProgress.progress = p;
}






- (AVAudioPlayer *)playerForItem:(TestItem *)item{
    //TestItem *item = _test.items[index];
    if (!item.hasSound) {
        return nil;
    }
    
    //    NSString *filename = [NSString stringWithFormat:@"%@_%d_16", item.frequency, item.decibels];
    //    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:filename withExtension:@"caf"];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *left, *filename;
    
    if (item.left)
        left = @"L";
    else if (item.right)
        left = @"R";
    
    if (delegate.audio == AudioType_MC5_1)
        filename = [NSString stringWithFormat:@"MC5-1_%@%@_%ddB", left, item.frequency, (int)item.decibels];
    
    else if (delegate.audio == AudioType_MC5_2)
        filename = [NSString stringWithFormat:@"MC5-2_%@%@_%ddB", left, item.frequency, (int)item.decibels];
    
    else if (delegate.audio == AudioType_MC5_3)
        filename = [NSString stringWithFormat:@"MC5-3_%@%@_%ddB", left, item.frequency, (int)item.decibels];
    
    else if (delegate.audio == AudioType_HF5_1)
        filename = [NSString stringWithFormat:@"HF5-1_%@%@_%ddB", left, item.frequency, (int)item.decibels];
    
    else if (delegate.audio == AudioType_MC5_1_HA2Cal)
        filename = [NSString stringWithFormat:@"MC5-1_HA2Cal_%@%@_%ddB", left, item.frequency, (int)item.decibels];
    
    else if (delegate.audio == AudioType_NS_1)
        filename = [NSString stringWithFormat:@"NS-1_%@%@_%ddB", left, item.frequency, (int)item.decibels];
    
    else if (delegate.audio == AudioType_NS_2) {
        NSLog(@"Item.Decibel: %f", item.decibels);
        NSString *dB;
        if (floor(item.decibels) == item.decibels)
            dB = [NSString stringWithFormat:@"%.f", item.decibels];
        
        else
            dB = [NSString stringWithFormat:@"%.01f", item.decibels];
        
        
        filename = [NSString stringWithFormat:@"NS-2_%@%@_%@dB", left, item.frequency, dB];
    }
    
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:filename withExtension:@"wav"];
    
    //    filename = [NSString stringWithFormat:@"%@_%d_16", item.frequency, item.decibels];
    //    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:filename withExtension:@"caf"];
    
    
    
    //NSLog(@"Audio Type: %i", delegate.audio);
    NSLog(@"Filename: %@", filename);
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    player.delegate = self;
    player.pan = (item.left && item.right) ? 0.0 : (item.left ? -1.0 : 1.0);
    if (error) {
        NSLog(@"Error creating player: %@", error);
    }
    return player;
}


- (double)randomPause{
    double val = ((double)arc4random() / ARC4RANDOM_MAX);
    double scaledVal = beforeSoundPauseMin + (val * (beforeSoundPauseMax - beforeSoundPauseMin));
    self.pauseLength = scaledVal;
    
    return scaledVal;
}


- (void)pauseFinished{
    //NSLog(@"Pause Finished");
    self.pauseTimer = nil;
    self.isPausing = NO;
    
}




- (void)playNextItem{
    NSLog(@"playNextItem");
    
    self.isPlaying = YES;
    
    TestItem *item = [_test currentItem];
    
    if (!item.hasSound) {
        [self playNoSound];
    } else {
        if(self.nextPlayer && self.nextPlayerIndex == _currentItemIndex){
            //See if a player is already made
            //NSLog(@"Using prepared player");
            self.player = self.nextPlayer;
        } else {
            //Make a player for this
            //NSLog(@"Making on-the-spot player");
            self.player = [self playerForItem:item];
        }
        
        
        //Play Sound
        [_player playAtTime:_player.deviceCurrentTime + [self randomPause]];
        delayStart = CACurrentMediaTime() + self.pauseLength;
        
        
        //Schedule Pause Timer
        //NSLog(@"Pausing");
        self.isPausing = YES;
        self.pauseTimer = [NSTimer scheduledTimerWithTimeInterval:self.pauseLength target:self selector:@selector(pauseFinished) userInfo:nil repeats:NO];
        
    }
    
    self.nextPlayer = nil;
    

}


- (void)playNoSound{
    NSLog(@"playNoSound");
    
    self.isPlaying = YES;
    
    NSTimeInterval waitingTime = 1.0 + [self randomPause] + afterSoundPause;
    [self performSelector:@selector(donePlayingNoSound) withObject:nil afterDelay:waitingTime];
}


- (void)donePlayingNoSound{
    self.isPlaying = NO;
    
    [self showUserResponseMode];
}


- (void)showUserResponseMode{
    [self configureInterfaceListening:NO];
}


- (void)responseTimeEnded{
    NSLog(@"----------------------------------responseTimeEnded--------");
    [self.responseTimer invalidate];
    self.responseTimer = nil;
    
    
    if (_isSampleTone) {
        [ToastManager showDidHear];
    }
    
    else
        [self responsePressed:NO];
}


- (void)vibrate{
    NSLog(@"vibrate");
    
    [[NoiseManager sharedInstance] stopMeasuring];
    
    //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    NSError *err = nil;
    //    [audioSession setCategory :AVAudioSessionCategoryPlayback  error:&err];
    //
    //    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    //
    //    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord  error:&err];
    
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
}


- (void)doneWithTest{
    //NSLog(@"Done with test");
    
    [self.responseTimer invalidate];
    self.responseTimer = nil;
    
    if (_isSampleTone) {
        [_test gradeResults];
        
        //NSLog(@"Test_Correct: %i", _test.correct);
        
        if (_test.correct <= 0) {
            //Not Success
            
            //Increase noise by 5 until 90 DB
            TestManager *testManager = [TestManager sharedInstance];
            testManager.testToneDecibels = MIN(90, testManager.testToneDecibels + 5);
            NSLog(@"new test decibels: %d", testManager.testToneDecibels);
            
            //Set SampleTone again
            self.isSampleTone = YES;
            
            //Start Test Again
            [self startTest];
            
        }
        else {
            //Success
            [_player stop];
            [self setButton:didYouHearButton enabled:NO];
            [self displayConfirmation];
            
        }

        
    } else {
        

        [_player stop];

        
        
        //Noise & Motion Managers Stop
        [self performSelectorOnMainThread:@selector(endMonitoring) withObject:nil waitUntilDone:NO];
        //[ToastManager endToastMonitor];
        

        
        //Display "Finished Lingo"
        [self setButton:didYouHearButton enabled:NO];
        [self displayTestComplete];

        //Tag Manager (Analytics)
//        TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
//        [dataLayer pushValue:@"testCompleted" forKey:@"event"];
        
        //Analytics
        //Google
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker set:kGAIScreenName value:@"Success Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"hearing_test"     // Event category (required)
                                                              action:@"finished"  // Event action (required)
                                                               label:nil          // Event label
                                                               value:nil] build]];    // Event value
        
        //FB
        [FBSDKAppEvents logEvent:@"Hearing_Test" parameters:@{@"Test":@"Finished"}];

    }
}


- (void)playTestFinished{
    
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:@"YourTestIsComplete" withExtension:@"mp3"];
    NSError *error = nil;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    
    //self.player = player;
    [self.player play];
    
}


- (TestResult *)compileTestResults{
    [_test gradeResults];
    
    //Create test result
    int testNumber = [TestResult MR_countOfEntities] + 1;
    TestResult *result = [TestResult MR_createEntity];
    result.testNumber = [NSNumber numberWithInt:testNumber];
    result.contactEmail = [TestManager sharedInstance].userEnteredEmail;
    result.usingAppleEarbuds = [NSNumber numberWithBool:[TestManager sharedInstance].usingAppleHeadphones];
    result.completed = [NSNumber numberWithBool:YES];
    result.startedDate = self.testStartTime;
    result.finishedDate = [NSDate date];
    
    result.completedCount = [NSNumber numberWithInt:_test.completed];
    result.correctCount = [NSNumber numberWithInt:_test.correct];
    result.correctRatio = [NSNumber numberWithFloat:_test.ratio];
    result.incorrectCount = [NSNumber numberWithInt:_test.incorrect];
    result.itemCount = [NSNumber numberWithInteger:_test.items.count];
    
    //Save result data
    NSLog(@"test leftResults: %@", _test.leftResults);
    NSLog(@"test rightResults: %@", _test.rightResults);
    NSLog(@"test frequencies: %@", _test.allFrequencies);
    
    //500 is last, need to sort results by frequency ascending before saving
    NSMutableDictionary *testData = [[NSMutableDictionary alloc] initWithCapacity:_test.allFrequencies.count];
    for (int i=0;i<_test.allFrequencies.count;i++) {
        NSNumber *freq = _test.allFrequencies[i];
        testData[freq] = @{@"left":_test.leftResults[i],@"right":_test.rightResults[i]};
    }
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedFreqs = [[testData allKeys] sortedArrayUsingDescriptors:@[descriptor]];
    
    NSMutableArray *leftResults = [[NSMutableArray alloc] initWithCapacity:sortedFreqs.count];
    NSMutableArray *rightResults = [[NSMutableArray alloc] initWithCapacity:sortedFreqs.count];
    
    int maxDifference = 0;
    
    for (NSNumber *freq in sortedFreqs) {
        NSDictionary *dataItem = testData[freq];
        NSNumber *leftNumber = dataItem[@"left"];
        NSNumber *rightNumber = dataItem[@"right"];
        
        int difference = abs(leftNumber.intValue - rightNumber.intValue);
        if (difference > maxDifference) {
            maxDifference = difference;
        }
        
        [leftResults addObject:leftNumber];
        [rightResults addObject:rightNumber];
    }
    
    result.earDifference = [NSNumber numberWithInt:maxDifference];
    result.shownAlert = [NSNumber numberWithBool:NO];
    NSLog(@"max ear difference: %d", maxDifference);
    
    result.leftResults = [[leftResults valueForKey:@"stringValue"] componentsJoinedByString:@"|"];
    result.rightResults = [[rightResults valueForKey:@"stringValue"] componentsJoinedByString:@"|"];
    result.frequencies = [[sortedFreqs valueForKey:@"stringValue"] componentsJoinedByString:@"|"];
    
    
    NSLog(@"leftResults: %@", result.leftResults);
    NSLog(@"rightResults: %@", result.rightResults);
    NSLog(@"frequencies: %@", result.frequencies);
    
    
//    result.resultsText = [EmailManager emailTextForResult:result leftResponses:_test.leftResponses rightResponses:_test.rightResponses];
    
    
    [[[MagicalRecordStack defaultStack] context] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if(!success){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                                 message:@"Error Saving result into database"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                [myAlert show];
            });
        }
        NSLog(@"done saving test result");
    }];
    
    return result;
}

- (void)testFinish{
    NSLog(@":testFinish");
    
    if (isToastVisible || self.hasPausedTest)
        return;
    
    

    //[self displayTestComplete];
    
    //Get Test Results
    TestResult *results = [self compileTestResults];
    
    
    //Rate
    //[[iRate sharedInstance] promptIfNetworkAvailable];
    
    
//    //delay
//    [containVC toHome];
    
    //StartViewController *startVC = (StartViewController *)self.parentViewController.parentViewController;
//    ResultsViewController *resultsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsController"];
//    
//    [self.parentViewController.parentViewController presentViewController:resultsVC animated:YES completion:^{
//        [containVC toHome];
//    }];
//    NSArray *array = [TestResult MR_findAllSortedBy:@"startedDate" ascending:NO];
    
    
    ContainerViewController *containVC = (ContainerViewController *)self.parentViewController;
    [containVC toResult:results];

//    [containVC toResult:[array objectAtIndex:4]];

}





#pragma mark - Pause / Resume Test Methods

- (void)pauseTest{
    NSLog(@"-------Pause Test-------");
    _hasPausedTest = YES;
    
    //Stop Tone Play
    [_player stop];
    [self.playTimer invalidate];
    self.playTimer = nil;
    
    //Stop Pause Timer ??
    [_pauseTimer invalidate];
    _pauseTimer = nil;
    
    
    //Stop Response Timer
    [_responseTimer invalidate];
    _responseTimer = nil;
    
    //[headerLbl.layer removeAllAnimations];
    //[textView.layer removeAllAnimations];

    //didYouHearButton.enabled = NO;
}

- (void)resumeTest{
    
    if (_headphoneLock == NO && _noiseLock == NO && _volumeLock == NO && _earlyLock == NO && _motionLock == NO) {
        NSLog(@"-------Resume Test-------");
        
        
        _hasPausedTest = NO;
        
        
        [self continueStep];
        
        //[self playNextItem];
        //didYouHearButton.enabled = YES;
    }
    
}







//Button Response
- (void)buttonAnimation{
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(didYouHearButton.frame.origin.x,
                                                              didYouHearButton.frame.origin.y,
                                                              didYouHearButton.frame.size.width,
                                                              didYouHearButton.frame.size.height)];
    circle.layer.cornerRadius = didYouHearButton.frame.size.height/2;
    circle.layer.masksToBounds = YES;
    circle.layer.borderWidth = 0;
    
    UIColor *waveColor = [UIColor colorWithRed:3/255.0f green:169/255.0f blue:244/255.0f alpha:1];
    circle.backgroundColor = waveColor;
    [didYouHearButton.superview insertSubview:circle belowSubview:didYouHearButton];
    
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //CGRect frame = CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
        
        CGAffineTransform transform = CGAffineTransformMakeScale(3.5, 3.5);
        circle.transform = transform;
        circle.alpha = 0.1;
        
    } completion:^(BOOL finished) {
        [circle removeFromSuperview];
    }];
    
}

- (void)responsePressed:(BOOL)yes{
    NSLog(@"responsePressed");
    
    if (yes)
        [self buttonAnimation];
    
    delayEnd = CACurrentMediaTime();
    //NSLog(@"Start: %f; End: %f; Duration: %f", delayStart, delayEnd, delayEnd-delayStart);
    
    
    //(Comment below IF statement to disable Early Click Stop)
    //Check if Button is Hit During Pause
    if (self.isPausing && !_isSampleTone) {
        
        //Pause Test
        [self pauseTest];
        
        //Set Flags
        self.isPausing = NO;    //sound silent interval before tone play flag
        self.earlyLock = YES;   //test paused from early hit flag
        
        
        //Vibrate
//        [self vibrate];
//        [self performSelector:@selector(vibrate) withObject:self afterDelay:.5f];
//        [self performSelector:@selector(vibrate) withObject:self afterDelay:1.0f];
        
        
        //1: For Alert and & Restart
        //Display alert
//        [self performSelector:@selector(displayListenAlert) withObject:nil afterDelay:0.25];

        
        //Log the Early Response
        [_test logResponse:NO delayTime:delayEnd-delayStart noiseLevel:noiseLevel beforeTone:YES];
        
        self.earlyLock = NO;
        [self resumeTest];
        
        return;
    }
    
    
    

    
    BOOL response = yes;
    
    //Vibrate on a Yes
//    if (yes) {
//        //[self vibrate];
//        [[NoiseManager sharedInstance] startMeasuring];
//    }
    
    
    if (_isSampleTone){

    }
    

    
    
    
    TestItem *item = _test.items[_currentItemIndex];
    item.response = response;
    
    if (_isSampleTone) {
        NSLog(@"Is Sample Tone: done with test");
        [self doneWithTest];
        return;
    }
    
    
    
    //Log the Response
    [_test logResponse:response delayTime:delayEnd-delayStart noiseLevel:noiseLevel beforeTone:NO];

    
    
    //Advance
    BOOL keepAdvancing = [_test advanceItemWithResponse:response];
    
    if (keepAdvancing) {
        _currentItemIndex++;
        
        
        //_testStep = TestStep_Test;

        
        [self configureInterfaceListening:YES];
        [self playNextItem];
    } else {
        //NSLog(@"Done with test");
        [self doneWithTest];
        didYouHearButton.enabled = NO;
    }
    
}


#pragma mark - IBAction Methods

- (IBAction)soundHeardAction:(id)sender{
    //NSLog(@"sound heard action");
    [self.responseTimer invalidate];
    self.responseTimer = nil;
    
    
    [self responsePressed:YES];
}







#pragma mark AVAudioPlayerDelegate methods
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //NSLog(@"audioPlayerDidFinishPlaying successfully: %d", flag);
    
    
    self.isPlaying = NO;
    
    //[self performSelector:@selector(showUserResponseMode) withObject:nil afterDelay:afterSoundPause];

    
    
//    if (!_isSampleTone){
//        //Wait 1.25 secs for a Response, if None then consider a NO
//        self.responseTimer = [NSTimer scheduledTimerWithTimeInterval:responseWait target:self selector:@selector(responseTimeEnded) userInfo:nil repeats:NO];
//    }
    
    self.responseTimer = [NSTimer scheduledTimerWithTimeInterval:responseWait target:self selector:@selector(responseTimeEnded) userInfo:nil repeats:NO];

}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"audioPlayerDecodeErrorDidOccur: %@", error);
    
}
/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"audioPlayerBeginInterruption");
    
}

/* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    NSLog(@"audioPlayerEndInterruption flags: %lu", (unsigned long)flags);
    
}







#pragma mark - ToastDelegate Methods

- (void)toastInterupt{
    NSLog(@"toastInterupt");
    
    isToastVisible = YES;
    
    [self pauseTest];
}


- (void)toastCompleted{
    NSLog(@"toastCompleted");

    isToastVisible = NO;
    
    [self resumeTest];
}


- (void)toastDidHearTone:(BOOL)answer{
    NSLog(@"TestViewController: didHearToast");
    
    isToastVisible = NO;

    if (answer) {
        //Repeat Same dB
        headerLbl.text = PRETONE_YES_H;
        textView.text = PRETONE_YES_D;
        [self resumeTest];
    }
    else {
        //Report No for Increase
        headerLbl.text = PRETONE_NO_H;
        textView.text = PRETONE_NO_D;
        [self responsePressed:answer];
    }
}


- (void)noiseValue:(float)value{
    noiseLevel = value;
    
}


- (void)sendPause{
    [self pauseTest];
    [self performSelectorOnMainThread:@selector(endMonitoring) withObject:nil waitUntilDone:NO];
    //[ToastManager endToastMonitor];
}


- (void)sendResume{
    [self resumeTest];
    //[ToastManager beginToastMonitor];
    [self performSelectorOnMainThread:@selector(startMonitoring) withObject:nil waitUntilDone:NO];

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




/* *************  TESTING ******************** */

- (void)testPane{
    //TestPane
    CGFloat width = self.view.frame.size.width;
    
    UIView *testPane = [[UIView alloc] initWithFrame:CGRectMake(0, 50, width, 50)];
    testPane.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:testPane];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(5, 10, 30, 30);
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 setTitle:@"N" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(raiseNoiseAlert:) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(45, 10, 30, 30);
    btn2.backgroundColor = [UIColor whiteColor];
    [btn2 setTitle:@"H" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(raiseHeadphonesAlert:) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn2];
    
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn3.frame = CGRectMake(85, 10, 30, 30);
    btn3.backgroundColor = [UIColor whiteColor];
    [btn3 setTitle:@"V" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(raiseVolumeAlert:) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn3];
    
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn4.frame = CGRectMake(125, 10, 30, 30);
    btn4.backgroundColor = [UIColor whiteColor];
    [btn4 setTitle:@"TT" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(raiseDidHearAlert:) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn4];
}


- (IBAction)raiseNoiseAlert:(id)sender{
    [ToastManager simulateNoise];
}

- (IBAction)raiseHeadphonesAlert:(id)sender{
    [ToastManager simulateHeadphones];
}

- (IBAction)raiseVolumeAlert:(id)sender{
    [ToastManager simulateVolume];
}

- (IBAction)raiseDidHearAlert:(id)sender{
    [ToastManager simulateDidHear];
}

/* ******************************************** */


@end
