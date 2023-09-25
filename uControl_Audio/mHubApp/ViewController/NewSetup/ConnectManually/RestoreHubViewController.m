//
//  RestoreHubViewController.m
//  mHubApp
//
//  Created by Rave on 18/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "RestoreHubViewController.h"

@interface RestoreHubViewController ()

@end

@implementation RestoreHubViewController

//static void extracted(RestoreHubViewController *object) {
//    [object.btn_goBack addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;

    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_RESTORE_MHUB];
   // extracted(self);
    self.lbl_restoreWarning.text   = HUB_RESTORE_HUB_WARNING_Message_Header;
    [self.view_roundView addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        self.constraint_heightCenterUIView.constant  = 90.0;
        [self.view_roundView addRoundedCorner_CornerRadius:45];
        [self.lbl_restoreWarning setFont:textFontRegular12];
        [self.lbl_titleWarning setFont:textFontBold12];
//        [self.btn_goBack.titleLabel setFont:textFontRegular12];
//        [self.btn_restoreMhub.titleLabel setFont:textFontBold12];
//        [self.btn_MAINMENU.titleLabel setFont:textFontBold12];
    } else {
        self.constraint_heightCenterUIView.constant  = 120.0;
        [self.view_roundView addRoundedCorner_CornerRadius:60];
        [self.lbl_restoreWarning setFont:textFontRegular16];
        [self.lbl_titleWarning setFont:textFontBold16];
//        [self.btn_goBack.titleLabel setFont:textFontRegular16];
//        [self.btn_restoreMhub.titleLabel setFont:textFontBold16];
//        [self.btn_MAINMENU.titleLabel setFont:textFontBold16];
    }
    //[self.view_roundView addRoundedCorner_CornerRadius:self.view_roundView.frame.size.width/2];
}



- (IBAction)btn_RestoreMhub_Clicked:(CustomButton *)sender
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE_Restore_MHUB, nil) message:[NSString stringWithFormat:HUB_RESTORE_HUB_WARNING] preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = colorGray_646464;
    NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERT_TITLE];
    [strAttributedTitle addAttribute:NSFontAttributeName
                               value:textFontRegular13
                               range:NSMakeRange(0, strAttributedTitle.length)];
    //[alertController setValue:strAttributedTitle forKey:@"attributedTitle"];

    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_RESTORE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self restoreMhub:self.objSelectedMHubDevice];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_GOBACK, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:NO];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (IBAction)btn_goBack_clicked:(CustomButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btn_MAINMENU_clicked:(CustomButton *)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ManuallySetupVC class]]) {
            [self.navigationController popToViewController:vc animated:false];
        }
    }
}


-(void)restoreMhub:(Hub *)selectedHubObj
{
     @try {
    [[AppDelegate appDelegate]showHudView:ShowIndicator Message:@"" ];
    [APIManager resetMhubSetting:selectedHubObj.Address completion:^(APIV2Response *responseObject) {
        if (responseObject.error) {
            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
            [self.img_restoreSuccess_YES_NO setImage:kImageIconNO] ;
            [self.btn_restoreMhub setHidden:NO];
            [self.btn_MAINMENU setHidden:YES];
        } else {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            selectedHubObj.BootFlag = false;
            selectedHubObj.isPaired = false;
            selectedHubObj.PairingDetails = [[Pair alloc] init];
            self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_MHUB_RESET_SUCCESSFUL];
            self.lbl_restoreWarning.text   = HUB_RESTORE_HUB_Success_Message;
            [self.img_restoreSuccess_YES_NO setImage:kImage_HDA_icon_setup_done_small] ;
            [self.btn_restoreMhub setHidden:YES];
            [self.btn_MAINMENU setHidden:NO];
            
        }
    }];
     } @catch(NSException *exception) {
         [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
     }
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
