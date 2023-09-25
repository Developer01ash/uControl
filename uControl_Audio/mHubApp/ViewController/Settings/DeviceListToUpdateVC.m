//
//  DeviceListToUpdateVC.m
//  mHubApp
//
//  Created by Rave Digital on 12/01/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "DeviceListToUpdateVC.h"
#import "EnterIPAddressManuallyUpdateFlowVC.h"
#import "UpdateHubViewController.h"
@interface DeviceListToUpdateVC ()
{
    NSIndexPath *selectedIndexPath;
}
@end

@implementation DeviceListToUpdateVC

- (void)viewDidLoad {
    @try {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_AVAILABLE_SYSTEMS];
    [self.btnAdvance.titleLabel setText:[HUB_ADVANCE_UPDATE_MOS uppercaseString]];
    [self.btnContinue.titleLabel setText:[ALERT_BTN_TITLE_CONTINUE uppercaseString]];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    SearchData *objData = [self.arr_devices objectAtIndex:section];
//    NSArray *arrRow = objData.arrItems;
////    for(int i = 0 ; i < [arrRow count];i++)
////    {
////        Hub *objHub = [arrRow objectAtIndex:i];
////
////        //NSLog(@"audio name %@",objHub.Address);
////    }
    return [self.arr_devices count];
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
        //SearchData *objData = [self.arr_devices objectAtIndex:indexPath.section];
        Hub *objHub = [self.arr_devices objectAtIndex:indexPath.row];
        NSMutableString *title;
        
            title = [[NSMutableString alloc] initWithString:@""];

            [title appendString:[NSString stringWithFormat:@"%@", objHub.Official_Name]];
        
        if (![objHub.Address isIPAddressEmpty]) {
            cell.lblAddress.text = [NSString stringWithFormat:@"%@", objHub.Address];
           // [title appendString:[NSString stringWithFormat:@"\n(%@)", objHub.Address]];
        }
        cell.lblCell.text = [title uppercaseString];
 
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        selectedIndexPath = indexPath;
        CellSetupDevice *cell = [self.tbl_devices cellForRowAtIndexPath:indexPath];
        [cell.imgCheckMark setHidden:false];
        [self.tbl_devices reloadData];
        return;
//        SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
//        Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
//        if(_navigateFromType == menu_reset)
//        {
//        RestoreHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RestoreHubViewController"];
//        objVC.objSelectedMHubDevice = objHub;
//        [self.navigationController pushViewController:objVC animated:YES];
//        }
//        else if(_navigateFromType ==  menu_update)
//        {
//            UpdateHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateHubViewController"];
//           // objVC.arrSearchData = self.arrSearchData;
//            objVC.objSelectedMHubDevice = objHub;
//            objVC.navigateFromType = _navigateFromType;
//            [self.navigationController pushViewController:objVC animated:YES];
//        }
//        else if(_navigateFromType ==  menu_autoConnect_gotoSetupConfirmation)
//        {
//            [self navigateToSetupConfirmationScreen:objHub Stacked:false Slave:[[NSMutableArray alloc]init]];
//            // [self deviceSetUpStandalone_TableIndexpath:indexPath];
//        }
//        else if(_navigateFromType == menu_Wifi)
//        {
//            SetAPModeVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"SetAPModeVC"];
//            objVC.objSelectedDevice = objHub;
//            [self.navigationController pushViewController:objVC animated:NO];
//
//        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(IBAction)button_continue:(CustomButton *)sender
{
    @try {
        Hub *objHub = [self.arr_devices objectAtIndex:selectedIndexPath.row];

            UpdateHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateHubViewController"];
           // objVC.arrSearchData = self.arrSearchData;
            objVC.objSelectedMHubDevice = objHub;
            objVC.navigateFromType = _navigateFromType;
            [self.navigationController pushViewController:objVC animated:YES];
       
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(IBAction)button_advance:(CustomButton *)sender
{
    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
    EnterIPAddressManuallyUpdateFlowVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"EnterIPAddressManuallyUpdateFlowVC"];
    [AppDelegate appDelegate].systemType = HDA_ConnectManually;
    [self.navigationController pushViewController:objVC animated:YES];
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
