//
//  GroupAudioVC.m
//  mHubApp
//
//  Created by Anshul Jain on 22/01/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "GroupAudioVC.h"
#import "ManageGroupAudioVC.h"
#import "CellGroupAudio.h"

@interface GroupAudioVC ()<CellGroupAudioDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblGroupAudio;
@property (strong, nonatomic) NSMutableArray *arrGroupAudio;

@end

// In case, I taken all saturday off which provided to me and for

@implementation GroupAudioVC

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        //self.navigationItem.backBarButtonItem = customBackBarButton;
        self.navigationItem.hidesBackButton = true;
        UIBarButtonItem *btnRightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnRightBarButton_Clicked:)];
        self.navigationItem.rightBarButtonItem = btnRightBarButton;

        if (mHubManagerInstance.objSelectedHub.HubGroupData.count == 0) {
            ManageGroupAudioVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"ManageGroupAudioVC"];
            objVC.selectedSetting = self.selectedSetting;
            [self.navigationController pushViewController:objVC animated:NO];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    @try {
        [super viewWillAppear:animated];
        self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
        [[AppDelegate appDelegate] setShouldRotate:NO];
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:self.selectedSetting.Title];

        self.arrGroupAudio = [[NSMutableArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubGroupData];
        [self.tblGroupAudio reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) btnRightBarButton_Clicked:(id)sender {
    @try {
        ManageGroupAudioVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"ManageGroupAudioVC"];
        objVC.selectedSetting = self.selectedSetting;
        [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrGroupAudio.count;
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
        static NSString *CellIdentifier = @"CellGroupAudio";
        CellGroupAudio *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        cell.cellIndexPath = indexPath;
        [cell.viewContentBG setBackgroundColor:[AppDelegate appDelegate].themeColours.colorBackground];
        cell.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorBackground Frame:cell.imgBackground.frame];
        [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorTableCellBorder BorderWidth:1.0];
        cell.lblCell.textColor = [AppDelegate appDelegate].themeColours.colorNormalText;

        Group *objSection = [self.arrGroupAudio objectAtIndex:indexPath.row];
        [cell.lblCell setText:[objSection.GroupName uppercaseString]];
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        ManageGroupAudioVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"ManageGroupAudioVC"];
        objVC.selectedSetting = self.selectedSetting;
        objVC.objGroup = [self.arrGroupAudio objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return YES if you want the specified item to be editable.
//    return YES;
//}




//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        //[self deleteAudioOutput:indexPath];
//    }
//}

#pragma mark - CellGroupAudioDelegate
- (void)didReceivedTapOnCellDeleteButton:(CellGroupAudio *)sender
{
    
        @try {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_DELETEGROUP, nil) message:[NSString stringWithFormat:HUB_REMOVEGROUPMESSAGE] preferredStyle:UIAlertControllerStyleAlert];
            alertController.view.tintColor = colorGray_646464;
            NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERT_DELETEGROUP];
            [strAttributedTitle addAttribute:NSFontAttributeName
                                       value:textFontLight13
                                       range:NSMakeRange(0, strAttributedTitle.length)];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_YES, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
              [self deleteAudioOutput:sender.cellIndexPath];
                
                

            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_NO, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }]];
             [self presentViewController:alertController animated:YES completion:nil];
        } @catch (NSException *exception) {
            [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
            
        }
    
    
    
    

}

-(void) deleteAudioOutput:(NSIndexPath *)indexPath {
    @try {
        Group *objGroup = [self.arrGroupAudio objectAtIndex:indexPath.row];
        if(mHubManagerInstance.isPairedDevice)
        {
            // Audio changes for single slave-NEW
//            Hub *objAudioSlave = [mHubManagerInstance.arrSlaveAudioDevice firstObject];
//            DDLogDebug(@"slave IP address groupManager_Address %@", objAudioSlave.Address);
            // Audio changes for single slave-NEW - Change to send command only on master.
            Hub *objHubMaster = mHubManagerInstance.objSelectedHub;
            
             [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
            [APIManager groupManager_Address:objHubMaster.Address Group:objGroup Operation:GRPO_Delete completion:^(APIV2Response *responseObject) {
                if (responseObject.error) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                } else {
                       NSDictionary *dict;
                    [self.arrGroupAudio removeObjectAtIndex:indexPath.row];
                    // ZONE UPDATE- After deleting a group we also need to update zone by setting its selected state to no and removing its selected image
                    for (int i = 0; i < mHubManagerInstance.objSelectedHub.HubZoneData.count; i++) {
                        Zone *tempZone = mHubManagerInstance.objSelectedHub.HubZoneData[i];
                        if ([objGroup.arrGroupedZones containsObject:tempZone.zone_id]) {
                            tempZone.isGrouped = NO;
                            tempZone.imgGroupedZone = nil;
                            if ([mHubManagerInstance.objSelectedZone.zone_id isEqualToString:tempZone.zone_id]) {
                                mHubManagerInstance.objSelectedZone = tempZone;
                                dict = [tempZone dictionaryRepresentation];
                            }
                           
                        }
                        [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:i withObject:tempZone];
                    }
                    
                   
                   
                //************
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadZoneControlVC object:self userInfo:dict];
                
                    
                    
                    //************
                    mHubManagerInstance.objSelectedHub.HubGroupData = [[NSMutableArray alloc] initWithArray:[mHubManagerInstance deleteGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:objGroup]];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    [self.tblGroupAudio reloadData];
                }
            }];
        }
        else
        {
             [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
            [APIManager groupManager_Address:mHubManagerInstance.objSelectedHub.Address Group:objGroup Operation:GRPO_Delete completion:^(APIV2Response *responseObject) {
                if (responseObject.error) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                } else {
                    [self.arrGroupAudio removeObjectAtIndex:indexPath.row];
                    // ZONE UPDATE- After deleting a group we also need to update zone by setting its selected state to no and removing its selected image
                    for (int i = 0; i < mHubManagerInstance.objSelectedHub.HubZoneData.count; i++) {
                        Zone *tempZone = mHubManagerInstance.objSelectedHub.HubZoneData[i];
                        if ([objGroup.arrGroupedZones containsObject:tempZone.zone_id]) {
                            tempZone.isGrouped = NO;
                            tempZone.imgGroupedZone = nil;
                        }
                        [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:i withObject:tempZone];
                    }
                    //************
                    mHubManagerInstance.objSelectedHub.HubGroupData = [[NSMutableArray alloc] initWithArray:[mHubManagerInstance deleteGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:objGroup]];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    [self.tblGroupAudio reloadData];
                }
            }];
        }
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
@end
