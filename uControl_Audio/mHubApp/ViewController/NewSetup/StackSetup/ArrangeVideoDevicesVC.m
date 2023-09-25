//
//  ArrangeVideoDevicesVC.m
//  mHubApp
//
//  Created by Rave Digital on 01/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "ArrangeVideoDevicesVC.h"
#import "ProfileData.h"
@interface ArrangeVideoDevicesVC ()
@end

    @implementation ArrangeVideoDevicesVC{

        NSMutableArray *arrayMHUBS;
        NSMutableArray *arrayOtherVideos;
        NSMutableArray *arrayFisrtProfileData;
        NSMutableArray *arraYsecondProfileData;
        bool flag_atLeastOneAdded;
        NSIndexPath *selectedIndexOfBottomTbl;
        NSIndexPath *selectedIndexOfTopTbl;
    }
- (void)viewDidLoad {
    @try {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    //self.navigationController.navigationBarHidden = true;
    [self.view_bottomTbl setBackgroundColor:colorDarkGray_333131];
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:ARRANGE_YOUR_VIDEO_DEVICES];
    
    self.lblHeader.text = ARRANGE_YOUR_VIDEO_DEVICES_HEADER_Message;
    self.lblSubHeader.text = ARRANGE_YOUR_VIDEO_DEVICES_SUBHEADER_Message;
    
//    self.tbl_bottom.dragInteractionEnabled = true;
//    if (@available(iOS 11.0, *)) {
//    self.tbl_top.dropDelegate = self;
//    self.tbl_bottom.dragDelegate = self;
//    }
        
    self.arr_bottomDeviceList = [[NSMutableArray alloc]init];
    self.arr_deviceAddedTop = [[NSMutableArray alloc]init];
    arrayMHUBS = [[NSMutableArray alloc]init];
    arrayOtherVideos = [[NSMutableArray alloc]init];
    self.arr_deviceAddedTop = [[NSMutableArray alloc]init];
    self.ArrTempData = [[NSMutableArray alloc]init];
    self.ArrTempData = [self.arrSearchData mutableCopy] ;//addObjectsFromArray:self.arrSearchData];
    
    [self arrangeDevices];
        [self addEmptyLayerOnCell];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            self.heightOfTable.constant = self.arr_bottomDeviceList.count *  heightTableViewRowWithPadding_SmallMobile + 40;
        } else {
            self.heightOfTable.constant = self.arr_bottomDeviceList.count * heightTableViewRowWithPadding + 40;
        }
        [self.tbl_top  reloadData];
        [self.tbl_bottom  reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}

-(void)addEmptyLayerOnCell
{
    NSInteger mhubSCount = 0;
    for (int i = 0; i < self.arr_bottomDeviceList.count; i++) {
        Hub *hubObj = [self.arr_bottomDeviceList objectAtIndex:i];
        if(hubObj.Generation == mHubS){
            mhubSCount = mhubSCount + 1;
        }
        
    }
    for (int i = 0; i < self.arr_bottomDeviceList.count ; i++) {
        Hub *hubObj = [self.arr_bottomDeviceList objectAtIndex:i];
        if(hubObj.Generation == mHubS){
            Hub *tempHub = [[Hub alloc]init];
            tempHub.Generation = hubObj.Generation;
            tempHub.Name = @"";
            tempHub.Address = @"";
            [self.arr_deviceAddedTop addObject:tempHub];
        }
    }
    if(arrayOtherVideos.count > 0)
    {
        
        Hub *tempHub = [[Hub alloc]init];
       // tempHub.Generation = hubObj.Generation;
        tempHub.Name = @"";
        tempHub.Address = @"";
        [self.arr_deviceAddedTop addObject:tempHub];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)arrangeDevices{
    @try {
        for (int i = 0; i < self.ArrTempData.count; i++) {
            SearchData *objData = [self.ArrTempData objectAtIndex:i];
            //NSLog(@"model names %ld %ld",(long)objData.modelType,[objData.arrItems count]);
            if (objData.modelType == HDA_MHUBZP5 || objData.modelType == HDA_MHUBZPMINI || objData.modelType == HDA_MHUBAUDIO64) {
                if ( objData.arrItems.count > 0) {
                    //NSLog(@"model names33 %ld %ld %d",(long)objData.modelType,[objData.arrItems count],i);
                [self.ArrTempData removeObjectAtIndex:i];
                }
            }
        }
        
    for (SearchData *objData in self.ArrTempData) {
    for (Hub *objHub in objData.arrItems) {
        //All Mhub found in a array
        [self.arr_bottomDeviceList addObject:objHub];
        if(objHub.Generation == mHubS){
            [arrayMHUBS addObject:objHub];
        }else
        {
            [arrayOtherVideos addObject:objHub];
        }
    }
    
    }
        [self.tbl_bottom reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


- (IBAction)btnADDToSystem:(CustomButton *)sender {
    @try {
   // [self.tbl_bottom setHidden:true];
        Hub *selectedHubTop = (Hub *)[self.arr_deviceAddedTop objectAtIndex:selectedIndexOfTopTbl.row];
        Hub *objHub = (Hub *)[self.arr_bottomDeviceList objectAtIndex:selectedIndexOfBottomTbl.row];
        if(selectedHubTop.Generation == mHubS)
        {
            if(objHub.Generation == mHubS){
            [self.view_bottomTbl setHidden:true];
            [self.arr_deviceAddedTop replaceObjectAtIndex:selectedIndexOfTopTbl.row withObject:objHub];
            [self.arr_bottomDeviceList removeObject:objHub];
            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                self.heightOfTable.constant = self.arr_bottomDeviceList.count *  heightTableViewRowWithPadding_SmallMobile + 40;
            } else {
                self.heightOfTable.constant = self.arr_bottomDeviceList.count * heightTableViewRowWithPadding + 40;
            }
                [self.tbl_top reloadData];
                [self.tbl_bottom reloadData];
            }
            else
            {
                [[AppDelegate appDelegate]showHudView:ShowMessage Message:@"Here you should select Rank 1 (MHUBS) devices."];
            }
            
            
        }else if(selectedHubTop.Generation != mHubS){
            if(objHub.Generation != mHubS){
            [self.view_bottomTbl setHidden:true];
            [self.arr_deviceAddedTop replaceObjectAtIndex:selectedIndexOfTopTbl.row withObject:objHub];
            [self.arr_bottomDeviceList removeObject:objHub];
            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                self.heightOfTable.constant = self.arr_bottomDeviceList.count *  heightTableViewRowWithPadding_SmallMobile + 40;
            } else {
                self.heightOfTable.constant = self.arr_bottomDeviceList.count * heightTableViewRowWithPadding + 40;
            }
                [self.tbl_top reloadData];
                [self.tbl_bottom reloadData];
            }
            else
            {
                [[AppDelegate appDelegate]showHudView:ShowMessage Message:@"Here you should select other video devices except Rank 1(MHUBS) devices."];
            }
        }else
        {
            
        }
        
        

    
    
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnNext:(CustomButton *)sender {
    @try {
    NSMutableArray *temparr = [[NSMutableArray alloc]initWithArray:self.arr_deviceAddedTop];
    for (int i = 0; i < self.arr_deviceAddedTop.count; i++) {
        Hub *hubObj = [self.arr_deviceAddedTop objectAtIndex:i];
        if([hubObj.Address isEqualToString:@""])
        {
            [temparr removeObject:hubObj];
        }
    }
        if([self checkOtherDevicesAvailableORNot]){
            ArrangeAudioAndOtherDevicesVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ArrangeAudioAndOtherDevicesVC"];
            objVC.arrSearchData  = self.arrSearchData;
            objVC.masterDevice = self.masterDevice;
            objVC.arr_deviceAddedTop = temparr;
            objVC.arr_bottomDeviceList = self.arr_bottomDeviceList;
            [self.navigationController pushViewController:objVC animated:YES];
        }else{
            ConfirmDeviceOrderVC *objVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ConfirmDeviceOrderVC"];
            objVC.arr_device_order  = temparr;
            objVC.masterDevice  = self.masterDevice;
            [self.navigationController pushViewController:objVC animated:YES];
        }
    
    
   
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}

-(BOOL)checkOtherDevicesAvailableORNot
{
    @try {
        BOOL countFlag = false;
        NSMutableArray *tempOtherDevices =  [[NSMutableArray alloc]init];
        for (int i = 0; i < self.arrSearchData.count; i++) {
            SearchData *objData = [self.arrSearchData objectAtIndex:i];
            
            if (objData.modelType == HDA_MHUBZP5 || objData.modelType == HDA_MHUBZPMINI || objData.modelType == HDA_MHUBAUDIO64) {
                for (Hub *objHub in objData.arrItems) {
                    //All Mhub found in a array
                    [tempOtherDevices addObject:objHub];
                }
            }
        }
        
        for (int i = 0; i < tempOtherDevices.count; i++) {
            Hub *hubObj = [tempOtherDevices objectAtIndex:i];
            if (hubObj.SerialNo == self.masterDevice.SerialNo ) {
                    //All Mhub found in a array
                    [tempOtherDevices removeObject:hubObj];
                
            }
        }
        if(tempOtherDevices.count > 0){
            countFlag = true;
        }
        
        return countFlag;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - Check device identity Top List
-(void) getIPAddressToCheckIdentity_top:(NSIndexPath*)indexPath {
    @try {
    Hub *objHub = [self.arr_deviceAddedTop objectAtIndex:indexPath.row];
    if (![objHub.Address isIPAddressEmpty]) {
        [APIManager checkMhubIdentity:objHub.Address updateData:nil completion:^(APIV2Response *responseObject) {
            if (!responseObject.error) {
                
            }
        }];
    }
    
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}
-(IBAction)button_identity_top:(CustomButtonMultiTags *)sender{
    @try {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.rowObj inSection:sender.sectionObj ];
        [self getIPAddressToCheckIdentity_top:indexPath];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Check device identity Bottom list
-(void) getIPAddressToCheckIdentity:(NSIndexPath*)indexPath {
    @try {
    Hub *objHub = [self.arr_bottomDeviceList objectAtIndex:indexPath.row];
    if (![objHub.Address isIPAddressEmpty]) {
        [APIManager checkMhubIdentity:objHub.Address updateData:nil completion:^(APIV2Response *responseObject) {
            if (!responseObject.error) {
                
            }
        }];
    }
    
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}
-(IBAction)button_cancel:(UIButton *)sender{
    [self.view_bottomTbl setHidden:true];
}
-(IBAction)button_identity:(CustomButtonMultiTags *)sender{
    @try {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.rowObj inSection:sender.sectionObj ];
        [self getIPAddressToCheckIdentity:indexPath];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
#pragma mark - UITableViewDataSource

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        Hub *hubObj = (Hub *)[self.arr_deviceAddedTop objectAtIndex:indexPath.row];
        if(hubObj.Generation == mHubS){
            Hub *tempHub = [[Hub alloc]init];
            tempHub.Generation = hubObj.Generation;
            tempHub.Name = @"";
            tempHub.Address = @"";
            //[self.arr_deviceAddedTop addObject:tempHub];
            [self.arr_deviceAddedTop replaceObjectAtIndex:indexPath.row withObject:tempHub];
        }else
        {
            Hub *tempHub = [[Hub alloc]init];
            tempHub.Generation = hubObj.Generation;
            tempHub.Name = @"";
            tempHub.Address = @"";
            [self.arr_deviceAddedTop replaceObjectAtIndex:indexPath.row withObject:tempHub];
        }
        [self.arr_bottomDeviceList addObject:hubObj];
        [self.tbl_top reloadData];
        [self.tbl_bottom reloadData];
    }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try {
    if (tableView == self.tbl_top) {
        return self->_arr_deviceAddedTop.count;
    } else {
        return self->_arr_bottomDeviceList.count;
    }
//    SearchData *objData = [self.arrSearchData objectAtIndex:section];
//    NSArray *arrRow = objData.arrItems;
//    return [arrRow count];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.tbl_top)
    {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            return heightTableViewRowWithPadding_SmallMobile + 15;
        } else {
            return heightTableViewRowWithPadding + 15;
        }
    }else{
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile ;
    } else {
        return heightTableViewRowWithPadding ;
    }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        CellSetupDevice *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSetupDevice"];
        }
        
        if(tableView == self.tbl_top)
        {
           
            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                [cell.lbl_foundation setFont:textFontRegular10];
                [cell.lbl_foundationConnected setFont:textFontRegular08];
            }else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
                [cell.lbl_foundation setFont:textFontRegular12];
                [cell.lbl_foundationConnected setFont:textFontRegular10];
            }else {
                [cell.lbl_foundation setFont:textFontRegular14];
                [cell.lbl_foundationConnected setFont:textFontRegular12];
            }
            Hub *obj = (Hub *)[self.arr_deviceAddedTop objectAtIndex:indexPath.row];
            if([obj.Name isEqualToString:@""])
            {
                cell.btn_identity.hidden = true;
                [cell.viewBG setBackgroundColor:colorClear];
                [cell.viewBottomBorder setBackgroundColor:colorClear];
                [cell.viewDassedLine setHidden:false];
                [cell.viewBottomBorder setHidden:false];
                [cell.lblCell setText:@""];
                cell.lblAddress.text = @"";
                [cell.lbl_foundation setHidden:false];
                [cell.lbl_deviceCount setHidden:false];
                [cell.lbl_deviceCount setText:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
                if(indexPath.row == 0){
                    [cell.lbl_foundation setText:[NSString stringWithFormat:@"Layer S%ld (Foundation)",indexPath.row +1 ]];
                    [cell.lbl_foundationConnected setHidden:false];
                }
                else{
                    [cell.lbl_foundation setText:[NSString stringWithFormat:@"Layer S%ld",indexPath.row +1 ]];
                    [cell.lbl_foundationConnected setHidden:true];
                }
                
            }
            else
            {
                cell.btn_identity.hidden = false;
                [cell.viewDassedLine setHidden:true];
                [cell.viewBG setBackgroundColor:colorGunGray_272726];
                [cell.viewBottomBorder setBackgroundColor:colorClear];
                [cell.lblCell setText:obj.modelName];
                cell.lblAddress.text = obj.Address;
                [cell.lbl_foundation setHidden:true];
                [cell.lbl_foundationConnected setHidden:true];
                [cell.lbl_deviceCount setHidden:false];
                [cell.lbl_deviceCount setText:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
                [cell.lblCell setTextColor:colorProPink];
               [ cell.lblAddress setTextColor:colorProPink];

            }
        }
        else
        {
//            if(selectedIndexOfBottomTbl == indexPath){
//                [cell setBackgroundColor:colorDarkGray_262626];
//            }
//            else{
//                [cell setBackgroundColor:colorDarkGray_333131];
//            }
            [cell.viewBottomBorder setHidden:false];
            [cell.lbl_foundation setHidden:true];
            [cell.lbl_foundationConnected setHidden:true];
            Hub *objHub = (Hub *)[self.arr_bottomDeviceList objectAtIndex:indexPath.row];
            [cell.lblCell setText:objHub.modelName];
            cell.lblAddress.text = objHub.Address;
            
        }
        cell.btn_identity.tag = indexPath.row;
        cell.btn_identity.sectionObj = indexPath.section;
        cell.btn_identity.rowObj = indexPath.row;
        //cell.btn_identity.hidden = false;
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view_bottomTbl setHidden:true];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if(tableView == self.tbl_top)
        {
            Hub *obj = (Hub *)[self.arr_deviceAddedTop objectAtIndex:indexPath.row];
            [self.tbl_top scrollsToTop];
            [self.tbl_top scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            if(self.arr_bottomDeviceList.count > 0){//Because if there is device to add at bottom, then we can show the table view.
                if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                    self.heightOfTable.constant = self.arr_bottomDeviceList.count *  heightTableViewRowWithPadding_SmallMobile + 40;
                } else {
                    self.heightOfTable.constant = self.arr_bottomDeviceList.count * heightTableViewRowWithPadding + 40;
                }
            selectedIndexOfTopTbl = indexPath;
            [self.view_bottomTbl setHidden:false];
            }
        }
        else
        {
            [self.tbl_bottom reloadData];
            selectedIndexOfBottomTbl = indexPath;
            Hub *selectedHubTop = (Hub *)[self.arr_deviceAddedTop objectAtIndex:selectedIndexOfTopTbl.row];
            Hub *objHub = (Hub *)[self.arr_bottomDeviceList objectAtIndex:selectedIndexOfBottomTbl.row];
            if(selectedHubTop.Generation == mHubS)
            {
                if(objHub.Generation == mHubS){
                [self.view_bottomTbl setHidden:true];
                [self.arr_deviceAddedTop replaceObjectAtIndex:selectedIndexOfTopTbl.row withObject:objHub];
                [self.arr_bottomDeviceList removeObject:objHub];
                if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                    self.heightOfTable.constant = self.arr_bottomDeviceList.count *  heightTableViewRowWithPadding_SmallMobile + 40;
                } else {
                    self.heightOfTable.constant = self.arr_bottomDeviceList.count * heightTableViewRowWithPadding + 40;
                }
                    [self.tbl_top reloadData];
                    [self.tbl_bottom reloadData];
                }
                else
                {
                    [[AppDelegate appDelegate]showHudView:ShowMessage Message:@"Here you should select Rank 1 (MHUBS) devices."];
                }
                
                
            }else if(selectedHubTop.Generation != mHubS){
                if(objHub.Generation != mHubS){
                [self.view_bottomTbl setHidden:true];
                [self.arr_deviceAddedTop replaceObjectAtIndex:selectedIndexOfTopTbl.row withObject:objHub];
                [self.arr_bottomDeviceList removeObject:objHub];
                if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                    self.heightOfTable.constant = self.arr_bottomDeviceList.count *  heightTableViewRowWithPadding_SmallMobile + 40;
                } else {
                    self.heightOfTable.constant = self.arr_bottomDeviceList.count * heightTableViewRowWithPadding + 40;
                }
                    [self.tbl_top reloadData];
                    [self.tbl_bottom reloadData];
                }
                else
                {
                    [[AppDelegate appDelegate]showHudView:ShowMessage Message:@"Here you should select other video devices except Rank 1(MHUBS) devices."];
                }
            }else
            {
                
            }
            
            
        }
        

    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

//-(UIDragItem *)dragItem:(NSIndexPath *)indexPath
//{
//    NSString *imageName = arraySecond[indexPath.row];
//    ProfileData *data = arraYsecondProfileData[indexPath.row];
//    NSString *string = data.profileImageName;
//    NSItemProvider *itemProvider = [[NSItemProvider alloc]initWithObject:string];
//    UIDragItem *dragItem =[[UIDragItem alloc]initWithItemProvider:itemProvider];
//    dragItem.localObject = imageName;
//    return dragItem;
//}

//-(UIDragPreviewParameters *)previewParameters:(NSIndexPath *)indexPath
//{
//    CellSetupDevice *cell = [self.tbl_top cellForRowAtIndexPath:indexPath];
//    UIDragPreviewParameters *previewParameters;
//    previewParameters.visiblePath = [UIBezierPath bezierPathWithRect:cell.imgCell.frame];
//    return previewParameters;
//}
//
//
//- (nonnull NSArray<UIDragItem *> *)tableView:(nonnull UITableView *)tableView itemsForBeginningDragSession:(nonnull id<UIDragSession>)session atIndexPath:(nonnull NSIndexPath *)indexPath {
//
//    UIDragItem *dragItem = [self dragItem:indexPath];
//    NSArray <UIDragItem*>*test = @[dragItem];
//    return test;
//
//}
//- (NSArray<UIDragItem *> *)tableView:(UITableView *)tableView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point
//{
//    UIDragItem *dragItem = [self dragItem:indexPath];
//    NSArray <UIDragItem*>*test = @[dragItem];
//    return test;
//}
//- (UIDragPreviewParameters *)tableView:(UITableView *)tableView dragPreviewParametersForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self previewParameters:indexPath];
//}
//- (void)tableView:(nonnull UITableView *)tableView performDropWithCoordinator:(nonnull id<UITableViewDropCoordinator>)coordinator {
//
//
//    NSIndexPath *destinationIndexPath;
//    if (coordinator.destinationIndexPath != nil) {
//        destinationIndexPath = coordinator.destinationIndexPath;
//    }
//    else
//    {
//        NSInteger section =  tableView.numberOfSections - 1;
//        NSInteger row =  [tableView numberOfRowsInSection:section];
//        destinationIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
//    }
    

//    coordinator.session.loadObjects(ofClass: NSString.self) { items in
//        guard let string = items as? [String] else { return }
//
//        var indexPaths = [IndexPath]()
//
//        for (index, value) in string.enumerated() {
//            let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
//            self.arraySecond.insert(value, at: indexPath.row)
//            indexPaths.append(indexPath)
//        }
//        tableView.insertRows(at: indexPaths, with: .automatic)
//    }
//}











/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
