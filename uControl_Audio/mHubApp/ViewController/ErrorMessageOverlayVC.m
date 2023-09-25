//
//  ErrorMessageOverlayVC.m
//  mHubApp
//
//  Created by Anshul Jain on 11/10/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

/*
VC to show error when stored IP address is not connected. This is a overlay Error page with translucent backgroud.
*/

#import "ErrorMessageOverlayVC.h"

@interface ErrorMessageOverlayVC ()<SearchDataManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblErrorHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblErrorMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnFindMHUB;
@property (weak, nonatomic) IBOutlet UIButton *btnConnectManually;

@property (weak, nonatomic) IBOutlet UILabel *lbluControlHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnDismissMHUB;
@property (weak, nonatomic) IBOutlet UIView *view_errorMessage;
@property (weak, nonatomic) IBOutlet UIView *view_updateMessage;
@end

@implementation ErrorMessageOverlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_isFirstAppORMosUpdateAlertPage)
    {
        [self.view_errorMessage setHidden:YES];
        [self.view_updateMessage setHidden:NO];
        self.imgBackground.image = [Utility imageWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.7] Frame:self.imgBackground.frame];
        
        [self.lbluControlHeader setTextColor:colorWhite_254254254];
        
        [self.lblUpdateMessage setTextColor:colorWhite_254254254];
        [self.lblUpdateMessage setText:[NSString stringWithFormat:APP_UPDATE_MESSAGE]];
        
        [self.btnDismissMHUB addBorder_Color:[AppDelegate appDelegate].themeColours.colorHeaderText BorderWidth:1.0];
        [self.btnDismissMHUB setTitleColor:colorWhite_254254254 forState:UIControlStateNormal];
        
        
    }
    else
    {
        [self.view_errorMessage setHidden:NO];
        [self.view_updateMessage setHidden:YES];
        self.imgBackground.image = [Utility imageWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.7] Frame:self.imgBackground.frame];
        
        [self.lblErrorHeader setTextColor:colorWhite_254254254];
        
        [self.lblErrorMessage setTextColor:colorWhite_254254254];
        [self.lblErrorMessage setText:[NSString stringWithFormat:HUB_UNABLETOCONNECT_MESSAGE, mHubManagerInstance.objSelectedHub.Address]];
        
        [self.btnFindMHUB addBorder_Color:[AppDelegate appDelegate].themeColours.colorHeaderText BorderWidth:1.0];
        [self.btnFindMHUB setTitleColor:colorWhite_254254254 forState:UIControlStateNormal];
        
        [self.btnConnectManually addBorder_Color:[AppDelegate appDelegate].themeColours.colorHeaderText BorderWidth:1.0];
        [self.btnConnectManually setTitleColor:colorWhite_254254254 forState:UIControlStateNormal];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnFindMHUB_Clicked:(UIButton *)sender {
    [[SearchDataManager sharedInstance] startSearchNetwork];
    [SearchDataManager sharedInstance].delegate = self;
}


- (IBAction)btnDismiss_Clicked:(UIButton *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)btnConnectManually_Clicked:(UIButton *)sender {
    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
    if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
        [SSDPManager disconnectSSDPmHub];
    }
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:kAppLaunchFirstTime];

     [mHubManagerInstance deletemHubManagerObjectData];
    // Wait 2 seconds while app is going background
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self showNewMainStoryBoard];
    });
}

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
        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - SearchData Delegate
-(void) searchData:(SearchData *)searchData didFindDataArray:(NSMutableArray *)arrSearchedData {
    @try {
        BOOL isDataFound = false;
        for (SearchData *objData in arrSearchedData) {
            for (Hub *objHub in objData.arrItems) {
                // DDLogDebug(@"objHub == %@", [objHub dictionaryRepresentation]);
                if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3 && objHub.Generation == mHub4KV3) {
                    mHubManagerInstance.objSelectedHub = [Hub updateHubAddress_From:objHub To:mHubManagerInstance.objSelectedHub];
                    isDataFound = true;
                    break;
                } else {
                     DDLogDebug(@"Serial Number === %@ : %@", objHub.SerialNo, mHubManagerInstance.objSelectedHub.SerialNo);
                    if ([objHub.SerialNo isEqualToString:mHubManagerInstance.objSelectedHub.SerialNo]) {
                        mHubManagerInstance.objSelectedHub = [Hub updateHubAddress_From:objHub To:mHubManagerInstance.objSelectedHub];
                        isDataFound = true;
                        break;
                    }
                }
            }
        }
        
        if (isDataFound) {
            [self dataFoundViewReload];
        } else {

        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) dataFoundViewReload {
    @try {
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            [mHubManagerInstance syncGlobalManagerObjectV0];
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
        } else {
            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
