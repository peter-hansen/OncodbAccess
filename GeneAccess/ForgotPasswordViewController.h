//
//  ForgotPasswordViewController.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/5/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ForgotPasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *emailView;
@property (strong, nonatomic) NSString *email;
@end
