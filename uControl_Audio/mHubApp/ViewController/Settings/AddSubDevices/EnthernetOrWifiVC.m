//
//  EnthernetOrWifiVC.m
//  mHubApp
//
//  Created by Apple on 05/02/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "EnthernetOrWifiVC.h"
#import "CellSetting.h"

@interface EnthernetOrWifiVC ()
@property (strong, nonatomic) NSMutableArray *arrOptions;
@property (weak, nonatomic) IBOutlet UITableView *tbl_Options;
@property (strong, nonatomic) IBOutlet UIButton *btn_back;
@property (strong, nonatomic) IBOutlet UIButton *btn_continue;
@end

@implementation EnthernetOrWifiVC

- (void)viewDidLoad {
    @try {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    [self.navigationController.navigationBar setHidden:NO];

    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:@"Ethernet Or WiFi"];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lbl_title setFont:textFontBold12];
            [self.lbl_subTitle setFont:textFontRegular12];
        } else {
            [self.lbl_title setFont:textFontBold16];
            [self.lbl_subTitle setFont:textFontRegular16];
        }
    [self.lbl_title setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
    [self.lbl_subTitle setTextColor:colorMiddleGray_868787];
    
    self.arrOptions = [[NSMutableArray alloc] initWithObjects:@"ETHERNET",@"WIFI", nil];
    [self.tbl_Options reloadData];
    [self.btn_back setTitleColor:[AppDelegate appDelegate].themeColours.colorNormalText forState:UIControlStateNormal];
    [self.btn_back setTitle:HUB_BACK forState:UIControlStateNormal];
    [self.btn_continue setTitleColor:[AppDelegate appDelegate].themeColours.colorNormalText forState:UIControlStateNormal];
    //[self.btn_continue addBorder_Color:[AppDelegate appDelegate].themeColours.colorNormalText BorderWidth:1.0];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(IBAction)ClickOn_BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)ClickOn_continue:(id)sender{
    @try {
       // Hub *objHub = [self.arrMhubDevicesFound objectAtIndex:indexPath.row];
        if([self.objSelectedMHubDevice isWifiSetup])
        {
            EnthernetOrWifiVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"EnthernetOrWifiVC"];
            objVC.objSelectedMHubDevice = self.objSelectedMHubDevice;
            [self.navigationController pushViewController:objVC animated:YES];
        }
        else{
        SetupDeviceVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"SetupDeviceVC"];
        objVC.objSelectedMHubDevice = self.objSelectedMHubDevice;
        [self.navigationController pushViewController:objVC animated:YES];
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
    return self.arrOptions.count;
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
        CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.lblCell.text = [self.arrOptions objectAtIndex:indexPath.row];
        cell.lblCell.textAlignment = NSTextAlignmentLeft;
        cell.lblCell.textColor = [AppDelegate appDelegate].themeColours.colorNormalText;
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblCell setFont:textFontSemiBold10];
        } else {
            [cell.lblCell setFont:textFontSemiBold13];
          
        }
        
        //cell.lblCell.text = [objSection.Title uppercaseString];
    return cell;
    
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
       // self.objSelectedMHubDevice = [self.arrMhubDevicesFound objectAtIndex:indexPath.row];
        
        if(indexPath.row == 0)
        {
            SetupDeviceVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupDeviceVC"];
            objVC.objSelectedMHubDevice = self.objSelectedMHubDevice;
            [self.navigationController pushViewController:objVC animated:YES];
        }
        else{
            StartWifiSetupViewController *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"StartWifiSetupViewController"];
            [self.navigationController pushViewController:objVC animated:YES];
        }
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
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
