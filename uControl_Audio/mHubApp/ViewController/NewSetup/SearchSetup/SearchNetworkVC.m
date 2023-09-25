//
//  SearchNetworkVC.m
//  mHubApp
//
//  Created by Anshul Jain on 12/03/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "SearchNetworkVC.h"
#import "SetupTypeVC.h"
#import "NewSetupVC.h"
#import "ConnectionOptionVC.h"
#import "UpdateHubViewController.h"
#import "UpdateAvailableViewController.h"
#import "HubDevicesListViewController.h"
#import "SetupMismatchViewController.h"
#import "UnableAutomaticConnectViewController.h"
#import "SelectDeviceVC.h"
#import "SelectStackSystemViewController.h"
#import "SetupConfirmationVC.h"
#import "ManuallySetupVC.h"

@interface SearchNetworkVC ()
{
    bool updateFlag;
}
@property (strong, nonatomic) NSMutableArray *arrSearchData;
@property (strong, nonatomic) NSMutableArray *arrBenchmarkData;
@property (strong, nonatomic) NSMutableArray *arrAllMhubData;
@property (strong, nonatomic) NSMutableArray *tempArr;
@property (strong, nonatomic) Hub *selectedHubForProfile;
@property (strong, nonatomic) NSString * isFromClass;

@end

@implementation SearchNetworkVC

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.tempArr = [[NSMutableArray alloc]init];
        self.navigationItem.backBarButtonItem = customBackBarButton;
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_SEARCHING_NETWORK_HEADER];
        self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
       // self.searchSpecificDevice = [[NSString alloc]init];
        
        [[AppDelegate appDelegate] setShouldRotate:NO];
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        //[[SearchDataManager sharedInstance]resetSharedInstance];
        //August2020: Here we are adding condition for V3 older units, because v3 units will only appear in FInd devices or WIll be able to connect manually. so except this 2 cases there is no need to search for V3 units. so based on userdefault value here. searchData class will decide to do search for v3 units or not. This key value will not allow app for SSDP search.
        if(self.navigateFromType == menu_findDevices )
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IsComingFromFindDevices"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"IsComingFromFindDevices"];
        }
        [[SearchDataManager sharedInstance] startSearchNetwork];
        [SearchDataManager sharedInstance].delegate = self;
        [NSTimer scheduledTimerWithTimeInterval:5.0
                                         target:self
                                       selector:@selector(popViewController)
                                       userInfo:nil
                                        repeats:NO];
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        BOOL flag_isManaulSetupPAge =  false;
        
        if ([AppDelegate appDelegate].isSearchNetworkPopVC == true) {
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[ManuallySetupVC class]]) {
                                flag_isManaulSetupPAge =  true;
                            }
                        }
            if(flag_isManaulSetupPAge)
            {
                
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ManuallySetupVC class]]) {
                        [self.navigationController popToViewController:vc animated:false];
                    }
                }
            }
            else
            {

                if (_isOpenFromSettingsScreen)
                {
                    [self.navigationController popViewControllerAnimated:false];
                }else
                {
                    [self.navigationController popToRootViewControllerAnimated:false];
                }
                
            }
        }
        
        [self getBenchMarkFile];
    } @catch (NSException *exception) {
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

-(void)getBenchMarkFile {
    {
        
        [APIManager getBenchMarkDetails:nil updateData:nil completion:^(NSDictionary *responseObject) {
            if(responseObject != nil){
            self.arrBenchmarkData  =  (NSMutableArray *)responseObject;
            ////NSLog(@"SearchNetworkVC Benchmark array %@",self.arrBenchmarkData);
            }
            else
                {
                //NSLog(@"SearchNetworkVC error %@",responseObject);
                }

        }];
    }
}

#pragma mark - SearchData Delegate
-(void) searchData:(SearchData *)searchData didFindDataArray:(NSMutableArray *)arrSearchedData {
    if (self.arrSearchData) {
        [self.arrSearchData removeAllObjects];
    } else {
        self.arrSearchData = [[NSMutableArray alloc] init];
    }
    
    [self.arrSearchData addObjectsFromArray:arrSearchedData];
    for (SearchData *objData in self.arrSearchData) {
           for (Hub *objHub in objData.arrItems) {
         NSLog(@"HubAudio objHub %@ NAD22 %@ serial no%@",objHub.modelName, objHub.Address,objHub.SerialNo);
           }
     }
    [self reloadTableViewData];
}

-(void) reloadTableViewData {
    @try {
        //NSLog(@"views c 33%@",self.navigationController.viewControllers);
        NSInteger intTotalDeviceCount = 0;
        NSInteger intVideoDeviceCount = 0;
        NSInteger intAudioDeviceCount = 0;
        bool deviceFound = false;
        for (SearchData *objData in self.arrSearchData) {
            intTotalDeviceCount+=objData.arrItems.count;
            if (objData.modelType == HDA_MHUBAUDIO64) {
                intAudioDeviceCount += objData.arrItems.count;
            }
            else {
                intVideoDeviceCount += objData.arrItems.count;
            }
            for (Hub *objHub in objData.arrItems) {
                //NSLog(@"mHub model %@ AND %@",objHub.modelName,self.searchSpecificDevice);
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_code == %@", objHub.modelName];
                NSArray *arrCmdDataFiltered = [self.arrBenchmarkData filteredArrayUsingPredicate:predicate];
                if(arrCmdDataFiltered.count > 0)
                {
                    objHub.MHub_BenchMarkVersion = [[[arrCmdDataFiltered objectAtIndex:0]objectForKey:@"mos_version_benchmark" ]floatValue ];
                }
                if([objHub.modelName isEqualToString:self.searchSpecificDevice])
                {
                    deviceFound = true;
                    self.selectedHubForProfile = [[Hub alloc]initWithHub:objHub];
                }
            }
        }

        if(_isManuallyConnectNavigation)
        {
            if (intTotalDeviceCount > 0) {
                HDASetupType setupType = HDA_SetupVideoAudio;
                if (intAudioDeviceCount > 0 && intVideoDeviceCount == 0) {
                    // DDLogDebug(@"Audio Only");
                    setupType = HDA_SetupAudio;
                } else if (intAudioDeviceCount == 0 && intVideoDeviceCount > 0) {
                    // DDLogDebug(@"Video Only");
                    setupType = HDA_SetupVideo;
                    if(intVideoDeviceCount > 1)
                    {
                        setupType = HDA_SetupVideoAudio;
                    }
                } else {
                    // DDLogDebug(@"Audio Video Both");
                    setupType = HDA_SetupVideoAudio;
                }
                [self performSelector:@selector(pushToSelectSystemFromManuallyConnect:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:setupType], @"DeviceType", nil] afterDelay:1.0];
            } else {
                [self popViewController];
            }
        }
        else
        {
            [self performSelector:@selector(checkValidations) withObject:nil afterDelay:5.0];
            return;
            if (intTotalDeviceCount > 0) {
                HDASetupType setupType = HDA_SetupVideoAudio;
                if (intAudioDeviceCount > 0 && intVideoDeviceCount == 0) {
                    setupType = HDA_SetupAudio;
                } else if (intAudioDeviceCount == 0 && intVideoDeviceCount > 0) {
                    setupType = HDA_SetupVideo;
                    if(intVideoDeviceCount > 1)
                    {
                        setupType = HDA_SetupVideoAudio;
                    }
                } else {
                    setupType = HDA_SetupVideoAudio;
                }
                [self performSelector:@selector(pushToNextViewController:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:setupType], @"DeviceType", nil] afterDelay:1.0];
            } else {
                [self popViewController];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)checkValidations
{
    @try {
        NSInteger intTotalDeviceCount = 0;
        NSInteger intVideoDeviceCount = 0;
        NSInteger intAudioDeviceCount = 0;
        self.arrAllMhubData = [[NSMutableArray alloc]init];
        int numberOfBootFlags = 0;
        int numberOfPairs = 0;
        int numberOfMaster = 0;
        int numberOfHubsLessThenRequiredVersion = 0;
        for (SearchData *objData in self.arrSearchData) {
            intTotalDeviceCount+=objData.arrItems.count;
            if (objData.modelType == HDA_MHUBAUDIO64) {
                intAudioDeviceCount += objData.arrItems.count;
            } else {
                intVideoDeviceCount += objData.arrItems.count;
            }
            for (Hub *objHub in objData.arrItems) {
                ////NSLog(@"mHubAudio objHub 66%@",objHub.Address);
//                if(objHub.mosVersion < 8.0 )
//                {
//                    numberOfHubsLessThenRequiredVersion ++;
//                }
                //All Mhub found in a array
                [self.arrAllMhubData addObject:objHub];
                // Boot Flags
                if(objHub.BootFlag == true )
                {
                    // bootFlagForAll = true;
                    numberOfBootFlags ++;
                }
                // Pair Json
                if(objHub.isPaired == true )
                {
                    numberOfPairs ++;
                    ////NSLog(@"self.arrAllMhubData %@ and data %d",objHub.modelName, objHub.isPaired);
                }
                // Master Json
                if(objHub.PairingDetails.master.ip_address != nil  && ![objHub.PairingDetails.master.ip_address isEqualToString:UNKNOWN_IP] )
                {
                    numberOfMaster ++;
                }
            }
        }
        if(self.navigateFromType == menu_profileConnect)
        {
          //  if(deviceFound){
            [self performSelector:@selector(pushToSetupDeviceFoundForProfile:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:self.selectedHubForProfile, @"SingleUnitHub", nil] afterDelay:1.0];
            return;
        }
        // If Single unit found.
        if(intTotalDeviceCount == 1)
        {
            if(numberOfHubsLessThenRequiredVersion > 0)
            {
                Hub *objHub = (Hub *)[self.arrAllMhubData objectAtIndex:0];
            if ([objHub.modelName isContainString:kDEVICEMODEL_MHUB4K431] || [objHub.modelName isContainString:kDEVICEMODEL_MHUB4K862]) {
                //August2020: No need to be show V3 or older units in auto connect process or auto search, so we are showing No Device found message by below code otherwise uncomment the code below to see V3 units in auto connect search. 
                [self popViewController];
               // [self performSelector:@selector(pushToSetupConfirmationVC:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:objHub, @"SingleUnitHub", nil] afterDelay:1.0];
            }
            else
                {
                [self performSelector:@selector(pushToNextViewControllerForUpdate:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"multipleDevices", nil] afterDelay:1.0];
                }
            }
            else
            {
                if(self.arrAllMhubData.count > 0)
                {
                    Hub *objHub = (Hub *)[self.arrAllMhubData objectAtIndex:0];
                    // No need to update the device from benchmark check so removed it.
//                    if (objHub.mosVersion < objHub.MHub_BenchMarkVersion) {
//                        [self performSelector:@selector(pushToNextViewControllerForUpdate:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"multipleDevices", nil] afterDelay:1.0];
//                    }
//                    else
//                    {
                        [self performSelector:@selector(pushToSetupConfirmationVC:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:objHub, @"SingleUnitHub", nil] afterDelay:1.0];
                        
//                    }
                }
            }
            
        }
        //Multiple units found
        else{
            if(numberOfHubsLessThenRequiredVersion > 0)
            {
                ////NSLog(@"Software Mismatch");
                [self performSelector:@selector(pushToSetupMismatchController:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:true], @"DeviceType", nil] afterDelay:1.0];
                return;
            }
            if (numberOfBootFlags == [self.arrAllMhubData count]) {
                // all boot flags are true
                ////NSLog(@"Pair JSON");
                if (numberOfPairs > 0 ) {
                    if (numberOfPairs == 1)
                    {
                        //NSLog(@"single pair JSON, Connect directly");
                    }
                    else if(numberOfPairs != numberOfBootFlags)
                    {
                        HDASetupType setupType = HDA_SetupVideoAudio;
                        if (intAudioDeviceCount > 0 && intVideoDeviceCount == 0) {
                            // DDLogDebug(@"Audio Only");
                            setupType = HDA_SetupAudio;
                        } else if (intAudioDeviceCount == 0 && intVideoDeviceCount > 0) {
                            // DDLogDebug(@"Video Only");
                            setupType = HDA_SetupVideo;
                            if(intVideoDeviceCount > 1)
                            {
                                setupType = HDA_SetupVideoAudio;
                            }
                        } else {
                            // DDLogDebug(@"Audio Video Both");
                            setupType = HDA_SetupVideoAudio;
                        }
                        [self performSelector:@selector(pushToNextViewController:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:setupType], @"DeviceType", nil] afterDelay:1.0];
                    }
                    else
                    {
                       // //NSLog(@"Multiple pair JSon, select stack system");
                        [self performSelector:@selector(pushToSelectStackOrPrimaryController:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], @"DeviceType", nil] afterDelay:1.0];
                    }
                }
                else
                {
                    ////NSLog(@"No pair Json, check for master");
                    if (numberOfMaster > 0 )
                    {
                        [self performSelector:@selector(pushToUnableToConnectController:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], @"DeviceType", nil] afterDelay:1.0];
                    }
                    else
                    {
                        self.navigateFromType = menu_autoConnect_gotoSetupConfirmation ;
                        [self performSelector:@selector(pushToSelectSystemFromManuallyConnect:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:HDA_SetupVideo], @"DeviceType", nil] afterDelay:1.0];

                    }
                    
                }
                
            } else if (numberOfBootFlags == 0) {
                // all false
                ////NSLog(@"All false, MULTIPLE MHUB DEVICES DISCOVERED");
                HDASetupType setupType = HDA_SetupVideoAudio;
                if (intAudioDeviceCount > 0 && intVideoDeviceCount == 0) {
                    // DDLogDebug(@"Audio Only");
                    setupType = HDA_SetupAudio;
                } else if (intAudioDeviceCount == 0 && intVideoDeviceCount > 0) {
                    // DDLogDebug(@"Video Only");
                    setupType = HDA_SetupVideo;
                    if(intVideoDeviceCount > 1)
                    {
                        setupType = HDA_SetupVideoAudio;
                    }
                } else {
                    // DDLogDebug(@"Audio Video Both");
                    setupType = HDA_SetupVideoAudio;
                }
                [self performSelector:@selector(pushToNextViewController:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:setupType], @"DeviceType", nil] afterDelay:1.0];
            } else {
                // different
              //  //NSLog(@"Setup Mismatch");
               // //NSLog(@"numberOfBootFlags %d  and [self.arrAllMhubData count] %ld",numberOfBootFlags,[self.arrAllMhubData count]);
                [self performSelector:@selector(pushToSetupMismatchController:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false], @"DeviceType", nil] afterDelay:1.0];
            }
        }
    }
    @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)popViewController {
    @try {
        NSInteger intDeviceCount = 0;
        for (SearchData *objData in self.arrSearchData) {
            intDeviceCount+=objData.arrItems.count;
        }
        if (intDeviceCount == 0) {
            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@"NO DEVICE FOUND"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)pushToSetupConfirmationVC:(id)setupType
{
    @try {
        NSArray *vcStack = self.navigationController.viewControllers;
        BOOL isVCAvailable = false;
        for (UIViewController *vc in vcStack) {
            if ([vc isKindOfClass:[SetupConfirmationVC class]] ) {
                isVCAvailable = true;
            }
        }
        if (isVCAvailable == false) {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            
            Hub *setupTp = (Hub *)[setupType valueForKey:@"SingleUnitHub"] ;
            
            SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
            objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:setupTp];
            objVC.isSelectedPaired = false;
            objVC.arrSelectedSlaveDevice = [[NSMutableArray alloc] init];
            [self.navigationController pushViewController:objVC animated:NO];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)pushToSetupDeviceFoundForProfile:(id)setupType
{
    @try {
        NSArray *vcStack = self.navigationController.viewControllers;
        NSLog(@"stack in search VC %@",vcStack);
        BOOL isVCAvailable = false;
        for (UIViewController *vc in vcStack) {
            if ([vc isKindOfClass:[DeviceFoundVC class]] ) {
                isVCAvailable = true;
            }
        }
        if (isVCAvailable == false) {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            Hub *setupTp = (Hub *)[setupType valueForKey:@"SingleUnitHub"] ;
            DeviceFoundVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DeviceFoundVC"];
            objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:setupTp];
            objVC.arrMhubDevicesFound = [[NSMutableArray alloc]initWithArray:self.arrAllMhubData];
            [self.navigationController pushViewController:objVC animated:NO];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)pushToSelectStackOrPrimaryController:(id)setupType
{
    @try {
        NSArray *vcStack = self.navigationController.viewControllers;
        BOOL isVCAvailable = false;
        for (UIViewController *vc in vcStack) {
            if ([vc isKindOfClass:[SelectStackSystemViewController class]] ) {
                isVCAvailable = true;
            }
        }
        if (isVCAvailable == false) {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            SelectStackSystemViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectStackSystemViewController"];
            objVC.setupType = HDA_SetupVideoAudio;
            objVC.setupLevel = HDA_SetupLevelPrimary;
            objVC.arrSearchData = self.arrSearchData;
            objVC.arrSearchDataTemp = self.arrAllMhubData;
            [self.navigationController pushViewController:objVC animated:NO];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)pushToSetupMismatchController:(id)setupType
{
    @try {
        NSArray *vcStack = self.navigationController.viewControllers;
        BOOL isVCAvailable = false;
        for (UIViewController *vc in vcStack) {
            if ([vc isKindOfClass:[SetupMismatchViewController class]] ) {
                isVCAvailable = true;
            }
        }
        if (isVCAvailable == false) {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            //BOOL isFlag = [setupType boolValue];
            BOOL isFlag  = (BOOL)[[setupType valueForKey:@"DeviceType"] boolValue];
            SetupMismatchViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupMismatchViewController"];
            objVC.arrSearchData = self.arrSearchData;
            objVC.isSoftware_mismatch = isFlag ;
            [self.navigationController pushViewController:objVC animated:NO];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)pushToUnableToConnectController:(id)setupType
{
    
    @try {
        NSArray *vcStack = self.navigationController.viewControllers;
        BOOL isVCAvailable = false;
        for (UIViewController *vc in vcStack) {
            if ([vc isKindOfClass:[UnableAutomaticConnectViewController class]] ) {
                isVCAvailable = true;
            }
        }
        //DDLogDebug(@"isVCAvailable == %@", isVCAvailable ? @"true" : @"false");
        if (isVCAvailable == false) {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            
            UnableAutomaticConnectViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UnableAutomaticConnectViewController"];
            objVC.arrSearchData = self.arrSearchData;
            [self.navigationController pushViewController:objVC animated:NO];
            
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
    
    
}

-(void)pushToNextViewController:(id)setupType {
    @try {
        NSArray *vcStack = self.navigationController.viewControllers;
        BOOL isVCAvailable = false;
        for (UIViewController *vc in vcStack) {
            if ([vc isKindOfClass:[SetupTypeVC class]] || [vc isKindOfClass:[ConnectionOptionVC class]]) {
                isVCAvailable = true;
            }
        }
        //DDLogDebug(@"isVCAvailable == %@", isVCAvailable ? @"true" : @"false");
        if (isVCAvailable == false) {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            HDASetupType setupTp = (HDASetupType)[[setupType valueForKey:@"DeviceType"] integerValue];
            if (setupTp == HDA_SetupVideoAudio) {
                SetupTypeVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupTypeVC"];
                objVC.setupType = setupTp;
                objVC.arrSearchData = self.arrSearchData;
                [self.navigationController pushViewController:objVC animated:NO];
            } else {
                [self pushToConnectionOptionVC:setupTp Animated:true];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void)pushToNextViewControllerForUpdate:(id)multipleDeviceFound {
    @try {
        NSArray *vcStack = self.navigationController.viewControllers;
        BOOL isVCAvailable = false;
        for (UIViewController *vc in vcStack) {
            if ([vc isKindOfClass:[UpdateHubViewController class]] || [vc isKindOfClass:[UpdateAvailableViewController class]]) {
                isVCAvailable = true;
            }
        }
        //DDLogDebug(@"isVCAvailable == %@", isVCAvailable ? @"true" : @"false");
        if (isVCAvailable == false) {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            BOOL flag = (HDASetupType)[[multipleDeviceFound valueForKey:@"multipleDevices"] boolValue];
            if(flag)
            {
                UpdateAvailableViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateAvailableViewController"];
                objVC.arrSearchData = self.arrAllMhubData;
                [self.navigationController pushViewController:objVC animated:NO];
            }
            else
            {
                UpdateHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateHubViewController"];
                objVC.arrSearchData = self.arrAllMhubData;
                [self.navigationController pushViewController:objVC animated:NO];
            }
            
            
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)pushToSelectSystemFromManuallyConnect:(id)setupType {
    @try {
        NSArray *vcStack = self.navigationController.viewControllers;
        BOOL isVCAvailable = false;
        if(self.navigateFromType == menu_Wifi || self.navigateFromType == menu_wifi_device_connected){
            for (UIViewController *vc in vcStack) {
                if ([vc isKindOfClass:[WifiDevicesListVC class]] || [vc isKindOfClass:[WiFiDeviceConnecteVC class]] ) {
                    isVCAvailable = true;
                }
            }
        }
        else{
        for (UIViewController *vc in vcStack) {
            if ([vc isKindOfClass:[HubDevicesListViewController class]] || [vc isKindOfClass:[SetupTypeVC class]] ) {
                isVCAvailable = true;
            }
        }
        }
        //DDLogDebug(@"isVCAvailable == %@", isVCAvailable ? @"true" : @"false");
        if (isVCAvailable == false) {
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            if(!(self.navigateFromType == menu_setMhub)){
                if(self.navigateFromType == menu_Wifi){
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    WifiDevicesListVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WifiDevicesListVC"];
                    objVC.arrSearchData = self.arrSearchData;
                    //objVC.navigateFromType =  self.navigateFromType;
                    [self.navigationController pushViewController:objVC animated:NO];
                }
                else if(self.navigateFromType == menu_wifi_device_connected){
                    [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                    WiFiDeviceConnecteVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WiFiDeviceConnecteVC"];
                    [self.navigationController pushViewController:objVC animated:NO];
                }
                else{
                [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                HubDevicesListViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"HubDevicesListViewController"];
                //objVC.setupType = setupTp;
                objVC.arrSearchData = self.arrSearchData;
                objVC.navigateFromType =  self.navigateFromType;
                [self.navigationController pushViewController:objVC animated:NO];
                }
            }
            else
            {
                
                HDASetupType setupTp = (HDASetupType)[[setupType valueForKey:@"DeviceType"] integerValue];
                if (setupTp == HDA_SetupVideoAudio) {
                    SetupTypeVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupTypeVC"];
                    objVC.setupType = setupTp;
                    objVC.arrSearchData = self.arrSearchData;
                    [self.navigationController pushViewController:objVC animated:NO];
                } else {
                    [self pushToConnectionOptionVC:setupTp Animated:true];
                }
            }
            
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


-(void)pushToConnectionOptionVC:(HDASetupType)setupType Animated:(BOOL) isAnimated {
    @try {
        NSMutableArray *arrFilterData = [[NSMutableArray alloc] init];
        switch (setupType) {
            case HDA_SetupVideo: {
                for (SearchData *objData in self.arrSearchData) {
                    DDLogDebug(@"<%s>: %@ == %ld", __FUNCTION__, objData.strTitle, (long)objData.arrItems.count);
                    if (objData.modelType != HDA_MHUBAUDIO64) {
                        [arrFilterData addObject:objData];
                    }
                }
                break;
            }
            case HDA_SetupAudio: {
                for (SearchData *objData in self.arrSearchData) {
                    DDLogDebug(@"<%s>: %@ == %ld", __FUNCTION__, objData.strTitle, (long)objData.arrItems.count);
                    if (objData.modelType == HDA_MHUBAUDIO64) {
                        [arrFilterData addObject:objData];
                    }
                }
                break;
            }
            case HDA_SetupVideoAudio: {
                for (SearchData *objData in self.arrSearchData) {
                    DDLogDebug(@"<%s>: %@ == %ld", __FUNCTION__, objData.strTitle, (long)objData.arrItems.count);
                    if (objData.modelType != HDA_MHUB4K431 && objData.modelType != HDA_MHUB4K862) {
                        [arrFilterData addObject:objData];
                    }
                }
                break;
            }
            default:
                break;
        }
//        ConnectionOptionVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ConnectionOptionVC"];
//        objVC.setupType = setupType;
//        objVC.arrSearchData = arrFilterData;
//        [self.navigationController pushViewController:objVC animated:isAnimated];
        SetupTypeVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupTypeVC"];
        objVC.setupType = setupType;
        objVC.arrSearchData = self.arrSearchData;
        [self.navigationController pushViewController:objVC animated:NO];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
}
@end
