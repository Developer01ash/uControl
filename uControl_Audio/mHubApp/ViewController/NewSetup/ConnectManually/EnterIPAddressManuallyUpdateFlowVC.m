//
//  ManuallyEnterIPAddressVC.m
//  mHubApp
//
//  Created by rave on 01/12/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "EnterIPAddressManuallyUpdateFlowVC.h"
#import "WarningMessageVC.h"
#import "SetupConfirmationVC.h"
#import "CellSetupDevice.h"
#import "UpdateHubViewController.h"

@interface EnterIPAddressManuallyUpdateFlowVC () {
    Hub *objSelectedMHubDevice;
}
@end

@implementation EnterIPAddressManuallyUpdateFlowVC
@synthesize hubModel;

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    // Do any additional setup after loading the view.

    
    objSelectedMHubDevice = [[Hub alloc] init];
    objSelectedMHubDevice.Generation = hubModel;
    objSelectedMHubDevice.modelName =[Hub getModelName:objSelectedMHubDevice];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:@"Enter IP address"];
    [self.lblHeaderMessage setTextColor:colorMiddleGray_868787];
    [self.lblHeaderMessage setText:HUB_CONNECT_MANUALLY_IPADDRESS_MESSAGE_update];
    
   
    [[AppDelegate appDelegate] setShouldRotate:NO];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    CGFloat height = MIN(self.tblDeviceType.bounds.size.height, self.tblDeviceType.contentSize.height);
//    self.heightTblDeviceType.constant = height;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontRegular12];
        self.heightViewIPAddress.constant = heightTableViewRow_SmallMobile;
    } else {
        [self.lblHeaderMessage setFont:textFontRegular16];
        self.heightViewIPAddress.constant = heightTableViewRow;
    }
    [self.view layoutIfNeeded];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ManualIPAddressViewUpdate"]) {
        ManuallyIPAddressContainerVC *objCtrlType = (ManuallyIPAddressContainerVC *)[segue destinationViewController];
        objCtrlType.delegate = self;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // if (tableView == self.tblSelection) {
        return 1;
//    } else {
//        return self.arrData.count;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  //  if (tableView == self.tblSelection) {
        return 0.0f;
//    } else {
//        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
//            return heightTableViewRowWithPadding_SmallMobile;
//        } else {
//            return heightTableViewRowWithPadding;
//        }
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CellSetup *cellHeader = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    if (cellHeader == nil) {
        cellHeader = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    }
//    if (tableView == self.tblDeviceType) {
//        cellHeader.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColoursSetup.colorNavigationBar Frame:cellHeader.imgBackground.frame];
//        [cellHeader.lblCell setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorHeaderText];
//        cellHeader.lblCell.text = [[Hub getHubName:hubModel] uppercaseString];
//        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
//            [cellHeader.lblCell setFont:textFontRegular12];
//
//        } else {
//            [cellHeader.lblCell setFont:textFontRegular16];
//
//        }
//    }
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
   // if (tableView == self.tblSelection) {
        CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
            tableView.allowsSelection = true;
        }
        //cell.lblCell.text = [[NSString stringWithFormat:@"Connect to %@", [Hub getHubName:hubModel]] uppercaseString];
        cell.lblCell.text = @"CONTINUE";
        return cell;
//    } else {
//        CellSetupDevice *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
//        if (cell == nil) {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
//        }
//        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
//            [cell.lblCell setFont:textFontBold10];
//
//        } else {
//            [cell.lblCell setFont:textFontBold13];
//
//        }
//        cell.lblCell.text = [[self.arrData objectAtIndex:indexPath.row] uppercaseString];
//        if ([indexPath isEqual:selectedIndexPath]) {
//            [cell.imgCell setTintColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
//            UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
//            [cell.imgCell setImage:image];
//            [cell.lblCell setTextColor:colorWhite];
//        } else {
//            cell.imgCell.image = nil;
//            [cell.lblCell setTextColor:colorMiddleGray_868787];
//        }
//
//        return cell;
//    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // if (tableView == self.tblSelection) {
        [self validationForNextScreen];
//    } else {
//        selectedIndexPath = indexPath;
//        switch (indexPath.row) {
//            case MHUB4K431: {
//                objSelectedMHubDevice.InputCount = 4;
//                objSelectedMHubDevice.OutputCount = 4;
//                break;
//            }
//            case MHUB4K862: {
//                objSelectedMHubDevice.InputCount = 8;
//                objSelectedMHubDevice.OutputCount = 8;
//                break;
//            }
//            default:
//                break;
//        }
//        [self.tblDeviceType reloadData];
//    }
}

#pragma mark - Standalone Validation and Navigation Methods
- (void)validationForNextScreen {
    @try {
        [[self view] endEditing:YES];
       
                [APIManager fileAllDetails:objSelectedMHubDevice completion:^(APIV2Response *responseObject) {
                    if (responseObject.error) {
                        [[AppDelegate appDelegate] alertControllerShowMessage:@"System not connected check IP address and try again, Find device or Exit"];
                        // [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                    } else {
                        if(self.navigateFromType == menu_Wifi)
                        {
                            [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                            WifiDiscoveryModeVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WifiDiscoveryModeVC"];
                            objVC.modelType = mHubZP;
                            //objVC.objSelectedMHubDevice =  objHub;
                            [self.navigationController pushViewController:objVC animated:YES];
                        }
                        else{
                        Hub *objHubResp = (Hub*)responseObject.data_description;
                        UpdateHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateHubViewController"];
                        objVC.objSelectedMHubDevice = objHubResp;
                        [self.navigationController pushViewController:objVC animated:NO];
                        }
                        
                       
                    }
                }];
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)validationToNavigateToConfirmationScreen:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        if ([objHub isAPIV2]) {
        if (objHub.Generation == mHub4KV3) {
            objHub.BootFlag = true;
            [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
        } else {
            if (objHub.Generation == mHubAudio) {
                [self checkDeviceIsAlreadyPaired:objHub Stacked:isStacked Slave:arrSlaveDevice];
            } else {
                if ([objHub isAPIV2]) {
                    [self checkDeviceIsAlreadyPaired:objHub Stacked:isStacked Slave:arrSlaveDevice];
                } else {
                    [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                }
            }
        }
    }
    else
    {
        
        if (objHub.Generation == mHub4KV3) {
            objHub.BootFlag = true;
            [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
        }
        else
        {
            [[AppDelegate appDelegate] alertControllerMOSUpdate:objHub];
        }
        
    }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - BootFlag Validation Method
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
            } else {
                [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
            }

        } else {
            [APIManager filePairJSON_Hub:objHub completion:^(APIV2Response *responseObject) {
                if (responseObject.error) {
                    [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
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
                    } else {
                        [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    }
                }
            }];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - BootFlag Validation Method
-(void) checkStandaloneDeviceIsAlreadyBooted:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        if ([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem && objHub.BootFlag == true) {
            [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
            
        } else if([objHub isAlreadyPairedSetup]) {
            [Pair deviceAvailableInPair:objHub.PairingDetails SerialNo:objHub.SerialNo completion:^(BOOL isMaster, BOOL isSlave) {
                if (isMaster) {
                    [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    //[self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
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

#pragma mark - Navigation Methods
-(void) navigateToWarningScreen:(HDAWarningType)warningType WarningHub:(Hub*)objWarningHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        WarningMessageVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"WarningMessageVC"];
        [objVC getNavigationValue:warningType SearchData:nil WarningHub:objWarningHub Paired:isStacked SlaveArray:arrSlaveDevice];
        [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) navigateToSetupConfirmationScreen:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
        objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:objHub];
        objVC.isSelectedPaired = isStacked;
        objVC.arrSelectedSlaveDevice = [[NSMutableArray alloc] initWithArray:arrSlaveDevice];
        [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - ManuallyIPAddressContainerVC Delegate

-(void) setIPAddress:(NSString *)strAddress {
    objSelectedMHubDevice.Address = strAddress;
}

-(void)animateView:(BOOL)isUp {
    @try {
        [self animateView_up:isUp];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)animateView_up:(BOOL)up
{
    int movementDistance;
    if (IS_IPHONE_4_HEIGHT) {
        movementDistance = -160; // tweak as needed
    } else {
        movementDistance = -60; // tweak as needed
    }
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
