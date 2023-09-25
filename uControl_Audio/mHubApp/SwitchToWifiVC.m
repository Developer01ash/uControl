//
//  SwitchToWifiVC.m
//  mHubApp
//
//  Created by Rave Digital on 01/02/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "SwitchToWifiVC.h"

@interface SwitchToWifiVC ()

@end

@implementation SwitchToWifiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:SWITCH_TO_WIFI_HOTSPOT];
    
    self.lbl_heading.text = [NSString stringWithFormat:SWITCH_TO_WIFI_HOTSPOT_heading];
    self.lbl_subHeading.text = [NSString stringWithFormat:SWITCH_TO_WIFI_HOTSPOT_MSG];
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lbl_heading setFont:textFontBold12];
        [self.lbl_subHeading setFont:textFontRegular12];

    } else {
        [self.lbl_heading setFont:textFontBold16];
        [self.lbl_subHeading setFont:textFontRegular16];

    }
    

}

- (void)call100Api
{
    Hub *objHub = [[Hub alloc]init];
    objHub.Address = @"192.168.100.1";
    
    [APIManager getSystemInformationStandalone:objHub completion:^(APIV2Response *responseObject) {
        if (responseObject.error) {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            WiFiErrorVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WiFiErrorVC"];
            objVC.errorType = 3;
            [self.navigationController pushViewController:objVC animated:NO];
           // handler(responseObject);
        } else {
            
            
            ScanForRouterVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"ScanForRouterVC"];
            [self.navigationController pushViewController:objVC animated:NO];
        }
        
    }];
    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
//    [APIManager wifiSetAPMode: updateData:nil completion:^(NSDictionary *responseObject) {
//        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
//        if(responseObject != nil){
//            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
//            //NSLog(@"callSetupAPModeAPI Success  %@",responseObject);
//        }
//        else
//            {
//            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
//            //NSLog(@"callSetupAPModeAPI error  %@",responseObject);
//            }
//    }];
}

- (IBAction)btn_CONNECTED_Clicked:(UIButton *)sender {
    [self call100Api];
//    ScanForRouterVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"ScanForRouterVC"];
//    [self.navigationController pushViewController:objVC animated:NO];

   
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
