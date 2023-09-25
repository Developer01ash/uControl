//
//  WiFiErrorVC.m
//  mHubApp
//
//  Created by Rave Digital on 02/02/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "WiFiErrorVC.h"

@interface WiFiErrorVC ()

@end

@implementation WiFiErrorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = true;
    if(_errorType == 1){
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:Wifi_Error_E1];
        self.lbl_heading.text = [NSString stringWithFormat:Wifi_Error_E1_Heading];
        self.lbl_subHeading.text = [NSString stringWithFormat:Wifi_Error_E1_subHeading];
        
    }
    else  if(_errorType == 2){
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:Wifi_Error_E2];
        self.lbl_heading.text = [NSString stringWithFormat:Wifi_Error_E2_Heading];
        self.lbl_subHeading.text = [NSString stringWithFormat:Wifi_Error_E2_subHeading];
    }
    else {
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:Wifi_Error_E3];
        self.lbl_heading.text = [NSString stringWithFormat:Wifi_Error_E3_Heading];
        self.lbl_subHeading.text = [NSString stringWithFormat:Wifi_Error_E3_subHeading];
    }
    
    
    

    
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
}

- (IBAction)btn_TRYAGAIN_Clicked:(UIButton *)sender {
 
  
    [self.navigationController popViewControllerAnimated:NO];
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
