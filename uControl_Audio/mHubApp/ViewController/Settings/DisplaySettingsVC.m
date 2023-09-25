//
//  DisplaySettingsVC.m
//  mHubApp
//
//  Created by Anshul Jain on 28/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "DisplaySettingsVC.h"
#import "CellSetting.h"

@interface DisplaySettingsVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate> {
    NSIndexPath *selectedTheme;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tblSettings;
@property (strong, nonatomic) NSMutableArray *arrSettings;
@property (strong, nonatomic) SectionSetting *selectedSection;



@end

@implementation DisplaySettingsVC

- (void)viewDidLoad {
    @try {
    [super viewDidLoad];
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    // Do any additional setup after loading the view.
    //    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:HUB_DISPLAYSETTINGS;
    
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:self.selectedSetting.Title];
    // self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:self.selectedSetting.Title];
    
    switch (self.selectedSetting.sectionType) {
        case HDA_Theme:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getDisplaySettingsArray_Theme]];
            break;
        case HDA_Background:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getDisplaySettingsArray]];
            break;
        case HDA_ButtonBorder:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getDisplaySettingsArray_ButtonBorder]];
            break;
        case HDA_MenuSettings:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMenuSettingsArray]];
            break;
        case HDA_ManageZones:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMenuSettingsArray_ForManageZone]];
            break;
        case HDA_ManageSource:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMenuSettingsArray_ForManageSource]];
            break;
        case HDA_ManageSequences:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getMenuSettingsArray_ForManageSequences]];
            break;
            
        case HDA_SetAppQuickAction:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getSetAppQuickActionArray]];
            break;
        case HDA_ButtonVibration:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getVibrationArray]];
            break;
        case HDA_CECSettings:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getCECSettingsArray]];
            break;
        case HDA_power:
            self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getPOWERONOFFArray]];
            break;
            
        default:
            break;
    }
    
    //self.arrSettings = [[NSMutableArray alloc] initWithArray:[SectionSetting getDisplaySettingArray]];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(IBAction)ClickOn_BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) viewWillAppear:(BOOL)animated {
    @try {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    ThemeColor *objColor = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColoursSetup];;
    self.view.backgroundColor = objColor.colorBackground;
    //    [self.navigationController.navigationBar setBackgroundColor:objColor.colorNavigationBar];
    //    [self.navigationController.navigationBar setBarTintColor:objColor.colorNavigationBar];
    //    [self.navigationController.navigationBar setTintColor:colorWhite_254254254];
    
    NSDictionary *dictTitleTextAttributes;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        dictTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:objColor.colorHeaderText, NSForegroundColorAttributeName,textFontLight20, NSFontAttributeName, nil];
    } else {
        dictTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:objColor.colorHeaderText, NSForegroundColorAttributeName,textFontLight30, NSFontAttributeName, nil];
    }
    [self.navigationController.navigationBar setTitleTextAttributes: dictTitleTextAttributes];
    
    [[AppDelegate appDelegate] setShouldRotate:NO];
    
    selectedTheme = [NSIndexPath indexPathForRow:objColor.themeType inSection:0];
    
    [self.tblSettings reloadData];
} @catch(NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)switchChanged:(UISwitch *)sender {
    
    //    switch (self.selectedSection.sectionType) {
    //        case  HDA_CECSettings:{
    if(sender.isOn)
    {
        [sender setOnTintColor:colorMiddleGray_868787];
        [sender setThumbTintColor:colorProPink];
    }else
    {
        [sender setTintColor:colorMiddleGray_868787];
        [sender setBackgroundColor:colorMiddleGray_868787];
        sender.layer.cornerRadius = sender.frame.size.height/2;
        [sender setThumbTintColor:colorWhite];
    }
    switch (sender.tag){
        case  0:
        {
            if(sender.isOn){
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FLAG_CecView"];
            }else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FLAG_CecView"];
            }
            break;
        }
        case  1:
        {
            if(sender.isOn){
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FLAG_CecUI"];
            }else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FLAG_CecUI"];
            }
            break;
        }
        case  2:
        {
            if(sender.isOn){
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FLAG_CecPower"];
            }else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FLAG_CecPower"];
            }
            
            break;
        }
        case  3:
        {
            if(sender.isOn){
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FLAG_CecVolume"];
            }else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FLAG_CecVolume"];
            }
            break;
        }
    }
    
    
    
    // break;
    //        }
    //    }
    //
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrSettings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // return tableViewHeaderHeight;
    
        SectionSetting *objSection = [self.arrSettings objectAtIndex:section];
    switch (objSection.sectionType) {
            //In case of cec settings, the menu should always be expandable.
        case HDA_ManageSource:
        {
            if (objSection.arrRow.count > 0 &&  objSection.Title != nil) {
                if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                    return heightTableViewRowWithPadding_SmallMobile;
                } else {
                    return heightTableViewRowWithPadding;
                }
            } else {
                return 0.0f;
            }
            break;
        }
        default:
        {
            return 0.0f;
            break;
        }
    }
        
   // return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderCellIdentifier = @"HeaderSetting";
    CellSetup *cellHeader = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    if (cellHeader == nil) {
        cellHeader = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    }
    SectionSetting *objSection = [self.arrSettings objectAtIndex:section];
    if(objSection.Title != nil){
//        cellHeader.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorBackground Frame:cellHeader.imgBackground.frame];
//        [cellHeader.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorTableCellBorder BorderWidth:1.0];
        cellHeader.lblCell.textColor = [AppDelegate appDelegate].themeColours.colorNormalText;
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cellHeader.lblCell setFont:textFontBold10];
        } else {
            [cellHeader.lblCell setFont:textFontBold13];
        }
    }
    else
    {
//        cellHeader.imgBackground.image = [[UIImage alloc]init];
//        [cellHeader.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorTableCellBorder BorderWidth:0.0];
        
        // cellHeader.lblCell.textColor = [AppDelegate appDelegate].themeColours.colorNormalText;
    }
    // objSection.isExpand = true;
    cellHeader.lblCell.text = [objSection.Title uppercaseString];
    [cellHeader.lblCell setTextAlignment:NSTextAlignmentLeft];
    cellHeader.tag = section;
    if (objSection.arrRow.count > 0) {
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(tapRecognizerHandler:)];
        tapRecognizer.delegate = self;
        [cellHeader addGestureRecognizer:tapRecognizer];
    }
    return cellHeader;
}

- (void)tapRecognizerHandler:(id)sender {
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    NSInteger intTag = [tapRecognizer.view tag];
    SectionSetting *objSection = [self.arrSettings objectAtIndex:intTag];
    switch (objSection.sectionType) {
            //In case of cec settings, the menu should always be expandable.
        case HDA_CECSettings:
        {
            objSection.isExpand = true;
            break;
        }
        default:
        {
            if (objSection.isExpand == false) {
                objSection.isExpand = true;
            } else {
                objSection.isExpand = false;
            }
            break;
        }
    }
    //objSection.isExpand = true;
    [self.arrSettings replaceObjectAtIndex:intTag withObject:objSection];
    [self.tblSettings reloadData];
}

-(UIView *) tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectZero];
    return viewFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionSetting *objSection = [self.arrSettings objectAtIndex:section];
    if(objSection.sectionType == HDA_CECSettings)
    {
        return 1;
    }
    else{
        if (objSection.isExpand == true) {
            return objSection.arrRow.count;
        } else {
            return 0;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        static NSString *CellIdentifier = @"CellSetting";
        
        CellSetting *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        [cell.border setBackgroundColor:colorGunGray_272726];
        SectionSetting *objSection = [self.arrSettings objectAtIndex:indexPath.section];
        RowSetting *objRow = [objSection.arrRow objectAtIndex:indexPath.row];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblCell setFont:textFontBold10];
        } else {
            [cell.lblCell setFont:textFontBold13];
        }
        
        cell.imgCellBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorNavigationBar Frame:cell.imgCellBackground.frame];
        [cell.imgCellBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorTableCellBorder BorderWidth:1.0];
        cell.lblCell.textColor = [AppDelegate appDelegate].themeColours.colorNormalText;
        //[cell.imgCell setTintColor:[AppDelegate appDelegate].themeColours.colorHeaderText];
        [cell.imgCell setTintColor:hexString_SkyBlueUtility];
        cell.lblCell.text = [objRow.strTitle uppercaseString];
        switch (objSection.sectionType) {
            case HDA_Theme: {
                if ([indexPath isEqual:selectedTheme]) {
                    UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.imgCell setImage:image];
                } else {
                    cell.imgCell.image = nil;
                }
                break;
            }
            case HDA_Background: {
                [cell.imgCell setImage:objRow.imgRow];
                break;
            }
            case HDA_ManageZones: {
                UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                [cell.imgCell setImage:image];
                break;
            }
            case HDA_ManageSequences: {
                UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                [cell.imgCell setImage:image];
                break;
            }
            case HDA_ManageQuickAction: {
                UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                [cell.imgCell setImage:image];
                break;
            }
            case HDA_ManageSource: {
                UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                [cell.imgCell setImage:image];
                break;
            }
            case HDA_ButtonBorder: {
                if (indexPath.row == 0 && [AppDelegate appDelegate].themeColours.isButtonBorder == true) {
                    UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.imgCell setImage:image];
                } else if (indexPath.row == 1 && [AppDelegate appDelegate].themeColours.isButtonBorder == false) {
                    UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.imgCell setImage:image];
                } else {
                    cell.imgCell.image = nil;
                }
                break;
            }
            case HDA_ButtonVibration: {
                if (indexPath.row == 0 && [AppDelegate appDelegate].themeColours.isButtonVibration == true) {
                    UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.imgCell setImage:image];
                } else if (indexPath.row == 1 && [AppDelegate appDelegate].themeColours.isButtonVibration == false) {
                    UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.imgCell setImage:image];
                } else {
                    cell.imgCell.image = nil;
                }
                break;
            }
            case HDA_power: {
                if (indexPath.row == 0 && [AppDelegate appDelegate].themeColours.isButtonVibration == true) {
                    UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.imgCell setImage:image];
                } else if (indexPath.row == 1 && [AppDelegate appDelegate].themeColours.isButtonVibration == false) {
                    UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.imgCell setImage:image];
                } else {
                    cell.imgCell.image = nil;
                }
                break;
            }
            case HDA_CECSettings: {
                [cell.imgCell setHidden:true];
                [cell.onOffSwitch setHidden:false];
                cell.lblCell.text = [objSection.Title uppercaseString];
                cell.onOffSwitch.tag = indexPath.section;
                switch (indexPath.section) {
                    case 0:{
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecView"]) {
                            [cell.onOffSwitch setOn:true];
                            [cell.onOffSwitch setOnTintColor:colorMiddleGray_868787];
                            [cell.onOffSwitch setThumbTintColor:colorProPink];
                        }else{
                            [cell.onOffSwitch setOn:false];
                            [cell.onOffSwitch setTintColor:colorMiddleGray_868787];
                            [cell.onOffSwitch setBackgroundColor:colorMiddleGray_868787];
                            cell.onOffSwitch.layer.cornerRadius = cell.onOffSwitch.frame.size.height/2;
                            [cell.onOffSwitch setThumbTintColor:colorWhite];
                        }
                        //Below code is for two rows enable & disable
                        //                    if (indexPath.row == 0) {
                        //                        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecView"]) {
                        //                            UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                        //                            [cell.imgCell setImage:image];
                        //                        }
                        //                        else
                        //                            cell.imgCell.image = nil;
                        //                    }
                        //                    if (indexPath.row == 1) {
                        //                        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecView"])
                        //                            cell.imgCell.image = nil;
                        //                        else {
                        //                            UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                        //                            [cell.imgCell setImage:image];
                        //                        }
                        //                    }
                        break;
                    }
                    case 1:{
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecUI"]) {
                            [cell.onOffSwitch setOn:true];
                            [cell.onOffSwitch setOnTintColor:colorMiddleGray_868787];
                            [cell.onOffSwitch setThumbTintColor:colorProPink];
                        }else{
                            [cell.onOffSwitch setOn:false];
                            [cell.onOffSwitch setTintColor:colorMiddleGray_868787];
                            [cell.onOffSwitch setBackgroundColor:colorMiddleGray_868787];
                            cell.onOffSwitch.layer.cornerRadius = cell.onOffSwitch.frame.size.height/2;
                            [cell.onOffSwitch setThumbTintColor:colorWhite];
                        }
                        //Below code is for two rows enable & disable
                        //                    if (indexPath.row == 0) {
                        //                        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecUI"]) {
                        //                            UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                        //                            [cell.imgCell setImage:image];
                        //                        }
                        //                        else
                        //                            cell.imgCell.image = nil;
                        //                    }
                        //                    if (indexPath.row == 1) {
                        //                        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecUI"])
                        //                            cell.imgCell.image = nil;
                        //                        else {
                        //                            UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                        //                            [cell.imgCell setImage:image];
                        //                        }
                        //                    }
                        break;
                    }
                    case 2:{
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecPower"]) {
                            [cell.onOffSwitch setOn:true];
                            [cell.onOffSwitch setOnTintColor:colorMiddleGray_868787];
                            [cell.onOffSwitch setThumbTintColor:colorProPink];
                        }else{
                            [cell.onOffSwitch setOn:false];
                            [cell.onOffSwitch setTintColor:colorMiddleGray_868787];
                            [cell.onOffSwitch setBackgroundColor:colorMiddleGray_868787];
                            cell.onOffSwitch.layer.cornerRadius = cell.onOffSwitch.frame.size.height/2;
                            [cell.onOffSwitch setThumbTintColor:colorWhite];
                        }
                        //Below code is for two rows enable & disable
                        /*
                         if (indexPath.row == 0) {
                         if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecPower"]) {
                         UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                         [cell.imgCell setImage:image];
                         }
                         else
                         cell.imgCell.image = nil;
                         }
                         if (indexPath.row == 1) {
                         if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecPower"])
                         cell.imgCell.image = nil;
                         else {
                         UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                         [cell.imgCell setImage:image];
                         }
                         }
                         */
                        break;
                    }
                    case 3:{
                        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecVolume"]) {
                            [cell.onOffSwitch setOn:true];
                            [cell.onOffSwitch setOnTintColor:colorMiddleGray_868787];
                            [cell.onOffSwitch setThumbTintColor:colorProPink];
                        }else{
                            [cell.onOffSwitch setOn:false];
                            [cell.onOffSwitch setTintColor:colorMiddleGray_868787];
                            [cell.onOffSwitch setBackgroundColor:colorMiddleGray_868787];
                            cell.onOffSwitch.layer.cornerRadius = cell.onOffSwitch.frame.size.height/2;
                            [cell.onOffSwitch setThumbTintColor:colorWhite];
                        }
                        //Below code is for two rows enable & disable
                        /*
                         if (indexPath.row == 0) {
                         if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecVolume"]) {
                         UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                         [cell.imgCell setImage:image];
                         }
                         else
                         cell.imgCell.image = nil;
                         }
                         if (indexPath.row == 1) {
                         if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecVolume"])
                         cell.imgCell.image = nil;
                         else {
                         UIImage *image = [objRow.imgRow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                         [cell.imgCell setImage:image];
                         }
                         }
                         */
                        break;
                    }
                }
                break;
            }
        }
        if ([objRow.imgRow isEqual:kImageCheckMark]) {
            [cell.lblCell setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
        } else {
            [cell.lblCell setTextColor:colorMiddleGray_868787];
        }
        cell.lblCell.textAlignment = NSTextAlignmentLeft;
        return cell;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        SectionSetting *objSection = [self.arrSettings objectAtIndex:indexPath.section];
        self.selectedSection = objSection;
        switch (objSection.sectionType) {
            case HDA_Background: {
                [self getImagePicker:indexPath];
                break;
            }
                
            case HDA_Theme: {
                selectedTheme = indexPath;
                ThemeColor *objTheme = [AppDelegate appDelegate].themeColours;
                switch (indexPath.row) {
                    case Dark: {
                        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                        objTheme = [[ThemeColor alloc] initWithThemeColor:[ThemeColor themeColorData:Dark]];
                        break;
                    }
                    case Light: {
                        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                        objTheme = [[ThemeColor alloc] initWithThemeColor:[ThemeColor themeColorData:Light]];
                        break;
                    }
                    default:
                        break;
                }
                [AppDelegate appDelegate].themeColours = [[ThemeColor alloc] initWithThemeColor:objTheme];
                [ThemeColor saveCustomObject:objTheme key:kCOLORTHEMEOBJECT];
                //DDLogDebug(@"ThemeColor == %@", objTheme);
                //DDLogDebug(@"ThemeColor Dict == %@", dictTheme);
                
                [self reloadSubViews];
                break;
            }
            case HDA_ManageZones: {
                RowSetting *objRow = objSection.arrRow[indexPath.row];
                if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                    Zone *objOPList = mHubManagerInstance.objSelectedHub.HubZoneData[indexPath.row];
                    if ([objRow.imgRow isEqual:kImageCheckMark]) {
                        objOPList.isDeleted = true;
                    } else {
                        objOPList.isDeleted = false;
                    }
                    [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:indexPath.row withObject:objOPList];
                    RowSetting *objRowSeq = [RowSetting initWithTitle:objRow.strTitle Image:objOPList.isDeleted ? nil : kImageCheckMark];
                    [objSection.arrRow replaceObjectAtIndex:indexPath.row withObject:objRowSeq];
                    [self.arrSettings replaceObjectAtIndex:indexPath.section withObject:objSection];
                    [mHubManagerInstance updateLeftPanelDataV2];
                } else {
                    OutputDevice *objOPList = mHubManagerInstance.objSelectedHub.HubOutputData[indexPath.row];
                    if ([objRow.imgRow isEqual:kImageCheckMark]) {
                        objOPList.isDeleted = true;
                    } else {
                        objOPList.isDeleted = false;
                    }
                    [mHubManagerInstance.objSelectedHub.HubOutputData replaceObjectAtIndex:indexPath.row withObject:objOPList];
                    RowSetting *objRowSeq = [RowSetting initWithTitle:objRow.strTitle Image:objOPList.isDeleted ? nil : kImageCheckMark];
                    [objSection.arrRow replaceObjectAtIndex:indexPath.row withObject:objRowSeq];
                    [self.arrSettings replaceObjectAtIndex:indexPath.section withObject:objSection];
                    [mHubManagerInstance updateLeftPanelData];
                }
                [self reloadSubViews];
                break;
            }
                
            case HDA_ManageSequences: {
                RowSetting *objRow = objSection.arrRow[indexPath.row];
                
                Sequence *objSeqList = mHubManagerInstance.objSelectedHub.HubSequenceList[indexPath.row];
                if ([objRow.imgRow isEqual:kImageCheckMark]) {
                    objSeqList.isDeleted = true;
                } else {
                    objSeqList.isDeleted = false;
                }
                [mHubManagerInstance.objSelectedHub.HubSequenceList replaceObjectAtIndex:indexPath.row withObject:objSeqList];
                
                RowSetting *objRowSeq = [RowSetting initWithTitle:objRow.strTitle Image:objSeqList.isDeleted ? nil : kImageCheckMark RowInfo:objSeqList];
                [objSection.arrRow replaceObjectAtIndex:indexPath.row withObject:objRowSeq];
                [self.arrSettings replaceObjectAtIndex:indexPath.section withObject:objSection];
                
                if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                    [mHubManagerInstance updateLeftPanelDataV2];
                } else {
                    [mHubManagerInstance updateLeftPanelData];
                }
                
                [self reloadSubViews];
                break;
            }
                
            case HDA_ManageQuickAction: {
                RowSetting *objRow = objSection.arrRow[indexPath.row];
                if ([objRow.imgRow isNotEmpty]) {
                    RowSetting *objRowSeq = [RowSetting initWithTitle:objRow.strTitle Image:nil RowInfo:objRow.rowInfo];
                    [objSection.arrRow replaceObjectAtIndex:indexPath.row withObject:objRowSeq];
                    [self.arrSettings replaceObjectAtIndex:indexPath.section withObject:objSection];
                    if ([objRow.rowInfo isKindOfClass:[Sequence class]]) {
                        [mHubManagerInstance removeActionToShortCutItems:(Sequence *)objRow.rowInfo];
                    }
                } else {
                    RowSetting *objRowSeq = [RowSetting initWithTitle:objRow.strTitle Image:kImageCheckMark RowInfo:objRow.rowInfo];
                    [objSection.arrRow replaceObjectAtIndex:indexPath.row withObject:objRowSeq];
                    [self.arrSettings replaceObjectAtIndex:indexPath.section withObject:objSection];
                    if ([objRow.rowInfo isKindOfClass:[Sequence class]]) {
                        [mHubManagerInstance addSequenceToQuickActions:(Sequence *)objRow.rowInfo];
                    }
                }
                [self reloadSubViews];
                break;
            }
                
                
            case HDA_ManageSource: {
                RowSetting *objRow = objSection.arrRow[indexPath.row];
                if(indexPath.section == 0){
                    InputDevice *objIPList = mHubManagerInstance.objSelectedHub.HubInputData[indexPath.row];
                    if ([objRow.imgRow isEqual:kImageCheckMark]) {
                        objIPList.isDeleted = false;
                    } else {
                        objIPList.isDeleted = true;
                    }
                    [mHubManagerInstance.objSelectedHub.HubInputData replaceObjectAtIndex:indexPath.row withObject:objIPList];
                    RowSetting *objRowSeq = [RowSetting initWithTitle:objRow.strTitle Image:!objIPList.isDeleted ? nil : kImageCheckMark];
                    [objSection.arrRow replaceObjectAtIndex:indexPath.row withObject:objRowSeq];
                    [self.arrSettings replaceObjectAtIndex:indexPath.section withObject:objSection];
                    [mHubManagerInstance updateSourceData];
                    [self reloadSubViews];
                }
                else
                {
                    NSPredicate *predicate;
                    NSLog(@"objRow Master %@ ",objRow.strTitle);
                    predicate = [NSPredicate predicateWithFormat:@"CreatedName == %@", objRow.strTitle];
                    if(indexPath.section == 2 && mHubManagerInstance.arrSlaveAudioDevice.count > 0)
                    {
                        predicate = [NSPredicate predicateWithFormat:@"CreatedName == %@ AND UnitId == %@", objRow.strTitle,@"S1"];
                    }
                    if(indexPath.section == 3  && mHubManagerInstance.arrSlaveAudioDevice.count > 1)
                    {
                        predicate = [NSPredicate predicateWithFormat:@"CreatedName == %@ AND UnitId == %@", objRow.strTitle,@"S2"];
                    }
                    if(indexPath.section == 4 && mHubManagerInstance.arrSlaveAudioDevice.count > 2)
                    {
                        predicate = [NSPredicate predicateWithFormat:@"CreatedName == %@ AND UnitId == %@", objRow.strTitle,@"S3"];
                    }
                    NSArray *arrSourceInput = [mHubManagerInstance.arrAudioSourceDeviceManaged  filteredArrayUsingPredicate:predicate];
                    if(arrSourceInput.count == 0 )
                    {
                        predicate = [NSPredicate predicateWithFormat:@"CreatedName == %@", objRow.strTitle];
                        arrSourceInput = [mHubManagerInstance.arrAudioSourceDeviceManaged  filteredArrayUsingPredicate:predicate];
                    }
                    InputDevice *objIPList = (InputDevice *)[arrSourceInput objectAtIndex:0];
                    NSLog(@"Obje Master %@ %ld ",objIPList.CreatedName,[mHubManagerInstance.arrAudioSourceDeviceManaged indexOfObject:objIPList]);
                    if ([objRow.imgRow isEqual:kImageCheckMark]) {
                        objIPList.isDeleted = false;
                    } else {
                        objIPList.isDeleted = true;
                    }
                    [mHubManagerInstance.arrAudioSourceDeviceManaged replaceObjectAtIndex:[mHubManagerInstance.arrAudioSourceDeviceManaged indexOfObject:objIPList] withObject:objIPList];
                    
                    RowSetting *objRowSeq = [RowSetting initWithTitle:objRow.strTitle Image:!objIPList.isDeleted ? nil : kImageCheckMark];
                    [objSection.arrRow replaceObjectAtIndex:indexPath.row withObject:objRowSeq];
                    [self.arrSettings replaceObjectAtIndex:indexPath.section withObject:objSection];
                    [self reloadSubViews];
                    
                    
                    
                }
                
                break;
            }
                
            case HDA_ButtonBorder: {
                switch (indexPath.row) {
                    case 0: {
                        [AppDelegate appDelegate].themeColours.isButtonBorder = true;
                        break;
                    }
                    case 1: {
                        [AppDelegate appDelegate].themeColours.isButtonBorder = false;
                        break;
                    }
                    default:
                        break;
                }
                [ThemeColor saveCustomObject:[AppDelegate appDelegate].themeColours key:kCOLORTHEMEOBJECT];
                
                [self reloadSubViews];
                
                break;
            }
                
            case HDA_ButtonVibration: {
                switch (indexPath.row) {
                    case 0: {
                        [AppDelegate appDelegate].themeColours.isButtonVibration = true;
                        break;
                    }
                    case 1: {
                        [AppDelegate appDelegate].themeColours.isButtonVibration = false;
                        break;
                    }
                    default:
                        break;
                }
                [ThemeColor saveCustomObject:[AppDelegate appDelegate].themeColours key:kCOLORTHEMEOBJECT];
                [self reloadSubViews];
                break;
            }
            case HDA_power: {
                switch (indexPath.row) {
                    case 0: {
                        [AppDelegate appDelegate].themeColours.isButtonVibration = true;
                        break;
                    }
                    case 1: {
                        [AppDelegate appDelegate].themeColours.isButtonVibration = false;
                        break;
                    }
                    default:
                        break;
                }
                [ThemeColor saveCustomObject:[AppDelegate appDelegate].themeColours key:kCOLORTHEMEOBJECT];
                [self reloadSubViews];
                break;
            }
            case HDA_CECSettings:
            {
                switch (indexPath.section) {
                    case 0:{
                        switch (indexPath.row) {
                            case 0: {
                                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FLAG_CecView"];
                                break;
                            }
                            case 1: {
                                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FLAG_CecView"];
                                break;
                            }
                        }
                        [self reloadSubViews];
                        break;
                    }
                    case 1:{
                        switch (indexPath.row) {
                            case 0: {
                                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FLAG_CecUI"];
                                break;
                            }
                            case 1: {
                                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FLAG_CecUI"];
                                break;
                            }
                        }
                        [self reloadSubViews];
                        break;
                    }
                    case 2:{
                        switch (indexPath.row) {
                            case 0: {
                                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FLAG_CecPower"];
                                break;
                            }
                            case 1: {
                                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FLAG_CecPower"];
                                break;
                            }
                        }
                        [self reloadSubViews];
                        break;
                    }
                    case 3:{
                        switch (indexPath.row) {
                            case 0: {
                                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FLAG_CecVolume"];;
                                break;
                            }
                            case 1: {
                                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FLAG_CecVolume"];
                                break;
                            }
                        }
                        [self reloadSubViews];
                        break;
                    }
                }
            }
                
            default:
                break;
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) reloadSubViews {
    [self viewWillAppear:NO];
    [self.tblSettings reloadData];
    [APIManager reloadDisplaySubView];
    [APIManager reloadSourceSubView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadSourceSwitch_ViewWillAppear object:self];
}

#pragma mark Image Picker Delegate
-(void) getImagePicker:(NSIndexPath*)selectedIndexpath {
    @try {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Upload Image", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        alertController.view.tintColor = colorGray_646464;
        NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Upload Image"];
        [strAttributedTitle addAttribute:NSFontAttributeName value:textFontLight13 range:NSMakeRange(0, strAttributedTitle.length)];
        [alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
        
        UIAlertAction *resetToDefault = [UIAlertAction actionWithTitle:@"Reset To Default" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImage *imgBlur = nil;
            // Replace object in global object for image background delete
            if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                Zone *objZone = [mHubManagerInstance.objSelectedHub.HubZoneData objectAtIndex:selectedIndexpath.row];
                objZone.imgControlGroupBG = imgBlur;
                
                [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:selectedIndexpath.row withObject:objZone];
                
                if ([mHubManagerInstance.objSelectedZone.zone_id isEqualToString:objZone.zone_id]) {
                    mHubManagerInstance.objSelectedZone = objZone;
                }
                
                // replace object in local display data
                SectionSetting *objSection = [self.arrSettings objectAtIndex:selectedIndexpath.section];
                RowSetting *objZoneReplace = [RowSetting initWithTitle:objZone.zone_label Image:objZone.imgControlGroupBG];
                [objSection.arrRow replaceObjectAtIndex:selectedIndexpath.row withObject:objZoneReplace];
                
            } else {
                OutputDevice *objOutput = [mHubManagerInstance.objSelectedHub.HubOutputData objectAtIndex:selectedIndexpath.row];
                objOutput.imgControlGroup = imgBlur;
                
                [mHubManagerInstance.objSelectedHub.HubOutputData replaceObjectAtIndex:selectedIndexpath.row withObject:objOutput];
                
                if (mHubManagerInstance.objSelectedOutputDevice.Index == objOutput.Index) {
                    mHubManagerInstance.objSelectedOutputDevice = objOutput;
                }
                
                // replace object in local display data
                SectionSetting *objSection = [self.arrSettings objectAtIndex:selectedIndexpath.section];
                RowSetting *objOutputReplace = [RowSetting initWithTitle:objOutput.CreatedName Image:objOutput.imgControlGroup];
                [objSection.arrRow replaceObjectAtIndex:selectedIndexpath.row withObject:objOutputReplace];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self viewWillAppear:NO];
                [self.tblSettings reloadData];
            });
        }];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        [picker setDelegate:self];
        //[picker setAllowsEditing:YES];
        [picker.view setTag:selectedIndexpath.row];
        
        UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"From Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
            });
        }];
        
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Take through Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:nil];
                });
                
            } else {
                if (![self isCameraAvailable]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:@"Device has no camera!"];
                    });
                }
            }
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_CANCEL, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:resetToDefault];
        [alertController addAction:photoLibrary];
        [alertController addAction:camera];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        NSInteger intTag = picker.view.tag;
        UIImageView *imgViewBlur = [[UIImageView alloc] initWithImage:image];
        [imgViewBlur setImageToBlur:imgViewBlur.image
                         blurRadius:100.0
                    completionBlock:^(){
            UIImage *imgBlur = [Utility resizeImage:imgViewBlur.image];
            if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                Zone *objZone = [mHubManagerInstance.objSelectedHub.HubZoneData objectAtIndex:intTag];
                objZone.imgControlGroupBG = imgBlur;
                [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:intTag withObject:objZone];
                
                if ([mHubManagerInstance.objSelectedZone.zone_id isEqualToString:objZone.zone_id]) {
                    mHubManagerInstance.objSelectedZone = objZone;
                }
                // replace object in local display data
                SectionSetting *objSection = [self.arrSettings objectAtIndex:0];
                RowSetting *objZoneReplace = [RowSetting initWithTitle:objZone.zone_label Image:objZone.imgControlGroupBG];
                [objSection.arrRow replaceObjectAtIndex:intTag withObject:objZoneReplace];
                
                [Utility saveImageInDocumentDirectory:objZone.imgControlGroupBG ZoneId:objZone.zone_id];
                
            } else {
                OutputDevice *objOutput = [mHubManagerInstance.objSelectedHub.HubOutputData objectAtIndex:intTag];
                objOutput.imgControlGroup = imgBlur;
                [mHubManagerInstance.objSelectedHub.HubOutputData replaceObjectAtIndex:intTag withObject:objOutput];
                
                if (mHubManagerInstance.objSelectedOutputDevice.Index == objOutput.Index) {
                    mHubManagerInstance.objSelectedOutputDevice = objOutput;
                }
                
                // replace object in local display data
                SectionSetting *objSection = [self.arrSettings objectAtIndex:0];
                RowSetting *objOutputReplace = [RowSetting initWithTitle:objOutput.CreatedName Image:objOutput.imgControlGroup];
                [objSection.arrRow replaceObjectAtIndex:intTag withObject:objOutputReplace];
                
                [Utility saveImageInDocumentDirectory:objOutput.imgControlGroup SourceIndex:intTag];
                
            }
            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self viewWillAppear:NO];
                [self.tblSettings reloadData];
                [picker dismissViewControllerAnimated:YES completion:nil];
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            });
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType) paramSourceType
{
    __block BOOL result = NO;
    
    if ([paramMediaType length] == 0){
        return NO;
    }
    
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) doesCameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
