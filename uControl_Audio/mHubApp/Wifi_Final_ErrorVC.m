//
//  Wifi_Final_ErrorVC.m
//  mHubApp
//
//  Created by Rave Digital on 02/02/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "Wifi_Final_ErrorVC.h"

@interface Wifi_Final_ErrorVC ()

@end

@implementation Wifi_Final_ErrorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = true;
    
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:Wifi_Error_Final];
        self.lbl_heading.text = [NSString stringWithFormat:Wifi_Error_Final_Heading1];
        self.lbl_subHeading.text = [NSString stringWithFormat:Wifi_Error_Final_subHeading1];
        
    
        self.lbl_heading2.text = [NSString stringWithFormat:Wifi_Error_Final_Heading2];
        self.lbl_subHeading2.text = [NSString stringWithFormat:Wifi_Error_Final_subHeading2];
   
        self.lbl_heading3.text = [NSString stringWithFormat:Wifi_Error_Final_Heading3];
        self.lbl_subHeading3.text = [NSString stringWithFormat:Wifi_Error_Final_subHeading3];

    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
  //  [self.btn_Start addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lbl_heading setFont:textFontBold12];
        [self.lbl_heading2 setFont:textFontBold12];
        [self.lbl_heading3 setFont:textFontBold12];
        [self.lbl_subHeading setFont:textFontRegular12];
        [self.lbl_subHeading2 setFont:textFontRegular12];
        [self.lbl_subHeading3 setFont:textFontRegular12];

    } else {
        [self.lbl_heading setFont:textFontBold16];
        [self.lbl_heading2 setFont:textFontBold16];
        [self.lbl_heading3 setFont:textFontBold16];
        [self.lbl_subHeading setFont:textFontRegular16];
        [self.lbl_subHeading2 setFont:textFontRegular16];
        [self.lbl_subHeading3 setFont:textFontRegular16];

    }
}

- (IBAction)btn_TRYAGAIN_Clicked:(UIButton *)sender {
 
  
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
