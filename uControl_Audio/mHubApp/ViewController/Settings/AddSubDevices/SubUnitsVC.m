//
//  SubUnitsVC.m
//  mHubApp
//
//  Created by Apple on 28/01/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "SubUnitsVC.h"

@interface SubUnitsVC ()
@property (strong, nonatomic) NSMutableArray *arrSubUnitsDevices;
@property (weak, nonatomic) IBOutlet UITableView *tbl_subUnitDevice;
@property (strong, nonatomic) IBOutlet UIButton *btn_back;
@end

@implementation SubUnitsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelSettings:@"Add Device"];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lbl_title setFont:textFontBold12];
        [self.lbl_subTitle setFont:textFontRegular12];
    } else {
        [self.lbl_title setFont:textFontBold16];
        [self.lbl_subTitle setFont:textFontRegular16];
    }
[self.lbl_title setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
[self.lbl_subTitle setTextColor:colorMiddleGray_868787];
   
//    self. = [[NSMutableArray alloc] initWithObjects:kDEVICE_MHUB_PRO2, kDEVICE_MHUB_PRO,kDEVICE_MHUB_S,kDEVICE_MHUB_U,kDEVICE_MHUB_ZONEPROCESSOR, nil];
    switch (self.selectedSetting.sectionType) {
         case HDA_MhubPro: {
             self.arrSubUnitsDevices = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBProDevicesArray]];
             break;
         }
            
        case HDA_MhubPro2: {
            self.arrSubUnitsDevices = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBPro2DevicesArray]];
            break;
        }

        case HDA_MhubS: {
            self.arrSubUnitsDevices = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBSDevicesArray]];
            break;
        }
            
        case HDA_Mhub_ZP: {
            self.arrSubUnitsDevices = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBZPDevicesArray]];
            break;
        }

        case HDA_Mhub_Max: {
            self.arrSubUnitsDevices = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBMaxDevicesArray]];
            break;
        }
            
        case HDA_Mhub_Audio: {
            self.arrSubUnitsDevices = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBAudioDevicesArray]];
            break;
        }
        case HDA_Mhub_U: {
            self.arrSubUnitsDevices = [[NSMutableArray alloc] initWithArray:[SectionSetting getMHUBUDevicesArray]];
            break;
        }
       
        

        default:
            break;
    }
    [self.tbl_subUnitDevice reloadData];
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
    return self.arrSubUnitsDevices.count;
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
        SectionSetting *objSection = [self.arrSubUnitsDevices objectAtIndex:indexPath.row];
        //NSLog(@"objSection row array model name %@",objSection.arrRow);
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
    //cell.lblCell.text = [[self.arrSubUnitsDevices objectAtIndex:indexPath.row] uppercaseString];
    return cell;
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        SectionSetting *objSection = [self.arrSubUnitsDevices objectAtIndex:indexPath.row];
       
        [AppDelegate appDelegate].isSearchNetworkPopVC = false;
        SearchNetworkVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchNetworkVC"];
        objVC.navigateFromType = menu_profileConnect;
        objVC.searchSpecificDevice =  [objSection.arrRow objectAtIndex:0];
        [AppDelegate appDelegate].systemType = HDA_SetupANewMHUBSystem;
        objVC.isManuallyConnectNavigation =  false;
        objVC.isOpenFromSettingsScreen =  true;
        [self.navigationController pushViewController:objVC animated:NO];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [AppDelegate appDelegate].isSearchNetworkPopVC = true;
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
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
