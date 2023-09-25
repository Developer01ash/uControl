//
//  NewSetupVC.m
//  mHubApp
//
//  Created by Anshul Jain on 26/02/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "NewSetupVC.h"
#import "SearchNetworkVC.h"
#import "SetupTypeVC.h"
#import "ManuallySetupVC.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>


@import SafariServices;

@interface NewSetupVC () <UINavigationControllerDelegate, SFSafariViewControllerDelegate, UIGestureRecognizerDelegate, UIGestureRecognizerDelegate,CLLocationManagerDelegate> {
    __weak UIView *_staticView;
    SFSafariViewController *safariVC;
    NSInteger selectedPageIndex;
}

@end

@implementation NewSetupVC

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        
       

          locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
          locationManager.delegate = self; // we set the delegate of locationManager to self.
          locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
            [locationManager requestAlwaysAuthorization];

          [locationManager startUpdatingLocation];  //requesting location updates
        self.navigationItem.backBarButtonItem = customBackBarButton;
        ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
        self.navigationController.navigationBarHidden = true;
        self.view.backgroundColor = themeColor.colorBackground;
        
        self.viewLogoBG.backgroundColor = themeColor.colorBackground;
        [self.lblHeaderMessage setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
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
        //self.arrDataSearch = [[NSMutableArray alloc] initWithObjects:HUB_SETUP_A_NEW_MHUB_SYSTEM, HUB_CONNECT_TO_AN_EXISTING_MHUB_SYSTEM, nil];
        self.arrDataSearch = [[NSMutableArray alloc] initWithObjects: HUB_CONNECT_TO_AN_EXISTING_MHUB_SYSTEM, nil];
        self.arrDataManual = [[NSMutableArray alloc] initWithObjects:HUB_ADVANCE_UPDATE_MOS, nil];
        [self.tblSetup reloadData];
        [self.tblSetupManual reloadData];

        [[AppDelegate appDelegate] setShouldRotate:NO];
//        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeGesture:)];
//        [swipeLeft setDelegate:self];
//        [swipeLeft setNumberOfTouchesRequired:1];
//        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//        [self.view addGestureRecognizer:swipeLeft];
//        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGesture:)];
//        [swipeRight setDelegate:self];
//        [swipeRight setNumberOfTouchesRequired:1];
//        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
//        [self.view addGestureRecognizer:swipeRight];
        NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString * versionBuildString = [NSString stringWithFormat:@"v.%@", appVersionString];
        [self.lbl_appVersion setText:versionBuildString];
        
        NSArray *sampleArray = [appVersionString componentsSeparatedByString:@"."];
        //Commented for version 2.4, no need to show update message and logout automatically or disconnect.
//        if([[NSUserDefaults standardUserDefaults]boolForKey:kAppLaunchFirstTime])
//        {
//            if([[NSUserDefaults standardUserDefaults]boolForKey:KUSERWASLOGGEDIN] && [appVersionString floatValue] <= 2.0 )
//            {
//                [self errorMessageOverlayNavigation];
//                [[NSUserDefaults standardUserDefaults]setBool:false forKey:kAppLaunchFirstTime];
//                [[NSUserDefaults standardUserDefaults]setBool:false forKey:KUSERWASLOGGEDIN];
//                [[NSUserDefaults standardUserDefaults] synchronize ];
//            }
//            else
//            {
//                if([[NSUserDefaults standardUserDefaults]boolForKey:KUSERWASLOGGEDIN] && [appVersionString floatValue] >= 2.0 )
//                {
//                    if(sampleArray.count <= 2)
//                    {
//                        if([[sampleArray objectAtIndex:1]integerValue] == 0)
//                        {
//                            [self errorMessageOverlayNavigation];
//                            [[NSUserDefaults standardUserDefaults]setBool:false forKey:kAppLaunchFirstTime];
//                            [[NSUserDefaults standardUserDefaults]setBool:false forKey:KUSERWASLOGGEDIN];
//                            [[NSUserDefaults standardUserDefaults] synchronize ];
//                        }
//                    }
//                }
//            }
//        }
//        [self fetchSSIDInfo];
//        NSLog(@"Connected with wifi name %@ ",[self fetchSSIDInfo]);
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
 //   [self.navigationController.navigationBar setHidden:NO];
    [super viewWillDisappear:animated];
}




-(NSString*)fetchSSIDInfo {

    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();

    NSDictionary *info;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            //NSLog(@"wifi info: bssid: %@, ssid:%@, ssidData: %@", [info objectForKey:@"BSSID"],[info objectForKey:@"SSID"],[info objectForKey:@"SSIDDATA"]);
            [[NSUserDefaults standardUserDefaults] setValue:[info objectForKey:@"SSID"] forKey:CONNECTED_SSID_NAME_KEY];
            return [info objectForKey:@"SSID"];
            break;
        }
    }

    return @"No WiFi Available";
}

-(void) errorMessageOverlayNavigation {
    @try {
        ErrorMessageOverlayVC *objVC = [mainStoryboard   instantiateViewControllerWithIdentifier:@"ErrorMessageOverlayVC"];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.isFirstAppORMosUpdateAlertPage = YES;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self presentViewController:objVC animated:YES completion:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
        CGFloat height = MIN(self.tblSetupManual.bounds.size.height, self.tblSetupManual.contentSize.height);
        self.heightSetupManualConstraint.constant = height;
        // [self.view layoutIfNeeded];

//        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
//            [self.lblHeaderMessage setFont:textFontRegular12];
//        } else {
//            [self.lblHeaderMessage setFont:textFontRegular18];
//        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tblSetup]) {
        return self.arrDataSearch.count;
    } else {
        return self.arrDataManual.count;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            return heightTableViewRowWithPadding_SmallMobile;
        } else {
            return heightTableViewRowWithPadding;
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        static NSString *CellIdentifier = @"CellSetup";
        CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if ([tableView isEqual:self.tblSetup]) {
            cell.lblCell.text = [[self.arrDataSearch objectAtIndex:indexPath.row] uppercaseString];
        } else {
            cell.lblCell.text = [[self.arrDataManual objectAtIndex:indexPath.row] uppercaseString];
            [cell.imgBackground addBorder_Color:colorClear BorderWidth:1.0];
            [cell.lblCell setFont:textFontBold12];
        }
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblCell setFont:textFontBold12];
        } else {
            [cell.lblCell setFont:textFontBold14];
        }
        //[cell.lblCell setFont:textFontBold36];
        return cell;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if ([tableView isEqual:self.tblSetup]) {
            switch (indexPath.row) {
                case 1: {
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
                    [AppDelegate appDelegate].systemType = HDA_SetupANewMHUBSystem;
                    [self.navigationController pushViewController:objVC animated:YES];
                    break;
                }
                case 0: {
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
                    objVC.navigateFromType = menu_autoConnect;
                    [AppDelegate appDelegate].systemType = HDA_ConnectToAnExistingMHUBSystem;
                    [self.navigationController pushViewController:objVC animated:YES];
                    break;
                }
                default: break;
            }
        } else {
            switch (indexPath.row) {
                case 0: {
                    ManuallySetupVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ManuallySetupVC"];
                    [AppDelegate appDelegate].systemType = HDA_ConnectManually;
                    [self.navigationController pushViewController:objVC animated:YES];
                    break;
                }
                case 1: {
                    if ([SFSafariViewController class] != nil) {
                        // Use SFSafariViewController
                        safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:[[API setupHelpURL] absoluteString]]];
                        safariVC.delegate = self;
                        [self presentViewController:safariVC animated:YES completion:nil];
                    } else {
                        NSURL *url = [NSURL URLWithString:[[API setupHelpURL] absoluteString]];
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                            if (!success) {
                                DDLogError(@"%@%@",@"Failed to open url:",[url description]);
                            }
                        }];
                    }
                    break;
                }
                default:
                    break;
            }
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)leftSwipeGesture:(id)sender {
    @try {
        NSInteger intLeftSwipeIndex = selectedPageIndex+1;
        [self.pageControl setCurrentPage:intLeftSwipeIndex];
        selectedPageIndex = self.pageControl.currentPage;
        // DDLogDebug(@"leftSwipeGesture selectedPageIndex == %ld", (long)selectedPageIndex);
        [self.imgDeviceLogo viewFadeOut_FadeIn:self.viewTable];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)rightSwipeGesture:(id)sender {
    @try {
        NSInteger intRightSwipeIndex = selectedPageIndex-1;
        [self.pageControl setCurrentPage:intRightSwipeIndex];
        selectedPageIndex = self.pageControl.currentPage;
        // DDLogDebug(@"rightSwipeGesture selectedPageIndex == %ld", (long)selectedPageIndex);
        [self.viewTable viewFadeOut_FadeIn:self.imgDeviceLogo];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)pageControl_ValueChanged:(CustomPageControl *)sender {
    @try {
        selectedPageIndex = sender.currentPage;
        // DDLogDebug(@"pageControl_ValueChanged selectedPageIndex == %ld", (long)selectedPageIndex);
        switch (selectedPageIndex) {
            case 0: {
                [self.tblSetup viewFadeOut_FadeIn:self.imgDeviceLogo];
                break;
            }
            case 1: {
                [self.imgDeviceLogo viewFadeOut_FadeIn:self.viewTable];
                break;
            }
            default:
                break;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - SFSafariViewController delegate methods
-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    // Load finished
}

-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    // Done button pressed

}


@end
