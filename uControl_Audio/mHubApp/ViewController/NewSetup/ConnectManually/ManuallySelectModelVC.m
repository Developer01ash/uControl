//
//  ManuallySelectModelVC.m
//  mHubApp
//
//  Created by Anshul Jain on 29/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ManuallySelectModelVC.h"
#import "ManuallyEnterIPAddressVC.h"
#import "SetupConfirmationVC.h"
#import "ManuallyAddSlaveModelVC.h"

@interface ManuallySelectModelVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblModel;
@property (nonatomic, retain) NSMutableArray *arrData;
@end

@implementation ManuallySelectModelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.backBarButtonItem = customBackBarButton;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    [self.lblHeaderMessage setTextColor:colorWhite];

    if (self.setupLevel == HDA_SetupLevelPrimary && (self.setupType == HDA_SetupVideoAudio || self.setupType == HDA_SetupPairedAudio)) {
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_SELECT_PRIMARY_SYSTEM_HEADER];
        [self.lblHeaderMessage setText:HUB_CONNECT_MANUALLY_PRIMARY_DEVICE_MESSAGE];
    } else {
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_ADDMANUALLY_HEADER];
        [self.lblHeaderMessage setText:HUB_CONNECT_MANUALLY_DEVICE_TYPE_MESSAGE];
    }

    if (self.setupType == HDA_SetupVideo) {
        self.arrData = [[NSMutableArray alloc] initWithArray:[Hub getVideoHubList]];
    } else if (self.setupType == HDA_SetupVideoAudio) {
        self.arrData = [[NSMutableArray alloc] initWithArray:[Hub getVideoMasterHubList]];
    } else if (self.setupType == HDA_SetupPairedAudio) {
        self.arrData = [[NSMutableArray alloc] initWithArray:[Hub getAudioHubList]];
    } else {
        self.arrData = [[NSMutableArray alloc]initWithArray:[Hub getHubList]];
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontBold12];
    } else {
        [self.lblHeaderMessage setFont:textFontBold16];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
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
    }
    cell.lblCell.text = [[self.arrData objectAtIndex:indexPath.row] uppercaseString];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
       
        [ cell.lblCell setFont:textFontBold10];
    } else {
        [ cell.lblCell setFont:textFontBold13];
       
    }
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if (self.setupType == HDA_SetupVideoAudio || self.setupType == HDA_SetupPairedAudio) {
            ManuallyAddSlaveModelVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ManuallyAddSlaveModelVC"];
            objVC.setupType = self.setupType;
            if (self.setupType == HDA_SetupVideoAudio) {
                switch (indexPath.row) {
                    case 0: objVC.hubModel = mHubPro;   break;
                    case 1: objVC.hubModel = mHub4KV4;  break;
                    case 2: objVC.hubModel = mHubMAX;   break;
                    case 6: objVC.hubModel = mHubZP;   break;
                    default:    break;
                }
            } else {
                objVC.hubModel = mHubAudio;
            }
            [self.navigationController pushViewController:objVC animated:YES];

        } else {
            ManuallyEnterIPAddressVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ManuallyEnterIPAddressVC"];
            objVC.hubModel = (HubModel)(indexPath.row+1);
            objVC.setupType = self.setupType;
            objVC.setupLevel = self.setupLevel;
            [AppDelegate appDelegate].systemType = HDA_ConnectManually;
            [self.navigationController pushViewController:objVC animated:YES];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
