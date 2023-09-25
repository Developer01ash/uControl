//
//  SelectStackSystemViewController.m
//  mHubApp
//
//  Created by Rave on 21/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "SelectStackSystemViewController.h"
#import "CellStackedSystemTableViewCell.h"
#import "SetupConfirmationVC.h"
#import "WarningMessageVC.h"
#import "UpdateHubViewController.h"
@interface SelectStackSystemViewController ()

@end

@implementation SelectStackSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @try {
    isDeviceSelected = false;
        
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lbl_deviceFound setFont:textFontBold12];
        } else {
            [self.lbl_deviceFound setFont:textFontBold16];
        }
        
        self.navigationItem.backBarButtonItem = customBackBarButton;
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_SELECT_STACKED_SYSTEM];
        self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
        //
    switch (self.setupType) {
    
    case HDA_SetupVideoAudio: {
    self.arrPrimarySearchData = [[NSMutableArray alloc] init];
    self.arrSecondarySearchData = [[NSMutableArray alloc] init];
        //self.arrSearchDataTemp = [[NSMutableArray alloc] init];
    for (SearchData *objData in self.arrSearchData) {
        DDLogDebug(@"<%s>: %ld %@ == %ld", __FUNCTION__, (long)objData.modelType,objData.strTitle, (long)objData.arrItems.count);
        if (objData.modelType == HDA_MHUBAUDIO64 || objData.modelType == HDA_MHUBS) {
            [self.arrSecondarySearchData addObject:objData];
        } else {
            [self.arrPrimarySearchData addObject:objData];
        }
    }
    
    if (self.setupLevel == HDA_SetupLevelPrimary) {
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel: HUB_SELECT_STACKED_SYSTEM];
        [self.arrSearchData removeAllObjects];
        [self.arrSearchData addObjectsFromArray:self.arrPrimarySearchData];
    } else {
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel: HUB_SELECT_SECONDARY_SYSTEM_HEADER];
        [self.arrSearchData removeAllObjects];
        [self.arrSearchData addObjectsFromArray:self.arrSecondarySearchData];
        arrSelectedDeviceIndexPath = [[NSMutableArray alloc] init];
    }
    break;
}
        default:
            break;
    }
    
} @catch(NSException *exception) {
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
    return [arrRow count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    SearchData *objData = [self.arrSearchData objectAtIndex:section];
//    if ([objData.arrItems count] > 0) {
//        return objData.sectionHeight;
//    }
//    return 0.0f;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    static NSString *HeaderCellIdentifier = @"CellStackedSystemTableViewCell";
//    SearchData *objData = [self.arrSearchData objectAtIndex:section];
//    CellStackedSystemTableViewCell *cellHeader = [self.tbl_stackSystem dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
//    if (cellHeader == nil) {
//        cellHeader = [self.tbl_stackSystem dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
//    }
//    [cellHeader.imgCell setTintColor:[AppDelegate appDelegate].themeColoursSetup.themeType == Dark ? colorWhite : colorBlack];
//    cellHeader.imgCell.image = objData.imgSection;
//    if (isDeviceSelected == true) {
//        if (selectedDeviceIndexpath.section == section) {
//            [cellHeader.contentView setAlpha:ALPHA_ENABLE];
//        } else {
//            [cellHeader.contentView setAlpha:ALPHA_DISABLE];
//        }
//    } else {
//        [cellHeader.contentView setAlpha:ALPHA_ENABLE];
//    }
//    return cellHeader;
//}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        CellStackedSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellStackedSystemTableViewCell"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellStackedSystemTableViewCell"];
        }
        // cell.imgCellBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColoursSetup.colorBackground Frame:cell.imgCellBackground.frame];
        
        SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
        
        Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
        NSMutableString *title = [[NSMutableString alloc] initWithString:@""];
        if ([objData.arrItems count] > 1) {
            NSInteger intCount = indexPath.row+1;
            [title appendString:[NSString stringWithFormat:@" #%ld", objHub.Name, (long)intCount]];
        } else {
            [title appendString:[NSString stringWithFormat:@"%@", objHub.Name]];
        }
        
        if (![objHub.Address isIPAddressEmpty]) {
            [title appendString:[NSString stringWithFormat:@" %@", objHub.Address]];
        }
        cell.lbl_HubIPAddress.text = [title uppercaseString];
        cell.lbl_StackSystem.text = [@"STACKED SYSTEM" uppercaseString];
        //NSLog(@"STACKED system title %@",title);
        
//        [cell.img_master setImage:kDEVICEMODEL_IMAGE_MHUB4K44PRO_CARBONITE_LARGE];
//        [cell.img_slave  setImage:kDEVICEMODEL_IMAGE_MHUBAUDIO64_CARBONITE_LARGE];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lbl_StackSystem setFont:textFontRegular12];
            [cell.lbl_HubIPAddress setFont:textFontBold12 ];
        } else {
            [cell.lbl_StackSystem setFont:textFontRegular16];
             [cell.lbl_HubIPAddress setFont:textFontBold16 ];
        }
       // [cell.view_withIpAddress addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];

        //[cell.imgHubDevice setImage:kDEVICEMODEL_IMAGE_MHUB4K44PRO_CARBONITE];
        if (self.setupLevel == HDA_SetupLevelPrimary) {
            if (isDeviceSelected == true) {
                if ([indexPath isEqual:selectedDeviceIndexpath]) {
                    UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.img_selected_yes_no setImage:image];
                    [cell setUserInteractionEnabled:true];
                    [cell.contentView setAlpha:ALPHA_ENABLE];
                } else {
                    cell.img_selected_yes_no.image = nil;
                    [cell setUserInteractionEnabled:false];
                    [cell.contentView setAlpha:ALPHA_DISABLE];
                }
            } else {
                cell.img_selected_yes_no.image = nil;
                [cell setUserInteractionEnabled:true];
                [cell.contentView setAlpha:ALPHA_ENABLE];
            }
        } else {
            // if (isDeviceSelected == true) {
            if ([arrSelectedDeviceIndexPath containsObject:indexPath]) {
                UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                [cell.img_selected_yes_no setImage:image];
                [cell setUserInteractionEnabled:true];
                [cell.contentView setAlpha:ALPHA_ENABLE];
            } else {
                cell.img_selected_yes_no.image = nil;
                [cell setUserInteractionEnabled:true];
                [cell.contentView setAlpha:ALPHA_ENABLE];
            }

        }
        [cell.img_master setImage:[[UIImage alloc] init]];
        [cell.img_slave setImage:[[UIImage alloc] init]];
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)updateDevice:(Hub*)objHub andAllHubsInStack:(NSMutableArray *)arrSearchData{
    
    
    UpdateHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateHubViewController"];
    objVC.arrSearchData = arrSearchData;
   // objVC.objSelectedMHubDevice = objHub;
    [self.navigationController pushViewController:objVC animated:YES];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        switch (self.setupType) {
            case HDA_SetupVideo: {
             //   [self deviceSetUpStandalone_TableIndexpath:indexPath];
                break;
            }
            case HDA_SetupAudio: {
             //   [self deviceSetUpStandalone_TableIndexpath:indexPath];
                break;
            }
            case HDA_SetupVideoAudio: {
             //   [self deviceSetUpStacked_TableIndexpath:indexPath];
                SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
                
                Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
                NSMutableArray *tempArrForAddingAllMasterNSlaveInArray = [[NSMutableArray alloc]init];
                [tempArrForAddingAllMasterNSlaveInArray addObject:objHub];
                NSMutableArray *tempArrOfSlave = [[NSMutableArray alloc]init];
                tempArrOfSlave = [Hub getObjectArrayFromPairJSON:objHub.PairingDetails];
                //August2020: WE are retriving array of slave from pairing details, but it dont have all mhub information like mosversion names and all. So below for loop is written to replace slave object with actual slave object who have all the information about slave.
                for(int i = 0 ; i < tempArrOfSlave.count ;i++)
                {
                    Hub *objHub = (Hub *)[tempArrOfSlave objectAtIndex:i];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SerialNo == %@", objHub.SerialNo];
                    NSArray *arrCmdDataFiltered = [self.arrSearchDataTemp filteredArrayUsingPredicate:predicate];
                    Hub *objHub2 = (Hub *)[arrCmdDataFiltered objectAtIndex:0];
                    if(arrCmdDataFiltered.count > 0)
                    {
                        objHub.MHub_BenchMarkVersion = objHub2.MHub_BenchMarkVersion ;
                        objHub.mosVersion = objHub2.mosVersion ;
                        objHub.Generation = objHub2.Generation;
                        objHub.modelName = objHub2.modelName;
                        objHub.BootFlag  = objHub2.BootFlag;
                        objHub.InputCount  = objHub2.InputCount;
                        objHub.OutputCount  = objHub2.OutputCount;
                        
                   
                    }
                    //[tempArrOfSlave replaceObjectAtIndex:i withObject:objHub];
                    [tempArrForAddingAllMasterNSlaveInArray addObject:objHub];
                }
                //August2020: In case of pro2, it'll directly go to connection without selecting slave units.
//                if(objHub.Generation  == mHubPro2 )
//                    {
//                    SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
//                    objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:objHub];
//                    objVC.isSelectedPaired = true;
//                    objVC.arrSelectedSlaveDevice = [[NSMutableArray alloc] initWithArray:tempArrOfSlave];
//                    [self.navigationController pushViewController:objVC animated:YES];
//                    return;
//
//                    }
               // //NSLog(@"objHub paired setup %d and pair details %@ details array slave %@ master details %@",[objHub isPairedSetup],objHub.PairingDetails,objHub.PairingDetails.arrSlave,objHub.PairingDetails.master.ip_address);
                
                bool flagToCheckAnyDeviceRequiredUpdateORNot = false;
//                for(int i = 0 ; i < tempArrForAddingAllMasterNSlaveInArray.count ;i++)
//                {
//                    Hub *objHub = (Hub *)[tempArrForAddingAllMasterNSlaveInArray objectAtIndex:i];
//                    if(objHub.mosVersion < objHub.MHub_BenchMarkVersion)
//                    {
//                        flagToCheckAnyDeviceRequiredUpdateORNot = true;
//                        break;
//                    }
//                    else
//                    {
//                        
//                        flagToCheckAnyDeviceRequiredUpdateORNot = false;
//                        
//                    }
//                    
//                }
                
                if(flagToCheckAnyDeviceRequiredUpdateORNot)
                {
                    [self updateDevice:objHub andAllHubsInStack:tempArrForAddingAllMasterNSlaveInArray];
                }
                else
                {
                    //NSMutableArray *arrSelectedSlaveDeviceTemp = [[NSMutableArray alloc] initWithArray:[Hub getObjectArrayFromPairJSON:objHub.PairingDetails]];
                    if(tempArrOfSlave.count > 0)
                    {
                    SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
                    objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:objHub];
                    objVC.isSelectedPaired = true;
                    objVC.arrSelectedSlaveDevice = [[NSMutableArray alloc] initWithArray:tempArrOfSlave];
                    [self.navigationController pushViewController:objVC animated:YES];
                    }
                    else
                    {
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:HUB_NOSLAVEDEVICES];
                    }
                    
                }
                break;
            }
            case HDA_SetupPairedAudio: {
             //   [self deviceSetUpStacked_TableIndexpath:indexPath];
                break;
            }
            default:    break;
        }
    } @catch(NSException *exception) {
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
