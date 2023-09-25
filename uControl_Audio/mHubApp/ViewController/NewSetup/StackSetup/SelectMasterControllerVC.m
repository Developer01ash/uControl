//
//  SelectMasterControllerVC.m
//  mHubApp
//
//  Created by Rave Digital on 01/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "SelectMasterControllerVC.h"

@interface SelectMasterControllerVC ()
{
    NSIndexPath *selectedIndexOfBottomTbl;
}
@end

@implementation SelectMasterControllerVC

- (void)viewDidLoad {
    @try {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    [self.view_bottomTbl setBackgroundColor:colorDarkGray_333131];
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:SELECT_MASTER_CONTROLLER];
    self.lblHeader.text = SELECT_MASTER_CONTROLLER_HEADER_Message;
    self.lblSubHeader.text = SELECT_MASTER_CONTROLLER_SUBHEADER_Message;
    self.arrMasterControllers = [[NSMutableArray alloc]init];
    self.arr_deviceAddedTop = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.arrSearchData.count; i++) {
            SearchData *objData = [self.arrSearchData objectAtIndex:i];
            //NSLog(@"model names11 %ld %ld",(long)objData.modelType,[objData.arrItems count]);
            if (objData.modelType == HDA_MHUBZP5 || objData.modelType == HDA_MHUBZPMINI ) {
                for (Hub *objHub in objData.arrItems) {
                    //All Mhub found in a array
                    [self.arrMasterControllers addObject:objHub];
                }
            }
        }
        
    Hub *tempHub = [[Hub alloc]init];
    tempHub.Generation = tempHub.Generation;
    tempHub.Name = @"";
    tempHub.Address = @"";
    [self.arr_deviceAddedTop addObject:tempHub];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            self.heightOfTable.constant = self.arrMasterControllers.count *  heightTableViewRowWithPadding_SmallMobile + 40;
        } else {
            self.heightOfTable.constant = self.arrMasterControllers.count * heightTableViewRowWithPadding + 40;
        }
    [self.tbl_masterDevice reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnContinue:(CustomButton *)sender {
    @try {
        if([self.masterDevice.Address isNotEmpty])
        {
            ArrangeVideoDevicesVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ArrangeVideoDevicesVC"];
            objVC.arrSearchData  = self.arrSearchData;
            objVC.masterDevice = self.masterDevice;
            [self.navigationController pushViewController:objVC animated:YES];
        }
        else{
            [[AppDelegate appDelegate]showHudView:ShowMessage Message:@"Select Master Controller"];
        }
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}

-(IBAction)button_cancel:(UIButton *)sender{
    [self.view_bottomTbl setHidden:true];
}
- (IBAction)btnADDToSystem:(CustomButton *)sender {
    @try {
   // [self.tbl_bottom setHidden:true];
    [self.view_bottomTbl setHidden:true];
    Hub *objHub = (Hub *)[self.arrMasterControllers objectAtIndex:selectedIndexOfBottomTbl.row];
  //  [self.arrMasterControllers addObject:[self.arr_deviceAddedTop objectAtIndex:0]];
    [self.arr_deviceAddedTop replaceObjectAtIndex:0 withObject:objHub];
    //[self.arr_deviceAddedTop addObject:objHub];
       
  //  [self.arrMasterControllers removeObject:objHub];
    [self.tbl_masterDevice reloadData];
    [self.tbl_selectFromBottom reloadData];
    self.masterDevice = objHub;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        self.heightOfTable.constant = self.arrMasterControllers.count *  heightTableViewRowWithPadding_SmallMobile + 40;
    } else {
        self.heightOfTable.constant = self.arrMasterControllers.count * heightTableViewRowWithPadding + 40;
    }
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}

#pragma mark - Check device identity
-(void) getIPAddressToCheckIdentity:(NSIndexPath*)indexPath {
    @try {
    Hub *objHub = [self.arrMasterControllers objectAtIndex:indexPath.row];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.tbl_masterDevice){
        return  self.arr_deviceAddedTop.count;
    }else{
        
        return [self.arrMasterControllers count];
    }
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
        }
        
        if(tableView == self.tbl_masterDevice){
            cell.btn_identity.hidden = true;
                [cell.lbl_foundation setText:@"Master Controller"];
                [cell.lbl_foundationConnected setText:@"This is your system controller and manager"];
                [cell.lbl_foundation setHidden:false];
                [cell.lbl_foundationConnected setHidden:false];
            Hub *obj = (Hub *)[self.arr_deviceAddedTop objectAtIndex:indexPath.row];
            if([obj.Address isEqualToString:@""])
            {
                
                [cell.viewBottomBorder setHidden:true];
                [cell.viewDassedLine setHidden:false];
            }
            else
            {
                
                //[cell.viewDassedLine.layer removeFromSuperlayer];
                [cell.viewDassedLine setHidden:true];
                [cell.lbl_foundation setHidden:true];
                [cell.lbl_foundationConnected setHidden:true];
                [cell.lblCell setText:obj.modelName];
                cell.lblAddress.text = obj.Address;
                [cell.lblCell setTextColor:colorProPink];
               [ cell.lblAddress setTextColor:colorProPink];
                [cell setBackgroundColor:colorGunGray_272726];
            }
            
            
            
        }else{
            cell.btn_identity.hidden = false;
//            if(selectedIndexOfBottomTbl == indexPath){
//                [cell setBackgroundColor:colorDarkGray_262626];
//            }
//            else
//            {
//                [cell setBackgroundColor:colorDarkGray_333131];
//            }
      
        cell.btn_identity.tag = indexPath.row;
        cell.btn_identity.sectionObj = indexPath.section;
        cell.btn_identity.rowObj = indexPath.row;
        
            Hub *objHub = [self.arrMasterControllers objectAtIndex:indexPath.row];
            [cell.lblCell setText:objHub.modelName];
            cell.lblAddress.text = objHub.Address;
            
           
//            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
//                [cell.lblAddress setFont:textFontRegular12];
//                [cell.lblCell setFont:textFontBold12];
//                [cell.btn_identity.titleLabel setFont:textFontBold10];
//            }
//            else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
//                [cell.lblAddress setFont:textFontRegular14];
//                [cell.lblCell setFont:textFontBold14];
//                [cell.btn_identity.titleLabel setFont:textFontBold12];
//            }else {
//                [cell.lblAddress setFont:textFontRegular16];
//                [cell.lblCell setFont:textFontBold16];
//                [cell.lblClickingNo setFont:textFontBold16];
//                [cell.btn_identity.titleLabel setFont:textFontBold14];
//            }
            
           
        }
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
      
        if(tableView == self.tbl_masterDevice)
        {
            [self.view_bottomTbl setHidden:false];
        }
        else
        {
            selectedIndexOfBottomTbl = indexPath;
            [self.tbl_selectFromBottom reloadData];
           
           // [self.tbl_bottom setHidden:true];
            [self.view_bottomTbl setHidden:true];
            Hub *objHub = (Hub *)[self.arrMasterControllers objectAtIndex:selectedIndexOfBottomTbl.row];
          //  [self.arrMasterControllers addObject:[self.arr_deviceAddedTop objectAtIndex:0]];
            [self.arr_deviceAddedTop replaceObjectAtIndex:0 withObject:objHub];
            //[self.arr_deviceAddedTop addObject:objHub];
               
          //  [self.arrMasterControllers removeObject:objHub];
            
            self.masterDevice = objHub;
            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                self.heightOfTable.constant = self.arrMasterControllers.count *  heightTableViewRowWithPadding_SmallMobile + 40;
            } else {
                self.heightOfTable.constant = self.arrMasterControllers.count * heightTableViewRowWithPadding + 40;
            }
            [self.tbl_masterDevice reloadData];
            [self.tbl_selectFromBottom reloadData];
            
            
        }
        
        
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//           //remove the deleted object from your data source.
//           //If your data source is an NSMutableArray, do this
//           [self.arr_deviceAddedTop removeObjectAtIndex:indexPath.row];
//           [tableView reloadData]; // tell table to refresh now
//       }
//}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view_bottomTbl setHidden:true];
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
