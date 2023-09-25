//
//  WarningMessageVC.m
//  mHubApp
//
//  Created by Anshul Jain on 27/03/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "WarningMessageVC.h"
#import "CellHeaderImage.h"
#import "CellSetupDevice.h"
#import "SetupConfirmationVC.h"
#import "SetupTypeVC.h"

@interface WarningMessageVC () {
    HDAWarningType warningType;
    SearchData *objSearchData;
    Hub *objHubWarning;
    BOOL isSelectedPaired;
    NSMutableArray <Hub*>*arrSelectedSlaveDevice;
}

@end

@implementation WarningMessageVC

-(void) getNavigationValue:(HDAWarningType)warning SearchData:(nullable SearchData*)objData WarningHub:(nullable Hub*)objWarningHub Paired:(BOOL)isPaired SlaveArray:(nullable NSMutableArray*)arrSlave {
    @try {
        warningType = warning;
        objSearchData = objData;
        objHubWarning = [[Hub alloc] initWithHub:objWarningHub];
        isSelectedPaired = isPaired;
        arrSelectedSlaveDevice = [[NSMutableArray alloc] initWithArray:arrSlave];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


- (void)viewDidLoad {
    @try {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    //[self.lblHeaderMessage setTextColor:themeColor.colorNormalText];
    [self.lblHeaderMessage setTextColor:colorMiddleGray_868787];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    switch (warningType) {
        case HDA_MasterExist: {
            self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_MHUB_ALREADY_CONFIGURED_HEADER];
            [self.lblHeaderMessage setText:HUB_MHUB_ALREADY_CONFIGURED_MESSAGE];
            break;
        }
        case HDA_SlaveExist: {
            self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_MHUB_ALREADY_PAIRED_HEADER];
            [self.lblHeaderMessage setText:HUB_MHUB_ALREADY_PAIRED_MESSAGE];
            break;
        }
        case HDA_ManuallyConnect: {
            self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_CONNECT_MANUALLY_WARNING_HEADER];
            [self.lblHeaderMessage setText:HUB_CONNECT_MANUALLY_WARNING_MESSAGE];
            break;
        }

        default:
            break;
    }
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}

-(void) viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lblHeaderMessage setFont:textFontRegular12];
        } else {
            [self.lblHeaderMessage setFont:textFontRegular16];
        }
        [[AppDelegate appDelegate] setShouldRotate:NO];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lblHeaderMessage setFont:textFontRegular12];
        } else {
            [self.lblHeaderMessage setFont:textFontRegular18];
        }
    }
    @catch(NSException *exception) {
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tblWarningContinue]) {
        return 2;
    } else {
        if (warningType == HDA_SlaveExist) {
            NSArray *arrRow = objSearchData.arrItems;
            return [arrRow count];
        } else {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.tblWarningMessage] && [objSearchData.arrItems count] > 0) {
        if (warningType == HDA_SlaveExist) {
            return objSearchData.sectionHeight+60.0f;
        } else {
            return objSearchData.sectionHeight;
        }
    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.tblWarningMessage]) {
        if (warningType == HDA_SlaveExist) {
            static NSString *HeaderCellIdentifier = @"CellHeaderImageWithLabel";
            CellHeaderImage *cellHeader = [self.tblWarningMessage dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
            if (cellHeader == nil) {
                cellHeader = [self.tblWarningMessage dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
            }
            [cellHeader.imgCell setTintColor:[AppDelegate appDelegate].themeColoursSetup.themeType == Dark ? colorWhite : colorBlack];
            cellHeader.imgCell.image = objSearchData.imgSection;
            [cellHeader.lblSubHeader setText:objHubWarning.SerialNo];

            [cellHeader.contentView setAlpha:ALPHA_ENABLE];
            return cellHeader;
        } else {
            static NSString *HeaderCellIdentifier = @"CellHeaderImage";
            CellHeaderImage *cellHeader = [self.tblWarningMessage dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
            if (cellHeader == nil) {
                cellHeader = [self.tblWarningMessage dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
            }
            [cellHeader.imgCell setTintColor:[AppDelegate appDelegate].themeColoursSetup.themeType == Dark ? colorWhite : colorBlack];
            cellHeader.imgCell.image = objSearchData.imgSection;
            //    if (isDeviceSelected == true) {
            //        if (selectedDeviceIndexpath.section == section) {
            //            [cellHeader.contentView setAlpha:ALPHA_ENABLE];
            //        } else {
            //            [cellHeader.contentView setAlpha:ALPHA_DISABLE];
            //        }
            //    } else {
            [cellHeader.contentView setAlpha:ALPHA_ENABLE];
            //    }
            return cellHeader;
        }
    } else {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
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
        if ([tableView isEqual:self.tblWarningContinue]) {
            if (indexPath.row == 0) {
                CellSetupDevice *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
                if (cell == nil) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
                }
                if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                    [cell.lblCell setFont:textFontBold10];
                } else {
                    [cell.lblCell setFont:textFontBold13];
                }
                // cell.imgCellBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColoursSetup.colorBackground Frame:cell.imgCellBackground.frame];
                if (warningType == HDA_ManuallyConnect) {
                    cell.lblCell.text = [HUB_RETURN_TO_MANUAL_CONNECTION uppercaseString];
                } else {
                    cell.lblCell.text = [HUB_RETURN_TO_CONNECTION_OPTIONS uppercaseString];
                }
               
                cell.imgCell.image = nil;
                [cell setUserInteractionEnabled:true];
                [cell.contentView setAlpha:ALPHA_ENABLE];
                return cell;

            } else {
                CellSetupDevice *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupWOBorder"];
                if (cell == nil) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupWOBorder"];
                }
                cell.imgCellBackground.image = nil;
                cell.lblCell.text = [HUB_CONTINUE_WITH_SETUP uppercaseString];
                if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                    [cell.lblCell setFont:textFontBold10];
                } else {
                    [cell.lblCell setFont:textFontBold13];
                }
                cell.imgCell.image = nil;
                [cell setUserInteractionEnabled:true];
                [cell.contentView setAlpha:ALPHA_ENABLE];
                return cell;
            }
        } else {
            CellSetupDevice *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
            if (cell == nil) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
            }
            // cell.imgCellBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColoursSetup.colorBackground Frame:cell.imgCellBackground.frame];

            Hub *objHub = [objSearchData.arrItems objectAtIndex:indexPath.row];
            NSMutableString *title = [[NSMutableString alloc] initWithString:@"ACCESS MHUB-OS"];
//            if ([self.objData.arrItems count] > 1) {
//                NSInteger intCount = indexPath.row+1;
//                [title appendString:[NSString stringWithFormat:@" \"%@\" #%ld", objHub.Name, (long)intCount]];
//            } else {
//                [title appendString:[NSString stringWithFormat:@" \"%@\"", objHub.Name]];
//            }

            if (![objHub.Address isIPAddressEmpty]) {
                [title appendString:[NSString stringWithFormat:@" (%@)", objHub.Address]];
            }
            cell.lblCell.text = [title uppercaseString];
            cell.imgCell.image = nil;
            [cell setUserInteractionEnabled:true];
            [cell.contentView setAlpha:ALPHA_ENABLE];
            return cell;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if ([tableView isEqual:self.tblWarningContinue]) {
            if (indexPath.row == 0) {
                //[self.navigationController popViewControllerAnimated:true];
                [self showNewMainStoryBoard];
            } else {
                if (warningType == HDA_ManuallyConnect) {
                    SetupTypeVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupTypeVC"];
                    objVC.setupType = HDA_SetupVideoAudio;
                    [self.navigationController pushViewController:objVC animated:YES];
                }
//                else if (warningType == HDA_MasterExist && [AppDelegate appDelegate].systemType == HDA_ConnectManually){
//
//                    SetupTypeVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupTypeVC"];
//                    objVC.setupType = HDA_SetupVideoAudio;
//                    [self.navigationController pushViewController:objVC animated:YES];
//                }
                
                else {
                    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
                    NSString *strAddress = @"";
                    if (warningType == HDA_SlaveExist) {
                        strAddress = objHubWarning.PairingDetails.master.ip_address;
                    } else {
                        strAddress = objHubWarning.Address;
                    }
                    [APIManager resetMhubSetting:strAddress completion:^(APIV2Response *responseObject) {
                        if (responseObject.error) {
                            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                        } else {
                            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                            objHubWarning.BootFlag = false;
                            SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
                            objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:objHubWarning];
                            objVC.isSelectedPaired = isSelectedPaired;
                            objVC.arrSelectedSlaveDevice = [[NSMutableArray alloc] initWithArray:arrSelectedSlaveDevice];
                            [self.navigationController pushViewController:objVC animated:YES];
                        }
                    }];
                }
            }
        } else {
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Navigation Methods

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
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}




@end
