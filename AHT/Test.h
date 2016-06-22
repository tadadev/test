//
//  Test.h
//  HearingTest
//
//  Created by Martin Ceperley on 6/16/14.
//  Copyright (c) 2014 Knotable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol TestLoggerDelegate <NSObject>
@optional
- (void)logOutput:(NSString *)log;
@end




@class TestItem;

@interface Test : NSObject {
    float CONFIRMATION_INCREMENT;
    IncrementLevel Increment_Level;
}

@property (nonatomic, readonly) NSMutableArray *items;

@property (nonatomic, strong) NSMutableArray *leftResults;
@property (nonatomic, strong) NSMutableArray *rightResults;
//@property (nonatomic, strong) NSMutableArray *leftAnswers, *rightAnswers;
@property (nonatomic, strong) NSMutableDictionary *leftResponses, *rightResponses;
@property (nonatomic, strong) NSMutableDictionary *yesDict;

@property (nonatomic, strong) NSArray *allFrequencies;

@property (nonatomic) BOOL graded;
@property (nonatomic) int completed;
@property (nonatomic) int correct;
@property (nonatomic ) int incorrect;
@property (nonatomic ) float ratio;
@property (nonatomic ) float noiseLevel;

@property (nonatomic ) BOOL currentAcclimitization;
@property (nonatomic ) BOOL currentConfirmation;


@property (nonatomic, assign) int leftProgress;
@property (nonatomic, assign) int rightProgress;

@property (nonatomic, assign) int currentItemIndex;
@property (nonatomic, assign) int currentFrequencyIndex;
@property (nonatomic, assign) float currentDecibels;
@property (nonatomic, assign) BOOL currentEarLeft;
@property (nonatomic, assign) BOOL atDecibelLimit;

@property (nonatomic, assign) int confirmationTry;
@property (nonatomic, assign) int positiveConfirms;

@property (nonatomic, assign) BOOL is1stNo, hitYes;

@property (nonatomic, weak) id<TestLoggerDelegate> delegate;


-(id)initSampleTone;
-(void)gradeResults;

-(TestItem *)currentItem;
-(BOOL)advanceItemWithResponse:(BOOL)response;
//- (void)logResponse:(BOOL)response beforeTone:(BOOL)before;
//- (void)logResponse:(BOOL)response noiseLevel:(float)noise beforeTone:(BOOL)before;
- (void)logResponse:(BOOL)response delayTime:(CFTimeInterval)delay noiseLevel:(float)noise beforeTone:(BOOL)before;

+(float)resultDecibelFromTestDecibel:(float)db;

- (void)test;


-(void)fakeResults;

@end
