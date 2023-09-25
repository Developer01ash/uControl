//
//  SelectModelVC.m
//  mHubApp
//
//  Created by Yashica Agrawal on 29/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "SelectModelVC.h"
#import "AddManuallyVC.h"

@interface SelectModelVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblModel;
@property (weak, nonatomic) IBOutlet UIButton *btnDemoMode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonDemoModeHeight;
@property (nonatomic, retain) NSMutableArray *arrData;
@end

@implementation SelectModelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_ADDMANUALLY_HEADER];
    [self.lblHeaderMessage setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
    [self.btnDemoMode setTitleColor:[AppDelegate appDelegate].themeColours.colorNormalText forState:UIControlStateNormal];
    [self.btnDemoMode.layer setBorderColor:[AppDelegate appDelegate].themeColours.colorTableCellBorder.CGColor];
    [self.btnDemoMode.layer setBorderWidth:1.0];
    [self.btnDemoMode.layer setMasksToBounds:false];

    [self.lblHeaderMessage setText:HUB_ADDMANUALLY_MESSAGE];
    self.arrData = [[NSMutableArray alloc]initWithArray:[Hub getHubList]];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblHeaderMessage setFont:textFontLight10];
        [self.btnDemoMode.titleLabel setFont:textFontLight10];
        [self.constraintButtonDemoModeHeight setConstant:heightTableViewRow_SmallMobile];
    } else {
        [self.lblHeaderMessage setFont:textFontLight13];
        [self.btnDemoMode.titleLabel setFont:textFontLight13];
        [self.constraintButtonDemoModeHeight setConstant:heightTableViewRow];
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
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddManuallyVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddManuallyVC"];
    objVC.hubModel = (HubModel)(indexPath.row+1);
    [self.navigationController pushViewController:objVC animated:YES];
}

- (IBAction)btnDemoMode_Clicked:(UIButton *)sender {
    @try {
        if (![mHubManagerInstance.objSelectedHub isNotEmpty]) {
            mHubManagerInstance.objSelectedHub = [[Hub alloc] init];
        }
        mHubManagerInstance.objSelectedHub.Generation = mHubPro;
        mHubManagerInstance.objSelectedHub.modelName = [Hub getHubName: mHubManagerInstance.objSelectedHub.Generation];
        mHubManagerInstance.objSelectedHub.Address = STATICTESTIP_PRO;
        
        ConnectVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ConnectVC"];
        [self.navigationController pushViewController:objVC animated:YES];

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
