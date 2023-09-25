//
//  StartWifiSetupViewController.m
//  mHubApp
//
//  Created by Ashutosh Tiwari on 19/12/19.
//  Copyright © 2019 Rave Infosys. All rights reserved.
//

#import "StartWifiSetupViewController.h"

@interface StartWifiSetupViewController ()

@end

@implementation StartWifiSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.btn_start addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:configure_wifi];
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lbl_header setFont:textFontBold12];
        [self.lbl_subHeader setFont:textFontRegular12];
    } else {
        [self.lbl_header setFont:textFontBold16];
        [self.lbl_subHeader setFont:textFontRegular16];
    }

}
- (IBAction)btnStartSetup_Clicked:(UIButton *)sender {
        WifiSetupInstructionViewController *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WifiSetupInstructionViewController"];
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
