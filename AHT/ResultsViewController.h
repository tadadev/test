//
//  ResultsViewController.h
//  AHT
//
//  Created by Troy DeMar on 3/5/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestResult.h"
#import "GAITrackedViewController.h"

//@interface ResultsViewController : UIViewController <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate> {
@interface ResultsViewController : GAITrackedViewController <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate> {
    IBOutlet UIView *headerView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UICollectionView *collectionView;
    IBOutlet UIView *footerView;
    IBOutlet UIButton *footBtn;
    TestResult *selectedResult;
    
    UILabel *oLabel, *hLabel, *mLabel, *lLabel;
    
    CGFloat prevOffset;
    
    IBOutlet UIButton *testButton;
    IBOutlet UILabel *testLabel;
}

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) TestResult *selectedResult;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *footBtn;

@property (strong, nonatomic) UIButton *testButton;
@property (strong, nonatomic) UILabel *testLabel;
@end
