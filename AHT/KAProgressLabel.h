//
//  KAProgressLabel.h
//  KAProgressLabel
//
//  Created by Alex on 09/06/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import "TPPropertyAnimation.h"

@class KAProgressLabel;

typedef void(^labelValueChangedCompletion)(KAProgressLabel *label);
typedef NS_ENUM(NSUInteger, ProgressLableType) {
    ProgressLabelCircle,
    ProgressLabelRect
};

@interface KAProgressLabel : UILabel

@property (nonatomic, copy) labelValueChangedCompletion labelVCBlock;

// Style
@property (nonatomic) ProgressLableType progressType;
@property (nonatomic) CGFloat trackWidth;
@property (nonatomic) CGFloat progressWidth;
@property (nonatomic, copy) UIColor * fillColor;
@property (nonatomic, copy) UIColor * trackColor;
@property (nonatomic, copy) UIColor * progressColor;
@property (nonatomic) BOOL roundedCorners;
@property (nonatomic) CGFloat roundedCornersWidth;

// Logic
@property (nonatomic) CGFloat startDegree;
@property (nonatomic) CGFloat endDegree;
@property (nonatomic) CGFloat progress;
@property (nonatomic) BOOL clockWise;

// Getters
- (float)radius;

// Animations
-(void)setStartDegree:(CGFloat)startDegree
               timing:(TPPropertyAnimationTiming)timing
             duration:(CGFloat)duration
                delay:(CGFloat)delay;

-(void)setEndDegree:(CGFloat)endDegree
             timing:(TPPropertyAnimationTiming)timing
           duration:(CGFloat)duration
              delay:(CGFloat)delay;

-(void)setProgress:(CGFloat)progress
            timing:(TPPropertyAnimationTiming)timing
          duration:(CGFloat)duration
             delay:(CGFloat)delay;

-(void)stopAnimations;
@end
