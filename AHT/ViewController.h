//
//  ViewController.h
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GAITrackedViewController.h"

//@interface ViewController : UIViewController<UITextViewDelegate, MFMailComposeViewControllerDelegate> {
@interface ViewController : GAITrackedViewController<UITextViewDelegate, MFMailComposeViewControllerDelegate> {

    IBOutlet UIButton *agreeBtn;
    IBOutlet UIWebView *webView;
    IBOutlet UITextView *textView;
    
    
}

@property (strong, nonatomic) UIButton *agreeBtn;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) NSString *viewType;

@end

