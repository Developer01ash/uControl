//
//  HubDevicesListViewController.m
//  mHubApp
//
//  Created by Rave on 17/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "HubDevicesListViewController.h"
#import "CellHeaderImage.h"
#import "CellSetupDevice.h"
#import "SetupConfirmationVC.h"
#import "WarningMessageVC.h"
#import "RestoreHubViewController.h"
#import "UpdateHubViewController.h"
#import "SetAPModeVC.h"
@interface HubDevicesListViewController ()
{
    NSIndexPath *selectedIndexPath;
}
@end

@implementation HubDevicesListViewController

- (void)viewDidLoad {
     @try {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
         self.navigationItem.hidesBackButton = true;
   // self.navigationItem.backBarButtonItem = customBackBarButton;
         if ([AppDelegate appDelegate].deviceType == mobileSmall) {
             [self.lbl_deviceFound setFont:textFontBold12];
         } else {
             [self.lbl_deviceFound setFont:textFontBold16];
         }
         if(self.navigateFromType == menu_update){
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_SYSTEM];
         }
    else if (self.navigateFromType == menu_reset){
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_RESET_SYSTEM];
    }
    else if (self.navigateFromType == menu_findDevices){
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_AVAILABLE_SYSTEMS];
        [self.btnContinue setHidden:true];
    }
         
    else
    {
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_AVAILABLE_SYSTEMS];
        [self.btnContinue setHidden:false];
    }
    [self.btnContinue.titleLabel setText:[ALERT_BTN_TITLE_CONTINUE uppercaseString]];
    
    //August2020: This screen is comman for all the views like reset mhub, update mhub or find devices. So This condtion is written here to only allowed or find WIFI Devices.
    if(self.navigateFromType == menu_Wifi){
    //August2020: Below array defined because it'll only contain Wifi devices in list and only wifi devices will be shown with help of this array. arrSearchData contains all mhubs details and below array will contain only wifi mhubs. and next it'll be assigned back to arrSearchData after filtering with wifi devices.
    self.arrSearchDataClass = [[NSMutableArray alloc]init];
    for (SearchData *objData in self.arrSearchData) {
        //If mhub units are Wifi, then will appear on screen otherwise
       if (objData.modelType == HDA_MHUBZP5 || objData.modelType == HDA_MHUBZPMINI || objData.modelType == HDA_MHUBU41140) {
           if([objData.arrItems isNotEmpty])
           {
               [self.arrSearchDataClass addObject:objData];
           }
//           for (Hub *objHub in objData.arrItems) {
//               if(objHub.Generation == mHub411 || objHub.Generation == mHubZP ){
//
//               }
//               else
//                   {
//                   [objData.arrItems removeAllObjects];
//                   }
//           }
       }
       }
   //[self.arrSearchData removeAllObjects];
        if([self.arrSearchDataClass isNotEmpty]){
            self.arrSearchData = self.arrSearchDataClass;
//            NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:self.arrSearchData];
//            self.arrSearchData = [orderedSet array].mutableCopy;
               [self.tblSearch reloadData];
        }
        else
        {
            //August2020: It should go back to wifi setup screen.
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[WifiSubMenuVC class]]) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:HUB_NO_MHUB_WIFI_FOUND];
                    [self.navigationController popToViewController:vc animated:false];
                }
            }
        }
    
   
    }
         
         } @catch (NSException *exception) {
             [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
         }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrSearchData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SearchData *objData = [self.arrSearchData objectAtIndex:section];
    NSArray *arrRow = objData.arrItems;
//    for(int i = 0 ; i < [arrRow count];i++)
//    {
//        Hub *objHub = [arrRow objectAtIndex:i];
//
//        //NSLog(@"audio name %@",objHub.Address);
//    }
    return [arrRow count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SearchData *objData = [self.arrSearchData objectAtIndex:section];
//    if ([objData.arrItems count] > 0) {
//        return objData.sectionHeight;
//    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderCellIdentifier = @"CellHeaderImage";
    SearchData *objData = [self.arrSearchData objectAtIndex:section];
    CellHeaderImage *cellHeader = [self.tblSearch dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    if (cellHeader == nil) {
        cellHeader = [self.tblSearch dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    }
    [cellHeader.imgCell setTintColor:[AppDelegate appDelegate].themeColoursSetup.themeType == Dark ? colorWhite : colorBlack];
    cellHeader.imgCell.image = objData.imgSection;
    if (isDeviceSelected == true) {
        if (selectedDeviceIndexpath.section == section) {
            [cellHeader.contentView setAlpha:ALPHA_ENABLE];
        } else {
            [cellHeader.contentView setAlpha:ALPHA_DISABLE];
        }
    } else {
        [cellHeader.contentView setAlpha:ALPHA_ENABLE];
    }
    return cellHeader;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        CellSetupDevice *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
        }
        UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        [cell.imgCheckMark setImage:image];
        [cell.imgCheckMark setTintColor:colorGreenCheck];
        if(selectedIndexPath == indexPath)
        {
            [cell.imgCheckMark setHidden:false];
        }
        else
        {
            [cell.imgCheckMark setHidden:true];
        }
        // cell.imgCellBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColoursSetup.colorBackground Frame:cell.imgCellBackground.frame];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblAddress setFont:textFontRegular12];
            [cell.lblCell setFont:textFontBold12];
        } else {
            [cell.lblAddress setFont:textFontRegular16];
            [cell.lblCell setFont:textFontBold16];
        }
        SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
        Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
        NSMutableString *title;
        if (self.navigateFromType ==  menu_findDevices ) {
            [cell.imgCheckMark setHidden:true];
            title = [[NSMutableString alloc] initWithString:@""];
        }
        else if(self.navigateFromType ==  menu_update)
        {
            title = [[NSMutableString alloc] initWithString:@""];
            //title = [[NSMutableString alloc] initWithString:@"UPDATE"];
        }
        else if(self.navigateFromType == menu_Wifi)// This condition is to show only Wifi devices list. like 411, ZP
        {
            title = [[NSMutableString alloc] initWithString:@""];
        }
        else{
            title = [[NSMutableString alloc] initWithString:@""];
            //title = [[NSMutableString alloc] initWithString:@"UPDATE"];
        }
        
        if ([objData.arrItems count] > 1) {
            NSInteger intCount = indexPath.row+1;
            [title appendString:[NSString stringWithFormat:@"%@ #%ld", objHub.Official_Name, (long)intCount]];
        } else {
            [title appendString:[NSString stringWithFormat:@"%@", objHub.Official_Name]];
        }
        
        if (![objHub.Address isIPAddressEmpty]) {
            cell.lblAddress.text = [NSString stringWithFormat:@"%@", objHub.Address];
           // [title appendString:[NSString stringWithFormat:@"\n(%@)", objHub.Address]];
        }
        cell.lblCell.text = [title uppercaseString];
        
        
        
        if (self.setupLevel == HDA_SetupLevelPrimary) {
            if (isDeviceSelected == true) {
                if ([indexPath isEqual:selectedDeviceIndexpath]) {
                    UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.imgCell setImage:image];
                    [cell setUserInteractionEnabled:true];
                    [cell.contentView setAlpha:ALPHA_ENABLE];
                } else {
                    cell.imgCell.image = nil;
                    [cell setUserInteractionEnabled:false];
                    [cell.contentView setAlpha:ALPHA_DISABLE];
                }
            } else {
                cell.imgCell.image = nil;
                [cell setUserInteractionEnabled:true];
                [cell.contentView setAlpha:ALPHA_ENABLE];
            }
        } else {
            // if (isDeviceSelected == true) {
            if ([arrSelectedDeviceIndexPath containsObject:indexPath]) {
                UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                [cell.imgCell setImage:image];
                [cell setUserInteractionEnabled:true];
                [cell.contentView setAlpha:ALPHA_ENABLE];
            } else {
                cell.imgCell.image = nil;
                [cell setUserInteractionEnabled:true];
                [cell.contentView setAlpha:ALPHA_ENABLE];
            }
        }
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        selectedIndexPath = indexPath;
        CellSetupDevice *cell = [self.tblSearch cellForRowAtIndexPath:indexPath];
        [cell.imgCheckMark setHidden:false];
        if (self.navigateFromType ==  menu_findDevices ) {
            [cell.imgCheckMark setHidden:true];
        }
        [self.tblSearch reloadData];
        return;
        SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
        Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
        if(_navigateFromType == menu_reset)
        {
        RestoreHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RestoreHubViewController"];
        objVC.objSelectedMHubDevice = objHub;
        [self.navigationController pushViewController:objVC animated:YES];
        }
        else if(_navigateFromType ==  menu_update)
        {
            UpdateHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateHubViewController"];
           // objVC.arrSearchData = self.arrSearchData;
            objVC.objSelectedMHubDevice = objHub;
            objVC.navigateFromType = _navigateFromType;
            [self.navigationController pushViewController:objVC animated:YES];
        }
        else if(_navigateFromType ==  menu_autoConnect_gotoSetupConfirmation)
        {
            [self navigateToSetupConfirmationScreen:objHub Stacked:false Slave:[[NSMutableArray alloc]init]];
            // [self deviceSetUpStandalone_TableIndexpath:indexPath];
        }
        else if(_navigateFromType == menu_Wifi)
        {
            SetAPModeVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"SetAPModeVC"];
            objVC.objSelectedDevice = objHub;
            [self.navigationController pushViewController:objVC animated:NO];

        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(IBAction)button_continue:(CustomButton *)sender
{
    @try {
        SearchData *objData = [self.arrSearchData objectAtIndex:selectedIndexPath.section];
        Hub *objHub = [objData.arrItems objectAtIndex:selectedIndexPath.row];
        if(_navigateFromType == menu_reset)
        {
        RestoreHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RestoreHubViewController"];
        objVC.objSelectedMHubDevice = objHub;
        [self.navigationController pushViewController:objVC animated:YES];
        }
        else if(_navigateFromType ==  menu_update)
        {
            UpdateHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateHubViewController"];
           // objVC.arrSearchData = self.arrSearchData;
            objVC.objSelectedMHubDevice = objHub;
            objVC.navigateFromType = _navigateFromType;
            [self.navigationController pushViewController:objVC animated:YES];
        }
        else if(_navigateFromType ==  menu_autoConnect_gotoSetupConfirmation)
        {
            [self navigateToSetupConfirmationScreen:objHub Stacked:false Slave:[[NSMutableArray alloc]init]];
            // [self deviceSetUpStandalone_TableIndexpath:indexPath];
        }
        else if(_navigateFromType == menu_Wifi)
        {
            SetAPModeVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"SetAPModeVC"];
            objVC.objSelectedDevice = objHub;
            [self.navigationController pushViewController:objVC animated:NO];

        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)callSetupAPModeAPI:(Hub*)objHub{
    [APIManager wifiSetAPMode:objHub.Address updateData:nil completion:^(NSDictionary *responseObject) {
        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
         if(responseObject != nil){
            //NSLog(@"callSetupAPModeAPI Success  %@",responseObject);
             
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
            //NSLog(@"callSetupAPModeAPI error  %@",responseObject);
        }
    }];
}

-(void)updateDevice:(Hub*)objHub {
    UpdateHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateHubViewController"];
    //objVC.arrSearchData = self.arrSearchData;
    objVC.objSelectedMHubDevice = objHub;
    [self.navigationController pushViewController:objVC animated:YES];
}

#pragma mark - Standalone Validation and Navigation Methods
-(void) deviceSetUpStandalone_TableIndexpath:(NSIndexPath*)indexPath {
    @try {
        selectedDeviceIndexpath = indexPath;
        SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
        // If device is Video type and not equal to MHUB V3 model i.e device type is Pro, V4 or MAX
        // If device is Audio type and not equal to MHUB V3 model
        if (objData.modelType != HDA_MHUB4K431 && objData.modelType != HDA_MHUB4K862) {
            Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
            if ([objHub.Address isIPAddressEmpty]) {
                // Fetch Service
                NSNetService *service = objHub.UserInfo;
                // Resolve Service
                [service setDelegate:self];
                [service resolveWithTimeout:3.0];
            } else {
                BOOL isValid = [objHub.Address isValidIPAddress];
                if (isValid) {
                    [self validationStandaloneDevice:objHub];
                    ////NSLog(@"MOS version is %f and %@",objHub.mosVersion,objHub.strMOSVersion);
                }
            }
        } else { // If device is Video type and  equal to MHUB V3 model
            Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
            [self validationStandaloneDevice:objHub];
            //            if ([objHub isAPIV2]) {
            //               [self validationStandaloneDevice:objHub];
            //            } else {
            //                //[[AppDelegate appDelegate] alertControllerMOSUpdate:objHub];
            //                [self alertControllerMOSUpdate:objHub];
            //            }
            
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}



- (void)validationStandaloneDevice:(Hub*)objHub {
    @try {
        //self.socket = nil;
        NSMutableString *strMessage = [[NSMutableString alloc] init];
        BOOL isValid = true;
        
        if ([objHub.Address isIPAddressEmpty]){
            isValid = false;
            [strMessage appendString:ALERT_MESSAGE_SELECT_DEVICE];
        }
        
        if (isValid) {
            BOOL isStacked = false;
            NSMutableArray *arrSlave = [[NSMutableArray alloc] init];
            if (objHub.Generation == mHub4KV3) {
                [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlave];
            } else {
                if (objHub.Generation == mHubAudio) {
                    [self checkDeviceIsAlreadyPaired:objHub Stacked:isStacked Slave:arrSlave];
                } else {
                    if ([objHub isAPIV2]) {
                        [self checkDeviceIsAlreadyPaired:objHub Stacked:isStacked Slave:arrSlave];
                    } else {
                        [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlave];
                    }
                }
            }
        } else {
            [[AppDelegate appDelegate] alertControllerShowMessage:strMessage];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}



#pragma mark - Pairing Validation Method
-(void) checkDeviceIsAlreadyPaired:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        if ([objHub isPairedSetup]) {
            if ([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem) {
                [Pair deviceAvailableInPair:objHub.PairingDetails SerialNo:objHub.SerialNo completion:^(BOOL isMaster, BOOL isSlave) {
                    if (isMaster) {
                        [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else if (isSlave) {
                        [self navigateToWarningScreen:HDA_SlaveExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    }
                }];
            } else if((self.setupType == HDA_SetupVideo || self.setupType == HDA_SetupAudio)) {
                [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
            } else {
               // [self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
            }
        } else {
            [APIManager filePairJSON_Hub:objHub completion:^(APIV2Response *responseObject) {
                if (responseObject.error) {
                    if((self.setupType == HDA_SetupVideo || self.setupType == HDA_SetupAudio)) {
                        [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else {
                       // [self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    }
                } else {
                    if ([responseObject.data_description isKindOfClass:[Pair class]]) {
                        objHub.PairingDetails = (Pair*)responseObject.data_description;
                        objHub.isPaired = true;
                    } else {
                        objHub.isPaired = false;
                        objHub.PairingDetails = [[Pair alloc] init];
                    }
                    if ([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem) {
                        [Pair deviceAvailableInPair:objHub.PairingDetails SerialNo:objHub.SerialNo completion:^(BOOL isMaster, BOOL isSlave) {
                            if (isMaster) {
                                [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                            } else if (isSlave) {
                                [self navigateToWarningScreen:HDA_SlaveExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                            }
                        }];
                    } else if((self.setupType == HDA_SetupVideo || self.setupType == HDA_SetupAudio)) {
                        [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else {
                        //[self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    }
                }
            }];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) navigateToWarningScreen:(HDAWarningType)warningType WarningHub:(Hub*)objWarningHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        WarningMessageVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"WarningMessageVC"];
        [objVC getNavigationValue:warningType SearchData:[self.arrSearchData objectAtIndex:selectedDeviceIndexpath.section] WarningHub:objWarningHub Paired:isStacked SlaveArray:arrSlaveDevice];
        [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - BootFlag Validation Method
-(void) checkStandaloneDeviceIsAlreadyBooted:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice
{
    @try {
        if ([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem && objHub.BootFlag == true) {
            [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
        } else if([objHub isAlreadyPairedSetup]) {
            [Pair deviceAvailableInPair:objHub.PairingDetails SerialNo:objHub.SerialNo completion:^(BOOL isMaster, BOOL isSlave) {
                if (isMaster) {
                    [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                } else if (isSlave) {
                    [self navigateToWarningScreen:HDA_SlaveExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                }
            }];
        } else {
            [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}



-(void) navigateToSetupConfirmationScreen:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice
{
    @try {
//        if(objHub.mosVersion < objHub.MHub_BenchMarkVersion)
//        {
//            [self updateDevice:objHub];
//        }
//        else{
            
            
            SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
            objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:objHub];
            objVC.isSelectedPaired = isStacked;
            objVC.arrSelectedSlaveDevice = [[NSMutableArray alloc] initWithArray:arrSlaveDevice];
            [self.navigationController pushViewController:objVC animated:YES];
       // }
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppDelegate appDelegate].isSearchNetworkPopVC = true;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
