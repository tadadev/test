//
//  Constants.h
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#ifndef AHT_Constants_h
#define AHT_Constants_h

#define SegueIdentifierHome @"homeSegue"
#define SegueIdentifierTest @"testSegue"
#define SegueIdentifierResultsList @"resultsListSegue"
#define SegueIdentifierResult @"resultSegue"
#define SegueIdentifierContact @"contactSegue"


#define SegueIdentifierResults @"resultstSegue" //OLD


#define PHONENUMBER @"888-979-6918"
#define MAILCHIMP_LIST @"7f694704ff"
#define MAILCHIMP_GROUPING @"Groups"
#define MAILCHIMP_GRP_NAME1 @"Mobile App."

#define CAMPAIGN_MON_API @"8481418a9bbd798fa1af7a7d15664d08"
#define CAMPAIGN_MON_LIST @"d7875206c917ceed3d61f446e388a55d"
#define CAMPAIGN_MON_GRP @"Mobile App."



static float QUIET_THRESHOLD = -37.0;   //=30.0

static NSTimeInterval ANIMATION_SLIDE = 0.8;
static NSTimeInterval READ_PACE = 3.5;  //3.0
static NSTimeInterval RESUME_PACE = 3.5;  //3.0

static NSString *VOLUME_PROPERTY = @"AVSystemController_AudioVolumeNotificationParameter";

static NSString *INSTRUCTION1_H = @"Instructions";
static NSString *INSTRUCTION1_D = @"Taking the Audicus hearing test is easy.  Simply tap the button when you hear a tone.";

static NSString *INSTRUCTION2_H = @"Let's Try It";
static NSString *INSTRUCTION2_D = @"We are about to play an audio tone.\nWhen you hear a tone, tap the button.";

static NSString *PRETONE_NO_H = @"A little louder";
static NSString *PRETONE_NO_D = @"This time the audio tone will be louder.\nWhen you hear the tone, tap the button.";

static NSString *PRETONE_YES_H = @"Let's try again";
static NSString *PRETONE_YES_D = @"We will play the audio tone again for you.\nWhen you hear the tone, tap the button.";

static NSString *PRETEST_CONFIRMATION_H = @"Perfect";
static NSString *PRETEST_CONFIRMATION_D = @"\nYou're ready to start the test.";

//static NSString *PRETEST_COUNTDOWN1 = @"The test will start in\n\n3... 2... 1... Begin!";
static NSString *PRETEST_COUNTDOWN_D = @"";


static NSString *TEST_INPROGRESS_RIGHT_H = @"Right Ear";
static NSString *TEST_INPROGRESS_RIGHT_D = @"Now playing audio tones\nin your right ear.\nWhen you hear a tone,\ntap the button.";

static NSString *TEST_INPROGRESS_LEFT_H = @"Left Ear";
static NSString *TEST_INPROGRESS_LEFT_D = @"Now playing audio tones\nin your left ear.\nWhen you hear a tone,\ntap the button.";

static NSString *TEST_COMPLETE = @"That's it!  The test is complete.\n\nCalculating results...";


//static NSString *EMAIL_TEXT = @"Great job on taking the Audicus Hearing Test!\nEnter your Email to receive a detailed summary of your test results.\nBy clicking submit, you agree to Audicus' Terms of Service.";
static NSString *EMAIL_TEXT = @"Receive your full, detailed results by Email.  By tapping Submit, you agree to Audicus' Terms of Use.";


static NSString *EMAIL_CONFIRMATION = @"An email with your official test results has been sent.\n\nCheck your email to view your full test results, and to browse Audicus' award-winning hearing aids.";

static NSString *EMAIL_ERROR = @"The email address you entered is not valid.  Please enter a valid email address.";
static NSString *EMAIL_NETWORK_ERROR = @"There was a network error.  Please try entering your email address again.";


static NSString *TOAST_NOISE_H = @"Too Noisy";
static NSString *TOAST_NOISE_D = @"Please move to a quieter place to ensure test accuracy.";

static NSString *TOAST_HEADPHONE_H = @"Headphones";
static NSString *TOAST_HEADPHONE_D = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do";

static NSString *TOAST_VOLUME_H = @"Volume";
static NSString *TOAST_VOLUME_D = @"For the most accurate test results, we need the highest possible value.  Please set your volume to the maximum.";

static NSString *TOAST_THANKS_H = @"Thanks!";
static NSString *TOAST_THANKS_D = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do";

static NSString *TOAST_DIDHEAR_H = @"Uhm, hello?";
static NSString *TOAST_DIDHEAR_D = @"We played the audio tone but we didn't register you tapping the button.\nDid you hear the tone?";

static NSString *RESULTS_EMPTY = @"No test results to show yet. Take your first test by accessing the home screen.";
static NSString *RESULTS_LIST = @"Touch any of your test results below for more details.";




CGFloat static const kJBBarChartViewStateAnimationDuration = 0.55f;



typedef NS_ENUM(NSInteger, AudioType) {
    AudioType_MC5_1 = 0,
    AudioType_MC5_2  = 1,
    AudioType_MC5_3  = 2,
    AudioType_HF5_1  = 3,
    AudioType_MC5_1_HA2Cal  = 4,
    AudioType_NS_1          = 5,
    AudioType_NS_2          = 6
};


typedef NS_ENUM(NSInteger, IncrementLevel) {
    IncrementLevel_5        = 0,
    IncrementLevel_2_5      = 1
};


typedef NS_ENUM(NSInteger, ThresholdLvl) {
    ThresholdLvl_37        = 0,
    ThresholdLvl_35        = 1,
    ThresholdLvl_40        = 2,
    ThresholdLvl_45        = 3
};


typedef NS_ENUM(NSInteger, ToastAlert) {
    ToastAlertHelpConfirm   = 1,
    ToastAlertNoise         = 2,
    ToastAlertHeadphone     = 3,
    ToastAlertVolume        = 4,
    ToastAlertNoiseConfirm  = 5,
    ToastAlertHeadphoneConfirm = 6,
    ToastAlertVolumeConfirm  = 7,
    ToastAlertDidHear       = 8,
    ToastAlertTapForEmail   = 9
};



typedef NS_ENUM(NSInteger, TestStep) {
    TestStep_Instr1             = 0,
    TestStep_Instr2             = 1,
    TestStep_PreToneConfirm     = 2,
    TestStep_Countdown          = 3,
    TestStep_TestStart          = 4,
    TestStep_Test               = 5,
    TestStep_TestComplete       = 6
};


typedef NS_ENUM(NSInteger, PDFLabel) {
    PDFLabel_LowFreq        = 0,
    PDFLabel_LowResults     = 1,
    PDFLabel_LowLeft        = 2,
    PDFLabel_LowRight       = 3,
    PDFLabel_LowLeftPct     = 4,
    PDFLabel_LowRightPct    = 5,
    PDFLabel_LowDetail      = 6,
    
    PDFLabel_MidFreq        = 22,
    PDFLabel_MidResults     = 23,
    PDFLabel_MidLeft        = 24,
    PDFLabel_MidRight       = 25,
    PDFLabel_MidLeftPct     = 26,
    PDFLabel_MidRightPct    = 27,
    PDFLabel_MidDetail      = 28,
    
    PDFLabel_HighFreq       = 29,
    PDFLabel_HighResults    = 30,
    PDFLabel_HighLeft       = 31,
    PDFLabel_HighRight      = 32,
    PDFLabel_HighLeftPct    = 33,
    PDFLabel_HighRightPct   = 34,
    PDFLabel_HighDetail     = 35,
    
    PDFLabel_Overview_High  = 36,
    PDFLabel_Overview_Mid  = 37,
    PDFLabel_Overview_Low  = 38
};


#endif
