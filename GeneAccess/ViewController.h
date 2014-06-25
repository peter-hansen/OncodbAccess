//
//  ViewController.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/3/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormPost.h"
#import "ViewController.h"
@interface ViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    NSMutableData *_responseData;
}
//Login page
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UIButton *login;
@property (strong, nonatomic) IBOutlet UILabel *usernamePrompt;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UIButton *forgotPassword;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
@property (strong, nonatomic) IBOutlet UIButton *requestAccount;
//Database page

//universal
@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *password;
@property(strong, nonatomic) NSString *response;
@end
