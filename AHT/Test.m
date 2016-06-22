//
//  Test.m
//  HearingTest
//
//  Created by Martin Ceperley on 6/16/14.
//  Copyright (c) 2014 Knotable. All rights reserved.
//

#import "Test.h"
#import "TestItem.h"
#import "TestManager.h"
#import "AppDelegate.h"
#import "UserDefaultsStore.h"
#import "DataSurrogate.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#define DEBUGTEXT @"\
On Last Response:\n\
\n\
Current dB Level: %@\n\
Detected: %@\n\
"

static int REPEATS_NEEDED = 2;

static int ACCLIM_INCREMENT = 5;

static int TEST_INCREMENT = 10;



static int LOUDEST_DECIBELS = 90;
static int QUIETEST_DECIBELS = 30;  //0





@interface Test ()

@property (nonatomic, assign) BOOL isSampleTest;

@property (nonatomic, strong) NSArray *frequencyNames;



@end


@implementation Test


/* New */

-(id)init{
    if (self = [super init]) {
        self.isSampleTest = NO;
        self.allFrequencies = @[@(1000),@(2000),@(4000),@(8000),@(500)];
//        self.frequencyNames = @[@"1k",@"2k",@"4k",@"8k",@"500"];
        self.frequencyNames = @[@"1000",@"2000",@"4000",@"8000",@"500"];

        self.leftResults = [[NSMutableArray alloc] initWithCapacity:self.allFrequencies.count];
        self.rightResults = [[NSMutableArray alloc] initWithCapacity:self.allFrequencies.count];
        
        self.leftResponses = [[NSMutableDictionary alloc] initWithCapacity:self.allFrequencies.count];
        self.rightResponses = [[NSMutableDictionary alloc] initWithCapacity:self.allFrequencies.count];
        
        self.yesDict = [[NSMutableDictionary alloc] initWithCapacity:self.allFrequencies.count];

        _items = [[NSMutableArray alloc] init];
        
        _currentFrequencyIndex = 0;
        _currentEarLeft = NO;
        //_currentAcclimitization = YES;
        _currentAcclimitization = NO;
        _currentConfirmation = NO;
        _confirmationTry = 0;
        _positiveConfirms = 0;
        _currentDecibels = [TestManager sharedInstance].testToneDecibels;
        _atDecibelLimit = NO;
        _currentItemIndex = 0;
        _leftProgress = 0;
        _rightProgress = 1;
        
        //NSLog(@"Starting Test");
        CONFIRMATION_INCREMENT = 5;
        _is1stNo = YES;
        _hitYes = NO;
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.audio != AudioType_NS_2)
            Increment_Level = IncrementLevel_5;
        else
            Increment_Level = IncrementLevel_2_5;

        
    }
    return self;
}

-(id) initSampleTone
{
    if (self = [super init]) {
        self.isSampleTest = YES;
//        _items = [@[[[TestItem alloc] initWithFrequency:@"1k"
//                                               decibels:[TestManager sharedInstance].testToneDecibels
//                                                   left:YES right:NO]] mutableCopy];
        
        _items = [@[[[TestItem alloc] initWithFrequency:@"1000"
                                               decibels:[TestManager sharedInstance].testToneDecibels
                                                   left:NO right:YES]] mutableCopy];
    }
    return self;
}

-(TestItem *)currentItem
{
    if (_isSampleTest) {
        return _items[0];
    }
    
    float decibels = _currentDecibels;
    
    
    BOOL left, right;
    if (_currentAcclimitization) {
        //left = right = YES;
        left = YES;
        right = NO;
    } else {
        left = _currentEarLeft;
        right = !_currentEarLeft;
    }
    
    TestItem *item = [[TestItem alloc] initWithFrequency:_frequencyNames[_currentFrequencyIndex]
                                                 decibels:decibels
                                                    left:left right:right];
    
    NSLog(@"Playing tone: %@ %f %d", _allFrequencies[_currentFrequencyIndex], _currentDecibels, _currentEarLeft);

    if (_items.count < _currentItemIndex + 1) {
        [_items addObject:item];
    }
    return item;
}

-(void)saveCurrentResult
{
    if (_currentAcclimitization) {
        return;
    }
    
    NSMutableArray *resultArray = _currentEarLeft ? _leftResults : _rightResults;
    float result = [Test resultDecibelFromTestDecibel:_currentDecibels];
    //NSLog(@"Saving result for hz %@ db: %f ear: %d", _allFrequencies[_currentFrequencyIndex], _currentDecibels, _currentEarLeft);
    //NSLog(@"Actually saving: %f", result);
    [resultArray addObject:@(result)];
}



//never used
-(void)acclimitizationResponse:(BOOL)response
{
    if (!response) {
        //Need to keep acclimating with -5 db
        if (_currentDecibels == 0) {
            //already at 0, record response
            response = YES;
        } else {
            _currentDecibels -= ACCLIM_INCREMENT;
        }
    }
    
}



-(BOOL)startConfirmation{
    //NSLog(@"Mode - #3");
    
    if (!_hitYes) {
        CONFIRMATION_INCREMENT = 10;
    }
    else {
        CONFIRMATION_INCREMENT = 5;
        
        
        
        

    }
    
    //AudioType_NS_2 -> IncrementLevel_2_5
    if (Increment_Level == IncrementLevel_2_5 && _is1stNo == YES) {
        _is1stNo = NO;
    }
    else if (Increment_Level == IncrementLevel_2_5 && _is1stNo == NO) {
        CONFIRMATION_INCREMENT = 2.5;
    }
    
    
    

    //Attemp to Move up to next dB Level
    if (_currentDecibels < LOUDEST_DECIBELS ) {
        
        //attempt Increment
        _currentDecibels += CONFIRMATION_INCREMENT;

        if (_currentDecibels > LOUDEST_DECIBELS) {
            //Make Ceiling
            _currentDecibels = LOUDEST_DECIBELS;
        }
        
        //NSLog(@"confirming at decibels: %f", _currentDecibels);
        _currentAcclimitization = NO;
        _currentConfirmation = YES;
        return YES;
    }
    
    
    
    else {
        //At Loudest
        //NSLog(@"already at loudest, user is deaf");
        
        NSArray *dBArray = [self noteYesFordB:_currentDecibels];
        
        //check for repeat count
        if (dBArray.count < REPEATS_NEEDED) {
            return YES;
        }
        else {
            return [self finishedConfirmation];
        }
    }
    

}

-(BOOL)finishedConfirmation
{
    //NSLog(@"CONFIRMED at %f", _currentDecibels);
//    NSLog(@"-----------------------------------------");
//    NSLog(@" ");
//    NSLog(@"CONFIRMED FREQ: %@; Ear: %@", _allFrequencies[_currentFrequencyIndex], _currentEarLeft ? @"Left" : @"Right");
//    NSLog(@" ");
//    NSLog(@"-----------------------------------------");
    
    //Analytics
    //Google
    NSString *freq = [NSString stringWithFormat:@"%@_%@", _allFrequencies[_currentFrequencyIndex], _currentEarLeft ? @"L" : @"R"];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"hearing_test"     // Event category (required)
                                                          action:@"frequency_completion"  // Event action (required)
                                                           label:freq          // Event label
                                                           value:nil] build]];    // Event value
    
    //FB
    [FBSDKAppEvents logEvent:@"Hearing_Test" parameters:@{@"Frequency":freq}];
    
    
    [self saveCurrentResult];
    
    self.yesDict = [[NSMutableDictionary alloc] initWithCapacity:self.allFrequencies.count];
    
    
    //Reset CONFIRMATION_INCREMENT = 5
    CONFIRMATION_INCREMENT = 5;
    _is1stNo = YES;
    _hitYes = NO;
    
    
    if (!_currentEarLeft) {
        _currentAcclimitization = NO;
        _currentConfirmation = NO;
        _confirmationTry = 0;
        _positiveConfirms = 0;
        _currentDecibels = [TestManager sharedInstance].testToneDecibels;

        
        if (_currentFrequencyIndex+1 < _allFrequencies.count) {
            //Move on to next frequency, Stay Right Ear
            _currentFrequencyIndex++;
            _rightProgress++;
        }
        else {
            //Go back to 1st frequency, Move to Left Ear
            _currentFrequencyIndex = 0;
            _currentEarLeft = YES;
            _leftProgress++;
        }
        
    } else {
        _currentAcclimitization = NO;
        _currentConfirmation = NO;
        _confirmationTry = 0;
        _positiveConfirms = 0;
        _currentDecibels = [TestManager sharedInstance].testToneDecibels;
        
        
        if (_currentFrequencyIndex+1 < _allFrequencies.count) {
            //Move on to next frequency, Stay Left Ear
            _currentFrequencyIndex++;
            _leftProgress++;
        }
        else {
            //Done with test
            return NO;
        }
    }
    
    
    return YES;
}






-(BOOL)regularTestValue:(BOOL)response
{
    //NSLog(@"REGULAR TEST");
    if (response) {
        //NSLog(@"Mode - #2");
        
        //play quieter
        if (_currentDecibels - TEST_INCREMENT >= QUIETEST_DECIBELS) {
            //NSLog(@"go quieter (-10)");
            
            //Advance decibel quieter
            _currentDecibels -= TEST_INCREMENT;
            return YES;
        }
        else if (_currentDecibels - (TEST_INCREMENT - 5) >= QUIETEST_DECIBELS) {
            //NSLog(@"go quieter (-5)");
            
            //Advance decibel quieter
            _currentDecibels -= (TEST_INCREMENT - 5);
            return YES;
        }
        
        else if ((Increment_Level == IncrementLevel_2_5) && _currentDecibels - (TEST_INCREMENT - 5 - 2.5) >= QUIETEST_DECIBELS) {
            //NSLog(@"go quieter (-2.5)");
            
            //Advance decibel quieter
            _currentDecibels -= (TEST_INCREMENT - 5 - 2.5);
            return YES;
        }
        
        else {
            //NSLog(@"already at quietest");
            
            //Already at quietest, perfect hearing!
            //return [self finishedConfirmation];
            
            NSArray *dBArray = [self noteYesFordB:_currentDecibels];
            
            //check for repeat count
            if (dBArray.count < REPEATS_NEEDED) {
                return YES;
            }
            else {
                return [self finishedConfirmation];
            }
        }
        
    }
    
    else {
        //NSLog(@"goto mode - #3");
        //start confirmation (louder) at slightly higher level
        return [self startConfirmation];
    }
}


-(BOOL)advanceItemWithResponse:(BOOL)response
{
    
    //log response (moved to TakeTestController)
    //[self logResponse:response beforeTone:NO];
    if (response)
        _hitYes = YES;

    
    //returns YES to keep advancing, NO indicates End of Test
    BOOL keepAdvancing = YES;
    
    if (!_currentAcclimitization && !_currentConfirmation) {
        //Regular test, look for no value
        //NSLog(@"regular test mode");
        
        keepAdvancing = [self regularTestValue:response];
    }
    
    //_currentAcclimitization is turned Off now (this never hits)
    else if (_currentAcclimitization) {
        //NSLog(@"acclimitization mode");
        
        //Acclimitizing
        if (response) {
            //Ended
            //Move to regular test
            //NSLog(@"ending acclimitization mode");
            //NSLog(@"regular test mode");
            
            _currentAcclimitization = NO;
            keepAdvancing = [self regularTestValue:response];
            
        }
        else {
            //Acclimitizing
//            if (_currentDecibels < ACCLIM_INCREMENT) {
            if (_currentDecibels == LOUDEST_DECIBELS) {

                //Already at loudest
                //NSLog(@"ending acclimitization mode, already loudest");
                
                _currentAcclimitization = NO;
            } else {
                //NSLog(@"acclimitzation mode increasing loudness");
                
                _currentDecibels += ACCLIM_INCREMENT;
            }
        }
        
    }
    
    else {
        //Confirming
        //NSLog(@"-------------Confirming------------");
        _currentConfirmation = NO;
        
        if (!response) {
            //A NO, so confirm again at +5 db
            //NSLog(@"NOTE NO");

            keepAdvancing = [self startConfirmation];
        }
        
        else {
            
            //Note YES
            NSArray *dBArray = [self noteYesFordB:_currentDecibels];
            
            //check for repeat count
            if (dBArray.count < REPEATS_NEEDED) {
                NSLog(@"goto mode - #2");
                keepAdvancing = [self regularTestValue:response];
            }
            else {
                keepAdvancing = [self finishedConfirmation];
            }
            
        }
        
    }

    
    _currentItemIndex++;
    
//    NSLog(@"Advance to next index: %d hz %@ db %f ear %d acclim %d confirming %d",
//          _currentItemIndex, _allFrequencies[_currentFrequencyIndex], _currentDecibels, _currentEarLeft, _currentAcclimitization, _currentConfirmation);
    
    return keepAdvancing;
}



- (void)logResponse:(BOOL)response delayTime:(CFTimeInterval)delay noiseLevel:(float)noise beforeTone:(BOOL)before{
    NSMutableDictionary *respDict = _currentEarLeft ? _leftResponses : _rightResponses;
    
    //find hertz array
    NSString *key = _frequencyNames[_currentFrequencyIndex];
    NSMutableArray *hertzArray = [respDict objectForKey:key];
    if (!hertzArray) {
        hertzArray = [[NSMutableArray alloc] init];
    }
    

    //Add Answer to Array
    //NSString *dB = [[NSNumber numberWithInt:_currentDecibels] stringValue];
    NSString *dB;
    if (floor(_currentDecibels) == _currentDecibels)
        dB = [NSString stringWithFormat:@"%.f", _currentDecibels];
    else
        dB = [NSString stringWithFormat:@"%.01f", _currentDecibels];
    
    NSString *ans;
    
    //If YES answer
    if (response == YES) {
        ans = @"y";
    }
    
    else {
        ans = @"n";

        if (before)
            ans = @"E";
        
        else if (noise > [[DataSurrogate sharedInstance] threshold]) {
            ans = @"X";
        }
    }
    
    
    [hertzArray addObject:[NSString stringWithFormat:@"%@,%@,%.01f,%.02f", dB, ans, noise, delay]];
    
    //Save Array back to Dict
    [respDict setObject:hertzArray forKey:key];
    
    //NSLog(@"Response Dictionary: %@", respDict);
    //NSLog(@"Delay Time: %.02f", delay);
    
    
//    NSLog(@"db: %@", dB);
//    NSLog(@"dB: %f", _currentDecibels);
//    NSLog(@"key: %@", key);
    NSLog(@"answer: %@", [NSString stringWithFormat:@"%@,%@,%.01f,%.02f", dB, ans, noise, delay]);
    
//
//    NSLog(@"Keys: %@", [respDict allKeys]);
//    
//    if ([key isEqualToString:@"1000"]) {
//        NSLog(@"KEY's are EQUAL");
//    }
//    else
//        NSLog(@"Keys are not equal");
    
//    //Debug Log Out
//    if (self.delegate) {
//        [self.delegate logOutput:[NSString stringWithFormat:DEBUGTEXT, dB, ans]];
//    }
}


- (NSArray *)noteYesFordB:(float)db{
    //NSLog(@"NOTE YES");
    
    //Reset CONFIRMATION_INCREMENT = 5
    CONFIRMATION_INCREMENT = 5;
    _is1stNo = YES;
    //_hitYes = NO;
    
    
    //find dB array
    //NSString *key = [[NSNumber numberWithInt:_currentDecibels] stringValue];
    NSString *key;
    if (floor(_currentDecibels) == _currentDecibels)
        key = [NSString stringWithFormat:@"%.f", _currentDecibels];
    else
        key = [NSString stringWithFormat:@"%.01f", _currentDecibels];
    
    NSMutableArray *dBArray = [_yesDict objectForKey:key];
    if (!dBArray) {
        dBArray = [[NSMutableArray alloc] init];
    }
    
    //Add YES to Array
    [dBArray addObject:@"yes"];
    
    //Save Array back to Dict
    [_yesDict setObject:dBArray forKey:key];
    
    NSLog(@"Yes Dictionary: %@", _yesDict);
    
    return dBArray;
}




- (void)test{
    NSLog(@"1000: %@", [_leftResponses objectForKey:@"1000"]);
    NSLog(@"500: %@", [_leftResponses objectForKey:@"500"]);
    NSLog(@"-----------------");

    //NSLog(@"Keys: %@", [_leftResponses allKeys]);
    for (NSString *key in [_leftResponses allKeys]) {
        NSLog(@"key: %@", key);
        NSLog(@"array: %@", [_leftResponses objectForKey:key]);
        NSLog(@"-----------------");
    }
}





+(float)resultDecibelFromTestDecibel:(float)db{
    //return QUIETEST_DECIBELS - db;
    //tmd add
    //return db - 5;
    return db;
}


-(void)gradeResults
{
    int completed = 0;
    int correct = 0;
    int incorrect = 0;
    
    double totalNoiseLevel = 0.0;

    for (TestItem *item in _items) {
        if (item.responded) {
            completed++;
            if (item.correct) {
                correct++;
            } else {
                incorrect++;
            }
            totalNoiseLevel += item.noiseLevel;
        }
    }
    
    _noiseLevel = (float)totalNoiseLevel / (float)_items.count;
    _completed = completed;
    _correct = correct;
    _incorrect = incorrect;
    _graded = YES;
    
    //_ratio = (float)_correct/(float)_items.count;
    NSArray *combinedResults = [_leftResults arrayByAddingObjectsFromArray:_rightResults];
    
    int total = 0;
    for (NSNumber *db in combinedResults) {
        total += db.intValue;
    }
    
    float average = (float)total / (float)combinedResults.count / (float)QUIETEST_DECIBELS;
    
    float correctAverage = 1.0 - average;
    
    _ratio = correctAverage;
    
    
    
//    NSLog(@"Left Results: %@", _leftResults);
//    NSLog(@"Right Results: %@", _rightResults);
//    NSLog(@"Combined Results: %@", combinedResults);
    
    //NSLog(@"Ratio: %f", _ratio);
//    NSLog(@"Left Responses: %@", _leftResponses);
//    NSLog(@"Right Responses: %@", _rightResponses);

}




-(void)fakeResults{
    //Right
    for (int i=0; i<_allFrequencies.count; i++) {
        [_rightResults addObject:@(0)];
    }
    
    //Left
    for (int i=0; i<_allFrequencies.count; i++) {
        [_leftResults addObject:@(0)];
    }
    
    
    _rightResponses = [[[UserDefaultsStore shared] rightResponses] mutableCopy];
    _leftResponses = [[[UserDefaultsStore shared] leftResponses] mutableCopy];

}




@end
