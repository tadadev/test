//
//  NoiseManager.h
//  HearingTest
//
//  Created by Martin Ceperley on 7/10/14.
//  Copyright (c) 2014 Knotable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol NoiseDelegate

- (void)noiseValueUpdated:(float)value;

@end

@interface NoiseManager : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, weak) id<NoiseDelegate> delegate;


+ (NoiseManager *)sharedInstance;

- (void)startMeasuring;
- (void)stopMeasuring;


- (void)play;

@end
