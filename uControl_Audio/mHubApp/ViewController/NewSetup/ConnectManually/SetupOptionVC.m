//
//  SetupOptionVC.m
//  mHubApp
//
//  Created by Apple on 13/04/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import "SetupOptionVC.h"
@interface SetupOptionVC ()
@property (nonatomic, retain) NSMutableArray *arrData;

@end

@implementation SetupOptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:SETUP_MHUB];
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    // [self.lblHeaderMessage setText:HUB_CONNECT_MANUALLY_PAGE_DESCRIPTION];
     // self.arrData = [[NSMutableArray alloc] initWithObjects:HUB_SETUP_A_NEW_MHUB_SYSTEM, HUB_CONNECT_TO_AN_EXISTING_MHUB_SYSTEM, HUB_ENTER_DEMO_MODE, nil];
     self.arrData = [[NSMutableArray alloc] initWithObjects: HUB_CONNECT_NEW_SYSTEM,HUB_ADDMANUALLY_HEADER, nil];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
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
        cell.lblCell.text = [[self.arrData objectAtIndex:indexPath.row] uppercaseString];
        
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
        switch (indexPath.row) {
            case 0: {
                [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                // [self navigateToWarningScreen:HDA_ManuallyConnect];
                SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
                objVC.isManuallyConnectNavigation =  true;
                objVC.navigateFromType =  self.navigateFromType;
                //[AppDelegate appDelegate].systemType = HDA_SetupANewMHUBSystem;
                [self.navigationController pushViewController:objVC animated:YES];
                break;
            }
            case 1: {

                [AppDelegate appDelegate].isSearchNetworkPopVC = false;
                [self navigateToManuallySetUp];
                break;
            }
            default:
                break;
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


-(void) navigateToManuallySetUp {
    @try {
        ManuallySelectModelVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ManuallySelectModelVC"];
        objVC.setupLevel = HDA_SetupLevelPrimary;
        [AppDelegate appDelegate].systemType = HDA_ConnectManually;
        [self.navigationController pushViewController:objVC animated:YES];
    } @catch (NSException *exception) {
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
