//
//  AppDelegate.h
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class TAGManager;
@class TAGContainer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MPVolumeView *volumeView;

@property (nonatomic) AudioType audio;
@property (nonatomic) ThresholdLvl threshold;

@property (nonatomic, strong) TAGManager *tagManager;
@property (nonatomic, strong) TAGContainer *container;

@end

