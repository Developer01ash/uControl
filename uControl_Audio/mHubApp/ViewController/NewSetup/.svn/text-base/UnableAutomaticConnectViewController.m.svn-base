//
//  UnableAutomaticConnectViewController.m
//  mHubApp
//
//  Created by Rave on 20/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "UnableAutomaticConnectViewController.h"

@interface UnableAutomaticConnectViewController ()

@end

@implementation UnableAutomaticConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UNABLE_TO_AUTOMATICALLY_CONNECT];
    
    [self.btn_searchAgain addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    
    
    
    self.lbl_instructionToConnect.text   = HUB_UNABLE_TO_AUTO_CONNECT_MESSAGE;
    
    [self.view_roundView addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        
        self.constraint_heightCenterUIView.constant  = 80.0;
        [self.view_roundView addRoundedCorner_CornerRadius:40];
    } else {
        
        self.constraint_heightCenterUIView.constant  = 100.0;
        [self.view_roundView addRoundedCorner_CornerRadius:50];
    }
    
    
    //[self.view_roundView addRoundedCorner_CornerRadius:self.view_roundView.frame.size.width/2];
    
}



- (IBAction)btnConnectManually_Clicked:(UIButton *)sender {
   [self.navigationController popViewControllerAnimated:NO];
}



- (IBAction)btn_goBack_clicked:(CustomButton *)sender {
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
