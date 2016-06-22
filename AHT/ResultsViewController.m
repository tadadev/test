//
//  ResultsViewController.m
//  AHT
//
//  Created by Troy DeMar on 3/5/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ResultsViewController.h"
#import "DataSurrogate.h"
#import "SummaryCollectionViewCell.h"
#import "FrequencyCollectionViewCell.h"
#import "ToastManager.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


static const CGFloat FONT_SIZE = 25;
static const CGFloat WIDTH_SPACE = 36;
static const NSTimeInterval ANIMATE_TIME = 0.75;

@interface ResultsViewController ()
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic) int labelIndex;
@property (nonatomic) BOOL isHeaderSet;
@property (nonatomic) BOOL animating;

@end

@implementation ResultsViewController
@synthesize headerView, scrollView, collectionView, footerView;
@synthesize selectedResult;
@synthesize footBtn;

@synthesize testButton, testLabel;

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
//    NSLog(@"viewDidLoad");
    NSLog(@"Results VC Width: %f", self.view.frame.size.width);
    NSLog(@"Header View Width: %f", headerView.frame.size.width);

//    [self.collectionView registerClass:[FrequencyCollectionViewCell class] forCellWithReuseIdentifier:@"FrequencyCell"];
    
    
    oLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:oLabel];

    hLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:hLabel];

    
    mLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:mLabel];

    
    lLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:lLabel];

    self.labelArray = [[NSMutableArray alloc] initWithObjects:oLabel, hLabel, mLabel, lLabel, nil];
    self.labelIndex = 0;
    
    
//    [self setupHeader];
    
    
//    footBtn.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 60);
//    footBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);

    [self performSelector:@selector(displayFooter) withObject:nil afterDelay:1.0];
    
    
//    NSArray *results = [TestResult MR_findAllSortedBy:@"startedDate" ascending:NO];
//    NSLog(@"Results: %i", results.count);
//    self.selectedResult = results[2];
//    self.selectedResult = results[0];

//    [self performSelector:@selector(animateHeaderNext) withObject:nil afterDelay:1.0];
//    [self performSelector:@selector(animateHeaderNext) withObject:nil afterDelay:3.0];
//    [self performSelector:@selector(animateHeaderNext) withObject:nil afterDelay:5.0];
//    [self performSelector:@selector(animateHeaderPrevious) withObject:nil afterDelay:5.0];
//    [self performSelector:@selector(animateHeaderPrevious) withObject:nil afterDelay:7.0];
//    [self performSelector:@selector(animateHeaderPrevious) withObject:nil afterDelay:11.0];


//    NSLog(@"Overview Frame: %@", NSStringFromCGRect(oLabel.frame));

    
    
    oLabel.translatesAutoresizingMaskIntoConstraints = YES;
    hLabel.translatesAutoresizingMaskIntoConstraints = YES;
    mLabel.translatesAutoresizingMaskIntoConstraints = YES;
    lLabel.translatesAutoresizingMaskIntoConstraints = YES;

//    testButton.translatesAutoresizingMaskIntoConstraints = YES;
    testLabel.text = [NSString stringWithFormat:@"%i", self.labelIndex];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Analytics
    //Google
    self.screenName = @"Test Results Screen";
    
    //FB
    [FBSDKAppEvents logEvent:@"Test Results Screen"];
}



- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
//    [self setupHeader];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self setupHeader];
}



- (void)setupHeader{
//    NSLog(@"Results VC Width: %f", self.view.frame.size.width);
//    NSLog(@"Header View Width: %f", headerView.frame.size.width);
    
    if (self.isHeaderSet)
        return;
    
//    NSLog(@"---SETUP HEADER---");
    
    
    self.isHeaderSet = YES;
    CGFloat width = headerView.frame.size.width;
    CGFloat height = headerView.frame.size.height;
    UIColor *LIGHT_COLOR = [UIColor grayColor];

    NSString *oString = @"Overview";
//    oLabel.backgroundColor = [UIColor blueColor];
    oLabel.text = oString;
    oLabel.textAlignment = NSTextAlignmentCenter;
    oLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:FONT_SIZE];
    oLabel.textColor = [UIColor blackColor];
    CGRect oFrame = [oString boundingRectWithSize:CGSizeMake(width, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:oLabel.font} context:nil];
    oLabel.frame = CGRectMake(width/2 - oFrame.size.width/2, height/2 - 30/2, oFrame.size.width, 30);
    
    NSString *hString = @"High Frequencies";
//    hLabel.backgroundColor = [UIColor yellowColor];
    hLabel.text = hString;
    hLabel.textAlignment = NSTextAlignmentCenter;
    hLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:FONT_SIZE];
    hLabel.textColor = LIGHT_COLOR;
    CGRect hFrame = [hString boundingRectWithSize:CGSizeMake(width, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:hLabel.font} context:nil];
//    hLabel.frame = CGRectMake(width-WIDTH_SPACE, height/2 - 30/2, hFrame.size.width, 30);
    hLabel.frame = CGRectMake(width-WIDTH_SPACE, height/2 - 30/2, hFrame.size.width, 30);

    
    
    NSString *mString = @"Middle Frequencies";
//    mLabel.backgroundColor = [UIColor redColor];
    mLabel.text = mString;
    mLabel.textAlignment = NSTextAlignmentCenter;
    mLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:FONT_SIZE];
    mLabel.textColor = LIGHT_COLOR;
    CGRect mFrame = [mString boundingRectWithSize:CGSizeMake(width, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:mLabel.font} context:nil];
    mLabel.frame = CGRectMake(width*2-WIDTH_SPACE, height/2 - 30/2, mFrame.size.width, 30);

    
    NSString *lString = @"Low Frequencies";
//    lLabel.backgroundColor = [UIColor brownColor];
    lLabel.text = lString;
    lLabel.textAlignment = NSTextAlignmentCenter;
    lLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:FONT_SIZE];
    lLabel.textColor = LIGHT_COLOR;
    CGRect lFrame = [lString boundingRectWithSize:CGSizeMake(width, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lLabel.font} context:nil];
    lLabel.frame = CGRectMake(width*3-WIDTH_SPACE, height/2 - 30/2, lFrame.size.width, 30);

    
    
    
    
    
//    UILabel *other = [[UILabel alloc] init];
//    other.text = oString;
//    other.textAlignment = NSTextAlignmentCenter;
//    other.font = [UIFont fontWithName:@"Roboto-Regular" size:FONT_SIZE];
//    other.textColor = [UIColor blackColor];
//    CGRect ooFrame = [oString boundingRectWithSize:CGSizeMake(width, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:oLabel.font} context:nil];
//    other.frame = CGRectMake(width/2 - ooFrame.size.width/2, 60, ooFrame.size.width, 30);
//    [headerView addSubview:other];
}

- (void)resetHeaderLabels{
//    NSLog(@"Reset: New Index: %i", self.labelIndex);
    CGFloat width = headerView.frame.size.width;
    CGFloat y = headerView.frame.size.height/2 - 30/2;
    
    CGFloat C, R0, R1, R2;
    
    
    C = width/2;
    R0 = width*1 - WIDTH_SPACE;
    R1 = width*2 - WIDTH_SPACE;
    R2 = width*3 - WIDTH_SPACE;

    
    if (self.labelIndex == 0) {
        oLabel.frame = CGRectMake(C - oLabel.frame.size.width/2, y, oLabel.frame.size.width, 30);
        //oLabel.frame = CGRectMake(109.36523, y, oLabel.frame.size.width, 30);

        //109.36523
        hLabel.frame = CGRectMake(R0, y, hLabel.frame.size.width, 30);
        mLabel.frame = CGRectMake(R1, y, mLabel.frame.size.width, 30);
        lLabel.frame = CGRectMake(R2, y, lLabel.frame.size.width, 30);
        
        oLabel.textColor = [UIColor blackColor];
        hLabel.textColor = [UIColor grayColor];
        mLabel.textColor = [UIColor grayColor];
        lLabel.textColor = [UIColor grayColor];
    }
    
    else if (self.labelIndex == 1) {
        oLabel.frame = CGRectMake(0-oLabel.frame.size.width*1 +WIDTH_SPACE, y, oLabel.frame.size.width, 30);
        hLabel.frame = CGRectMake(C- hLabel.frame.size.width/2, y, hLabel.frame.size.width, 30);
        mLabel.frame = CGRectMake(R0, y, mLabel.frame.size.width, 30);
        lLabel.frame = CGRectMake(R1, y, lLabel.frame.size.width, 30);
        
        oLabel.textColor = [UIColor grayColor];
        hLabel.textColor = [UIColor blackColor];
        mLabel.textColor = [UIColor grayColor];
        lLabel.textColor = [UIColor grayColor];
    }
    
    else if (self.labelIndex == 2) {
        oLabel.frame = CGRectMake(0-oLabel.frame.size.width*2 +WIDTH_SPACE, y, oLabel.frame.size.width, 30);
        hLabel.frame = CGRectMake(0-hLabel.frame.size.width*1 +WIDTH_SPACE, y, hLabel.frame.size.width, 30);
        mLabel.frame = CGRectMake(C - mLabel.frame.size.width/2, y, mLabel.frame.size.width, 30);
        lLabel.frame = CGRectMake(R0, y, lLabel.frame.size.width, 30);
        
        oLabel.textColor = [UIColor grayColor];
        hLabel.textColor = [UIColor grayColor];
        mLabel.textColor = [UIColor blackColor];
        lLabel.textColor = [UIColor grayColor];

    }
    
    else if (self.labelIndex == 3) {
        oLabel.frame = CGRectMake(0-oLabel.frame.size.width*3 +WIDTH_SPACE, y, oLabel.frame.size.width, 30);
        hLabel.frame = CGRectMake(0-hLabel.frame.size.width*2 +WIDTH_SPACE, y, hLabel.frame.size.width, 30);
        mLabel.frame = CGRectMake(0-mLabel.frame.size.width*1 +WIDTH_SPACE, y, mLabel.frame.size.width, 30);
        lLabel.frame = CGRectMake(C - lLabel.frame.size.width/2, y, lLabel.frame.size.width, 30);
        
        oLabel.textColor = [UIColor grayColor];
        hLabel.textColor = [UIColor grayColor];
        mLabel.textColor = [UIColor grayColor];
        lLabel.textColor = [UIColor blackColor];

    }
    
//    NSLog(@"Overview Frame: %@", NSStringFromCGRect(oLabel.frame));
}

- (void)animateHeaderNext{
    if (self.labelIndex == 4)
        return;
    
    self.animating = YES;

    
    //Out Right to Next Position
    [UIView animateWithDuration:ANIMATE_TIME delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//    [UIView animateWithDuration:1.0 animations:^{
        //UIViewAnimationOptionCurveEaseInOut
        //UIViewAnimationOptionCurveEaseIn
        
        [self resetHeaderLabels];

        
    } completion:^(BOOL finished) {
        //NSLog(@"Animation Finished");
        
        if (finished) {
            self.animating = NO;

        }

        //[self resetHeaderLabels];
        //testLabel.text = [NSString stringWithFormat:@"%i", self.labelIndex];

    }];
    

}

- (void)animateHeaderPrevious{
    if (self.labelIndex < 0)
        return;
    
    self.animating = YES;

    
    //Out Left to Previous Position
    [UIView animateWithDuration:ANIMATE_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//    [UIView animateWithDuration:1.0 animations:^{

        [self resetHeaderLabels];

        
    } completion:^(BOOL finished) {
        
        if (finished) {
            self.animating = NO;
        }
        
        //[self resetHeaderLabels];
        //testLabel.text = [NSString stringWithFormat:@"%i", self.labelIndex];

    }];
    
    
}

- (void)cancelAnimations{
    //NSLog(@"Cancel Animations");
    [oLabel.layer removeAllAnimations];
    [hLabel.layer removeAllAnimations];
    [mLabel.layer removeAllAnimations];
    [lLabel.layer removeAllAnimations];
    
    
}


- (void)dragHeaderByOffsetX:(CGFloat)offsetX{    
    if (self.animating)
        return;

//    NSLog(@"Dragging Offset X: %f", offsetX);
    
    UILabel *prev, *current, *next;;

    //Move Previous Out Left
    if (self.labelIndex > 0) {
        prev = [self.labelArray objectAtIndex:self.labelIndex-1];
        prev.frame = CGRectMake(prev.frame.origin.x-offsetX, prev.frame.origin.y, prev.frame.size.width, prev.frame.size.height);
    }
    
    
    //Move Current to Previous
    current = [self.labelArray objectAtIndex:self.labelIndex];
    current.frame = CGRectMake(current.frame.origin.x-offsetX, current.frame.origin.y, current.frame.size.width, current.frame.size.height);
    
    
    //Move Next to Current
    if (self.labelIndex+1 < self.labelArray.count) {
        next = [self.labelArray objectAtIndex:self.labelIndex+1];
        next.frame = CGRectMake(next.frame.origin.x-offsetX, next.frame.origin.y, next.frame.size.width, next.frame.size.height);
    }

    
    //oLabel.frame = CGRectMake(oLabel.frame.origin.x-offsetX, oLabel.frame.origin.y, oLabel.frame.size.width, oLabel.frame.size.height);
//    testButton.frame = CGRectMake(testButton.frame.origin.x-offsetX, testButton.frame.origin.y, testButton.frame.size.width, testButton.frame.size.height);

}


- (void)displayFooter{
    CGFloat height = footerView.frame.size.height;  //95;

    footerView.frame = CGRectMake(0, self.view.frame.size.height, footerView.frame.size.width, height);
    
    
    CGRect frame = CGRectMake(0, self.view.frame.size.height-height, footerView.frame.size.width, height);
    footerView.hidden = NO;
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //UIViewAnimationOptionCurveEaseInOut
        footerView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
//    CGRect frame = footBtn.frame;
//    frame.origin.y = self.view.frame.size.height - footBtn.frame.size.height;
//    
//    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        //UIViewAnimationOptionCurveEaseInOut
//        footerView.frame = frame;
//    } completion:^(BOOL finished) {
//        
//    }];

    
}




#pragma mark - IBAction Methods

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
}


- (IBAction)emailToastAction:(id)sender {
    //Analytics
    //Google
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Email Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    //FB
    [FBSDKAppEvents logEvent:@"Email Screen"];
    
    
    [[DataSurrogate sharedInstance] generatePDFfromResults:self.selectedResult];
    [ToastManager toastEmail];
}


- (IBAction)test1:(id)sender{
    NSLog(@"Overview Frame: %@", NSStringFromCGRect(oLabel.frame));
    NSLog(@"High Frame: %@", NSStringFromCGRect(hLabel.frame));

//    oLabel.frame = CGRectMake(oLabel.frame.origin.x+20, oLabel.frame.origin.y, oLabel.frame.size.width, oLabel.frame.size.height);
    
    //self.labelIndex ++;
    testLabel.text = [NSString stringWithFormat:@"%i", self.labelIndex];

    //NSLog(@"Label Index: %i", self.labelIndex);

}

- (IBAction)test2:(id)sender{

    self.labelIndex --;
    testLabel.text = [NSString stringWithFormat:@"%i", self.labelIndex];

    NSLog(@"Label Index: %i", self.labelIndex);
}

- (IBAction)test3:(id)sender{
    [self resetHeaderLabels];
    testLabel.text = [NSString stringWithFormat:@"%i", self.labelIndex];

}





#pragma mark - UIScrollViewDelegate Delegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{
    CGFloat offsetX = aScrollView.contentOffset.x;
    //NSLog(@"Offset: %f", offsetX/100);
    
    
    static NSInteger previousPage = 0;
    
    CGFloat pageWidth = aScrollView.frame.size.width;
    float fractionalPage = aScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Page has changed, do your thing!
        //NSLog(@"Page:%i -- Previous:%i", page, previousPage);
        
        self.labelIndex = page;
        
        if (page > previousPage) {
            NSLog(@"next");
            
            if (self.animating) {
                [self cancelAnimations];
                self.labelIndex = page;
                testLabel.text = [NSString stringWithFormat:@"%i", self.labelIndex];

                //[self resetHeaderLabels];
            }
            
            [self animateHeaderNext];
        }
        else {
            NSLog(@"prev");
            
            if (self.animating) {
                [self cancelAnimations];
                self.labelIndex = page;
                testLabel.text = [NSString stringWithFormat:@"%i", self.labelIndex];

                //[self resetHeaderLabels];
            }
            
            [self animateHeaderPrevious];
        }
        
        // Finally, update previous page
        previousPage = page;
        
        return;
    }

    
    
    CGFloat move;
    if (offsetX < prevOffset) {
        //Moving Right
        //NSLog(@"Drag Header Right");
        move = prevOffset-offsetX;
        move = move * -1;
    }
    else {
        //Moving Left
        //NSLog(@"Drag Header Left");
        move = offsetX-prevOffset;
    }

    [self dragHeaderByOffsetX:move/8];
    
    
    prevOffset = offsetX;
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)aScrollView
{
//    NSLog(@"scrollViewWillBeginDecelerating");
    
    /*
    static NSInteger previousPage = 0;
    CGFloat pageWidth = aScrollView.frame.size.width;
    float fractionalPage = aScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Page has changed, do your thing!
        NSLog(@"Page: %i", page);
        
        //[self animateHeaderNext];
        if (page > previousPage)
            NSLog(@"Next");
        
        else
            NSLog(@"Previous");
        
        // Finally, update previous page
        previousPage = page;
    }
    */
    
    collectionView.userInteractionEnabled = NO;
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
//    NSLog(@"scrollViewDidEndDecelerating");
    //Run your code on the current page
    collectionView.userInteractionEnabled = YES;
}


#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return  4;   //4
    

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        SummaryCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SummaryCell" forIndexPath:indexPath];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@", [self.selectedResult formattedFinishedDate]];
//        cell.scoreLabel.text = [[DataSurrogate sharedInstance] scoreFromResults:self.selectedResult];
//        cell.textView.text = [[DataSurrogate sharedInstance] scoreDescriptionFromResults:self.selectedResult];
        
        cell.scoreLabel.text = [[DataSurrogate sharedInstance] lowestScoreFromResults:self.selectedResult];
        cell.textView.attributedText = [[DataSurrogate sharedInstance] lowestScoreDescriptionFromResults:self.selectedResult];
        
        return cell;
    }
    
    else {
        FrequencyCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FrequencyCell" forIndexPath:indexPath];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // resizeScrollViewMethod should be where scrollview content size > scroll view frame.
//            [cell resizeScrollViewMethod];
//        });

        
        [[DataSurrogate sharedInstance] lowFreqTextFromResults:self.selectedResult];
        
        float leftScore, rightScore;
        NSString *detail;
        if (indexPath.row == 1) {
            //High
            leftScore = [[DataSurrogate sharedInstance] highFrequencyScoreFromResults:self.selectedResult forLeftEar:YES];
            rightScore = [[DataSurrogate sharedInstance] highFrequencyScoreFromResults:self.selectedResult forLeftEar:NO];
//            detail = @"High frequency hearing loss is very common and affects the clarity of speech.";
            
            detail = [[DataSurrogate sharedInstance] highFreqTextFromResults:self.selectedResult];

        }
        
        else if (indexPath.row == 2) {
            //Mid
            leftScore = [[DataSurrogate sharedInstance] medFrequencyScoreFromResults:self.selectedResult forLeftEar:YES];
            rightScore = [[DataSurrogate sharedInstance] medFrequencyScoreFromResults:self.selectedResult forLeftEar:NO];
//            detail = @"Mid Frequency hearing loss typically affects speech.";
            
            detail = [[DataSurrogate sharedInstance] medFreqTextFromResults:self.selectedResult];
        }
        
        else if (indexPath.row == 3) {
            //Low
            leftScore = [[DataSurrogate sharedInstance] lowFrequencyScoreFromResults:self.selectedResult forLeftEar:YES];
            rightScore = [[DataSurrogate sharedInstance] lowFrequencyScoreFromResults:self.selectedResult forLeftEar:NO];
            //detail = @"Low Frequency hearing loss tends to be less common and affects pitches below 2000Hz. As a result understanding phone conversations or accents can become more challenging.";
            
            detail = [[DataSurrogate sharedInstance] lowFreqTextFromResults:self.selectedResult];
        }
        
//        NSLog(@"Left Score: %f", leftScore);
//        NSLog(@"Right Score: %f", rightScore);
//        NSLog(@"Left: %i", (int)roundf(leftScore*100));

        cell.leftLabel.text = [NSString stringWithFormat:@"%i%%", (int)roundf(leftScore*100)];
        cell.rightLabel.text = [NSString stringWithFormat:@"%i%%", (int)roundf(rightScore*100)];
        
        [cell.chartL updateChartByCurrent:[NSNumber numberWithFloat:leftScore]];
        [cell.chartR updateChartByCurrent:[NSNumber numberWithFloat:rightScore]];
        
        cell.textView.text = detail;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // resizeScrollViewMethod should be where scrollview content size > scroll view frame.
            [cell resizeScrollViewMethod];
            [cell.scrollView setContentOffset:CGPointZero animated:NO];
            
        });
        
        return cell;
    }

}






#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}



#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0f;
}


/* ----------------- TESTING -------------*/

- (void)setupScrollView{
    //CGFloat height = scrollView.frame.size.height;
    
    //    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, height)];
    //    lbl1.text = @"Overview";
    //    [scrollView addSubview:lbl1];
    
    //    UIView *blue = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    //    blue.backgroundColor = [UIColor blueColor];
    //    [scrollView addSubview:blue];
    
    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor orangeColor], nil];
    for (int i = 0; i < 4; i++) {
        CGFloat width = 280;
        CGRect frame;
        frame.origin.x = width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = [colors objectAtIndex:i];
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * colors.count, self.scrollView.frame.size.height);
}


@end
