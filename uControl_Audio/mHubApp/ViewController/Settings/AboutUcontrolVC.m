//
//  AboutUcontrolVC.m
//  mHubApp
//
//  Created by Apple on 23/07/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "AboutUcontrolVC.h"

@interface AboutUcontrolVC ()

@end

@implementation AboutUcontrolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:@"About uControl"];
    
    [self.lblAppVersion setTextColor:colorMiddleGray_868787];
    [self.lblSerialNo setTextColor:colorMiddleGray_868787];
    [self.lblMOSVersion setTextColor:colorMiddleGray_868787];
    [self.lblAppVersion_value setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
    [self.lblSerialNo_value setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
    [self.lblMOSVersion_value setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblAppVersion setFont:textFontBold12];
        [self.lblSerialNo setFont:textFontBold12];
        [self.lblMOSVersion setFont:textFontBold12];
        [self.lblAppVersion_value setFont:textFontRegular12];
        [self.lblSerialNo_value setFont:textFontRegular12];
        [self.lblMOSVersion_value setFont:textFontRegular12];
    } else {
        [self.lblAppVersion setFont:textFontRegular18];
        [self.lblSerialNo setFont:textFontRegular18];
        [self.lblMOSVersion setFont:textFontRegular18];
        [self.lblAppVersion_value setFont:textFontBold18];
        [self.lblSerialNo_value setFont:textFontBold18];
        [self.lblMOSVersion_value setFont:textFontBold18];
    }
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString * versionBuildString = [NSString stringWithFormat:@"v.%@.%@", appVersionString, appBuildString];
    [self.lblAppVersion_value setText:versionBuildString];
    self.lblSerialNo_value.text = mHubManagerInstance.objSelectedHub.SerialNo;
    self.lblMOSVersion_value.text = [NSString stringWithFormat:@"%.2f", mHubManagerInstance.objSelectedHub.mosVersion];
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
