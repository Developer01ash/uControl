//
//  AppDelegate.h
//  mHubApp
//
//  Created by Anshul Jain on 17/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlNavigationController.h"
#import "IQKeyboardManager.h"

@import SafariServices;
    // ** Global enum to show and hide type of ProgressHud View ** //
typedef enum {
    ShowIndicator = 0,
    ShowMessage = 1,
    ShowIndicatorTemparory = 2
} ShowHudType;

typedef enum {
    HideIndicator = 0,
    ErrorMessage = 1,
    HideIndicatorTemparory= 2
} HideHudType;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, BuglifeDelegate,SFSafariViewControllerDelegate>
{
    SFSafariViewController *safariVC;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DGActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) DGActivityIndicatorView *activityIndicatorViewTemparory;
@property (strong, nonatomic) NSArray *arrControlData;
@property (assign, nonatomic) BOOL shouldRotate;
@property (assign, nonatomic) DeviceType deviceType;
@property (retain, nonatomic) ThemeColor *themeColours;
@property (retain, nonatomic) ThemeColor *themeColoursSetup;
@property (assign, nonatomic) BOOL isDeviceNotFound;
@property (assign, nonatomic) BOOL isRebootNavigation;
@property (assign, nonatomic) BOOL isSearchNetworkPopVC;
@property (assign, nonatomic) HDAMHUBSystemType systemType;
@property (assign, nonatomic) HDAMHUBFlow flowType;
@property (strong, nonatomic) NSMutableArray *arrayInput;
@property (strong, nonatomic) NSMutableArray *arrayOutPut;
@property (strong, nonatomic) NSMutableArray *arrayAVR;
@property (assign, nonatomic) double pressVal;
@property (assign, nonatomic) double holdVal;
@property (assign, nonatomic) NSInteger tapTimes;


-(void)btnSendComment_pressed;
-(void)btnSendComment_pressed2;
+(AppDelegate *)appDelegate;
-(void) showHudView:(ShowHudType) hudType Message:(NSString*)strMessage;
-(void) hideHudView:(HideHudType) hudType Message:(NSString*)strMessage;
-(void) methodToCheckUpdatedVersionOnAppStore;
-(void) alertControllerReSyncUControlConfirmation;
-(void)alertControllerReStartAfterMOSUpdate;
-(void) alertControllerShowMessage:(NSString*)strMessage;
-(void) alertControllerMOSUpdate:(Hub*)objHub;
-(void) exceptionLog:(NSException*)exception Function:(const char *)function Line:(int)line;
-(void) hockeyEventLog:(NSString*)strClass;

@end

