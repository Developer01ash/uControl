//
//  RemoveEthernetCableVC.m
//  mHubApp
//
//  Created by Rave Digital on 31/01/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "RemoveEthernetCableVC.h"

@interface RemoveEthernetCableVC ()

@end

@implementation RemoveEthernetCableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:REMOVE_ETHERNET_CABLE];
    
    self.lbl_heading.text = [NSString stringWithFormat:REMOVE_ETHERNET_CABLE_FROM_DEVICE];
    self.lbl_subHeading.text = [NSString stringWithFormat:REMOVE_ETHERNET_CABLE_FROM_DEVICE_MSG];

    
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
  //  [self.btn_Start addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lbl_heading setFont:textFontBold12];
        [self.lbl_subHeading setFont:textFontRegular12];

    } else {
        [self.lbl_heading setFont:textFontBold16];
        [self.lbl_subHeading setFont:textFontRegular16];

    }
}


- (IBAction)btn_ETHERNET_REMOVED_Clicked:(UIButton *)sender {
 
    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
    SwitchToWifiVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"SwitchToWifiVC"];
    objVC.objSelectedMHubDevice =  self.objSelectedMHubDevice;
    [self.navigationController pushViewController:objVC animated:NO];
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
