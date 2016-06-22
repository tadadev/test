//
//  ResultsListViewController.m
//  AHT
//
//  Created by Troy DeMar on 3/6/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "ResultsListViewController.h"
#import "DataSurrogate.h"
#import "ListTableViewCell.h"
#import "StartViewController.h"
#import "PreviousResultsViewController.h"
#import "TestResult.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"

#import "PDFViewController.h"
#import "PDFView.h"
#import <CoreText/CoreText.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface ResultsListViewController ()
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) TestResult *selectedResult;

@end

@implementation ResultsListViewController
@synthesize dataTableView;
@synthesize resultsTextView;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue");
    PreviousResultsViewController *prevResultVC = (PreviousResultsViewController *)[segue destinationViewController];
    prevResultVC.result = self.selectedResult;

}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    resultsTextView.text = RESULTS_LIST;
    
    //Data Table
    dataTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    // Do any additional setup after loading the view.
    self.results = [TestResult MR_findAllSortedBy:@"startedDate" ascending:NO];

    //Header Text
    if (self.results.count == 0) {
        resultsTextView.text = RESULTS_EMPTY;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Analytics
    //Google
    self.screenName = @"All Results Screen";
    
    //FB
    [FBSDKAppEvents logEvent:@"All Results Screen"];
}




#pragma mark - IBAction Methods

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (IBAction)closeAction:(id)sender {
    StartViewController *startVC = (StartViewController *)self.presentingViewController;
    [startVC closeMenuAction:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return self.results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TestResult *result = _results[indexPath.row];
    static NSString *cellIdentifier = @"ResultCell";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // resizeScrollViewMethod should be where scrollview content size > scroll view frame.
        [cell resizeViewMethod];
    });

    
    
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", [result formattedFinishedDate]];

    float hLeft = [[DataSurrogate sharedInstance] highFrequencyScoreFromResults:result forLeftEar:YES];
    float hRight = [[DataSurrogate sharedInstance] highFrequencyScoreFromResults:result forLeftEar:NO];

    float mLeft = [[DataSurrogate sharedInstance] medFrequencyScoreFromResults:result forLeftEar:YES];
    float mRight = [[DataSurrogate sharedInstance] medFrequencyScoreFromResults:result forLeftEar:NO];
    
    float lLeft = [[DataSurrogate sharedInstance] lowFrequencyScoreFromResults:result forLeftEar:YES];
    float lRight = [[DataSurrogate sharedInstance] lowFrequencyScoreFromResults:result forLeftEar:NO];

    [cell.highChartL updateChartByCurrent:[NSNumber numberWithFloat:hLeft]];
    [cell.highChartR updateChartByCurrent:[NSNumber numberWithFloat:hRight]];
    
    [cell.midChartL updateChartByCurrent:[NSNumber numberWithFloat:mLeft]];
    [cell.midChartR updateChartByCurrent:[NSNumber numberWithFloat:mRight]];
    
    [cell.lowChartL updateChartByCurrent:[NSNumber numberWithFloat:lLeft]];
    [cell.lowChartR updateChartByCurrent:[NSNumber numberWithFloat:lRight]];

    return cell;
}


- (void)addChartstoCell:(ListTableViewCell *)cell{
    
    if (cell.highChartL == nil) {
        cell.highChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(20, 70, 90, 90) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
        cell.highChartL.backgroundColor = [UIColor clearColor];
        [cell.highChartL setStrokeColor:PNYellow];
        [cell.highChartL strokeChart];
        [cell.contentView addSubview:cell.highChartL];
        
        cell.highChartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(20, 85, 90, 60) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
        cell.highChartR.backgroundColor = [UIColor clearColor];
        [cell.highChartR setStrokeColor:PNYellow];
        [cell.highChartR strokeChart];
        [cell.contentView addSubview:cell.highChartR];
        
        
        
        cell.midChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(120, 70, 90, 90) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
        cell.midChartL.backgroundColor = [UIColor clearColor];
        [cell.midChartL setStrokeColor:PNYellow];
        [cell.midChartL strokeChart];
        [cell.contentView addSubview:cell.midChartL];
        
        cell.midChartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(120, 85, 90, 60) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
        cell.midChartR.backgroundColor = [UIColor clearColor];
        [cell.midChartR setStrokeColor:PNYellow];
        [cell.midChartR strokeChart];
        [cell.contentView addSubview:cell.midChartR];
        
        
        
        cell.lowChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(220, 70, 90, 90) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
        cell.lowChartL.backgroundColor = [UIColor clearColor];
        [cell.lowChartL setStrokeColor:PNYellow];
        [cell.lowChartL strokeChart];
        [cell.contentView addSubview:cell.lowChartL];
        
        cell.lowChartR = [[PNCircleChart alloc] initWithFrame:CGRectMake(120, 85, 90, 60) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
        cell.lowChartR.backgroundColor = [UIColor clearColor];
        [cell.lowChartR setStrokeColor:PNYellow];
        [cell.lowChartR strokeChart];
        [cell.contentView addSubview:cell.lowChartR];
    }
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedResult = _results[indexPath.row];
    
    //[self performSegueWithIdentifier:@"resultsSegue" sender:nil];


    ContainerViewController *containVC = (ContainerViewController *)self.parentViewController;
    [containVC toResult:_results[indexPath.row]];
//    [containVC toResults];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180.0f;
}







- (IBAction)pdfAction:(id)sender{

//    PDFViewController *pdfController = [self.storyboard instantiateViewControllerWithIdentifier:@"PDFController2"];
//    pdfController.dateLabel.text = @"Today's date is 04/23/15";
//    
//    UIView *pdfView = pdfController.view;
//    pdfView.frame = CGRectMake(0, 0, 600, 600);
    
//    UIColor *topColor = [UIColor colorWithRed:238/255.0f green:141/255.0f blue:34/255.0f alpha:1];
//    UIColor *bottomColor = [UIColor colorWithRed:255/255.0f green:205/255.0f blue:0/255.0f alpha:1];
//    PNCircleChart *highChartL = [[PNCircleChart alloc] initWithFrame:CGRectMake(20, 170, 90, 90) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:75] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:10]];
//    highChartL.backgroundColor = [UIColor clearColor];
//    [highChartL setStrokeColor:topColor];
//    [highChartL strokeChart];
//    [pdfView addSubview:highChartL];


    TestResult *result = _results[0];
    //[DataSurrogate generatePDFfromResults:result];
    [[DataSurrogate sharedInstance] generatePDFfromResults:result];

    
    
    
    //[self createPDFfromUIView:pdf saveToDocumentsWithFileName:@"PDF_TEST.pdf"];
    //[self.view addSubview:pdf];
}


- (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename{
    /*
    NSString* textToDraw = @"Results from April 14, 2015";
//    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    
    
    // Prepare the text using a Core Text Framesetter
//    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    //    create attributed string
    CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrStr, CFRangeMake(0, 0), (CFStringRef) textToDraw);

    //    create font
    CTFontRef font = CTFontCreateWithName(CFSTR("Noteworthy-Light"), 25, NULL);
 

    //    set font attribute
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font);
    //CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font);

    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStr);
    
    
    
    CGRect frameRect = CGRectMake(0, 0, 350, 50);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    */
    
    
    
    NSLog(@"View's Bound: %@", NSStringFromCGRect(aView.bounds));
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    
    
    
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    [aView.layer renderInContext:pdfContext];
    
    
    /*
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(pdfContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(pdfContext, 0, 100);
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    
    
    // Draw the frame.
    CTFrameDraw(frameRef, pdfContext);
    
    CFRelease(frameRef);
//    CFRelease(stringRef);
    CFRelease(framesetter);
    CFRelease(font);
    */
    
    
    for (UIView *subview in [aView subviews]) {
        for (UIView *view in [subview subviews]) {
        
            if([view isKindOfClass:[UILabel class]]) {
                UILabel* label = (UILabel*)view;
                NSLog(@"Label: %@", NSStringFromCGRect(label.frame));
                //[self drawText:label.text inFrame:label.frame];
                [self drawText:label.text inFrame:[label convertRect:label.bounds toView:aView]];
                
            }
        }
        
    }
    
    //[self drawText:@"Hello World" inFrame:CGRectMake(0, 0, 300, 50)];


//    for (UIView *subview in [aView subviews]) {
//        if([subview isKindOfClass:[UILabel class]]) {
//            UILabel* label = (UILabel*)subview;
//            
//            //[self drawText:label.text inFrame:label.frame];
//            [self drawText:label.text inFrame:[label convertRect:label.bounds toView:aView]];
//            
//        }
//    }
    
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
}


- (void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect{
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    // Modify this to take into consideration the origin.
    //CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextTranslateCTM(currentContext, 0, frameRect.size.height + (frameRect.origin.y*2));
    //CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    
    // Add these two lines to reverse the earlier transformation.
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1) * (frameRect.size.height + (frameRect.origin.y*2)));

    
    CFRelease(currentText);
    CFRelease(framesetter);
    CFRelease(frameRef);

}


- (UIImage *)screenShot:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    
//        //Save Image
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Results.jpg"];
//        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    return image;
}






@end
