//
//  NoiseManager.m
//  HearingTest
//
//  Created by Martin Ceperley on 7/10/14.
//  Copyright (c) 2014 Knotable. All rights reserved.
//

#import "NoiseManager.h"
#import <AVFoundation/AVFoundation.h>

//static float NOISE_RECORD_INTERVAL = 0.1;
static int NOISE_SAMPLE_SMOOTHING = 10;


static float MIN_NOISE_METER = -60.0;
static float MAX_NOISE_METER = 0.0;


@interface NoiseManager ()

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *noiseTimer;
@property (nonatomic, strong) NSMutableArray *noiseValues;

@property (nonatomic, assign) int noiseValueIndex;
@property (nonatomic, assign) int noiseValueLength;


@end

@implementation NoiseManager

+ (NoiseManager *)sharedInstance
{
    static NoiseManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[NoiseManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)startMeasuring
{
    [self performSelectorOnMainThread:@selector(startMeasuringOnMain) withObject:nil waitUntilDone:NO];
}

- (void)startMeasuringOnMain{
    if (!self.recorder || !self.recorder.recording) {
        [self setupMeasuringNoiseLevel];
    }
}

- (void)stopMeasuring
{
    if (_noiseTimer) {
        [_noiseTimer invalidate];
        _noiseTimer = nil;
    }
    if (_recorder) {
        NSLog(@"Stop Recording");
        if (_recorder.recording) {
            [_recorder stop];
        }
        //[_recorder deleteRecording];
        //_recorder = nil;
    }
}

- (void)setupMeasuringNoiseLevel
{
#if TARGET_IPHONE_SIMULATOR
    return;
#endif
    
    //NSLog(@"device name %@", machineName());

    
    _noiseValues = [[NSMutableArray alloc] initWithCapacity:NOISE_SAMPLE_SMOOTHING];
    _noiseValueLength = 0;
    _noiseValueIndex = 0;
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    
    NSError *error = nil;
    
    /*
     [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
     if (error) {
     NSLog(@"Error overriding audio port: %@", error);
     }
     
     */
    
    NSDictionary* recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                      [NSNumber numberWithInt:44100],AVSampleRateKey,
                                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                      nil];
    error = nil;
    
    
    NSURL *tempFileURL = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"]];

//    NSArray *pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               @"tmp.caf",
//                               nil];
//    NSURL *tempFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    
    
    
//    [[AVAudioRecorder alloc] initWithURL:<#(NSURL *)#> settings:<#(NSDictionary *)#> error:<#(NSError *__autoreleasing *)#>]
//    if (tempFileURL !=nil)
//        NSLog(@"tempFileURL is NOT nil");
//    else
//        NSLog(@"tempFileURL is INFACT nil");
//
//    
//    if (recorderSettings !=nil)
//        NSLog(@"recorderSettings is NOT nil");
//    else
//        NSLog(@"recorderSettings is INFACT nil");
    
    
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:tempFileURL
                                                settings:recorderSettings
                                                   error:&error];
    
    self.recorder.delegate = self;
    
    if (error) {
        NSLog(@"Error setting up AVAudioRecorder: %@", error);
    }
    _recorder.meteringEnabled = YES;
    
    
    [_recorder record];
    NSLog(@"started recording");
    //0.2
    self.noiseTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(captureNoiseLevel) userInfo:nil repeats:YES];
    
    
}

- (float)smoothedNoiseValue
{
    float total = 0;
    for (NSNumber *value in _noiseValues) {
        total += value.floatValue;
    }
    return total / (float)_noiseValueLength;
}

- (void)captureNoiseLevel
{
    [_recorder updateMeters];
    float noiseDecibels = [_recorder averagePowerForChannel:0];
    //NSLog(@"noise level : %0.3f recording? %d", noiseDecibels, _recorder.recording);
    
    NSNumber *_noiseValueNumber = [NSNumber numberWithFloat:noiseDecibels];
    
    if (_noiseValueIndex >= _noiseValueLength) {
        [_noiseValues addObject:_noiseValueNumber];
        _noiseValueLength = (int)_noiseValues.count;
    } else {
        [_noiseValues replaceObjectAtIndex:_noiseValueIndex withObject:_noiseValueNumber];
    }
    _noiseValueIndex = (_noiseValueIndex + 1) % NOISE_SAMPLE_SMOOTHING;
    
    if (self.delegate) {
        [self.delegate noiseValueUpdated:[self smoothedNoiseValue]];
    }
    
    float noiseLevel = [self smoothedNoiseValue];
    
    
    float noiseRatio = MIN(MAX_NOISE_METER, MAX(MIN_NOISE_METER, noiseLevel));
    noiseRatio = (noiseRatio - MIN_NOISE_METER) / (MAX_NOISE_METER - MIN_NOISE_METER);
    

}



- (void)play{
    if (!_recorder.recording){
        NSLog(@"Playing");
        NSLog(@"URL: %@", self.recorder.url.path);
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:nil];
        [self.player setDelegate:self];
        [_player play];
    }
}


- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"audioPlayerDidFinishPlaying");
}


@end
