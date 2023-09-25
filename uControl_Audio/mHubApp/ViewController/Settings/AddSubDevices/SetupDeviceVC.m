//
//  SetupDeviceVC.m
//  mHubApp
//
//  Created by Apple on 05/02/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "SetupDeviceVC.h"

@interface SetupDeviceVC ()

@property (strong, nonatomic) NSMutableArray *arrDevices;
@property (weak, nonatomic) IBOutlet UITableView *tbl_device;
@property (strong, nonatomic) IBOutlet UIButton *btn_back;
@end

@implementation SetupDeviceVC

- (void)viewDidLoad {
    @try {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    
    [self.navigationController.navigationBar setHidden:NO];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lbl_title setFont:textFontBold12];
            [self.lbl_subTitle setFont:textFontRegular12];
        } else {
            [self.lbl_title setFont:textFontBold16];
            [self.lbl_subTitle setFont:textFontRegular16];
        }
    [self.lbl_title setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
    [self.lbl_subTitle setTextColor:colorMiddleGray_868787];
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:self.objSelectedMHubDevice.modelName];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    
   // self.arrDevices = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBModelDevicesArray]];
    [self.tbl_device reloadData];
    [self.btn_back setTitleColor:[AppDelegate appDelegate].themeColours.colorNormalText forState:UIControlStateNormal];
    [self.btn_back setTitle:HUB_BACK forState:UIControlStateNormal];
        
    
    
        
           
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:HUB_START_SETUP];
        [self.btnConfirmationStatus setTitle:HUB_START_SETUP forState:UIControlStateNormal];
        [self.btnConfirmationStatus setTitleColor:[AppDelegate appDelegate].themeColours.colorNormalText forState:UIControlStateNormal];


            // If Paired flag is true then post data to server
            if (self.isSelectedPaired && self.objSelectedMHubDevice.BootFlag == false) {
                self.objSelectedMHubDevice.PairingDetails = [[Pair alloc] initWithPair:[Pair getPairObjectFromMHUBObject:self.objSelectedMHubDevice SlaveHub:self.arrSelectedSlaveDevice]];
                NSDictionary *dictPairing = [[NSDictionary alloc] initWithDictionary:[self.objSelectedMHubDevice.PairingDetails dictionaryJSONRepresentation]];
                DDLogDebug(@"Pair Dictionary == %@", dictPairing);
                [[AppDelegate appDelegate] showHudView:ShowIndicator Message:HUB_CONNECTING];
                [APIManager setPairJSON:self.objSelectedMHubDevice PairData:dictPairing completion:^(APIV2Response *responseObject) {
                    if (responseObject.error) {
                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                        [self.navigationController popViewControllerAnimated:NO];
                    } else {
                        self.objSelectedMHubDevice.UnitId = self.objSelectedMHubDevice.PairingDetails.master.unit_id;
                        for (Hub *objSlave in self.arrSelectedSlaveDevice) {
                            for (PairDetail *objPairing in self.objSelectedMHubDevice.PairingDetails.arrSlave) {
                                if ([objSlave.SerialNo isEqualToString:objPairing.serial_number]) {
                                    objSlave.UnitId = objPairing.unit_id;
                                    break;
                                }
                            }
                        }
                        [self fileAllDetails];
                    }
                }];
            } else {
                if(self.objSelectedMHubDevice.BootFlag == true) {
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:HUB_SETUP_COMPLETE_HEADER];
                    
                    [self.lbl_title setText:HUB_DEVICE_IS_READY_TO_USE];
                    [self.lbl_subTitle setText:[NSString stringWithFormat:HUB_DEVICE_IS_READY_TO_USE_WITH_MODELNAME,self.objSelectedMHubDevice.Official_Name]];
                    [self.btnConfirmationStatus setBackgroundColor:[Utility colorWithHexString:hexString_ProPink]];
                    [self.btnConfirmationStatus setTitle:HUB_SETUP_COMPLETE_BUTTON_New forState:UIControlStateNormal];
                    [self.btnConfirmationStatus addBorder_Color:UIColor.clearColor BorderWidth:0.0];
                }

            }
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCloseSafari object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveNotification:)
                                                         name:kNotificationCloseSafari
                                                       object:nil];

        } @catch(NSException *exception) {
            [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
        }
    
    
}


-(void)viewWillLayoutSubviews {
    @try {
        [super viewWillLayoutSubviews];
        //[self.btnConfirmationStatus addBorder_Color:[AppDelegate appDelegate].themeColours.colorNormalText BorderWidth:1.0];
        [self.view layoutIfNeeded];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - AlertController
-(void) alertControllerMOSUpdate:(Hub*)objHub {
    @try {
        //UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE, nil) message:[NSString stringWithFormat:HUB_MOSUPDATE_MESSAGE, [Hub getMhubDisplayName:objHub]] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE_UPDATE_AVAILABLE, nil) message:[NSString stringWithFormat:HUB_MOSUPDATE_MESSAGE_Without_Model] preferredStyle:UIAlertControllerStyleAlert];
        alertController.view.tintColor = colorGray_646464;
        NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERT_TITLE];
        [strAttributedTitle addAttribute:NSFontAttributeName
                                   value:textFontRegular13
                                   range:NSMakeRange(0, strAttributedTitle.length)];
       // [alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_UPDATE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *strAddress;
            NSURL *url;
            
            if(objHub.mosVersion < MOSUPDATEVERSIONTOCHECK)
            {
                strAddress =   [NSString stringWithFormat:@"update-step1.php?ip=%@", objHub.Address];
                url = [[API MHUBOSUpdatePageURL:strAddress] absoluteURL];
                
            }
            else if(objHub.mosVersion == MOSUPDATEVERSIONTOCHECK)
            {
                strAddress =   [NSString stringWithFormat:@"update-step.php?ip=%@", objHub.Address];
                url = [[API MHUBOSUpdatePageURL:strAddress] absoluteURL];
            }
            else{
                strAddress =   [NSString stringWithFormat:@"%@", objHub.Address];
                url =  [[API MHUBOSIndexPageURL:strAddress] absoluteURL];
            }


            if ([SFSafariViewController class] != nil) {
                // Use SFSafariViewController
                safariVC = [[SFSafariViewController alloc]initWithURL:url];
                safariVC.delegate = self;
                [[AppDelegate appDelegate]showHudView:ShowMessage Message:HUB_CONNECTINGTOMHUBOS];
                [self presentViewController:safariVC animated:YES completion:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    if (!success) {
                        DDLogError(@"%@%@",@"Failed to open url:",[url description]);
                    }
                }];
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_CANCEL, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:NO];
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
        CGFloat height = MIN(self.tblConfirmationOption.bounds.size.height, self.tblConfirmationOption.contentSize.height);
        self.heightTblConfirmationOption.constant = height;
        [self.view layoutIfNeeded];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) receiveNotification:(NSNotification *) notification {
    DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
    @try {
        [safariVC dismissViewControllerAnimated:YES completion:nil];
        [self fileAllDetails];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SFSafariViewController delegate methods
-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    // Load finished
    [[AppDelegate appDelegate]hideHudView:HideIndicator Message:@"Finished"];
}

-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    // Done button pressed
    [self fileAllDetails];
}

- (IBAction)btnConfirmationStatus_Clicked:(CustomButton *)sender {
    @try {
        if([self.btnConfirmationStatus.titleLabel.text isEqualToString: HUB_SETUP_COMPLETE_BUTTON_New]) {
            switch (self.objSelectedMHubDevice.Generation) {
                case mHub4KV3: {
                    [self connectSSDPDevice:self.objSelectedMHubDevice];
                    break;
                }
                default: {
                    if ([self.objSelectedMHubDevice isAPIV2]) {
                        [self getSystemDetails:self.objSelectedMHubDevice Stacked:self.isSelectedPaired Slave:self.arrSelectedSlaveDevice];
                    } else {
                        [self getmHubDetails:self.objSelectedMHubDevice];
                    }
                    break;
                }
            }
        } else {
            [self navigateToMHUBOSIndex];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)pageControl_ValueChanged:(CustomPageControl *)sender {
}

-(IBAction)ClickOn_BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - SSDP Method
-(void)connectSSDPDevice:(Hub*)objDevice
{
    mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objDevice];
    [SSDPManager connectSSDPmHub_Completion:^(APIResponse *objResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (objResponse.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                [AppDelegate appDelegate].isDeviceNotFound = true;
                [self.navigationController popToRootViewControllerAnimated:NO];
            } else {
                [mHubManagerInstance syncGlobalManagerObjectV0];
                [self showSettingsStoryBoard];
            }
        });
    }];
}

#pragma mark - REST API methods

-(void) fileAllDetails {
    @try {
        [APIManager fileAllDetails:self.objSelectedMHubDevice completion:^(APIV2Response *responseObject) {
            if (!responseObject.error) {
                Hub *objHubAPI = (Hub *)responseObject.data_description;
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                self.objSelectedMHubDevice = [Hub getHubObject_From:objHubAPI To:self.objSelectedMHubDevice];
                if(self.objSelectedMHubDevice.BootFlag == true) {
                    
                    if(self.objSelectedMHubDevice.mosVersion <= MOSUPDATEVERSIONTOCHECK)
                    {
                        if([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem)
                        {

                        }
                        else
                        {
                            if (![self.objSelectedMHubDevice.modelName isContainString:kDEVICEMODEL_MHUBAUDIO64])
                            {
                            [self alertControllerMOSUpdate:self.objSelectedMHubDevice];
                            }
                        }
                    }
                    else
                    {
                        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:HUB_SETUP_COMPLETE_HEADER];
                        [self.lbl_title setText:HUB_DEVICE_IS_READY_TO_USE];
                        [self.lbl_subTitle setText:[NSString stringWithFormat:HUB_DEVICE_IS_READY_TO_USE_WITH_MODELNAME,self.objSelectedMHubDevice.Official_Name]];
                        [self.btnConfirmationStatus setBackgroundColor:[Utility colorWithHexString:hexString_ProPink]];
                        [self.btnConfirmationStatus setTitle:HUB_SETUP_COMPLETE_BUTTON_New forState:UIControlStateNormal];
                        [self.btnConfirmationStatus addBorder_Color:UIColor.clearColor BorderWidth:0.0];
                        
                    }
                    
                    
                } else {
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:HUB_START_SETUP];
                    [self.btnConfirmationStatus setTitle:HUB_START_SETUP forState:UIControlStateNormal];
                }
                [self.tblConfirmationOption reloadData];
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

//
-(void) getSystemDetails:(Hub*)objDevice Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        //[[AppDelegate appDelegate] showHudView:ShowMessage Message:@"Connecting to MHUB-OS, this can take up to 30 seconds..."];
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        [APIManager getAllMHUBDetails:objDevice Stacked:isStacked Slave:arrSlaveDevice Sync:true completion:^(APIV2Response *responseObject) {
            if (responseObject.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
            } else {
                // [mHubManager saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:HUB_SUCCESS];
                if ([objDevice isUControlSupport]) {
                    [mHubManagerInstance.arrDeviceAddedForProfile addObject:objDevice];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    NSLog(@"AppDelegate appDelegate].arrDeviceAddedForProfile %@" ,mHubManagerInstance.arrDeviceAddedForProfile);
                    [self showControlStoryBoard];
                } else {
                    [self showSettingsStoryBoard];
                }
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) getmHubDetails:(Hub*)objDevice {
    @try {
        mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objDevice];
        //[[AppDelegate appDelegate] showHudView:ShowIndicator Message:HUB_CONNECTING];
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        [APIManager getmHubDetails_DataSync:true completion:^(APIResponse *responseObject) {
            if (responseObject.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.response];
            } else {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:HUB_SUCCESS];
                if ([objDevice isUControlSupport]) {
                    [mHubManagerInstance.arrDeviceAddedForProfile addObject:objDevice];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    NSLog(@"AppDelegate appDelegate].arrDeviceAddedForProfile %@" ,mHubManagerInstance.arrDeviceAddedForProfile);
                    [self showControlStoryBoard];
                } else {
                    [self showSettingsStoryBoard];
                }
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Navigation Methods
-(void) navigateToMHUBOSIndex {
    @try {
        //NSString *strAddress = self.objSelectedMHubDevice.Address;
        //NSURL *url = [[API MHUBOSIndexPageURL:strAddress] absoluteURL];
        
        NSString *strAddress;
        NSURL *url;
        
        if(self.objSelectedMHubDevice.mosVersion < MOSUPDATEVERSIONTOCHECK)
        {
            if (![self.objSelectedMHubDevice.modelName isContainString:kDEVICEMODEL_MHUBAUDIO64])
            {
                strAddress =   [NSString stringWithFormat:@"update-step1.php?ip=%@", self.objSelectedMHubDevice.Address];
                url = [[API MHUBOSUpdatePageURL:strAddress] absoluteURL];
            }
        }
        else if(self.objSelectedMHubDevice.mosVersion == MOSUPDATEVERSIONTOCHECK)
        {
            if (![self.objSelectedMHubDevice.modelName isContainString:kDEVICEMODEL_MHUBAUDIO64])
            {
            strAddress =   [NSString stringWithFormat:@"update-step.php?ip=%@", self.objSelectedMHubDevice.Address];
            url = [[API MHUBOSUpdatePageURL:strAddress] absoluteURL];
            }
            else{
                strAddress =   [NSString stringWithFormat:@"%@", self.objSelectedMHubDevice.Address];
                url =  [[API MHUBOSIndexPageURL:strAddress] absoluteURL];
            }
        }
        else{
            strAddress =   [NSString stringWithFormat:@"%@", self.objSelectedMHubDevice.Address];
            url =  [[API MHUBOSIndexPageURL:strAddress] absoluteURL];
        }
        if ([SFSafariViewController class] != nil) {
            // Use SFSafariViewController
            safariVC = [[SFSafariViewController alloc]initWithURL:url];
            safariVC.delegate = self;
            [[AppDelegate appDelegate]showHudView:ShowMessage Message:HUB_CONNECTINGTOMHUBOS];
            
            [self presentViewController:safariVC animated:YES completion:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    DDLogError(@"%@%@",@"Failed to open url:",[url description]);
                }
            }];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void) showControlStoryBoard {
    @try {
        [AppDelegate appDelegate].flowType = HDA_UControlFlow;
        UIStoryboard *storyboard = controlStoryboard;
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"ControlNavigationController"];
        MainViewController *mainViewController = [storyboard instantiateInitialViewController];
        mainViewController.rootViewController = navigationController;
        [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:0];

        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        window.rootViewController = mainViewController;
        [window crossDissolveTransitionWithAnimations:nil AndCompletion:nil];

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)showSettingsStoryBoard {
    @try {
        [AppDelegate appDelegate].flowType = HDA_UControlFlow;
        UIStoryboard *storyboard = settingsStoryboard;
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"ControlNavigationController"];

        MainViewController *mainViewController = [storyboard instantiateInitialViewController];
        mainViewController.rootViewController = navigationController;
        [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:0];

        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        window.rootViewController = mainViewController;
        [window crossDissolveTransitionWithAnimations:nil AndCompletion:nil];

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppDelegate appDelegate].isSearchNetworkPopVC = true;
}

@end
