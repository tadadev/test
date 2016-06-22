//
//  DataSurrogate.h
//  HearingTest
//
//  Created by TROY DEMAR on 1/22/15.
//  Copyright (c) 2015 Knotable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestResult.h"

@interface DataSurrogate : NSObject

+ (DataSurrogate *)sharedInstance;


- (float)threshold;
- (NSString *)thresholdString;

- (float)lowFrequencyScoreFromResults:(TestResult *)result forLeftEar:(BOOL)left;
- (float)medFrequencyScoreFromResults:(TestResult *)result forLeftEar:(BOOL)left;
- (float)highFrequencyScoreFromResults:(TestResult *)result forLeftEar:(BOOL)left;

//v1
- (NSString *)scoreFromResults:(TestResult *)result;
- (NSString *)scoreDescriptionFromResults:(TestResult *)result;

//v2
- (NSString *)lowestScoreFromResults:(TestResult *)result;
- (NSMutableAttributedString *)lowestScoreDescriptionFromResults:(TestResult *)result;
- (NSString *)lowFreqTextFromResults:(TestResult *)result;
- (NSString *)medFreqTextFromResults:(TestResult *)result;
- (NSString *)highFreqTextFromResults:(TestResult *)result;

+ (void)emailTextForResult:(TestResult *)result;


- (void)generatePDFfromResults:(TestResult *)result;
+ (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;
//+ (void)drawText:(NSString*)textToDraw withFont:(UIFont *)font inFrame:(CGRect)frameRect;
+ (void)drawText:(NSAttributedString *)attrString inFrame:(CGRect)frameRect;
@end
