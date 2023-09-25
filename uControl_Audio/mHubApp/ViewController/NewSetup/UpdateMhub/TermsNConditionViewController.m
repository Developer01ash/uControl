//
//  TermsNConditionViewController.m
//  mHubApp
//
//  Created by Rave on 06/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "TermsNConditionViewController.h"
#import "HubUpdatingViewController.h"

@import SafariServices;

@interface TermsNConditionViewController ()
{
    WKWebView *webviewLegal;
    WKWebView *webviewpolicy;
    WKWebView *webviewChangeLog;
    SFSafariViewController *safariVC;
    //SFSafariViewController *safariVC;
    //SFSafariViewController *safariVC;

}

@end

@implementation TermsNConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_TERMSNCONDITION];
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall)  {
        [self.heading setFont:textFontRegular12];
        [self.subHeading setFont:textFontRegular12];
    } else {
        [self.heading setFont:textFontRegular16];
        [self.subHeading setFont:textFontRegular16];
    }
   
    [self.heading setTextColor:colorWhite];
    [self.subHeading setTextColor:colorMiddleGray_868787];
    
    self.heading.text = HUB_TERMS_CONDITION_Heading;
    self.subHeading.text = HUB_TERMS_CONDITION_SubHeading;
   //[self.btn_Iagree addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    
   

}



-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    webviewLegal = [[WKWebView alloc]initWithFrame:self.viewLegal.bounds];
    NSURL *nsUrlLegal=[NSURL URLWithString:URL_EULA];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsUrlLegal];
    [webviewLegal loadRequest:nsrequest];
    webviewLegal.backgroundColor = [UIColor blackColor];
    [self.viewLegal addSubview:webviewLegal];
    
    
    webviewpolicy =[[WKWebView alloc]initWithFrame:CGRectMake(0,0,self.viewPolicy.frame.size.width,self.viewPolicy.frame.size.height)];
    NSURL *nsurlPolicy=[NSURL URLWithString:URL_PRIVACY];
    NSURLRequest *nsrequest2=[NSURLRequest requestWithURL:nsurlPolicy];
    [webviewpolicy loadRequest:nsrequest2];
    webviewpolicy.backgroundColor = [UIColor blackColor];
    
    [self.viewPolicy addSubview:webviewpolicy];
    
    
    webviewChangeLog =[[WKWebView alloc]initWithFrame:CGRectMake(0,0,self.viewLog.frame.size.width,self.viewLog.frame.size.height)];
    NSURL *nsurlLog=[NSURL URLWithString:URL_CHANGELOG];
    NSURLRequest *nsrequestLog=[NSURLRequest requestWithURL:nsurlLog];
    [webviewChangeLog loadRequest:nsrequestLog];
    webviewChangeLog.backgroundColor = [UIColor blackColor];
    
    [self.viewLog addSubview:webviewChangeLog];
    
    
}

- (IBAction)btnEULA_Clicked:(CustomButton *)sender
{
    
    if ([SFSafariViewController class] != nil) {
        // Use SFSafariViewController
        safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:URL_EULA]];
        safariVC.delegate = self;
        [[AppDelegate appDelegate]showHudView:ShowMessage Message:HUB_CONNECTINGTOMHUBOS];
        [self presentViewController:safariVC animated:YES completion:nil];
    } else {
        NSURL *url = [NSURL URLWithString:[[API dashUControlAccessURL] absoluteString]];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                DDLogError(@"%@%@",@"Failed to open url:",[url description]);
            }
        }];
    }
    
}


- (IBAction)btnPrivacy_Clicked:(CustomButton *)sender
{
    if ([SFSafariViewController class] != nil) {
        // Use SFSafariViewController
        safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:URL_PRIVACY]];
        safariVC.delegate = self;
        [[AppDelegate appDelegate]showHudView:ShowMessage Message:HUB_CONNECTINGTOMHUBOS];
        [self presentViewController:safariVC animated:YES completion:nil];
    } else {
        NSURL *url = [NSURL URLWithString:[[API dashUControlAccessURL] absoluteString]];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                DDLogError(@"%@%@",@"Failed to open url:",[url description]);
            }
        }];
    }
    
}


- (IBAction)btnChangeLog_Clicked:(CustomButton *)sender
{
    if ([SFSafariViewController class] != nil) {
        // Use SFSafariViewController
        safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:URL_CHANGELOG]];
        safariVC.delegate = self;
        [[AppDelegate appDelegate]showHudView:ShowMessage Message:HUB_CONNECTINGTOMHUBOS];
        [self presentViewController:safariVC animated:YES completion:nil];
    } else {
        NSURL *url = [NSURL URLWithString:[[API dashUControlAccessURL] absoluteString]];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                DDLogError(@"%@%@",@"Failed to open url:",[url description]);
            }
        }];
    }
    
    
}

- (IBAction)btnIAgree_Clicked:(CustomButton *)sender
{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE_START_UPDATE, nil) message:[NSString stringWithFormat:HUB_MOSUPDATE_WARNING_TERMSANDCONDITION] preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        alertController.view.tintColor = colorWhite;
        NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERT_TITLE];
        [strAttributedTitle addAttribute:NSFontAttributeName
                                   value:textFontRegular13
                                   range:NSMakeRange(0, strAttributedTitle.length)];
        //[alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_UPDATE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            HubUpdatingViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"HubUpdatingViewController"];
            objVC.objSelectedMHubDevice = self.objSelectedMHubDevice;
            objVC.navigateFromType = self.navigateFromType;
            objVC.isSingleUnit = self.isSingleUnit ;
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ISTermsNConditionTrue" ];
            [self.navigationController pushViewController:objVC animated:YES];

        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_CANCEL, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ISTermsNConditionTrue" ];
        }]];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
}
    


- (IBAction)btn_gotoMenu_clicked:(CustomButton *)sender {
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
