//
//  ProtoViewController.m
//  AHT
//
//  Created by Troy DeMar on 4/9/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ProtoViewController.h"
#import "DataSurrogate.h"
#import "ToastManager.h"

#define ARC4RANDOM_MAX 0x100000000

@interface ProtoViewController ()

@end

@implementation ProtoViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = 50;
    circle = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - width/2,
                                                              self.view.frame.size.height/2 - width/2,
                                                              width,
                                                              width)];
    circle.layer.cornerRadius = circle.frame.size.height/2;
    circle.layer.masksToBounds = YES;
    circle.layer.borderWidth = 0;
    
    UIColor *waveColor = [UIColor colorWithRed:3/255.0f green:169/255.0f blue:244/255.0f alpha:1];
    circle.backgroundColor = waveColor;
    circle.alpha = 0.8;
    [self.view addSubview:circle];
    
    
    interval = 0.25;
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];

    
//    CABasicAnimation *theAnimation;
//    
//    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
//    theAnimation.duration=1.0;
//    theAnimation.repeatCount=HUGE_VALF;
//    theAnimation.autoreverses=YES;
//    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
//    theAnimation.toValue=[NSNumber numberWithFloat:0.0];
//    [circle.layer addAnimation:theAnimation forKey:@"animateOpacity"]; //myButton.layer instead of
    
    //[ToastManager simulateNoise];
    //[ToastManager beginToastMonitor];
}


- (IBAction)stop:(id)sender{
    [timer invalidate];
    timer = nil;
}

- (IBAction)action1:(id)sender{
    [timer invalidate];
    timer = nil;
    
//    interval = 1.25;
//    size = 1.5;
//    
//    [self ripple];
//    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];

}

- (IBAction)action2:(id)sender{
    [timer invalidate];
    timer = nil;
    
//    interval = 1.0;
//    size = 2.0;
    
    interval = 1.20;
    size = 1.5;
    
    [self ripple];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];

}

- (IBAction)action3:(id)sender{
    [timer invalidate];
    timer = nil;
    
    interval = 0.9;   //0.875;
    size = 2.0;
    
    [self ripple];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];

}

- (IBAction)action4:(id)sender{
    [timer invalidate];
    timer = nil;
    
    interval = 0.70;
    size = 3.0;
    
    [self ripple];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];
    
}

- (IBAction)action5:(id)sender{
    [timer invalidate];
    timer = nil;
    
    interval = 0.50;
    size = 4.0;
    
    [self ripple];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];
    
}

- (IBAction)action6:(id)sender{
    [timer invalidate];
    timer = nil;
    
    interval = 0.35;
    size = 5.5;
    
    [self ripple];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ripple) userInfo:nil repeats:YES];
    
}


- (void)ripple{
    //float min = 1.5;
    //float max = 4.5;
    //float random = ((float)arc4random() / ARC4RANDOM_MAX * (min - max)) + max;
    //float t = 4;
    
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

        
        //CGAffineTransform transform = CGAffineTransformMakeScale(random, random);
        CGAffineTransform transform = CGAffineTransformMakeScale(size, size);

        wave.transform = transform;
        wave.alpha = 0.1;
        
    } completion:^(BOOL finished) {
        [wave removeFromSuperview];
    }];
    
}



- (void)old{
    float value;
    float t = [[DataSurrogate sharedInstance] threshold];
    float range = t / 5;
    
    if (value <= t) {
        NSLog(@"1.0f");
        
    }
    
    else if (value > t && value <= (t-range*1)) {
        NSLog(@"1:  0.70f");
        
    }else if (value > (t-range*1) && value <= (t-range*2)) {
        NSLog(@"2:  0.50f");
        
    }else if (value > (t-range*2) && value <= (t-range*3)) {
        NSLog(@"3:  0.35f");
        
    }else if (value > (t-range*3) && value <= (t-range*4)) {
        NSLog(@"4:  0.20f");
        
    }
}

@end
