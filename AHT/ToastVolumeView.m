//
//  ToastVolumeView.m
//  AHT
//
//  Created by Troy DeMar on 2/26/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ToastVolumeView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ToastManager.h"

@implementation ToastVolumeView
@synthesize view, headerLbl, descTextView, fixLbl;
@synthesize volumeSlider, volumeViewSlider;
@synthesize volumeLbl;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ToastVolumeView" owner:self options:nil];
        self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.view];
        
        self.userInteractionEnabled = YES;
        //        self.accessibilityLabel = NSStringFromClass([self class]);
        //        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        
        [fixLbl addBottomBorderWithHeight:1.0 andColor:[UIColor colorWithRed:176/255.0f green:176/255.0f blue:176/255.0f alpha:1]];
        
        
//        UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 30)];
        headerLbl.userInteractionEnabled = NO;
        headerLbl.text = TOAST_VOLUME_H;
        headerLbl.textAlignment = NSTextAlignmentCenter;
//        headerLbl.font = [UIFont fontWithName:@"GTWalsheim-Bold" size:28];
//        [self addSubview:headerLbl];
        
        
//        UITextView *descTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, frame.size.width-(20*2), 60)];
        descTextView.editable = NO;
        descTextView.text = TOAST_VOLUME_D;
        descTextView.textAlignment = NSTextAlignmentCenter;
        descTextView.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
//        [self addSubview:descTextView];
        
        
        
        //Slider
        volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, frame.size.height - 20 - 40, frame.size.width-(40*2), 20)];
        //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        //UIEdgeInsets
        UIImage *minImage = [[UIImage imageNamed:@"slider_max"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 12)];
        UIImage *maxImage = [[UIImage imageNamed:@"slider_min2"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
        
//        UIImage *minImage = [[UIImage imageNamed:@"slider-track-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
//        UIImage *maxImage = [UIImage imageNamed:@"slider-track.png"];
        
//        UIImage *minImage = [[UIImage imageNamed:@"slider-track-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
//        UIImage *maxImage = [UIImage imageNamed:@"slider-track.png"];
        
        [volumeSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
        [volumeSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];

        //[volumeSlider setThumbImage:[UIImage imageNamed:@"sliderBtn"] forState:UIControlStateNormal];
//        volumeSlider.thumbTintColor = [UIColor grayColor];

        
//        UIImage *minImage = [[UIImage imageNamed:@"slider_minimum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//        UIImage *maxImage = [[UIImage imageNamed:@"slider_maximum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
//        [volumeSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
//        [volumeSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
        
        [self addSubview:volumeSlider];
        
        
        
        //MPVolume
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-1000, 0, 200, 40)];
        //volumeView.showsVolumeSlider = NO;
        volumeView.showsRouteButton = NO;
        [self addSubview:volumeView];
        
//        MPVolumeView *volumeView = [ToastManager manager].volumeView;
        
        int volume = 0;
        
        for (UIView *v in [volumeView subviews]){
            if ([v.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)v;
                //volumeViewSlider.hidden = YES;
                volumeSlider.value = volumeViewSlider.value;
                volume = (int)roundf(volumeSlider.value*100);
//                NSLog(@"Starting Value: %f", volumeViewSlider.value);
                break;
            }
        }
        
        NSLog(@"Volume: %i", volume);
        volumeLbl.text = [NSString stringWithFormat:@"%i", volume];

        
    }
    return self;
}


@end
