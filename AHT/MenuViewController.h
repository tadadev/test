//
//  MenuViewController.h
//  AHT
//
//  Created by Troy DeMar on 2/25/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuDelegate <NSObject>
- (IBAction)homeAction:(id)sender;
- (IBAction)resultsAction:(id)sender;
- (IBAction)howAction:(id)sender;
- (IBAction)emailAction:(id)sender;
- (IBAction)callAction:(id)sender;
- (IBAction)contactAction:(id)sender;
- (IBAction)closeAction:(id)sender;

@end



@interface MenuViewController : UIViewController {
    IBOutlet UIButton *homeBtn, *resultsBtn, *contactBtn;
    
    BOOL isVisible;
}

@property (strong, nonatomic) UIButton *homeBtn, *resultsBtn, *contactBtn;

@property (nonatomic) BOOL isVisible;
@property (assign) id <MenuDelegate> delegate;


- (void)displayMenuInView:(UIView *)parentView;
- (void)dismissMenu;

@end
