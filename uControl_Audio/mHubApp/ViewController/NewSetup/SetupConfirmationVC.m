//
//  SetupConfirmationVC.m
//  mHubApp
//
//  Created by Anshul Jain on 20/03/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "SetupConfirmationVC.h"
#import "MainViewController.h"

@interface SetupConfirmationVC ()
 
@end

@implementation SetupConfirmationVC
BOOL isComingAfterFirstBoot;

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        [self.viewRebootMasterController setHidden:true];
        isComingAfterFirstBoot = false;
        self.navigationItem.backBarButtonItem = customBackBarButton;
        self.navigationItem.hidesBackButton = true;
        ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
        self.view.backgroundColor = themeColor.colorBackground;
        self.viewRebootMasterController.backgroundColor = themeColor.colorBackground;
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_CONTINUE_SETUP_ON_Device];
        [self.btnConfirmationStatus setImage:kImageIconSetupMHUBOSLarge forState:UIControlStateNormal];
        arrConfirmationData = [[NSMutableArray alloc] initWithObjects:HUB_CONTINUE_SETUP_ON_Device, nil];

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
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_SETUP_COMPLETE_HEADER];
                arrConfirmationData = [[NSMutableArray alloc] initWithObjects:HUB_SETUP_COMPLETE_BUTTON, nil];
                // [self.btnConfirmationStatus setBackgroundColor:[AppDelegate appDelegate].themeColoursSetup.colorNavigationBar];
                [self.btnConfirmationStatus setImage:kImageIconSetupDoneLarge forState:UIControlStateNormal];
            }

//            if(self.objSelectedMHubDevice.mosVersion <= MOSUPDATEVERSIONTOCHECK && self.objSelectedMHubDevice.mosVersion > 1 )
//            {
//                                 if([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem)
//                                 {
//
//                                 }
//                                 else
//                                 {
//                                     if (![self.objSelectedMHubDevice.modelName isContainString:kDEVICEMODEL_MHUBAUDIO64])
//                                     {
//                                     [self alertControllerMOSUpdate:self.objSelectedMHubDevice];
//                                     }
//                                 }
//           }

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
        [self.btnConfirmationStatus addRoundedCorner_CornerRadius:self.btnConfirmationStatus.frame.size.height/2];
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
        isComingAfterFirstBoot = true;
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
    isComingAfterFirstBoot = true;
    // Done button pressed
    [self fileAllDetails];
}

- (IBAction)btnContinueAfterReboot_Clicked:(CustomButton *)sender {//This method is written to check that IP is not changed as we asked user to forcefully reboot the ZP device.
    [self.viewRebootMasterController setHidden:true];
    isComingAfterFirstBoot = false;
    [self fileAllDetails];
   // self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_SETUP_COMPLETE_HEADER];
}

- (IBAction)btnConfirmationStatus_Clicked:(CustomButton *)sender {
 
}

- (IBAction)pageControl_ValueChanged:(CustomPageControl *)sender {
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrConfirmationData.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return 45;
    } else {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
    CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    }
    if([[arrConfirmationData objectAtIndex:indexPath.row] isEqualToString:HUB_CONTINUE_SETUP_ON_Device])
    {
        [cell addBorder_Color:colorGunGray_272726 BorderWidth:1.0];
    }
    else{
        [cell setBackgroundColor:[Utility colorWithHexString:hexString_ProPink]];
        [cell addBorder_Color:colorClear BorderWidth:0.0];
    }
    
    cell.lblCell.text = [[arrConfirmationData objectAtIndex:indexPath.row] uppercaseString];
    return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if([self.btnConfirmationStatus.currentImage isEqual: kImageIconSetupDoneLarge]) {
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
                        // Below if case is added because of new changes for ZP devices. So if master is ZP and its in stack, so user needs to powerOff and On the system after completing the first boot and return to Application for access uControl button.
                        if(self.objSelectedMHubDevice.isZPSetup && [self.objSelectedMHubDevice isPairedSetup] && isComingAfterFirstBoot)
                        {
                            self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:REBOOT_MASTER_CONTROLLER];
                            [self.viewRebootMasterController setHidden:false];
                        }
                        else{
                        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_SETUP_COMPLETE_HEADER];
                        arrConfirmationData = [[NSMutableArray alloc] initWithObjects:HUB_SETUP_COMPLETE_BUTTON, nil];
                        // [self.btnConfirmationStatus setBackgroundColor:[AppDelegate appDelegate].themeColoursSetup.colorNavigationBar];
                        [self.btnConfirmationStatus setImage:kImageIconSetupDoneLarge forState:UIControlStateNormal];
                        }
                    }
                    
                    
                } else {
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_CONTINUE_SETUP_ON_Device];
                    self->arrConfirmationData = [[NSMutableArray alloc] initWithObjects:HUB_CONTINUE_SETUP_ON_Device, nil];
                    [self.btnConfirmationStatus setImage:kImageIconSetupMHUBOSLarge forState:UIControlStateNormal];
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
        [[AppDelegate appDelegate] showHudView:ShowMessage Message:@"Connecting to Device-OS, this can take up to 30 seconds..."];
        float mosVersionStr = objDevice.mosVersion;
        [APIManager getAllMHUBDetails:objDevice Stacked:isStacked Slave:arrSlaveDevice Sync:true completion:^(APIV2Response *responseObject) {
            if (responseObject.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
            } else {
                // [mHubManager saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:HUB_SUCCESS];
                if ([objDevice isUControlSupport]) {
                    mHubManagerInstance.objSelectedHub.mosVersion = mosVersionStr;
                   [ mHubManagerInstance.arrDeviceAddedForProfile addObject:objDevice];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
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
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:HUB_CONNECTING];
        [APIManager getmHubDetails_DataSync:true completion:^(APIResponse *responseObject) {
            if (responseObject.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.response];
            } else {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:HUB_SUCCESS];
                if ([objDevice isUControlSupport]) {
                    [mHubManagerInstance.arrDeviceAddedForProfile addObject:objDevice];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
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
        
        
//        if(self.objSelectedMHubDevice.mosVersion < MOSUPDATEVERSIONTOCHECK)
//        {
//            if(self.objSelectedMHubDevice.mosVersion < 7)
//            {
//                strAddress =   [NSString stringWithFormat:@"update-step1.php?ip=%@", self.objSelectedMHubDevice.Address];
//                url = [[API MHUBOSUpdatePageURL:strAddress] absoluteURL];
//
//            }
//            else
//            {
//                if(self.objSelectedMHubDevice.BootFlag == true)
//                {
//                    strAddress =   [NSString stringWithFormat:@"update-step1.php?ip=%@", self.objSelectedMHubDevice.Address];
//                    url = [[API MHUBOSUpdatePageURL:strAddress] absoluteURL];
//                }
//                else
//                {
//                    strAddress =   [NSString stringWithFormat:@"%@", self.objSelectedMHubDevice.Address];
//                    url =  [[API MHUBOSIndexPageURL:strAddress] absoluteURL];
//                }
//            }
//        }
//        else{
//            strAddress =   [NSString stringWithFormat:@"%@", self.objSelectedMHubDevice.Address];
//            url =  [[API MHUBOSIndexPageURL:strAddress] absoluteURL];
//        }
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
