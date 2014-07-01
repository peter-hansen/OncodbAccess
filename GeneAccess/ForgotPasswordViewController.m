//
//  ForgotPasswordViewController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/5/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "FormPost.h"
@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize email;
- (BOOL)shouldAutorotate
{
    return NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// Send the request to the server and let it handle things
- (IBAction)submit:(id)sender {
    email = [_emailView text];
    FormPost *submitEmail = [[FormPost alloc] init];
    submitEmail.url = @"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock";
    submitEmail.post = [NSString stringWithFormat:@"rm=forgot_passwd&forgot_passwd_submitted=TRUE&frm=forgot_passwd&email=%@" , email];
    [submitEmail postForm];
}

@end
