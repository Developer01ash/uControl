//
//  CloudDeviceListVC.m
//  mHubApp
//
//  Created by Anshul Jain on 26/04/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "CloudDeviceListVC.h"
#import "CellCloudDevice.h"
#import "CloudData.h"
#import "UserData.h"
#import "SubSettingsVC.h"

@interface CloudDeviceListVC ()

@end

@implementation CloudDeviceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SubSettingsVC class]]) {
            [self.navigationController popToViewController:vc animated:true];
        } 
    }
}

-(void) viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        self.navigationItem.backBarButtonItem = customBackBarButton;

        self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:HUB_QUICKSYNCHDACLOUD];
        [self.lblHeaderMessage setText:[NSString stringWithFormat:HUB_MULTIPLESERIALNO_MESSAGE, (long)self.arrData.count]];
        [self.lblHeaderMessage setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.lblHeaderMessage setFont:textFontRegular12];
        } else {
            [self.lblHeaderMessage setFont:textFontRegular18];
        }

        [[AppDelegate appDelegate] setShouldRotate:NO];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontRegular12];
    } else {
        [self.lblHeaderMessage setFont:textFontRegular18];
    }
    [self.view layoutIfNeeded];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPaddingWithLabel_SmallMobile;
    } else {
        return heightTableViewRowWithPaddingWithLabel;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        CellCloudDevice *cell = [tableView dequeueReusableCellWithIdentifier:@"CellCloudDevice"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellCloudDevice"];
        }
        
        CloudData *objData = [self.arrData objectAtIndex:indexPath.row];
        
        [cell.lblCell setText:objData.strSerialNo];
        [cell.imgCell setImage:objData.imgMHub];
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {

        CloudData *objData = (CloudData *)[self.arrData objectAtIndex:indexPath.row];
        [self.dictParameter setObject:objData.strSerialNo forKey:kSerial_Number];
        
        [APIManager fetchCloudBackup:self.dictParameter completion:^(APIResponse *objResponse) {
            DDLogDebug(@"fetchCloudBackup objResponse == %@", objResponse);
            if (objResponse.error == false) {
                [mHubManagerInstance syncGlobalManagerObjectV0];
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[SettingsVC class]]) {
                        [self.navigationController popToViewController:vc animated:true];
                    }
                }
            } else {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
            }
        }];

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


@end
