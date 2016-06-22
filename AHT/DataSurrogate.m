//
//  DataSurrogate.m
//  HearingTest
//
//  Created by TROY DEMAR on 1/22/15.
//  Copyright (c) 2015 Knotable. All rights reserved.
//

#import "DataSurrogate.h"
#import "AppDelegate.h"
#import "PDFView.h"
#import "PNCircleChart.h"
#import <CoreText/CoreText.h>

static DataSurrogate *sharedDataSurrogate = nil;


@implementation DataSurrogate


+ (DataSurrogate *)sharedInstance{
    if (sharedDataSurrogate == nil) {
        sharedDataSurrogate = [[super allocWithZone:NULL] init];
    }
    return sharedDataSurrogate;
}


- (id)init{
	
	if (self = [super init]) {

	}
	
	return self;
}


- (float)threshold{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (del.threshold == ThresholdLvl_35) {
        return -35.0f;
    }
    else if (del.threshold == ThresholdLvl_37) {
        return -37.0f;
    }
    
    else if (del.threshold == ThresholdLvl_40) {
        return -40.0f;
    }
    
    else if (del.threshold == ThresholdLvl_45) {
        return -45.0f;
    }
    
    return -37.0f;
}

- (NSString *)thresholdString{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (del.threshold == ThresholdLvl_35) {
        return @"35";
    }
    else if (del.threshold == ThresholdLvl_37) {
        return @"37";
    }
    
    else if (del.threshold == ThresholdLvl_40) {
        return @"40";
    }
    
    else if (del.threshold == ThresholdLvl_45) {
        return @"45";
    }
    
    return @"37";;
}


- (float)lowFrequencyScoreFromResults:(TestResult *)result forLeftEar:(BOOL)left{
    //left = TRUE --> Left Ear
    //left = FALSE --> Right Ear
    //Freqs: 500 | 1000 | 2000 | 4000 | 8000
    NSArray *lefts = [result.leftResults componentsSeparatedByString:@"|"];
    NSArray *rights = [result.rightResults componentsSeparatedByString:@"|"];
    
    NSArray *ear = left==YES ? lefts : rights;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *dbNumber = [formatter numberFromString:ear[0]];
    
    NSLog(@"Ear[0]: %@:", ear[0]);
    
    NSLog(@"Low Freq Score: %f", 1 - (([dbNumber floatValue] - 30) / 60));
    return 1 - (([dbNumber floatValue] - 30) / 60);
}

- (float)medFrequencyScoreFromResults:(TestResult *)result forLeftEar:(BOOL)left{
    //left = TRUE --> Left Ear
    //left = FALSE --> Right Ear
    //Freqs: 500 | 1000 | 2000 | 4000 | 8000
    NSArray *lefts = [result.leftResults componentsSeparatedByString:@"|"];
    NSArray *rights = [result.rightResults componentsSeparatedByString:@"|"];
    
    NSArray *ear = left==YES ? lefts : rights;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *dbNumber1 = [formatter numberFromString:ear[1]];
    NSNumber *dbNumber2 = [formatter numberFromString:ear[2]];

    float db1 = [dbNumber1 floatValue];
    float db2 = [dbNumber2 floatValue];
    float temp = (db1+db2)/2;
    
    return 1 - ((temp-30)/60);
}

- (float)highFrequencyScoreFromResults:(TestResult *)result forLeftEar:(BOOL)left{
    //left = TRUE --> Left Ear
    //left = FALSE --> Right Ear
    //Freqs: 500 | 1000 | 2000 | 4000 | 8000
    NSArray *lefts = [result.leftResults componentsSeparatedByString:@"|"];
    NSArray *rights = [result.rightResults componentsSeparatedByString:@"|"];
    
    NSArray *ear = left==YES ? lefts : rights;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *dbNumber1 = [formatter numberFromString:ear[3]];
    NSNumber *dbNumber2 = [formatter numberFromString:ear[4]];
    
    float db1 = [dbNumber1 floatValue];
    float db2 = [dbNumber2 floatValue];
    float temp = (db1+db2)/2;

    return 1 - ((temp-30)/60);
}


//v1
- (float)avgScoreFromResults:(TestResult *)result{
    float leftLow = [self lowFrequencyScoreFromResults:result forLeftEar:YES];
    float rightLow = [self lowFrequencyScoreFromResults:result forLeftEar:NO];
    
    float leftMid = [self medFrequencyScoreFromResults:result forLeftEar:YES];
    float rightMid = [self medFrequencyScoreFromResults:result forLeftEar:NO];
    
    float leftHigh = [self highFrequencyScoreFromResults:result forLeftEar:YES];
    float rightHigh = [self highFrequencyScoreFromResults:result forLeftEar:NO];
    
    
    float avg = (leftLow+rightLow + leftMid+rightMid + leftHigh+rightHigh)/6;
    avg = avg * 100;
    
    return avg;
}

- (NSString *)scoreFromResults:(TestResult *)result{
    
    float avg = [self avgScoreFromResults:result];
    NSLog(@"Average: %f", avg);
    
    NSString *score;
    if (avg < 20.0f) {
        score = @"Profound";
    }
    else if (avg >= 20.0f && avg < 40.f) {
        score = @"Severe";
    }
    else if (avg >= 40.0f && avg < 60.f) {
        score = @"Moderate";
    }
    else if (avg >= 60.0f && avg < 80.f) {
        score = @"Mild";
    }
    else {
        score = @"Normal";
    }
    
    
    return score;
}

- (NSString *)scoreDescriptionFromResults:(TestResult *)result{
    float avg = [self avgScoreFromResults:result];
    NSLog(@"Average: %f", avg);
    
    NSString *description;
    if (avg < 20.0f) {
        description = @"With a profound score, we highly encourage you to schedule a hearing test with an audiologist.";
    }
    else if (avg >= 20.0f && avg < 40.f) {
        description = @"With a severe score, we encourage you to schedule a hearing test with an audiologist.";
    }
    else if (avg >= 40.0f && avg < 60.f) {
        description = @"With a moderate score, conversation will become challenging even in the absence of background noise. You should consider scheduling a hearing test with an audiologist.";
    }
    else if (avg >= 60.0f && avg < 80.f) {
        description = @"With a mild score, you may miss the softer consonant sounds like s, t, th, and f. Hearing becomes even more difficult in the presence of background noise.";
    }
    else {
        description = @"Not much to worry about.";
    }
    
    return description;
}



//v2
- (float)avgLeftScoreFromResults:(TestResult *)result{
    float leftLow = [self lowFrequencyScoreFromResults:result forLeftEar:YES];
    float leftMid = [self medFrequencyScoreFromResults:result forLeftEar:YES];
    float leftHigh = [self highFrequencyScoreFromResults:result forLeftEar:YES];

    float avg = (leftLow + leftMid + leftHigh)/3;
    avg = avg * 100;
    //NSLog(@"Left Avg: %f", avg);
    
    return avg;
}

- (float)avgRightScoreFromResults:(TestResult *)result{
    float rightLow = [self lowFrequencyScoreFromResults:result forLeftEar:NO];
    float rightMid = [self medFrequencyScoreFromResults:result forLeftEar:NO];
    float rightHigh = [self highFrequencyScoreFromResults:result forLeftEar:NO];
    
    float avg = (rightLow + rightMid + rightHigh)/3;
    avg = avg * 100;
    //NSLog(@"Right Avg: %f", avg);

    return avg;
}

- (NSString *)lowestScoreFromResults:(TestResult *)result{
    float left = [self avgLeftScoreFromResults:result];
    float right = [self avgRightScoreFromResults:result];
    float lowest;
    
    if (left <= right)
        lowest = left;
    else
        lowest = right;
    
//    lowest = 50.0F;
    
    NSString *score;
    if (lowest < 40.0f) {
        //score = @"SEVERE(4) OR PROFOUND(5)";
        score = @"SEVERE OR PROFOUND";
    }
    
    else if (lowest >= 40.0f && lowest < 80.f) {
        //score = @"MILD(2) OR MODERATE(3)";
        score = @"MILD OR MODERATE";
    }

    else {
        //score = @"NORMAL(1)";
        score = @"NORMAL";
    }
    
    return score;
}

- (NSMutableAttributedString *)lowestScoreDescriptionFromResults:(TestResult *)result{
    float left = [self avgLeftScoreFromResults:result];
    float right = [self avgRightScoreFromResults:result];
    float lowest;
    
    if (left <= right)
        lowest = left;
    else
        lowest = right;
    
//    lowest = 30.0F;
    
    
    NSString *string2 = @"Swipe left";
    NSString *string3 = @" to learn in more detail how you performed at low, medium and high pitches and the potential implications for your day-to-day life.";
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:string2
                                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                                                                                NSFontAttributeName: [UIFont fontWithName:@"Roboto-Bold" size:18],
                                                                                                NSParagraphStyleAttributeName: paragraphStyle}];
    
    NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:string3
                                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                                                                                NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:18],
                                                                                                NSParagraphStyleAttributeName: paragraphStyle}];
    
    if (lowest < 40.0f) {
        //Severe of Profound
        NSString *string1 = @"Your Audicus score suggests low hearing capabilities.\nSpeech and a broad range of environmental sounds may be increasingly difficult to hear. \n\nConsider visiting a hearing healthcare specialist to fully evaluate your hearing\n\n";

        NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:string1
                                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                                                                                    NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:18],
                                                                                                    NSParagraphStyleAttributeName: paragraphStyle}];
        
        
        [attString1 appendAttributedString:attString2];
        [attString1 appendAttributedString:attString3];
        
        return attString1;
    }
    
    else if (lowest >= 40.0f && lowest < 80.f) {
        //Mild or Moderate
        NSString *string1 = @"Your Audicus score suggests moderate to decent hearing capabilities.\nSpeech in noisy environments and a range of environmental sounds may be increasingly difficult to hear.\n\nConsider visiting a hearing healthcare specialist to fully evaluate your hearing.\n\n";

        NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:string1
                                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                                                                                    NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:18],
                                                                                                    NSParagraphStyleAttributeName: paragraphStyle}];
        
        
        [attString1 appendAttributedString:attString2];
        [attString1 appendAttributedString:attString3];
        
        return attString1;
    }
    
    else {
        //Nomal
        NSString *string1 = @"Your Audicus Hearing Test indicates you have normal hearing!\n\n";

        NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:string1
                                                                                    attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                                                                                 NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:18],
                                                                                                 NSParagraphStyleAttributeName: paragraphStyle}];
        
        
        [attString1 appendAttributedString:attString2];
        [attString1 appendAttributedString:attString3];
        
        return attString1;
    }
}


- (NSString *)lowFreqTextFromResults:(TestResult *)result{
    float leftLow = [self lowFrequencyScoreFromResults:result forLeftEar:YES] * 100;
    float rightLow = [self lowFrequencyScoreFromResults:result forLeftEar:NO] * 100;

    float lowest;
    
    if (leftLow <= rightLow)
        lowest = leftLow;
    else
        lowest = rightLow;
    
//    lowest = 50;
    
    NSString *text;
    if (lowest < 40.0f) {
        //Severe or Profound
        NSString *s1 = @"Your results indicate severe hearing loss in this range. This type of hearing loss may make it difficult to register speech and other sounds, and requires an evaluation from a professional.\n\n";
        NSString *s2 = @"SOUNDS AFFECTED: dogs barking, car engines, television, radio, and footsteps\n\n";
        NSString *s3 = @"SPEECH SOUNDS AFFECTED: vowels such as “oo” and “ah”, consonants such as “m” and “n”, and persistent muffling of speech (like under water), male voices\n\n";
        NSString *s4 = @"ADVICE: Visit a hearing healthcare specialist to learn more about your specific hearing.  Visit Audicus.com to find out more information about amplification options.\n\n";
        NSString *s5 = @"SUGGESTIONS: Wear hearing protection during loud activities such as mowing the lawn or attending a concert.\n";

        text = [NSString stringWithFormat:@"%@%@%@%@%@", s1,s2,s3,s4,s5];
    }
    
    else if (lowest >= 40.0f && lowest < 80.f) {
        //Mild or Moderate
        NSString *s1 = @"Your results indicate moderate hearing loss in this range. This type of hearing loss may make it difficult to understand speech and other sounds.\n\n";
        NSString *s2 = @"SOUNDS AFFECTED: dogs barking, car engines, television, radio, and footsteps\n\n";
        NSString *s3 = @"SPEECH SOUNDS AFFECTED: vowels such as “oo” and “ah”, consonants such as “m” and “n”, and persistent muffling of speech (like under water), male voices\n\n";
        NSString *s4 = @"ADVICE: Visit a hearing healthcare specialist to learn more about your specific hearing.  Visit Audicus.com to find out more information about amplification options.\n\n";
        NSString *s5 = @"SUGGESTIONS: Wear hearing protection during loud activities such as mowing the lawn or attending a concert.\n";
        
        text = [NSString stringWithFormat:@"%@%@%@%@%@", s1,s2,s3,s4,s5];
    }
    
    else {
        //Normal
        NSString *s1 = @"Your hearing is normal in this range. Sounds and speech in both quiet and loud environments should be audible.\n\n";
        NSString *s2 = @"SOUNDS IN THIS RANGE: humming of a refrigerator, engines, lightbulbs and running water\n\n";
        NSString *s3 = @"SPEECH SOUNDS: vowels (“oo” and “ah”) and nasal consonants (“m” and “n”)\n\n";
        NSString *s4 = @"SUGGESTIONS: Wear hearing protection during loud activities such as mowing the lawn or attending a concert.\n";
        
        text = [NSString stringWithFormat:@"%@%@%@%@", s1,s2,s3,s4];
    }
    
    
    return text;
}

- (NSString *)medFreqTextFromResults:(TestResult *)result{
    float leftMed = [self medFrequencyScoreFromResults:result forLeftEar:YES] * 100;
    float rightMed = [self medFrequencyScoreFromResults:result forLeftEar:NO] * 100;
    
    float lowest;
    
    if (leftMed <= rightMed)
        lowest = leftMed;
    else
        lowest = rightMed;
    
//    lowest = 30;
    
    NSString *text;
    if (lowest < 40.0f) {
        //Severe or Profound
        NSString *s1 = @"Your results indicate severe hearing loss in this range. This type of hearing loss may make it difficult to register speech and other sounds, and requires an evaluation from a professional.\n\n";
        NSString *s2 = @"SOUNDS AFFECTED: leaves rustling or a clock ticking\n\n";
        NSString *s3 = @"SPEECH SOUNDS AFFECTED: “ch”, “p”, and “g”\n\n";
        NSString *s4 = @"ADVICE: Visit a hearing healthcare specialist to learn more about your specific hearing.  Visit Audicus.com to find out more information about amplification options.\n\n";
        NSString *s5 = @"SUGGESTIONS: Wear hearing protection during loud activities such as mowing the lawn or attending a concert.\n";

        text = [NSString stringWithFormat:@"%@%@%@%@%@", s1,s2,s3,s4,s5];
    }
    
    else if (lowest >= 40.0f && lowest < 80.f) {
        //Mild or Moderate
        NSString *s1 = @"Your results indicate moderate hearing loss in this range. This type of hearing loss may make it difficult to understand speech and other sounds.\n\n";
        NSString *s2 = @"SOUNDS AFFECTED: leaves rustling or a clock ticking\n\n";
        NSString *s3 = @"SPEECH SOUNDS AFFECTED: “ch”, “p”, and “g”\n\n";
        NSString *s4 = @"ADVICE: Visit a hearing healthcare specialist to learn more about your specific hearing.  Visit Audicus.com to find out more information about amplification options.\n\n";
        NSString *s5 = @"SUGGESTIONS: Wear hearing protection during loud activities such as mowing the lawn or attending a concert.\n";

        text = [NSString stringWithFormat:@"%@%@%@%@%@", s1,s2,s3,s4,s5];
    }
    
    else {
        //Normal
        NSString *s1 = @"Your hearing is normal in this range. Sounds and speech in both quiet and loud environments should be audible.\n\n";
        NSString *s2 = @"SOUNDS IN THIS RANGE: leaves rustling or a clock ticking\n\n";
        NSString *s3 = @"SPEECH SOUNDS: “ch”, “p”, and “g”\n\n";
        NSString *s4 = @"SUGGESTIONS: Wear hearing protection during loud activities such as mowing the lawn or attending a concert.\n";
        
        text = [NSString stringWithFormat:@"%@%@%@%@", s1,s2,s3,s4];
    }
    
    
    return text;
}

- (NSString *)highFreqTextFromResults:(TestResult *)result{
    float leftHigh = [self highFrequencyScoreFromResults:result forLeftEar:YES] * 100;
    float rightHigh = [self highFrequencyScoreFromResults:result forLeftEar:NO] * 100;
    
    float lowest;
    
    if (leftHigh <= rightHigh)
        lowest = leftHigh;
    else
        lowest = rightHigh;
    
//    lowest = 50;
    
    NSString *text;
    if (lowest < 40.0f) {
        //Severe or Profound
        NSString *s1 = @"Your results indicate severe hearing loss in this range. This type of hearing loss may make it difficult to register speech and other sounds, and requires an evaluation from a professional.\n\n";
        NSString *s2 = @"SOUNDS AFFECTED: speech in loud environments, birds chirping or children’s and women’s voices\n\n";
        NSString *s3 = @"SPEECH SOUNDS AFFECTED: soft consonants, such as “s”, “t”, and “f”\n\n";
        NSString *s4 = @"ADVICE: Visit a hearing healthcare specialist to learn more about your specific hearing.  Visit Audicus.com to find out more information about amplification options.\n\n";
        NSString *s5 = @"SUGGESTIONS: Wear hearing protection during loud activities such as mowing the lawn or attending a concert.\n";
        
        text = [NSString stringWithFormat:@"%@%@%@%@%@", s1,s2,s3,s4,s5];
    }
    
    else if (lowest >= 40.0f && lowest < 80.f) {
        //Mild or Moderate
        NSString *s1 = @"Your results indicate moderate hearing loss in this range. This type of hearing loss may make it difficult to understand speech and other sounds.\n\n";
        NSString *s2 = @"SOUNDS AFFECTED: speech in loud environments, birds chirping or children’s and women’s voices\n\n";
        NSString *s3 = @"SPEECH SOUNDS AFFECTED: soft consonants, such as “s”, “t”, and “f”\n\n";
        NSString *s4 = @"ADVICE: Visit a hearing healthcare specialist to learn more about your specific hearing.  Visit Audicus.com to find out more information about amplification options.\n\n";
        NSString *s5 = @"SUGGESTIONS: Wear hearing protection during loud activities such as mowing the lawn or attending a concert.\n";

        
        text = [NSString stringWithFormat:@"%@%@%@%@%@", s1,s2,s3,s4,s5];
    }
    
    else {
        //Normal
        NSString *s1 = @"Your hearing is normal in this range. Sounds and speech in both quiet and loud environments should be audible.\n\n";
        NSString *s2 = @"SOUNDS IN THIS RANGE: whispering, birds chirping, dishes clanking, computer keyboard sounds\n\n";
        NSString *s3 = @"SPEECH SOUNDS: “s”, “t”, and “f”\n\n";
        NSString *s4 = @"SUGGESTIONS: Wear hearing protection during loud activities such as mowing the lawn or attending a concert.\n";
        
        text = [NSString stringWithFormat:@"%@%@%@%@", s1,s2,s3,s4];
    }
    
    
    return text;
}




- (NSString *)pdf_lowFreqTextFromResults:(TestResult *)result{

    return [self lowFreqTextFromResults:result];
}

- (NSString *)pdf_medFreqTextFromResults:(TestResult *)result{

    
    return [self medFreqTextFromResults:result];
}

- (NSString *)pdf_highFreqTextFromResults:(TestResult *)result{

    return [self highFreqTextFromResults:result];
}


//•




+ (void)emailTextForResult:(TestResult *)result{
    
    //NSArray *freqs = [result.frequencies componentsSeparatedByString:@"|"];
    NSArray *lefts = [result.leftResults componentsSeparatedByString:@"|"];
    NSArray *rights = [result.rightResults componentsSeparatedByString:@"|"];
    
    //NSLog(@"FREQUENCIES: %@", freqs);
    //NSLog(@"============================");
    NSLog(@"LEFTS: %@", lefts);
    NSLog(@"============================");
    NSLog(@"RIGHTS: %@", rights);

    //result.contactEmail
    
    
    //NSMutableString *leftText = [@"Left Ear\n" mutableCopy];
    //NSMutableString *leftText = [NSMutableString stringWithFormat:@"%@\nLeft Ear\n", result.contactEmail];
    //NSMutableString *rightText = [@"Right Ear\n" mutableCopy];
    
    
//    NSLog(@"Left Responses: %@", leftResponses);
//    NSLog(@"Right Responses: %@", rightResponses);
//    NSLog(@"Keys: %@", [leftResponses allKeys]);
//    
//    for (int i=0; i < freqs.count; i++) {
//        NSString *freq = freqs[i];
//        NSString *left = lefts[i];
//        NSString *right = rights[i];
//        
//        
//        [leftText appendFormat:@"%@, %@\n", freq, left];
//        NSString *lAns = [[leftResponses objectForKey:freq] componentsJoinedByString: @"\n"];
//        [leftText appendFormat:@"%@\n", lAns];
//        //[leftText appendFormat:@"%@\n", [leftResponses objectForKey:freq]];
//        
//        [rightText appendFormat:@"%@, %@\n", freq, right];
//        NSString *rAns = [[rightResponses objectForKey:freq] componentsJoinedByString: @"\n"];
//        [rightText appendFormat:@"%@\n", rAns];
//        //[rightText appendFormat:@"%@", [rightResponses objectForKey:freq]];
//        
//        
//    }
//    
//    [email_text appendFormat:@"%@\n%@", leftText, rightText];
//    
}




- (void)generatePDFfromResults:(TestResult *)result{
    PDFView *pdf = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, 600, 1200)];
    
    CGFloat FREQ_SPACE = 50;
    
    
    //Date Label
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Here are the test results from %@", [result formattedFinishedDate]]];
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:paragraphStyle
                       range:NSMakeRange(0, attrString.length)];
    
    [attrString addAttribute:NSFontAttributeName
                       value:pdf.dateLabel.font
                       range:NSMakeRange(0, attrString.length)];
    pdf.dateLabel.attributedText = attrString;
    
    
    
    //Overall Results
    UIView *overallView = [self createOverallViewFromResults:result];
    overallView.frame = CGRectMake(pdf.frame.size.width/2-overallView.frame.size.width/2, 130, overallView.frame.size.width, overallView.frame.size.height); //70
    [pdf addSubview:overallView];
    
    
    
    //Low Freq
    pdf.lowFreq.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_LowFreq withResults:result];
    
    //Low Results
    pdf.lowResults.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_LowResults withResults:result];
    
    //Low Left
    pdf.lowLeft.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_LowLeft withResults:result];
    
    //Low Right
    pdf.lowRight.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_LowRight withResults:result];

    //Low Left Pct
    pdf.lowLeftPct.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_LowLeftPct withResults:result];
    
    //Low Right Pct
    pdf.lowRightPct.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_LowRightPct withResults:result];
    


    //Low Frequency Graphic
    UIView *low = [self createLowFreqFromResults:result];
    low.frame = CGRectMake((pdf.lowRight.frame.origin.x+pdf.lowRight.frame.size.width)/2  - low.frame.size.width/2 + 10,
                           pdf.lowLeftPct.frame.origin.y+pdf.lowLeftPct.frame.size.height + 15,
                           low.frame.size.width,
                           low.frame.size.height);
    [pdf addSubview:low];
    
    
//    pdf.lowLabel.frame = CGRectMake(low.frame.origin.x + low.frame.size.width/2 - pdf.lowLabel.frame.size.width/2,
//                                    pdf.lowLabel.frame.origin.y,
//                                    pdf.lowLabel.frame.size.width,
//                                    pdf.lowLabel.frame.size.height);
    
    
    //Low Detail
    pdf.lowDetail.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_LowDetail withResults:result];
    pdf.lowDetail.frame = CGRectMake(pdf.lowDetail.frame.origin.x,
                                     pdf.lowDetail.frame.origin.y,
                                     pdf.lowDetail.frame.size.width,
                                     //300);
                                     [self getHeightForText:[pdf.lowDetail.attributedText string] andWidth:pdf.lowDetail.frame.size.width]);
    
    
    //Heights
    CGFloat heightResults = pdf.lowResults.frame.origin.y-pdf.lowFreq.frame.origin.y;
    CGFloat heightPct = pdf.lowLeftPct.frame.origin.y - pdf.lowLeft.frame.origin.y;

    
    
    //Middle Freq
    pdf.middleFreq.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_MidFreq withResults:result];

    CGFloat middleY = low.frame.origin.y + low.frame.size.height;
    if (pdf.lowDetail.frame.origin.y+pdf.lowDetail.frame.size.height > middleY)
        middleY = pdf.lowDetail.frame.origin.y+pdf.lowDetail.frame.size.height;
    
    pdf.middleFreq.frame = CGRectMake(pdf.middleFreq.frame.origin.x, middleY+FREQ_SPACE, pdf.middleFreq.frame.size.width, pdf.middleFreq.frame.size.height);
    
    //Middle Results
    pdf.midResults.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_MidResults withResults:result];
    pdf.midResults.frame = CGRectMake(pdf.midResults.frame.origin.x, pdf.middleFreq.frame.origin.y + heightResults, pdf.midResults.frame.size.width, pdf.midResults.frame.size.height);


    //Mid Left
    pdf.midLeft.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_MidLeft withResults:result];
    pdf.midLeft.frame = CGRectMake(pdf.midLeft.frame.origin.x, pdf.midResults.frame.origin.y, pdf.midLeft.frame.size.width, pdf.midLeft.frame.size.height);

    //Mid Right
    pdf.midRight.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_MidRight withResults:result];
    pdf.midRight.frame = CGRectMake(pdf.midRight.frame.origin.x, pdf.midResults.frame.origin.y, pdf.midRight.frame.size.width, pdf.midRight.frame.size.height);

    //Mid Left Pct
    pdf.midLeftPct.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_MidLeftPct withResults:result];
    pdf.midLeftPct.frame = CGRectMake(pdf.midLeftPct.frame.origin.x, pdf.midLeft.frame.origin.y + heightPct, pdf.midLeftPct.frame.size.width, pdf.midLeftPct.frame.size.height);

    //Mid Right Pct
    pdf.midRightPct.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_MidRightPct withResults:result];
    pdf.midRightPct.frame = CGRectMake(pdf.midRightPct.frame.origin.x, pdf.midLeftPct.frame.origin.y, pdf.midRightPct.frame.size.width, pdf.midRightPct.frame.size.height);

    //Mid Frequency Graphic
    UIView *mid = [self createMidFreqFromResults:result];
    mid.frame = CGRectMake((pdf.midRight.frame.origin.x+pdf.midRight.frame.size.width)/2  - mid.frame.size.width/2 + 10,
                           pdf.midLeftPct.frame.origin.y+pdf.midLeftPct.frame.size.height + 10,
                           mid.frame.size.width,
                           mid.frame.size.height);
    [pdf addSubview:mid];
    
    //Mid Detail
    pdf.midDetail.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_MidDetail withResults:result];
    pdf.midDetail.frame = CGRectMake(pdf.midDetail.frame.origin.x,
                                     pdf.midRight.frame.origin.y,
                                     pdf.midDetail.frame.size.width,
                                     [self getHeightForText:[pdf.midDetail.attributedText string] andWidth:pdf.midDetail.frame.size.width]);

    
    
    
    
    
    //Heights
    //CGFloat heightResults = pdf.lowResults.frame.origin.y-pdf.lowFreq.frame.origin.y;
    //CGFloat heightPct = pdf.lowLeftPct.frame.origin.y - pdf.lowLeft.frame.origin.y;
    
    
    
    //High Freq
    pdf.highFreq.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_HighFreq withResults:result];
    
    CGFloat highY = mid.frame.origin.y + mid.frame.size.height;
    if (pdf.midDetail.frame.origin.y+pdf.midDetail.frame.size.height > highY)
        highY = pdf.midDetail.frame.origin.y+pdf.midDetail.frame.size.height;
    
    pdf.highFreq.frame = CGRectMake(pdf.highFreq.frame.origin.x, highY+FREQ_SPACE, pdf.highFreq.frame.size.width, pdf.highFreq.frame.size.height);
    
    //High Results
    pdf.highResults.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_HighResults withResults:result];
    pdf.highResults.frame = CGRectMake(pdf.highResults.frame.origin.x, pdf.highFreq.frame.origin.y + heightResults, pdf.highResults.frame.size.width, pdf.highResults.frame.size.height);
    
    
    //High Left
    pdf.highLeft.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_HighLeft withResults:result];
    pdf.highLeft.frame = CGRectMake(pdf.highLeft.frame.origin.x, pdf.highResults.frame.origin.y, pdf.highLeft.frame.size.width, pdf.highLeft.frame.size.height);
    
    //High Right
    pdf.highRight.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_HighRight withResults:result];
    pdf.highRight.frame = CGRectMake(pdf.highRight.frame.origin.x, pdf.highResults.frame.origin.y, pdf.highRight.frame.size.width, pdf.highRight.frame.size.height);
    
    //High Left Pct
    pdf.highLeftPct.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_HighLeftPct withResults:result];
    pdf.highLeftPct.frame = CGRectMake(pdf.highLeftPct.frame.origin.x, pdf.highLeft.frame.origin.y + heightPct, pdf.highLeftPct.frame.size.width, pdf.highLeftPct.frame.size.height);
    
    //High Right Pct
    pdf.highRightPct.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_HighRightPct withResults:result];
    pdf.highRightPct.frame = CGRectMake(pdf.highRightPct.frame.origin.x, pdf.highLeftPct.frame.origin.y, pdf.highRightPct.frame.size.width, pdf.highRightPct.frame.size.height);
    
    //High Frequency Graphic
    UIView *high = [self createHighFreqFromResults:result];
    high.frame = CGRectMake((pdf.highRight.frame.origin.x+pdf.highRight.frame.size.width)/2  - high.frame.size.width/2 + 10,
                           pdf.highLeftPct.frame.origin.y+pdf.highLeftPct.frame.size.height + 10,
                           high.frame.size.width,
                           high.frame.size.height);
    [pdf addSubview:high];
    
    //High Detail
    pdf.highDetail.attributedText = [self attributedStringForPDFView:pdf forPDFLabel:PDFLabel_HighDetail withResults:result];
    pdf.highDetail.frame = CGRectMake(pdf.highDetail.frame.origin.x,
                                     pdf.highRight.frame.origin.y,
                                     pdf.highDetail.frame.size.width,
                                     [self getHeightForText:[pdf.highDetail.attributedText string] andWidth:pdf.highDetail.frame.size.width]);
    
    
    
    
    //Divider 1 & 2
    UIView *divider1 = [[UIView alloc] initWithFrame:CGRectMake(pdf.lowResults.frame.origin.x, pdf.middleFreq.frame.origin.y - 15,
                                                                pdf.frame.size.width - pdf.lowResults.frame.origin.x*2, 1)];
    divider1.backgroundColor = [UIColor darkGrayColor];
    [pdf addSubview:divider1];

    
    UIView *divider2 = [[UIView alloc] initWithFrame:CGRectMake(pdf.midResults.frame.origin.x, pdf.highFreq.frame.origin.y - 15,
                                                                pdf.frame.size.width - pdf.midResults.frame.origin.x*2, 1)];
    divider2.backgroundColor = [UIColor darkGrayColor];
    [pdf addSubview:divider2];
    
    
    
    CGFloat highEnd = high.frame.origin.y + high.frame.size.height;
    if (pdf.highDetail.frame.origin.y+pdf.highDetail.frame.size.height > highEnd)
        highEnd = pdf.highDetail.frame.origin.y+pdf.highDetail.frame.size.height;
    
    
    //Contact View
    pdf.contactView.frame = CGRectMake(0,
                                       highEnd + FREQ_SPACE,
                                       pdf.contactView.frame.size.width,
                                       pdf.contactView.frame.size.height);
    
    //Disclaimer
    pdf.disclaimerLbl.frame = CGRectMake(pdf.disclaimerLbl.frame.origin.x,
                                         pdf.contactView.frame.origin.y + pdf.contactView.frame.size.height + 10,
                                         pdf.disclaimerLbl.frame.size.width,
                                         pdf.disclaimerLbl.frame.size.height);

    
    //Set PDF View Height
    pdf.frame = CGRectMake(pdf.frame.origin.x, pdf.frame.origin.y, pdf.frame.size.width, pdf.disclaimerLbl.frame.origin.y+pdf.disclaimerLbl.frame.size.height + 0);
    
    [DataSurrogate createPDFfromUIView:pdf saveToDocumentsWithFileName:@"PDF_TEST.pdf"];
}


- (CGFloat)labelHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    //UITextView *calculationView = [[UITextView alloc] init];
    UILabel *calculationView = [[UILabel alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    
    NSLog(@"Text: %@; Height: %f, Width: %f", text.string, size.height, width);
    return size.height;
}

- (float)getHeightForText:(NSString *)text andWidth:(float)width{
    CGSize constraint = CGSizeMake(width , 20000.0f);
    
    CGSize sizeOfText = [text boundingRectWithSize: constraint
                                              options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes: [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Roboto-Regular" size:14]
                                                                                   forKey:NSFontAttributeName]
                                              context: nil].size;
    
    NSLog(@"Height: %f", ceilf(sizeOfText.height));

    
    return ceilf(sizeOfText.height);
    
}



- (NSAttributedString *)attributedStringForPDFView:(PDFView *)pdfV forPDFLabel:(PDFLabel)pdfLbl withResults:(TestResult *)result{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString *string;
    float leftScore, rightScore;
    
    switch (pdfLbl) {

        case PDFLabel_LowFreq:
            //Low Freq
            string = [[NSMutableAttributedString alloc] initWithString:@"Low Frequencies"];
            [string addAttribute:NSParagraphStyleAttributeName
                              value:paragraphStyle
                              range:NSMakeRange(0, string.length)];
            
            [string addAttribute:NSFontAttributeName
                              value:pdfV.lowFreq.font
                              range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_LowResults:
            //Low Results
            string = [[NSMutableAttributedString alloc] initWithString:@"Your Results"];
            [string addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(0, string.length)];
            
            [string addAttribute:NSFontAttributeName
                           value:pdfV.lowResults.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_LowLeft:
            //Low Left
            string = [[NSMutableAttributedString alloc] initWithString:@"Left"];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.lowLeft.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_LowRight:
            //Low Right
            string = [[NSMutableAttributedString alloc] initWithString:@"Right"];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.lowRight.font
                           range:NSMakeRange(0, string.length)];
            break;
        
        case PDFLabel_LowLeftPct:
            //Low Left Pct
            leftScore = [self lowFrequencyScoreFromResults:result forLeftEar:YES];
            string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i%%", (int)roundf(leftScore*100)]];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.lowLeftPct.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_LowRightPct:
            //Low Right Pct
            rightScore = [self lowFrequencyScoreFromResults:result forLeftEar:NO];
            string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i%%", (int)roundf(rightScore*100)]];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.lowRightPct.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_LowDetail:
            //Low Detail
            string = [[NSMutableAttributedString alloc] initWithString:[self pdf_lowFreqTextFromResults:result]];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.lowDetail.font
                           range:NSMakeRange(0, string.length)];
            break;
            
            
        case PDFLabel_MidFreq:
            //Mid Freq
            string = [[NSMutableAttributedString alloc] initWithString:@"Middle Frequencies"];
            [string addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(0, string.length)];
            
            [string addAttribute:NSFontAttributeName
                           value:pdfV.middleFreq.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_MidResults:
            //Mid Results
            string = [[NSMutableAttributedString alloc] initWithString:@"Your Results"];
            [string addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(0, string.length)];
            
            [string addAttribute:NSFontAttributeName
                           value:pdfV.midResults.font
                           range:NSMakeRange(0, string.length)];
            break;

        case PDFLabel_MidLeft:
            //Mid Left
            string = [[NSMutableAttributedString alloc] initWithString:@"Left"];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.midLeft.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_MidRight:
            //Mid Right
            string = [[NSMutableAttributedString alloc] initWithString:@"Right"];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.midRight.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_MidLeftPct:
            //Mid Left Pct
            leftScore = [self medFrequencyScoreFromResults:result forLeftEar:YES];
            string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i%%", (int)roundf(leftScore*100)]];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.midLeftPct.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_MidRightPct:
            //Mid Right Pct
            rightScore = [self medFrequencyScoreFromResults:result forLeftEar:NO];
            string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i%%", (int)roundf(rightScore*100)]];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.midRightPct.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_MidDetail:
            //Mid Detail
            string = [[NSMutableAttributedString alloc] initWithString:[self pdf_medFreqTextFromResults:result]];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.midDetail.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_HighFreq:
            //High Freq
            string = [[NSMutableAttributedString alloc] initWithString:@"High Frequencies"];
            [string addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(0, string.length)];
            
            [string addAttribute:NSFontAttributeName
                           value:pdfV.highFreq.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_HighResults:
            //High Results
            string = [[NSMutableAttributedString alloc] initWithString:@"Your Results"];
            [string addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(0, string.length)];
            
            [string addAttribute:NSFontAttributeName
                           value:pdfV.highResults.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_HighLeft:
            //High Left
            string = [[NSMutableAttributedString alloc] initWithString:@"Left"];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.highLeft.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_HighRight:
            //High Right
            string = [[NSMutableAttributedString alloc] initWithString:@"Right"];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.highRight.font
                           range:NSMakeRange(0, string.length)];
            break;

        case PDFLabel_HighLeftPct:
            //High Left Pct
            leftScore = [self highFrequencyScoreFromResults:result forLeftEar:YES];
            string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i%%", (int)roundf(leftScore*100)]];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.highLeftPct.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_HighRightPct:
            //High Right Pct
            rightScore = [self highFrequencyScoreFromResults:result forLeftEar:NO];
            string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i%%", (int)roundf(rightScore*100)]];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.highRightPct.font
                           range:NSMakeRange(0, string.length)];
            break;
            
        case PDFLabel_HighDetail:
            //High Detail
            string = [[NSMutableAttributedString alloc] initWithString:[self pdf_highFreqTextFromResults:result]];
            [string addAttribute:NSFontAttributeName
                           value:pdfV.highDetail.font
                           range:NSMakeRange(0, string.length)];
            break;

            
        default:
            break;
    }
    
    return string;
}

- (UIView *)createOverallViewFromResults:(TestResult *)result{
    float widthTotal = 260;
    float heightTotal = 90;
    
    UIView *overallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthTotal, heightTotal)];
    
    float hLeft = [self highFrequencyScoreFromResults:result forLeftEar:YES];
    float hRight = [self highFrequencyScoreFromResults:result forLeftEar:NO];
    
    float mLeft = [[DataSurrogate sharedInstance] medFrequencyScoreFromResults:result forLeftEar:YES];
    float mRight = [[DataSurrogate sharedInstance] medFrequencyScoreFromResults:result forLeftEar:NO];
    
    float lLeft = [[DataSurrogate sharedInstance] lowFrequencyScoreFromResults:result forLeftEar:YES];
    float lRight = [[DataSurrogate sharedInstance] lowFrequencyScoreFromResults:result forLeftEar:NO];
    
    UIColor *topColor = [UIColor colorWithRed:238/255.0f green:141/255.0f blue:34/255.0f alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:255/255.0f green:205/255.0f blue:0/255.0f alpha:1];
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    PNCircleChart *highChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 80, 80) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:hLeft] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    highChartL.backgroundColor = [UIColor clearColor];
    [highChartL setStrokeColor:topColor];
    [highChartL strokeChart];
    [overallView addSubview:highChartL];
    
    //0,13 80x50 : 8
    PNCircleChart *highChartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 15, 80, 50) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:hRight] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    highChartR.backgroundColor = [UIColor clearColor];
    [highChartR setStrokeColor:bottomColor];
    [highChartR strokeChart];
    [overallView addSubview:highChartR];
    
    
    UILabel *highLabel = [[UILabel alloc] initWithFrame:CGRectMake(highChartL.frame.size.width/2 - 20/2, highChartL.frame.size.height/2 - 20/2, 20, 20)];
    NSMutableAttributedString *hString = [[NSMutableAttributedString alloc] initWithString:@"H"];
    [hString addAttribute:NSParagraphStyleAttributeName
                   value:paragraphStyle
                   range:NSMakeRange(0, hString.length)];
    [hString addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Roboto-Medium" size:18]
                   range:NSMakeRange(0, hString.length)];
    highLabel.attributedText = hString;
    //highLabel.hidden = YES;
    [overallView addSubview:highLabel];
    
    
    
    PNCircleChart *midChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(90, 0, 80, 80) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:mLeft] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    midChartL.backgroundColor = [UIColor clearColor];
    [midChartL setStrokeColor:topColor];
    [midChartL strokeChart];
    [overallView addSubview:midChartL];
    
    PNCircleChart *midChartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(90, 15, 80, 50) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:mRight] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    midChartR.backgroundColor = [UIColor clearColor];
    [midChartR setStrokeColor:bottomColor];
    [midChartR strokeChart];
    [overallView addSubview:midChartR];
    
    
    UILabel *medLabel = [[UILabel alloc] initWithFrame:CGRectMake((midChartL.frame.origin.x+midChartL.frame.size.width-midChartL.frame.size.width/2) - 20/2,
                                                                  midChartL.frame.size.height/2 - 20/2,
                                                                  20, 20)];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:@"M"];
    [mString addAttribute:NSParagraphStyleAttributeName
                    value:paragraphStyle
                    range:NSMakeRange(0, mString.length)];
    [mString addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"Roboto-Medium" size:18]
                    range:NSMakeRange(0, mString.length)];
    medLabel.attributedText = mString;
    //highLabel.hidden = YES;
    [overallView addSubview:medLabel];
    
    
    
    PNCircleChart *lowChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(180, 0, 80, 80) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:lLeft] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    lowChartL.backgroundColor = [UIColor clearColor];
    [lowChartL setStrokeColor:topColor];
    [lowChartL strokeChart];
    [overallView addSubview:lowChartL];
    
    PNCircleChart *lowChartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(180, 15, 80, 50) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:lRight] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    lowChartR.backgroundColor = [UIColor clearColor];
    [lowChartR setStrokeColor:bottomColor];
    [lowChartR strokeChart];
    [overallView addSubview:lowChartR];
    
    UILabel *lowLabel = [[UILabel alloc] initWithFrame:CGRectMake((lowChartL.frame.origin.x+lowChartL.frame.size.width-lowChartL.frame.size.width/2) - 20/2,
                                                                  lowChartL.frame.size.height/2 - 20/2,
                                                                  20, 20)];
    NSMutableAttributedString *lString = [[NSMutableAttributedString alloc] initWithString:@"L"];
    [lString addAttribute:NSParagraphStyleAttributeName
                    value:paragraphStyle
                    range:NSMakeRange(0, lString.length)];
    [lString addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"Roboto-Medium" size:18]
                    range:NSMakeRange(0, lString.length)];
    lowLabel.attributedText = lString;
    //highLabel.hidden = YES;
    [overallView addSubview:lowLabel];

    return overallView;
}

- (UIView *)createLowFreqFromResults:(TestResult *)result{
    UIColor *topColor = [UIColor colorWithRed:238/255.0f green:141/255.0f blue:34/255.0f alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:255/255.0f green:205/255.0f blue:0/255.0f alpha:1];
    
    float leftScore = [self lowFrequencyScoreFromResults:result forLeftEar:YES];
    float rightScore = [self lowFrequencyScoreFromResults:result forLeftEar:NO];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    
    
    
    PNCircleChart *chartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 160, 160) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:leftScore] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    chartL.backgroundColor = [UIColor clearColor];
    [chartL setStrokeColor:topColor];
    [chartL strokeChart];
    [view addSubview:chartL];
    
    
    PNCircleChart *chartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 15, 160, 130) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:rightScore] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    chartR.backgroundColor = [UIColor clearColor];
    [chartR setStrokeColor:bottomColor];
    [chartR strokeChart];
    [view addSubview:chartR];
    
    
    return view;
}

- (UIView *)createMidFreqFromResults:(TestResult *)result{
    UIColor *topColor = [UIColor colorWithRed:238/255.0f green:141/255.0f blue:34/255.0f alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:255/255.0f green:205/255.0f blue:0/255.0f alpha:1];
    
    float leftScore = [self medFrequencyScoreFromResults:result forLeftEar:YES];
    float rightScore = [self medFrequencyScoreFromResults:result forLeftEar:NO];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    
    
    
    PNCircleChart *chartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 160, 160) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:leftScore] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    chartL.backgroundColor = [UIColor clearColor];
    [chartL setStrokeColor:topColor];
    [chartL strokeChart];
    [view addSubview:chartL];
    
    
    PNCircleChart *chartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 15, 160, 130) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:rightScore] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    chartR.backgroundColor = [UIColor clearColor];
    [chartR setStrokeColor:bottomColor];
    [chartR strokeChart];
    [view addSubview:chartR];
    
    
    return view;
}

- (UIView *)createHighFreqFromResults:(TestResult *)result{
    UIColor *topColor = [UIColor colorWithRed:238/255.0f green:141/255.0f blue:34/255.0f alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:255/255.0f green:205/255.0f blue:0/255.0f alpha:1];
    
    float leftScore = [self highFrequencyScoreFromResults:result forLeftEar:YES];
    float rightScore = [self highFrequencyScoreFromResults:result forLeftEar:NO];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    
    
    
    PNCircleChart *chartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 160, 160) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:leftScore] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    chartL.backgroundColor = [UIColor clearColor];
    [chartL setStrokeColor:topColor];
    [chartL strokeChart];
    [view addSubview:chartL];
    
    
    PNCircleChart *chartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 15, 160, 130) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithFloat:rightScore] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    chartR.backgroundColor = [UIColor clearColor];
    [chartR setStrokeColor:bottomColor];
    [chartR strokeChart];
    [view addSubview:chartR];
    
    
    return view;
}



+ (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    [aView.layer renderInContext:pdfContext];
    
    
    
    for (UIView *subview in [aView subviews]) {
        for (UIView *view in [subview subviews]) {
            
            if([view isKindOfClass:[UILabel class]]) {
                UILabel* label = (UILabel*)view;
                //NSLog(@"Label: %@", NSStringFromCGRect(label.frame));
                [DataSurrogate drawText:label.attributedText inFrame:[label convertRect:label.bounds toView:aView]];
            }
        }
    }
    
    
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
}



+ (void)drawText:(NSAttributedString *)attrString inFrame:(CGRect)frameRect{
//+ (void)drawText:(NSAttributedString *)attrString withFont:(UIFont *)font inFrame:(CGRect)frameRect{
//+ (void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect {
    

    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attrString));
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    // Modify this to take into consideration the origin.
    //CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextTranslateCTM(currentContext, 0, frameRect.size.height + (frameRect.origin.y*2));
    //CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    
    // Add these two lines to reverse the earlier transformation.
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1) * (frameRect.size.height + (frameRect.origin.y*2)));
    
    
    //CFRelease(currentText);
    CFRelease(framesetter);
    CFRelease(frameRef);
    
}







//+ (void)drawLabels{
//    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"InvoiceView" owner:nil options:nil];
//    
//    UIView* mainView = [objects objectAtIndex:0];
//    
//    for (UIView* view in [mainView subviews]) {
//        if([view isKindOfClass:[UILabel class]])
//        {
//            UILabel* label = (UILabel*)view;
//            
//            [self drawText:label.text inFrame:label.frame];
//        }
//    }
//}

@end
