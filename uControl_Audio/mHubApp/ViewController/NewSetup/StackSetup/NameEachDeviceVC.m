//
//  NameEachDeviceVC.m
//  mHubApp
//
//  Created by Rave Digital on 23/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "NameEachDeviceVC.h"

@interface NameEachDeviceVC ()

@end

@implementation NameEachDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    //self.navigationController.navigationBarHidden = true;
        
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:NAME_EACH_DEVICE];
    
    self.lblHeader.text = NAME_EACH_DEVICE_HEADER;
    self.lblSubHeader.text = @"";
    [self.arr_device_name insertObject:self.masterDevice atIndex:0];
    [self.tbl_devices reloadData];
//    
    
}

- (IBAction)btnNext:(CustomButton *)sender {
    @try {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SerialNo == %@", self.masterDevice.SerialNo];
    NSArray *arrCmdDataFiltered = [self.arr_device_name filteredArrayUsingPredicate:predicate];
    if(arrCmdDataFiltered.count >0 ){
    Hub *objHub2 = (Hub *)[arrCmdDataFiltered objectAtIndex:0];
    [self.arr_device_name removeObject:objHub2];
    }
    SetupConfirmationVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetupConfirmationVC"];
    objVC.objSelectedMHubDevice = self.masterDevice;
    objVC.isSelectedPaired = true;
    objVC.arrSelectedSlaveDevice = self.arr_device_name;
    [self.navigationController pushViewController:objVC animated:YES];
    
    
//    ContinueOnuOSVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ContinueOnuOSVC"];
//    objVC.arr_devices  = self.arr_device_name;
//    objVC.masterDevice  = self.masterDevice;
//    [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
#pragma mark - UITableViewDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try {
   
        return self->_arr_device_name.count;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}





-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile + 50;
    } else {
        return heightTableViewRowWithPadding + 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        CellSetupDevice *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
        }
       
         
            Hub *obj = (Hub *)[self.arr_device_name objectAtIndex:indexPath.row];
                [cell.lblCell setText:obj.Name];
                cell.lblAddress.text = obj.Address;
                [cell.lbl_deviceCount setHidden:false];
                [cell.lbl_deviceCount setText:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
                [cell setBackgroundColor:colorClear];
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
        numberToolbar.tintColor = colorWhite;
        numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
        [numberToolbar sizeToFit];
        cell.txtF_deviceName.inputAccessoryView = numberToolbar;
        cell.txtF_deviceName.tag = indexPath.row;
        
        cell.view_textFieldNCount.layer.borderWidth = 1.0f;
        cell.view_textFieldNCount.layer.borderColor = colorMiddleGray_868787.CGColor;
        [cell.lblCell setTextColor:colorMiddleGray_868787];
        [cell.lblAddress setTextColor:colorMiddleGray_868787];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblAddress setFont:textFontRegular12];
            [cell.lblCell setFont:textFontRegular12];
            [cell.lbl_deviceCount setFont:textFontBold18];
        } else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
            [cell.lblAddress setFont:textFontRegular14];
            [cell.lblCell setFont:textFontRegular14];
            [cell.lbl_deviceCount setFont:textFontBold20];
        }else {
            [cell.lblAddress setFont:textFontRegular16];
            [cell.lblCell setFont:textFontBold16];
            [cell.lbl_deviceCount setFont:textFontBold22];
        }

        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
       
        

    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return true;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CellSetupDevice *cell = [self.tbl_devices cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    Hub *obj = (Hub *)[self.arr_device_name objectAtIndex:textField.tag];
    obj.hubName_InStack = cell.txtF_deviceName.text;
    NSLog(@"name %@",cell.txtF_deviceName.text);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    
    return true;
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
