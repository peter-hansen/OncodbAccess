//
//  DataViewController.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/6/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseViewController.h"
@interface DataViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic) NSMutableString *html;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end
