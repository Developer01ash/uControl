//
//  ConnectToRouterVC.m
//  mHubApp
//
//  Created by Ashutosh Tiwari on 20/12/19.
//  Copyright © 2019 Rave Infosys. All rights reserved.
//

#import "ConnectToRouterVC.h"

@interface ConnectToRouterVC ()

@end

@implementation ConnectToRouterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:@"Enter SSID Password"];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
   
    [_btn_joinNetwork addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    [_txtField_password addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    NSString *str = [NSString stringWithFormat:@"Please enter the password for %@.",_SSIDNameStr];
    [self.lbl_heading setText:str];
    
    ThemeColor *objTheme = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColoursSetup];
    [self.txtField_password setBackgroundColor:colorClear];
    [self.txtField_password setTextColor:colorWhite];
    [self.txtField_password addBorder_Color:objTheme.colorHeaderText BorderWidth:1.0];
    self.txtField_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Password" attributes:@{NSForegroundColorAttributeName: objTheme.colorHeaderText}];
   

}


- (IBAction)btnJoinNetwork_Clicked:(UIButton *)sender {
    
    JoinNetworkVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"JoinNetworkVC"];
    objVC.SSIDNameStr = self.SSIDNameStr;
    objVC.passwordStr = self.txtField_password.text;
    objVC.encryptionNameStr = self.encryptionNameStr;
    [self.navigationController pushViewController:objVC animated:NO];


}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
