//
//  SetupMismatchViewController.m
//  mHubApp
//
//  Created by Rave on 20/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "SetupMismatchViewController.h"
#import "CellHubUpdateVersionTableViewCell.h"

@interface SetupMismatchViewController ()
{
      NSMutableArray *arrFilterData;
}
@end

@implementation SetupMismatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton =  true;
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    if(_isSoftware_mismatch){
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_SOFTWARE_MISMATCH];
        self.lbl_mismatchMessage.text = HUB_SOFTWARE_MISMATCH_MSG;
    }
    
    else{
        self.lbl_mismatchMessage.text = HUB_SETUP_MISMATCH_MSG;
        self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_SETUP_MISMATCH];
    }
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
      //  [self.lbl_title setFont:textFontBold12];
        [self.lbl_mismatchMessage setFont:textFontRegular12];
    } else {
       // [self.lbl_title setFont:textFontBold16];
        [self.lbl_mismatchMessage setFont:textFontRegular16];
    }
     
   // [self.btn_returnToMenu addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // //NSLog(@"tbl_hubListWithVersion count %ld",self.arrSearchData.count);
    
    arrFilterData = [[NSMutableArray alloc] init];
    if(self.objSelectedMHubDevice != nil)
    {
        [arrFilterData addObject:self.objSelectedMHubDevice];
    }
    else
    {
        for (SearchData *objData in self.arrSearchData) {
            // DDLogDebug(@"%@ == %ld", objData.strTitle, (long)objData.arrItems.count);
            for (Hub *objHub in objData.arrItems) {
                [arrFilterData addObject:objHub];
                
                DDLogDebug(@"viewDidAppear %f == %@", objHub.mosVersion, objHub.modelName);
            }}
    }
    //[self.tbl_mismatchWithVersion reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    @try{
        
        [self.tbl_mismatchWithVersion reloadData];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
   
    
    
}
- (IBAction)btn_gotoMenu_clicked:(CustomButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrFilterData.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    SearchData *objData = [self.arrSearchData objectAtIndex:section];
//    if ([objData.arrItems count] > 0) {
//        return objData.sectionHeight;
//    }
//    return 0.0f;
//}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     @try {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
        return UITableViewAutomaticDimension;
    }
}
@catch(NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}


//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    @try {
//        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
//            return heightBiggerCellView_SmallMobile;
//        } else {
//            return heightBiggerCellView;
//        }
//    }
//    @catch(NSException *exception) {
//        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
//    }
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        static NSString *CellIdentifier = @"CellHubUpdateVersionTableViewCell";
        CellHubUpdateVersionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        Hub *objHub = (Hub *)[arrFilterData objectAtIndex:indexPath.row];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lbl_HubVersion setFont:textFontRegular12];
            [cell.lbl_HubName setFont:textFontBold12];
        } else {
            [cell.lbl_HubVersion setFont:textFontRegular16];
            [cell.lbl_HubName setFont:textFontBold16];
        }
        [cell.lbl_HubVersion setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
        [cell.lbl_HubName setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
        if(_isSoftware_mismatch)
        {
            cell.lbl_HubVersion.text =  [NSString stringWithFormat:@"%.02f",objHub.mosVersion];
            [cell.img_mismatch_yes_no setHidden:YES];
            [cell.lbl_HubVersion setHidden:NO];
        }
        else
        {
            cell.lbl_HubVersion.text =  [NSString stringWithFormat:@"%@",objHub.Address];
            [cell.img_mismatch_yes_no setHidden:NO];
            [cell.lbl_HubVersion setHidden:NO];
            if(objHub.BootFlag )
            {
                [cell.lbl_HubVersion setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
                [cell.lbl_HubName setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
                UIImage *image = [kImageCheckMark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
                [cell.img_mismatch_yes_no setImage:image];
                [cell.img_mismatch_yes_no setTintColor:colorGreenCheck];
                //[cell.img_mismatch_yes_no setImage:kImageIconYES];
                
            }
            else
            {
                [cell.lbl_HubVersion setTextColor:colorMiddleGray_868787];
                [cell.lbl_HubName setTextColor:colorMiddleGray_868787];
                [cell.img_mismatch_yes_no setImage:nil];
            }
        }
        //[cell.imgHubDevice  setImage:[self getHubDeviceImage:objHub.modelName]];
        cell.lbl_HubName.text = objHub.modelName;
       // cell.view_roundView.backgroundColor = [UIColor blackColor];
       // [cell.view_roundView addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
        return cell;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(UIImage *)getHubDeviceImage:(NSString *)secType{
    
    
    UIImage *imageObj;
    if ([secType isContainString:kDEVICEMODEL_MHUB4K44PRO] || [secType isContainString:kDEVICEMODEL_MHUBPRO24440] ) {
        imageObj = kDEVICEMODEL_IMAGE_MHUB4K44PRO_CARBONITE;
        
    }
    if ([secType isContainString:kDEVICEMODEL_MHUB4K88PRO] || [secType isContainString:kDEVICEMODEL_MHUBPRO288100]) {
        imageObj =  kDEVICEMODEL_IMAGE_MHUB4K88PRO_CARBONITE;
        
    }
    if ([secType isContainString:kDEVICEMODEL_MHUB4K431]) {
        
        imageObj =  kDEVICEMODEL_IMAGE_MHUB4K431_CARBONITE;
        
    }
    if ([secType isContainString:kDEVICEMODEL_MHUB4K862]) {
        
        imageObj =   kDEVICEMODEL_IMAGE_MHUB4K862_CARBONITE;
        
    }
    
    if ([secType isContainString:kDEVICEMODEL_MHUB431U]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUB431U_CARBONITE;
        
    }
    if ([secType isContainString:kDEVICEMODEL_MHUB862U]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUB862U_CARBONITE;
    }
    
    if ([secType isContainString:kDEVICEMODEL_MHUBPRO4440]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBPRO4440_CARBONITE;
    }
    if ([secType isContainString:kDEVICEMODEL_MHUBPRO8840]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBPRO8840_CARBONITE;
    }
    
    if ([secType isContainString:kDEVICEMODEL_MHUBAUDIO64]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBAUDIO64_CARBONITE;
    }
    
    if ([secType isContainString:kDEVICEMODEL_MHUBMAX44]) {
        
        imageObj =   kDEVICEMODEL_IMAGE_MHUBMAX44_CARBONITE;
        
    }
    return imageObj;
    
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppDelegate appDelegate].isSearchNetworkPopVC = true;
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
