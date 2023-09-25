//
//  HubUpdatingViewController.m
//  mHubApp
//
//  Created by Rave on 12/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "HubUpdatingViewController.h"
#import "UpdateAvailableViewController.h"
#import "SetupConfirmationVC.h"
#import "UpdateAvailableViewController.h"
#import "UpdateHubViewController.h" 
#import "ManuallySetupVC.h"
#import "SubSettingsVC.h"

typedef void(^myCompletion)(BOOL);

@interface HubUpdatingViewController ()
{
    NSTimer *timerObj;
    NSInteger timerSeconds_value;
    NSInteger timer20Seconds_value;
    NSDictionary *dict_upgradeDetails;

}
@end

@implementation HubUpdatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.btn_finished setHidden:YES];
    [self.btn_finished setBackgroundColor:[Utility colorWithHexString:hexString_ProPink]];
    //[self.btn_finished addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    
    self.navigationItem.hidesBackButton = true;
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATING_HEADER];
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall)  {
        [self.lblHeaderMessage setFont:textFontRegular12];
        [self.lblSubHeaderMessage setFont:textFontRegular12];
        
    } else {
        [self.lblHeaderMessage setFont:textFontRegular16];
        [self.lblSubHeaderMessage setFont:textFontRegular16];
    }
    [self.lblHeaderMessage setTextColor:colorMiddleGray_868787];
    [self.lblSubHeaderMessage setTextColor:colorMiddleGray_868787];
   
    
    [self.view_roundView addBorder_Color:[UIColor colorWithRed:119.0/255.0  green:200.0/255.0 blue:219.0/255.0 alpha:1.0] BorderWidth:5.0];
    [self.view_roundView addRoundedCorner_CornerRadius:self.view_roundView.frame.size.width/2];
//    if(self.objSelectedMHubDevice.MHub_LatestVersion > 0)
//    {
//         self.lbl_HubVersion.text = [NSString stringWithFormat:@"%f",self.objSelectedMHubDevice.APP_BenchMarkVersion];
//    }
//    else
//    {
//      //self.lbl_HubVersion.text = [NSString stringWithFormat:@"%f",self.objSelectedMHubDevice.APP_BenchMarkVersion];
//    }
    [[AppDelegate appDelegate]showHudView:ShowIndicator Message:@""];
    self.lbl_HubVersion.text = [NSString stringWithFormat:@"%.02f",self.objSelectedMHubDevice.MHub_LatestVersion];
    [APIManager getFORCEMOSUpdate:self.objSelectedMHubDevice updateData:@"mhub_update:true" completion:^(APIResponse *responseObject){
    }];
    [self.img_loadingProgress setHidden:YES];
    [self.view_roundView setHidden:YES];
//    CABasicAnimation *rotate;
//    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    rotate.fromValue = [NSNumber numberWithFloat:0];
//    rotate.toValue = [NSNumber numberWithFloat:10.0];
//    rotate.duration = 120.0;
//    rotate.repeatCount = 120.0;
//    [self.img_loadingProgress.layer addAnimation:rotate forKey:@"10"];
    
    //[self performSelector:@selector(stopRotation) withObject:nil afterDelay:180.0];
    timerSeconds_value = 0;
    timer20Seconds_value = 0;
    
    timerObj = [NSTimer scheduledTimerWithTimeInterval: 1.0
                          target: self
                          selector:@selector(timerCalled:)
                          userInfo: nil repeats:YES];
   
 
}
-(void)timerCalled:(NSTimer *)timer
{
     NSLog(@"Timer Called %ld %ld",timerSeconds_value,timer20Seconds_value);
     // Your Code
    timerSeconds_value = timerSeconds_value +  1;
    if(timerSeconds_value < 181)
    {
       
    
    if(timerSeconds_value > 60)
    {
        if(timer20Seconds_value == 0){
            [self call_DashUpgrade_JSON];
        }
        else{
        if(timer20Seconds_value > 20){
            timer20Seconds_value = 1;
            [self call_DashUpgrade_JSON];
        }
        }
        timer20Seconds_value = timer20Seconds_value +  1;
    }
}
    else
        
    {
        [self.btn_finished setHidden:NO];
        [self callAlert];
        [[AppDelegate appDelegate]hideHudView:HideIndicator Message:@""];
       
        [self->timerObj invalidate];
        self->timerObj = nil;
    }
   
    
}

-(void)stopRotation
{
    //[self fileAllDetails];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_COMPLETED];
    [self.img_loadingProgress setHidden:YES];
    [self.btn_finished setHidden:NO];
    
}

#pragma mark - REST API methods


-(void)call_DashUpgrade_JSON

{
    @try {
        //[[AppDelegate appDelegate]showHudView:ShowIndicator Message:@"Checking For Updates" ];
        [APIManager getDashUpgrade_JSON:self.objSelectedMHubDevice updateData:nil completion:^(APIV2Response *objResponse) {
            if(objResponse.error){
                // [self call_DashUpgradeApi];
                NSLog(@"ERROR: Dash_upgrade JSON %@ @",objResponse.data_description);
                NSLog(@"timerSeconds_value %ld @",self->timerSeconds_value);
                //[[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@"No Update Available"];
                //[self.navigationController popViewControllerAnimated:YES];
//                if(self->timerSeconds_value > 180)
//                {
//                    
//                    NSLog(@"timerSeconds_value %ld @",self->timerSeconds_value);
//                }
            }
            else
            {
                [[AppDelegate appDelegate]hideHudView:HideIndicator Message:@""];
                
                //  self->mArr_upgradeDetails  =  (NSMutableArray *)objResponse;
                self->dict_upgradeDetails = (NSDictionary *)objResponse.data_description;
                NSLog(@"dash  upgrade JSON %@ ",objResponse.data_description);
                //NSLog(@"Success: dash  upgrade JSON %@ and dict %@",self->mArr_upgradeDetails,[self->dict_upgradeDetails objectForKey:@"version"]);
                
                if ([[Utility checkNullForKey:kLABEL_UPGRADE Dictionary:self->dict_upgradeDetails] isNotEmpty]){
                if([[Utility checkNullForKey:kLABEL_UPGRADE Dictionary:self->dict_upgradeDetails] boolValue] )
                {
                    
                }
                else {
                    [self.btn_finished setHidden:NO];
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_COMPLETED];
                    [self->timerObj invalidate];
                    self->timerObj = nil;
                }
                }
                
                else{
                    [self.btn_finished setHidden:NO];
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_COMPLETED];
                    [self->timerObj invalidate];
                    self->timerObj = nil;
                }
            }
        }];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)callAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE, nil) message:[NSString stringWithFormat:ALERTMESSAGE_SOMETHINGWENTWRONG] preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = colorWhite;
    NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERT_TITLE];
    [strAttributedTitle addAttribute:NSFontAttributeName
                               value:textFontRegular13
                               range:NSMakeRange(0, strAttributedTitle.length)];
    //[alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_EXIT, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
            if(self->_navigateFromType == menu_update_inside){
            for (UIViewController *controller in self.navigationController.viewControllers) {
                //Do not forget to import AnOldViewController.h
                if ([controller isKindOfClass:[SubSettingsVC class]]) {
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    return;
                }
            }
        }
        else
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                //Do not forget to import AnOldViewController.h
                if ([controller isKindOfClass:[ManuallySetupVC class]]) {
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    return;
                }
            }
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void) fileAllDetails {
    @try {
        [APIManager fileAllDetails:self.objSelectedMHubDevice completion:^(APIV2Response *responseObject) {
            if (!responseObject.error) {
                Hub *objHubAPI = (Hub *)responseObject.data_description;
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                Hub *extractedExpr = [Hub getHubObject_From:objHubAPI To:self.objSelectedMHubDevice];
                self.objSelectedMHubDevice = extractedExpr;
                if(self.objSelectedMHubDevice.BootFlag == true) {
                    
                }
               
                [self viewDidLayoutSubviews];
            }
            else
            {
                [self errorMessageOverlayNavigation];
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) errorMessageOverlayNavigation {
    @try {
        ErrorMessageOverlayVC *objVC = [mainStoryboard   instantiateViewControllerWithIdentifier:@"ErrorMessageOverlayVC"];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.isFirstAppORMosUpdateAlertPage = NO;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self presentViewController:objVC animated:YES completion:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) ImageRotationMethod:(myCompletion) compblock{
    //do stuff
    [UIView animateWithDuration:90.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.img_loadingProgress setTransform:CGAffineTransformRotate(self.img_loadingProgress.transform, M_PI_2)];
    }completion:^(BOOL finished){
        compblock(YES);
//        [self.btn_finished setHidden:NO];
//        if (finished) {
//            [self.btn_finished setHidden:NO];
//        }
    }];
    
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:1.00];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    [self.img_loadingProgress.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (IBAction)btn_UpdateFinished:(CustomButton *)sender {
    if(self->_navigateFromType == menu_update_inside){
    for (UIViewController *controller in self.navigationController.viewControllers) {
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[SubSettingsVC class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            return;
        }
    }
}
else
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[ManuallySetupVC class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            return;
        }
    }
}
    
//
//
//
//
//    if(_isSingleUnit)
//   {
//
//       if(_navigateFromType == menu_update)
//       {
//           for (UIViewController *controller in self.navigationController.viewControllers) {
//               //Do not forget to import AnOldViewController.h
//               if ([controller isKindOfClass:[UpdateHubViewController class]]) {
//                   [self.navigationController popToViewController:controller
//                                                         animated:YES];
//                   return;
//               }
//           }
//       }
//       else
//       {
//           if(self.objSelectedMHubDevice.isPaired)
//           {
//               for (UIViewController *controller in self.navigationController.viewControllers) {
//                   //Do not forget to import AnOldViewController.h
//                   if ([controller isKindOfClass:[UpdateHubViewController class]]) {
//                       [self.navigationController popToViewController:controller
//                                                             animated:YES];
//                       return;
//                   }
//               }
//           }
//           else{
//               SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
//               objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:self.objSelectedMHubDevice];
//               objVC.isSelectedPaired = false;
//               objVC.arrSelectedSlaveDevice = [[NSMutableArray alloc] init];
//               [self.navigationController pushViewController:objVC animated:YES];
//           }
//       }
//   }
//   else
//   {
//       bool flag_checkAllUpdatedOrNot = false;
//       for (int i = 0; i < [self.arr_allAvailableHubsForUpdate count]; i++) {
//
//           Hub *hubObj = (Hub *)[self.arr_allAvailableHubsForUpdate objectAtIndex:i];
//           if(hubObj.mosVersion >= hubObj.MHub_BenchMarkVersion){
//               flag_checkAllUpdatedOrNot = true;
//           }
//           else{
//               flag_checkAllUpdatedOrNot = false;
//           }
//       }
//       if(flag_checkAllUpdatedOrNot)
//       {
////           SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
////           objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:self.objSelectedMHubDevice_ForSetupConfirmation];
////           objVC.isSelectedPaired = self.isSelectedPaired_ForSetupConfirmation;
////           objVC.arrSelectedSlaveDevice = [[NSMutableArray alloc] initWithArray:self.arrSelectedSlaveDevice_ForSetupConfirmation];
////           [self.navigationController pushViewController:objVC animated:YES];
//           for (UIViewController *controller in self.navigationController.viewControllers) {
//               //Do not forget to import AnOldViewController.h
//               if ([controller isKindOfClass:[UpdateHubViewController class]]) {
//                   [self.navigationController popToViewController:controller
//                                                         animated:YES];
//                   return;
//               }
//           }
//       }
//       else
//       {
//           for (UIViewController *controller in self.navigationController.viewControllers) {
//               //Do not forget to import AnOldViewController.h
//               if ([controller isKindOfClass:[UpdateAvailableViewController class]]) {
//                   [self.navigationController popToViewController:controller
//                                                         animated:YES];
//                   return;
//               }
//           }
//       }
//   }
//    UpdateAvailableViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateAvailableViewController"];
//    [self.navigationController popToViewController:objVC animated:NO];
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
