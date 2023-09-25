//
//  ConnectedWifiViewController.m
//  mHubApp
//
//  Created by Ashutosh Tiwari on 19/12/19.
//  Copyright © 2019 Rave Infosys. All rights reserved.
//

#import "ConnectedWifiViewController.h"
#import "ScanForRouterVC.h"
@interface ConnectedWifiViewController ()

@end

@implementation ConnectedWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.btn_continue addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;

    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:@"Connect To Device"];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    self.lbl_title.text = Connected_WIFI;
     if ([AppDelegate appDelegate].deviceType == mobileSmall)  {
         [self.lbl_title setFont:textFontBold12];
         [self.wifiNameBtn.titleLabel setFont:textFontRegular12];
         
     } else {
         [self.lbl_title setFont:textFontBold16];
         [self.wifiNameBtn.titleLabel setFont:textFontRegular16];
     }
    //NSLog(@"Is connected via wifi - %s", [FGRoute isWifiConnected] ? "YES" : "NO");
    //NSLog(@"Wifi Route ip is - %@", [FGRoute getGatewayIP]);
    //NSLog(@"Ip Address - %@ ssid%@ %@ %@", [FGRoute getIPAddress],[FGRoute getSSID],[FGRoute getBSSID],[FGRoute getSSIDDATA]);
    if([[FGRoute getSSID] containsString:@"HDA"] || [[FGRoute getSSID] containsString:@"hda"]){
    [self.wifiNameBtn setTitle:[FGRoute getSSID] forState:UIControlStateNormal];
    }
    else
    {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No HDA device found" message:@"Please check if you have enabled discovery mode?" preferredStyle:UIAlertControllerStyleAlert];
                alertController.view.tintColor = colorGray_646464;
                NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERT_TITLE];
                [strAttributedTitle addAttribute:NSFontAttributeName
                                           value:textFontRegular13
                                           range:NSMakeRange(0, strAttributedTitle.length)];
                [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_OK, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];

                }]];
                [self presentViewController:alertController animated:YES completion:nil];
        }



    //[self fetchSSIDInfo];
}

 -(NSString*)fetchSSIDInfo {

    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();

    NSDictionary *info;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            //NSLog(@"wifi info: bssid: %@, ssid:%@, ssidData: %@", [info objectForKey:@"BSSID"],[info objectForKey:@"SSID"],[info objectForKey:@"SSIDDATA"]);
            return [info objectForKey:@"SSID"];
            break;
        }
    }

    return @"No WiFi Available";
}
////NSLog[@"wifi info: bssid: %@, ssid:%@, ssidData: %@", info[@"BSSID"], info[@"SSID"], info[@"SSIDDATA"]];

- (IBAction)btnTestConnection_Clicked:(UIButton *)sender {



    [APIManager getWifiModeDetails:[FGRoute getGatewayIP] updateData:nil completion:^(NSDictionary *responseObject) {
         if(responseObject != nil){
            //NSLog(@"btnTestConnection_Clicked Success  %@",responseObject);
                 ScanForRouterVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"ScanForRouterVC"];
                 [self.navigationController pushViewController:objVC animated:NO];
        }
        else
        {
            //NSLog(@"btnTestConnection_Clicked error  %@",responseObject);
        }
    }];



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
