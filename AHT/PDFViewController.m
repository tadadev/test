//
//  PDFViewController.m
//  AHT
//
//  Created by Troy DeMar on 4/15/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "PDFViewController.h"
#import "PNCircleChart.h"

@interface PDFViewController ()

@end

@implementation PDFViewController
@synthesize leftView, rightView;
@synthesize dateLabel;

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
    
    NSLog(@"PDFViewController");
    
    [self buildLeft];
}

- (void)buildLeft{
    
    //Top
    UIColor *topColor = [UIColor colorWithRed:238/255.0f green:141/255.0f blue:34/255.0f alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:255/255.0f green:205/255.0f blue:0/255.0f alpha:1];
    
    
    PNCircleChart *highChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(20, 70, 90, 90) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    highChartL.backgroundColor = [UIColor clearColor];
    [highChartL setStrokeColor:topColor];
    [highChartL strokeChart];
    [leftView addSubview:highChartL];
    
    PNCircleChart *highChartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(20, 85, 90, 60) total:[NSNumber numberWithInt:1] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
    highChartR.backgroundColor = [UIColor clearColor];
    [highChartR setStrokeColor:bottomColor];
    [highChartR strokeChart];
    [leftView addSubview:highChartR];
    
    UILabel *highLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.5, 105, 20, 20)];
    highLabel.textAlignment = NSTextAlignmentCenter;
    highLabel.text = @"H";
    highLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:18];
    [leftView addSubview:highLabel];
    
    
    //Bottom
    
}


@end
