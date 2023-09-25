//
//  DeviceFoundVC.m
//  mHubApp
//
//  Created by Apple on 05/02/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "DeviceFoundVC.h"
#import "CellSetting.h"

@interface DeviceFoundVC ()

@property (strong, nonatomic) NSMutableArray *arrDevices;
@property (weak, nonatomic) IBOutlet UITableView *tbl_devicesFound;
@property (strong, nonatomic) IBOutlet CustomButton *btn_back;
@property (strong, nonatomic) IBOutlet CustomButton *btn_continue;
@end

@implementation DeviceFoundVC

- (void)viewDidLoad {
    @try {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    [self.navigationController.navigationBar setHidden:NO];

    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:@"Device Found"];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    
   // self.arrDevices = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBModelDevicesArray]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SerialNo != %@", mHubManagerInstance.objSelectedHub.SerialNo];
    NSArray *arrCmdDataFiltered = [self.arrMhubDevicesFound filteredArrayUsingPredicate:predicate];
    self.arrMhubDevicesFound = [NSMutableArray arrayWithArray:arrCmdDataFiltered];
    [self.tbl_devicesFound reloadData];
    [self.btn_back setTitleColor:[AppDelegate appDelegate].themeColours.colorNormalText forState:UIControlStateNormal];
    [self.btn_back setTitle:HUB_BACK forState:UIControlStateNormal];
    [self.btn_continue setTitleColor:[AppDelegate appDelegate].themeColours.colorNormalText forState:UIControlStateNormal];
   // [self.btn_continue addBorder_Color:[AppDelegate appDelegate].themeColours.colorNormalText BorderWidth:1.0];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(IBAction)ClickOn_BackButton:(id)sender{
   // [self.navigationController popViewControllerAnimated:NO];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SubUnitsVC class]]) {
            [self.navigationController popToViewController:vc animated:false];
        }
    }
}
-(IBAction)ClickOn_continue:(id)sender{
    @try {
       // Hub *objHub = [self.arrMhubDevicesFound objectAtIndex:indexPath.row];
        if(self.objSelectedMHubDevice.Generation != mHubFake){
        if([self.objSelectedMHubDevice isWifiSetup])
        {
            EnthernetOrWifiVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"EnthernetOrWifiVC"];
            objVC.objSelectedMHubDevice = self.objSelectedMHubDevice;
            [self.navigationController pushViewController:objVC animated:YES];
        }
        else{
        SetupDeviceVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupDeviceVC"];
        objVC.objSelectedMHubDevice = self.objSelectedMHubDevice;
        [self.navigationController pushViewController:objVC animated:YES];
        }
        }
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 10;
    @try {
    return self.arrMhubDevicesFound.count;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    @try {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            return heightTableViewRowWithPadding_SmallMobile;
        } else {
            return heightTableViewRowWithPadding;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
    static NSString *CellIdentifier = @"CellSetting";
    
    CellSetting *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
        Hub *objHub = [self.arrMhubDevicesFound objectAtIndex:indexPath.row];
        cell.lblCell.text = objHub.Official_Name;
        cell.lblCell_SubTitle.text =  objHub.Address;
        cell.lblCell.textAlignment = NSTextAlignmentLeft;
        cell.border.backgroundColor = [AppDelegate appDelegate].themeColours.colorNormalText;
        //cell.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorBackground Frame:cell.imgBackground.frame];
        //[cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorTableCellBorder BorderWidth:1.0];
       
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblCell_SubTitle setFont:textFontRegular12];
            [cell.lblCell setFont:textFontBold12];
        } else {
            [cell.lblCell_SubTitle setFont:textFontRegular16];
            [cell.lblCell setFont:textFontBold16];
        }
        
        if([self.objSelectedMHubDevice.Address isEqualToString:objHub.Address]){
            UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
            [cell.imgCell setTintColor:colorGreenCheck];
            [cell.imgCell setImage:image];
            [cell.lblCell setFont:textFontBold16];
            [cell.lblCell setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
            [cell.lblCell_SubTitle setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
            
        }
        else
        {
            [cell.imgCell setImage:nil];
            [cell.lblCell setTextColor:colorMiddleGray_868787];
            [cell.lblCell_SubTitle setTextColor:colorMiddleGray_868787];
        }
        
        //cell.lblCell.text = [objSection.Title uppercaseString];
    return cell;
    
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        self.objSelectedMHubDevice = [self.arrMhubDevicesFound objectAtIndex:indexPath.row];
        [self.tbl_devicesFound reloadData];
//        CellSetting *cell = [self.tbl_devicesFound cellForRowAtIndexPath:indexPath];
//        UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
//        [cell.imgCell setTintColor:[AppDelegate appDelegate].themeColours.colorHeaderText];
//        [cell.imgCell setImage:image];
//        SetupDeviceVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"SetupDeviceVC"];
//        objVC.objSelectedMHubDevice = objHub;
//        [self.navigationController pushViewController:objVC animated:YES];
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

//- (void)tableView:(UITableView *)tableView deselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CellSetting *cell = [self.tbl_devicesFound cellForRowAtIndexPath:indexPath];
//    [cell.imgCell setImage:nil];
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [AppDelegate appDelegate].isSearchNetworkPopVC = true;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
