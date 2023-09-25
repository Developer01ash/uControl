//
//  AddDeviceViewController.m
//  mHubApp
//
//  Created by Apple on 22/01/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "AddDeviceViewController.h"

@interface AddDeviceViewController ()
@property (strong, nonatomic) NSMutableArray *arrDevices;
@property (weak, nonatomic) IBOutlet UITableView *tbl_AddDevice;
@property (strong, nonatomic) IBOutlet UIButton *btn_back;
@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    [self.navigationController.navigationBar setHidden:NO];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lbl_title setFont:textFontBold12];
        [self.lbl_subTitle setFont:textFontRegular12];
    } else {
        [self.lbl_title setFont:textFontBold16];
        [self.lbl_subTitle setFont:textFontRegular16];
    }
[self.lbl_title setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
[self.lbl_subTitle setTextColor:colorMiddleGray_868787];

    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:@"Add Device"];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    
    self.arrDevices = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBModelDevicesArray]];
    [self.tbl_AddDevice reloadData];
    [self.btn_back setTitleColor:[AppDelegate appDelegate].themeColours.colorNormalText forState:UIControlStateNormal];
    [self.btn_back setTitle:HUB_BACK forState:UIControlStateNormal];
}

-(IBAction)ClickOn_BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 10;
    return self.arrDevices.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    @try {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            return heightTableViewRowWithPadding_SmallMobile;
        } else {
            return heightTableViewRowWithPadding;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
    static NSString *CellIdentifier = @"CellSetting";
    
    CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
        SectionSetting *objSection = [self.arrDevices objectAtIndex:indexPath.row];
        cell.lblCell.text = [objSection.Title uppercaseString];

        cell.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorBackground Frame:cell.imgBackground.frame];
        [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorTableCellBorder BorderWidth:1.0];
        cell.lblCell.textColor = [AppDelegate appDelegate].themeColours.colorNormalText;
        UIImage *image = [kImageIconNextArrow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        [cell.imgNextArrow  setTintColor:[AppDelegate appDelegate].themeColours.colorDownArrow];
        [cell.imgNextArrow setImage:image];
        [cell.imgNextArrow setTintColor:[AppDelegate appDelegate].themeColours.colorNormalText];

        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblCell setFont:textFontBold10];
        } else {
            [cell.lblCell setFont:textFontBold13];
        }
        
        //cell.lblCell.text = [objSection.Title uppercaseString];
    return cell;
    
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        SectionSetting *objSection = [self.arrDevices objectAtIndex:indexPath.row];

        SubUnitsVC *objVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"SubUnitsVC"];
        objVC.selectedSetting = objSection;
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
