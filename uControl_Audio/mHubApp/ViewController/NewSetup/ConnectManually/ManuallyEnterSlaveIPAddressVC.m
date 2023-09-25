//
//  ManuallyEnterSlaveIPAddressVC.m
//  mHubApp
//
//  Created by rave on 9/18/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ManuallyEnterSlaveIPAddressVC.h"
#import "WarningMessageVC.h"
#import "SetupConfirmationVC.h"
#import "CellSetupDevice.h"
#import "CellEnterIPAddressContainer.h"
@interface ManuallyEnterSlaveIPAddressVC () {

}
@end

@implementation ManuallyEnterSlaveIPAddressVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;

}

-(void) viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_ADDMANUALLY_HEADER];
        [self.lblHeaderMessage setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
        [self.lblHeaderMessage setText:HUB_CONNECT_MANUALLY_IPADDRESS_MESSAGE];
        [[AppDelegate appDelegate] setShouldRotate:NO];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
//        CGFloat height = MIN(self.tblDeviceType.bounds.size.height, self.tblDeviceType.contentSize.height);
//        self.heightTblDeviceType.constant = height;
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lblHeaderMessage setFont:textFontRegular12];
        } else {
            [self.lblHeaderMessage setFont:textFontRegular18];
        }
        [self.view layoutIfNeeded];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
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
    if ([[segue identifier] isEqualToString:@"ManualIPAddressView"]) {
        ManuallyIPAddressContainerVC *objCtrlType = (ManuallyIPAddressContainerVC *)[segue destinationViewController];
        objCtrlType.delegate = self;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tblSelection) {
        return 1;
    } else {
        return self.arrSelectedSlaveDevice.count+1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tblSelection) {
        return 0.0f;
    } else {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            return heightTableViewRowWithPadding_SmallMobile;
        } else {
            return heightTableViewRowWithPadding;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CellSetup *cellHeader = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    if (cellHeader == nil) {
        cellHeader = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    }
    if (tableView == self.tblDeviceType) {
        // cellHeader.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColoursSetup.colorNavigationBar Frame:cellHeader.imgBackground.frame];
        [cellHeader.lblCell setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorOutputText];
        if (section == 0) {
            cellHeader.lblCell.text = [self.objSelectedMHubDevice.modelName uppercaseString];
        } else {
            Hub *objSlave = [self.arrSelectedSlaveDevice objectAtIndex:section-1];
            NSMutableString *title = [[NSMutableString alloc] init];
            if ([self.arrSelectedSlaveDevice count] > 1) {
                NSInteger intCount = section;
                [title appendString:[NSString stringWithFormat:@"%@ #%ld", objSlave.modelName, (long)intCount]];
            } else {
                [title appendString:[NSString stringWithFormat:@"%@", objSlave.modelName]];
            }
            cellHeader.lblCell.text = [title uppercaseString];
        }
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
    if (tableView == self.tblSelection) {
        CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
            tableView.allowsSelection = true;
        }
        //cell.lblCell.text = [[NSString stringWithFormat:@"Connect to %@", [Hub getHubName:hubModel]] uppercaseString];
        cell.lblCell.text = @"CONNECT";
        return cell;
    } else {
        CellEnterIPAddressContainer *cell = [tableView dequeueReusableCellWithIdentifier:@"CellEnterIPAddressContainer" forIndexPath:indexPath];
        // adjust this for your structure
        cell.delegate = self;
        cell.cellIndexPath = indexPath;
        return cell;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if (tableView == self.tblSelection) {
        [self validationForNextScreen];
    }
}

#pragma mark - Stacked Validation and Navigation Methods

- (void)validationForNextScreen {
    @try {
        [[self view] endEditing:YES];
        NSMutableString *strMessage = [[NSMutableString alloc] init];
        BOOL isValid = true;

        if (self.objSelectedMHubDevice.Generation <= (HubModel)0) {
            isValid = false;
            [strMessage appendString:ALERT_MESSAGE_SELECT_HUBMODEL];
        }

        if ([self.objSelectedMHubDevice.Address isIPAddressEmpty]){
            isValid = false;
            [strMessage appendString:[NSString stringWithFormat:ALERT_MESSAGE_ENTER_DEVICE_IPADDRESS, self.objSelectedMHubDevice.modelName]];
        }

        if (self.arrSelectedSlaveDevice.count > 0) {
            for (int counter = 0; counter < self.arrSelectedSlaveDevice.count; counter++) {
                Hub *objSlave = [self.arrSelectedSlaveDevice objectAtIndex:counter];
                if ([objSlave.Address isIPAddressEmpty]){
                    isValid = false;
                    NSMutableString *title = [[NSMutableString alloc] init];
                    if ([self.arrSelectedSlaveDevice count] > 1) {
                        NSInteger intCount = counter+1;
                        [title appendString:[NSString stringWithFormat:@"%@ #%ld", objSlave.modelName, (long)intCount]];
                    } else {
                        [title appendString:[NSString stringWithFormat:@"%@", objSlave.modelName]];
                    }
                    [strMessage appendString:[NSString stringWithFormat:ALERT_MESSAGE_ENTER_DEVICE_IPADDRESS, title]];
                }
            }
        }
       
        if (isValid) {
            if (self.objSelectedMHubDevice.Generation == mHub4KV3) {
                [self validationToNavigateToConfirmationScreen:self.objSelectedMHubDevice Stacked:false Slave:[[NSMutableArray alloc] init]];
            } else {
                for (int counter = 0; counter < self.arrSelectedSlaveDevice.count; counter++) {
                    Hub *objSlave = [self.arrSelectedSlaveDevice objectAtIndex:counter];
                    [APIManager fileAllDetails:objSlave completion:^(APIV2Response *responseObject) {
                        if (!responseObject.error) {
                            Hub *objHubResp = (Hub*)responseObject.data_description;
                            [self.arrSelectedSlaveDevice replaceObjectAtIndex:counter withObject:objHubResp];
                        }
                    }];
                }
                [APIManager fileAllDetails:self.objSelectedMHubDevice completion:^(APIV2Response *responseObject) {
                    if (responseObject.error) {
                        // [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                    } else {
                        Hub *objHubResp = (Hub*)responseObject.data_description;
                        [self validationToNavigateToConfirmationScreen:objHubResp Stacked:true Slave:self.arrSelectedSlaveDevice];
                    }
                }];
            }
        } else {
            [[AppDelegate appDelegate] alertControllerShowMessage:strMessage];
        }
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)validationToNavigateToConfirmationScreen:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        if ([objHub isAPIV2]) {
        if (objHub.Generation == mHub4KV3) {
            [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
        } else {
            if (objHub.Generation == mHubAudio) {
                [self checkDeviceIsAlreadyPaired:objHub Stacked:isStacked Slave:arrSlaveDevice];
            } else {
                if ([objHub isAPIV2]) {
                    [self checkDeviceIsAlreadyPaired:objHub Stacked:isStacked Slave:arrSlaveDevice];
                } else {
                    [self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                }
            }
        }
    }
    else {
        [[AppDelegate appDelegate] alertControllerMOSUpdate:objHub];
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
                [self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
            }
        } else {
            [APIManager filePairJSON_Hub:objHub completion:^(APIV2Response *responseObject) {
                if (responseObject.error) {
                    if((self.setupType == HDA_SetupVideo || self.setupType == HDA_SetupAudio)) {
                        [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else {
                        [self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
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
                        [self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
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

-(void) checkStackedDeviceIsAlreadyBooted:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        if ([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem && objHub.BootFlag == true) {
            [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
        } else {
            if (isStacked == false) {
                [Hub deviceAvailableForPair:objHub Slaves:arrSlaveDevice completion:^(BOOL isMaster, BOOL isSlave, Hub *objWarningSlave) {
                    if (isMaster) {
                        [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else if (isSlave) {
                        [self navigateToWarningScreen:HDA_SlaveExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else {
                        [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    }
                }];
            } else {
                if (objHub.BootFlag == true && [objHub.PairingDetails isPairEmpty]) {
                    [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                } else {
                    [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
                }
            }
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

- (void) setIPAddress:(CellEnterIPAddressContainer*)sender Address:(NSString*)strAddress {
    @try {
        if (sender.cellIndexPath.section == 0) {
            self.objSelectedMHubDevice.Address = strAddress;
        } else {
            NSInteger intIndex = sender.cellIndexPath.section-1;
            Hub *objSlave = [self.arrSelectedSlaveDevice objectAtIndex:intIndex];
            objSlave.Address = strAddress;
            [self.arrSelectedSlaveDevice replaceObjectAtIndex:intIndex withObject:objSlave];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
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
        movementDistance = -100; // tweak as needed
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
