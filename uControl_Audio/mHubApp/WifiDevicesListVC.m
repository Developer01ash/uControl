//
//  WifiDevicesListVC.m
//  mHubApp
//
//  Created by Ashutosh Tiwari on 16/03/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import "WifiDevicesListVC.h"
#import "CellHeaderImage.h"
#import "CellSetupDevice.h"
@interface WifiDevicesListVC ()

@property (strong, nonatomic) NSMutableArray *arrSearchDataClass;

@end

@implementation WifiDevicesListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_SELECT_DEVICE_HEADER];
    [self.lblHeaderMessage setText:Wifi_find_the_device];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontBold12];
    } else {
        [self.lblHeaderMessage setFont:textFontBold16];
    }
    
   
      
    self.arrSearchDataClass = [[NSMutableArray alloc]init];
    for (SearchData *objData in self.arrSearchData) {
        //If mhub units are Wifi, then will appear on screen otherwise
       if (objData.modelType == HDA_MHUBZP5 || objData.modelType == HDA_MHUBZPMINI) {
           if([objData.arrItems isNotEmpty])
           {
               [self.arrSearchDataClass addObject:objData];
           }
       }
       }
    if([self.arrSearchDataClass isNotEmpty]){
        self.arrSearchData = self.arrSearchDataClass;
           [self.tblSearch reloadData];
    }
    else
    {
        //August2020: It should go back to wifi setup screen.
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[WifiSubMenuVC class]]) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:HUB_NO_MHUB_WIFI_FOUND];
                [self.navigationController popToViewController:vc animated:false];
            }
        }
    }
    //[self.tblSearch reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppDelegate appDelegate].isSearchNetworkPopVC = true;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrSearchData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SearchData *objData = [self.arrSearchData objectAtIndex:section];
    NSArray *arrRow = objData.arrItems;
//    for(int i = 0 ; i < [arrRow count];i++)
//    {
//        Hub *objHub = [arrRow objectAtIndex:i];
//
//        //NSLog(@"audio name %@",objHub.Address);
//    }
    return [arrRow count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SearchData *objData = [self.arrSearchData objectAtIndex:section];
//    if ([objData.arrItems count] > 0) {
//        return objData.sectionHeight;
//    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    static NSString *HeaderCellIdentifier = @"CellHeaderImage";
//    SearchData *objData = [self.arrSearchData objectAtIndex:section];
//    CellHeaderImage *cellHeader = [self.tblSearch dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
//    if (cellHeader == nil) {
//        cellHeader = [self.tblSearch dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
//    }
//    [cellHeader.imgCell setTintColor:[AppDelegate appDelegate].themeColoursSetup.themeType == Dark ? colorWhite : colorBlack];
//    cellHeader.imgCell.image = objData.imgSection;
//    if (isDeviceSelected == true) {
//        if (selectedDeviceIndexpath.section == section) {
//            [cellHeader.contentView setAlpha:ALPHA_ENABLE];
//        } else {
//            [cellHeader.contentView setAlpha:ALPHA_DISABLE];
//        }
//    } else {
//        [cellHeader.contentView setAlpha:ALPHA_ENABLE];
//    }
//    return cellHeader;
//}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        static NSString *CellIdentifier = @"CellSetup";
        CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblCell setFont:textFontBold10];
        } else {
            [cell.lblCell setFont:textFontBold13];
        }
        SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
        Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
        NSMutableString *title= [[NSMutableString alloc] initWithString:@""];;
        
        
        if ([objData.arrItems count] > 1) {
            NSInteger intCount = indexPath.row+1;
            [title appendString:[NSString stringWithFormat:@"%@ #%ld", objHub.Official_Name, (long)intCount]];
        } else {
            [title appendString:[NSString stringWithFormat:@"%@", objHub.Official_Name]];
        }
        
        if (![objHub.Address isIPAddressEmpty]) {
            cell.lblCell.text = [NSString stringWithFormat:@"%@", objHub.Address];
           // [title appendString:[NSString stringWithFormat:@"\n(%@)", objHub.Address]];
        }
        cell.lblCell.text = [title uppercaseString];
   
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        SearchData *objData = [self.arrSearchData objectAtIndex:indexPath.section];
        Hub *objHub = [objData.arrItems objectAtIndex:indexPath.row];
        
        [AppDelegate appDelegate].isSearchNetworkPopVC = false;
        WifiDiscoveryModeVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WifiDiscoveryModeVC"];
        objVC.objSelectedMHubDevice =  objHub;
        [self.navigationController pushViewController:objVC animated:YES];

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
