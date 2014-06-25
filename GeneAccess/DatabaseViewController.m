//
//  DatabaseViewController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/6/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "DatabaseViewController.h"
#import "DataViewController.h"
#import "GSEAController.h"
@interface DatabaseViewController ()
@property (strong, nonatomic) IBOutlet UITextField *chromEnd;
@property (strong, nonatomic) IBOutlet UITextField *chromStart;
@property (strong, nonatomic) IBOutlet UISwitch *heatmapSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *transcriptSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *transcriptLocationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *entrezGeneIdSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *geneSymbolSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *geneTitleSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *membraneProteinSwitch;
@property (strong, nonatomic) IBOutlet UITextField *heatmapThreshold;
@property NSMutableArray *databases;
@property NSMutableDictionary *databaseIDs;
@end

@implementation DatabaseViewController
@synthesize databaseSelect;
@synthesize valueSelect;
@synthesize chromSelect;
@synthesize limitSelect;
@synthesize heatmapValueSelect;
@synthesize orderBySelect;
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *temp = [[NSMutableString alloc]init];
    NSArray* splittedArray= [_databaseHtml componentsSeparatedByString:@"<div id=db_help>"];
    NSMutableArray* loopArray = [splittedArray mutableCopy];
    [loopArray removeObjectAtIndex:0];
    NSArray* splittedStr = [[NSArray alloc]init];
    NSArray* splittedStrv2 = [[NSArray alloc]init];
    NSArray* splittedStrv3 = [[NSArray alloc]init];
    _databaseIDs = [[NSMutableDictionary alloc]init];
    self.databases = [[NSMutableArray alloc]init];
    for (NSString *str in loopArray) {
        splittedStr = [str componentsSeparatedByString:@">"];
        temp = [splittedStr[4] substringToIndex:[splittedStr[4] length]-3];
        if([temp length] != 1) {
            [_databases addObject:(temp)];
        }
        splittedStrv2 = [str componentsSeparatedByString:@"db="];
        splittedStrv3 = [splittedStrv2[1] componentsSeparatedByString:@"\", \""];
        NSString *key = [splittedStrv3 objectAtIndex:0];
        _databaseIDs[temp] = key;
    }
    _heatmapThreshold.text=@"2";
    _values = @[@"Annotation", @"Transcript", @"GO ID", @"GO Term"];
    _chroms = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"X", @"Y"];
    _databasePicker = [[UIPickerView alloc]init];
    [_databasePicker setDataSource:self];
    [_databasePicker setDelegate:self];
    [_databasePicker setShowsSelectionIndicator:YES];
    databaseSelect.inputView = _databasePicker;
    databaseSelect.text = _databases[0];
    _valuePicker = [[UIPickerView alloc]init];
    [_valuePicker setDataSource:self];
    [_valuePicker setDelegate:self];
    [_valuePicker setShowsSelectionIndicator:YES];
    valueSelect.inputView = _valuePicker;
    valueSelect.text = @"Annotation";
    _chromPicker = [[UIPickerView alloc]init];
    [_chromPicker setDataSource:self];
    [_chromPicker setDelegate:self];
    [_chromPicker setShowsSelectionIndicator:YES];
    chromSelect.inputView = _chromPicker;
    chromSelect.text = @"1";
    _limits = @[@"20", @"50", @"100", @"200", @"500"];
    _limitPicker = [[UIPickerView alloc]init];
    [_limitPicker setDataSource:self];
    [_limitPicker setDelegate:self];
    [_limitPicker setShowsSelectionIndicator:YES];
    limitSelect.inputView = _limitPicker;
    limitSelect.text = @"20";
    _heatmapValuePicker = [[UIPickerView alloc]init];
    _heatmapValues = @[@"Z-Score on Normal Samples", @"Log2 Intensities", @"Median-Centered", @"Z-Score", @"Median-Centered on Normal Samples"];
    [_heatmapValuePicker setDataSource:self];
    [_heatmapValuePicker setDelegate:self];
    [_heatmapValuePicker setShowsSelectionIndicator:YES];
    heatmapValueSelect.inputView = _heatmapValuePicker;
    heatmapValueSelect.text = @"Z-Score on Normal Samples";
    _orderByPicker = [[UIPickerView alloc]init];
    _orderBy = @[@"Gene Symbol", @"Transcript", @"Transcript Location", @"Entrez Gene ID",  @"Gene Title", @"Membrane Protein"];
    [_orderByPicker setDataSource:self];
    [_orderByPicker setDelegate:self];
    [_orderByPicker setShowsSelectionIndicator:YES];
    orderBySelect.inputView = _orderByPicker;
    orderBySelect.text = @"Gene Symbol";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)search:(UIButton*)sender {
    [self.activityWheel startAnimating];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock"]];
    
    request.HTTPMethod = @"POST";
    int chromNum = [chromSelect.text intValue];
    NSString *searchType = sender.titleLabel.text;
    NSString *chromStart = _chromStart.text;
    NSString *chromEnd = _chromEnd.text;
    if([chromStart isEqual:@""]) {
        chromStart = @"null";
    }
    if([chromEnd isEqual:@""]) {
        chromEnd = @"null";
    }
    if([searchType isEqual:@"Search"]) {
        searchType = @"submitted_text_query";
    } else if ([searchType isEqual:@"Location Search"]) {
        searchType = @"submitted_location_query";
    }
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    NSString *name = _textArea.text;
    if([name rangeOfString:@"%"].location != NSNotFound) {
        name = [name stringByReplacingOccurrencesOfString:@"%" withString:@"%%"];
    }
    NSString *selectval_text = [self pickerView:_valuePicker titleForRow:[_valuePicker selectedRowInComponent:0] forComponent:0];
    NSString *db = [self pickerView:_databasePicker titleForRow:[_databasePicker selectedRowInComponent:0] forComponent:0];
    NSString *limitTo = [self pickerView:_limitPicker titleForRow:[_limitPicker selectedRowInComponent:0] forComponent:0];
    NSString *heatmapValue = [self pickerView:_heatmapValuePicker titleForRow:[_heatmapValuePicker selectedRowInComponent:0] forComponent:0];
    NSString *orderBy = [self pickerView:_orderByPicker titleForRow:[_orderByPicker selectedRowInComponent:0] forComponent:0];
    NSString *produceHeatmap = @"";
    NSMutableString *annotations = [[NSMutableString alloc]init];
    NSString *heatmapThreshold = _heatmapThreshold.text;
    NSArray* databaseTagArray = [db componentsSeparatedByString:@": "];
    NSString *dbTag = @"";
    if([heatmapValue isEqual:@"Log2 Intensities"]) {
        heatmapValue = @"log2";
    } if([heatmapValue isEqual:@"Median-Centered"]) {
        heatmapValue = @"log2c";
    } if ([heatmapValue isEqual:@"Z-Score"]) {
        heatmapValue = @"log2cs";
    } if ([heatmapValue isEqual:@"Median-Centered on Normal Samples"]) {
        heatmapValue = @"log2cN";
    } if ([heatmapValue isEqual:@"Z-Score on Normal Samples"]) {
        heatmapValue = @"log2csN";
    }
    orderBy = [orderBy stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    dbTag = _databaseIDs[db];
    if([_heatmapSwitch isOn]){
        produceHeatmap = @"heatmap=on";
    }
    if([_transcriptSwitch isOn]) {
        [annotations appendString:@"&annot=Transcript"];
    } if([_transcriptLocationSwitch isOn]) {
        [annotations appendString:@"&annot=Transcript+Location"];
    } if([_entrezGeneIdSwitch isOn]) {
        [annotations appendString:@"&annot=Entrez+Gene+ID"];
    } if([_geneSymbolSwitch isOn]) {
        [annotations appendString:@"&annot=Gene+Symbol"];
    } if([_geneTitleSwitch isOn]) {
        [annotations appendString:@"&annot=Gene+Title"];
    } if([_membraneProteinSwitch isOn]) {
        [annotations appendString:@"&annot=Membrane+Protein"];
    }
    // Convert data and set request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"rm=query_all&frm=query_all&submitted_multi_expression_query=TRUE&db=%@&name=%@&selectval_text=%@&%@=Search&chrom=%d&chromstart=%@&chromend=%@&%@&limit=%@%@&threshold=%@&exprs=%@&orderby=%@", dbTag, name, selectval_text, searchType, chromNum, chromStart, chromEnd, produceHeatmap, limitTo, annotations, heatmapThreshold, heatmapValue, orderBy];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (IBAction)logout:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)GSEA:(id)sender {
    NSString *db = [self pickerView:_databasePicker titleForRow:[_databasePicker selectedRowInComponent:0] forComponent:0];
    NSString *dbTag = @"";
    dbTag = _databaseIDs[db];
    NSString *URLString = [NSString stringWithFormat:@"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock?rm=query_all;db=rseASPS;source=genomic", dbTag];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSError *error;
    NSString *htmlPage = [NSString stringWithContentsOfURL:URL
                                                    encoding:NSASCIIStringEncoding
                                                       error:&error];
    UIStoryboard *storyboard = [[UIStoryboard alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    if([htmlPage rangeOfString:@"<select NAME=\"smplid\">"].location != NSNotFound) {
        GSEAController *ViewController = (GSEAController *)[storyboard instantiateViewControllerWithIdentifier:@"GSEA"];
        ViewController.html = [htmlPage mutableCopy];
        ViewController.db = dbTag;
        [self presentViewController:ViewController animated:YES completion:nil];
        [self.activityWheel stopAnimating];
    }
//    NSString *stringData = [NSString stringWithFormat:@"rm=query_all;db=%@;source=genomic", dbTag];
//    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody = requestBodyData;
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//    } else {
//        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//    }
}
//Database Selection Protocols
#pragma mark -
#pragma mark PickerView DataSource
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    if (pickerView == self.databasePicker) {
        [databaseSelect setText:[self pickerView:_databasePicker titleForRow:[_databasePicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.valuePicker) {
        [valueSelect setText:[self pickerView:_valuePicker titleForRow:[_valuePicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.chromPicker) {
        [chromSelect setText:[self pickerView:_chromPicker titleForRow:[_chromPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.limitPicker) {
        [limitSelect setText:[self pickerView:_limitPicker titleForRow:[_limitPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.heatmapValuePicker) {
        [heatmapValueSelect setText:[self pickerView:_heatmapValuePicker titleForRow:[_heatmapValuePicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.orderByPicker) {
        [orderBySelect setText:[self pickerView:_orderByPicker titleForRow:[_orderByPicker selectedRowInComponent:0] forComponent:0]];
    }
}
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.databasePicker) {
        return [_databases count];
    }
    else if (pickerView == self.valuePicker) {
        return [_values count];
    }else if (pickerView == self.chromPicker) {
        return [_chroms count];
    }else if (pickerView == self.limitPicker) {
        return [_limits count];
    }else if (pickerView == self.heatmapValuePicker) {
        return [_heatmapValues count];
    }else if (pickerView == self.orderByPicker) {
        return [_orderBy count];
    }
    else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (pickerView == self.databasePicker) {
        return _databases[row];
    }
    else if (pickerView == self.valuePicker) {
        return _values[row];
    }
    else if (pickerView == self.chromPicker) {
        return _chroms[row];
    }
    else if (pickerView == self.limitPicker) {
        return _limits[row];
    }
    else if (pickerView == self.heatmapValuePicker) {
        return _heatmapValues[row];
    }
    else if (pickerView == self.orderByPicker) {
        return _orderBy[row];
    }
    else{
        return @"";
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
    }
    if (pickerView == self.databasePicker) {
        tView.text=_databases[row];
        tView.font = [UIFont systemFontOfSize:18];
    }
    else if (pickerView == self.valuePicker) {
        tView.text=_values[row];
    }
    else if (pickerView == self.chromPicker) {
        tView.text=_chroms[row];
    } else if (pickerView == self.limitPicker) {
        tView.text=_limits[row];
    }
    else if (pickerView == self.heatmapValuePicker) {
        tView.text=_heatmapValues[row];
        tView.font = [UIFont systemFontOfSize:18];
    }
    else if (pickerView == self.orderByPicker) {
        tView.text=_orderBy[row];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        tView.font = [UIFont systemFontOfSize:30];
    }
    return tView;
}
#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _response = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    UIStoryboard *storyboard = [[UIStoryboard alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    if([_response rangeOfString:@"<table  class=\"heatmapouter\">"].location != NSNotFound) {

        DataViewController *ViewController = (DataViewController *)[storyboard instantiateViewControllerWithIdentifier:@"data"];
        ViewController.html = [_response mutableCopy];
        [self presentViewController:ViewController animated:YES completion:nil];
        [self.activityWheel stopAnimating];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter valid search parameters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.activityWheel stopAnimating];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSString *message = @"Could not connect to server";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
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
