//
//  StartSearchVC.m
//  mHubApp
//
//  Created by Yashica Agrawal on 17/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "StartSearchVC.h"
#import "ConnectVC.h"
#import "CellHeaderImage.h"

@interface StartSearchVC ()<NSNetServiceDelegate, NSNetServiceBrowserDelegate, GCDAsyncSocketDelegate, SearchDataManagerDelegate> {
}
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgDeviceLogo;
@property (weak, nonatomic) IBOutlet UITableView *tblSearch;

@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (strong, nonatomic) NSMutableArray *arrSearchData;
//@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser;
//@property (strong, nonatomic) SSDPServiceBrowser *ssdpServiceBrowser;
@end

@implementation StartSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_MHUBFOUND_HEADER];

    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(popViewController)
                                   userInfo:nil
                                    repeats:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    [self.imgDeviceLogo setTintColor:[AppDelegate appDelegate].themeColours.colorNormalText];
    [self.lblHeaderMessage setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontLight10];
    } else {
        [self.lblHeaderMessage setFont:textFontLight13];
    }

    [[AppDelegate appDelegate] setShouldRotate:NO];
    
    [[SearchDataManager sharedInstance] startSearchNetwork];
    [SearchDataManager sharedInstance].delegate = self;
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
    return [self.arrSearchData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SearchData *objData = [self.arrSearchData objectAtIndex:section];
    NSArray *arrRow = objData.arrItems;
    return [arrRow count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SearchData *objData = [self.arrSearchData objectAtIndex:section];
    if ([objData.arrItems count] > 0) {
        return objData.sectionHeight;
    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderCellIdentifier = @"CellHeaderImage";
    SearchData *objData = [self.arrSearchData objectAtIndex:section];
    CellHeaderImage *cellHeader = [self.tblSearch dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    if (cellHeader == nil) {
        cellHeader = [self.tblSearch dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    }
    [cellHeader.imgCell setTintColor:[AppDelegate appDelegate].themeColours.themeType == Dark ? colorWhite : colorBlack];
    cellHeader.imgCell.image = objData.imgSection;
    return cellHeader;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
        }
        SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
        
        Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
        NSMutableString *title = [[NSMutableString alloc] initWithString:@"CONNECT TO"];
        if ([objData.arrItems count] > 1) {
            NSInteger intCount = indexPath.row+1;
            [title appendString:[NSString stringWithFormat:@" \"%@\" #%ld", objHub.Name, (long)intCount]];
        } else {
            [title appendString:[NSString stringWithFormat:@" \"%@\"", objHub.Name]];
        }
        
        if (![objHub.Address isIPAddressEmpty]) {
            [title appendString:[NSString stringWithFormat:@" (%@)", objHub.Address]];
        }
        cell.lblCell.text = [title uppercaseString];
        
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //mHubManagerInstance.objSelectedHub = nil;
    SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
    if (objData.modelType != HDA_MHUB4K431 && objData.modelType != HDA_MHUB4K862) {
        Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
        mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objHub];
        
        if ([objHub.Address isIPAddressEmpty]) {
            // Fetch Service
            NSNetService *service = objHub.UserInfo;
            // Resolve Service
            [service setDelegate:self];
            [service resolveWithTimeout:3.0];
        } else {
            BOOL isValid = [mHubManagerInstance.objSelectedHub.Address isValidIPAddress];
            if (isValid) {
                //DDLogDebug(@"mHubManagerInstance.objSelectedHub.Address == %@", mHubManagerInstance.objSelectedHub.Address);
                [self navigateToNextScreen];
            }
        }
    } else {
        Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
        mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objHub];
        [self navigateToNextScreen];
    }
}

- (void)navigateToNextScreen {
    @try {
        self.socket = nil;
        NSMutableString *strMessage = [[NSMutableString alloc] init];
        BOOL isValid = true;
        
        if ([mHubManagerInstance.objSelectedHub.Address isIPAddressEmpty]){
            isValid = false;
            [strMessage appendString:ALERT_MESSAGE_SELECT_DEVICE];
        }
        
        if (isValid) {
            ConnectVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ConnectVC"];
            [self.navigationController pushViewController:objVC animated:YES];
        } else {
            [[AppDelegate appDelegate] alertControllerShowMessage:strMessage];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}

-(void) reloadTableData {
    @try {
        for (SearchData *objData in self.arrSearchData) {
            if (objData.modelType != HDA_MHUB4K431 && objData.modelType != HDA_MHUB4K862) {
                for (Hub *objHub in objData.arrItems) {
                    if (![objHub.Address isIPAddressEmpty]) {
                        // [APIManager getmHubDetails_Address:objHub.Address completion:^(APIResponse *responseObject) {
                        [APIManager mHUBUserProfileXML_Hub:objHub completion:^(APIResponse *responseObject) {
                            if (!responseObject.error) {
                                Hub *objHubAPI = (Hub *)responseObject.response;
                                
                                if ([objHubAPI.Name isNotEmpty]) {
                                    objHub.Name = objHubAPI.Name;
                                }
                                
                                if ([objHubAPI.Mac isNotEmpty]) {
                                    objHub.Mac = objHubAPI.Mac;
                                }
                                
                                if ([objHubAPI.Address isIPAddressEmpty]) {
                                    objHub.Address = objHubAPI.Address;
                                }
                                
                                if (objHubAPI.Generation != 0) {
                                    objHub.Generation = objHubAPI.Generation;
                                }
                                
                                objHub.modelName = [objHub.modelName isNotEmpty] ? objHub.modelName : [Hub getHubName:objHub.Generation];
                                
                                if (objHubAPI.BootFlag == true) {
                                    objHub.BootFlag = objHubAPI.BootFlag;
                                }
                                
                                if ([objHubAPI.SerialNo isNotEmpty]) {
                                    objHub.SerialNo = objHubAPI.SerialNo;
                                }
                                
                                if ([objHubAPI.UserInfo isNotEmpty]) {
                                    objHub.UserInfo = objHubAPI.UserInfo;
                                }
                                
                                if (objHubAPI.apiVersion != 0) {
                                    objHub.apiVersion = objHubAPI.apiVersion;
                                }

                                if (objHubAPI.mosVersion != 0) {
                                    objHub.mosVersion = objHubAPI.mosVersion;
                                }

                                if ([objHubAPI.strMOSVersion isNotEmpty]) {
                                    objHub.strMOSVersion = objHubAPI.strMOSVersion;
                                }

                                if (objHubAPI.OutputCount != 0) {
                                    objHub.OutputCount = objHubAPI.OutputCount;
                                }
                                
                                if (objHubAPI.InputCount != 0) {
                                    objHub.InputCount = objHubAPI.InputCount;
                                }
                                
                                if (objHubAPI.AVR_IRPack == true) {
                                    objHub.AVR_IRPack = objHubAPI.AVR_IRPack;
                                }
                                
                                // if (objHubAPI.Audio_Paired == true) {
                                //     objHub.Audio_Paired = objHubAPI.Audio_Paired;
                                // }
                            }
                        }];
                    }
                }
            }
        }
        [self reloadTableViewData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) reloadTableViewData {
    [self.tblSearch reloadData];
    NSInteger intDeviceCount = 0;
    for (SearchData *objData in self.arrSearchData) {
        intDeviceCount+=objData.arrItems.count;
    }
    if (intDeviceCount > 0) {
        [self.lblHeaderMessage setText:[NSString stringWithFormat:HUB_MHUBFOUND_MESSAGE]];
    }
}

-(void)popViewController {
    NSInteger intDeviceCount = 0;
    for (SearchData *objData in self.arrSearchData) {
        intDeviceCount+=objData.arrItems.count;
    }
    if (intDeviceCount == 0) {
        [AppDelegate appDelegate].isDeviceNotFound = true;
        [self.navigationController popViewControllerAnimated:YES];
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
    [self reloadTableViewData];
}

#pragma mark - NetService Delegate

- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    [service setDelegate:nil];
}

- (void)netServiceDidResolveAddress:(NSNetService *)service {
    @try {
        // Connect With Service
        if ([self connectWithService:service]) {
            DDLogDebug(@"Did Connect with Service: domain=(%@) type=(%@) name=(%@) port=(%i) hostName=(%@)", [service domain], [service type], [service name], (int)[service port], [service hostName]);
            for (SearchData *objData in self.arrSearchData) {
                for (Hub *objHub in objData.arrItems) {
                    if ([objHub.modelName isEqualToString:service.name] && [service addresses].count > 0) {
                        NSData *address = [service.addresses firstObject];
                        struct sockaddr_in *socketAddress = (struct sockaddr_in *) [address bytes];
                        //DDLogDebug(@"Service name: %@ , ip: %s , port %li", [service name], inet_ntoa(socketAddress->sin_addr), (long)[service port]);
                        objHub.Address = [NSString stringWithFormat:@"%s", inet_ntoa(socketAddress->sin_addr)];
                    }
                }
            }
            [self reloadTableData];
        } else {
            DDLogError(@"Unable to Connect with Service: domain=(%@) type=(%@) name=(%@) port=(%i) hostName=(%@)", [service domain], [service type], [service name], (int)[service port], [service hostName]);
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (BOOL)connectWithService:(NSNetService *)service {
    BOOL _isConnected = NO;
        // Copy Service Addresses
    NSArray *addresses = [[service addresses] copy];
    if (!self.socket || ![self.socket isConnected]) {
            // Initialize Socket
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
            // Connect
        while (!_isConnected && [addresses count]) {
            NSData *address = [addresses objectAtIndex:0];
            
            NSError *error = nil;
            if ([self.socket connectToAddress:address error:&error]) {
                _isConnected = YES;
                
            } else if (error) {
                DDLogError(@"Unable to connect to address. Error %@ with user info %@.", error, [error userInfo]);
            }
        }
        
    } else {
        _isConnected = [self.socket isConnected];
    }
    
    return _isConnected;
}

- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(UInt16)port {
    DDLogInfo(@"Socket Did Connect to Host: %@ Port: %hu", host, port);
    // Start Reading
    [socket readDataToLength:sizeof(uint64_t) withTimeout:-1.0 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error {
    DDLogError(@"Socket Did Disconnect with Error %@ with User Info %@.", error, [error userInfo]);
    
    [socket setDelegate:nil];
    [self setSocket:nil];
}

@end
