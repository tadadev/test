//
//  ToastNoiseView.m
//  AHT
//
//  Created by Troy DeMar on 2/26/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ToastNoiseView.h"

#define ARC4RANDOM_MAX 0x100000000


@implementation ToastNoiseView
@synthesize view, headerLbl, descTextView, fixLbl;

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
        [[NSBundle mainBundle] loadNibNamed:@"ToastNoiseView" owner:self options:nil];
        self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.view];
        
        self.userInteractionEnabled = YES;
        //        self.accessibilityLabel = NSStringFromClass([self class]);
        //        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        
        [fixLbl addBottomBorderWithHeight:1.0 andColor:[UIColor colorWithRed:176/255.0f green:176/255.0f blue:176/255.0f alpha:1]];
        
        
//        UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 30)];
        headerLbl.userInteractionEnabled = NO;
        headerLbl.text = TOAST_NOISE_H;
        headerLbl.textAlignment = NSTextAlignmentCenter;
//        headerLbl.font = [UIFont fontWithName:@"GTWalsheim-Bold" size:28];
//        [self addSubview:headerLbl];
        
        
//        UITextView *descTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, frame.size.width-(20*2), 60)];
        descTextView.editable = NO;
        descTextView.text = TOAST_NOISE_D;
        descTextView.textAlignment = NSTextAlignmentCenter;
        descTextView.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
//        [self addSubview:descTextView];
        
        
        
        CGFloat width = 50;
        circle = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - width/2,
                                                          descTextView.frame.origin.y + descTextView.frame.size.height + 5,
                                                          width,
                                                          width)];
        circle.layer.cornerRadius = circle.frame.size.height/2;
        circle.layer.masksToBounds = YES;
        circle.layer.borderWidth = 0;
        
        UIColor *waveColor = [UIColor colorWithRed:3/255.0f green:169/255.0f blue:244/255.0f alpha:1];
        circle.backgroundColor = waveColor;
        circle.alpha = 0.8;
        [self.view insertSubview:circle belowSubview:descTextView];
        
    }
    
    [self speed3];
    
    return self;
}


- (void)speed1{
    if (currentSpeed == 1)
        return;
    
    [timer invalidate];
    timer = nil;
    currentSpeed = 1;
}

- (void)speed2{
    if (currentSpeed == 2)
        return;
    
    [timer invalidate];
    timer = nil;
    currentSpeed = 2;

    interval = 1.20;
    size = 1.5;
    
    [self ripple];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];
    
}

- (void)speed3{
    if (currentSpeed == 3)
        return;
    
    [timer invalidate];
    timer = nil;
    currentSpeed = 3;

    interval = 0.9;   //0.875;
    size = 2.0;
    
    [self ripple];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];
    
}

- (void)speed4{
    if (currentSpeed == 4)
        return;
    
    [timer invalidate];
    timer = nil;
    currentSpeed = 4;

    interval = 0.70;
    size = 3.0;
    
    [self ripple];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];
    
}

- (void)speed5{
    if (currentSpeed == 5)
        return;
    
    [timer invalidate];
    timer = nil;
    currentSpeed = 5;

    interval = 0.50;
    size = 4.0;
    
    [self ripple];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];
    
}

- (void)speed6{
    if (currentSpeed == 6)
        return;
    
    [timer invalidate];
    timer = nil;
    currentSpeed = 6;
    
    interval = 0.35;
    size = 5.5;
    
    [self ripple];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];
    
}



- (void)ripple{
    
    UIView *wave = [[UIView alloc] initWithFrame:CGRectMake(circle.frame.origin.x,
                                                            circle.frame.origin.y,
                                                            circle.frame.size.width,
                                                            circle.frame.size.height)];
    wave.layer.cornerRadius = circle.frame.size.height/2;
    wave.layer.masksToBounds = YES;
    wave.layer.borderWidth = 0;
    
    UIColor *waveColor = [UIColor colorWithRed:3/255.0f green:169/255.0f blue:244/255.0f alpha:1];
    wave.backgroundColor = waveColor;
    wave.alpha = 0.7;
    [self.view insertSubview:wave belowSubview:circle];
    
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGAffineTransform transform = CGAffineTransformMakeScale(size, size);
        
        wave.transform = transform;
        wave.alpha = 0.1;
        
    } completion:^(BOOL finished) {
        [wave removeFromSuperview];
    }];
    
}



@end
