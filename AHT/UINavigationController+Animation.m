//
//  UINavigationController+Animation.m
//  AHT
//
//  Created by Troy DeMar on 4/28/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "UINavigationController+Animation.h"

@implementation UINavigationController (Animation)


- (void) popViewControllerWithFlip
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
                         //[UIView setAnimationTransition:UIViewAnimationTransition forView:self.view cache:NO];

                     }];
    
    [self popViewControllerAnimated:NO];
}


@end
