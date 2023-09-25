//
//  WifiSubMenuVC.m
//  mHubApp
//
//  Created by Ashutosh Tiwari on 16/03/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import "WifiSubMenuVC.h"
#import "StartWifiSetupViewController.h"
#import "SearchNetworkVC.h"

@interface WifiSubMenuVC ()
@property (nonatomic, retain) NSMutableArray *arrData;

@end

@implementation WifiSubMenuVC

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
        self.view.backgroundColor = themeColor.colorBackground;
        [self.lblHeaderMessage setTextColor:themeColor.colorNormalText];
        
        //self.navigationItem.backBarButtonItem = customBackBarButton;
        self.navigationItem.hidesBackButton = true;
        // Do any additional setup after loading the view.
        //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:kImageIconNavBack] style:UIBarButtonItemStylePlain target:nil action:nil];

        [self.btn_footer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn_footer setTitle:HUB_ENTER_DEMO_MODE forState:UIControlStateNormal];
        [self.btn_footer addBorder_Color:UIColor.whiteColor BorderWidth:1.0];


        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_CONFIGURE_WIFI_SETUP];
        [self.lblHeaderMessage setText:Wifi_select_the_device];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lblHeaderMessage setFont:textFontBold12];
        } else {
            [self.lblHeaderMessage setFont:textFontBold16];
        }
       // self.arrData = [[NSMutableArray alloc] initWithObjects:HUB_CONFIGURE_WIFI_DEVICE, HUB_MANUALLY_CONNECT_FIND_DEVICES, nil];
        self.arrData = [[NSMutableArray alloc] initWithObjects:@"MHUB U (4X1+1) 40", @"uControl Zone Processor", nil];
        [self.btn_footer setHidden:YES];

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        
        [[AppDelegate appDelegate] setShouldRotate:NO];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
        CGFloat height = MIN(self.tblManuallySetup.bounds.size.height, self.tblManuallySetup.contentSize.height);
        self.heightTblManuallySetup.constant = height;
        // [self.view layoutIfNeeded];

      
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
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
        cell.lblCell.text = [[self.arrData objectAtIndex:indexPath.row] uppercaseString];

        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblCell setFont:textFontBold10];
        } else {
            [cell.lblCell setFont:textFontBold13];
        }
        //        if (indexPath.row == 2) {
        //            [cell.imgBackground addBorder_Color:colorClear BorderWidth:1.0];
        //            [cell.lblCell setFont:textFontBold12];
        //        }
        return cell;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        [AppDelegate appDelegate].isSearchNetworkPopVC = false;
        WiFiImportantVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WiFiImportantVC"];
        objVC.navigateFromType =  menu_Wifi;
        if(indexPath.row == 0)
            objVC.modelType =  mHub411;
        else
            objVC.modelType =  mHubZP;
        [self.navigationController pushViewController:objVC animated:YES];
        
        
//        switch (indexPath.row) {
//            case 0: {
//                StartWifiSetupViewController *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"StartWifiSetupViewController"];
//                [self.navigationController pushViewController:objVC animated:YES];
//                break;
//
//            }
//
//            case 1: {
//
//                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
//                    SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
//                    objVC.isManuallyConnectNavigation =  true;
//                    [AppDelegate appDelegate].systemType = HDA_SetupANewMHUBSystem;
//                    objVC.navigateFromType =  self.navigateFromType;
//                    [self.navigationController pushViewController:objVC animated:NO];
////                    WifiDevicesListVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WifiDevicesListVC"];
////                    objVC.arrSearchData = self.arrSearchData;
////                    [self.navigationController pushViewController:objVC animated:YES];
//                break;
//            }
//
//            default:
//                break;
//        }
    }
    @catch(NSException *exception) {
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
