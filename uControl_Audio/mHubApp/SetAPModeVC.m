//
//  SetAPModeVC.m
//  mHubApp
//
//  Created by Ashutosh Tiwari on 19/03/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import "SetAPModeVC.h"
#import "StartWifiSetupViewController.h"

@interface SetAPModeVC ()

@end

@implementation SetAPModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:@"Connecting"];

    self.lbl_headingTitle1.text = [NSString stringWithFormat:HUB_SET_AP_MODE_SCREEN_MESSAGE1,self.objSelectedDevice.Address];
    self.lbl_headingTitle2.text = [NSString stringWithFormat:HUB_SET_AP_MODE_SCREEN_MESSAGE2];
    [self.btn_solid addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    [self.btn_flashing addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lbl_headingTitle1 setFont:textFontRegular12];
        [self.lbl_headingTitle2 setFont:textFontRegular12];
    } else {
        [self.lbl_headingTitle1 setFont:textFontRegular16];
        [self.lbl_headingTitle2 setFont:textFontRegular16];
    }

    [self callSetAPModeApi];
}

- (void)callSetAPModeApi
{
    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
    [APIManager wifiSetAPMode:self.objSelectedDevice.Address updateData:nil completion:^(NSDictionary *responseObject) {
        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
        if(responseObject != nil){
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            //NSLog(@"callSetupAPModeAPI Success  %@",responseObject);
        }
        else
            {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            //NSLog(@"callSetupAPModeAPI error  %@",responseObject);
            }
    }];
}

- (IBAction)btnLightsSolid_Clicked:(UIButton *)sender {
    //    WifiConnectedVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WifiConnectedVC"];
    //    [self.navigationController pushViewController:objVC animated:NO];
    StartWifiSetupViewController *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"StartWifiSetupViewController"];
    [self.navigationController pushViewController:objVC animated:YES];
}

- (IBAction)btnLightsFlashing_Clicked:(UIButton *)sender {
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
