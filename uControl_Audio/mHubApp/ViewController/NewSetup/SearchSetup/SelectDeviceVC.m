//
//  SelectDeviceVC.m
//  mHubApp
//
//  Created by Anshul Jain on 15/03/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "SelectDeviceVC.h"
#import "CellHeaderImage.h"
#import "CellSetupDevice.h"
#import "SetupConfirmationVC.h"
#import "WarningMessageVC.h"
#import "UpdateHubViewController.h"
@interface SelectDeviceVC () {
    // Indexing settings 1234
    NSMutableArray *arraySelectedDevices;
    //*********
}
    
@end

@implementation SelectDeviceVC

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.navigationItem.backBarButtonItem = customBackBarButton;
        self.navigationItem.hidesBackButton = true;
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lbl_deviceFound setFont:textFontBold12];
        } else {
            [self.lbl_deviceFound setFont:textFontBold16];
        }
        isDeviceSelected = false;
        switch (self.setupType) {
            case HDA_SetupVideo: {
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel: HUB_SELECT_SYSTEM_HEADER];
                break;
            }
            case HDA_SetupAudio: {
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel: HUB_SELECT_SYSTEM_HEADER];
                break;
            }
            case HDA_SetupVideoAudio: {
                self.arrPrimarySearchData = [[NSMutableArray alloc] init];
                self.arrSecondarySearchData = [[NSMutableArray alloc] init];
                for (SearchData *objData in self.arrSearchData) {
                    DDLogDebug(@"<%s>: %ld %@ == %ld", __FUNCTION__, (long)objData.modelType,objData.strTitle, (long)objData.arrItems.count);
                    if (objData.modelType == HDA_MHUBAUDIO64 || objData.modelType == HDA_MHUBS) {
                        [self.arrSecondarySearchData addObject:objData];
                    }
                    else {
                        [self.arrPrimarySearchData addObject:objData];
                    }
                  //  [self.arrPrimarySearchData addObject:objData];
                }
                if (self.setupLevel == HDA_SetupLevelPrimary) {
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel: HUB_SELECT_PRIMARY_SYSTEM_HEADER];
                    [self.arrSearchData removeAllObjects];
                    [self.arrSearchData addObjectsFromArray:self.arrPrimarySearchData];
                } else {
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel: HUB_SELECT_SECONDARY_SYSTEM_HEADER];
                    [self.arrSearchData removeAllObjects];
                    [self.arrSearchData addObjectsFromArray:self.arrSecondarySearchData];
                    arrSelectedDeviceIndexPath = [[NSMutableArray alloc] init];
                    // Indexing settings 1234
                    arraySelectedDevices = [[NSMutableArray alloc] init];
                    for (int j = 0; j < self.arrSearchData.count; j++) {
                    SearchData *objData = [self.arrSearchData objectAtIndex:j];
                    NSArray *arrRow = objData.arrItems;
                    for (int i = 0; i < arrRow.count; i++) {
                        [arraySelectedDevices addObject:@"0"];
                    }
                    //***********
                    }
                }
                break;
            }
            case HDA_SetupPairedAudio: {
                if (self.setupLevel == HDA_SetupLevelPrimary) {
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel: HUB_SELECT_PRIMARY_SYSTEM_HEADER];
                } else {
                    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel: HUB_SELECT_SECONDARY_SYSTEM_HEADER];
                    arrSelectedDeviceIndexPath = [[NSMutableArray alloc] init];
                }
                break;
            }
            default:
            break;
        }

    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
       // self.tblSearch.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
        [[AppDelegate appDelegate] setShouldRotate:NO];
        if (mHubManagerInstance.objSelectedHub.Generation != mHub4KV3) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(longPressRecognizerHandler_ReorderTableview:)];
            longPress.minimumPressDuration = 2.0;
            [self.tblSearch addGestureRecognizer:longPress];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
        [self.view layoutIfNeeded];
    } @catch(NSException *exception) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrSearchData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SearchData *objData = [self.arrSearchData objectAtIndex:section];
    NSArray *arrRow = objData.arrItems;
//    for(int i = 0 ; i < [arrRow count];i++)
//    {
//        //NSLog(@"audio name %@",[arrRow objectAtIndex:i]);
//    }
    return [arrRow count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SearchData *objData = [self.arrSearchData objectAtIndex:section];
    if ([objData.arrItems count] > 0) {
       // return objData.sectionHeight;
        return 0.0f;
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
    [cellHeader.imgCell setTintColor:[AppDelegate appDelegate].themeColoursSetup.themeType == Dark ? colorWhite : colorBlack];
    cellHeader.imgCell.image = objData.imgSection;
    if (isDeviceSelected == true) {
        if (selectedDeviceIndexpath.section == section) {
            [cellHeader.contentView setAlpha:ALPHA_ENABLE];
        } else {
            [cellHeader.contentView setAlpha:ALPHA_DISABLE];
        }
    } else {
        [cellHeader.contentView setAlpha:ALPHA_ENABLE];
    }
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
        CellSetupDevice *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
        }
        // cell.imgCellBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColoursSetup.colorBackground Frame:cell.imgCellBackground.frame];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblAddress setFont:textFontRegular10];
            [cell.lblCell setFont:textFontBold10];
            [cell.lblClickingNo setFont:textFontBold10];

        }
        else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
            [cell.lblAddress setFont:textFontRegular14];
            [cell.lblCell setFont:textFontBold14];
            [cell.lblClickingNo setFont:textFontBold14];

        }
        else {
            [cell.lblAddress setFont:textFontRegular16];
            [cell.lblCell setFont:textFontBold16];
            [cell.lblClickingNo setFont:textFontBold16];

        }
        SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];

        Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
        //NSMutableString *title = [[NSMutableString alloc] initWithString:@"CONNECT TO"]
        
        NSMutableString *title = [[NSMutableString alloc] initWithString:@""];

        if ([objData.arrItems count] > 1) {
            NSInteger intCount = indexPath.row+1;
            //[title appendString:[NSString stringWithFormat:@" \"%@\" #%ld", objHub.Name, (long)intCount]];
            [title appendString:[NSString stringWithFormat:@"%@", objHub.Official_Name]];

        } else {
            [title appendString:[NSString stringWithFormat:@"%@", objHub.Official_Name]];
        }

        if (![objHub.Address isIPAddressEmpty]) {
           // [title appendString:[NSString stringWithFormat:@" (%@)", objHub.Address]];
            cell.lblAddress.text =[NSString stringWithFormat:@"%@", objHub.Address];
        }
        cell.lblCell.text = [title uppercaseString];
        

        if (self.setupLevel == HDA_SetupLevelPrimary) {
            cell.lblClickingNo.hidden = true;
            cell.imgCell.hidden = false;
            if (isDeviceSelected == true) {
                if ([indexPath isEqual:selectedDeviceIndexpath]) {
                    UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.imgCell setImage:image];
                    [cell setUserInteractionEnabled:true];
                    [cell.contentView setAlpha:ALPHA_ENABLE];
                } else {
                    cell.imgCell.image = nil;
                    [cell setUserInteractionEnabled:false];
                    [cell.contentView setAlpha:ALPHA_DISABLE];
                }
            } else {
                cell.imgCell.image = nil;
                [cell setUserInteractionEnabled:true];
                [cell.contentView setAlpha:ALPHA_ENABLE];
            }
            cell.btn_identity.hidden = true;
        } else {
           // if (isDeviceSelected == true) {
                if ([arrSelectedDeviceIndexPath containsObject:indexPath]) {
                    UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                    [cell.imgCell setImage:image];
                    [cell setUserInteractionEnabled:true];
                    [cell.contentView setAlpha:ALPHA_ENABLE];
                    // Indexing settings 1234
                    if(arraySelectedDevices.count > 0){
                    if ([arraySelectedDevices[indexPath.row] intValue] != 0) {
                        cell.lblClickingNo.text = [NSString stringWithFormat:@"%@",arraySelectedDevices[indexPath.row]];
                    } else {
                        cell.lblClickingNo.text = @"";
                    }
                    }
                    //**********
                } else {
                    cell.lblClickingNo.text = [NSString stringWithFormat:@""];
                    cell.imgCell.image = nil;
                    [cell setUserInteractionEnabled:true];
                    [cell.contentView setAlpha:ALPHA_ENABLE];
                }
            cell.btn_identity.hidden = false;
            cell.btn_identity.sectionObj = indexPath.section;
            cell.btn_identity.rowObj = indexPath.row;
            cell.lblClickingNo.hidden = false;
            cell.imgCell.hidden = true;
           
            
//            } else {
//                cell.imgCell.image = nil;
//                if (arrSelectedDeviceIndexPath.count < 4) {
//                    [cell setUserInteractionEnabled:true];
//                    [cell.contentView setAlpha:ALPHA_ENABLE];
//                } else {
//                    [cell setUserInteractionEnabled:false];
//                    [cell.contentView setAlpha:ALPHA_DISABLE];
//                }
//            }
        }
        
//        if(objHub.BootFlag)
//        {
//            cell.lblCell.text = HUB_SYSTEM_CONFIGURED;
//            [cell setUserInteractionEnabled:false];
//            
//        }
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        switch (self.setupType) {
            case HDA_SetupVideo: {
                    [self deviceSetUpStandalone_TableIndexpath:indexPath];
                break;
            }
            case HDA_SetupAudio: {
                [self deviceSetUpStandalone_TableIndexpath:indexPath];
                break;
            }
            case HDA_SetupVideoAudio: {
                [self deviceSetUpStacked_TableIndexpath:indexPath];
                break;
            }
            case HDA_SetupPairedAudio: {
                [self deviceSetUpStacked_TableIndexpath:indexPath];
                break;
            }
            default:    break;
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - Check device identity
-(void) getIPAddressToCheckIdentity:(NSIndexPath*)indexPath {
    @try {
    SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
    
    Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
    
    if (![objHub.Address isIPAddressEmpty]) {
        [APIManager checkMhubIdentity:objHub.Address updateData:nil completion:^(APIV2Response *responseObject) {
            if (!responseObject.error) {
                
            }
        }];
    }
    
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}
-(IBAction)button_identity:(CustomButtonMultiTags *)sender{
    @try {
        
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.rowObj inSection:sender.sectionObj ];
    if (self.setupLevel == HDA_SetupLevelSecondary) {
        [self getIPAddressToCheckIdentity:indexPath];
    }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)longPressRecognizerHandler_ReorderTableview:(id)sender {
    @try {
        //    if (self.isEdit) {
        // self.isEdit = true;
        // [self.btnEditDone setHidden:false];
        // [self.tableView reloadData];
        
        UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
        UIGestureRecognizerState state = longPress.state;
        
        CGPoint location = [longPress locationInView:self.tblSearch];
        NSIndexPath *indexPath = [self.tblSearch indexPathForRowAtPoint:location];
        
     
        
        switch (state) {
            case UIGestureRecognizerStatePossible: {
                break;
            }
            case UIGestureRecognizerStateBegan: {
                if (indexPath) {
                    @try {
                        if (self.setupLevel == HDA_SetupLevelSecondary) {
                            [self getIPAddressToCheckIdentity:indexPath];
                        }
                    } @catch (NSException *exception) {
                        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
                    }
                }
                break;
            }
                
            case UIGestureRecognizerStateChanged: {
                
                break;
            }
            case UIGestureRecognizerStateEnded: {
                
                break;
            }
            case UIGestureRecognizerStateCancelled: {
                
                break;
            }
            case UIGestureRecognizerStateFailed: {
                
                break;
            }
            
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - FixedFooter In TableView
-(void) addFooterToTableView:(HDAPairSetupLevel)setupLevel {
    @try {
        static NSString *FooterCellIdentifier = @"CellSetup";
        CellSetup *cellFooter = [self.tblSearch dequeueReusableCellWithIdentifier:FooterCellIdentifier];
        if (cellFooter == nil) {
            cellFooter = [self.tblSearch dequeueReusableCellWithIdentifier:FooterCellIdentifier];
        }
        CGFloat width = self.tblSearch.frame.size.width;
        CGFloat height = 0.0f;

        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            height = heightTableViewRowWithPadding_SmallMobile;
        } else {
            height = heightTableViewRowWithPadding;
        }

        cellFooter.frame = CGRectMake(0.0f, self.tblSearch.bounds.size.height-height, width, height);
        for (id cellview in self.tblSearch.subviews) {
            if ([cellview isKindOfClass:[CellSetup class]]) {
                [cellview removeFromSuperview];
            }
        }

        if (isDeviceSelected == true) {
            [cellFooter setUserInteractionEnabled:true];
            [cellFooter.contentView setAlpha:ALPHA_ENABLE];
        } else {
            [cellFooter setUserInteractionEnabled:false];
            [cellFooter.contentView setAlpha:ALPHA_DISABLE];
        }

        if (setupLevel == HDA_SetupLevelPrimary) {
            [cellFooter.lblCell setText:@"CONTINUE"];
            UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerHandler_ContinuePrimaryButtonStacked:)];
            tapRecognizer.delegate = self;
            // ---- //
            [cellFooter addGestureRecognizer:tapRecognizer];
        } else if (setupLevel == HDA_SetupLevelSecondary) {
            [cellFooter.lblCell setText:@"NEXT"];
            UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerHandler_NextSecondaryButtonStacked:)];
            tapRecognizer.delegate = self;
            // ---- //
            [cellFooter addGestureRecognizer:tapRecognizer];
        }

        [self.tblSearch addSubview:cellFooter];
        _staticView = cellFooter;
        self.tblSearch.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) removeFooterToTableView {
    @try {
        for (id cellview in self.tblSearch.subviews) {
            if ([cellview isKindOfClass:[CellSetup class]]) {
                [cellview removeFromSuperview];
            }
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _staticView.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // this is needed to prevent cells from being displayed above our static view
    [self.tblSearch bringSubviewToFront:_staticView];
}

- (void)tapRecognizerHandler_ContinuePrimaryButtonStacked:(id)sender {
    @try {
        SearchData *objData = [self.arrSearchData objectAtIndex:selectedDeviceIndexpath.section];
        if (objData.modelType != HDA_MHUB4K431 && objData.modelType != HDA_MHUB4K862) {
            Hub *objHub = [objData.arrItems objectAtIndex:selectedDeviceIndexpath.row];
            if ([objHub.Address isIPAddressEmpty]) {
                // Fetch Service
                NSNetService *service = objHub.UserInfo;
                // Resolve Service
                [service setDelegate:self];
                [service resolveWithTimeout:3.0];
            } else {
                [self navigateToSecondarySelectDeviceScreen:objHub Stacked:true];
            }
        } else {
            Hub *objHub = [objData.arrItems objectAtIndex:selectedDeviceIndexpath.row];
            [self validationStandaloneDevice:objHub];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)tapRecognizerHandler_NextSecondaryButtonStacked:(id)sender {
    @try {
        NSMutableArray *arrSlaveDevice = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrSelectedDeviceIndexPath count]; counter++) {
            SearchData *objData = [self.arrSearchData objectAtIndex:[arrSelectedDeviceIndexPath objectAtIndex:counter].section];
            if (objData.modelType != HDA_MHUB4K431 && objData.modelType != HDA_MHUB4K862) {
                Hub *objHub = [objData.arrItems objectAtIndex:[arrSelectedDeviceIndexPath objectAtIndex:counter].row];
                if ([objHub.Address isIPAddressEmpty]) {
                    // Fetch Service
                    NSNetService *service = objHub.UserInfo;
                    // Resolve Service
                    [service setDelegate:self];
                    [service resolveWithTimeout:3.0];
                } else {
                    BOOL isValid = [objHub.Address isValidIPAddress];
                    if (isValid) {
                        if (arrSlaveDevice.count > 0) {
                            for (Hub *objHubTemp in arrSlaveDevice) {
                                if ([objHubTemp.SerialNo isEqualToString:objHub.SerialNo]) {
                                    DDLogDebug(@"Already exist 1" );
                                } else {
                                    [arrSlaveDevice addObject:[[Hub alloc] initWithHub:objHub]];
                                    break;
                                }
                            }
                        } else {
                            [arrSlaveDevice addObject:[[Hub alloc] initWithHub:objHub]];
                        }
                    }
                }
            }
        }
        if ([arrSlaveDevice count] > 0) {
            [self validationStackedDevice:self.objSelectedMHubDevice Stacked:self.isSelectedPaired Slave:arrSlaveDevice];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Standalone Validation and Navigation Methods
-(void) deviceSetUpStandalone_TableIndexpath:(NSIndexPath*)indexPath {
    @try {
        selectedDeviceIndexpath = indexPath;
        SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
        // If device is Video type and not equal to MHUB V3 model i.e device type is Pro, V4 or MAX
        // If device is Audio type and not equal to MHUB V3 model
        if (objData.modelType != HDA_MHUB4K431 && objData.modelType != HDA_MHUB4K862) {
            Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
            if ([objHub.Address isIPAddressEmpty]) {
                // Fetch Service
                NSNetService *service = objHub.UserInfo;
                // Resolve Service
                [service setDelegate:self];
                [service resolveWithTimeout:3.0];
            } else {
                BOOL isValid = [objHub.Address isValidIPAddress];
                if (isValid) {
                    [self validationStandaloneDevice:objHub];
                    ////NSLog(@"MOS version is %f and %@",objHub.mosVersion,objHub.strMOSVersion);
                }
            }
        } else { // If device is Video type and  equal to MHUB V3 model
            Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
            [self validationStandaloneDevice:objHub];
//            if ([objHub isAPIV2]) {
//               [self validationStandaloneDevice:objHub];
//            } else {
//                //[[AppDelegate appDelegate] alertControllerMOSUpdate:objHub];
//                [self alertControllerMOSUpdate:objHub];
//            }
            
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)updateDevice:(Hub*)objHub allHubArray:(NSMutableArray *)allHubs{
    
    
    UpdateHubViewController *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateHubViewController"];
    objVC.arrSearchData = allHubs;
   // objVC.objSelectedMHubDevice = objHub;
    [self.navigationController pushViewController:objVC animated:YES];
}

- (void)validationStandaloneDevice:(Hub*)objHub {
    @try {
        self.socket = nil;
        NSMutableString *strMessage = [[NSMutableString alloc] init];
        BOOL isValid = true;

        if ([objHub.Address isIPAddressEmpty]){
            isValid = false;
            [strMessage appendString:ALERT_MESSAGE_SELECT_DEVICE];
        }

        if (isValid) {
            BOOL isStacked = false;
            NSMutableArray *arrSlave = [[NSMutableArray alloc] init];
            if (objHub.Generation == mHub4KV3) {
                [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlave];
            } else {
                if (objHub.Generation == mHubAudio) {
                    [self checkDeviceIsAlreadyPaired:objHub Stacked:isStacked Slave:arrSlave];
                } else {
                    if ([objHub isAPIV2]) {
                        [self checkDeviceIsAlreadyPaired:objHub Stacked:isStacked Slave:arrSlave];
                    } else {
                        [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlave];
                    }
                }
            }
        } else {
            [[AppDelegate appDelegate] alertControllerShowMessage:strMessage];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Stacked Validation and Navigation Methods
-(void) deviceSetUpStacked_TableIndexpath:(NSIndexPath*)indexPath {
    @try {
        if (self.setupLevel == HDA_SetupLevelPrimary) {
            if (selectedDeviceIndexpath == indexPath) {
                selectedDeviceIndexpath = nil;
                isDeviceSelected = false;
                [self removeFooterToTableView];
            } else {
                selectedDeviceIndexpath = indexPath;
                isDeviceSelected = true;
                [self addFooterToTableView:HDA_SetupLevelPrimary];
            }
            [self.tblSearch reloadData];
        } else {
            if ([arrSelectedDeviceIndexPath containsObject:indexPath]) {
                [arrSelectedDeviceIndexPath removeObject:indexPath];
                // Indexing settings 1234
                [self setUpSelectionOfDevicesIndexes:indexPath.row isSelected:NO];
                //***********
                isDeviceSelected = false;
                if(arrSelectedDeviceIndexPath.count == 0){
                [self removeFooterToTableView];
                }
            } else {
                // Indexing settings 1234
                if (arrSelectedDeviceIndexPath.count < 3) {
                    //isDeviceSelected = true;
                } else {
                    //isDeviceSelected = false;
                    [self resetDeviceSelectionArray];
                    [arrSelectedDeviceIndexPath removeAllObjects];
                }
                isDeviceSelected = true;
                [arrSelectedDeviceIndexPath addObject:indexPath];
                [self setUpSelectionOfDevicesIndexes:indexPath.row isSelected:YES];
                //***************
                [self addFooterToTableView:HDA_SetupLevelSecondary];
            }
            [self.tblSearch reloadData];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

// Indexing settings 1234
- (void)resetDeviceSelectionArray{
    for (int i = 0; i < arraySelectedDevices.count; i++) {
        [arraySelectedDevices replaceObjectAtIndex:i withObject:@"0"];
    }
}

- (void)setUpSelectionOfDevicesIndexes:(NSInteger)index isSelected:(BOOL)toSelect{
    NSString *max = [[arraySelectedDevices sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [(NSString *)a compare:(NSString *)b options:NSNumericSearch];
    }] lastObject];


    for (int i = 0; i < arraySelectedDevices.count; i++) {
        if (i == index) {
            if (!toSelect) {
                if ([arraySelectedDevices[i] intValue] < max.intValue) {
                    for (int j = 0; j < arraySelectedDevices.count; j++) {
                        if ([arraySelectedDevices[j] intValue] != 0 && [arraySelectedDevices[j] intValue] > [arraySelectedDevices[i] intValue]) {
                            [arraySelectedDevices replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%d",[arraySelectedDevices[j] intValue]-1]];
                        }
                    }
                }
                [arraySelectedDevices replaceObjectAtIndex:i withObject:@"0"];
            } else {
                [arraySelectedDevices replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",max.intValue + 1]];
            }
        }
    }
}
//************

- (void)validationStackedDevice:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        self.socket = nil;
        NSMutableString *strMessage = [[NSMutableString alloc] init];
        BOOL isValid = true;

        if ([objHub.Address isIPAddressEmpty]){
            isValid = false;
            [strMessage appendString:ALERT_MESSAGE_SELECT_DEVICE];
        }

        if (isValid) {
            if (objHub.Generation == mHub4KV3) {
                [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
            } else {
                if (objHub.Generation == mHubAudio) {
                    [self checkDeviceIsAlreadyPaired:objHub Stacked:isStacked Slave:arrSlaveDevice];
                } else {
                    if ([objHub isAPIV2]) {
                        [self checkDeviceIsAlreadyPaired:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else {
                        [self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    }
                }
            }
        } else {
            [[AppDelegate appDelegate] alertControllerShowMessage:strMessage];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Pairing Validation Method
-(void) checkDeviceIsAlreadyPaired:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        if ([objHub isPairedSetup]) {
            if ([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem) {
                [Pair deviceAvailableInPair:objHub.PairingDetails SerialNo:objHub.SerialNo completion:^(BOOL isMaster, BOOL isSlave) {
                    if (isMaster) {
                        [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else if (isSlave) {
                        [self navigateToWarningScreen:HDA_SlaveExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    }
                }];
            } else if((self.setupType == HDA_SetupVideo || self.setupType == HDA_SetupAudio)) {
                [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
            } else {
                [self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
            }
        } else {
            [APIManager filePairJSON_Hub:objHub completion:^(APIV2Response *responseObject) {
                if (responseObject.error) {
                    if((self.setupType == HDA_SetupVideo || self.setupType == HDA_SetupAudio)) {
                        [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else {
                        [self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    }
                } else {
                    if ([responseObject.data_description isKindOfClass:[Pair class]]) {
                        objHub.PairingDetails = (Pair*)responseObject.data_description;
                        objHub.isPaired = true;
                    } else {
                        objHub.isPaired = false;
                        objHub.PairingDetails = [[Pair alloc] init];
                    }
                    if ([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem) {
                        [Pair deviceAvailableInPair:objHub.PairingDetails SerialNo:objHub.SerialNo completion:^(BOOL isMaster, BOOL isSlave) {
                            if (isMaster) {
                                [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                            } else if (isSlave) {
                                [self navigateToWarningScreen:HDA_SlaveExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                            }
                        }];
                    } else if((self.setupType == HDA_SetupVideo || self.setupType == HDA_SetupAudio)) {
                        [self checkStandaloneDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else {
                        [self checkStackedDeviceIsAlreadyBooted:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    }
                }
            }];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - BootFlag Validation Method
-(void) checkStandaloneDeviceIsAlreadyBooted:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice
{
    @try {
        if ([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem && objHub.BootFlag == true) {
            [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
        } else if([objHub isAlreadyPairedSetup]) {
            [Pair deviceAvailableInPair:objHub.PairingDetails SerialNo:objHub.SerialNo completion:^(BOOL isMaster, BOOL isSlave) {
                if (isMaster) {
                    //This code will directly navigate to made connection without seleting slave devices.
                    [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    //Below code will say this is paired unit and need to go for selecting slave devices in it.
                    //[self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                } else if (isSlave) {
                    [self navigateToWarningScreen:HDA_SlaveExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                }
            }];
        } else {
            [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) checkStackedDeviceIsAlreadyBooted:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        if ([AppDelegate appDelegate].systemType == HDA_SetupANewMHUBSystem && objHub.BootFlag == true) {
            [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
        } else {
            if (isStacked == false) {
                [Hub deviceAvailableForPair:objHub Slaves:arrSlaveDevice completion:^(BOOL isMaster, BOOL isSlave, Hub *objWarningSlave) {
                    if (isMaster) {
                        [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else if (isSlave) {
                        [self navigateToWarningScreen:HDA_SlaveExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    } else {
                        [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
                    }
                }];
            } else {
                if (objHub.BootFlag == true && [objHub.PairingDetails isPairEmpty]) {
                    [self navigateToWarningScreen:HDA_MasterExist WarningHub:objHub Stacked:isStacked Slave:arrSlaveDevice];
                } else {
                    [self navigateToSetupConfirmationScreen:objHub Stacked:isStacked Slave:arrSlaveDevice];
                }
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Navigation Methods
- (void)navigateToSecondarySelectDeviceScreen:(Hub*)objHub Stacked:(BOOL)isStacked {
    @try {
        //if ([objHub isAPIV2]) {
            SelectDeviceVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectDeviceVC"];
            objVC.setupType = self.setupType;
            objVC.setupLevel = HDA_SetupLevelSecondary;
            if (self.setupType == HDA_SetupVideoAudio && self.setupLevel == HDA_SetupLevelPrimary) {
                objVC.arrSearchData = [[NSMutableArray alloc] initWithArray:self.arrSecondarySearchData];
                // } else if (self.setupType == HDA_SetupVideoAudio && self.setupLevel == HDA_SetupLevelSecondary) {
            } else if (self.setupType == HDA_SetupPairedAudio && self.setupLevel == HDA_SetupLevelPrimary) {
                self.arrSecondarySearchData = [[NSMutableArray alloc] initWithArray:self.arrSearchData];
                for (SearchData *objSearch in self.arrSearchData) {
                    if (objSearch.modelType == HDA_MHUBAUDIO64 || objSearch.modelType == HDA_MHUBS || objSearch.modelType == HDA_MHUBPRO24440 || objSearch.modelType == HDA_MHUBPRO288100) {
                        NSInteger intIndex = [self.arrSecondarySearchData indexOfObject:objSearch];
                        NSInteger intSection  = selectedDeviceIndexpath.section;
                        if (intIndex == intSection) {
                            NSInteger intRow = selectedDeviceIndexpath.row;
                            [[self.arrSecondarySearchData objectAtIndex:intSection].arrItems removeObjectAtIndex:intRow];
                        }
                    }
                }
                objVC.arrSearchData = [[NSMutableArray alloc] initWithArray:self.arrSecondarySearchData];
                // } else if (self.setupType == HDA_SetupPairedAudio && self.setupLevel == HDA_SetupLevelSecondary) {
                // } else {
            }
            BOOL isValid = [objHub.Address isValidIPAddress];
            if (isValid) {
                objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:objHub];
                objVC.isSelectedPaired = isStacked;
            }
            [self.navigationController pushViewController:objVC animated:YES];
//        } else {
//            // This code is to simple switch to browser with update URL
//            //[[AppDelegate appDelegate] alertControllerMOSUpdate:objHub];
//            ///This is with Safari view controller and when user will come back to app, it'll ask to refresh the page.
//            [self alertControllerMOSUpdate:objHub];
//        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - AlertController
-(void) alertControllerMOSUpdate:(Hub*)objHub {
    @try {
        //UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE, nil) message:[NSString stringWithFormat:HUB_MOSUPDATE_MESSAGE, [Hub getMhubDisplayName:objHub]] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(ALERT_TITLE_UPDATE_AVAILABLE, nil) message:[NSString stringWithFormat:HUB_MOSUPDATE_MESSAGE_Without_Model] preferredStyle:UIAlertControllerStyleAlert];
        
        alertController.view.tintColor = colorGray_646464;
        NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERT_TITLE];
        [strAttributedTitle addAttribute:NSFontAttributeName
                                   value:textFontRegular13
                                   range:NSMakeRange(0, strAttributedTitle.length)];
       // [alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_UPDATE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //NSString *strAddress =   [NSString stringWithFormat:@"%@/update-step1.php", objHub.Address];
            //NSURL *url = [[API MHUBOSIndexPageURL:strAddress] absoluteURL];

            NSString *strAddress;
            NSURL *url;
            
            if(objHub.mosVersion < MOSUPDATEVERSIONTOCHECK)
            {
                if (![objHub.modelName isContainString:kDEVICEMODEL_MHUBAUDIO64])
                {
                strAddress =   [NSString stringWithFormat:@"update-step1.php?ip=%@", objHub.Address];
                url = [[API MHUBOSUpdatePageURL:strAddress] absoluteURL];
                }
                
            }
            else if(objHub.mosVersion == MOSUPDATEVERSIONTOCHECK)
            {
                if (![objHub.modelName isContainString:kDEVICEMODEL_MHUBAUDIO64])
                {
                strAddress =   [NSString stringWithFormat:@"update-step.php?ip=%@", objHub.Address];
                url = [[API MHUBOSUpdatePageURL:strAddress] absoluteURL];
                }
            }
            else{
                strAddress =   [NSString stringWithFormat:@"%@", objHub.Address];
                url =  [[API MHUBOSIndexPageURL:strAddress] absoluteURL];
            }
            
            
//            if(objHub.mosVersion < 8)
//            {
//                if(objHub.mosVersion < 7)
//                {
//                    strAddress =   [NSString stringWithFormat:@"update-step1.php?ip=%@", objHub.Address];
//                    url = [[API MHUBOSUpdatePageURL:strAddress] absoluteURL];
//                    
//                }
//                else
//                {
//                    if(objHub.BootFlag == true)
//                    {
//                        strAddress =   [NSString stringWithFormat:@"update-step1.php?ip=%@", objHub.Address];
//                        url = [[API MHUBOSUpdatePageURL:strAddress] absoluteURL];
//                    }
//                    else
//                    {
//                        strAddress =   [NSString stringWithFormat:@"%@", objHub.Address];
//                        url =  [[API MHUBOSIndexPageURL:strAddress] absoluteURL];
//                    }
//                }
//            }
//            else{
//                strAddress =   [NSString stringWithFormat:@"%@", objHub.Address];
//                url =  [[API MHUBOSIndexPageURL:strAddress] absoluteURL];
//            }
            if ([SFSafariViewController class] != nil) {
                // Use SFSafariViewController
                safariVC = [[SFSafariViewController alloc]initWithURL:url];
                safariVC.delegate = self;
                [self presentViewController:safariVC animated:YES completion:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    if (!success) {
                        DDLogError(@"%@%@",@"Failed to open url:",[url description]);
                    }
                }];
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(ALERT_BTN_TITLE_CANCEL, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
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
//    if (mHubManagerInstance.objSelectedHub.Generation != mHub4KV3) {
//        [[AppDelegate appDelegate] alertControllerReStartAfterMOSUpdate];
//    }
    
//    if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
//        [APIManager getSystemDetails:mHubManagerInstance.objSelectedHub  Stacked:mHubManagerInstance.isPairedDevice Slave:mHubManagerInstance.arrSlaveAudioDevice];
//    } else {
//        [APIManager resyncMHUBProData];
//    }
}
-(void) navigateToWarningScreen:(HDAWarningType)warningType WarningHub:(Hub*)objWarningHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        WarningMessageVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"WarningMessageVC"];
        [objVC getNavigationValue:warningType SearchData:[self.arrSearchData objectAtIndex:selectedDeviceIndexpath.section] WarningHub:objWarningHub Paired:isStacked SlaveArray:arrSlaveDevice];
        [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) navigateToSetupConfirmationScreen:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        //Now no need to update from every screen, thats why code commented below.
//        if(objHub.mosVersion < objHub.MHub_BenchMarkVersion)
//        {
//            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:arrSlaveDevice];
//            [tempArray addObject:objHub];
//            [self updateDevice:objHub allHubArray:tempArray];
//        }
//        else{
        SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
        objVC.objSelectedMHubDevice = [[Hub alloc] initWithHub:objHub];
        objVC.isSelectedPaired = isStacked;
        objVC.arrSelectedSlaveDevice = [[NSMutableArray alloc] initWithArray:arrSlaveDevice];
        [self.navigationController pushViewController:objVC animated:YES];
      //  }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Reload Data Method
-(void) reloadTableData {
    @try {
        for (SearchData *objData in self.arrSearchData) {
            if (objData.modelType != HDA_MHUB4K431 && objData.modelType != HDA_MHUB4K862) {
                for (Hub *objHub in objData.arrItems) {
                    if (![objHub.Address isIPAddressEmpty] && ![objHub.SerialNo isNotEmpty]) {
                        [APIManager fileAllDetails:objHub completion:^(APIV2Response *responseObject) {
                            if (!responseObject.error) {
                                Hub *objHubAPI = (Hub *)responseObject.data_description;

                                if ([objHubAPI.Name isNotEmpty]) {
                                    objHub.Name = objHubAPI.Name;
                                }

                                if ([objHubAPI.modelName isNotEmpty]) {
                                    objHub.modelName = objHubAPI.modelName;
                                }

                                if ([objHubAPI.Official_Name isNotEmpty]) {
                                    objHub.Official_Name = objHubAPI.Official_Name;
                                }

                                if ([objHubAPI.SerialNo isNotEmpty]) {
                                    objHub.SerialNo = objHubAPI.SerialNo;
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

                                if (objHubAPI.BootFlag == true) {
                                    objHub.BootFlag = objHubAPI.BootFlag;
                                }

                                if ([objHubAPI.HubInputData isNotEmpty]) {
                                    objHub.HubInputData = objHubAPI.HubInputData;
                                }
                                if ([objHubAPI.HubInputDataAudioInStandalone isNotEmpty]) {
                                    objHub.HubInputDataAudioInStandalone = objHubAPI.HubInputDataAudioInStandalone;
                                }

                                if ([objHubAPI.HubOutputData isNotEmpty]) {
                                    objHub.HubOutputData = objHubAPI.HubOutputData;
                                }

                                if ([objHubAPI.HubZoneData isNotEmpty]) {
                                    objHub.HubZoneData = objHubAPI.HubZoneData;
                                }

                                if (objHubAPI.isPaired == true) {
                                    objHub.isPaired = objHubAPI.isPaired;
                                }

                                if (![objHubAPI.PairingDetails isPairEmpty]) {
                                    objHub.PairingDetails = objHubAPI.PairingDetails;
                                }
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
}

//-(void)popViewController {
//    NSInteger intDeviceCount = 0;
//    for (SearchData *objData in self.arrSearchData) {
//        intDeviceCount+=objData.arrItems.count;
//    }
//    if (intDeviceCount == 0) {
//        [AppDelegate appDelegate].isDeviceNotFound = true;
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

#pragma mark - SearchData Delegate
-(void) :(SearchData *)searchData didFindDataArray:(NSMutableArray *)arrSearchedData {
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppDelegate appDelegate].isSearchNetworkPopVC = true;
}
    @end
