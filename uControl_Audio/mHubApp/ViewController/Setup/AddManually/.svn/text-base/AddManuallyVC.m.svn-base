//
//  AddManuallyVC.m
//  mHubApp
//
//  Created by rave on 9/18/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "AddManuallyVC.h"

@interface AddManuallyVC ()
@end

@implementation AddManuallyVC
@synthesize hubModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    // Do any additional setup after loading the view.
    
    if (hubModel == mHub4KV3) {
        [SSDPManager disconnectSSDPmHub];
        self.arrData = [[NSMutableArray alloc]initWithArray:[Hub getmHub4KV3List]];
    } else {
        self.arrData = [[NSMutableArray alloc]init];
    }
    
    if ([mHubManagerInstance.objSelectedHub isNotEmpty]) {
        mHubManagerInstance.objSelectedHub.Generation = hubModel;
        mHubManagerInstance.objSelectedHub.modelName = [Hub getHubName: mHubManagerInstance.objSelectedHub.Generation];
    } else {
        mHubManagerInstance.objSelectedHub = [[Hub alloc] init];
        mHubManagerInstance.objSelectedHub.Generation = hubModel;
        mHubManagerInstance.objSelectedHub.modelName = [Hub getHubName: mHubManagerInstance.objSelectedHub.Generation];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_ADDMANUALLY_HEADER];
    [self.lblHeaderMessage setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontLight10];
    } else {
        [self.lblHeaderMessage setFont:textFontLight13];
    }
    [self.lblHeaderMessage setText:HUB_ADDMANUALLY_MESSAGE];
    [[AppDelegate appDelegate] setShouldRotate:NO];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat height = MIN(self.tblDeviceType.bounds.size.height, self.tblDeviceType.contentSize.height);
    self.heightTblDeviceType.constant = height;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontLight10];
    } else {
        [self.lblHeaderMessage setFont:textFontLight13];
    }
    [self.view layoutIfNeeded];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"IPAddressView"]) {
        ControlTypeVC *objCtrlType = (ControlTypeVC *)[segue destinationViewController];
        objCtrlType.delegate = self;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tblSelection) {
        return 1;
    } else {
        return self.arrData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tblSelection) {
        return 0.0f;
    } else {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            return heightTableViewRowWithPadding_SmallMobile;
        } else {
            return heightTableViewRowWithPadding;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CellSetup *cellHeader = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    if (cellHeader == nil) {
        cellHeader = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    }
    if (tableView == self.tblDeviceType) {
        cellHeader.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorNavigationBar Frame:cellHeader.imgBackground.frame];
        [cellHeader.lblCell setTextColor:[AppDelegate appDelegate].themeColours.colorOutputText];
        cellHeader.lblCell.text = [[Hub getHubName:hubModel] uppercaseString];
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
    CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
        tableView.allowsSelection = true;
    }
    
    if (tableView == self.tblSelection) {
        cell.lblCell.text = [[NSString stringWithFormat:@"Connect to %@", [Hub getHubName:hubModel]] uppercaseString];
    } else {
        cell.lblCell.text = [[self.arrData objectAtIndex:indexPath.row] uppercaseString];
        if ([indexPath isEqual:selectedIndexPath]) {
            [cell.imageView setTintColor:[AppDelegate appDelegate].themeColours.colorNormalText];
            UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
            [cell.imageView setImage:image];
        } else {
            cell.imageView.image = nil;
        }
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tblSelection) {
        [self navigateToNextScreen];
    } else {
        selectedIndexPath = indexPath;
        switch (indexPath.row) {
            case MHUB4K431: {
                mHubManagerInstance.objSelectedHub.InputCount = 4;
                mHubManagerInstance.objSelectedHub.OutputCount = 4;
                break;
            }
            case MHUB4K862: {
                mHubManagerInstance.objSelectedHub.InputCount = 8;
                mHubManagerInstance.objSelectedHub.OutputCount = 8;
                break;
            }
                
            default:
                break;
        }
        [self.tblDeviceType reloadData];
    }
}

- (void)navigateToNextScreen {
    @try {
        [[self view] endEditing:YES];

        NSMutableString *strMessage = [[NSMutableString alloc] init];
        BOOL isValid = true;
        
        if (mHubManagerInstance.objSelectedHub.Generation <= (HubModel)0) {
            isValid = false;
            [strMessage appendString:ALERT_MESSAGE_SELECT_HUBMODEL];
        }
        
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3 && ![selectedIndexPath isNotEmpty]) {
            isValid = false;
            [strMessage appendString:[NSString stringWithFormat:ALERT_MESSAGE_SELECT_MHUB4KV3TYPE, [Hub getHubName:mHubManagerInstance.objSelectedHub.Generation]]];
        }
        
        if ([mHubManagerInstance.objSelectedHub.Address isIPAddressEmpty]){
            isValid = false;
            [strMessage appendString:ALERT_MESSAGE_ENTER_IPADDRESS];
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

#pragma mark -- IPAddressContainerVC Delegate --

-(void)animateView:(BOOL)isUp {
    @try {
        [self animateView_up:isUp];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)animateView_up:(BOOL)up
{
    int movementDistance;
    if (IS_IPHONE_4_HEIGHT) {
        movementDistance = -160; // tweak as needed
    } else {
        movementDistance = -100; // tweak as needed
    }
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
