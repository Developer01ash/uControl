//
//  WifiDiscoveryModeVC.m
//  mHubApp
//
//  Created by Rave Digital on 31/01/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "WifiDiscoveryModeVC.h"

@interface WifiDiscoveryModeVC ()

@end

@implementation WifiDiscoveryModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:DISCOVERY_MODE];
    
    self.lbl_heading.text = [NSString stringWithFormat:WIFI_POWER_LED_SHOULD_FLASHING];
    self.lbl_subHeading.text = [NSString stringWithFormat:WIFI_POWER_LED_SHOULD_FLASHING_msg];
    
    
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
    if(_modelType != mHub411){
    [self callSetAPModeApi];
    }
}

- (void)callSetAPModeApi
{
   // [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
    [APIManager wifiSetAPMode:self.objSelectedMHubDevice.Address updateData:nil completion:^(NSDictionary *responseObject) {
        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
        if(responseObject != nil){
            //[[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            //NSLog(@"callSetupAPModeAPI Success  %@",responseObject);
        }
        else
            {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                WiFiErrorVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WiFiErrorVC"];
                objVC.errorType = 1;
                [self.navigationController pushViewController:objVC animated:NO];
            }
    }];
}

- (IBAction)btnFLASHING_Clicked:(UIButton *)sender {
    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
    RemoveEthernetCableVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"RemoveEthernetCableVC"];
    objVC.objSelectedMHubDevice =  self.objSelectedMHubDevice;
    [self.navigationController pushViewController:objVC animated:NO];
}

- (IBAction)btnSOLID_Clicked:(UIButton *)sender {
    WiFiErrorVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WiFiErrorVC"];
    objVC.errorType = 2;
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
