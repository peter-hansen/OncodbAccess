//
//  ViewController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/3/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//
#import "FormPost.h"
#import "ViewController.h"
#import "DatabaseViewController.h"
#import "GseaController.h"
@interface ViewController ()
@end

@implementation ViewController
@synthesize username;
@synthesize password;
@synthesize response;
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.activityWheel startAnimating];
    [textField resignFirstResponder];
    // Create the request.
    username = [_usernameText text];
    password = [_passwordText text];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock"]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // Convert data and set request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"rm=login&login_submitted=TRUE&frm=login&user=%@&password=%@", username, password];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)login:(id)sender {
    [self.activityWheel startAnimating];
    // Create the request.
    username = [_usernameText text];
    password = [_passwordText text];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock"]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // Convert data and set request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"rm=login&login_submitted=TRUE&frm=login&user=%@&password=%@", username, password];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    
    response = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    if([response rangeOfString:@"Not Authenticated"].location == NSNotFound && [response rangeOfString:@"Missing"].location == NSNotFound) {
        _passwordText.text = @"";
        UIStoryboard *storyboard = [[UIStoryboard alloc]init];
        NSString *message = @"Login Successful";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        DatabaseViewController *ViewController = [[DatabaseViewController alloc]init];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            ViewController = (DatabaseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"databases_iPad"];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            ViewController = (DatabaseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"databases"];
        }
 //       GSEAController *ViewController2 = [[GSEAController alloc] init];
 //       ViewController2 = (GSEAController *)[storyboard instantiateViewControllerWithIdentifier:@"GSEA"];
  //      ViewController2.html = [response mutableCopy];
        ViewController.databaseHtml = [response mutableCopy];
        [self presentViewController:ViewController animated:YES completion:nil];
        [self.activityWheel stopAnimating];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot Authenticate Credentials"   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.activityWheel stopAnimating];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    NSString *message = @"ERROR";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}




@end
