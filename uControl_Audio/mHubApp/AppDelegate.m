//
//  AppDelegate.m
//  mHubApp
//
//  Created by Anshul Jain on 17/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "UIAlertController+Window.h"
#import <WatchConnectivity/WatchConnectivity.h>
@import HockeySDK;

@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    _arrayInput = [[NSMutableArray alloc]init];
    _arrayOutPut = [[NSMutableArray alloc]init];
    _arrayAVR = [[NSMutableArray alloc]init];
    
    if(WCSession.isSupported){
        WCSession *sessionWatch = WCSession.defaultSession;
        [sessionWatch activateSession];
    }
    [[IQKeyboardManager sharedManager] setEnable:true];
    
  //  self.arrDeviceAddedForProfile =  [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeDidChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    //Color change to White. previously it was colorDarkGray_484847
    self.activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScale tintColor:colorDarkGray_666666];
    
    self.activityIndicatorViewTemparory = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScale tintColor:colorDarkGray_666666];
    
    self.arrControlData = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ControlIcon" ofType:@"plist"]];
    
    self.deviceType = [Utility deviceType];
    self.isDeviceNotFound = false;
    self.isRebootNavigation = false;
    self.isSearchNetworkPopVC = false;
    
    self.pressVal = 0.4;
    self.holdVal = 0.75;
    self.tapTimes = 10;
    
    //NSLog(@"Screen Resolution %f %f and scale %ld",SCREEN_WIDTH,SCREEN_HEIGHT,(long)[[UIScreen mainScreen] scale]);
    
    /*if (IS_IPHONE_X_HEIGHT) {
     application.statusBarHidden = NO;
     UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
     if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
     statusBar.backgroundColor = colorBlack;
     }
     } else {
     application.statusBarHidden = NO;
     }*/
    // DDLogDebug(@"Device Size %@", NSStringFromCGSize([[UIScreen mainScreen]bounds].size));
    // DDLogDebug(@"Device Size Diagonal = %lu", self.deviceType);
    
#ifdef DEVELOPMENT
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"cab9542f2bc14c7f91ec1241bfb9c0b0"];
    // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    [self hockeyEventLog:NSStringFromClass([AppDelegate class])];
#else
    // Method to Skip Document Directory Images.
    [self addSkipBackupAttributeToItemAtURL];
    
    // Method to check Current App version and Store App Version.
    [self methodToCheckUpdatedVersionOnAppStore];
#endif
    
    
    // Screen Stay awake
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // UISlider Thumb Image Set
    [[UISlider appearance] setThumbImage:kImageIconAudioSlider forState:UIControlStateNormal];
    
    
    // UIPageControl
    //    UIPageControl *pageControl = [UIPageControl appearance];
    //    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    //    pageControl.backgroundColor = [UIColor whiteColor];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self bugLifeSettings];
        UIApplicationShortcutItem *shortcutItem = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
        return ![self handleShortCutItem:shortcutItem];
    } else {
        return YES;
    }
}


-(void)volumeDidChange:(NSNotification * ) notification
{
    
    // DDLogDebug(@"AVSystemController_AudioVolumeNotificationParameter %@",notification.userInfo);
    [[CustomAVPlayer sharedInstance] setHardwareVolumeControl];
    // float temp = [[notification userInfo]valueForKey:@"AVSystemController_AudioVolumeNotificationParameter"];
    //    let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
    
}



#pragma mark - BugLife Methods

-(void) bugLifeSettings {
    // [[Buglife sharedBuglife] startWithEmail:@"yagrawal@raveinfosys.com"];
    [[Buglife sharedBuglife] startWithAPIKey:@"4RfPTwrv56KDQ9CL9Tsk2gtt"];
    [Buglife sharedBuglife].invocationOptions = LIFEInvocationOptionsNone;
    [Buglife sharedBuglife].delegate = self;
    id<LIFEAppearance> appearance = [[Buglife sharedBuglife] appearance];
    //    appearance.tintColor = colorBlue;
    appearance.barTintColor = colorGray_646464;
    //    appearance.titleTextAttributes = @{ NSForegroundColorAttributeName : colorWhite };
    appearance.statusBarStyle = UIStatusBarStyleDefault;
    
    /// Objective-C
    LIFETextInputField *userEmail = [LIFETextInputField userEmailInputField];
    userEmail.required = YES;
    LIFETextInputField *summaryField = [LIFETextInputField summaryInputField];
    summaryField.required = YES;
    
    LIFETextInputField *descriptionField = [[LIFETextInputField alloc] initWithAttributeName:@"Description"];
    descriptionField.placeholder = @"Use this form to report bugs in uControl only (buttons not working, functions like sequences of volume control working strangely, typos or bad descriptions etc). If you are experiencing picture, audio or cabling problems that are not directly attached to uControl then report the issue to our technical team for assistance instead: support@hdanywhere.com.";
    descriptionField.multiline = YES;
    LIFEPickerInputField *reproducibilityField = [[LIFEPickerInputField alloc] initWithAttributeName:@"Reproducibility"];
    [reproducibilityField setOptions:@[@"Always", @"Sometimes", @"Rarely"]];
    LIFETextInputField *stepsField = [[LIFETextInputField alloc] initWithAttributeName:@"Steps to reproduce"];
    stepsField.multiline = YES;
    [[Buglife sharedBuglife] setStringValue:@"Use this form to report bugs in uControl only (buttons not working, functions like sequences of volume control working strangely, typos or bad descriptions etc). If you are experiencing picture, audio or cabling problems that are not directly attached to uControl then report the issue to our technical team for assistance instead: support@hdanywhere.com." forAttribute:@"Description"];
    [Buglife sharedBuglife].inputFields = @[userEmail,descriptionField, summaryField, reproducibilityField, stepsField];
}

- (NSString *)buglife:(Buglife *)buglife titleForPromptWithInvocation:(LIFEInvocationOptions)invocation {
    return @"We love bug reports!";
}

#pragma mark - Skip LocalFiles Backup
- (BOOL)addSkipBackupAttributeToItemAtURL {
    NSString *docsDir;
    NSArray *dirPaths;
    NSURL * finalURL;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    finalURL = [NSURL fileURLWithPath:docsDir];
    
    assert([[NSFileManager defaultManager] fileExistsAtPath: [finalURL path]]);
    NSError *error = nil;
    BOOL success = [finalURL setResourceValue: [NSNumber numberWithBool: YES]
                                       forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        DDLogError(@"Error excluding %@ from backup %@", [finalURL lastPathComponent], error);
    }
    return success;
}

#pragma mark - Application States Methods
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
    [[NetworkController sharedInstance] disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [SSDPManager checkSSDPmHubConnection];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [SSDPManager checkSSDPmHubConnection];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
    [[NetworkController sharedInstance] disconnect];
}

-(BOOL) application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    //hdamobile://installation?bootflag=1
    //    if([[url absoluteString] isEqualToString:@"hdamobile://installation?bootflag=1"])
    //    {
    ////        safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:[[API mHUBInstallationURL] absoluteString]]];
    ////        safariVC.delegate = self;
    ////        [self presentViewController:safariVC animated:YES completion:nil];
    //    }
    //    else
    //    {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCloseSafari object:self];
    //
    //    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCloseSafari object:self];
    return true;
}

#pragma mark - Hudview Methods
-(void) showHudView:(ShowHudType) hudType Message:(NSString*)strMessage {
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (hudType) {
                case ShowIndicator: {
                    self.activityIndicatorView.center = self.window.center;
                    [self.window addSubview:self.activityIndicatorView];
                    [self.activityIndicatorView startAnimating];
                    
                } break;
                case ShowIndicatorTemparory: {
                    [self hideHudView:HideIndicator Message:@""];
                    self.activityIndicatorViewTemparory.center = self.window.center;
                    [self.window addSubview:self.activityIndicatorViewTemparory];
                    [self.activityIndicatorViewTemparory startAnimating];
                } break;
                case ShowMessage: {
                    [self hideHudView:HideIndicator Message:@""];
                    if ([strMessage isNotEmpty] && ![strMessage containsString:@"data parameter is nil"]) {
                        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                        style.messageFont = textFontLight13;
                        style.messageColor = colorWhite;
                        style.messageAlignment = NSTextAlignmentCenter;
                        style.backgroundColor = colorDarkGray_484847;
                        [self.window makeToast:strMessage
                                      duration:3.0
                                      position:CSToastPositionCenter
                                         style:style];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            //[self.window setUserInteractionEnabled:NO];
        });
    } @catch (NSException *exception) {
        [self exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) hideHudView:(HideHudType) hudType Message:(NSString*)strMessage {
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (hudType) {
                case HideIndicator: {
                    [self.activityIndicatorView stopAnimating];
                    [self.activityIndicatorView removeFromSuperview];
                    
                }
                break;
                case HideIndicatorTemparory: {
                    [self.activityIndicatorViewTemparory stopAnimating];
                    [self.activityIndicatorViewTemparory removeFromSuperview];
                    
                }
                break;
                case ErrorMessage: {
                    [self hideHudView:HideIndicator Message:@""];
                    if ([strMessage isNotEmpty] && ![strMessage containsString:@"data parameter is nil"]) {
                        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                        style.messageFont = textFontLight13;
                        style.messageColor = colorWhite;
                        style.messageAlignment = NSTextAlignmentCenter;
                        style.backgroundColor = colorDarkGray_484847;
                        [self.window makeToast:strMessage
                                      duration:3.0
                                      position:CSToastPositionCenter
                                         style:style];
                        
                    }
                }
                    break;
                    
                default:
                    break;
            }
            //[self.window setUserInteractionEnabled:YES];
        });
    } @catch (NSException *exception) {
        [self exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - AlertController
-(void) alertControllerReSyncUControlConfirmation {
    @try {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(HUB_RESYNCUCONTROL_CONFIRMATION, nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        alertController.view.tintColor = colorGray_646464;
        
        NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:HUB_RESYNCUCONTROL_CONFIRMATION];
        [strAttributedTitle addAttribute:NSFontAttributeName value:textFontLight13 range:NSMakeRange(0, strAttributedTitle.length)];
        [alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
        
        UIAlertAction *actionYES = [UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_YES, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                [APIManager getSystemDetails:mHubManagerInstance.objSelectedHub  Stacked:mHubManagerInstance.isPairedDevice Slave:mHubManagerInstance.arrSlaveAudioDevice];
            } else {
                [APIManager resyncMHUBProData];
            }
        }];
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_NO, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:actionYES];
        [alertController addAction:actionNO];
        [alertController show];
        
    } @catch (NSException *exception) {
        [self exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


-(void) alertControllerReStartAfterMOSUpdate {
    @try {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(HUB_RESTART_MHUBSYSTEM, nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        alertController.view.tintColor = colorGray_646464;
        
        NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:HUB_RESTART_MHUBSYSTEM];
        [strAttributedTitle addAttribute:NSFontAttributeName value:textFontLight13 range:NSMakeRange(0, strAttributedTitle.length)];
        [alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
        
        UIAlertAction *actionYES = [UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_YES, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showNewMainStoryBoard];
        }];
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_NO, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:actionYES];
        [alertController addAction:actionNO];
        [alertController show];
        
    } @catch (NSException *exception) {
        [self exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)showNewMainStoryBoard {
    @try {
        [AppDelegate appDelegate].flowType = HDA_SetupFlow;
        UIStoryboard *storyboard = mainStoryboard;
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        UIViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"NewSetupVC"];
        
        vc1.navigationItem.hidesBackButton = true;
        // vc1.navigationItem.backBarButtonItem = customBackBarButton;
        
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        window.rootViewController = navigationController;
        [window crossDissolveTransitionWithAnimations:nil AndCompletion:nil];
        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)btnSendComment_pressed
{
    if ([[[[AppDelegate appDelegate] window] rootViewController] isKindOfClass:[MainViewController class]])
    {
        MainViewController * main = (MainViewController *)[[[AppDelegate appDelegate] window] rootViewController];
        
        ControlNavigationController * nav = (ControlNavigationController *)main.rootViewController;
        
        [nav popViewControllerAnimated:true];

    }else
    {
        UINavigationController * nav = (UINavigationController *)[[[AppDelegate appDelegate] window] rootViewController];
        
        [nav popViewControllerAnimated:true];

    }
    
}
-(void)btnSendComment_pressed2
{
    MainViewController * main = (MainViewController *)[[[AppDelegate appDelegate] window] rootViewController];
    
    ControlNavigationController * nav = (ControlNavigationController *)main.rootViewController;
    
    [nav popViewControllerAnimated:true];

}

-(void)backButton
{
    // [self popViewControllerAnimated:YES];
    
}
-(void) alertControllerShowMessage:(NSString*)strMessage {
    @try {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE, nil) message:NSLocalizedString(strMessage, nil) preferredStyle:UIAlertControllerStyleAlert];
        alertController.view.tintColor = colorGray_646464;
        NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERT_TITLE];
        [strAttributedTitle addAttribute:NSFontAttributeName value:textFontLight13 range:NSMakeRange(0, strAttributedTitle.length)];
        [alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_OK, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [alertController show];
    } @catch (NSException *exception) {
        [self exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)logoutORRemoveMhub{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            [SSDPManager disconnectSSDPmHub];
        }
        [mHubManagerInstance deletemHubManagerObjectData];
        // Wait 2 seconds while app is going background
        // [NSThread sleepForTimeInterval:2.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self showNewMainStoryBoard];
        });
    });
}

-(void) alertControllerAppUpdate {
    @try {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE, nil) message:NSLocalizedString(HUB_APPUPDATE_MESSAGE, nil) preferredStyle:UIAlertControllerStyleAlert];
        alertController.view.tintColor = colorGray_646464;
        NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERT_TITLE];
        [strAttributedTitle addAttribute:NSFontAttributeName
                                   value:textFontLight13
                                   range:NSMakeRange(0, strAttributedTitle.length)];
        [alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_UPDATE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *iTunesLink = @"https://itunes.apple.com/us/app/ucontrol/id1187839463?ls=1&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink] options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    DDLogError(@"%@%@",@"Failed to open url:",[[NSURL URLWithString:iTunesLink] description]);
                }
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_CANCEL, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [alertController show];
    } @catch (NSException *exception) {
        [self exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) alertControllerMOSUpdate:(Hub*)objHub {
    @try {
        //UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE, nil) message:[NSString stringWithFormat:HUB_MOSUPDATE_MESSAGE, [Hub getMhubDisplayName:objHub]] preferredStyle:UIAlertControllerStyleAlert];
        if (![objHub.modelName isContainString:kDEVICEMODEL_MHUBAUDIO64])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE_UPDATE_AVAILABLE, nil) message:[NSString stringWithFormat:HUB_MOSUPDATE_MESSAGE_Without_Model] preferredStyle:UIAlertControllerStyleAlert];
            alertController.view.tintColor = colorGray_646464;
            NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERT_TITLE];
            [strAttributedTitle addAttribute:NSFontAttributeName
                                       value:textFontLight13
                                       range:NSMakeRange(0, strAttributedTitle.length)];
            //[alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
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
                //NSString *strAddress =   [NSString stringWithFormat:@"%@/update-step1.php", objHub.Address];
                // NSURL *url = [[API MHUBOSIndexPageURL:strAddress] absoluteURL];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    if (!success) {
                        DDLogError(@"%@%@",@"Failed to open url:",[url description]);
                    }
                }];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_CANCEL, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }]];
            [alertController show];
        }
    } @catch (NSException *exception) {
        [self exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) exceptionLog:(NSException*)exception Function:(const char *)function Line:(int)line {
    //NSLog(@"crash happens");
    DDLogError(EXCEPTIONLOG, function, line, exception);
    //[self hideHudView:ErrorMessage Message:[exception debugDescription]];
}

-(void) hockeyEventLog:(NSString*)strClass {
    NSString *strLog = [NSString stringWithFormat:TRACKINGLOG, [Utility deviceNameByCode], strClass];
    DDLogDebug(@"%@", strLog);
    [[BITHockeyManager sharedHockeyManager].metricsManager trackEventWithName:strLog];
}

#pragma mark - Orientation Method
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.shouldRotate)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    else
        return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Method to check for updated version on App Store
-(void) methodToCheckUpdatedVersionOnAppStore {
    @try {
        [APIManager methodToCheckUpdatedVersionOnAppStore_WithCompletion:^(BOOL isUpdate) {
            if(isUpdate) {
                //DDLogDebug(@"Need to update [%@ != %@]", appStoreVer, currentVer);
                [self alertControllerAppUpdate];
            }
        }];
    } @catch (NSException *exception) {
        [self exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Quick Action Handler
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    [self handleShortCutItem:shortcutItem];
}

- (BOOL)handleShortCutItem:(UIApplicationShortcutItem *)shortcutItem {
    __block BOOL handled = NO;
    
    if (shortcutItem == nil) {
        return handled;
    }
    Sequence *obj = [Sequence getObjectFromDictionary:shortcutItem.userInfo];
    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
    if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
        [APIManager executeSequence:mHubManagerInstance.objSelectedHub.Address SequenceId:obj.macro_id isSuperSeq:obj.isFunction  completion:^(APIV2Response *responseObject) {
            if (!responseObject.error) {
                handled = YES;
            }
        }];
    } else {
        [APIManager playMacro_AlexaName:obj.alexa_name completion:^(APIResponse *responseObject) {
            if (!responseObject.error) {
                handled = YES;
            }
        }];
    }
    return handled;
}

@end
