//
//  WifiConnectedVC.m
//  mHubApp
//
//  Created by Ashutosh Tiwari on 03/01/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import "WifiConnectedVC.h"

@interface WifiConnectedVC ()

@end

@implementation WifiConnectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:PERFORMING_CHECKS];
    // Do any additional setup after loading the view.
    self.lbl_heading.text = [NSString stringWithFormat:PERFORMING_CHECKS_WIFI_CONNECTED_heading];
    self.lbl_subHeading.text = [NSString stringWithFormat:PERFORMING_CHECKS_WIFI_CONNECTED_subHeading];
    self.lbl_subHeading2.text = [NSString stringWithFormat:PERFORMING_CHECKS_WIFI_CONNECTED_subHeading2];
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lbl_heading setFont:textFontBold12];
        [self.lbl_subHeading setFont:textFontRegular12];
        [self.lbl_subHeading2 setFont:textFontRegular12];

    } else {
        [self.lbl_heading setFont:textFontBold16];
        [self.lbl_subHeading setFont:textFontRegular16];
        [self.lbl_subHeading2 setFont:textFontRegular16];

    }
    
}


- (IBAction)btnConnectToDevice_Clicked:(UIButton *)sender {
      //  [self.navigationController popToRootViewControllerAnimated:false];
    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
    SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
    objVC.isManuallyConnectNavigation =  true;
    [AppDelegate appDelegate].systemType = HDA_SetupANewMHUBSystem;
    objVC.navigateFromType =  menu_wifi_device_connected;
    [self.navigationController pushViewController:objVC animated:NO];
}

- (IBAction)btnMAINMENU_Clicked:(UIButton *)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
    if ([vc isKindOfClass:[WifiSubMenuVC class]]) {
        [self.navigationController popToViewController:vc animated:false];
    }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
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
