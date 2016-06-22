//
//  ContainerViewController.m
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ContainerViewController.h"
#import "StartViewController.h"
#import "ResultsViewController.h"

@interface ContainerViewController ()
@property (nonatomic, strong) TestResult *selectedResult;
@end

@implementation ContainerViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"prepareForSegue");
    
    if (self.childViewControllers.count == 0) {
        UIViewController *homeVC = segue.destinationViewController;
        
        [self addChildViewController:homeVC];
        homeVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:homeVC.view];
        [homeVC didMoveToParentViewController:self];
    }
    
    else {
        
        if ([segue.identifier isEqualToString:SegueIdentifierResult]) {
            ResultsViewController *resultsVC = (ResultsViewController *)[segue destinationViewController];
            resultsVC.selectedResult = self.selectedResult;
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:resultsVC];

        }
        
        else {
            UIViewController *homeVC = segue.destinationViewController;
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:homeVC];
        }
        
        
    }
    
    self.currentSegueIdentifier = segue.identifier;

}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentSegueIdentifier = SegueIdentifierTest;
    [self performSegueWithIdentifier:SegueIdentifierTest sender:nil];
    
//    self.currentSegueIdentifier = SegueIdentifierHome;
//    [self performSegueWithIdentifier:SegueIdentifierHome sender:nil];
}




- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //nil out ParentController of FromController
    [fromViewController willMoveToParentViewController:nil];
    
    //add ToController as Child
    [self addChildViewController:toViewController];
    
    
    //NSLog(@"After Controllers: %i", self.childViewControllers.count);
    
    
    //Transition Views
    //UIViewAnimationOptionTransitionCrossDissolve
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        //0
        //UIViewAnimationOptionTransitionNone
        
        //remove FromController from Parent
        [fromViewController removeFromParentViewController];
        
        //tell ToController it Move to Parent Controller
        [toViewController didMoveToParentViewController:self];
        
        
    }];
}



//- (void)pauseTest{
//    if (![self.currentSegueIdentifier isEqualToString:SegueIdentifierTest])
//        
//}


- (void)toHome{
    NSLog(@"To Home");
    if (![self.currentSegueIdentifier isEqualToString:SegueIdentifierHome])
        [self performSegueWithIdentifier:SegueIdentifierHome sender:nil];
}


- (void)toTest{
    if (![self.currentSegueIdentifier isEqualToString:SegueIdentifierTest])
        [self performSegueWithIdentifier:SegueIdentifierTest sender:nil];
}


- (void)toResultsList{
    if (![self.currentSegueIdentifier isEqualToString:SegueIdentifierResultsList])
        [self performSegueWithIdentifier:SegueIdentifierResultsList sender:nil];
}


- (void)toResults{
//    if (![self.currentSegueIdentifier isEqualToString:SegueIdentifierResultsList])
//        [self performSegueWithIdentifier:SegueIdentifierResultsList sender:nil];
}

- (void)toContact{
    if (![self.currentSegueIdentifier isEqualToString:SegueIdentifierContact])
        [self performSegueWithIdentifier:SegueIdentifierContact sender:nil];
}


- (void)toResult:(TestResult *)result{
//    NSLog(@"To Result");
    if (![self.currentSegueIdentifier isEqualToString:SegueIdentifierResult]) {
//        NSLog(@"To Result");
        self.selectedResult = result;
        [self performSegueWithIdentifier:SegueIdentifierResult sender:nil];
    }
}






- (void)openTOS{
    StartViewController *startVC = (StartViewController *)self.parentViewController;
    [startVC TOSAction:nil];
}



- (void)menuAction{
    
    [UIView animateWithDuration:5.0 animations:^{

        self.view.frame = CGRectMake(0, 0, 320, 200);
        
    } completion:^(BOOL finished) {
        
    }];
}


@end
