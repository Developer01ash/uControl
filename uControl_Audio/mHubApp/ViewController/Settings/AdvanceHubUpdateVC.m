//
//  AdvanceHubUpdateVC.m
//  mHubApp
//
//  Created by Rave on 22/10/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "AdvanceHubUpdateVC.h"

@interface AdvanceHubUpdateVC ()
{
    NSInteger intSecondsCount ;
    NSTimer *timerMOSUpdate;
    
}

@end

@implementation AdvanceHubUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_ADVANCEMOSUPDATE_HEADER];
    [self.btnReturnToUcontrol setHidden:YES];
    [self.view_updateTimer setHidden:YES];
    intSecondsCount = 120;
    
}
;
-(void) viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        //self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
        // self.viewSetupTypeBG.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
        //self.view_updateTimer.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
        
        [self.lblHeaderMessage setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
        [self.lblHeaderMessage setText:HUB_ADVANCEMOSUPDATE_MESSAGE_WARNING_MERGED];
        
        [self.lblMOSUpdatingHeaderMessage setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
        [self.lblMOSUpdatingHeaderMessage setText:HUB_UPDATING_MESSAGE];
        // [self.btnForceUpdate setTitleColor:[AppDelegate appDelegate].themeColours.colorSettingControlBorder forState:UIControlStateNormal];
        // [self.btnReturnToUcontrol setTitleColor:[AppDelegate appDelegate].themeColours.colorSettingControlBorder forState:UIControlStateNormal];
        
        
        
        
        [self.btnForceUpdate setBackgroundColor:[AppDelegate appDelegate].themeColoursSetup.colorNavigationBar];
        [self.btnReturnToUcontrol setBackgroundColor:[AppDelegate appDelegate].themeColoursSetup.colorNavigationBar];
        
        
        self.btnForceUpdate.layer.borderWidth = 1.0f;
        
        self.btnReturnToUcontrol.layer.borderWidth = 1.0f;
        //self.btnReturnToUcontrol.layer.borderColor = [AppDelegate appDelegate].themeColours.colorTableCellBorder.CGColor;
        // self.btnForceUpdate.layer.borderColor = [AppDelegate appDelegate].themeColours.colorTableCellBorder.CGColor;
        self.btnForceUpdate.layer.borderColor = [UIColor whiteColor].CGColor;
        self.btnReturnToUcontrol.layer.borderColor = [UIColor whiteColor].CGColor;
        
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lblHeaderMessage setFont:textFontRegular12];
            [self.lblMOSUpdatingHeaderMessage setFont:textFontRegular12];
            
            [self.lbl_secondsRemaining setFont:textFontRegular12];
            [self.lbl_runningSeconds setFont:textFontMedium40];
            
            [self.btnForceUpdate.titleLabel setFont:textFontRegular12];
            [self.btnReturnToUcontrol.titleLabel setFont:textFontRegular12];
            
        } else {
            [self.lblHeaderMessage setFont:textFontRegular18];
            [self.lblMOSUpdatingHeaderMessage setFont:textFontRegular18];
            [self.lbl_secondsRemaining setFont:textFontRegular18];
            [self.lbl_runningSeconds setFont:textFontMedium80];
            [self.btnForceUpdate.titleLabel setFont:textFontRegular18];
            [self.btnReturnToUcontrol.titleLabel setFont:textFontRegular18];
            
        }
        
        [[AppDelegate appDelegate] setShouldRotate:NO];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewWillLayoutSubviews {
    @try {
        [super viewWillLayoutSubviews];
        //[self.btnSetupTypeVideo addRoundedCorner_CornerRadius:self.btnSetupTypeVideo.frame.size.height/2];
        /// [self.btnSetupTypeAudio addRoundedCorner_CornerRadius:self.btnSetupTypeAudio.frame.size.height/2];
        /// [self.btnSetupTypeVideoAudio addRoundedCorner_CornerRadius:self.btnSetupTypeVideoAudio.frame.size.height/2];
        [self.view layoutIfNeeded];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
        // [self.btnSetupTypeVideo addRoundedCorner_CornerRadius:self.btnSetupTypeVideo.frame.size.height/2];//
        // [self.btnSetupTypeAudio addRoundedCorner_CornerRadius:self.btnSetupTypeAudio.frame.size.height/2];
        // [self.btnSetupTypeVideoAudio addRoundedCorner_CornerRadius:self.btnSetupTypeVideoAudio.frame.size.height/2];
        [self.view layoutIfNeeded];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
- (IBAction)btnForceUpdate_Clicked:(CustomButton *)sender{
    
    
    @try {
        timerMOSUpdate =  [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(callAPIFORMOSUPDATE)
                                                         userInfo:nil
                                                          repeats:YES];
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:HUB_CONNECTING];      
        
       // [self apiMethod];
        [APIManager getFORCEMOSUpdate:mHubManagerInstance.objSelectedHub updateData:@"mhub_update:true" completion:^(APIResponse *responseObject){
        }];
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATING_HEADER];
        [self.btnReturnToUcontrol setHidden:YES];
        [self.view_updateTimer setHidden:NO];
        [self.btnForceUpdate setHidden:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)apiMethod{
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.1.16/api/mhub_dash_updater.cgi"]];
    [req setHTTPMethod:@"POST"];
    NSData *postData = [@"mhub_update:true" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [req addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:req
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                // Do something with response data here - convert to JSON, check if error exists, etc....
                                               // //NSLog(@"apiMethod response %@",response);
                                            }];
    [task resume];
}
- (IBAction)btnReturnToUcontrol:(CustomButton *)sender{
    // Done button pressed
    @try {
        [self.navigationController popViewControllerAnimated:YES];
        
        if (mHubManagerInstance.objSelectedHub.Generation != mHub4KV3) {
            [[AppDelegate appDelegate] alertControllerReSyncUControlConfirmation];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
    
}




-(void)callAPIFORMOSUPDATE {
    @try {
        
        
        intSecondsCount = intSecondsCount - 1;
        self.lbl_runningSeconds.text = [NSString stringWithFormat:@"%ld", (long)intSecondsCount];
        if (intSecondsCount > 0 ) {
            
            
            
            
        }
        else{
            intSecondsCount = 120;
            [timerMOSUpdate invalidate];
            [self.btnReturnToUcontrol setHidden:NO];
            [self.view_updateTimer setHidden:YES];
            [self.btnForceUpdate setHidden:YES];
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            self.navigationItem.backBarButtonItem = customBackBarButton;
            self.navigationItem.hidesBackButton =  NO;
            self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATED_HEADER];
        }
    } @catch (NSException *exception) {
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
