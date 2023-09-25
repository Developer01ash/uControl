//
//  SubSettingsVC.m
//  mHubApp
//
//  Created by Anshul Jain on 03/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "SubSettingsVC.h"
#import "CellSetting.h"
#import "AddLabelsVC.h"
#import "UserData.h"
#import "BackupCloudVC.h"
#import "CloudDeviceListVC.h"
#import "CloudData.h"
#import "DisplaySettingsVC.h"
#import "AboutUcontrolVC.h"
#import "EnterIPAddressManuallyUpdateFlowVC.h"
#import "DeviceListToUpdateVC.h"

@import SafariServices;

@interface SubSettingsVC () <UINavigationControllerDelegate, SFSafariViewControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate> {
    SFSafariViewController *safariVC;
    BOOL flagForPowerState;
    NSInteger resetTab_Count;
}
@property (weak, nonatomic) IBOutlet UITableView *tblSubSettings;
@property (strong, nonatomic) NSMutableArray *arrSettings;
@property(nonatomic, strong) UIAlertAction *okAction;


@end

@implementation SubSettingsVC
//@synthesize settingType;

- (void)viewDidLoad {
    [super viewDidLoad];
    resetTab_Count = 0;
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    [self.navigationController.navigationBar setHidden:NO];
    if(![mHubManagerInstance.objSelectedHub isZPSetup]){
    [self getPowerState:mHubManagerInstance.objSelectedHub.Address];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    //self.view.backgroundColor = themeColor.colorBackground;
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    [[AppDelegate appDelegate] setShouldRotate:NO];
    
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:self.selectedSetting.Title];
  //  self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:self.selectedSetting.Title];
    
    switch (self.selectedSetting.sectionType) {
         case HDA_AccessSystem: {
             self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBAccessSystemArray]];
             break;
         }
            
        case HDA_MHUBSystem: {
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBSystemSettingsArray]];
            break;
        }

        case HDA_HDACloud: {
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getHDACloudSettingsArray]];
            break;
        }
            
        case HDA_UControlSettings: {
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getUCONTROLSettingsArray]];
            break;
        }

        case HDA_ManageLabels: {
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getManageLabelsSettingsArray]];
            break;
        }
            
        case HDA_AdditionalCustomization: {
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getAdditionalCustomizationArray]];
            break;
        }
        case HDA_Interface: {
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBUCONTROLINTERFACESETTINGS]];
            break;
        }
        case HDA_Appearance: {
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBUCONTROLAPPEARANCESETTINGS]];
            break;
        }
        case HDA_ManageSource:{
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMenuSettingsArray_ForManageSource]];
            break;
        }
        case HDA_general:
        {
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBUCONTROLGENERALSETTINGS]];
            break;
        }
        case HDA_utility:
        {
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBUCONTROLUTILITYSETTINGS]];
            break;
        }

        default:
            break;
    }
    [self.tblSubSettings reloadData];
}
-(void)getPowerState:(NSString *)hubAddress {

   // [APIManager getmHubPowerState:hubAddress completion:completion:^(NSDictionary *responseObject)];
    [APIManager getmHubPowerState:hubAddress completion:^(NSDictionary *responseObject) {
        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
         if(responseObject != nil){
            NSLog(@"getmHubPowerState Success  %@",responseObject);
             NSNumber *powerState = (NSNumber *)[responseObject objectForKey:@"power"];
             self->flagForPowerState = [powerState boolValue];
             NSLog(@"bool val is: %d",self->flagForPowerState);
             [self.tblSubSettings reloadData];
             

        }
        else
        {
            
        }
    }];
}
-(void)setPowerState:(NSString *)hubAddress state:(NSString *)pState{

   // [APIManager getmHubPowerState:hubAddress completion:completion:^(NSDictionary *responseObject)];
    [APIManager setmHubPowerState:hubAddress powerSt:pState completion:^(NSDictionary *responseObject) {
        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
         if(responseObject != nil){
            NSLog(@"setmHubPowerState Success  %@",responseObject);
        }
        else
        {
            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)ClickOn_BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)switchChanged:(UISwitch *)sender {
   // Do something
  /// BOOL value = sender.on;
    NSString *str;
    if(sender.isOn)
    {
        str = @"1";
        [sender setOnTintColor:colorMiddleGray_868787];
        [sender setThumbTintColor:colorProPink];
        
    }else
    {
        str = @"0";
        [sender setTintColor:colorMiddleGray_868787];
       // [sender setOnTintColor:colorMiddleGray_868787];
        [sender setBackgroundColor:colorMiddleGray_868787];
        sender.layer.cornerRadius = sender.frame.size.height/2;
        [sender setThumbTintColor:colorWhite];
    }
    [self setPowerState:mHubManagerInstance.objSelectedHub.Address state:str];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrSettings.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellSetting";
    CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorBackground Frame:cell.imgBackground.frame];
    [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorTableCellBorder BorderWidth:1.0];
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [cell.lblCell setFont:textFontBold10];
    } else {
        [cell.lblCell setFont:textFontBold13];
    }
    UIImage *image = [kImageIconNextArrow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    [cell.imgNextArrow  setTintColor:[AppDelegate appDelegate].themeColours.colorDownArrow];
    [cell.imgNextArrow setImage:image];
    [cell.imgNextArrow setTintColor:[AppDelegate appDelegate].themeColours.colorNormalText];
   

    SectionSetting *objSection = [self.arrSettings objectAtIndex:indexPath.row];
    cell.lblCell.text = [objSection.Title uppercaseString];
    [cell.lblCell setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
    if(objSection.sectionType == HDA_power)
    {
        [cell.imgNextArrow setHidden:true];
        [cell.switch_onOFF setHidden:false];
        if (flagForPowerState) {
            [cell.switch_onOFF setOn:true];
            [cell.switch_onOFF setOnTintColor:colorMiddleGray_868787];
            [cell.switch_onOFF setThumbTintColor:colorProPink];
        }else{
        [cell.switch_onOFF setOn:false];
        [cell.switch_onOFF setTintColor:colorMiddleGray_868787];
        [cell.switch_onOFF setBackgroundColor:colorMiddleGray_868787];
            cell.switch_onOFF.layer.cornerRadius = cell.switch_onOFF.frame.size.height/2;
        [cell.switch_onOFF setThumbTintColor:colorWhite];
        }
        
        
        
        
    }
    else if(objSection.sectionType == HDA_Resync_MOS || objSection.sectionType == HDA_RemoveUControl)
    {
        [cell.imgNextArrow setHidden:true];
        [cell.switch_onOFF setHidden:true];
    }
    else{
        [cell.imgNextArrow setHidden:false];
        [cell.switch_onOFF setHidden:true];
    }
    return cell;
}

#pragma mark - UITableView Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
    SectionSetting *objSection = [self.arrSettings objectAtIndex:indexPath.row];
        
        switch (objSection.sectionType) {
            //MARK: HDA_PairedNameAndAddress
            case HDA_PairedNameAndAddress: {
                if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: ALERT_ENTER_AUDIOIPADDRESS message: ALERT_MESSAGE_ENTER_AUDIOIPADDRESS  preferredStyle:UIAlertControllerStyleAlert];
                    alertController.view.tintColor = colorGray_646464;
                    self.okAction = [UIAlertAction actionWithTitle:ALERT_BTN_TITLE_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSArray * textfields = alertController.textFields;
                        UITextField * strIPAddress = textfields[0];
                        DDLogDebug(@"Audio IP Address === %@",strIPAddress.text);
                        mHubManagerInstance.objSelectedHub.Address = strIPAddress.text;
                        /*for (int counter = 0; counter < mHubManagerInstance.objSelectedHub.HubAudioList.count; counter++) {
                            Hub *objAudio = [mHubManagerInstance.objSelectedHub.HubAudioList objectAtIndex:counter];
                            if ([objAudio.AudioId isEqualToString:mHubManagerInstance.objSelectedHub.AudioId]) {
                                [mHubManagerInstance.objSelectedHub.HubAudioList replaceObjectAtIndex:counter withObject:mHubManagerInstance.objSelectedHub];
                            }
                        }*/
                        [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                        [self viewWillAppear:false];
                    }];
                    self.okAction.enabled = NO;
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = UNKNOWN_IP;
                        textField.textColor = colorGray_646464;
                        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                        if (![mHubManagerInstance.objSelectedHub.Address isIPAddressEmpty]) {
                            [textField setText:mHubManagerInstance.objSelectedHub.Address];
                        }
                        textField.delegate = self;
                    }];
                    [alertController addAction:self.okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                break;
            }
            //MARK: HDA_AccessMHUBOS
            case HDA_AccessMHUBOS: {
                if ([SFSafariViewController class] != nil) {
                    // Use SFSafariViewController
                    safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:[[API mHUBInstallationURL] absoluteString]]];
                    safariVC.delegate = self;
                    [[AppDelegate appDelegate]showHudView:ShowMessage Message:HUB_CONNECTINGTOMHUBOS];
                    [self presentViewController:safariVC animated:YES completion:nil];
                } else {
                    NSURL *url = [NSURL URLWithString:[[API mHUBInstallationURL] absoluteString]];
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        if (!success) {
                            DDLogError(@"%@%@",@"Failed to open url:",[url description]);
                        }
                    }];
                }
                
                break;
            }
            //MARK: HDA_ManageSequences
           case HDA_ManageSequences: {
               DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
               objVC.selectedSetting = objSection;
               [self.navigationController pushViewController:objVC animated:YES];
               break;
           }
            //MARK: HDA_ManageUControlPacks
            case HDA_ManageUControlPacks: {
                if ([SFSafariViewController class] != nil) {
                    // Use SFSafariViewController
                    safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:[[API dashUControlAccessURL] absoluteString]]];
                    safariVC.delegate = self;
                    [[AppDelegate appDelegate]showHudView:ShowMessage Message:HUB_CONNECTINGTOMHUBOS];
                    [self presentViewController:safariVC animated:YES completion:nil];
                } else {
                    NSURL *url = [NSURL URLWithString:[[API dashUControlAccessURL] absoluteString]];
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        if (!success) {
                            DDLogError(@"%@%@",@"Failed to open url:",[url description]);
                        }
                    }];
                }
                
                break;
            }
            //MARK: HDA_ManageMOSSequence
            case HDA_ManageMOSSequence: {
                if ([SFSafariViewController class] != nil) {
                    // Use SFSafariViewController
                    safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:[[API dashSequenceAccessURL] absoluteString]]];
                    safariVC.delegate = self;
                    [[AppDelegate appDelegate]showHudView:ShowMessage Message:HUB_CONNECTINGTOMHUBOS];
                    [self presentViewController:safariVC animated:YES completion:nil];
                } else {
                    NSURL *url = [NSURL URLWithString:[[API dashSequenceAccessURL] absoluteString]];
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        if (!success) {
                            DDLogError(@"%@%@",@"Failed to open url:",[url description]);
                        }
                    }];
                }
                
                break;
            }
            //MARK: HDA_ManageLabels
            case HDA_ManageLabels: {
                SubSettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"SubSettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];

                break;
            }
            //MARK: HDA_ManageZonesLabels
            case HDA_ManageZonesLabels: {
                AddLabelsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"AddLabelsVC"];
                objVC.labelType = Display;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            //MARK: HDA_ManageSourceLabels
            case HDA_ManageSourceLabels: {
                AddLabelsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"AddLabelsVC"];
                objVC.labelType = Source;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            //MARK: HDA_Create_Cloud
            case HDA_Create_Cloud: {
                id dictUserdata = [Utility retrieveUserDefaults:kUserData];
                if ([dictUserdata isKindOfClass:[NSDictionary class]] && [[Utility checkNullForKey:kUsername Dictionary:dictUserdata] isNotEmpty]) {
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ALREADYLOGIN];
                } else {
                    BackupCloudVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"BackupRegistrationCloudVC"];
                    objVC.formType = Registration;
                    objVC.selectedSetting = objSection;
                    [self.navigationController pushViewController:objVC animated:YES];
                }
                break;
            }
            //MARK: HDA_Resync_Cloud
            case HDA_Resync_Cloud: {
                [self fetchBackUpFromCloud:objSection];
                break;
            }
            //MARK: HDA_Backup_Cloud
            case HDA_Backup_Cloud: {
                id dictUserdata = [Utility retrieveUserDefaults:kUserData];
                if ([dictUserdata isKindOfClass:[NSDictionary class]] && [[Utility checkNullForKey:kUsername Dictionary:dictUserdata] isNotEmpty]) {
                    // If user is already loggedin from the app then get credential from the UserDefauls and call for backup service.
                    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
                    NSMutableDictionary *dictParameterData = [[NSMutableDictionary alloc] initWithDictionary:dictUserdata];
                    [dictParameterData setObject:mHubManagerInstance.objSelectedHub.SerialNo forKey:kSerial_Number];
                    [dictParameterData setObject:[mHubManagerInstance.objSelectedHub dictionaryRepresentation] forKey:kData];
                    
                    [APIManager postCloudBackup:dictParameterData completion:^(APIResponse *objResponse) {
                        DDLogDebug(@"postCloudBackup objResponse == %@", objResponse);
                        if (objResponse.error == false) {
                            [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResponse.response];
                        } else {
                            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                        }
                    }];
                } else {
                    BackupCloudVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"BackupCloudVC"];
                    objVC.backupType = Post;
                    objVC.formType = Login;
                    objVC.selectedSetting = objSection;
                    [self.navigationController pushViewController:objVC animated:YES];
                }
                break;
            }
            //MARK: HDA_DisplaySetting
            case HDA_DisplaySetting: {
                DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                
                break;
            }
            //MARK: HDA_AdditionalCustomization
            case HDA_AdditionalCustomization: {
                SubSettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"SubSettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            //MARK: HDA_MenuSettings
            case HDA_MenuSettings: {
                DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            //MARK: HDA_SetAppQuickAction
            case HDA_SetAppQuickAction: {
                DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_update: {
                [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                
                //[AppDelegate appDelegate].systemType = HDA_ConnectToAnExistingMHUBSystem;
                
                NSMutableArray *testArr = [[NSMutableArray alloc]init];
                [testArr addObject:mHubManagerInstance.objSelectedHub];
                for (int counter = 0; counter < mHubManagerInstance.arrSlaveAudioDevice.count; counter++) {
                    Hub *objSlave = (Hub *)[mHubManagerInstance.arrSlaveAudioDevice objectAtIndex:counter];
                    [testArr addObject:objSlave];
                }
                DeviceListToUpdateVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DeviceListToUpdateVC"];
                objVC.arr_devices =  testArr;
                objVC.navigateFromType =  menu_update_inside;
                [self.navigationController pushViewController:objVC animated:YES];
                
//                [AppDelegate appDelegate].isSearchNetworkPopVC = false;
//                SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
//                objVC.isManuallyConnectNavigation =  true;
//                objVC.navigateFromType =  menu_update;
//                objVC.isOpenFromSettingsScreen =  true;
//                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_reset: {
                resetTab_Count = resetTab_Count+1;
                if(resetTab_Count >= [AppDelegate appDelegate].tapTimes)
                {
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
                    objVC.isManuallyConnectNavigation =  true;
                    objVC.navigateFromType =  menu_reset;
                    objVC.isOpenFromSettingsScreen =  true;
                    [self.navigationController pushViewController:objVC animated:YES];
                }
                
                break;
            }
            //MARK: HDA_RemoveUControl
            case HDA_RemoveUControl: {
                [self  resetUControlConfirmation];
                break;
            }
            //MARK: HDA_ButtonVibration
            case HDA_ButtonVibration: {
                DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_Appearance: {
                SubSettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"SubSettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_ManageSource: {
                DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_SendBugReport: {
                [[Buglife sharedBuglife]presentReporter ];
                break;
            }
            case HDA_AboutUCONTROL:
            {
                [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                AboutUcontrolVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"AboutUcontrolVC"];
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_Benchmark:
            {
                [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                BenchmarkDetailsViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"BenchmarkDetailsViewController"];
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_power:
            {
                
//                DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
//                objVC.selectedSetting = objSection;
//                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_Resync_MOS: {
                
                if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                    [self extracted];
                } else {
                    [APIManager resyncMHUBProData];
                }
                break;
            }
            case HDA_FindDevices:
            {
                [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
                objVC.isManuallyConnectNavigation =  true;
                [AppDelegate appDelegate].systemType = HDA_SetupANewMHUBSystem;
                objVC.navigateFromType =  menu_findDevices;
                objVC.isOpenFromSettingsScreen =  true;
                [self.navigationController pushViewController:objVC animated:NO];
                break;
            }
            case HDA_ManageZones: {
                DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_Theme: {
                DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_Background: {
                DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_ButtonBorder: {
                DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
                objVC.selectedSetting = objSection;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case HDA_CECSettings: {
                     DisplaySettingsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"DisplaySettingsVC"];
                                   objVC.selectedSetting = objSection;
                                   [self.navigationController pushViewController:objVC animated:YES];
                    break;
            }
            
            default:
                break;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)extracted {
    mHubManagerInstance.arrLeftPanelRearranged = [[NSMutableArray alloc]init];
    mHubManagerInstance.arrSlaveAudioDevice = [[NSMutableArray alloc]init];
    [APIManager getSystemDetails:mHubManagerInstance.objSelectedHub Stacked:mHubManagerInstance.isPairedDevice Slave:mHubManagerInstance.arrSlaveAudioDevice];
}


-(void) resetUControlConfirmation {
    @try {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(HUB_REMOVEUCONTROL_CONFIRMATION, nil)
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        alertController.view.tintColor = colorGray_646464;
        NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:HUB_REMOVEUCONTROL_CONFIRMATION];
        [strAttributedTitle addAttribute:NSFontAttributeName
                                   value:textFontLight13
                                   range:NSMakeRange(0, strAttributedTitle.length)];
        [alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
        
        UIAlertAction *resetToDefault = [UIAlertAction actionWithTitle:ALERT_BTN_TITLE_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
                
                [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
                if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
                    [SSDPManager disconnectSSDPmHub];
                }
                [mHubManagerInstance deletemHubManagerObjectData];
                // Wait 2 seconds while app is going background
                // [NSThread sleepForTimeInterval:2.0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self showNewMainStoryBoard];
                });
            });
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_NO, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:resetToDefault];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)showNewMainStoryBoard {
    @try {
        [AppDelegate appDelegate].flowType = HDA_SetupFlow;
        UIStoryboard *storyboard = mainStoryboard;
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        UIViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"NewSetupVC"];
        vc1.navigationItem.backBarButtonItem = customBackBarButton;

        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        window.rootViewController = navigationController;
        [window crossDissolveTransitionWithAnimations:nil AndCompletion:nil];
        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) fetchBackUpFromCloud:(SectionSetting*)objSection {
    id dictUserdata = [Utility retrieveUserDefaults:kUserData];
    if ([dictUserdata isKindOfClass:[NSDictionary class]] && [[Utility checkNullForKey:kUsername Dictionary:dictUserdata] isNotEmpty]) {
            // If user is already loggedin from the app then get credential from the UserDefauls and call to fetchBackup API.
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] initWithDictionary:[UserData getParameterDictionaryFromDictionary:dictUserdata]];
        
        [APIManager postCloudLogin:dictParameter completion:^(APIResponse *objResponse) {
            DDLogDebug(@"postCloudLogin objResponse == %@", objResponse);
            if (objResponse.error == false) {
                NSArray *arrData = [[NSArray alloc] initWithArray:objResponse.data];
                if (arrData.count > 1)
                    {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    CloudDeviceListVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"CloudDeviceListVC"];
                    objVC.arrData = [[NSMutableArray alloc] initWithArray:arrData];
                    objVC.dictParameter = [[NSMutableDictionary alloc] initWithDictionary:dictParameter];
                    [self.navigationController pushViewController:objVC animated:YES];
                    }
                else if (arrData.count == 1)
                    {
                    CloudData *objData = (CloudData *)[arrData firstObject];
                    [dictParameter setObject:objData.strSerialNo forKey:kSerial_Number];
                    
                    [APIManager fetchCloudBackup:dictParameter completion:^(APIResponse *objResponse) {
                        DDLogDebug(@"fetchCloudBackup objResponse == %@", objResponse);
                        if (objResponse.error) {
                            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                        } else {
                            Hub *objHub = (Hub *)objResponse.response;
                            for (OutputDevice *objOP in objHub.HubOutputData) {
                                if (objOP.Index == mHubManagerInstance.objSelectedOutputDevice.Index) {
                                    mHubManagerInstance.objSelectedOutputDevice = objOP;
                                }
                            }
                            for (InputDevice *objIP in objHub.HubInputData) {
                                if (objIP.Index == mHubManagerInstance.objSelectedInputDevice.Index) {
                                    mHubManagerInstance.objSelectedInputDevice = objIP;
                                    [ContinuityCommand saveCustomObject:[ContinuityCommand getDictionaryArray:objIP.arrContinuity] key:kSELECTEDCONTINUITYARRAY];
                                }
                            }
                            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        }
                    }];
                    }
            } else {
                [Utility deleteUserDefaults:kUserData];
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
            }
        }];
    } else {
        BackupCloudVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"BackupCloudVC"];
        objVC.backupType = Fetch;
        objVC.formType = Login;
        objVC.selectedSetting = objSection;
        [self.navigationController pushViewController:objVC animated:YES];
    }
}

#pragma mark - SFSafariViewController delegate methods
-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    // Load finished
    [[AppDelegate appDelegate]hideHudView:HideIndicator Message:@"Finished"];
}

-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    // Done button pressed
    if (mHubManagerInstance.objSelectedHub.Generation != mHub4KV3) {
        [[AppDelegate appDelegate] alertControllerReSyncUControlConfirmation];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.okAction setEnabled:(![finalString isIPAddressEmpty])];
    return YES;
}

@end
