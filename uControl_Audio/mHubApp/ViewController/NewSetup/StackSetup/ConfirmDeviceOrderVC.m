//
//  ConfirmDeviceOrderVC.m
//  mHubApp
//
//  Created by Rave Digital on 23/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "ConfirmDeviceOrderVC.h"

@interface ConfirmDeviceOrderVC ()

@end

@implementation ConfirmDeviceOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    //self.navigationController.navigationBarHidden = true;
        
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:CONFIRM_DEVICE_ORDER];
    
    self.lblHeader.text = CONFIRM_DEVICE_ORDER_HEADER;
    self.lblSubHeader.text = @"";
    
    
}


- (IBAction)btnNext:(CustomButton *)sender {
    
    NameEachDeviceVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"NameEachDeviceVC"];
    objVC.arr_device_name  = self.arr_device_order;
    objVC.masterDevice  = self.masterDevice;
    [self.navigationController pushViewController:objVC animated:YES];
}

#pragma mark - Check device identity
-(void) getIPAddressToCheckIdentity:(NSIndexPath*)indexPath {
    @try {
    Hub *objHub = [self.arr_device_order objectAtIndex:indexPath.row];
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
    @try {
   
        return self->_arr_device_order.count;
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetup"];
        }
       
         
            Hub *obj = (Hub *)[self.arr_device_order objectAtIndex:indexPath.row];
          
                //Hub *obj = (Hub *)[self.arr_deviceAddedTop objectAtIndex:indexPath.row];
                [cell.lblCell setText:obj.Name];
                cell.lblAddress.text = obj.Address;
                [cell.lbl_foundation setHidden:true];
                [cell.lbl_foundationConnected setHidden:true];
                [cell.lbl_deviceCount setHidden:false];
                [cell.lbl_deviceCount setText:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
                [cell setBackgroundColor:colorGunGray_272726];
        [cell.viewBottomBorder setBackgroundColor:[AppDelegate appDelegate].themeColoursSetup.colorBackground];
        
               // [cell.lbl_deviceCount setText:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
           
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblAddress setFont:textFontRegular12];
            [cell.lblCell setFont:textFontRegular12];
            [cell.lbl_deviceCount setFont:textFontBold20];
        } else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
            [cell.lblAddress setFont:textFontRegular14];
            [cell.lblCell setFont:textFontRegular14];
            [cell.lbl_deviceCount setFont:textFontBold22];
        }else {
            [cell.lblAddress setFont:textFontRegular16];
            [cell.lblCell setFont:textFontBold16];
            [cell.lbl_deviceCount setFont:textFontBold25];
        }
        cell.btn_identity.hidden = false;
        cell.btn_identity.tag = indexPath.row;
        cell.btn_identity.sectionObj = indexPath.section;
        cell.btn_identity.rowObj = indexPath.row;
        [cell.lblCell setTextColor:colorProPink];
       [ cell.lblAddress setTextColor:colorProPink];
    
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
       
        

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
