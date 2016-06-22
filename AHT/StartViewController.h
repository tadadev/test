//
//  StartViewController.h
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MenuViewController.h"
#import "ContainerViewController.h"
#import <ChimpKit/ChimpKit.h>

@interface StartViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MenuDelegate, MFMailComposeViewControllerDelegate, ChimpKitRequestDelegate> {
    
    IBOutlet UIView *menuView;
    IBOutlet UITableView *myTableView;
    IBOutlet UIView *cancelView;
    
    IBOutlet UIView *containerView;
    IBOutlet UIButton *helpBtn, *cancelBtn;
    
    __weak IBOutlet NSLayoutConstraint *helpTop;
    __weak IBOutlet NSLayoutConstraint *containerTop, *containerBottom;
    __weak IBOutlet NSLayoutConstraint *leftArrowLeft, *rightArrowRight;
    __weak IBOutlet NSLayoutConstraint *cancelBtnTop, *cancelBtnBottom;

    __weak IBOutlet NSLayoutConstraint *tableViewHeight;

    BOOL isMenuVisible;
}

@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) UIView *cancelView;

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIButton *helpBtn, *cancelBtn;


@property (nonatomic, strong) MenuViewController *menuController;
@property (nonatomic, weak) ContainerViewController *containerViewController;


- (IBAction)closeMenuAction:(id)sender;
- (IBAction)TOSAction:(id)sender;


@end
