//
//  HomeViewController.m
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "HomeViewController.h"
#import "ContainerViewController.h"
#import "ToastManager.h"
#import "ToastHelpConfirmView.h"
#import "PNCircleChart.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"
#import "StartViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface PushAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface PopAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end


@interface HomeViewController () <UINavigationControllerDelegate>

@end

@implementation HomeViewController
@synthesize startView, startBtn;

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
    self.navigationController.delegate = self;
    
    
    startView.layer.borderWidth = 1.0f;
    startView.layer.cornerRadius = 4.0f;
    
    
    startBtn.layer.borderWidth = 1.0f;
    startBtn.layer.borderColor = [UIColor grayColor].CGColor;
    startBtn.layer.cornerRadius = 4.0f;
    
    //------ Tesing --------
//    [self testPane];
    //[self testPane2];
    //NSLog(@"Width: %f", self.view.frame.size.width);
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Analytics
    //Google
    self.screenName = @"Home Screen";
    
    //FB
    [FBSDKAppEvents logEvent:@"Home Screen"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //Tag Manager (Analytics)
//    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
//    [dataLayer push:@{@"event": @"openScreen", @"screenName": @"Results List Screen"}];

}




#pragma mark - IBAction Methods

- (IBAction)TOSAction:(id)sender {
    ContainerViewController *containVC = (ContainerViewController *)self.parentViewController;
    [containVC openTOS];
}


- (IBAction)beginTestAction:(id)sender {
    ContainerViewController *containVC = (ContainerViewController *)self.parentViewController;
    [containVC toTest];
}

- (IBAction)beginTest:(id)sender{
    [self performSegueWithIdentifier:@"startTestSegue" sender:nil];
}



/* *************  TESTING ******************** */

- (void)testPane{
    //TestPane
    CGFloat width = self.view.frame.size.width;
    
    UIView *testPane = [[UIView alloc] initWithFrame:CGRectMake(0, 50, width, 50)];
    testPane.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:testPane];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(5, 10, 30, 30);
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 setTitle:@"N" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(raiseNoiseAlert:) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(45, 10, 30, 30);
    btn2.backgroundColor = [UIColor whiteColor];
    [btn2 setTitle:@"H" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(raiseHeadphonesAlert:) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn2];
    
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn3.frame = CGRectMake(85, 10, 30, 30);
    btn3.backgroundColor = [UIColor whiteColor];
    [btn3 setTitle:@"V" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(raiseVolumeAlert:) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn3];
    
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn4.frame = CGRectMake(125, 10, 30, 30);
    btn4.backgroundColor = [UIColor whiteColor];
    [btn4 setTitle:@"TT" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(raiseDidHearAlert:) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btn4];
    
    
    UIButton *btnX = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnX.frame = CGRectMake(280, 10, 30, 30);
    btnX.backgroundColor = [UIColor whiteColor];
    [btnX setTitle:@"X" forState:UIControlStateNormal];
    [btnX addTarget:self action:@selector(raiseThanksAlert:) forControlEvents:UIControlEventTouchUpInside];
    [testPane addSubview:btnX];
}

- (void)testPane2{
    
    PNCircleChart *circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 80.0, 320, 200.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:20]];
    circleChart.backgroundColor = [UIColor clearColor];
    [circleChart setStrokeColor:PNGreen];
    [circleChart strokeChart];
    [self.view addSubview:circleChart];
    
    
    PNCircleChart *circleChart2 = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 110.0, 320, 140) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:20]];
    circleChart2.backgroundColor = [UIColor clearColor];
    [circleChart2 setStrokeColor:PNYellow];
    [circleChart2 strokeChart];
    [self.view addSubview:circleChart2];
}




- (IBAction)raiseNoiseAlert:(id)sender{
    [ToastManager simulateNoise];
}

- (IBAction)raiseHeadphonesAlert:(id)sender{
    [ToastManager simulateHeadphones];
}

- (IBAction)raiseVolumeAlert:(id)sender{
    [ToastManager simulateVolume];
}

- (IBAction)raiseDidHearAlert:(id)sender{
    [ToastManager simulateDidHear];
}


- (IBAction)raiseThanksAlert:(id)sender{
    [ToastManager simulateThanks];
    //ToastHelpConfirmView *view = [[ToastHelpConfirmView alloc] initWithFrame:CGRectMake(0, 100, 320, 150)];
    //[self.view addSubview:view];
}

- (IBAction)test:(id)sender{
    [ToastManager startToast];
}
/* ******************************************** */



#pragma mark - IUINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
//    if (operation == UINavigationControllerOperationPush)
//        return [[PushAnimator alloc] init];
    
    if (operation == UINavigationControllerOperationPop)
        return [[PopAnimator alloc] init];
    
    return nil;
}


@end




@implementation PushAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    toViewController.view.alpha = 0.0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end


@implementation PopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return ANIMATION_SLIDE;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    //UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    StartViewController* fromViewController   = (StartViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    
    toViewController.view.frame = CGRectMake(0, fromViewController.view.frame.size.height, toViewController.view.frame.size.width, toViewController.view.frame.size.height);

    [[transitionContext containerView] insertSubview:toViewController.view aboveSubview:fromViewController.view];

    
    
    
//    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
//
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        fromViewController.view.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];
    
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toViewController.view.frame = CGRectMake(0, 0, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

    
    
//    NSTimeInterval ANIMATION_SLIDE = 0.8;
//    //View Slide
//    fromViewController.containerTop.constant = 0;
//    fromViewController.containerBottom.constant = 0;
//
//    [UIView animateWithDuration:ANIMATION_SLIDE delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        
//        [fromViewController.view layoutIfNeeded];
//        
//    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];
    
    
    
//    fromViewController.cancelBtnBottom.constant = (-1) * toViewController.cancelView.frame.size.height;
//    toViewController.cancelBtnTop.constant = self.cancelView.frame.size.height;;
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
//        
//        [self.view layoutIfNeeded];
//        
//    } completion:^(BOOL finished){
//        [self.view insertSubview:cancelView aboveSubview:myTableView];
//    }];

    
}

@end


