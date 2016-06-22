//
//  ViewController.m
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ViewController.h"
#import "StartViewController.h"
#import "HomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize agreeBtn, webView, textView;
@synthesize viewType;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.automaticallyAdjustsScrollViewInsets = NO;

    
//    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.makemegeek.com"]];
//    [self.webView loadRequest:request];
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TOC" withExtension:@"docx"];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TOC" withExtension:@"htm"];
//
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//    
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Splash" ofType:@"png"];
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"TOC" ofType:@"docx"];
//    NSLog(@"Path: %@", path);
//    NSURL *targetURL = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
//    [webView loadRequest:request];
    
    
    if ([viewType isEqualToString:@"tos"]) {
        UITextView *textview2 = [[UITextView alloc] initWithFrame:CGRectMake(10, 118, self.view.frame.size.width-20, self.view.frame.size.height-118)];
        textview2.backgroundColor = [UIColor clearColor];
        textview2.editable = NO;
        [self.view addSubview:textview2];
        
        // Create an NSURL pointing to the HTML file
        NSURL *htmlString = [[NSBundle mainBundle]
                             URLForResource: @"TOC" withExtension:@"htm"];
        
        // Transform HTML into an attributed string
        NSAttributedString *stringWithHTMLAttributes = [[NSAttributedString alloc]   initWithFileURL:htmlString options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        textview2.attributedText=stringWithHTMLAttributes;
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([self.viewType isEqualToString:@"contact"]) {
        //Analytics
        //Google
        self.screenName = @"Contact Screen";
        
        //FB
        [FBSDKAppEvents logEvent:@"Contact Screen"];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}



#pragma mark - IBAction Methods

- (IBAction)tos_closeAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)tos_startTestAction:(id)sender{
//    StartViewController *startVC = (StartViewController *)self.presentingViewController;
//    [startVC.containerViewController toTest];
    
    UINavigationController *nav = (UINavigationController *)self.presentingViewController;
    HomeViewController *homeVC = (HomeViewController *)[nav.viewControllers objectAtIndex:0];
    [homeVC beginTest:nil];

    
    
    [self dismissViewControllerAnimated:NO completion:nil];
}



- (IBAction)how_backAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (IBAction)how_closeAction:(id)sender {
    StartViewController *startVC = (StartViewController *)self.presentingViewController;
    [startVC closeMenuAction:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}




- (IBAction)phoneAction:(id)sender {
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

- (IBAction)emailAction:(id)sender {
    MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
    compose.mailComposeDelegate = self;
    
    [compose setToRecipients:[NSArray arrayWithObjects:@"mobiletest@audicus.com", nil]];
    //[compose setSubject:@"From my app"];
    [compose setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:compose animated:YES completion:nil];
}


- (IBAction)websiteAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:@"http://www.audicus.com"]];
}





- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //NSLog(@"HIII");
    //NSString *updatedString = [aTextView.text stringByReplacingCharactersInRange:range withString:text];
    //textView.text = updatedString;
    [aTextView replaceRange:aTextView.selectedTextRange withText:text];
    return NO;
    
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


@end
