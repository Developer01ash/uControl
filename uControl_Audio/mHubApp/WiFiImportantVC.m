//
//  WiFiImportantVC.m
//  mHubApp
//
//  Created by Rave Digital on 28/01/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "WiFiImportantVC.h"

@interface WiFiImportantVC ()

@end

@implementation WiFiImportantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:IMPORTANT];
    
    
    
    if(_modelType == mHub411){
        [self.lbl_subHeading1 setHidden:NO];
        [self.lbl_subHeading2 setHidden:YES];
       
        [self.btn_Advance setHidden:YES];
        self.btn_Advance_height.constant = 0;
        
        self.lbl_heading.text = [NSString stringWithFormat:enable_discovery_mode];
        self.lbl_subHeading.text = [NSString stringWithFormat:WIFI_Discovery_Mode_Msg2];
        self.lbl_subHeading1.text = [NSString stringWithFormat:WIFI_Discovery_Mode_Msg3];
       // self.lbl_subHeading2.text = [NSString stringWithFormat:WIFI_Discovery_Mode_Msg3];
    }
    else{
        [self.lbl_subHeading1 setHidden:YES];
        [self.lbl_subHeading2 setHidden:YES];
        [self.btn_Advance setHidden:NO];
        self.lbl_heading.text = [NSString stringWithFormat:WIFI_ETHERNET_CABLE_CONNECTED];
        self.lbl_subHeading.text = [NSString stringWithFormat:WIFI_ENABLE_DISCOVERY_MODE];
    }
    

    
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
  //  [self.btn_Start addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lbl_heading setFont:textFontBold12];
        [self.lbl_subHeading setFont:textFontRegular12];
        [self.lbl_subHeading1 setFont:textFontRegular12];
        [self.lbl_subHeading2 setFont:textFontRegular12];

    } else {
        [self.lbl_heading setFont:textFontBold16];
        [self.lbl_subHeading setFont:textFontRegular16];
        [self.lbl_subHeading1 setFont:textFontRegular16];
        [self.lbl_subHeading2 setFont:textFontRegular16];

    }
}

- (IBAction)btnSTART_Clicked:(UIButton *)sender {
    if(_modelType == mHub411){
        
        [AppDelegate appDelegate].isSearchNetworkPopVC = false;
        WifiDiscoveryModeVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WifiDiscoveryModeVC"];
        objVC.modelType = self.modelType;
        //objVC.objSelectedMHubDevice =  objHub;
        [self.navigationController pushViewController:objVC animated:YES];
    }else{
    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
    SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
    objVC.isManuallyConnectNavigation =  true;
    [AppDelegate appDelegate].systemType = HDA_SetupANewMHUBSystem;
    objVC.navigateFromType =  self.navigateFromType;
    [self.navigationController pushViewController:objVC animated:NO];
    }
}

- (IBAction)btnADVANCE_Clicked:(UIButton *)sender {
    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
    EnterIPAddressManuallyUpdateFlowVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"EnterIPAddressManuallyUpdateFlowVC"];
    objVC.navigateFromType =  menu_Wifi;
    [AppDelegate appDelegate].systemType = HDA_ConnectManually;
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
