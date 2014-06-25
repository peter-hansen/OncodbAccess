//
//  GSEAController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/23/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "GseaController.h"

@interface GSEAController ()
// Misc
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSString *response;
@property (strong, nonatomic) IBOutlet UITextField *sampleSelect;
@property (strong, nonatomic) IBOutlet UITextField *geneSelect;
@property (strong, nonatomic) IBOutlet UITextField *duplicateSelect;
@property (strong, nonatomic) IBOutlet UITextField *genesetSelect;
@property (strong, nonatomic) UIPickerView *samplePicker;
@property (strong, nonatomic) UIPickerView *genePicker;
@property (strong, nonatomic) UIPickerView *duplicatePicker;
@property (strong, nonatomic) UIPickerView *genesetPicker;
@property (strong, nonatomic) NSMutableArray *samples;
@property (strong, nonatomic) NSArray *gene;
@property (strong, nonatomic) NSArray *duplicate;
@property (strong, nonatomic) NSMutableDictionary *genesets;
@property (strong, nonatomic) NSArray *activeObjects;
@property (strong, nonatomic) IBOutlet UILabel *plus1;
@property (strong, nonatomic) IBOutlet UILabel *plus2;
@property (strong, nonatomic) IBOutlet UILabel *plus3;
@property (strong, nonatomic) NSDictionary *keys;
@property (strong, nonatomic) NSArray *switches;
@property int c;
// NCI
@property (strong, nonatomic) IBOutlet UILabel *NCIGeneSetv6tgmt;
@property (strong, nonatomic) IBOutlet UISwitch *NCIGeneSetv6tSwitch;
@property (strong, nonatomic) IBOutlet UILabel *NCIGeneSetv8gmt;
@property (strong, nonatomic) IBOutlet UISwitch *NCIGeneSetv8Switch;
@property (strong, nonatomic) IBOutlet UILabel *Neuroblastomagrp;
@property (strong, nonatomic) IBOutlet UISwitch *NeuroblastomaSwitch;
// Sample.Drug
@property (strong, nonatomic) IBOutlet UILabel *DrugHighgmt;
@property (strong, nonatomic) IBOutlet UISwitch *DrugHighSwitch;
@property (strong, nonatomic) IBOutlet UILabel *DrugLowgmt;
@property (strong, nonatomic) IBOutlet UISwitch *DrugLowSwitch;
@property (strong, nonatomic) IBOutlet UILabel *SampleHighgmt;
@property (strong, nonatomic) IBOutlet UISwitch *SampleHighSwitch;
@property (strong, nonatomic) IBOutlet UILabel *SampleLowgmt;
@property (strong, nonatomic) IBOutlet UISwitch *SampleLowSwitch;
// ANN
@property (strong, nonatomic) IBOutlet UILabel *cancerdiag2;
@property (strong, nonatomic) IBOutlet UILabel *cdEWS;
@property (strong, nonatomic) IBOutlet UILabel *cdRMS;
@property (strong, nonatomic) IBOutlet UISwitch *cancerdiag2Pos;
@property (strong, nonatomic) IBOutlet UISwitch *cancerdiag2Neg;
@property (strong, nonatomic) IBOutlet UISwitch *cdEWSpos;
@property (strong, nonatomic) IBOutlet UISwitch *cdEWSNeg;
@property (strong, nonatomic) IBOutlet UISwitch *cdRMSPos;
@property (strong, nonatomic) IBOutlet UISwitch *cdRMSNeg;
// Cell_Line
@property (strong, nonatomic) IBOutlet UISwitch *CCLEpos;
@property (strong, nonatomic) IBOutlet UISwitch *CCLEneg;
@property (strong, nonatomic) IBOutlet UILabel *CCLE;
@property (strong, nonatomic) IBOutlet UISwitch *NCI60pos;
@property (strong, nonatomic) IBOutlet UISwitch *NCI60neg;
@property (strong, nonatomic) IBOutlet UILabel *NCI60;
@property (strong, nonatomic) IBOutlet UISwitch *SCCLpos;
@property (strong, nonatomic) IBOutlet UISwitch *SCCLneg;
@property (strong, nonatomic) IBOutlet UILabel *SCCL;
// Drug_Response
@property (strong, nonatomic) IBOutlet UISwitch *NDSApos;
@property (strong, nonatomic) IBOutlet UISwitch *NSAneg;
@property (strong, nonatomic) IBOutlet UILabel *NDSA;
// Germ_Cell_Tumors
@property (strong, nonatomic) IBOutlet UISwitch *GermCTpos;
@property (strong, nonatomic) IBOutlet UISwitch *GermCTneg;
@property (strong, nonatomic) IBOutlet UILabel *GermCT;
// Leukemia
@property (strong, nonatomic) IBOutlet UISwitch *DWN133pos;
@property (strong, nonatomic) IBOutlet UISwitch *DWN133neg;
@property (strong, nonatomic) IBOutlet UILabel *DWN133;
@property (strong, nonatomic) IBOutlet UISwitch *DWN95pos;
@property (strong, nonatomic) IBOutlet UISwitch *DWN95neg;
@property (strong, nonatomic) IBOutlet UILabel *DWN;
@property (strong, nonatomic) IBOutlet UISwitch *TLAffypos;
@property (strong, nonatomic) IBOutlet UISwitch *TLAffyneg;
@property (strong, nonatomic) IBOutlet UILabel *TLAffy;
// Medulloblastoma
@property (strong, nonatomic) IBOutlet UISwitch *mbpos;
@property (strong, nonatomic) IBOutlet UISwitch *mbneg;
@property (strong, nonatomic) IBOutlet UILabel *mb;

@end

@implementation GSEAController
- (IBAction)Medulloblastoma:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    _plus1.hidden = false;
    _mbpos.hidden = false;
    _mbneg.hidden= false;
    _mb.hidden = false;
    _activeObjects = @[_plus1, _mb, _mbpos, _mbneg];
}
- (IBAction)Leukemia:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    _plus1.hidden = false;
    _plus2.hidden = false;
    _plus3.hidden = false;
    _DWN133pos.hidden = false;
    _DWN133neg.hidden = false;
    _DWN133.hidden = false;
    _DWN95pos.hidden = false;
    _DWN95neg.hidden = false;
    _DWN.hidden = false;
    _TLAffypos.hidden = false;
    _TLAffyneg.hidden = false;
    _TLAffy.hidden = false;
    _activeObjects = @[_plus1, _plus2, _plus3, _DWN133pos, _DWN133neg, _DWN133, _DWN95neg, _DWN95pos, _DWN, _TLAffy, _TLAffyneg, _TLAffypos];
}
- (IBAction)Germ_Cell_Tumors:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    _plus1.hidden = false;
    _GermCTpos.hidden = false;
    _GermCTneg.hidden = false;
    _GermCT.hidden = false;
    _activeObjects = @[_plus1, _GermCT, _GermCTneg, _GermCTpos];
}
- (IBAction)Drug_Response:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    _plus1.hidden = false;
    _NDSApos.hidden = false;
    _NSAneg.hidden = false;
    _NDSA.hidden = false;
    _activeObjects = @[_plus1, _NDSApos, _NSAneg, _NDSA];
}
- (IBAction)Cell_Line:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    _plus1.hidden = false;
    _plus2.hidden = false;
    _plus3.hidden = false;
    _CCLEpos.hidden = false;
    _CCLEneg.hidden = false;
    _CCLE.hidden = false;
    _NCI60pos.hidden = false;
    _NCI60neg.hidden = false;
    _NCI60.hidden = false;
    _SCCLpos.hidden = false;
    _SCCLneg.hidden = false;
    _SCCL.hidden = false;
        _activeObjects = @[_plus1, _plus2, _plus3, _CCLEpos, _CCLEneg, _CCLE, _NCI60pos, _NCI60neg, _NCI60, _SCCLpos, _SCCLneg,_SCCL];
}
- (IBAction)ANN:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    _plus1.hidden = false;
    _plus2.hidden = false;
    _plus3.hidden = false;
    _cancerdiag2.hidden=false;
    _cdEWS.hidden = false;
    _cdRMS.hidden = false;
    _cancerdiag2Pos.hidden = false;
    _cancerdiag2Neg.hidden = false;
    _cdEWSpos.hidden = false;
    _cdEWSNeg.hidden = false;
    _cdRMSPos.hidden = false;
    _cdRMSNeg.hidden = false;
    _activeObjects = @[_plus1, _plus2, _plus3, _cdRMS, _cdEWS, _cancerdiag2, _cancerdiag2Pos, _cancerdiag2Neg, _cdRMSPos, _cdRMSNeg, _cdEWSpos,_cdEWSNeg];
}
- (IBAction)SampleDrug:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    _DrugHighgmt.hidden=false;
    _DrugHighSwitch.hidden=false;
    _DrugLowgmt.hidden=false;
    _DrugLowSwitch.hidden=false;
    _SampleHighgmt.hidden=false;
    _SampleHighSwitch.hidden=false;
    _SampleLowgmt.hidden=false;
    _SampleLowSwitch.hidden=false;
    _activeObjects = @[_DrugHighgmt, _DrugHighSwitch, _DrugLowgmt, _DrugLowSwitch, _SampleHighgmt, _SampleHighSwitch, _SampleLowgmt, _SampleLowSwitch];
}
- (IBAction)NCI:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    _NCIGeneSetv6tgmt.hidden = false;
    _NCIGeneSetv6tSwitch.hidden = false;
    _NCIGeneSetv8gmt.hidden = false;
    _NCIGeneSetv8Switch.hidden = false;
    _Neuroblastomagrp.hidden = false;
    _NeuroblastomaSwitch.hidden = false;
    _activeObjects = @[_NCIGeneSetv6tgmt, _NCIGeneSetv6tSwitch, _NCIGeneSetv8gmt, _NCIGeneSetv8Switch, _Neuroblastomagrp, _NeuroblastomaSwitch];
}
- (IBAction)runGSEA:(id)sender {
    [self.activityWheel startAnimating];
    NSString *chosenGenes = _geneSelect.text;
    NSString *chosenGeneset = _genesets[_genesetSelect.text];
    chosenGeneset = [chosenGeneset stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *duplicateyn = _duplicateSelect.text;
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
    NSMutableString *grp = [[NSMutableString alloc]init];
    for (UISwitch *theswitch in _switches) {
        if ([theswitch isOn]) {
            [grp appendString:@"&grp="];
            [grp appendString:_keys[theswitch.accessibilityLabel]];
        }
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock?rm=query_all;db=rseASPS;source=genomic"]];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"rm=query_all&frm=query_all&submitted_multi_expression_query=TRUErm=show_gsea&show_gsea=Run+GSEA&prerank_file=null&gsea_file=null&db=%@&smplid=%ld&geneset=%@&geneduprm=%@&gmx=%@%@", _db, (long)[self.samplePicker selectedRowInComponent:0], chosenGenes, duplicateyn, chosenGeneset, grp];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
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
    _switches = @[_NCIGeneSetv6tSwitch, _NCIGeneSetv8Switch, _DrugHighSwitch, _DrugLowSwitch, _SampleLowSwitch, _SampleHighSwitch, _cancerdiag2Neg, _cancerdiag2Pos, _cdEWSNeg, _cdEWSpos, _cdRMSNeg, _cdRMSPos, _CCLEneg, _CCLEpos, _NCI60neg, _NCI60pos, _SCCLneg, _SCCLpos, _NDSApos, _NSAneg, _GermCTneg, _GermCTpos, _DWN133neg, _DWN133pos, _DWN95neg, _DWN95pos,_TLAffyneg, _TLAffypos, _mbneg, _mbpos];
    _keys = [[NSDictionary alloc]init];
    _keys = @{_NCIGeneSetv6tSwitch.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/0.NCI/NCI_GeneSet_v6b.gmt", _NCIGeneSetv8Switch.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/0.NCI/NCI_GeneSet_v8.gmt", _NeuroblastomaSwitch.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/0.NCI/Neuroblastoma.grp", _DrugHighSwitch.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/0.Sample.Drug/Drug_High.gmt", _DrugLowSwitch.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/0.Sample.Drug/Drug_Low.gmt", _SampleHighSwitch.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/0.Sample.Drug/Sample_High.gmt", _SampleLowSwitch.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/0.Sample.Drug/Sample_Low.gmt", _cancerdiag2Pos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.ANN_positive/cancerdiag2_PediatricSolidTumors_ANN.200.top.positive.gmt", _cancerdiag2Neg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.ANN_negative/cancerdiag2_PediatricSolidTumors_ANN.200.bottom.negative.gmt", _cdEWSpos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.ANN_positive/cdEWS_EWS_ANN.200.top.positive.gmt", _cdEWSNeg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.ANN_negative/cdEWS_EWS_ANN.200.bottom.negative.gmt", _cdRMSPos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.ANN_positive/cdRMS_RMS_ANN.200.top.positive.gmt", _cdRMSNeg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.ANN_negative/cdRMS_RMS_ANN.200.bottom.negative.gmt", _CCLEpos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Cell_Line_positive/CCLE_CCLE.200.top.positive.gmt", _CCLEneg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Cell_Line_negative/CCLE_CCLE.200.bottom.negative.gmt", _SCCLpos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Cell_Line_positive/SCCL_SangerCCL_Affy.200.top.positive.gmt", _SCCLneg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Cell_Line_negative/SCCL_SangerCCL_Affy.200.bottom.negative.gmt", _NCI60pos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Cell_Line_positive/NCI.60.Gene.Expression.Database.200.top.positive.gmt", _NCI60neg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Cell_Line_negative/NCI.60.Gene.Expression.Database.200.bottom.negative.gmt", _NDSApos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Drug_Response_positive/NDSAffy_NB_DrugScreen.200.top.positive.gmt", _NSAneg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Drug_Response_negative/NDSAffy_NB_DrugScreen.200.bottom.negative.gmt", _GermCTpos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Germ_Cell_Tumors_positive/GermCT_GermCellTumor.200.top.positive.gmt", _GermCTneg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Germ_Cell_Tumors_negative/GermCT_GermCellTumor.200.bottom.negative.gmt", _DWN133pos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Leukemia_positive/StJLeukDWN133_Leukemia_StJude_U133AB.200.top.positive.gmt", _DWN133neg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Leukemia_negative/StJLeukDWN133_Leukemia_StJude_U133AB.200.bottom.negative.gmt", _DWN95pos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Leukemia_positive/StJLeukDWN95_Leukemia_StJude_U95.200.top.positive.gmt", _DWN95neg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Leukemia_negative/StJLeukDWN95_Leukemia_StJude_U95.200.bottom.negative.gmt", _TLAffypos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Leukemia_positive/TLAffy_Leukemia_StJude_U133plus2.200.top.positive.gmt", _TLAffyneg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Leukemia_negative/TLAffy_Leukemia_StJude_U133plus2.200.bottom.negative.gmt", _mbpos.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Medulloblastoma_positive/mbProgPm_Medulloblastoma.200.top.positive.gmt", _mbneg.accessibilityLabel : @"/WWW/htdocs/gsea/gene_sets/GSEA_genesets/1.Medulloblastoma_negative/mbProgPm_Medulloblastoma.200.bottom.negative.gmt"};
    _gene = @[@"Use all genes(probes)", @"Use current genes"];
    _duplicate = @[@"Keep highest value(abs)", @"keep all"];
    NSArray *sampleFinder = [[NSArray alloc] initWithArray:[_html componentsSeparatedByString:@"<select NAME=\"smplid\">"]];
    NSArray *sampleFinder2 = [sampleFinder[1] componentsSeparatedByString:@"</select>"];
    NSArray *sampleFinder3 = [sampleFinder2[0] componentsSeparatedByString:@">"];
    _samples = [[NSMutableArray alloc]init];
    NSString *sample = [[NSString alloc]init];
    for (NSString *object in sampleFinder3) {
        if ([object rangeOfString:@"<option"].location == NSNotFound && [object length] != 8 && [object length] != 0) {
            sample = [object stringByReplacingOccurrencesOfString:@"</option" withString:@""];
            [_samples addObject:sample];
        }
    }
    sampleFinder = [_html componentsSeparatedByString:@"<SELECT NAME=gmx"];
    sampleFinder2 = [sampleFinder[1] componentsSeparatedByString:@"</SELECT>"];
    sampleFinder3 = [sampleFinder2[0] componentsSeparatedByString:@"<OPTION value"];
    _genesets = [[NSMutableDictionary alloc]init];
    NSArray *sampleFinder4 = [[NSArray alloc]init];
    NSString *key = [[NSString alloc]init];
    NSString *url = [[NSString alloc]init];
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
    NSArray *keys = [_genesets allKeys];
    id aKey = [keys objectAtIndex:0];
    _genesetSelect.text = @"Select MSigDC gene set";
    [_duplicatePicker setDataSource:self];
    [_duplicatePicker setDelegate:self];
    [_duplicatePicker setShowsSelectionIndicator:YES];
    _duplicateSelect.inputView = _duplicatePicker;
    _duplicateSelect.text = @"Keep highest value(abs)";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark PickerView dataSource
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
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

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
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
    }
    if (pickerView == self.samplePicker) {
        tView.text=_samples[row];
        tView.font = [UIFont systemFontOfSize:14];
    }
    else if (pickerView == self.genePicker) {
        tView.text=_gene[row];
    }
    else if (pickerView == self.genesetPicker) {
        NSMutableArray *keys = [[_genesets allKeys] mutableCopy];
        [keys insertObject:@"Select MSigDC gene set" atIndex:0];
        tView.text=keys[row];
        tView.font = [UIFont systemFontOfSize:14];
    } else if (pickerView == self.duplicatePicker) {
        tView.text=_duplicate[row];
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
