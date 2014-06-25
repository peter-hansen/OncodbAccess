//
//  DatabaseViewController.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/6/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"
@interface DatabaseViewController : UIViewController<NSURLConnectionDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) IBOutlet UIButton *submitTextQuery;
@property (strong, nonatomic) IBOutlet UITextView *textArea;
@property (strong, nonatomic) IBOutlet UITextField *databaseSelect;
@property (strong, nonatomic) IBOutlet UIButton *logout;
@property (strong, nonatomic) IBOutlet UITextField *valueSelect;
@property (strong, nonatomic) IBOutlet UITextField *chromSelect;
@property (strong, nonatomic) IBOutlet UITextField *limitSelect;
@property (strong, nonatomic) IBOutlet UITextField *heatmapValueSelect;
@property (strong, nonatomic) IBOutlet UITextField *orderBySelect;
@property(strong, nonatomic) UIPickerView *databasePicker;
@property(strong, nonatomic) UIPickerView *valuePicker;
@property(strong, nonatomic) UIPickerView *chromPicker;
@property(strong, nonatomic) UIPickerView *limitPicker;
@property(strong, nonatomic) UIPickerView *heatmapValuePicker;
@property(strong, nonatomic) UIPickerView *orderByPicker;
@property(strong, nonatomic) NSArray *values;
@property(strong, nonatomic) NSArray *chroms;
@property(strong, nonatomic) NSArray *limits;
@property(strong, nonatomic) NSArray *heatmapValues;
@property(strong, nonatomic) NSArray *orderBy;
@property(strong, nonatomic) NSString *response;
@property(strong, nonatomic) NSMutableString *databaseHtml;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
@end
