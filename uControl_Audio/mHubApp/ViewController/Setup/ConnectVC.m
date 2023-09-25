//
//  ConnectVC.m
//  mHubApp
//
//  Created by rave on 9/18/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ConnectVC.h"
#import "MainViewController.h"

@interface ConnectVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgDeviceLogo;
@property (weak, nonatomic) IBOutlet UITableView *tblConnect;
@property (nonatomic, retain) NSMutableArray *arrData;
@end

@implementation ConnectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_ATTEMPTINGTOPAIRWITHMHUB_HEADER];

    if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
        [self connectSSDPDevice];
    } else if (mHubManagerInstance.objSelectedHub.Generation == mHubPro || mHubManagerInstance.objSelectedHub.Generation == mHub4KV4 || mHubManagerInstance.objSelectedHub.Generation == mHubMAX || mHubManagerInstance.objSelectedHub.Generation == mHubAudio){
        [self apiGetmHubDetails];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCloseSafari object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kNotificationCloseSafari
                                               object:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    [self.lblHeaderMessage setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontLight10];
    } else {
        [self.lblHeaderMessage setFont:textFontLight13];
    }
    self.arrData = [[NSMutableArray alloc] init];
    [[AppDelegate appDelegate] setShouldRotate:NO];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontLight10];
    } else {
        [self.lblHeaderMessage setFont:textFontLight13];
    }
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) receiveNotification:(NSNotification *) notification {
    DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
    mHubManagerInstance.objSelectedHub.BootFlag = true;
    [safariVC dismissViewControllerAnimated:YES completion:nil];
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_ATTEMPTINGTOPAIRWITHMHUB_HEADER];
    [self.lblHeaderMessage setText:HUB_ATTEMPTINGTOPAIRWITHMHUB_MESSAGE];
    self.arrData = [[NSMutableArray alloc] init];
    [self.tblConnect reloadData];
    [self apiGetmHubDetails];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SFSafariViewController delegate methods
-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
        // Load finished
}

-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
        // Done button pressed
    
}

#pragma mark - REST API methods

-(void) apiGetmHubDetails {
    self.imgDeviceLogo.hidden = true;
    @try {
        [self.lblHeaderMessage setText:HUB_ATTEMPTINGTOPAIRWITHMHUB_MESSAGE];
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:HUB_CONNECTING];
        [APIManager getmHubDetails_DataSync:false completion:^(APIResponse *responseObject) {
            if (responseObject.error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AppDelegate appDelegate].isDeviceNotFound = true;
                    [self.navigationController popToRootViewControllerAnimated:NO];
                });
            } else {
                Hub *objHub = (Hub *)responseObject.response;
                [self mHubConnectionCompletionMethod:objHub];
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - SSDP Method
-(void)connectSSDPDevice {
    [self.lblHeaderMessage setText:HUB_ATTEMPTINGTOPAIRWITHMHUB_MESSAGE];
    [SSDPManager connectSSDPmHub_Completion:^(APIResponse *objResponse) {
        if (objResponse.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                [AppDelegate appDelegate].isDeviceNotFound = true;
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        } else {
            Hub *objHub = (Hub *)objResponse.response;
            [self mHubConnectionCompletionMethod:objHub];
        }
    }];
}

#pragma mark - mHub Connection Completion Method
-(void) mHubConnectionCompletionMethod:(Hub*)objHub {
    ThemeColor *objTheme = [AppDelegate appDelegate].themeColours;
    
    self.imgDeviceLogo.hidden = false;
    [self.imgDeviceLogo setTintColor:[AppDelegate appDelegate].themeColours.themeType == Dark ? colorWhite : colorBlack];
    switch (objHub.Generation) {
        case mHubPro: {
            if (objHub.InputCount == 4) {
                if ([objHub.modelName isContainString:kDEVICEMODEL_MHUBPRO4440]) {
                    self.imgDeviceLogo.image = objTheme.themeType == Light ? kDEVICEMODEL_IMAGE_MHUBPRO4440_SNOW : kDEVICEMODEL_IMAGE_MHUBPRO4440_CARBONITE;
                } else {
                    self.imgDeviceLogo.image = objTheme.themeType == Light ? kDEVICEMODEL_IMAGE_MHUB4K44PRO_SNOW : kDEVICEMODEL_IMAGE_MHUB4K44PRO_CARBONITE;
                }
            } else if (objHub.InputCount == 8) {
                if ([objHub.modelName isContainString:kDEVICEMODEL_MHUBPRO8840]) {
                    self.imgDeviceLogo.image = objTheme.themeType == Light ? kDEVICEMODEL_IMAGE_MHUBPRO8840_SNOW : kDEVICEMODEL_IMAGE_MHUBPRO8840_CARBONITE;
                } else {
                    self.imgDeviceLogo.image = objTheme.themeType == Light ? kDEVICEMODEL_IMAGE_MHUB4K88PRO_SNOW : kDEVICEMODEL_IMAGE_MHUB4K88PRO_CARBONITE;
                }
            }
            break;
        }
        case mHub4KV4: {
            if (objHub.InputCount == 4) {
                self.imgDeviceLogo.image = objTheme.themeType == Light ? kDEVICEMODEL_IMAGE_MHUB431U_SNOW : kDEVICEMODEL_IMAGE_MHUB431U_CARBONITE;
            } else if (objHub.InputCount == 8) {
                self.imgDeviceLogo.image = objTheme.themeType == Light ? kDEVICEMODEL_IMAGE_MHUB862U_SNOW : kDEVICEMODEL_IMAGE_MHUB862U_CARBONITE;
            }
            break;
        }
        case mHubMAX: {
            self.imgDeviceLogo.image = objTheme.themeType == Light ? kDEVICEMODEL_IMAGE_MHUBMAX44_SNOW : kDEVICEMODEL_IMAGE_MHUBMAX44_CARBONITE;
            break;
        }
        case mHubAudio: {
            self.imgDeviceLogo.image = objTheme.themeType == Light ? kDEVICEMODEL_IMAGE_MHUBAUDIO64_SNOW : kDEVICEMODEL_IMAGE_MHUBAUDIO64_CARBONITE;
            break;
        }
            
        case mHub4KV3: {
            if (objHub.InputCount == 4) {
                self.imgDeviceLogo.image = objTheme.themeType == Light ? kDEVICEMODEL_IMAGE_MHUB4K431_SNOW : kDEVICEMODEL_IMAGE_MHUB4K431_CARBONITE;
            } else if (objHub.InputCount == 8) {
                self.imgDeviceLogo.image = objTheme.themeType == Light ? kDEVICEMODEL_IMAGE_MHUB4K862_SNOW : kDEVICEMODEL_IMAGE_MHUB4K862_CARBONITE;
            }
            break;
        }
        default:
            break;
    }
    
    if (objHub.BootFlag) {
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_CONNECTED_HEADER];
        [self.lblHeaderMessage setText:HUB_CONNECTED_MESSAGE];

        self.arrData = [[NSMutableArray alloc] initWithObjects:HUB_CONNECTED_BUTTON, nil];
        [self.tblConnect setTag:102];
        [self.tblConnect reloadData];
    } else {
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_NOTSETUP_HEADER];
        [self.lblHeaderMessage setText:HUB_NOTSETUP_MESSAGE];
        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:HUB_NOTSETUP_MESSAGE];
        self.arrData = [[NSMutableArray alloc] initWithObjects:HUB_NOTSETUP_BUTTON, nil];
        [self.tblConnect setTag:101];
        [self.tblConnect reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    }
    cell.lblCell.text = [[self.arrData objectAtIndex:indexPath.row] uppercaseString];
    return cell;
}

#pragma mark - UITableView Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        switch (tableView.tag) {
            case 101: {
                if ([SFSafariViewController class] != nil) {
                    // Use SFSafariViewController
                    safariVC = [[SFSafariViewController alloc]initWithURL:[[API mHUBInstallationURL] absoluteURL]];
                    safariVC.delegate = self;
                    [self presentViewController:safariVC animated:YES completion:nil];
                } else {
                    NSURL *url = [[API mHUBInstallationURL] absoluteURL];
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        if (!success) {
                            DDLogError(@"%@%@",@"Failed to open url:",[url description]);
                        }
                    }];
                }

                break;
            }
                
            case 102: {
                if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_ATTEMPTINGTOPAIRWITHMHUB_HEADER];
                    [self.lblHeaderMessage setText:HUB_ATTEMPTINGTOPAIRWITHMHUB_MESSAGE];
                    
                    [mHubManagerInstance syncGlobalManagerObjectV0];
                    [mHubManager saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    [self showSettingsStoryBoard];

                } else if (mHubManagerInstance.objSelectedHub.Generation == mHubPro || mHubManagerInstance.objSelectedHub.Generation == mHub4KV4 || mHubManagerInstance.objSelectedHub.Generation == mHubMAX) {
                    
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_ATTEMPTINGTOPAIRWITHMHUB_HEADER];
                    [self.lblHeaderMessage setText:HUB_ATTEMPTINGTOPAIRWITHMHUB_MESSAGE];
                    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
                    [APIManager getmHubDetails_DataSync:true completion:^(APIResponse *responseObject) {
                        if (responseObject.error) {
                            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.response];
                        } else {
                            [mHubManager saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:HUB_SUCCESS];

                            if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
                                [self showControlStoryBoard];
                            } else {
                                [self showSettingsStoryBoard];
                            }
                        }
                    }];
                }

                break;
            }
                
            default:
                break;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) showControlStoryBoard {
    @try {
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
@end
