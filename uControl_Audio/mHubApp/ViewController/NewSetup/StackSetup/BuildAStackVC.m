//
//  BuildAStackVC.m
//  mHubApp
//
//  Created by Rave Digital on 01/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "BuildAStackVC.h"
@import SafariServices;
@interface BuildAStackVC ()


@end

@implementation BuildAStackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_BUILDING_A_STACKED_SYSTEM];
    
    self.lblHeader.text = COMBINE_MULTIPLE_DEVICES;
    self.lblSubHeader.text = COMBINE_MULTIPLE_DEVICES_Message;
    
    
}


- (IBAction)btnHelp_Clicked:(CustomButton_NoBorder *)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://support.hdanywhere.com/help-stacking-devices/"] ;
    
    if ([SFSafariViewController class] != nil) {
        // Use SFSafariViewController
        safariVC = [[SFSafariViewController alloc]initWithURL:url];
        safariVC.delegate = self;
        [self presentViewController:safariVC animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                DDLogError(@"%@%@",@"Failed to open url:",[url description]);
            }
        }];
    }
    
}



- (IBAction)btnStart_Clicked:(CustomButton *)sender {
    SelectMasterControllerVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectMasterControllerVC"];
    objVC.arrSearchData  = self.arrSearchData;
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
