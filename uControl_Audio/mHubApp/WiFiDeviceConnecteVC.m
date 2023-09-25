//
//  WiFiDeviceConnecteVC.m
//  mHubApp
//
//  Created by Rave Digital on 02/02/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "WiFiDeviceConnecteVC.h"

@interface WiFiDeviceConnecteVC ()

@end

@implementation WiFiDeviceConnecteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:WIFI_DEVICE_CONNECTED];
    
    self.lbl_heading.text = [NSString stringWithFormat:WIFI_DEVICE_CONNECTED_heading];
    self.lbl_subHeading.text = [NSString stringWithFormat:WIFI_DEVICE_CONNECTED_subHeading];
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    [self.btn_complete setBackgroundColor:[Utility colorWithHexString:hexString_ProPink]];
    [self.btn_complete addBorder_Color:colorClear BorderWidth:0.0];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lbl_heading setFont:textFontBold12];
        [self.lbl_subHeading setFont:textFontRegular12];

    } else {
        [self.lbl_heading setFont:textFontBold16];
        [self.lbl_subHeading setFont:textFontRegular16];

    }
}

- (IBAction)btn_COMPLETED_Clicked:(UIButton *)sender {
   
    [self.navigationController popToRootViewControllerAnimated:NO];

   
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
