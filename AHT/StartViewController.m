//
//  StartViewController.m
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "StartViewController.h"
#import "TestResult.h"
#import "ToastManager.h"
#import "UINavigationController+Animation.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface StartViewController ()

@end

@implementation StartViewController
@synthesize menuView, myTableView, cancelView, containerView, helpBtn, cancelBtn;
@synthesize menuController, containerViewController;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedContainer"])
        self.containerViewController = segue.destinationViewController;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Data Table
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    myTableView.delaysContentTouches = NO;
    
    self.menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuController"];
    self.menuController.delegate = self;
    
    
    cancelBtn.layer.cornerRadius = 5.0f;
    cancelBtn.layer.borderWidth = 1.0f;
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    NSLog(@"Screen Height: %f", screenHeight);
    
    if (screenHeight < 500.0f) //480
        tableViewHeight.constant = 180;
    
    
}





#pragma mark - IBAction Methods

- (IBAction)menuAction:(id)sender{
//    NSLog(@"View: %@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"Container: %@", NSStringFromCGRect(self.containerView.frame));
//    NSLog(@"Container.y: %f", self.containerView.frame.origin.y);
//    NSLog(@"Constant: %f", self.view.frame.size.height - self.containerView.frame.origin.y);
//    NSLog(@"Cancel View: %@", NSStringFromCGRect(cancelView.frame));
//    NSLog(@"Table View: %@", NSStringFromCGRect(self.myTableView.frame));
//    NSLog(@"Bottom Table View: %f", self.myTableView.frame.origin.y + self.myTableView.frame.size.height);
    

    
    if (!isMenuVisible) {
        isMenuVisible = YES;
        [[ToastManager manager] attemptTestPause];
        
        
        //Analytics
        //Google
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker set:kGAIScreenName value:@"Help Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        //FB
        [FBSDKAppEvents logEvent:@"Help Screen"];
        
        
        //Move Cancel Button
        cancelView.alpha = 0;
        [self.view insertSubview:cancelView atIndex:10];
        cancelBtnBottom.constant = (-1) * self.cancelView.frame.size.height;
        cancelBtnTop.constant = self.cancelView.frame.size.height;
        [self.view layoutIfNeeded];
        
        
        UIView *view = self.containerViewController.view;
        
        
        //Help Slide
        helpTop.constant = -64;
        [UIView animateWithDuration:ANIMATION_SLIDE-0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        
        [UIView animateWithDuration:0.5 animations:^{
            helpBtn.alpha = 0;
        }];

        
        
        //Arrows
        leftArrowLeft.constant = 0-12;
        rightArrowRight.constant = 0-12;
        [UIView animateWithDuration:ANIMATION_SLIDE-0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
         
        
        
        //View Alpa
        [UIView animateWithDuration:0.6 animations:^{
            view.alpha = 0;
        }];
        
        
        //View Slide
        containerBottom.constant = (self.view.frame.size.height - self.containerView.frame.origin.y - self.cancelView.frame.size.height) * -1;
        containerTop.constant = self.view.frame.size.height - self.containerView.frame.origin.y - self.cancelView.frame.size.height;
        
        [UIView animateWithDuration:ANIMATION_SLIDE delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //view.frame = CGRectMake(0, self.view.frame.size.height, view.frame.size.width, view.frame.size.height);
            //self.containerViewController.view.frame = CGRectMake(0, 0, 320, 200);

            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            //[self.view insertSubview:cancelView aboveSubview:view];
            //view.hidden = YES;
            //[self.view addSubview:cancelView];
        }];
        
        
        //Cancel Button
        [UIView animateWithDuration:0.15 delay:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
            cancelView.alpha = 1;
        } completion:nil];

        
        cancelBtnTop.constant = 20;
        cancelBtnBottom.constant = 20;
        [UIView animateWithDuration:ANIMATION_SLIDE-0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.view layoutIfNeeded];

        } completion:nil];
    
    
    
    }
    
    //[self.containerViewController menuAction];
    
}




- (IBAction)closeMenuAction2:(id)sender{
    NSLog(@"StartViewController: closeMenuAction");
    if (menuController.isVisible) {
        [menuController dismissMenu];
    }
    
    [[ToastManager manager] attemptTestResume];
}


- (IBAction)closeMenuAction:(id)sender{
    if (isMenuVisible) {
        NSLog(@"Menu Close");
        isMenuVisible = NO;
        
        UIView *view = self.containerViewController.view;
        //[self.view insertSubview:view aboveSubview:cancelView];
        //view.hidden = NO;
        //view.alpha = 1.0f;
        
        
        //Help Slide
        helpTop.constant = 0;
        [UIView animateWithDuration:ANIMATION_SLIDE-0.3 delay:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
            helpBtn.alpha = 1;

            //[self.view layoutIfNeeded];
        } completion:nil];
        
        
        //Arrows
        leftArrowLeft.constant = 40;
        rightArrowRight.constant = 40;
        [UIView animateWithDuration:ANIMATION_SLIDE-0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        
        
        
        
        //View Alpa
        [UIView animateWithDuration:0.7 animations:^{
            view.alpha = 1.0f;
        }];
        
        
        //View Slide
        containerTop.constant = 0;
        containerBottom.constant = 0;
        
        [UIView animateWithDuration:ANIMATION_SLIDE delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //view.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height);
            
            [self.view layoutIfNeeded];

        } completion:^(BOOL finished) {
            
            
            [[ToastManager manager] attemptTestResume];
        }];
        
        
        
        cancelBtnBottom.constant = (-1) * self.cancelView.frame.size.height;
        cancelBtnTop.constant = self.cancelView.frame.size.height;;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished){
            [self.view insertSubview:cancelView aboveSubview:myTableView];
        }];
    }
    
    
}





- (IBAction)TOSAction:(id)sender {
    [self performSegueWithIdentifier:@"tosSegue" sender:nil];
}




#pragma mark - MenuDelegate Methods

- (IBAction)homeAction2:(id)sender{
    NSLog(@"homeAction");
    
    [ToastManager endToastMonitor];
    
    [self.containerViewController toHome];
}

- (IBAction)homeAction:(id)sender{

    [ToastManager endToastMonitor];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController popViewControllerWithFlip];
    
//    UIViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
//    UIView *rootView = rootController.view;
//    rootView.frame = CGRectMake(0, self.view.frame.size.height, rootView.frame.size.width, rootView.frame.size.height);
//    
//    
//    
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.alpha = 0;
//    }];
//    
//
//    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
//        rootView.frame = CGRectMake(0, 0, rootView.frame.size.width, rootView.frame.size.height);
//        
//    } completion:^(BOOL finished){
//        //[self.navigationController popToRootViewControllerAnimated:NO];
//    }];

}



- (IBAction)resultsActionOLD:(id)sender{
    [self performSegueWithIdentifier:@"resultsListSegue" sender:nil];
}

- (IBAction)resultsAction:(id)sender {
    [containerViewController toResultsList];
    
    [self closeMenuAction:nil];
}



// --------- NOT USED ---------------------------
- (IBAction)howAction:(id)sender {
    [self performSegueWithIdentifier:@"howItWorksSegue" sender:nil];
}

- (IBAction)emailAction:(id)sender {
    MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
    compose.mailComposeDelegate = self;
    
    [compose setToRecipients:[NSArray arrayWithObjects:@"mobiletest@audicus.com", nil]];
    [compose setSubject:@"From my app"];
    [compose setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:compose animated:YES completion:nil];
}
// -----------------------------------------------------------

- (IBAction)callAction:(id)sender {
    NSString *phNo = PHONENUMBER;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Unavailable" message:@"Call function is not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}




- (IBAction)contactAction:(id)sender{
    [containerViewController toContact];
    
    [self closeMenuAction:nil];

}


- (IBAction)closeAction:(id)sender{
    NSLog(@"Menu Close");
    
    [[ToastManager manager] attemptTestResume];
}







#pragma mark - MFMessageComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
//        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
//        [alrt show];
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    static NSString *cellIdentifier = @"ResultCell";
//    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
    static NSString *cellIdentifier = @"BasicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UIButton *button = (UIButton *)[cell viewWithTag:2];
    label.text = @"";
    [button setTitle:@"" forState:UIControlStateNormal];
    
    //iOS 7 Button Highlight Fix
    for (id obj in cell.subviews){
        if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"]){
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
    
    //iOS 8 Button Highlight Fix
    for (UIView *currentView in tableView.subviews) {
        if ([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    
    //Row==0 is blank to get the extra line
    if (indexPath.row == 1) {
        //label.text = @"Home";
        [button setTitle:@"Home" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(homeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (indexPath.row == 2) {
        //label.text = @"Results";
        [button setTitle:@"Results" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(resultsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (indexPath.row == 3) {
        //label.text = @"Contact";
        [button setTitle:@"Contact" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(contactAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight < 500.0f)//480
        [button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:19]];
    
    return cell;
}

- (void)menuButton:(id)sender{
    NSLog(@"menuButtonAtRow");
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 0.5f;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    //NSLog(@"Screen Height: %f", screenHeight);
    
    if (screenHeight < 500.0f) {//480
        NSLog(@"Small Screen");
        return 50.0f;
    }
    else
        return 68.0f;
}





#pragma mark - <ChimpKitRequestDelegate> Methods

//- (void)ckRequestIdentifier:(NSUInteger)requestIdentifier didSucceedWithResponse:(NSURLResponse *)response andData:(NSData *)data {
//    
//    
//    NSLog(@"Success");
//    NSLog(@"requestIdentifier: %i", requestIdentifier);
//}
//
//- (void)ckRequestFailedWithIdentifier:(NSUInteger)requestIdentifier andError:(NSError *)anError {
//    
//    NSLog(@"Fail");
//
//    
//    //Handle connection error
//    NSLog(@"Error, %@", anError);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //Update UI here
//    });
//}



@end
