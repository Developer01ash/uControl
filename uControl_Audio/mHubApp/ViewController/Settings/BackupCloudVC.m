//
//  BackupCloudVC.m
//  mHubApp
//
//  Created by Anshul Jain on 05/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "BackupCloudVC.h"
#import "CellAddLabel.h"
#import "UserData.h"
#import "CellHeaderImage.h"
#import "CloudDeviceListVC.h"

@interface BackupCloudVC () {
    UITextField *activeField;
    NSString *strSendButtonTitle;
    NSInteger intSelectedCountry;
    NSDateFormatter *dateFormatter;
}
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBarCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBarDone;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCountry;
@property (weak, nonatomic) IBOutlet UITableView *tblUserData;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBarDateCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBarDateDone;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerPurchase;

@property (nonatomic, retain) NSMutableArray *arrData;
@property (nonatomic) NSMutableArray *arrPickerData;

@end

@implementation BackupCloudVC
@synthesize backupType;

- (void)viewDidLoad {
    [super viewDidLoad];
    @try {
        switch (self.formType) {
            case Login: {
                switch (backupType) {
                    case Fetch: {
                        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:HUB_QUICKSYNCHDACLOUD];
                        strSendButtonTitle = HUB_SYNCWITHCLOUD;
                        break;
                    }
                    case Post: {
                        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:HUB_BACKUPHDACLOUD];
                        strSendButtonTitle = HUB_BACKUPTOCLOUD;
                        break;
                    }
                    default:
                        break;
                }
                self.arrData = [[NSMutableArray alloc] initWithArray:[UserData getCloudLoginArray]];
                break;
            }
            case Registration: {
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:HUB_CREATEHDACLOUDACCOUNT];
                strSendButtonTitle = HUB_VALIDATESERIALNUMBER;
                self.arrData = [[NSMutableArray alloc] initWithArray:[UserData getCloudRegistrationArray]];
                
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                [self.datePickerPurchase setMaximumDate:[NSDate date]];
                
                NSArray *arrCountry = [[NSArray alloc] initWithObjects:@"AFG 0093", @"ALB 0355", @"DZA 0213", @"ASM 1-684", @"AND 0376", @"AGO 0244", @"AIA 1-264", @"ATA 0672", @"ATG 1-268", @"ARG 0054", @"ARM 0374", @"ABW 0297", @"AUS 0061", @"AUT 0043", @"AZE 0994", @"BHS 1-242", @"BHR 0973", @"BGD 0880", @"BRB 1-246", @"BLR 0375", @"BEL 0032", @"BLZ 0501", @"BEN 0229", @"BMU 1-441", @"BTN 0975", @"COL 0057", @"COM 0269", @"COK 0682", @"CUB 0053", @"CYP 0357", @"CZE 0420", @"COD 0243", @"DNK 0045", @"DJI 0253", @"DMA 1-767", @"TLS 0670", @"ECU 0593", @"EGY 0020", @"SLV 0503", @"GNQ 0240", @"ERI 0291", @"EST 0372", @"ETH 0251", @"FLK 0500", @"FRO 0298", @"FJI 0679", @"FIN 0358", @"FRA 0033", @"PYF 0689", @"GAB 0241", @"GMB 0220", @"GEO 0995", @"DEU 0049", @"GHA 0233", @"GIB 0350", @"GRC 0030", @"HKG 0852", @"HUN 0036", @"ISL 0354", @"IND 0091", @"IDN 0062", @"IRN 0098", @"IRQ 0964", @"IRL 0353", @"ISR 0972", @"ITA 0039", @"JAM 1-876", @"JPN 0081", @"JEY 44-1534", @"JOR 0962", @"KAZ 0007", @"KEN 0254", @"KIR 0686", @"XKX 0384", @"KWT 0965", @"KGZ 0996", @"LAO 0856", @"LVA 0371", @"LBN 0961", @"LSO 0266", @"LBR 0231", @"MYS 0060", @"MEX 0052", @"MDA 0373", @"MCO 0377", @"PHL 0063", @"RUS 0007", @"SAU 0966", @"SGP 0065", @"SVN 0386", @"SOM 0252", @"ZAF 0027", @"KOR 0082", @"SSD 0211", @"ESP 0034", @"LKA 0094", @"SDN 0249", @"SWE 0046", @"CHE 0041", @"SYR 0963", @"TWN 0886", @"THA 0066", @"TUR 0090", @"UK 0044", @"USA 0001", @"VAT 0379", @"VEN 0058", @"VNM 0084", @"WLF 0681", @"ESH 0212", @"YEM 0967", @"ZMB 0260", @"ZWE 0263", nil];
                
                NSArray *sortedArray = [arrCountry sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                
                self.arrPickerData = [[NSMutableArray alloc] init];
                [self.arrPickerData addObject:@"Select"];
                [self.arrPickerData addObjectsFromArray:sortedArray];
                
                intSelectedCountry = 0;
                    // For default selection to last value.
                [self.pickerCountry selectRow:intSelectedCountry inComponent:0 animated:YES];
                
                for (int counter = 0; counter < self.arrData.count; counter++) {
                    UserData *objData = [self.arrData objectAtIndex:counter];
                    if (objData.userTag == CalledCountry) {
                        objData.strValue = [self.arrPickerData objectAtIndex:intSelectedCountry];
                        [self.arrData replaceObjectAtIndex:counter withObject:objData];
                        break;
                    }
                }
                [self registerForKeyboardNotifications];

                break;
            }
            default:
                break;
        }
        
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:self.selectedSetting.Title];
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        self.navigationItem.backBarButtonItem = customBackBarButton;
        self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
        if (self.formType == Registration) {
            [self.lblHeaderMessage setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                [self.lblHeaderMessage setFont:textFontRegular12];
            } else {
                [self.lblHeaderMessage setFont:textFontRegular18];
            }
        }
        [[AppDelegate appDelegate] setShouldRotate:NO];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontRegular12];
    } else {
        [self.lblHeaderMessage setFont:textFontRegular18];
    }
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPicker ToolBar Methods

- (IBAction)btnBarCancel_Clicked:(id)sender {
    @try {
        [self.viewPicker downSlideWithCompletion:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnBarDone_Clicked:(id)sender {
    @try {
        [self.viewPicker downSlideWithCompletion:^(BOOL finished) {
            if (finished) {
                for (int counter = 0; counter < self.arrData.count; counter++) {
                    UserData *objData = [self.arrData objectAtIndex:counter];
                    if (objData.userTag == CalledCountry) {
                        objData.strValue = [self.arrPickerData objectAtIndex:intSelectedCountry];
                        [self.arrData replaceObjectAtIndex:counter withObject:objData];
                        break;
                    }
                }
                [self.tblUserData reloadData];
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
#pragma mark - UIDatePicker ToolBar Methods

- (IBAction)btnBarDateCancel_Clicked:(id)sender {
    @try {
        [self.viewDatePicker downSlideWithCompletion:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnBarDateDone_Clicked:(id)sender {
    @try {
        [self.viewDatePicker downSlideWithCompletion:^(BOOL finished) {
            if (finished) {
                for (int counter = 0; counter < self.arrData.count; counter++) {
                    UserData *objData = [self.arrData objectAtIndex:counter];
                    if (objData.userTag == DateOfPurchase) {
                        objData.strValue = [dateFormatter stringFromDate:self.datePickerPurchase.date];
                        [self.arrData replaceObjectAtIndex:counter withObject:objData];
                        break;
                    }
                }
                [self.tblUserData reloadData];
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)datePicker_ValueChanged:(UIDatePicker *)sender {
    @try {
        for (int counter = 0; counter < self.arrData.count; counter++) {
            UserData *objData = [self.arrData objectAtIndex:counter];
            if (objData.userTag == DateOfPurchase) {
                objData.strValue = [dateFormatter stringFromDate:self.datePickerPurchase.date];
                [self.arrData replaceObjectAtIndex:counter withObject:objData];
                break;
            }
        }
        [self.tblUserData reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIPickerViewDatasource and Delegate
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrPickerData.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = self.arrPickerData[row];
    NSAttributedString *attString =
    [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:colorLightGray_208210211, NSFontAttributeName: textFontLight13}];
    
    return attString;
}

#pragma mark - UIPickerViewDelegate
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    intSelectedCountry = row;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            return heightTableViewRowWithPadding_SmallMobile;
        } else {
            return heightTableViewRowWithPadding;
        }
    } else {
        UserData *objData = [self.arrData objectAtIndex:indexPath.row];
        if (objData.userTag == MHubImage) {
            if ([objData.strValue integerValue] == 8) {
                return kDEVICEMODEL_IMAGE_HEIGHT_MHUB4K862;
            } else {
                return kDEVICEMODEL_IMAGE_HEIGHT_MHUB4K431;
            }
        }
    }
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPaddingWithLabel_SmallMobile;
    } else {
        return heightTableViewRowWithPaddingWithLabel;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSend"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSend"];
        }

        [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorTableCellBorder BorderWidth:1.0];
        [cell.lblCell setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
        cell.lblCell.text = strSendButtonTitle;
        return cell;
    } else {
        UserData *objData = [self.arrData objectAtIndex:indexPath.row];
        if (objData.userTag == MHubImage) {
            CellHeaderImage *cell = [tableView dequeueReusableCellWithIdentifier:@"CellImage"];
            cell = nil;
            if (cell == nil) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellImage"];
            }
            if ([objData.strValue integerValue] == 8) {
                cell.imgCell.image = kDEVICEMODEL_IMAGE_MHUB4K862;
            } else {
                cell.imgCell.image = kDEVICEMODEL_IMAGE_MHUB4K431;
            }
            return cell;
        } else {
            CellAddLabel *cell = [tableView dequeueReusableCellWithIdentifier:@"CellUserdata"];
            cell = nil;
            if (cell == nil) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellUserdata"];
            }
            [cell.lblCell setText:[objData.strPlaceholder uppercaseString]];
            [cell.txtCell setTag:indexPath.row];
            [cell.txtCell setText:[objData.strValue isNotEmpty] ? objData.strValue : @""];
            
            switch (objData.userTag) {
                case EmailId: {
                    [cell.txtCell setKeyboardType:UIKeyboardTypeEmailAddress];
                    [cell.txtCell setSecureTextEntry:false];
                    break;
                }
                case Password: {
                    [cell.txtCell setSecureTextEntry:true];
                    break;
                }
                case SerialNo: {
                    [cell.txtCell setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
                    [cell.txtCell setSecureTextEntry:false];
                    break;
                }
                case MHubType: {
                    [cell.txtCell setSecureTextEntry:false];
                    break;
                }
                case FirstName: {
                    [cell.txtCell setSecureTextEntry:false];
                    break;
                }
                case SecondName: {
                    [cell.txtCell setSecureTextEntry:false];
                    break;
                }
                case CalledCountry: {
                    [cell.txtCell setUserInteractionEnabled:false];
                    [cell.txtCell setSecureTextEntry:false];
                    break;
                }
                case Telephone: {
                    [cell.txtCell setKeyboardType:UIKeyboardTypePhonePad];
                    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
                    numberToolbar.barStyle = UIBarStyleDefault;
                    [numberToolbar setTintColor:colorDarkGray_333131];
                    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelWithNumberPad)], [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
                    [numberToolbar sizeToFit];
                    [cell.txtCell setInputAccessoryView:numberToolbar];
                    [cell.txtCell setSecureTextEntry:false];

                    break;
                }
                case DateOfPurchase: {
                    [cell.txtCell setUserInteractionEnabled:false];
                    [cell.txtCell setSecureTextEntry:false];

                    break;
                }
                case PurchasedWhere: {
                    [cell.txtCell setSecureTextEntry:false];

                    break;
                }
                    
                default:
                    break;
            }
            return cell;
        }
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        switch (indexPath.section) {
            case 0: {
                [self.view endEditing:true];
                UserData *objData = [self.arrData objectAtIndex:indexPath.row];
                if (objData.userTag == CalledCountry) {
                    [self.viewPicker upSlideWithCompletion:nil];
                } else if (objData.userTag == DateOfPurchase) {
                    [self.viewDatePicker upSlideWithCompletion:nil];
                }
                break;
            }
            case 1: {
                [self checkValidations];
                break;
            }
            default:
                break;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) checkValidations {
    @try {
        [[self view] endEditing:YES];
        NSMutableString *strMessage = [[NSMutableString alloc] init];
        BOOL isValid = true;
        for (UserData *objData in self.arrData) {
            switch (objData.userTag) {
                case EmailId: {
                    BOOL isValidEmail = [objData.strValue isValidEmail];
                    if (!isValidEmail) {
                        isValid = false;
                        [strMessage appendString:ALERT_MESSAGE_ENTER_EMAILID];
                    }
                    break;
                }
                case Password: {
                    BOOL isValidPassword = [objData.strValue isValidPassword];
                    if (!isValidPassword) {
                        isValid = false;
                        [strMessage appendString:ALERT_MESSAGE_ENTER_PASSWORD];
                    }
                    break;
                }
                  
                case SerialNo: {
                    BOOL isNotEmpty = [objData.strValue isNotEmpty];
                    if (isNotEmpty) {
                        mHubManagerInstance.objSelectedHub.SerialNo = objData.strValue;
                    } else {
                        isValid = false;
                        [strMessage appendString:ALERT_MESSAGE_ENTER_SERIALNO];
                    }
                    break;
                }
                  
                case MHubType: {
                    BOOL isNotEmpty = [objData.strValue isNotEmpty];
                    if (!isNotEmpty) {
                        isValid = false;
                        [strMessage appendString:ALERT_MESSAGE_ENTER_MHUBTYPE];
                    }
                    break;
                }
                case FirstName: {
                    BOOL isNotEmpty = [objData.strValue isNotEmpty];
                    if (!isNotEmpty) {
                        isValid = false;
                        [strMessage appendString:ALERT_MESSAGE_ENTER_FIRSTNAME];
                    }
                    break;
                }
                case SecondName: {
                    BOOL isNotEmpty = [objData.strValue isNotEmpty];
                    if (!isNotEmpty) {
                        isValid = false;
                        [strMessage appendString:ALERT_MESSAGE_ENTER_SECONDNAME];
                    }
                    break;
                }
                case CalledCountry: {
                    BOOL isNotEmpty = [objData.strValue isNotEmpty];
                    if (!isNotEmpty || [objData.strValue isEqualToString:@"Select"]) {
                        isValid = false;
                        [strMessage appendString:ALERT_MESSAGE_SELECT_CALLEDCOUNTRY];
                    }
                    break;
                }
                case Telephone: {
                    BOOL isNotEmpty = [objData.strValue isValidPhoneNumber];
                    if (!isNotEmpty) {
                        isValid = false;
                        [strMessage appendString:ALERT_MESSAGE_ENTER_TELEPHONE];
                    }
                    break;
                }
                case DateOfPurchase: {
                    BOOL isNotEmpty = [objData.strValue isNotEmpty];
                    if (!isNotEmpty) {
                        isValid = false;
                        [strMessage appendString:ALERT_MESSAGE_ENTER_DATEOFPURCHASE];
                    }
                    break;
                }
                case PurchasedWhere: {
                    BOOL isNotEmpty = [objData.strValue isNotEmpty];
                    if (!isNotEmpty) {
                        isValid = false;
                        [strMessage appendString:ALERT_MESSAGE_ENTER_PURCHASEDWHERE];
                    }
                    break;
                }
                default:
                    break;
            }
        }

        if (isValid) {
            [self postHDALoginRegistration:self.arrData];
        } else {

            [[AppDelegate appDelegate] showHudView:ShowMessage Message:strMessage];

        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) postHDALoginRegistration:(NSMutableArray *)arrParameter {
    @try {
        // DDLogDebug(@"Post data == %@", arrParameter);
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if (self.formType == Registration) {
            [APIManager postCloudRegistration:[UserData getRegistrationParameterDictionary:arrParameter] completion:^(APIResponse *objResponse) {
                DDLogDebug(@"postCloudRegistration objResponse == %@", objResponse);
                if (objResponse.error == false) {
                    [Utility saveUserDefaults:kUserData value:[UserData getRegistrationParameterDictionary:arrParameter]];
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResponse.response];
                    [self.navigationController popViewControllerAnimated:true];
                } else {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                }
            }];
        } else {
            [APIManager postCloudLogin:[UserData getParameterDictionary:arrParameter] completion:^(APIResponse *objResponse) {
                DDLogDebug(@"postCloudLogin objResponse == %@", objResponse);
                if (objResponse.error == false) {
                    [Utility saveUserDefaults:kUserData value:[UserData getRegistrationParameterDictionary:arrParameter]];
                    NSArray *arrData = [[NSArray alloc] initWithArray:objResponse.data];
                    [self postDataToCloud:arrParameter Data:arrData];
                } else {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                }
            }];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) postDataToCloud:(NSArray *)arrParameter Data:(NSArray *)arrData {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] initWithDictionary:[UserData getParameterDictionary:arrParameter]];

        switch (backupType) {
            case Post: {
                NSMutableDictionary *dictParameterData = [[NSMutableDictionary alloc] initWithDictionary:dictParameter];
                [dictParameterData setObject:mHubManagerInstance.objSelectedHub.SerialNo forKey:kSerial_Number];
                [dictParameterData setObject:[mHubManagerInstance.objSelectedHub dictionaryRepresentation] forKey:kData];
                [APIManager postCloudBackup:dictParameterData completion:^(APIResponse *objResponse) {
                    DDLogDebug(@"postCloudBackup objResponse == %@", objResponse);
                    if (objResponse.error == false) {
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResponse.response];
                        [self.navigationController popViewControllerAnimated:true];
                    } else {
                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                    }
                }];
                break;
            }
            case Fetch: {
                if (arrData.count > 1) {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    CloudDeviceListVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"CloudDeviceListVC"];
                    objVC.arrData = [[NSMutableArray alloc] initWithArray:arrData];
                    objVC.dictParameter = [[NSMutableDictionary alloc] initWithDictionary:dictParameter];
                    [self.navigationController pushViewController:objVC animated:YES];
                } else if (arrData.count == 1) {
                    CloudData *objData = (CloudData *)[arrData firstObject];
                    [dictParameter setObject:objData.strSerialNo forKey:kSerial_Number];
                    
                    [APIManager fetchCloudBackup:dictParameter completion:^(APIResponse *objResponse) {
                        DDLogDebug(@"fetchCloudBackup objResponse == %@", objResponse);
                        if (objResponse.error) {
                            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                        } else {
                            [mHubManagerInstance syncGlobalManagerObjectV0];
                            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                            [self.navigationController popViewControllerAnimated:true];
                        }
                    }];
                } else {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                }
                break;
            }
            default:
                break;
        }
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
#pragma mark - numberpad Toolbar methods

-(void)doneWithNumberPad {
    @try {
        [self.view endEditing:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) cancelWithNumberPad {
    @try {
        [self.view endEditing:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSInteger nextTag = textField.tag + 1;
//    // Try to find next responder
//    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//    if (nextResponder) {
//        // Found next responder, so set it.
//        [nextResponder becomeFirstResponder];
//    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
//    }
    return YES; // We do not want UITextField to insert line-breaks.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
    NSString *strValue = [[NSString stringWithFormat:@"%@", [textField.text isNotEmpty] ? textField.text : @""] getTrimmedString];
    UserData *objData = [self.arrData objectAtIndex:textField.tag];
    objData.strValue = strValue;
    [self.arrData replaceObjectAtIndex:textField.tag withObject:objData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length + range.location > textField.text.length)
        return false;
    NSInteger newLength = textField.text.length + string.length - range.length;
    NSString * strNew = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == SerialNo) {
        if (![[strNew uppercaseString] containsString:@"MHUB4K"]) {
            return false;
        }
        return newLength <= 24;
    }
    return newLength <= 100;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString * strNew = textField.text;
    if (textField.tag == SerialNo) {
        strNew = [strNew stringByReplacingOccurrencesOfString:@"X" withString:@""];
        textField.text = strNew;
    }
    activeField = textField;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tblUserData.contentInset = contentInsets;
    self.tblUserData.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        UITableViewCell *cell = (UITableViewCell*) [[activeField superview] superview];
        [self.tblUserData scrollToRowAtIndexPath:[self.tblUserData indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tblUserData.contentInset = contentInsets;
    self.tblUserData.scrollIndicatorInsets = contentInsets;
}

@end
