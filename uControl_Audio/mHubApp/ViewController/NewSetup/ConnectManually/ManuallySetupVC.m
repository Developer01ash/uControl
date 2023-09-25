//
//  ManuallySetupVC.m
//  mHubApp
//
//  Created by Anshul Jain on 27/03/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "ManuallySetupVC.h"
#import "SetupConfirmationVC.h"
#import "ManuallySelectModelVC.h"
#import "WarningMessageVC.h"
#import "SearchNetworkVC.h"
#import "BenchmarkDetailsViewController.h"
#import "TermsNConditionViewController.h"
#import "StartWifiSetupViewController.h"
#import "ManuallyEnterIPAddressVC.h"
#import "EnterIPAddressManuallyUpdateFlowVC.h"

@interface ManuallySetupVC ()
{
    NSInteger resetTab_Count;
}
@property (nonatomic, retain) NSMutableArray *arrData;
@end

@implementation ManuallySetupVC

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        resetTab_Count = 0;
        ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
        self.view.backgroundColor = themeColor.colorBackground;
        [self.lblHeaderMessage setTextColor:themeColor.colorNormalText];
        
        //self.navigationItem.backBarButtonItem = customBackBarButton;
        self.navigationItem.hidesBackButton = true;
        [self.btn_footer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn_footer setTitle:HUB_ENTER_DEMO_MODE forState:UIControlStateNormal];
       // [self.btn_footer addBorder_Color:UIColor.whiteColor BorderWidth:1.0];
        
        [self.btn_ConnectManually setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn_ConnectManually setTitle:[HUB_ADDMANUALLY_HEADER uppercaseString] forState:UIControlStateNormal];
        [self.btn_ConnectManually setHidden:true];
        
        
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            self.constraint_heightFooterBtn_EnterDemo.constant = heightTableViewRow_SmallMobile;
            self.btn_footer.titleLabel.font = textFontBold10 ;
            self.btn_ConnectManually.titleLabel.font = textFontRegular10 ;
        } else {
            self.constraint_heightFooterBtn_EnterDemo.constant = heightTableViewRow;
            self.btn_footer.titleLabel.font = textFontBold13 ;
            self.btn_ConnectManually.titleLabel.font = textFontRegular13 ;
        }
        
        if(_isOpeningFromInsideTheMainUI)
        {
            self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_CONNECT_ADVANCE_OPTIONS];
            [self.lblHeaderMessage setText:HUB_CONNECT_MANUALLY_PAGE_DESCRIPTION];
            self.arrData = [[NSMutableArray alloc] initWithObjects:HUB_MANUALLY_CONNECT_FIND_DEVICES, HUB_CONNECT_REQUEST_SOFTWARE_BENCHMARK,HUB_FORCE_MHUB_UPDATE, nil];
            [self.btn_ConnectManually setHidden:YES];
            [self.btn_footer setHidden:YES];
        }
        else{
            
            self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:ADVANCED];
            // [self.lblHeaderMessage setText:HUB_CONNECT_MANUALLY_PAGE_DESCRIPTION];
            // self.arrData = [[NSMutableArray alloc] initWithObjects:HUB_SETUP_A_NEW_MHUB_SYSTEM, HUB_CONNECT_TO_AN_EXISTING_MHUB_SYSTEM, HUB_ENTER_DEMO_MODE, nil];
            self.arrData = [[NSMutableArray alloc] initWithObjects:HUB_CONFIGURE_WIFI_SETUP,HUB_MANUALLY_CONNECT_FIND_DEVICES, HUB_CONNECT_REQUEST_SOFTWARE_BENCHMARK,HUB_FORCE_MHUB_UPDATE,HUB_CONNECT_NEW_SYSTEM,HUB_CONNECT_RESET_MHUB, nil];
            [self.btn_ConnectManually setHidden:YES];
            [self.btn_footer setHidden:NO];
        }
        //self.arrData = [[NSMutableArray alloc] initWithObjects:HUB_CONNECT_TO_AN_EXISTING_MHUB_SYSTEM, HUB_ENTER_DEMO_MODE, nil];
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lblHeaderMessage setFont:textFontRegular12];
        } else {
            [self.lblHeaderMessage setFont:textFontRegular18];
        }
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
        
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lblHeaderMessage setFont:textFontRegular12];
        } else {
            [self.lblHeaderMessage setFont:textFontRegular18];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ClickOn_FooterView:(id)sender{
    [self navigateForDemoSetup];
}

-(IBAction)ClickOn_ManualConnect:(id)sender{
    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
    [self navigateToManuallySetUp];
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
        } else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
            [cell.lblCell setFont:textFontBold12];
        } else {
            [cell.lblCell setFont:textFontBold14];
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
        switch (indexPath.row) {
            case 0: // WiFi Setup, (But if opening from app settings then its Find devices.)
            {
                if(!_isOpeningFromInsideTheMainUI)
                {
                    WifiSubMenuVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WifiSubMenuVC"];
                    objVC.navigateFromType =  menu_Wifi;
                    [self.navigationController pushViewController:objVC animated:YES];
                }
                else{
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
                    objVC.isManuallyConnectNavigation =  true;
                    [AppDelegate appDelegate].systemType = HDA_SetupANewMHUBSystem;
                    objVC.navigateFromType =  menu_findDevices;
                    [self.navigationController pushViewController:objVC animated:NO];
                }
                break;
                
            }
                
            case 1: // FIND DEVICES (But if opening from app settings then its BenchMark.)
            {
                //                [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                //                [self navigateToManuallySetUp];
                if(!_isOpeningFromInsideTheMainUI)
                {
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
                    objVC.isManuallyConnectNavigation =  true;
                    [AppDelegate appDelegate].systemType = HDA_SetupANewMHUBSystem;
                    objVC.navigateFromType =  menu_findDevices;
                    [self.navigationController pushViewController:objVC animated:NO];
                }
                else
                {
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    BenchmarkDetailsViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"BenchmarkDetailsViewController"];
                    [self.navigationController pushViewController:objVC animated:YES];
                }
                
                break;
            }
            case 2: // BENCHMARK (But if opening from app settings then its Update.)
            {
                if(!_isOpeningFromInsideTheMainUI)
                {
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    BenchmarkDetailsViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"BenchmarkDetailsViewController"];
                    [self.navigationController pushViewController:objVC animated:YES];
                }else{
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
                    objVC.isManuallyConnectNavigation =  true;
                    objVC.navigateFromType =  menu_update;
                    [self.navigationController pushViewController:objVC animated:YES];
                }
                break;
            }
            case 3: // MHUB UPDATE
            {
                [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                EnterIPAddressManuallyUpdateFlowVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"EnterIPAddressManuallyUpdateFlowVC"];
//                objVC.hubModel = (HubModel)(indexPath.row+1);
//                objVC.setupType = HDA_ManualIP_WithoutType;
//                objVC.setupLevel = HDA_SetupLevelPrimary;
                objVC.navigateFromType =  menu_update;
                [AppDelegate appDelegate].systemType = HDA_ConnectManually;
                [self.navigationController pushViewController:objVC animated:YES];
//                SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
//                objVC.isManuallyConnectNavigation =  true;
                
//                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case 4: // Set MHUB
            {
                if(!_isOpeningFromInsideTheMainUI)
                {
                    
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    //[self navigateToWarningScreen:HDA_ManuallyConnect];
                    
                    SetupOptionVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupOptionVC"];
                    //objVC.isManuallyConnectNavigation =  true;
                    objVC.navigateFromType =  menu_setMhub;
                    [AppDelegate appDelegate].systemType = HDA_ConnectToAnExistingMHUBSystem;
                    [self.navigationController pushViewController:objVC animated:YES];
                    break;
                }
                else{
                    [self loadTextLogFileOnWebView];
                    
                }
                break;
            }
            case 5: // Reset
            {
                if(!_isOpeningFromInsideTheMainUI)
                {
                    resetTab_Count = resetTab_Count+1;
                    if(resetTab_Count >= [AppDelegate appDelegate].tapTimes)
                    {
                        [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                        //[self navigateToWarningScreen:HDA_ManuallyConnect];
                        
                        SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
                        objVC.isManuallyConnectNavigation =  true;
                        objVC.navigateFromType =  menu_reset;
                        //[AppDelegate appDelegate].systemType = HDA_SetupANewMHUBSystem;
                        [self.navigationController pushViewController:objVC animated:YES];
                    }
                    
                }
                else{
                    [self shareLogFile:UIView.new];
                }
                break;
                
            }
            default:
                break;
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)loadTextLogFileOnWebView
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (0 < [paths count]) {
        NSString *documentsDirPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirPath stringByAppendingPathComponent:@"textLog.txt"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
            WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
            [webView loadData:data MIMEType:@"application/txt" characterEncodingName:@"UTF-8" baseURL:[NSURL new]];
            webView.navigationDelegate = self;
            webView.UIDelegate = self;
            // NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
            //[webView loadRequest:nsrequest];
            [webView setBackgroundColor:[UIColor lightGrayColor]];
            //            [webView loadRequest:nsrequest];
            [self.view addSubview:webView];
        }
    }
}

- (void)shareLogFile:(id)sender{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (0 < [paths count]) {
        NSString *documentsDirPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirPath stringByAppendingPathComponent:@"textLog.txt"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            //NSData *textData = [[NSFileManager defaultManager] contentsAtPath:filePath];
            NSURL *urlObj = [[NSURL alloc]initFileURLWithPath:filePath];
            NSArray *activityItems = [NSArray arrayWithObjects: urlObj, nil];
            
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityController.modalPresentationStyle = UIModalPresentationPopover;
            activityController.popoverPresentationController.sourceView = sender;
            [self presentViewController:activityController animated:YES completion:nil];
            
            
            //            //if iPhone
            //            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            //                [self presentViewController:activityController animated:YES completion:nil];
            //            }
            //            //if iPad
            //            else {
            //                // Change Rect to position Popover
            //                UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
            //                [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            //            }
        }
    }
    
}


-(void) navigateToWarningScreen:(HDAWarningType)warningType {
    @try {
        WarningMessageVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"WarningMessageVC"];
        [objVC getNavigationValue:warningType SearchData:nil WarningHub:nil Paired:false SlaveArray:nil];
        [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) navigateToManuallySetUp {
    @try {
        ManuallySelectModelVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ManuallySelectModelVC"];
        objVC.setupLevel = HDA_SetupLevelPrimary;
        [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) navigateForDemoSetup {
    @try {
        [mHubManagerInstance deletemHubManagerObjectData];
        if (![mHubManagerInstance.objSelectedHub isNotEmpty]) {
            mHubManagerInstance.objSelectedHub = [[Hub alloc] init];
        }
        Hub *objHubDemo = [[Hub alloc] init];
        objHubDemo.Generation = mHubPro;
        objHubDemo.modelName = [Hub getModelName:objHubDemo];
        objHubDemo.Address = STATICTESTIP_PRO;
        objHubDemo.BootFlag = true;
        
        SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
        objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:objHubDemo];
        objVC.isSelectedPaired = false;
        objVC.arrSelectedSlaveDevice = [[NSMutableArray alloc] init];
        [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
