//
//  UpdateHubViewController.m
//  mHubApp
//
//  Created by Rave on 04/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "UpdateHubViewController.h"
#import "UpdateAvailableViewController.h"
#import "HubUpdatingViewController.h"

@interface UpdateHubViewController ()
{
    NSMutableArray *arrFilterData;
}
@end

@implementation UpdateHubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton =  true;
    //self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_REQUIRED];
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_CHECKING_FOR_UPDATES];
    
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    
    //[self.updateMhub addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    self.lblHeaderMessage.text = HUB_UPDATE_MESSAGE;
    [self.lblHeaderMessage setTextColor:colorWhite];
    
    self.lblSubHeaderMessage.text = HUB_UPDATE_MESSAG_SubHeading;
    [self.lblSubHeaderMessage setTextColor:colorMiddleGray_868787];
    
    self.lbl_checkingHubUpdate.text = HUB_HOLD_MESSAGE_FOR_CHECKING_UPDATE;
    [self.lbl_checkingHubUpdate setTextColor:colorMiddleGray_868787];
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall)  {
        [self.lblHeaderMessage setFont:textFontRegular12];
        [self.lbl_checkingHubUpdate setFont:textFontRegular12];
    } else {
        [self.lblHeaderMessage setFont:textFontRegular16];
        [self.lbl_checkingHubUpdate setFont:textFontRegular16];
    }
    [self call_ConnectivityJSON];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    @try {
        arrFilterData = [[NSMutableArray alloc] init];
//        if(self.objSelectedMHubDevice != nil)
//        {
//            [arrFilterData addObject:self.objSelectedMHubDevice];
//            [self.img_mhub  setImage:[Hub getHubDeviceImage:self.objSelectedMHubDevice.modelName]];
//        }
//        else
//        {
//            bool flag_checkAllUpdatedOrNot = false;
//            for (Hub *objHub in self.arrSearchData) {
//                [arrFilterData addObject:objHub];
//                [self.img_mhub  setImage:[Hub getHubDeviceImage:objHub.modelName]];
//                if(objHub.mosVersion >= objHub.MHub_BenchMarkVersion)
//                {
//                    flag_checkAllUpdatedOrNot = true;
//                }
//                else
//                {
//                    flag_checkAllUpdatedOrNot = false;
//                }
//            }
//            if(flag_checkAllUpdatedOrNot)
//            {
//                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_IS_UPTODATE];
//                [self.gotoMenu setTitle:[ALERT_BTN_TITLE_GOBACK uppercaseString] forState:UIControlStateNormal];
//                [self.updateMhub setHidden:YES];
//                self.lblHeaderMessage.text = HUB_UP_TO_DATE_MESSAGE;
//            }
//            else
//            {
//                [self.updateMhub setHidden:NO];
//            }
//        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (IBAction)btnUpdateMhub_Clicked:(CustomButton *)sender {
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"ISTermsNConditionTrue" ])
    {
        HubUpdatingViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"HubUpdatingViewController"];
        objVC.objSelectedMHubDevice =  self.objSelectedMHubDevice;
        objVC.latestOSVersion = [NSString stringWithFormat:@"%.02f",self.objSelectedMHubDevice.MHub_LatestVersion];
        objVC.navigateFromType = self.navigateFromType;
        if(arrFilterData.count  == 1)
        objVC.isSingleUnit = true ;
        else
        objVC.isSingleUnit = false ;
        [self.navigationController pushViewController:objVC animated:YES];
    }
    else
    {
        TermsNConditionViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TermsNConditionViewController"];
        objVC.arrSearchData = self.arrSearchData;
        objVC.latestOSVersion = [NSString stringWithFormat:@"%.02f",self.objSelectedMHubDevice.MHub_LatestVersion];
        objVC.navigateFromType = self.navigateFromType;
        objVC.objSelectedMHubDevice = self.objSelectedMHubDevice;
        if(arrFilterData.count  == 1)
            objVC.isSingleUnit = true ;
        else
            objVC.isSingleUnit = false ;
        [self.navigationController pushViewController:objVC animated:NO];
    }
    
}

- (IBAction)btn_gotoMenu_clicked:(CustomButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)call_ConnectivityJSON
{
    @try {
        [[AppDelegate appDelegate]showHudView:ShowIndicator Message:@"Checking For Updates.." ];
        [APIManager fileConnectivityJSON:self.objSelectedMHubDevice completion:^(NSDictionary *responseObject) {
            [self.view_checkingUpdates setHidden:YES];
            self->dict_upgradeDetails = (NSDictionary *)responseObject;
            [[AppDelegate appDelegate]hideHudView:HideIndicator Message:@""];
            NSLog(@"call_ConnectivityJSON %@",[self->dict_upgradeDetails objectForKey:kLABEL_connectivity]);
            if ([[Utility checkNullForKey:kLABEL_connectivity Dictionary:self->dict_upgradeDetails] isNotEmpty]){
            if( [[self->dict_upgradeDetails objectForKey:kLABEL_connectivity] isEqualToString:kLABEL_ONLINE]){
                [self call_DashUpgrade_CGI];
            }
            else
            {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@"System Offline\nUpdate Unavailable"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            }
            else{
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@"System Offline\nUpdate Unavailable"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)call_DashUpgrade_CGI
{
    @try {
        [[AppDelegate appDelegate]showHudView:ShowIndicator Message:@"Checking For Updates" ];
        [APIManager getDashUpgrade_CGI:self.objSelectedMHubDevice updateData:nil completion:^(APIV2Response *objResponse) {
            if(objResponse.error){
                NSLog(@"ERROR:dash  upgrade CGI %@ @",objResponse.data_description);
                [[AppDelegate appDelegate]hideHudView:HideIndicator Message:@""];
                [self call_DashUpgrade_JSON];
            }
            else
            {
                [[AppDelegate appDelegate]hideHudView:HideIndicator Message:@""];
                [self.view_checkingUpdates setHidden:YES];
                //self->mArr_upgradeDetails  =  (NSMutableArray *)objResponse;
                self->dict_upgradeDetails = (NSDictionary *)objResponse.data_description;
                NSLog(@"SUCCESS: dash  upgrade CGI %@ @",objResponse.data_description);
                if ([[Utility checkNullForKey:kLABEL_UPGRADE Dictionary:self->dict_upgradeDetails] isNotEmpty]){
                    if([[Utility checkNullForKey:kLABEL_UPGRADE Dictionary:self->dict_upgradeDetails] boolValue] )
                    {
                        [self.updateMhub setHidden:false];
                        self.objSelectedMHubDevice.MHub_LatestVersion  = [[self->dict_upgradeDetails objectForKey:@"version"]floatValue ];
                        NSLog(@"dash  upgrade JSON %f %@",self.objSelectedMHubDevice.MHub_LatestVersion,[self->dict_upgradeDetails objectForKey:@"version"] );
                        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_IS_AVAILABLE];
                        [self.lblHeaderMessage setText:HUB_UPDATE_AVAILABLE_MESSAGE];
                        [self.lblSubHeaderMessage setText:[NSString stringWithFormat:HUB_UPDATE_AVAILABLE__SUBHEADING,self.objSelectedMHubDevice.mosVersion,[self->dict_upgradeDetails objectForKey:@"version"]]];
//                        UpdateAvailableViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateAvailableViewController"];
//                        objVC.navigateFromType = self->_navigateFromType;
//                        objVC.arrSearchData = self->arrFilterData;
//                        objVC.objSelectedMHubDevice = self.objSelectedMHubDevice;
//                        objVC.latestOSVersion = [self->dict_upgradeDetails objectForKey:@"version"];
//                        [self.navigationController pushViewController:objVC animated:YES];
                    }
                    else{
                        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_IS_UPTODATE];
                        self.lblHeaderMessage.text = nil;//Heading blank, subheading is the main heading.
                        self.lblSubHeaderMessage.text = HUB_UP_TO_DATE_MESSAGE;
                        
                        [self.updateMhub setHidden:true];
//                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@"No Update Available"];
//                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                else{
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_IS_UPTODATE];
                    self.lblHeaderMessage.text  = nil;//Heading blank, subheading is the main heading.
                    self.lblSubHeaderMessage.text = HUB_UP_TO_DATE_MESSAGE;
                    [self.updateMhub setHidden:true];
//                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@"No Update Available"];
//                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)call_DashUpgrade_JSON

{
    @try {
        //[[AppDelegate appDelegate]showHudView:ShowIndicator Message:@"Checking For Updates" ];
        [APIManager getDashUpgrade_JSON:self.objSelectedMHubDevice updateData:nil completion:^(APIV2Response *objResponse) {
            if(objResponse.error){
                // [self call_DashUpgradeApi];
                [[AppDelegate appDelegate]hideHudView:HideIndicator Message:@""];
                NSLog(@"ERROR: Dash_upgrade JSON %@ @",objResponse.data_description);
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_IS_UPTODATE];
                self.lblHeaderMessage.text = nil;//Heading blank, subheading is the main heading.
                self.lblSubHeaderMessage.text = HUB_UP_TO_DATE_MESSAGE;
                [self.updateMhub setHidden:true];
//                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@"No Update Available"];
//                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [[AppDelegate appDelegate]hideHudView:HideIndicator Message:@""];
                [self.view_checkingUpdates setHidden:YES];
                //  self->mArr_upgradeDetails  =  (NSMutableArray *)objResponse;
                self->dict_upgradeDetails = (NSDictionary *)objResponse.data_description;
                NSLog(@"dash  upgrade JSON %@ ",objResponse.data_description);
                //NSLog(@"Success: dash  upgrade JSON %@ and dict %@",self->mArr_upgradeDetails,[self->dict_upgradeDetails objectForKey:@"version"]);
                
                if ([[Utility checkNullForKey:kLABEL_UPGRADE Dictionary:self->dict_upgradeDetails] isNotEmpty]){
                if([[Utility checkNullForKey:kLABEL_UPGRADE Dictionary:self->dict_upgradeDetails] boolValue] )
                {
                    [self.updateMhub setHidden:false];
                    self.objSelectedMHubDevice.MHub_LatestVersion = [[self->dict_upgradeDetails objectForKey:@"version"]floatValue ];
                    NSLog(@"dash  upgrade JSON %f %@",self.objSelectedMHubDevice.MHub_LatestVersion,[self->dict_upgradeDetails objectForKey:@"version"] );
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_IS_AVAILABLE];
                    [self.lblHeaderMessage setText:HUB_UPDATE_AVAILABLE_MESSAGE];
                    [self.lblSubHeaderMessage setText:[NSString stringWithFormat:HUB_UPDATE_AVAILABLE__SUBHEADING,self.objSelectedMHubDevice.mosVersion,[self->dict_upgradeDetails objectForKey:@"version"]]];
//                    UpdateAvailableViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateAvailableViewController"];
//                    objVC.navigateFromType = self->_navigateFromType;
//                    objVC.arrSearchData = self->arrFilterData;
//                    objVC.objSelectedMHubDevice = self.objSelectedMHubDevice;
//                    objVC.latestOSVersion = [self->dict_upgradeDetails objectForKey:@"version"];
//                    [self.navigationController pushViewController:objVC animated:YES];
                }
                else {
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_IS_UPTODATE];
                    self.lblHeaderMessage.text = nil;//Heading blank, subheading is the main heading.
                    self.lblSubHeaderMessage.text = HUB_UP_TO_DATE_MESSAGE;
                    [self.updateMhub setHidden:true];
//                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@"No Update Available"];
//                    [self.navigationController popViewControllerAnimated:YES];
                }
                }
                else{
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UPDATE_IS_UPTODATE];
                    self.lblHeaderMessage.text = nil;//Heading blank, subheading is the main heading.
                    self.lblSubHeaderMessage.text = HUB_UP_TO_DATE_MESSAGE;
                    [self.updateMhub setHidden:true];
//                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@"No Update Available"];
//                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppDelegate appDelegate].isSearchNetworkPopVC = true;
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
