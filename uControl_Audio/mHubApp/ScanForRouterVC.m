//
//  ScanForRouterVC.m
//  mHubApp
//
//  Created by Ashutosh Tiwari on 20/12/19.
//  Copyright © 2019 Rave Infosys. All rights reserved.
//

#import "ScanForRouterVC.h"
#import "ConnectToRouterVC.h"
@interface ScanForRouterVC (){
NSMutableArray *arrRoutersList;
}
@end

@implementation ScanForRouterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:Connect_to_wifi];
   
    
    self.lbl_heading.text = [NSString stringWithFormat:Scan_Network_heading];
    self.lbl_subHeading.text = [NSString stringWithFormat:Scan_Network_subHeading];
    if ([AppDelegate appDelegate].deviceType == mobileSmall)  {
        [self.lbl_heading setFont:textFontBold12];
        [self.lbl_subHeading setFont:textFontRegular12];
    } else {
        [self.lbl_heading setFont:textFontBold16];
        [self.lbl_subHeading setFont:textFontRegular16];
    }
    
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    [self callRouterScanApi];
    [self.btn_cancelScan addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];

    arrRoutersList = [[NSMutableArray alloc]init];
}

-(void)callRouterScanApi
{
    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
    [APIManager wifiNetworkScan:[FGRoute getGatewayIP] updateData:nil completion:^(NSDictionary *responseObject) {
        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
         if(responseObject != nil){
            NSLog(@"wifiNetworkScan Success  %@",responseObject);
             self->arrRoutersList = [[responseObject objectForKey:@"data"] objectForKey:@"WiFi"];
             [self.tblRouterWifiList reloadData];
             [self.btn_cancelScan setHidden:YES];
            // arrRoutersList
        }
        else
        {
            [self.btn_cancelScan setHidden:NO];
            //NSLog(@"wifiNetworkScan error  %@",responseObject);
        }
    }];

}
- (IBAction)btnCancelScan:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];


}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->arrRoutersList.count;
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
        //cell.lblCell.text = @"test Router";
        cell.lblCell.text = [[[arrRoutersList objectAtIndex:indexPath.row]objectForKey:@"ESSID" ] uppercaseString];

        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblCell setFont:textFontBold10];
        } else {
            [cell.lblCell setFont:textFontBold13];
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
        ConnectToRouterVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"ConnectToRouterVC"];
        objVC.SSIDNameStr = [[arrRoutersList objectAtIndex:indexPath.row]objectForKey:@"ESSID" ];

        objVC.encryptionNameStr = [[arrRoutersList objectAtIndex:indexPath.row]objectForKey:@"Encryption" ];
        [self.navigationController pushViewController:objVC animated:NO];
    }
    @catch(NSException *exception) {
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
