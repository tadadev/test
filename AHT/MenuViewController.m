//
//  MenuViewController.m
//  AHT
//
//  Created by Troy DeMar on 2/25/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "MenuViewController.h"
#import "UIView+Borders.h"

#define MG_ANIMATION_APPEAR		@"Appear"
#define MG_ANIMATION_DISAPPEAR	@"Disappear"

// Timing.
#define MG_ANIMATION_DURATION	0.50 // seconds

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize homeBtn, resultsBtn, contactBtn;
@synthesize isVisible;
@synthesize delegate;


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
    
    //[homeBtn addTopBorderWithHeight:1.0f andColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:0.7]];
    
}




- (void)displayMenuInView:(UIView *)parentView{
    //center self in parent view
    CGRect frame = self.view.frame;
    frame.size.height = parentView.frame.size.height;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.view.frame = frame;
    
    //NSLog(@"(%fx%f)", frame.size.width, frame.size.height);
    
    
    //display menu
    [parentView addSubview:self.view];
    
    
    // Add appearance animations.
    NSArray *animations = [self animationsForAppearing:YES];
    int i = 0;
    for (CAAnimation *animation in animations) {
        [self.view.layer addAnimation:animation forKey:[NSString stringWithFormat:@"%d", i]];
        i++;
    }
    
    isVisible = YES;
}

- (void)dismissMenu{
    
    if (isVisible) {
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        frame.origin.y = -self.view.frame.size.height;
        self.view.frame = frame;

        
//        NSArray *animations = [self animationsForAppearing:NO];
//        int i = 0;
//        for (CAAnimation *animation in animations) {
//            [self.view.layer addAnimation:animation forKey:[NSString stringWithFormat:@"%d", i]];
//            i++;
//        }
//        
//        return;

        
        
        NSArray *animations = [self animationsForAppearing:NO];
        
        [CATransaction begin]; {
            [CATransaction setCompletionBlock:^{
//                float end = -self.view.frame.size.height;
//                CGRect frame = self.view.frame;
//                frame.origin.y = end;
//                self.view.frame = frame;

                
                [self.view removeFromSuperview];
            }];
    
            int i = 0;
            for (CAAnimation *animation in animations) {
                [self.view.layer addAnimation:animation forKey:[NSString stringWithFormat:@"%d", i]];
                i++;
            }
            
            
        } [CATransaction commit];
        
        //[self.view removeFromSuperview];
        
    }
    
    isVisible = NO;
}



#pragma mark - Animations

- (NSArray *)animationsForAppearing:(BOOL)appearing{
    NSMutableArray *animations = [NSMutableArray arrayWithCapacity:0];
    
    if (appearing) {
        
        /*
        CABasicAnimation *expandAnimation;
        expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        [expandAnimation setValue:MG_ANIMATION_APPEAR forKey:@"name"];
        [expandAnimation setRemovedOnCompletion:NO];
        [expandAnimation setDuration:MG_ANIMATION_DURATION];
        [expandAnimation setFillMode:kCAFillModeForwards];
        [expandAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [expandAnimation setDelegate:self];
        CGFloat factor = 0.6;
        CATransform3D transform = CATransform3DMakeScale(factor, factor, factor);
        expandAnimation.fromValue = [NSValue valueWithCATransform3D:transform];
        expandAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        
        [animations addObject:expandAnimation];
        
        CABasicAnimation *fadeAnimation;
        fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fadeAnimation setValue:MG_ANIMATION_APPEAR forKey:@"name"];
        [fadeAnimation setRemovedOnCompletion:NO];
        [fadeAnimation setDuration:MG_ANIMATION_DURATION];
        [fadeAnimation setFillMode:kCAFillModeForwards];
        [fadeAnimation setDelegate:self];
        fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
        
        [animations addObject:fadeAnimation];
        */
        
        CABasicAnimation *downAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        float start = -self.view.frame.size.height;
        [downAnimation setFromValue:[NSNumber numberWithFloat:start]];
        [downAnimation setToValue:[NSNumber numberWithFloat:0.0f]];
        [downAnimation setDuration:MG_ANIMATION_DURATION];
//        [downAnimation setRemovedOnCompletion:NO];
//        [downAnimation setFillMode:kCAFillModeForwards];
        
        [animations addObject:downAnimation];
        
    } else {
        
        CABasicAnimation *upAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        float start = self.view.frame.size.height;

        [upAnimation setFromValue:[NSNumber numberWithFloat:start]];
        [upAnimation setToValue:[NSNumber numberWithFloat:0.0f]];
        [upAnimation setDuration:MG_ANIMATION_DURATION];
//        [upAnimation setRemovedOnCompletion:NO];
//        [upAnimation setFillMode:kCAFillModeForwards];
//        [upAnimation setDelegate:self];
        
        [animations addObject:upAnimation];
        //self.view.layer.frame = frame;
    }
    
    
    return animations;
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    NSLog(@"animation stopped");
    if (flag) {
        NSLog(@"Description: %@",theAnimation.description);
    }
}




#pragma mark - IBAction Methods

- (IBAction)homeAction:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(homeAction:)]) {
        [self dismissMenu];
        [delegate homeAction:nil];
    }
}

- (IBAction)resultsAction:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(resultsAction:)]) {
        [delegate resultsAction:nil];
        
        [self dismissMenu];
    }
}

- (IBAction)howAction:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(howAction:)]) {
        //[self dismissMenu];
        [delegate howAction:nil];
    }
}

- (IBAction)emailAction:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(emailAction:)]) {
        [delegate emailAction:nil];
        
        //[self dismissMenu];
    }
}

- (IBAction)callAction:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(callAction:)]) {
        //[self dismissMenu];
        [delegate callAction:nil];
    }
}

- (IBAction)contactAction:(id)sender{
    if (delegate && [delegate respondsToSelector:@selector(contactAction:)]) {
        [delegate contactAction:nil];
        
        [self dismissMenu];
    }
}


- (IBAction)closeAction:(id)sender {
    [self dismissMenu];

    if (delegate && [delegate respondsToSelector:@selector(callAction:)]) {
        [delegate closeAction:nil];
    }
    
}

@end
