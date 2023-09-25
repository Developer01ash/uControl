//
//  SplashVC.m
//  mHubApp
//
//  Created by Anshul Jain on 17/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/*
 As name specify, first VC to load after didFinishLaunching. In this class functionality like cache data reload, theme load and connection will check. According which next screen is loaded i.e. NewSetUpVC, ControlVC, SourceSwitchVC
 */

#import "SplashVC.h"
#import "MainViewController.h"
#import "APIManager.h"

@interface SplashVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblLoadingMessage;
@end

@implementation SplashVC

- (void)viewDidLoad {
    @try {
    [super viewDidLoad];
       
    self.navigationItem.backBarButtonItem = customBackBarButton;
        // Do any additional setup after loading the view, typically from a nib.
        [self getThemeColorObject];

        [self getMHUBManagerObject];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @try {
        [self.lblLoadingMessage setText:HUB_LOADING];
        [self.lblLoadingMessage setTextColor:colorGray_646464];

        NSString *string = HUB_LANDINGPAGE_MESSAGE;
        NSRange rangeEntertainment = [string rangeOfString:@"Entertainment"];
        NSRange rangeTechnology = [string rangeOfString:@"Technology"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        // And before you set the bold range, set your attributed string (the whole range!) to the new attributed font name
        if ([AppDelegate appDelegate].deviceType == mobileSmall ) {
            [attrString setAttributes:@{ NSFontAttributeName: textFontRegular12 } range:NSMakeRange(0, string.length - 1)];
            [attrString setAttributes:@{ NSFontAttributeName: textFontBold12 } range:rangeEntertainment];
            [attrString setAttributes:@{ NSFontAttributeName: textFontBold12 } range:rangeTechnology];
        } else {
            [attrString setAttributes:@{ NSFontAttributeName: textFontRegular16 } range:NSMakeRange(0, string.length - 1)];
            [attrString setAttributes:@{ NSFontAttributeName: textFontBold16 } range:rangeEntertainment];
            [attrString setAttributes:@{ NSFontAttributeName: textFontBold16 } range:rangeTechnology];
        }
        [self.lblHeaderMessage setAttributedText:attrString];

        NSString *strAddTemp = [NSString stringWithFormat:@"%@", mHubManagerInstance.objSelectedHub.Address];
        //DDLogDebug(@"MHUB Address : %@", strAddTemp);
        //DDLogDebug(@"MHUB Paired : %@", mHubManagerInstance.objSelectedHub.isPaired ? @"true" : @"false");
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString * savedVersionString =     [userDefault objectForKey:kAppSavedVersion];
        NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
         if(mHubManagerInstance.objSelectedHub.modelName != nil && ![mHubManagerInstance.objSelectedHub.modelName isEqualToString:@"MHUBFake"] && ([userDefault boolForKey:kAppLaunchFirstTime]))
         {
         [userDefault setBool:YES forKey:KUSERWASLOGGEDIN];
         
         }
         if(![appVersionString isEqualToString:savedVersionString] && [appVersionString floatValue] <= 2.0)
         {
         [userDefault setBool:YES forKey:kLogoutOnUpdate];
         [userDefault setValue:appVersionString forKey:kAppSavedVersion];
             
             //Take user out from the main UI of application. In Short Disconnect
         [self logoutORRemoveMhub];
         [userDefault synchronize];
         }
         
         if(![userDefault boolForKey:kAppLaunchFirstTime]){
         [userDefault setBool:YES forKey:kAppLaunchFirstTime];
         [userDefault synchronize ];
         
         }
         
        //
        if ([strAddTemp isIPAddressEmpty]) {
            [self showNewMainStoryBoard];
        } else {
            if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
                [self showControlStoryBoard];
            } else if ([mHubManagerInstance.objSelectedHub isSwitchSupportOnly]){
                [self showSettingsStoryBoard];
            } else {
                [self showNewMainStoryBoard];
            }
        }
       
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void)logoutORRemoveMhub
{
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


-(void)getThemeColorObject {
    @try {
        ThemeColor *objTheme;
        //Below code is added because we are not supporting light theme now, so if any user using it, it'll convert in DARK always.
        objTheme = [[ThemeColor alloc] initWithThemeColor:[ThemeColor themeColorData:Dark]];
        [AppDelegate appDelegate].themeColours = [[ThemeColor alloc] initWithThemeColor:objTheme];
        [ThemeColor saveCustomObject:objTheme key:kCOLORTHEMEOBJECT];
        //Above code is added because we are not supporting light theme now, so if any user using it, it'll convert in DARK always.
         objTheme = [ThemeColor retrieveCustomObjectWithKey:kCOLORTHEMEOBJECT];
        BOOL isButtonBorder = objTheme.isButtonBorder;
        BOOL isButtonVibration = objTheme.isButtonVibration;

        if ([objTheme isNotEmpty]) {
            switch (objTheme.themeType) {
                case Dark: {
                    objTheme = [[ThemeColor alloc] initWithThemeColor:[ThemeColor themeColorData:Dark]];
                    break;
                }
                case Light: {
                    objTheme = [[ThemeColor alloc] initWithThemeColor:[ThemeColor themeColorData:Light]];
                    break;
                }
                default:
                    break;
            }
        } else {
            objTheme = [[ThemeColor alloc]initWithThemeColor:[ThemeColor themeColorData:Dark]];
            isButtonBorder = true;
            isButtonVibration = false;
        }
        objTheme.isButtonBorder = isButtonBorder;
        objTheme.isButtonVibration = isButtonVibration;
        [ThemeColor saveCustomObject:objTheme key:kCOLORTHEMEOBJECT];
        [AppDelegate appDelegate].themeColours = [[ThemeColor alloc] initWithThemeColor:objTheme];
        [AppDelegate appDelegate].themeColoursSetup = [[ThemeColor alloc] initWithThemeColor:[ThemeColor themeColorData:Dark]];

        //DDLogDebug(@"ThemeColor == %@", objTheme);
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)getMHUBManagerObject {
    @try {
        mHubManager *objManager = [mHubManagerInstance retrieveCustomObjectWithKey:kMHUBMANAGERINSTANCE];
        mHubManagerInstance.objSelectedHub              = [[Hub alloc] initWithHub:objManager.objSelectedHub];
        mHubManagerInstance.objSelectedOutputDevice     = objManager.objSelectedOutputDevice;
        mHubManagerInstance.objSelectedInputDevice      = objManager.objSelectedInputDevice;
        mHubManagerInstance.arrLeftPanelRearranged      = [[NSMutableArray alloc] initWithArray:objManager.arrLeftPanelRearranged];
        mHubManagerInstance.arrSourceDeviceManaged      = [[NSMutableArray alloc] initWithArray:objManager.arrSourceDeviceManaged];
        mHubManagerInstance.arrAudioSourceDeviceManaged     = [[NSMutableArray alloc] initWithArray:objManager.arrAudioSourceDeviceManaged];
        mHubManagerInstance.arrayAVR      = [[NSMutableArray alloc] initWithArray:objManager.arrayAVR];
        mHubManagerInstance.arrayOutPut      = [[NSMutableArray alloc] initWithArray:objManager.arrayOutPut];
        mHubManagerInstance.arrayInput      = [[NSMutableArray alloc] initWithArray:objManager.arrayInput];
        
        if (mHubManagerInstance.objSelectedHub.Generation != mHub4KV3) {
            mHubManagerInstance.appApiVersion           = objManager.appApiVersion;
            mHubManagerInstance.strMOSVersion           = objManager.strMOSVersion;
            mHubManagerInstance.mosVersion              = objManager.mosVersion;

            mHubManagerInstance.objSelectedZone         = objManager.objSelectedZone;
            mHubManagerInstance.objSelectedGroup        = objManager.objSelectedGroup;
            mHubManagerInstance.objSelectedAVRDevice    = objManager.objSelectedAVRDevice;
            mHubManagerInstance.controlDeviceTypeSource = objManager.controlDeviceTypeSource;
            mHubManagerInstance.controlDeviceTypeBottom = objManager.controlDeviceTypeBottom;
            mHubManagerInstance.OutputTypeInSelectedZone = objManager.OutputTypeInSelectedZone;

            mHubManagerInstance.isPairedDevice          = objManager.isPairedDevice;
            mHubManagerInstance.masterHubModel          = objManager.masterHubModel;
            mHubManagerInstance.arrSlaveAudioDevice     = [[NSMutableArray alloc] initWithArray:objManager.arrSlaveAudioDevice];
            mHubManagerInstance.arrSelectedGroupZoneList= [[NSMutableArray alloc] initWithArray:objManager.arrSelectedGroupZoneList];

            [ContinuityCommand saveCustomObject:[ContinuityCommand getDictionaryArray:objManager.objSelectedInputDevice.arrContinuity] key:kSELECTEDCONTINUITYARRAY];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)pageControl_ValueChanged:(CustomPageControl *)sender {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Methods

-(void)showNewMainStoryBoard {
    @try {
        [AppDelegate appDelegate].flowType = HDA_SetupFlow;
        UIStoryboard *storyboard = mainStoryboard;
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        UIViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"NewSetupVC"];
        vc1.navigationItem.backBarButtonItem = customBackBarButton;

        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        window.rootViewController = navigationController;
        [window crossDissolveTransitionWithAnimations:nil AndCompletion:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) showControlStoryBoard {
    @try {
        [AppDelegate appDelegate].flowType = HDA_UControlFlow;
        [AppDelegate appDelegate].isRebootNavigation = true;
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
        [AppDelegate appDelegate].isRebootNavigation = true;
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
