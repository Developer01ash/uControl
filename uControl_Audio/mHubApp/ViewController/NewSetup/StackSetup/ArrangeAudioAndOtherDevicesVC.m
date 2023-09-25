//
//  ArrangeAudioAndOtherDevicesVC.m
//  mHubApp
//
//  Created by Rave Digital on 23/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "ArrangeAudioAndOtherDevicesVC.h"

@interface ArrangeAudioAndOtherDevicesVC ()

@end

@implementation ArrangeAudioAndOtherDevicesVC
{
    NSIndexPath *selectedIndexOfBottomTbl;
    NSIndexPath *selectedIndexOfTopTbl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    //self.navigationController.navigationBarHidden = true;
    [self.view_bottomTbl setBackgroundColor:colorDarkGray_333131];
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:OTHER_DEVICES];
    [self.view_bottomTbl setBackgroundColor:colorDarkGray_333131];
    self.lblHeader.text = ARRANGE_YOUR_AUDIO_DEVICES_HEADER_Message;
    self.lblSubHeader.text = ARRANGE_YOUR_AUDIO_DEVICES_SUBHEADER_Message;
  //  self.arr_bottomDeviceList = [[NSMutableArray alloc]init];
   // self.arr_deviceAddedTop = [[NSMutableArray alloc]init];
    [self arrangeDevices];
    
    for (int i = 0; i < self.arr_bottomDeviceList.count ; i++) {
    Hub *hubObj = [self.arr_bottomDeviceList objectAtIndex:i];
    if(hubObj.Generation == mHubS){
            Hub *tempHub = [[Hub alloc]init];
            tempHub.Generation = hubObj.Generation;
            tempHub.Name = @"";
            tempHub.Address = @"";
            [self.arr_deviceAddedTop addObject:tempHub];
    }else{
            Hub *tempHub = [[Hub alloc]init];
            tempHub.Generation = hubObj.Generation;
            tempHub.Name = @"";
            tempHub.Address = @"";
            [self.arr_deviceAddedTop addObject:tempHub];
        }
    }
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        self.heightOfTable.constant = self.arr_bottomDeviceList.count *  heightTableViewRowWithPadding_SmallMobile + 40;
    } else {
        self.heightOfTable.constant = self.arr_bottomDeviceList.count * heightTableViewRowWithPadding + 40;
    }
    [self.tbl_top  reloadData];
    [self.tbl_bottom  reloadData];
   
}


-(void)arrangeDevices
{
    @try {
        self.arr_bottomDeviceList = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.arrSearchData.count; i++) {
            SearchData *objData = [self.arrSearchData objectAtIndex:i];
            
            if (objData.modelType == HDA_MHUBZP5 || objData.modelType == HDA_MHUBZPMINI || objData.modelType == HDA_MHUBAUDIO64) {
                for (Hub *objHub in objData.arrItems) {
                    //All Mhub found in a array
                    [self.arr_bottomDeviceList addObject:objHub];
                }
            }
        }
        
        for (int i = 0; i < self.arr_bottomDeviceList.count; i++) {
            Hub *hubObj = [self.arr_bottomDeviceList objectAtIndex:i];
            if (hubObj.SerialNo == self.masterDevice.SerialNo ) {
                    //All Mhub found in a array
                    [self.arr_bottomDeviceList removeObject:hubObj];
                
            }
        }
        
//    for (SearchData *objData in self.ArrTempData) {
//    for (Hub *objHub in objData.arrItems) {
//        //All Mhub found in a array
//        [self.arr_bottomDeviceList addObject:objHub];
//    }
//
//    }
        [self.tbl_bottom reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(IBAction)button_cancel:(UIButton *)sender{
    [self.view_bottomTbl setHidden:true];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view_bottomTbl setHidden:true];
}

- (IBAction)btnADDToSystem:(CustomButton *)sender {
    
    [self.view_bottomTbl setHidden:true];
    Hub *objHub = (Hub *)[self.arr_bottomDeviceList objectAtIndex:selectedIndexOfBottomTbl.row];
    [self.arr_deviceAddedTop replaceObjectAtIndex:selectedIndexOfTopTbl.row withObject:objHub];
    [self.arr_bottomDeviceList removeObject:objHub];
   
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        self.heightOfTable.constant = self.arr_bottomDeviceList.count *  heightTableViewRowWithPadding_SmallMobile + 40;
    } else {
        self.heightOfTable.constant = self.arr_bottomDeviceList.count * heightTableViewRowWithPadding + 40;
    }
    [self.tbl_top reloadData];
    [self.tbl_bottom reloadData];
}


- (IBAction)btnNext:(CustomButton *)sender {
    NSMutableArray *temparr = [[NSMutableArray alloc]initWithArray:self.arr_deviceAddedTop];
    for (int i = 0; i < self.arr_deviceAddedTop.count; i++) {
        Hub *hubObj = [self.arr_deviceAddedTop objectAtIndex:i];
        if([hubObj.Address isEqualToString:@""])
        {
            [temparr removeObject:hubObj];
        }
        
    }
    ConfirmDeviceOrderVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ConfirmDeviceOrderVC"];
    objVC.arr_device_order  = temparr;
    objVC.masterDevice  = self.masterDevice;
    [self.navigationController pushViewController:objVC animated:YES];
}

#pragma mark - Check device identity Top List
-(void) getIPAddressToCheckIdentity_top:(NSIndexPath*)indexPath {
    @try {
    Hub *objHub = [self.arr_deviceAddedTop objectAtIndex:indexPath.row];
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
-(IBAction)button_identity_top:(CustomButtonMultiTags *)sender{
    @try {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.rowObj inSection:sender.sectionObj ];
        [self getIPAddressToCheckIdentity_top:indexPath];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
#pragma mark - Check device identity
-(void) getIPAddressToCheckIdentity:(NSIndexPath*)indexPath {
    @try {
    Hub *objHub = [self.arr_bottomDeviceList objectAtIndex:indexPath.row];
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
        [self getIPAddressToCheckIdentity:indexPath];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
#pragma mark - UITableViewDataSource
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        Hub *hubObj = (Hub *)[self.arr_deviceAddedTop objectAtIndex:indexPath.row];
        if(hubObj.Generation == mHubS){
            Hub *tempHub = [[Hub alloc]init];
            tempHub.Generation = hubObj.Generation;
            tempHub.Name = @"";
            tempHub.Address = @"";
            //[self.arr_deviceAddedTop addObject:tempHub];
            [self.arr_deviceAddedTop replaceObjectAtIndex:indexPath.row withObject:tempHub];
        }else
        {
            Hub *tempHub = [[Hub alloc]init];
            tempHub.Generation = hubObj.Generation;
            tempHub.Name = @"";
            tempHub.Address = @"";
            [self.arr_deviceAddedTop replaceObjectAtIndex:indexPath.row withObject:tempHub];
        }
        [self.arr_bottomDeviceList addObject:hubObj];
        [self.tbl_top reloadData];
        [self.tbl_bottom reloadData];
    }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try {
    if (tableView == self.tbl_top) {
        return self->_arr_deviceAddedTop.count;
    } else {
        return self->_arr_bottomDeviceList.count;
    }
//    SearchData *objData = [self.arrSearchData objectAtIndex:section];
//    NSArray *arrRow = objData.arrItems;
//    return [arrRow count];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile+15;
    } else {
        return heightTableViewRowWithPadding+15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        CellSetupDevice *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
        }
        if(tableView == self.tbl_top){
            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                [cell.lbl_foundation setFont:textFontRegular10];
                [cell.lbl_foundationConnected setFont:textFontRegular08];
            }else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
                [cell.lbl_foundation setFont:textFontRegular12];
                [cell.lbl_foundationConnected setFont:textFontRegular10];
            }else {
                [cell.lbl_foundation setFont:textFontRegular14];
                [cell.lbl_foundationConnected setFont:textFontRegular12];
            }
            Hub *obj = (Hub *)[self.arr_deviceAddedTop objectAtIndex:indexPath.row];
            if([obj.Name isEqualToString:@""]){
                cell.btn_identity.hidden = true;
                [cell.viewBG setBackgroundColor:colorClear];
                [cell.viewBottomBorder setBackgroundColor:colorClear];
                [cell.viewDassedLine setHidden:false];
                [cell.viewBottomBorder setHidden:false];
                [cell.lblCell setText:@""];
                cell.lblAddress.text = @"";
                [cell.lbl_foundation setHidden:false];
                [cell.lbl_deviceCount setHidden:true];
                if(indexPath.row == 0){
                    [cell.lbl_foundation setText:[NSString stringWithFormat:@"Layer S%ld (Foundation)",indexPath.row +1 ]];
                    [cell.lbl_foundationConnected setHidden:false];
                }
                else{
                    [cell.lbl_foundation setText:[NSString stringWithFormat:@"Layer S%ld",indexPath.row +1 ]];
                    [cell.lbl_foundationConnected setHidden:true];
                }
            }
            else{
                cell.btn_identity.hidden = false;
                [cell.viewDassedLine setHidden:true];
                [cell.viewBG setBackgroundColor:colorGunGray_272726];
                [cell.viewBottomBorder setBackgroundColor:colorClear];
                [cell.lblCell setText:obj.Name];
                cell.lblAddress.text = obj.Address;
                [cell.lblCell setTextColor:colorProPink];
               [ cell.lblAddress setTextColor:colorProPink];
                [cell.lbl_foundation setHidden:true];
                [cell.lbl_foundationConnected setHidden:true];
                [cell.lbl_deviceCount setHidden:false];
                [cell.lbl_deviceCount setText:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
            }
        }
        else
        {
            cell.btn_identity.hidden = false;
            if(selectedIndexOfBottomTbl == indexPath){
                [cell setBackgroundColor:colorDarkGray_262626];
            }
            else{
                [cell setBackgroundColor:colorDarkGray_333131];
            }
            [cell.viewBottomBorder setHidden:false];
            [cell.lbl_foundation setHidden:true];
            [cell.lbl_foundationConnected setHidden:true];
            Hub *objHub = (Hub *)[self.arr_bottomDeviceList objectAtIndex:indexPath.row];
            [cell.lblCell setText:objHub.Name];
            cell.lblAddress.text = objHub.Address;
            
        }
//        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
//            [cell.lblAddress setFont:textFontRegular12];
//            [cell.lblCell setFont:textFontBold12];
//            [cell.lblClickingNo setFont:textFontBold12];
//        } else {
//            [cell.lblAddress setFont:textFontRegular16];
//            [cell.lblCell setFont:textFontBold16];
//            [cell.lblClickingNo setFont:textFontBold16];
//        }

        cell.btn_identity.tag = indexPath.row;
        cell.btn_identity.sectionObj = indexPath.section;
        cell.btn_identity.rowObj = indexPath.row;
//        cell.btn_identity.hidden = false;
           

        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if(tableView == self.tbl_top){
            if(self.arr_bottomDeviceList.count > 0){//Because if there is device to add at bottom, then we can show the table view.
                if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                    self.heightOfTable.constant = self.arr_bottomDeviceList.count *  heightTableViewRowWithPadding_SmallMobile + 40;
                } else {
                    self.heightOfTable.constant = self.arr_bottomDeviceList.count * heightTableViewRowWithPadding + 40;
                }
            selectedIndexOfTopTbl = indexPath;
            [self.view_bottomTbl setHidden:false];
            }
        }
        else{
            selectedIndexOfBottomTbl = indexPath;
           // [self.tbl_bottom reloadData];
            [self.view_bottomTbl setHidden:true];
            Hub *objHub = (Hub *)[self.arr_bottomDeviceList objectAtIndex:selectedIndexOfBottomTbl.row];
            [self.arr_deviceAddedTop replaceObjectAtIndex:selectedIndexOfTopTbl.row withObject:objHub];
            [self.arr_bottomDeviceList removeObject:objHub];
           
            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                self.heightOfTable.constant = self.arr_bottomDeviceList.count *  heightTableViewRowWithPadding_SmallMobile + 40;
            } else {
                self.heightOfTable.constant = self.arr_bottomDeviceList.count * heightTableViewRowWithPadding + 40;
            }
            [self.tbl_top reloadData];
            [self.tbl_bottom reloadData];
        }
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
