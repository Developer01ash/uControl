//
//  WifiSetupInstructionViewController.m
//  mHubApp
//
//  Created by Ashutosh Tiwari on 19/12/19.
//  Copyright © 2019 Rave Infosys. All rights reserved.
//

#import "WifiSetupInstructionViewController.h"
#import "FGRoute.h"
@interface WifiSetupInstructionViewController ()

@end

@implementation WifiSetupInstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:CONNECT_TO_HDA_DEVICE];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    self.lbl_title1.text = WIFI_Settings_Instruction;
    if ([AppDelegate appDelegate].deviceType == mobileSmall)  {
        [self.lbl_title1 setFont:textFontRegular12];
        
//        [self.btn_continue.titleLabel setFont:textFontBold10];
//        [self.btn_settings.titleLabel setFont:textFontBold10];

        
    } else {
        [self.lbl_title1 setFont:textFontRegular16];
//        [self.btn_continue.titleLabel setFont:textFontBold13];
//        [self.btn_settings.titleLabel setFont:textFontBold13];
    }
    
//    [self.btn_continue addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
//    [self.btn_settings addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
}

- (IBAction)btnGOTOSettings:(UIButton *)sender {
    NSURL *urlStr = [[NSURL alloc]initWithString:UIApplicationOpenSettingsURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
        [[UIApplication sharedApplication] openURL:urlStr];
    }
}


- (IBAction)btnContinue_Clicked:(UIButton *)sender {
    ConnectedWifiViewController *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"ConnectedWifiViewController"];
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
