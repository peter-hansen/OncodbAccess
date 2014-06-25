//
//  DataViewController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/6/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//
#import "DataViewController.h"
#import "DatabaseViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface DataViewController ()
@property (strong, nonatomic) IBOutlet UIButton *missingButton;
@property NSString *backHTML;
@property NSString *forwardHTML;
@property NSString *currentHTML;
@property NSMutableArray *backHistory;
@property int backLocation;
@property NSMutableArray *forwardHistory;
@end

@implementation DataViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)newSearch:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)screenCapture:(id)sender {
    CGRect originalFrame = _webView.frame;
    CGRect frame = _webView.frame;
    frame.size.height = 1;
    _webView.frame = frame;
    CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    _webView.frame = frame;
    UIGraphicsBeginImageContextWithOptions(_webView.bounds.size, NO, [UIScreen mainScreen].scale);
    [_webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    _webView.frame = originalFrame;
}
- (IBAction)back:(id)sender {
    if(_backLocation >= 0) {
        [_forwardHistory addObject:_currentHTML];
        [_webView loadHTMLString:[_backHistory[_backLocation] description] baseURL:nil];
        _currentHTML = _backHistory[_backLocation];
        _backLocation--;
        [_backHistory removeObjectAtIndex:[_backHistory count] -1];
    }
}
- (IBAction)forward:(id)sender {
    if([_forwardHistory count] != 0) {
        [_backHistory addObject:_currentHTML];
        _backLocation++;
        [_webView loadHTMLString:[[_forwardHistory lastObject] description] baseURL:nil];
        _currentHTML = [_forwardHistory lastObject];
        [_forwardHistory removeObjectAtIndex:[_forwardHistory count] -1];
    }
}
- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obtain current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(UIDeviceOrientationIsLandscape(orientation)) {
        _webView.layer.frame = CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width-45);
    }
    if(UIDeviceOrientationIsPortrait(orientation)) {
        _webView.layer.frame = CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.height - 45, [UIScreen mainScreen].bounds.size.width);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:   @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    //instantiate the web view
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 45)];
    [_webView setDelegate:self];
    [_webView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    _webView.scalesPageToFit=YES;
    //make the background transparent
    [_webView setBackgroundColor:[UIColor clearColor]];
    //Get just the data we want from the table
    NSArray* splittedArray= [_html componentsSeparatedByString:@"<div class=heatmap>"];
    if([_html rangeOfString:@"Transcripts(+)"].location == NSNotFound) {
        NSString *message = @"There were no results for the given search parameters. (Tip:If you don't find your gene of interest in the Full-Text query add two wildcards (%), e.g. \"%CD45%\") ";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Emtpy Response" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    NSMutableString *secondhtml = [[NSMutableString alloc]init];
    if(splittedArray[1]){
        secondhtml = splittedArray[1];
    } else {
        return;
    }
    splittedArray= [secondhtml componentsSeparatedByString:@"<!-- footer wrapper -->"];
    secondhtml = splittedArray[0];
    NSMutableString *thirdhtml = [[NSMutableString alloc]init];
    if([secondhtml rangeOfString:@"/images/"].location != NSNotFound) {
        splittedArray= [secondhtml componentsSeparatedByString:@"/images/"];
        if([splittedArray count] > 2) {
            thirdhtml = [splittedArray[0] mutableCopy];
            [thirdhtml appendString:(@"http://nci-oncomics-1.nci.nih.gov/images/")];
            [thirdhtml appendString:(splittedArray[1])];
            [thirdhtml appendString:(@"http://nci-oncomics-1.nci.nih.gov/images/")];
            [thirdhtml appendString:(splittedArray[2])];
            secondhtml = thirdhtml;
        }
    }
//    [thirdhtml appendString:@"&nbsp;</div></td></tr></tbody></table>"];
    //pass the string to the webview
    _currentHTML = secondhtml;
    _backHistory = [[NSMutableArray alloc]init];
    _forwardHistory = [[NSMutableArray alloc]init];
 //   [_backhistory addObject:thirdhtml];
    _backLocation = -1;
    [_webView loadHTMLString:[secondhtml description] baseURL:nil];
    
    //add it to the subview
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebView Navigation
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = request.URL;
    NSString *urlPath = [url absoluteString];
    if(![urlPath  isEqual: @"about:blank"]) {
        NSString *transcriptHTML = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        if (navigationType == UIWebViewNavigationTypeLinkClicked && [urlPath rangeOfString:(@"http://nci-oncomics-1.nci.nih.gov/")].location != NSNotFound && [transcriptHTML rangeOfString:(@"<div class=heatmap>")].location != NSNotFound){
            
            NSArray* splittedArray= [transcriptHTML componentsSeparatedByString:@"<div class=heatmap>"];
            NSMutableString *secondhtml = [[NSMutableString alloc]init];
            if(splittedArray[1]){
                secondhtml = splittedArray[1];
            } else {
                return NO;
            }
            splittedArray= [secondhtml componentsSeparatedByString:@"<!-- footer wrapper -->"];
            secondhtml = splittedArray[0];
            NSMutableString *thirdhtml = [[NSMutableString alloc]init];
            if([secondhtml rangeOfString:@"/images/"].location != NSNotFound) {
                splittedArray= [secondhtml componentsSeparatedByString:@"/images/"];
                if([splittedArray count] > 2) {
                    thirdhtml = [splittedArray[0] mutableCopy];
                    [thirdhtml appendString:(@"http://nci-oncomics-1.nci.nih.gov/images/")];
                    [thirdhtml appendString:(splittedArray[1])];
                    [thirdhtml appendString:(@"http://nci-oncomics-1.nci.nih.gov/images/")];
                    [thirdhtml appendString:(splittedArray[2])];
                    secondhtml = thirdhtml;
                }
            }
            if([transcriptHTML rangeOfString:(@"/help/")].location != NSNotFound){
                NSMutableString *fourthhtml = [[NSMutableString alloc]init];
                splittedArray = [secondhtml componentsSeparatedByString:@"/help/"];
                NSMutableArray *mutArray= [splittedArray mutableCopy];
                fourthhtml = [splittedArray[0] mutableCopy];
                [mutArray removeObjectAtIndex:0];
                for (NSString *key in mutArray) {
                    [fourthhtml appendString:(@"http://nci-oncomics-1.nci.nih.gov/help/")];
                    [fourthhtml appendString:(key)];
                }
                _backHTML = _currentHTML;
                _backLocation++;
                [_backHistory addObject:_currentHTML];
                _currentHTML = fourthhtml;
                [webView loadHTMLString:[fourthhtml description] baseURL:nil];
                return YES;
            }
            _backHTML = _currentHTML;
            _backLocation++;
            [_backHistory addObject:_currentHTML];
            _currentHTML = thirdhtml;
            [webView loadHTMLString:[thirdhtml description] baseURL:nil];
            return YES;
        }
        _backHTML = _currentHTML;
        _backLocation++;
        [_backHistory addObject:_currentHTML];
        _currentHTML = transcriptHTML;
        return YES;
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
