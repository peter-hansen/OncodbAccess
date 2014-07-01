//
//  GSEAController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/23/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "GseaController.h"

@interface GSEAController ()
// Misc - These are objects that are used by all sample sets. All
// objects without description are exactly what the name implies
@property (strong, nonatomic) IBOutlet UIButton *runGSEA;
// Spinning wheel that indicates processing data
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
// the data that is sent from the server
@property (nonatomic) NSMutableData *responseData;
// the data in a readable string format
@property (nonatomic) NSString *response;
// texfield where samples are selected
@property (strong, nonatomic) IBOutlet UITextField *sampleSelect;
// textfield where all probes/not all probes is selected
@property (strong, nonatomic) IBOutlet UITextField *geneSelect;
// you get the point by now
@property (strong, nonatomic) IBOutlet UITextField *duplicateSelect;
// same as before
@property (strong, nonatomic) IBOutlet UITextField *genesetSelect;
// the rolling wheel that shows up to select samples
// all _____Picker objects correspond to that _____Select
@property (strong, nonatomic) UIPickerView *samplePicker;
@property (strong, nonatomic) UIPickerView *genePicker;
@property (strong, nonatomic) UIPickerView *duplicatePicker;
@property (strong, nonatomic) UIPickerView *genesetPicker;
// These arrays are what goes in the picker views
@property (strong, nonatomic) NSMutableArray *samples;
@property (strong, nonatomic) NSArray *gene;
@property (strong, nonatomic) NSArray *duplicate;
@property (strong, nonatomic) NSMutableDictionary *genesets;
@property (strong, nonatomic) NSMutableArray *activeObjects;
// This is the object that holds the response each switch should
// give if turned on
@property (strong, nonatomic) NSMutableDictionary *realKeys;
// This holds all switches that will be tracked
@property (strong, nonatomic) NSMutableArray *switches;
// NCI Objects
@property (strong, nonatomic) NSMutableArray *NCI;
// Sample.Drug
@property (strong, nonatomic) NSMutableArray *sampleDrug;
// ANN
@property (strong, nonatomic) NSMutableArray *ANN;
// Cell_Line
@property (strong, nonatomic) NSMutableArray *cellLine;
// Drug_Response
@property (strong, nonatomic) NSMutableArray *drugResponse;
// Germ_Cell_Tumors
@property (strong, nonatomic) NSMutableArray *germCellTumors;
// Leukemia
@property (strong, nonatomic) NSMutableArray *leukemia;
// Medulloblastoma
@property (strong, nonatomic) NSMutableArray *medulloblastoma;
// Neuroblastoma
@property (strong, nonatomic) NSMutableArray *neuroblastoma;
// Normal_Tissue
@property (strong, nonatomic) NSMutableArray *normalTissue;
// Pediatric_Cancers
@property (strong, nonatomic) NSMutableArray *pediatricCancers;
// Rhabdomyosarcoma
@property (strong, nonatomic) NSMutableArray *rhabdomyosarcoma;
// Sarcoma
@property (strong, nonatomic) NSMutableArray *Sarcoma;
// cMAP
@property (strong, nonatomic) NSMutableArray *cMAP;
@end

@implementation GSEAController
// A method that catches all touches made onto the MAIN view
// Other views placed on top, such as UIScrollViews may
// intercept these touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    // If the touch isn't on a UITextField, close the keyboard,
    // we don't need it anymore
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}
// A method that in conjunction with its tracker defined in
// viewDidLoad catches touches otherwise intercepted by the
// UIScrollView and closes the keyboard
-(void) hideKeyBoard:(id) sender
{
    [self.scrollView endEditing:YES];
}
// The following methods map to the button of the same name
// Each one hides all objects that are currently being used
// and reveal the object corresponding to that sample set.
- (IBAction)cMAP:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _cMAP) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)Sarcoma:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _Sarcoma) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)Rhabdomyosarcoma:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _rhabdomyosarcoma) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)Pediatric_Cancer:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _pediatricCancers) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)Normal_Tissue:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _normalTissue) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)Neuroblastoma:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _neuroblastoma) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)Medulloblastoma:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _medulloblastoma) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)Leukemia:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _leukemia) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)Germ_Cell_Tumors:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _germCellTumors) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)Drug_Response:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _drugResponse) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)Cell_Line:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _cellLine) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)ANN:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _ANN) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)SampleDrug:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _sampleDrug) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
- (IBAction)NCI:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _NCI) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
}
// A method that sends the user defined information to
// the server. It is activated by the Run GSEA button.
- (IBAction)runGSEA:(id)sender {
    [self.activityWheel startAnimating];
    // The following statements collect data from input sources and then convert the data to match what the server expects
    NSString *chosenGenes = _geneSelect.text;
    NSString *chosenGeneset = _genesets[_genesetSelect.text];
    chosenGeneset = [chosenGeneset stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *duplicateyn = _duplicateSelect.text;
    // this is how I clone the <select><option value=Y>Use all genes(probes)</option>... etc
    if ([chosenGenes isEqual:@"Use all genes(probes)"]) {
        chosenGenes = @"Y";
    } else {
        chosenGenes = @"N";
    }
    if([duplicateyn isEqual:@"Keep highest value(abs)"]) {
        duplicateyn = @"Y";
    } else {
        duplicateyn = @"N";
    }
    // If you do not define a starting value for a variable it must have memory ALLOCated and INITialized to become non nil
    NSMutableString *grp = [[NSMutableString alloc]init];
    // Check all the switches to see which ones are turned on and add that information to a string
    for (UISwitch *theswitch in _switches) {
        if ([theswitch isOn]) {
            [grp appendString:@"&grp="];
            NSString *str = theswitch.accessibilityLabel;
            NSLog(@"It is %@", str);
            [grp appendString:_realKeys[theswitch.accessibilityLabel]];
        }
    }
    // Create a request object with all the data we want to send to the server. This is how variadic functions are defined in objective C
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock?rm=query_all;db=%@;source=genomic", _db]]];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"rm=query_all&frm=query_all&submitted_multi_expression_query=TRUErm=show_gsea&show_gsea=Run+GSEA&prerank_file=null&gsea_file=null&db=%@&smplid=%ld&geneset=%@&geneduprm=%@&gmx=%@%@", _db, (long)[self.samplePicker selectedRowInComponent:0], chosenGenes, duplicateyn, chosenGeneset, grp];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
// close the current view and return to the main page
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
- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        // start tracking switch
        [_switches addObject:sender];
    } else{
        // do nothing
    }
}
// Initialize everything when the view loads
- (void)viewDidLoad
{
    [super viewDidLoad];
    _switches = [[NSMutableArray alloc]init];
    _realKeys = [[NSMutableDictionary alloc]init];
    _activeObjects = [[NSMutableArray alloc]init];
    // Add a tap reciever to the scroll view so that they won't be intercepted anymore. This works on conjunction with hideKeyBoard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [_scrollView addGestureRecognizer:gestureRecognizer];
    _gene = @[@"Use all genes(probes)", @"Use current genes"];
    _duplicate = @[@"Keep highest value(abs)", @"keep all"];
    // The following set of code disects the <select> objects and extracts every option. The first one puts all the samples in _samples.
    NSArray *sampleFinder = [[NSArray alloc] initWithArray:[_html componentsSeparatedByString:@"<select NAME=\"smplid\">"]];
    NSArray *sampleFinder2 = [sampleFinder[1] componentsSeparatedByString:@"</select>"];
    NSArray *sampleFinder3 = [sampleFinder2[0] componentsSeparatedByString:@">"];
    // at this point all the <option>s for the sample  select are in sampleFinder3
    _samples = [[NSMutableArray alloc]init];
    NSString *sample = [[NSString alloc]init];
    for (NSString *object in sampleFinder3) {
        // Throw out anything that isn't an option and take the contents of option and put it in _sample
        if ([object rangeOfString:@"<option"].location == NSNotFound && [object length] != 8 && [object length] != 0) {
            sample = [object stringByReplacingOccurrencesOfString:@"</option" withString:@""];
            [_samples addObject:sample];
        }
    }
    // This one takes all the genesets and puts them in _genesets
    sampleFinder = [_html componentsSeparatedByString:@"<SELECT NAME=gmx"];
    sampleFinder2 = [sampleFinder[1] componentsSeparatedByString:@"</SELECT>"];
    sampleFinder3 = [sampleFinder2[0] componentsSeparatedByString:@"<OPTION value"];
    _genesets = [[NSMutableDictionary alloc]init];
    NSArray *sampleFinder4 = [[NSArray alloc]init];
    NSString *key = [[NSString alloc]init];
    NSString *url = [[NSString alloc]init];
    // each geneset has both a display name and an address for where the file is, so each display name (the key)
    // has to be mapped to the address (the url, or object)
    for (NSString *object in sampleFinder3) {
        sampleFinder4 = [object componentsSeparatedByString:@">"];
        if([sampleFinder4 count] == 3) {
            key = sampleFinder4[1];
            key = [key stringByReplacingOccurrencesOfString:@"   " withString:@" "];
            key = [key stringByReplacingOccurrencesOfString:@"</OPTION" withString:@""];
            url = sampleFinder4[0];
            url = [url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            url = [url stringByReplacingOccurrencesOfString:@"=" withString:@""];
            [_genesets setObject:url forKey:key];
        }
    }
    // Getting all the preset checkboxes is a little more complicated, so here a lot of manipulation has to be done.
    // This isn't going to make a lot of sense unless you go and look at the html that's being recieved from the server.
    // when you see it, it will make sense why each of these manipulations are being done.
    // componentsSeparatedByString is the exact same as javascript .split("foobar");
    NSMutableArray *msampleFinder = [[_html componentsSeparatedByString:@"<div id='0."] mutableCopy];
    [msampleFinder removeObjectAtIndex:0];
    NSMutableArray *msampleFinder3 = [[[msampleFinder lastObject] componentsSeparatedByString:@"<div id='1."] mutableCopy];
    msampleFinder[[msampleFinder count]-1]  = msampleFinder3[0];
    [msampleFinder3 removeObjectAtIndex:0];
    // Put a break point here and just look at the contents of each msampleFinder and it'll make sense.
    NSMutableArray *msampleFinder4 = [[NSMutableArray alloc]init];
    for (NSString *finder in msampleFinder3) {
        // This will add each check box from the 1.____ sample sets (i.e. sets that require both a positive and negative
        // checkbox) to msamapleFinder4
        [msampleFinder4 addObjectsFromArray:[finder componentsSeparatedByString:@"<input type='checkbox' name=grp value='"]];
    }
    // The last object is just going to be a bunch of gunk html that gives us the rest of the page data, but we don't care about that
    // because we only wanted the check boxes
    [msampleFinder4 removeObjectAtIndex:0];
    NSMutableArray *msampleFinder2 = [[NSMutableArray alloc]init];
    for (NSString *finder in msampleFinder) {
        // This does the same thing that the earlier one did, just for 0.____ sample sets instead for msampleFinder2
        [msampleFinder2 addObjectsFromArray:[finder componentsSeparatedByString:@"<input type='checkbox' name=grp value='"]];
    }
    [msampleFinder2 removeObjectAtIndex:0];
    _NCI = [[NSMutableArray alloc]init];
    _sampleDrug = [[NSMutableArray alloc]init];
    _ANN = [[NSMutableArray alloc]init];
    _cellLine = [[NSMutableArray alloc]init];
    _drugResponse = [[NSMutableArray alloc]init];
    _germCellTumors = [[NSMutableArray alloc]init];
    _leukemia = [[NSMutableArray alloc]init];
    _medulloblastoma = [[NSMutableArray alloc]init];
    _neuroblastoma = [[NSMutableArray alloc]init];
    _normalTissue = [[NSMutableArray alloc]init];
    _pediatricCancers = [[NSMutableArray alloc]init];
    _rhabdomyosarcoma = [[NSMutableArray alloc]init];
    _Sarcoma = [[NSMutableArray alloc]init];
    _cMAP = [[NSMutableArray alloc]init];
    // If you add a whole new catagory of samples it is CRUCIAL that you add it to this array and initialize it the same way the others were. It also
    // has to be in order with the order they show up in the html, otherwise everything is going to get mixed up and/or crash the program.
    NSArray *sampleSets = @[_NCI, _sampleDrug, _ANN, _cellLine, _drugResponse, _germCellTumors, _leukemia, _medulloblastoma, _neuroblastoma, _normalTissue, _pediatricCancers, _rhabdomyosarcoma, _Sarcoma, _cMAP];
    // The following code generates the switches, the labels describing them, and the data each one will provide if turned on.
    // These are counters, c is what row the next switch should be generated on, and s is the catagory the next switch should be placed under.
    int c = 0;
    int s = 0;
    NSString *checkUrl = [[NSString alloc]init];
    NSArray *dummyArray = [[NSArray alloc]init];
    NSArray *dummyArray2 = [[NSArray alloc]init];
    // count is our overall number of switches + 1. The +1 is so that when necessary the next element in the array can be accessed
    // before it is iterated on
    int count = 1;
    // row should really be column, this will only ever be 0 (left) or 1 (right)
    int row = 0;
    // We start with the 0.___ samples that we earlier put in msampleFinder2
    for (NSString *str in msampleFinder2) {
        // The only time this condition will not be true is at the end of a catagory, where it states what the next catagory is
        if ([[str substringWithRange:NSRangeFromString(@"0,5")] isEqualToString:@"/WWW/"]) {
            dummyArray = [str componentsSeparatedByString:@"'>"];
            // Conviniently, with the way the html is being parsed the URL ends up in the first position of our array so
            // we'll just grab that
            checkUrl = dummyArray[0];
            // We don't need the beginning of our array anymore because we already captured it, so we're going to throw it away
            // and focus on the third element which is where our label information is going to be
            dummyArray2 = [dummyArray[2] componentsSeparatedByString:@"<span title='"];
            // Since the iPad is so much bigger, we're obviously going to put the switches in different positions, so right here
            // before we do that we check to see if the device is an iPad or not
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                // Since the iPad is big enough to fit everything on one page we are going to put all of these switches in two columns.
                // This if statement defines when the new column starts. In this case there will be a new column made after 16 rows.
                // The maximum ammount that will fit onto one page is around 2 columns and 18 rows per column. THEREFORE, IF YOU HAVE MORE
                // THAN THAT NUMBER OF SAMPLES (positive and negative samples count as one in this case) EITHER CONTACT ME AT MY EMAIL ADDRESS
                // phansen@terpmail.umd.edu OR ADAPT WHAT HAS BEEN DONE WITH UISCROLLVIEW ON THE IPHONE SIDE. OTHERWISE THIS ENTIRE THING
                // COULD GET VERY MESSY.
                if (c > 15) {
                    row = 1;
                    c= 0;
                }
                // Making the label that goes next to the switch. The parameters are (xpos, ypos, width, height)
                UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54+50 +355*row, 362 +c*34, 280, 21)];
                myLabel.text = [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                myLabel.font = [UIFont systemFontOfSize:14];
                // Place the label in the view that is on top. Otherwise it will be invisible
                [self.iPadView addSubview:myLabel];
                myLabel.hidden = true;
                // map the id of our switch to the url for tha data we want that switch to turn on
                [_realKeys setObject:checkUrl forKey:[NSString stringWithFormat:@"%i", count]];
                UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50+355*row, 357 + c*34, 0, 0)];
                [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                // give the switch a label corresponding to it's id
                mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                [self.iPadView addSubview:mySwitch];
                [self.iPadView addSubview:myLabel];
                // Add the new switche and label to their catagory so that the buttons can turn them on and off
                [sampleSets[s] addObject:mySwitch];
                [sampleSets[s] addObject:myLabel];
                mySwitch.hidden = true;
            } else {
                // exact same thing, just different positioning to accomodate the iPhone's screen
                UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 417 +c*34, 280, 21)];
                myLabel.text = [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                myLabel.font = [UIFont systemFontOfSize:14];
                [self.container addSubview:myLabel];
                myLabel.hidden = true;
                [_realKeys setObject:checkUrl forKey:[NSString stringWithFormat:@"%i", count]];
                UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 407 + c*34, 0, 0)];
                [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                [self.container addSubview:mySwitch];
                [self.container addSubview:myLabel];
                [sampleSets[s] addObject:mySwitch];
                [sampleSets[s] addObject:myLabel];
                mySwitch.hidden = true;

            }
            c++;
            count++;
        } else {
            // end of a catagory, so move onto next one (s++) and go back to the top row (c=0)
            s++;
            c = 0;
            // row should be column, but it would be complicated to change it now and it doesn't make any difference
            row = 0;
        }
    }
    BOOL left = true;
    c = 0;
    s++;
    row = 0;
    // exact same thing as above, just for sample sets that have positive and negative samples so
    // I added the BOOL left parameter, which just says whether each switch goes on the left or right
    // of the column.
    for (NSString *str in msampleFinder4) {
        if ([[str substringWithRange:NSRangeFromString(@"0,5")] isEqualToString:@"/WWW/"]) {
            if( left) {
                dummyArray = [str componentsSeparatedByString:@"'>"];
                checkUrl = dummyArray[0];
                [_realKeys setObject:checkUrl forKey:[NSString stringWithFormat:@"%i", count]];
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    if (c > 15) {
                        row = 1;
                        c= 0;
                    }
                    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50+355*row, 357 + c*34, 0, 0)];
                    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                    mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(50+54+355*row, 362 +c*34, 280, 21)];
                    myLabel.text = @"+";
                    myLabel.font = [UIFont systemFontOfSize:14];
                    [self.container addSubview:myLabel];
                    myLabel.hidden = true;
                    [self.iPadView addSubview:mySwitch];
                    [self.iPadView addSubview:myLabel];
                    [sampleSets[s] addObject:mySwitch];
                    [sampleSets[s] addObject:myLabel];
                    mySwitch.hidden = true;
                } else {
                    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 407 + c*34, 0, 0)];
                    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                    mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 412 +c*34, 280, 21)];
                    myLabel.text = @"+";
                    myLabel.font = [UIFont systemFontOfSize:14];
                    [self.container addSubview:myLabel];
                    myLabel.hidden = true;
                    [self.container addSubview:mySwitch];
                    [self.container addSubview:myLabel];
                    [sampleSets[s] addObject:mySwitch];
                    [sampleSets[s] addObject:myLabel];
                    mySwitch.hidden = true;
                }
            } else {
                dummyArray = [str componentsSeparatedByString:@"'>"];
                checkUrl = dummyArray[0];
                dummyArray2 = [dummyArray[2] componentsSeparatedByString:@"<span title='"];
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    if (c > 15) {
                        row = 1;
                        c= 0;
                    }
                    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(115+75+355*row, 362 +c*34, 280, 21)];
                    myLabel.text = [NSString stringWithFormat:@"-  %@", [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""]];
                    myLabel.font = [UIFont systemFontOfSize:14];
                    myLabel.hidden = true;
                    [_realKeys setObject:checkUrl forKey:[NSString stringWithFormat:@"%i", count]];
                    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50+75+355*row, 357 + c*34, 0, 0)];
                    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                    mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                    [self.iPadView addSubview:mySwitch];
                    [self.iPadView addSubview:myLabel];
                    [sampleSets[s] addObject:mySwitch];
                    [sampleSets[s] addObject:myLabel];
                    mySwitch.hidden = true;
                } else {
                    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 412 +c*34, 280, 21)];
                    myLabel.text = [NSString stringWithFormat:@"-  %@", [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""]];
                    myLabel.font = [UIFont systemFontOfSize:11];
                    myLabel.hidden = true;
                    [_realKeys setObject:checkUrl forKey:[NSString stringWithFormat:@"%i", count]];
                    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(75, 407 + c*34, 0, 0)];
                    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                    mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                    [self.container addSubview:mySwitch];
                    [self.container addSubview:myLabel];
                    [sampleSets[s] addObject:mySwitch];
                    [sampleSets[s] addObject:myLabel];
                    mySwitch.hidden = true;
                }
                c++;
            }
            left = !left;
            count++;
        } else {
            s++;
            c = 0;
            row = 0;
        }
    }
    // These methods define that the pickerviews should be used instead of a
    // keyboard for the text boxes.
    _samplePicker = [[UIPickerView alloc]init];
    _genePicker = [[UIPickerView alloc]init];
    _genesetPicker = [[UIPickerView alloc]init];
    _duplicatePicker = [[UIPickerView alloc]init];
    [_samplePicker setDataSource:self];
    [_samplePicker setDelegate:self];
    [_samplePicker setShowsSelectionIndicator:YES];
    _sampleSelect.inputView = _samplePicker;
    _sampleSelect.text = _samples[0];
    [_genePicker setDataSource:self];
    [_genePicker setDelegate:self];
    [_genePicker setShowsSelectionIndicator:YES];
    _geneSelect.inputView = _genePicker;
    _geneSelect.text = @"Use all genes(probes)";
    [_genesetPicker setDataSource:self];
    [_genesetPicker setDelegate:self];
    [_genesetPicker setShowsSelectionIndicator:YES];
    _genesetSelect.inputView = _genesetPicker;
    _genesetSelect.text = @"Select MSigDC gene set";
    [_duplicatePicker setDataSource:self];
    [_duplicatePicker setDelegate:self];
    [_duplicatePicker setShowsSelectionIndicator:YES];
    _duplicateSelect.inputView = _duplicatePicker;
    _duplicateSelect.text = @"Keep highest value(abs)";
    [_scrollView setDelegate:self];
}
// ONLY FOR IPHONE: This sets the bottom of the dragable space in the iPhone. If any more samples are added than Neuroblastoma currently has,
// this number will have to be increased, by about 35 per set.
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (targetContentOffset->y > 720) {
        targetContentOffset->y = 720;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark PickerView dataSource
// This method sets the text of each textfield to the value selected on the pickerview
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    if (pickerView == self.samplePicker) {
        [_sampleSelect setText:[self pickerView:_samplePicker titleForRow:[_samplePicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.genePicker) {
        [_geneSelect setText:[self pickerView:_genePicker titleForRow:[_genePicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.genesetPicker) {
        [_genesetSelect setText:[self pickerView:_genesetPicker titleForRow:[_genesetPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.duplicatePicker) {
        [_duplicateSelect setText:[self pickerView:_duplicatePicker titleForRow:[_duplicatePicker selectedRowInComponent:0] forComponent:0]];
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
    if (pickerView == self.samplePicker) {
        return [_samples count];
    }
    else if (pickerView == self.genePicker) {
        return [_gene count];
    }else if (pickerView == self.genesetPicker) {
        return [_genesets count];
    }else if (pickerView == self.duplicatePicker) {
        return [_duplicate count];
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
    if (pickerView == self.samplePicker) {
        return _samples[row];
    }
    else if (pickerView == self.genePicker) {
        return _gene[row];
    }
    else if (pickerView == self.genesetPicker) {
        // this is a bit different because for the genesets it's the keys
        // that are displayed in the picker, not the objects themselves
        NSMutableArray *keys = [[_genesets allKeys] mutableCopy];
        [keys insertObject:@"Select MSigDC gene set" atIndex:0];
        return keys[row];
    }
    else if (pickerView == self.duplicatePicker) {
        return _duplicate[row];
    }
    else{
        return @"";
    }
}
// For a given row this defines what the row should display as text.
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
    }
    if (pickerView == self.samplePicker) {
        // These tend to be longer strings, so they need to be sized down
        tView.text=_samples[row];
        tView.font = [UIFont systemFontOfSize:14];
    }
    else if (pickerView == self.genePicker) {
        tView.text=_gene[row];
    }
    else if (pickerView == self.genesetPicker) {
        // Get the keys and add the Select MSigDC gene set so that it shows
        // up as a description but doesn't have to map to any real object
        // in the dictionary
        NSMutableArray *keys = [[_genesets allKeys] mutableCopy];
        [keys insertObject:@"Select MSigDC gene set" atIndex:0];
        tView.text=keys[row];
        tView.font = [UIFont systemFontOfSize:14];
    } else if (pickerView == self.duplicatePicker) {
        tView.text=_duplicate[row];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // if it's an iPad, it has room for larger font regardless of how long
        // the string is
        tView.font = [UIFont systemFontOfSize:30];
    }
    return tView;
}
#pragma mark NSURLConnection Delegate Methods
// These methods handle HTTP requests. The name of each one is pretty self explanitory.
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
    // This method handles the response of the server. Here we check to see if the server
    // told us that it's running the program or not. We can change what we are looking for
    // by just changing what is in the rangeOfString: parameter
    if([_response rangeOfString:@"An email will be sent to you once it's finished."].location != NSNotFound) {
        NSString *message = @"The program is running... An email will be sent to you once it's finished.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        NSString *message = @"Could not run analysis";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self.activityWheel stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSString *message = @"Could not connect to server";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [self.activityWheel stopAnimating];
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
