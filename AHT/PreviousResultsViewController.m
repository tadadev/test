//
//  PreviousResultsViewController.m
//  AHT
//
//  Created by Troy DeMar on 3/7/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "PreviousResultsViewController.h"
#import "ResultsTableViewCell.h"
#import "StartViewController.h"
#import "ToastManager.h"
#import "DataSurrogate.h"

@interface PreviousResultsViewController ()
@property (strong, nonatomic) NSMutableArray *chartArray;
@end

@implementation PreviousResultsViewController
@synthesize tableContainer;
@synthesize dataTableView, tapButton;
//@synthesize result;

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
    
    //Data Table
    dataTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dataTableView.HVTableViewDelegate = self;
    self.dataTableView.HVTableViewDataSource = self;
    
    //Tap Button
    tapButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [tapButton setTitle:@"Tap to receive your audiogram from\nthis test." forState:UIControlStateNormal];
    tapButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    tapButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
//    tapButton.titleLabel.textColor = [UIColor whiteColor];
//    
    
//    JBBarChartView *barChartView = [[JBBarChartView alloc] init];
//    barChartView.frame = CGRectMake(10, 150, 50, 100);
//    barChartView.minimumValue = 0.0f;
//    barChartView.dataSource = self;
//    barChartView.delegate = self;
//    barChartView.backgroundColor = [UIColor darkGrayColor];
//    [self.view addSubview:barChartView];
//    [barChartView reloadData];
    
    self.chartArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    [self performSelector:@selector(animateCharts) withObject:nil afterDelay:2.0];
    

    
    
    [DataSurrogate emailTextForResult:self.result];
    NSLog(@"Low Left Score: %f", [[DataSurrogate sharedInstance] lowFrequencyScoreFromResults:self.result forLeftEar:YES]);
    
    NSLog(@"Med Left Score: %f", [[DataSurrogate sharedInstance] medFrequencyScoreFromResults:self.result forLeftEar:YES]);

    NSLog(@"High Left Score: %f", [[DataSurrogate sharedInstance] highFrequencyScoreFromResults:self.result forLeftEar:YES]);

}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [dataTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

}


- (void)animateCharts{
    for (JBChartView *chart in self.chartArray) {
        [chart setState:JBChartViewStateExpanded animated:YES];
    }

    //[dataTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    //[dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}




#pragma mark - IBAction Methods

- (IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeAction:(id)sender{
    StartViewController *startVC = (StartViewController *)self.presentingViewController;
    [startVC closeMenuAction:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (IBAction)emailToastAction:(id)sender {
    [ToastManager toastEmail];
}




//perform your expand stuff (may include animation) for cell here. It will be called when the user touches a cell
-(void)tableView:(UITableView *)tableView expandCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    ResultsTableViewCell *myCell = (ResultsTableViewCell *)cell;
    myCell.scoreLabel.alpha = 0;
    
    [UIView animateWithDuration:.5 animations:^{
//        detailLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        myCell.scoreLabel.hidden = NO;
        myCell.scoreLabel.alpha = 1;
        
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);
    }];
}

//perform your collapse stuff (may include animation) for cell here. It will be called when the user touches an expanded cell so it gets collapsed or the table is in the expandOnlyOneCell satate and the user touches another item, So the last expanded item has to collapse
-(void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    ResultsTableViewCell *myCell = (ResultsTableViewCell *)cell;

    
    [UIView animateWithDuration:.5 animations:^{

        myCell.scoreLabel.hidden = YES;
        myCell.scoreLabel.alpha = 0;
        
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(-3.14);
    
    } completion:^(BOOL finished) {
//        purchaseButton.hidden = YES;
    }];
}








-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded{
    static NSString *CellIdentifier = @"Content1";
    ResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        cell.freqLabel.text = @"Low Frequencies";
        //cell.scoreLabel = [NSString stringWithFormat:@"Hearing score: %f", [[DataSurrogate sharedInstance] lowFrequencyScoreFromResults:self.result forLeftEar:<#(BOOL)#>]]
    }
    
    else if (indexPath.row == 1)
        cell.freqLabel.text = @"Medium Frequencies";
    
    else if (indexPath.row == 2)
        cell.freqLabel.text = @"High Frequencies";
    
    
    //textLabel.text = [cellTitles objectAtIndex:indexPath.row % 10];
    
    //Chart
    /*
//    JBBarChartView *barChartView = [[JBBarChartView alloc] init];
//    barChartView.frame = CGRectMake(10, 120, 50, 100);
//    barChartView.minimumValue = 0.0f;
//    barChartView.dataSource = self;
//    barChartView.delegate = self;
//    barChartView.backgroundColor = [UIColor darkGrayColor];
//    [cell.contentView addSubview:barChartView];
//    
//    [barChartView reloadData];
//    barChartView.transform = CGAffineTransformMakeRotation(3.14/2);
    cell.chart.dataSource = self;
    cell.chart.delegate = self;
    [cell.chart setState:JBChartViewStateCollapsed animated:YES];
    [cell.chart reloadData];
    [self.chartArray addObject:cell.chart];
    */
    
    
    if (!isExpanded) //prepare the cell as if it was collapsed! (without any animation!)
    {
        //detailLabel.text = @"Lorem ipsum dolor sit amet";
        cell.scoreLabel.hidden = YES;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(0);
    }
    
    else ///prepare the cell as if it was expanded! (without any animation!)
    {
        //detailLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);
    }
    return cell;
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded{
    //you can define different heights for each cell. (then you probably have to calculate the height or e.g. read pre-calculated heights from an array
    if (isexpanded)
        return 200; //300
    
    return 170; //170
}





- (BOOL)visibilityOfCell:(UITableViewCell *)cell inScrollView:(UIScrollView *)scrollView{
    CGRect cellRect = [scrollView convertRect:cell.frame toView:scrollView.superview];
    
    if (CGRectContainsRect(scrollView.frame, cellRect))
        return YES;
    
    return NO;
}


//Revisit for Auto More Loading
#pragma mark -  UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"Content Height: %f", scrollView.contentSize.height);
    
    /*
//    NSArray* cells = dataTableView.visibleCells;
//    
//    NSUInteger cellCount = [cells count];
//    
//    if (cellCount == 0)
//        return;
//    
//    //check 1st Cell
//    if ([self visibilityOfCell:[cells firstObject] inScrollView:scrollView]) {
//        NSLog(@"First Cell is Visible");
//    }
//    
//    else
//        NSLog(@"First Cell NOT Visible");
    */
    
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *path2 = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *path3 = [NSIndexPath indexPathForRow:2 inSection:0];

    ResultsTableViewCell *cell1 = (ResultsTableViewCell *)[dataTableView cellForRowAtIndexPath:path1];
    ResultsTableViewCell *cell2 = (ResultsTableViewCell *)[dataTableView cellForRowAtIndexPath:path2];
    ResultsTableViewCell *cell3 = (ResultsTableViewCell *)[dataTableView cellForRowAtIndexPath:path3];

    //CGRect cellRect1 = [scrollView convertRect:cell1.frame toView:tableContainer];
    CGRect cellRect2 = [scrollView convertRect:cell2.frame toView:tableContainer];
    //CGRect cellRect3 = [scrollView convertRect:cell3.frame toView:tableContainer];

//    CGRect cellRect1 = [dataTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    CGRect cellRect2 = [dataTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

//    NSLog(@"Cell1: %@", NSStringFromCGRect(cellRect1));
//    NSLog(@"   ");
//    NSLog(@"   ");
//    NSLog(@"Cell2: %@", NSStringFromCGRect(cellRect2));
//    NSLog(@" 1/3 of view: %f", tableContainer.frame.size.height/3);
//    NSLog(@"   ");

    
    
    if ([self visibilityOfCell:cell1 inScrollView:scrollView]) {
        NSLog(@"Expand Cell 1");
        [dataTableView expandRowAtIndexPath:path1];
    }
    
    
    else if ([self visibilityOfCell:cell3 inScrollView:scrollView]) {
        //Make sure bottom of cell is at bottom of table (Not Bouncing)
        //Not already Expanded
        
        NSLog(@"Expand Cell 3");
        [dataTableView expandRowAtIndexPath:path3];
        //[dataTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    }
    
    
    else if ([self visibilityOfCell:cell2 inScrollView:scrollView]) {
        if (cellRect2.origin.y <= tableContainer.frame.size.height/3) {
            NSLog(@"Expand Cell 2");
            [dataTableView expandRowAtIndexPath:path2];
        }
    }

}



#pragma mark - JBChartViewDataSource

- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}


#pragma mark - JBBarChartViewDataSource

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return 2;
}


#pragma mark - JBBarChartViewDelegate

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    
    
    if (index==0) {
        NSLog(@"0");
        return 25.0f;
        
    }
    else {
        NSLog(@"1");

        return 15.0f;
        
    }
}


- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    if (index==0) {
        NSLog(@"0");
        return [UIColor blueColor];
    }

    
    else {
        NSLog(@"1");
        return [UIColor redColor];
    }
}


- (CGFloat)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return 30;
}


@end
