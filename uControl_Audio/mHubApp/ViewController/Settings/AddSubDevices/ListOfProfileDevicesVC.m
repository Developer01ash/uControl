//
//  ListOfProfileDevicesVC.m
//  mHubApp
//
//  Created by Apple on 29/01/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "ListOfProfileDevicesVC.h"
#import "CellSetting.h"

@interface ListOfProfileDevicesVC ()
@property (weak, nonatomic) IBOutlet UITableView *tblProfileList;
@property (strong, nonatomic) NSMutableArray *arrDeviceList;
@property (strong, nonatomic) IBOutlet CustomButton *btn_back;
@property (strong, nonatomic) IBOutlet CustomButton *btn_confirm;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Title;

@end

@implementation ListOfProfileDevicesVC

- (void)viewDidLoad {
    @try {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
        
        ThemeColor *objColor = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColoursSetup];;
        self.view.backgroundColor = objColor.colorBackground;
    self.tblProfileList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.arrDeviceList  =  [[NSMutableArray alloc]initWithArray:mHubManagerInstance.arrDeviceAddedForProfile];
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:@"Switch System"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SerialNo != %@", mHubManagerInstance.objSelectedHub.SerialNo];
    NSArray *arrCmdDataFiltered = [self.arrDeviceList filteredArrayUsingPredicate:predicate];
    self.arrDeviceList = [NSMutableArray arrayWithArray:arrCmdDataFiltered];
    [self.btn_back setTitleColor:[AppDelegate appDelegate].themeColours.colorNormalText forState:UIControlStateNormal];
        //[self.btn_confirm setTitleColor:[AppDelegate appDelegate].themeColours.colorNormalText forState:UIControlStateNormal];
    [self.btn_back setTitle:ALERT_BTN_TITLE_CANCEL forState:UIControlStateNormal];
        [self.lbl_Title setTextColor:colorMiddleGray_868787];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
           
            [self.lbl_Title setFont:textFontLight18];
        } else {
            
            [self.lbl_Title setFont:textFontLight22];
        }
      
   // [self.btn_back addBorder_Color:[AppDelegate appDelegate].themeColours.colorNormalText BorderWidth:1.0];
   // [self.btn_confirm addBorder_Color:[AppDelegate appDelegate].themeColours.colorNormalText BorderWidth:1.0];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(IBAction)ClickOn_BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)ClickOn_ConfirmButton{
    @try {
//        if(self.arrDeviceList.count <= 1){
//            [[AppDelegate appDelegate]showHudView:ShowMessage Message:HUB_SelectDifferentProfile];
//        }
        if(mHubManagerInstance.objSelectedHub.SerialNo == self.objSelectedMHubDevice.SerialNo)
        {
            [[AppDelegate appDelegate]showHudView:ShowMessage Message:HUB_SelectDifferentProfile];
        }
        else{
    if(self.objSelectedMHubDevice.Generation != mHubFake){
    switch (self.objSelectedMHubDevice.Generation) {
        case mHub4KV3: {
            [self connectSSDPDevice:self.objSelectedMHubDevice];
            break;
        }
        default: {
            [mHubManagerInstance deletemHubManagerObjectData];
            if ([self.objSelectedMHubDevice isAPIV2]) {
                [self getSystemDetails:self.objSelectedMHubDevice Stacked:false Slave:nil];
            } else {
                [self getmHubDetails:self.objSelectedMHubDevice];
            }
            break;
        }
    }
    }
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
       // [[AppDelegate appDelegate] showHudView:ShowMessage Message:@"Connecting to MHUB-OS, this can take up to 30 seconds..."];
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        [APIManager getAllMHUBDetails:objDevice Stacked:isStacked Slave:arrSlaveDevice Sync:true completion:^(APIV2Response *responseObject) {
            if (responseObject.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
            } else {
                // [mHubManager saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:HUB_SUCCESS];
                if ([objDevice isUControlSupport]) {
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
       // [[AppDelegate appDelegate] showHudView:ShowIndicator Message:HUB_CONNECTING];
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        [APIManager getmHubDetails_DataSync:true completion:^(APIResponse *responseObject) {
            if (responseObject.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.response];
            } else {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:HUB_SUCCESS];
                if ([objDevice isUControlSupport]) {
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
   // return 10;
    return self.arrDeviceList.count;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRow_SmallMobile;
    } else {
        return heightTableViewRow;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     @try {
    static NSString *CellIdentifier = @"CellSetting";
    
    CellSetting *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
         
   // SectionSetting *objSection = [self.arrDeviceList objectAtIndex:indexPath.section];
   // RowSetting *objRow = [objSection.arrRow objectAtIndex:indexPath.row];
    Hub *hubObj  = (Hub * )[self.arrDeviceList objectAtIndex:indexPath.row];
    cell.lblCell.text = hubObj.modelName;
    cell.lblCell.textAlignment = NSTextAlignmentLeft;
    cell.lblCell.textColor = [AppDelegate appDelegate].themeColours.colorNormalText;
    [cell.border setBackgroundColor:colorGunGray_272726];
    UIImage *image = [kImageIconNextArrow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    [cell.imgCell setTintColor:[AppDelegate appDelegate].themeColours.colorHeaderText];
    [cell.imgCell setImage:image];
         
         
         if ([AppDelegate appDelegate].deviceType == mobileSmall) {
             [cell.lblCell setFont:textFontBold10];
         } else {
             [cell.lblCell setFont:textFontBold13];
         }
    
//    if([self.objSelectedMHubDevice.SerialNo isEqualToString:hubObj.SerialNo])
//    {
//             UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
//             [cell.imgCell setTintColor:[Utility colorWithHexString:hexString_SkyBlue]];
//             [cell.imgCell setImage:image];
//    }
//         else
//         {
//             [cell.imgCell setImage:nil];
//         }
    return cell;
    } @catch(NSException *exception) {
                [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
            }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     @try {
   // SectionSetting *objSection = [self.arrDeviceList objectAtIndex:indexPath.section];
         self.objSelectedMHubDevice  = (Hub * )[self.arrDeviceList objectAtIndex:indexPath.row];
         
         [self ClickOn_ConfirmButton];
         //[self.tblProfileList reloadData];
//         CellSetting *cell = [self.tblProfileList cellForRowAtIndexPath:indexPath];
//         UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
//         [cell.imgCell setTintColor:[AppDelegate appDelegate].themeColours.colorHeaderText];
//         [cell.imgCell setImage:image];
        // [self dismissViewControllerAnimated:YES completion:nil];
         } @catch(NSException *exception) {
                        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
                    }
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
