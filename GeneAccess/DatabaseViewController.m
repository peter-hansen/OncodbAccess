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
#import "AdvancedSearchController.h"
#import "dbInfoController.h"
#import "ViewController.h"
@interface DatabaseViewController ()
// scrollView so that we can bring textfields that would normally
// be hidden by the keyboard up into view
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
// Record any touches that might be needed among methods
@property (strong, nonatomic) UITouch *touch;
// Button that brings forward GSEA page
@property (strong, nonatomic) IBOutlet UIButton *GSEA;
// Textfield to input chromosome end for a position search
@property (strong, nonatomic) IBOutlet UITextField *chromEnd;
// Textfield to input chromosome start for a position search
@property (strong, nonatomic) IBOutlet UITextField *chromStart;
// Switch to turn on and off heatmaps
@property (strong, nonatomic) IBOutlet UISwitch *heatmapSwitch;
// Switch to turn on and off transcript
@property (strong, nonatomic) IBOutlet UISwitch *transcriptSwitch;
// Switch to turn on and off transcript locations
@property (strong, nonatomic) IBOutlet UISwitch *transcriptLocationSwitch;
// Switch to turn on and off Entrez Gene ID information
@property (strong, nonatomic) IBOutlet UISwitch *entrezGeneIdSwitch;
// Switch to turn on and off Gene Symbol information
@property (strong, nonatomic) IBOutlet UISwitch *geneSymbolSwitch;
// Switch to turn on and off Gene Title information
@property (strong, nonatomic) IBOutlet UISwitch *geneTitleSwitch;
// Switch to turn on and off Membrane Protein information
@property (strong, nonatomic) IBOutlet UISwitch *membraneProteinSwitch;
// Value for heatmap color threshold
@property (strong, nonatomic) IBOutlet UITextField *heatmapThreshold;
// Databases available to user
@property NSMutableArray *databases;
// ID's of all databases
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
// A method that in conjunction with its tracker defined in
// viewDidLoad catches touches otherwise intercepted by the
// UIScrollView and closes the keyboard
//-(void) hideKeyBoard:(id) sender
//{
//    [self.scrollView endEditing:YES];
//}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)dbInfo:(id)sender {
    [self.activityWheel startAnimating];
    // get the database ID and give it to ASC
    NSString *db = [self pickerView:_databasePicker titleForRow:[_databasePicker selectedRowInComponent:0] forComponent:0];
    NSString *dbTag = @"";
    dbTag = _databaseIDs[db];
    // find the storyboard that coressponds to the the current device
    UIStoryboard *storyboard = [[UIStoryboard alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    // find the right view within the storyboard
    dbInfoController *ViewController = (dbInfoController *)[storyboard instantiateViewControllerWithIdentifier:@"dbInfo"];
    NSString *url = [NSString stringWithFormat:@"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock?rm=db_info;dbedit=YES;db=%@", dbTag];
    NSURL *urlRequest = [NSURL URLWithString:url];
    NSError *err = nil;
    
    NSString *html = [NSString stringWithContentsOfURL:urlRequest encoding:NSUTF8StringEncoding error:&err];

    ViewController.html = [html mutableCopy];
    // switch view to ASC
    [self presentViewController:ViewController animated:YES completion:nil];
    [self.activityWheel stopAnimating];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField.frame.origin.y > 250) {
        _scrollView.contentOffset = CGPointMake( 0, textField.frame.origin.y - 250); //required offset
        //provide contentOffSet those who needed
    } else {
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    return YES;
}
// A method that catches all touches made. I am currently using it to close the keyboard
// if you touch on something that doesn't need it.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    // If the touch isn't on a UITextField, close the keyboard,
    // we don't need it anymore
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
        _scrollView.contentOffset = CGPointMake(0,0); //make UIScrollView as it was before
    }
    [super touchesBegan:touches withEvent:event];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set all delegates so that we can catch events on these objects. I specifically added these so that
    // the textFieldShouldBeginEditing function can be triggered by textfields and the touchesBegan method
    // can be triggered by the scrollView
    [_scrollView setDelegate:self];
    [_heatmapThreshold setDelegate:self];
    [heatmapValueSelect setDelegate:self];
    [orderBySelect setDelegate:self];
    [databaseSelect setDelegate:self];
    [valueSelect setDelegate:self];
    [chromSelect setDelegate:self];
    [_chromStart setDelegate:self];
    [_chromEnd setDelegate:self];
    // Here we're going to chop up the html response to find all the databases we have access to
    NSString *temp = [[NSMutableString alloc]init];
    NSArray* splittedArray= [_databaseHtml componentsSeparatedByString:@"<div id=db_help>"];
    NSMutableArray* loopArray = [splittedArray mutableCopy];
    [loopArray removeObjectAtIndex:0];
    NSArray* splittedStr = [[NSArray alloc]init];
    NSArray* splittedStrv2 = [[NSArray alloc]init];
    NSArray* splittedStrv3 = [[NSArray alloc]init];
    _databaseIDs = [[NSMutableDictionary alloc]init];
    self.databases = [[NSMutableArray alloc]init];
    // for each db_help, there has to be a db. So loopArray should hold all the db's in it
    for (NSString *str in loopArray) {
        // We don't want any of the html to show up for the user, so right here it's being cut out
        splittedStr = [str componentsSeparatedByString:@">"];
        temp = [splittedStr[6] substringToIndex:[splittedStr[6] length]-3];
        if([temp length] != 1) {
            [_databases addObject:(temp)];
        }
        splittedStrv2 = [str componentsSeparatedByString:@"db="];
        splittedStrv3 = [splittedStrv2[1] componentsSeparatedByString:@"\", \""];
        NSString *key = [splittedStrv3 objectAtIndex:0];
        _databaseIDs[temp] = key;
    }
    // initialize all the pickerviews
    // The arrays hold the values that will show up in the pickerviews
    _heatmapThreshold.text=@"2";
    _values = @[@"Annotation", @"Transcript", @"GO ID", @"GO Term"];
    _chroms = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"X", @"Y"];
    // Allocate and initialize the memory for the pickerView
    _databasePicker = [[UIPickerView alloc]init];
    // Tell the pickerView where to get it's data
    [_databasePicker setDataSource:self];
    // Tell the pickerView where to send data
    [_databasePicker setDelegate:self];
    // Tell the pickerView to show which row is selected
    [_databasePicker setShowsSelectionIndicator:YES];
    // Set the pickerView as the thing that will pop up when you click on the textfield
    databaseSelect.inputView = _databasePicker;
    // Set the textfield to automatically show the first database
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
    NSString *db = [self pickerView:_databasePicker titleForRow:[_databasePicker selectedRowInComponent:0] forComponent:0];
    // GSEA only enabled for RNAseq databases
    if ([db rangeOfString:@"RNAseq"].location == NSNotFound) {
        _GSEA.hidden = true;
    }
    NSString *message = @"Login Successful";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// gather data on preferences and then send user to the advanced search page
- (IBAction)advancedSearch:(id)sender {
    // get the database ID and give it to ASC
    NSString *db = [self pickerView:_databasePicker titleForRow:[_databasePicker selectedRowInComponent:0] forComponent:0];
    NSString *dbTag = @"";
    dbTag = _databaseIDs[db];
    // find the storyboard that coressponds to the the current device
    UIStoryboard *storyboard = [[UIStoryboard alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    // find the right view within the storyboard
    AdvancedSearchController *ViewController = (AdvancedSearchController *)[storyboard instantiateViewControllerWithIdentifier:@"adsearch"];
    ViewController.db = dbTag;
    // these lines just gather data and pass it to ASC
    if([_heatmapSwitch isOn]){
        ViewController.produceHeatmap = @"&heatmap=on";
    } else {
        ViewController.produceHeatmap = @"";
    }
    NSMutableString *annotations = [@"" mutableCopy];
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
    ViewController.limitTo = [self pickerView:_limitPicker titleForRow:[_limitPicker selectedRowInComponent:0] forComponent:0];
    ViewController.heatmapValue = [self pickerView:_heatmapValuePicker titleForRow:[_heatmapValuePicker selectedRowInComponent:0] forComponent:0];
    ViewController.orderBy = [self pickerView:_orderByPicker titleForRow:[_orderByPicker selectedRowInComponent:0] forComponent:0];
    ViewController.heatmapThreshold = _heatmapThreshold.text;
    ViewController.annotations = annotations;
    // switch view to ASC
    [self presentViewController:ViewController animated:YES completion:nil];
    [self.activityWheel stopAnimating];
    
}
// The main seach function of the app. It searches based on the full-text area primarily.
- (IBAction)search:(UIButton*)sender {
    [self.activityWheel startAnimating];
    // create a HTTP request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock"]];
    // define HTTP method
    request.HTTPMethod = @"POST";
    int chromNum = [chromSelect.text intValue];
    // gather information from textfields
    NSString *searchType = sender.titleLabel.text;
    NSString *chromStart = _chromStart.text;
    NSString *chromEnd = _chromEnd.text;
    // gather information from switches
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
    // gather information from the pickerviews
    NSString *selectval_text = [self pickerView:_valuePicker titleForRow:[_valuePicker selectedRowInComponent:0] forComponent:0];
    NSString *db = [self pickerView:_databasePicker titleForRow:[_databasePicker selectedRowInComponent:0] forComponent:0];
    NSString *limitTo = [self pickerView:_limitPicker titleForRow:[_limitPicker selectedRowInComponent:0] forComponent:0];
    NSString *heatmapValue = [self pickerView:_heatmapValuePicker titleForRow:[_heatmapValuePicker selectedRowInComponent:0] forComponent:0];
    NSString *orderBy = [self pickerView:_orderByPicker titleForRow:[_orderByPicker selectedRowInComponent:0] forComponent:0];
    // initialize produce heatmap at empty to prevent error with variadic function latter when it is off
    NSString *produceHeatmap = @"";
    NSMutableString *annotations = [[NSMutableString alloc]init];
    NSString *heatmapThreshold = _heatmapThreshold.text;
    NSString *dbTag = @"";
    // convert heatmapValue from readable value to actual value that the server expects
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
    // POST method requires all spaces to be replaced with +'s
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
    // Here we cast it as void because we don't need to do anything
    // with the return value
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
// logout by closing view and requiring re-entering of username and password
- (IBAction)logout:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// If database selected is a RNAseq database open GSEA application tool
- (IBAction)GSEA:(id)sender {
    // the GSEA needs information from the server, but rather than asking the server again we're just going to send it
    // manually since we already have it stored in variables.
    NSString *db = [self pickerView:_databasePicker titleForRow:[_databasePicker selectedRowInComponent:0] forComponent:0];
    NSString *dbTag = @"";
    dbTag = _databaseIDs[db];
    // load the page from the server and get what we don't have already
    NSString *URLString = [NSString stringWithFormat:@"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock?rm=query_all;db=%@;source=genomic", dbTag];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSError *error;
    NSString *htmlPage = [NSString stringWithContentsOfURL:URL
                                                    encoding:NSASCIIStringEncoding
                                                       error:&error];
    // Find the right storyboard based on the device being used
    UIStoryboard *storyboard = [[UIStoryboard alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    // If there aren't any samples, then there's not point in going to the GSEA, and it just means that
    // somewhere along the way there was an error so we only open up the GSEA page if they are present.
    if([htmlPage rangeOfString:@"<select NAME=\"smplid\">"].location != NSNotFound) {
        GSEAController *ViewController = (GSEAController *)[storyboard instantiateViewControllerWithIdentifier:@"GSEA"];
        ViewController.html = [htmlPage mutableCopy];
        ViewController.db = dbTag;
        [self presentViewController:ViewController animated:YES completion:nil];
        [self.activityWheel stopAnimating];
    }
}
//Database Selection Protocols
#pragma mark -
#pragma mark PickerView DataSource
// This method sets the text of each textfield to the value selected on the pickerview
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    if (pickerView == self.databasePicker) {
        NSString *db = [self pickerView:_databasePicker titleForRow:[_databasePicker selectedRowInComponent:0] forComponent:0];
        [databaseSelect setText:db];
        if ([db rangeOfString:@"RNAseq"].location == NSNotFound) {
            _GSEA.hidden = true;
        } else {
            _GSEA.hidden = false;
        }
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
// If you wanted more than on column for the pickerview you would define that here
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
// This defines the number of selectable items in the pickerview. Right now
// it is set to however many items we have to choose from
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

// This method defines the title of the row. In general, this is used very rarely.
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
// For a given row this defines what the row should display as text.
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // using a UILabel allows us to set the size and font of what shows up in the picker wheel
    // The function expects a UIView in return, so really any subclass of UIView will work. It doesn't have to be UILabel.
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
    }
    if (pickerView == self.databasePicker) {
        tView.text=_databases[row];
        // these tend to be longer, so we need to make the font smaller to fit in the screen
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
        // these tend to be longer, so we need to make the font somaller to fit in the screen
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
// When users navigate within the webview we need to check if any manipulation needs to be done.
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
// Method that runs when the server responds
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _response = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    if ([_response rangeOfString:@"500 Internal Server Error"].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"500 Internal Server Error" message:@"The server encountered an internal error or                              misconfiguration and was unable to complete your request."   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    // find the appropriate storyboard for the given device
    UIStoryboard *storyboard = [[UIStoryboard alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    if ([_response rangeOfString:@"login_submitted"].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forced Logout" message:@"You have been inactive for too long and have been logged out. Please log in again."   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        ViewController *ViewController2 = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:ViewController2 animated:YES completion:nil];
        return;
    }
    if([_response rangeOfString:@"<table  class=\"heatmapouter\">"].location != NSNotFound) {
        // All successful searches provide transcripts, so if this string is not there
        // we know that it was unsuccessful and stop the program here.
        if([_response rangeOfString:@"Transcripts(+)"].location == NSNotFound) {
            NSString *message = @"There were no results for the given search parameters. (Tip:If you don't find your gene of interest in the Full-Text query add two wildcards (%), e.g. \"%CD45%\") ";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Emtpy Response" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self.activityWheel stopAnimating];
            return;
        }
        // if there's a heatmapouter, we know that the data is ready to be viewed, so we switch to the view that will hold the data
        DataViewController *ViewController = (DataViewController *)[storyboard instantiateViewControllerWithIdentifier:@"data"];
        ViewController.html = [_response mutableCopy];
        [self presentViewController:ViewController animated:YES completion:nil];
        [self.activityWheel stopAnimating];
    }
    else {
        // if we didn't find any heatmapouter then the search was unsuccessful, so therefore we ask the user to provide different parameters
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
