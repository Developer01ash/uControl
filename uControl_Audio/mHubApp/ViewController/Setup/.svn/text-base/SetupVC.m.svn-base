//
//  SetupVC.m
//  mHubApp
//
//  Created by Yashica Agrawal on 22/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "SetupVC.h"
#import "SelectModelVC.h"
#import "StartSearchVC.h"

@interface SetupVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblSetup;
@property (nonatomic, retain) NSMutableArray *arrData;
@end

@implementation SetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    //self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_FIRSTTIMESETUP_HEADER;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_FIRSTTIMESETUP_HEADER];
    self.arrData = [[NSMutableArray alloc] initWithObjects:@"Start Search", @"Connect Manually", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    [self.lblHeaderMessage setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontLight10];
    } else {
        [self.lblHeaderMessage setFont:textFontLight13];
    }
    if ([AppDelegate appDelegate].isDeviceNotFound == true) {
        [AppDelegate appDelegate].isDeviceNotFound = false;
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_UNABLETOFIND_HEADER];
        [self.lblHeaderMessage setText:HUB_UNABLETOFIND_MESSAGE];
    } else {
        [self.lblHeaderMessage setText:HUB_FIRSTTIMESETUP_MESSAGE];
    }
    self.arrData = [[NSMutableArray alloc] initWithObjects:@"Start Search", @"Connect Manually", nil];
    [self.tblSetup reloadData];
    [[AppDelegate appDelegate] setShouldRotate:NO];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontLight10];
    } else {
        [self.lblHeaderMessage setFont:textFontLight13];
    }
    [self.view layoutIfNeeded];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

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
    return cell;
}

#pragma mark - UITableView Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            StartSearchVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"StartSearchVC"];
            [self.navigationController pushViewController:objVC animated:YES];
            break;
        }
        case 1: {
            SelectModelVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectModelVC"];
            [self.navigationController pushViewController:objVC animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
