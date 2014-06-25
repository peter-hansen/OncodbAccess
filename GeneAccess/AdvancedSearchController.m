//
//  AdvancedSearchController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/20/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "AdvancedSearchController.h"

@interface AdvancedSearchController ()

@end

@implementation AdvancedSearchController
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark PickerView DataSource
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
//    if (pickerView == self.databasePicker) {
//        [databaseSelect setText:[self pickerView:_databasePicker titleForRow:[_databasePicker selectedRowInComponent:0] forComponent:0]];
//    }
//    else if (pickerView == self.valuePicker) {
//        [valueSelect setText:[self pickerView:_valuePicker titleForRow:[_valuePicker selectedRowInComponent:0] forComponent:0]];
//    }
//    else if (pickerView == self.chromPicker) {
//        [chromSelect setText:[self pickerView:_chromPicker titleForRow:[_chromPicker selectedRowInComponent:0] forComponent:0]];
//    }
//    else if (pickerView == self.limitPicker) {
//        [limitSelect setText:[self pickerView:_limitPicker titleForRow:[_limitPicker selectedRowInComponent:0] forComponent:0]];
//    }
//    else if (pickerView == self.heatmapValuePicker) {
//        [heatmapValueSelect setText:[self pickerView:_heatmapValuePicker titleForRow:[_heatmapValuePicker selectedRowInComponent:0] forComponent:0]];
//    }
//    else if (pickerView == self.orderByPicker) {
//        [orderBySelect setText:[self pickerView:_orderByPicker titleForRow:[_orderByPicker selectedRowInComponent:0] forComponent:0]];
//    }
}
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
//    if (pickerView == self.databasePicker) {
//        return [_databases count];
//    }
//    else if (pickerView == self.valuePicker) {
//        return [_values count];
//    }else if (pickerView == self.chromPicker) {
//        return [_chroms count];
//    }else if (pickerView == self.limitPicker) {
//        return [_limits count];
//    }else if (pickerView == self.heatmapValuePicker) {
//        return [_heatmapValues count];
//    }else if (pickerView == self.orderByPicker) {
//        return [_orderBy count];
//    }
//    else{
        return 0;
//    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
//    if (pickerView == self.databasePicker) {
//        return _databases[row];
//    }
//    else if (pickerView == self.valuePicker) {
//        return _values[row];
//    }
//    else if (pickerView == self.chromPicker) {
//        return _chroms[row];
//    }
//    else if (pickerView == self.limitPicker) {
//        return _limits[row];
//    }
//    else if (pickerView == self.heatmapValuePicker) {
//        return _heatmapValues[row];
//    }
//    else if (pickerView == self.orderByPicker) {
//        return _orderBy[row];
//    }
//    else{
        return @"";
//    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
    }
//    if (pickerView == self.databasePicker) {
//        tView.text=_databases[row];
//        tView.font = [UIFont systemFontOfSize:18];
//    }
//    else if (pickerView == self.valuePicker) {
//        tView.text=_values[row];
//    }
//    else if (pickerView == self.chromPicker) {
//        tView.text=_chroms[row];
//    } else if (pickerView == self.limitPicker) {
//        tView.text=_limits[row];
//    }
//    else if (pickerView == self.heatmapValuePicker) {
//        tView.text=_heatmapValues[row];
//        tView.font = [UIFont systemFontOfSize:18];
//    }
//    else if (pickerView == self.orderByPicker) {
//        tView.text=_orderBy[row];
//    }
    return tView;
}

@end
