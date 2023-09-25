//
//  InputDeviceVC.m
//  mHubApp
//
//  Created by Anshul Jain on 23/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
 VC to show InputDevice data i.e. List of Input and AVR when ControlVC load as main screen.
 This is the container view child Class of ControlVC.
 In this file we can perform switching between Output and Input Device.
 We can perform selection of AVR device also.
 */

#import "InputDeviceVC.h"
#import "CellInput.h"
#import "APIManager.h"

@interface InputDeviceVC ()
@property (nonatomic, retain) NSMutableArray *arrInputs;
@property (nonatomic, retain) NSMutableArray *local_arrayOutputs;
@end
@implementation InputDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = customBackBarButton;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadInput object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kNotificationReloadInput
                                               object:nil];
    
}
- (void) receiveNotification:(NSNotification *) notification {
    DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
    [self viewWillAppear:false];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.collectionInputDevice setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.collectionInputDevice setContentSize:CGSizeMake(self.collectionInputDevice.contentSize.width, self.view.frame.size.height)];
    [self.collectionInputDevice reloadData];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    @try {
        self.local_arrayOutputs = [[NSMutableArray alloc]init];
        self.collectionInputDevice.backgroundColor = [AppDelegate appDelegate].themeColours.colorInputBackground;
        self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
        if([mHubManagerInstance.objSelectedHub  isZPSetup] && ![mHubManagerInstance.objSelectedHub isPairedSetup] )
            // if([mHubManagerInstance.objSelectedHub  isZPSetup] )
        {
            
            NSLog(@"isZPSetup %@  %@",[AppDelegate appDelegate].arrayInput,[AppDelegate appDelegate].arrayOutPut);
            self.arrInputs = [[NSMutableArray alloc] initWithArray:mHubManagerInstance.arrayInput];
            self.arrInputs = [[[self.arrInputs reverseObjectEnumerator] allObjects] mutableCopy];
            //[self.collectionInputDevice reloadData];
            [self.arrInputs addObjectsFromArray:mHubManagerInstance.arrayAVR];

            [self.arrInputs addObjectsFromArray:mHubManagerInstance.arrayOutPut];
            [self.local_arrayOutputs addObjectsFromArray:mHubManagerInstance.arrayOutPut];
            for (int i = 0; i < mHubManagerInstance.objSelectedHub.HubOutputData.count; i++) {
                mHubManager *extractedExpr = mHubManagerInstance;
                OutputDevice *obj = [extractedExpr.objSelectedHub.HubOutputData objectAtIndex:i];
                if([obj.CreatedName containsString:@"CEC"] && [[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecView"])
                {
                    [self.arrInputs addObject:obj];
                }
                ////NSLog(@"array %@  %@  %ld",obj.CreatedName,obj.Name,(long)obj.Index);
            }
            
            self.arrInputs = [[[self.arrInputs reverseObjectEnumerator] allObjects] mutableCopy];
            [self.collectionInputDevice reloadData];
        }
        else{
            self.arrInputs = [[NSMutableArray alloc] init];
            //NSMutableArray  *duplicateArray = mHubManagerInstance.arrSourceDeviceManaged;
            self.arrInputs = [[NSMutableArray alloc] initWithArray:mHubManagerInstance.arrSourceDeviceManaged];
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"PortNo" ascending:YES];
            [self.arrInputs sortUsingDescriptors:[NSArray arrayWithObject:sort]];
            self.arrInputs = [[[self.arrInputs reverseObjectEnumerator] allObjects] mutableCopy];
            if([mHubManagerInstance.objSelectedHub  is411Setup])
            {
                [self.arrInputs addObjectsFromArray:mHubManagerInstance.arrayInput];
            }
            
            if (mHubManagerInstance.objSelectedHub.AVR_IRPack && [mHubManagerInstance.objSelectedAVRDevice isNotEmpty]) {
                [self.arrInputs addObject:mHubManagerInstance.objSelectedAVRDevice];
            } else if (mHubManagerInstance.objSelectedHub.AVR_IRPack && mHubManagerInstance.objSelectedHub.HubAVRList.count > 0) {
                mHubManagerInstance.objSelectedAVRDevice = mHubManagerInstance.objSelectedHub.HubAVRList.firstObject;
                [self.arrInputs addObject:mHubManagerInstance.objSelectedAVRDevice];
            }
            if([mHubManagerInstance.objSelectedHub  is411Setup])
            {
                [self.arrInputs addObjectsFromArray:mHubManagerInstance.arrayAVR];
                
            }
           NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            if([mHubManagerInstance.objSelectedHub  isZPSetup]){
                OutputDevice *objOutput;
                for (int i = 0; i < mHubManagerInstance.objSelectedZone.arrOutputs.count; i++) {
                    mHubManager *extractedExpr = mHubManagerInstance;
                    objOutput = [extractedExpr.objSelectedZone.arrOutputs objectAtIndex:i];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UnitId = %@", objOutput.UnitId];
                    NSArray *arrZoneFilteredInputs = [self.arrInputs filteredArrayUsingPredicate:predicate];
                    NSLog(@"inputs filter ed %lu  %lu",(unsigned long)self.arrInputs.count,(unsigned long)arrZoneFilteredInputs.count);
                    [tempArr addObjectsFromArray:arrZoneFilteredInputs];
                }
                self.arrInputs = [tempArr mutableCopy];
            }
            BOOL isContainVideoOutput = false;
            OutputDevice *obj;
            NSInteger cecIndexNo = 0;
            for (int i = 0; i < mHubManagerInstance.objSelectedZone.arrOutputs.count; i++) {
                mHubManager *extractedExpr = mHubManagerInstance;
                obj = [extractedExpr.objSelectedZone.arrOutputs objectAtIndex:i];
                if([mHubManagerInstance.objSelectedHub  isPro2Setup])
                {
                    if([obj.outputType_VideoOrAudio containsString:@"video"] ){
                        isContainVideoOutput = true;
                        cecIndexNo = obj.Index;
                        if(obj.isIRPack){
                            [self.arrInputs addObject:obj];
                            [self.local_arrayOutputs addObject:obj];
                        }
                    }
                }else
                {
                    if([obj.outputType_VideoOrAudio containsString:@"video"] || [obj.UnitId containsString:@"M1"] ){
                        isContainVideoOutput = true;
                        cecIndexNo = obj.Index;
                        if(obj.isIRPack){
                            [self.arrInputs addObject:obj];
                            [self.local_arrayOutputs addObject:obj];
                        }
                    }
                }
            }
            if([mHubManagerInstance.objSelectedHub  is411Setup])
            {
                [self.arrInputs addObjectsFromArray:mHubManagerInstance.arrayOutPut];
                [self.local_arrayOutputs addObjectsFromArray:mHubManagerInstance.arrayOutPut];
            }
            for (int i = 0; i < mHubManagerInstance.objSelectedHub.HubOutputData.count; i++) {
                mHubManager *extractedExpr = mHubManagerInstance;
                OutputDevice *objCEC = [extractedExpr.objSelectedHub.HubOutputData objectAtIndex:i];
                if([objCEC.CreatedName containsString:@"CEC"] && [[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecView"])
                {
                    objCEC.PortNo = cecIndexNo;
                    [self.arrInputs addObject:objCEC];
                }
            }
            
            if (!isContainVideoOutput && ![mHubManagerInstance.objSelectedHub isDemoMode]) {
                self.arrInputs = [[NSMutableArray alloc] init];
                self.collectionInputDevice.hidden = true;
                mHubManagerInstance.objSelectedInputDevice = nil;
                [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                [ContinuityCommand saveCustomObject:@[] key:kSELECTEDCONTINUITYARRAY];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadInputOutputContainer object:self];
                return;
            }
            //Below line of code is written to bring the video display and AVR to the First appear.
            //self.arrInputs = [[[self.arrInputs reverseObjectEnumerator] allObjects] mutableCopy];
            self.collectionInputDevice.hidden = false;
            
            if([mHubManagerInstance.objSelectedHub isDemoMode])
            {
                [self.arrInputs addObject:mHubManagerInstance.objSelectedOutputDevice];
            }else{
            NSMutableArray *arrObj = [[NSMutableArray alloc]initWithArray:self.arrInputs];
            for (int i = 0 ; i < [self.arrInputs count]; i++) {
                if([[self.arrInputs objectAtIndex:i] isKindOfClass:[InputDevice class]]){
                    InputDevice *objInput = [self.arrInputs objectAtIndex:i];
                    if (!objInput.isDeleted) {
                        [arrObj removeObject:objInput];
                    }
                }
            }
            _arrInputs = arrObj;
            }
            if(self.arrInputs.count == 0 && isContainVideoOutput)
            {
                [self showAllInputsHiddenAlert];
                mHubManagerInstance.objSelectedInputDevice = nil;// This will remove existing IR pack UI from the view.
               // [APIManager reloadSourceSubView];
            }
            
            //Below line of code is written to bring the video display and AVR to the First appear.
            self.arrInputs = [[[self.arrInputs reverseObjectEnumerator] allObjects] mutableCopy];
            [self.collectionInputDevice reloadData];
            //mHubManagerInstance.arrSourceDeviceManaged = duplicateArray;
        }
        if (mHubManagerInstance.controlDeviceTypeSource == AVRSource) {
            AVRDevice *selectedAVRDevice = mHubManagerInstance.objSelectedAVRDevice;
            if (selectedAVRDevice != nil) {
                for (int counter = 0; counter <
                     
                     self.arrInputs.count; counter++) {
                    if ([[self.arrInputs objectAtIndex:counter] isKindOfClass:[AVRDevice class]]) {
                        AVRDevice *objAVR = [self.arrInputs objectAtIndex:counter];
                        if (objAVR.Index == selectedAVRDevice.Index) {
                            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:counter inSection:0];
                            [self.collectionInputDevice scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                            break;
                        }
                    }
                }
            }
        }
        else  if (mHubManagerInstance.controlDeviceTypeSource == OutputScreen) {
            OutputDevice *selectedOutputDevice = mHubManagerInstance.objSelectedOutputDevice;
            if (selectedOutputDevice != nil) {
                for (int counter = 0; counter < self.arrInputs.count; counter++) {
                    if ([[self.arrInputs objectAtIndex:counter] isKindOfClass:[OutputDevice class]]) {
                        OutputDevice *objop = [self.arrInputs objectAtIndex:counter];
                        if (objop.Index == selectedOutputDevice.Index) {
                            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:counter inSection:0];
                            [self.collectionInputDevice scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                            break;
                        }
                    }
                }
            }
        }
        else {
            bool isFlag = false;
            InputDevice *selectedInputDevice = mHubManagerInstance.objSelectedInputDevice;
            if (selectedInputDevice != nil) {
                for (int counter = 0; counter < self.arrInputs.count; counter++) {
                    if ([[self.arrInputs objectAtIndex:counter] isKindOfClass:[InputDevice class]]) {
                        InputDevice *objIP = [self.arrInputs objectAtIndex:counter];
                        if (objIP.Index == selectedInputDevice.Index) {
                            isFlag = true;
                            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:counter inSection:0];
                            [self.collectionInputDevice scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                            break;
                        }
                    }
                }
            }
            else
            {
                InputDevice *objIP = [self.arrInputs objectAtIndex:0];
                mHubManagerInstance.objSelectedInputDevice =  objIP;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                [self.collectionInputDevice scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)showAllInputsHiddenAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(HUB_REMOVEUCONTROL_CONFIRMATION, nil)
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = colorGray_646464;
    NSMutableAttributedString *strAttributedTitle = [[NSMutableAttributedString alloc] initWithString:ALERTMESSAGE_INPUTSHIDDEN];
    [strAttributedTitle addAttribute:NSFontAttributeName
                               value:textFontLight13
                               range:NSMakeRange(0, strAttributedTitle.length)];
    [alertController setValue:strAttributedTitle forKey:@"attributedTitle"];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ALERT_BTN_TITLE_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            
        });
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.arrInputs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        // we're going to use a custom UICollectionViewCell, which will hold an image and its label
        CellInput *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellInput" forIndexPath:indexPath];
        
        if ([AppDelegate appDelegate].deviceType == mobileSmall || [AppDelegate appDelegate].deviceType == mobileLarge) {
            [cell.lblInputName setFont:textFontRegular10];
        } else {
            [cell.lblInputName setFont:textFontRegular13];
        }
        
        NSString *strInputTitle = @"";
        //NSLog(@"self.arrInputs %@",self.arrInputs);
        if(self.arrInputs.count > 0){
            if ([self.arrInputs[indexPath.row] isKindOfClass:[InputDevice class]]) {
                cell.sourceDisplayTop_position.constant = 0;
                [cell.view_sourceCountBG setHidden:true];
                [cell.lbl_sourceCount setHidden:true];
                InputDevice *objInput = [self.arrInputs objectAtIndex:indexPath.row];
                strInputTitle = [objInput.CreatedName uppercaseString];
                // In case of ZP stack setup. Due to IR Pairing we need to check condition with PORT No NOT with Index of inputs, that why I have added below condition, so that in case of only ZP stack, it'll check by portno else will check for index no.
//                if([mHubManagerInstance.objSelectedHub  isZPSetup] && [mHubManagerInstance.objSelectedHub isPairedSetup] ){
//                    if (mHubManagerInstance.controlDeviceTypeSource == InputSource && objInput.PortNo == mHubManagerInstance.objSelectedInputDevice.PortNo) {
//                        [cell.lblInputName setTextColor:[AppDelegate appDelegate].themeColours.colorInputSelectedText];
//                        cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorInputSelectedBackground;
//                    } else {
//                        [cell.lblInputName setTextColor:[AppDelegate appDelegate].themeColours.colorInputText];
//                        cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorInputBackground;
//                    }
//                }
//                else
//                {
                    if (mHubManagerInstance.controlDeviceTypeSource == InputSource && objInput.Index == mHubManagerInstance.objSelectedInputDevice.Index) {
                        [cell.lblInputName setTextColor:[AppDelegate appDelegate].themeColours.colorInputSelectedText];
                        cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorInputSelectedBackground;
                    } else {
                        [cell.lblInputName setTextColor:[AppDelegate appDelegate].themeColours.colorInputText];
                        cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorInputBackground;
                    }
                //}
                
                [cell.lblInputName setHidden:NO];
                [cell.img_sourceIcon setHidden:YES];
            }
            
            else if ([self.arrInputs[indexPath.row] isKindOfClass:[OutputDevice class]]) {
                OutputDevice *objOutput = [self.arrInputs objectAtIndex:indexPath.row];
                cell.sourceDisplayTop_position.constant = -3;
                if (mHubManagerInstance.controlDeviceTypeSource == OutputScreen && objOutput.Index == mHubManagerInstance.objSelectedOutputDevice.Index) {
                    [cell.lblInputName setTextColor:[AppDelegate appDelegate].themeColours.colorInputSelectedText];
                    cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorInputSelectedBackground;
                    
                } else {
                    [cell.lblInputName setTextColor:[AppDelegate appDelegate].themeColours.colorInputText];
                    cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorInputBackground;
                }
                [cell.lblInputName setHidden:YES];
                [cell.img_sourceIcon setHidden:NO];
                if([objOutput.Name containsString:@"CEC"]){
                    [cell.img_sourceIcon setImage:kImageCECIcon];
                    [cell.view_sourceCountBG setHidden:true];
                    [cell.lbl_sourceCount setHidden:true];
                }
                else
                {
                    [cell.img_sourceIcon setImage:kImageIconTVDisplay];
                    if(self.local_arrayOutputs.count > 1 && ([mHubManagerInstance.objSelectedHub  isZPSetup] || [mHubManagerInstance.objSelectedHub  is411Setup]))
                    {
                        NSString *countstr;
                        if([[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecView"])
                        {
                            countstr = [NSString stringWithFormat:@"%lu",(unsigned long)indexPath.row];
                        }
                        else
                        {
                            countstr = [NSString stringWithFormat:@"%lu",(unsigned long)indexPath.row+1];
                        }
                        
                        [cell.view_sourceCountBG setHidden:false];
                        [cell.lbl_sourceCount setHidden:false];
                        [cell.lbl_sourceCount setText:countstr];
                        cell.view_sourceCountBG.layer.cornerRadius = 10;
                        cell.view_sourceCountBG.layer.masksToBounds = true;
                    }
                    else
                    {
                        [cell.view_sourceCountBG setHidden:true];
                        [cell.lbl_sourceCount setHidden:true];
                    }
                    
                    
                }
                
            }
            else {
                cell.sourceDisplayTop_position.constant = 0;
                if(mHubManagerInstance.arrayAVR.count > 1)
                {
                    NSString *countstr = [NSString stringWithFormat:@"%lu",(unsigned long)mHubManagerInstance.arrayAVR.count];
                    [cell.view_sourceCountBG setHidden:false];
                    [cell.lbl_sourceCount setHidden:false];
                    [cell.lbl_sourceCount setText:countstr];
                    cell.view_sourceCountBG.layer.cornerRadius = 10;
                    cell.view_sourceCountBG.layer.masksToBounds = true;
                }
                else
                {
                    [cell.view_sourceCountBG setHidden:true];
                    [cell.lbl_sourceCount setHidden:true];
                }
                AVRDevice *objAVR = [self.arrInputs objectAtIndex:indexPath.row];
                strInputTitle = [objAVR.CreatedName uppercaseString];
                if (mHubManagerInstance.controlDeviceTypeSource == AVRSource && objAVR.Index == mHubManagerInstance.objSelectedAVRDevice.Index) {
                    [cell.lblInputName setTextColor:[AppDelegate appDelegate].themeColours.colorInputSelectedText];
                    cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorInputSelectedBackground;
                    [cell.lblInputName setHidden:YES];
                    [cell.img_sourceIcon setHidden:NO];
                } else {
                    [cell.lblInputName setTextColor:[AppDelegate appDelegate].themeColours.colorInputText];
                    cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorInputBackground;
                }
                [cell.lblInputName setHidden:YES];
                [cell.img_sourceIcon setHidden:NO];
                [cell.img_sourceIcon setImage:kImageIconTVAVR];
                
            }
            cell.lblInputName.text = strInputTitle;
        }
        return cell;
    }
    @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if ([self.arrInputs[indexPath.row] isKindOfClass:[InputDevice class]]) {
            InputDevice *objInput = [self.arrInputs objectAtIndex:indexPath.row];
            if([mHubManagerInstance.objSelectedHub  isZPSetup] && ![mHubManagerInstance.objSelectedHub isPairedSetup] ){
                // if (![mHubManagerInstance.objSelectedHub isZPSetup] ) {
                mHubManagerInstance.controlDeviceTypeSource = InputSource;
                mHubManagerInstance.objSelectedInputDevice = objInput;
                [APIManager reloadSourceSubView];
                [self.collectionInputDevice scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
            else{
                if (mHubManagerInstance.objSelectedOutputDevice.Index == 0) {
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:HUB_SELECTEDDEVICE];
                } else {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CEC_COMMAND"];
                    
                    mHubManagerInstance.controlDeviceTypeSource = InputSource;
                    mHubManagerInstance.objSelectedInputDevice = objInput;
                    if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                        [APIManager switchInZoneOutputToInput:mHubManagerInstance.objSelectedHub Zone:mHubManagerInstance.objSelectedZone InputDevice:objInput completion:^(APIV2Response *responseObject) {
                            mHubManagerInstance.controlDeviceTypeSource = InputSource;
                            if ([mHubManagerInstance.objSelectedHub is411Setup] ) {
                                mHubManagerInstance.objSelectedInputDevice = objInput;
                            }
                            
                            // mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
                            //                            if([self isAUtoEnabledORNot]  && mHubManagerInstance.objSelectedZone.OutputTypeInSelectedZone == audioVideoZone)
                            //                            {
                            //                                mHubManagerInstance.objSelectedZone.audio_input = 0;
                            //                            }
                            [APIManager reloadSourceSubView];
                            [self.collectionInputDevice scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                            
                            //                        if (responseObject.error) {
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                if ([responseObject.error_description isEqualToString:HUB_APPUPDATE_MESSAGE]) {
                            //                                    [[AppDelegate appDelegate] methodToCheckUpdatedVersionOnAppStore];
                            //                                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
                            //                                } else {
                            //                                    if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
                            //                                        [[SearchDataManager sharedInstance] startSearchNetwork];
                            //                                        [SearchDataManager sharedInstance].delegate = self;
                            //                                    }
                            //                                }
                            //                            });
                            //                        } else {
                            //                            mHubManagerInstance.controlDeviceTypeSource = InputSource;
                            //                            // mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
                            //                            [APIManager reloadSourceSubView];
                            //                            [self.collectionInputDevice scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                            //                        }
                            //
                        }];
                    } else {
                        [APIManager putSwitchIn_OutputIndex:mHubManagerInstance.objSelectedOutputDevice.Index InputIndex:objInput.Index completion:^(APIResponse *responseObject) {
                            mHubManagerInstance.controlDeviceTypeSource = InputSource;
                            // mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
                            [APIManager reloadSourceSubView];
                            [self.collectionInputDevice scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                        }];
                    }
                }
            }
        }
        else   if ([self.arrInputs[indexPath.row] isKindOfClass:[OutputDevice class]]) {
            if ([mHubManagerInstance.objSelectedHub isZPSetup]) {
                OutputDevice *objop = [self.arrInputs objectAtIndex:indexPath.row];
                //NSLog(@"cellForRow 1 %@",objop.outputType);
                mHubManagerInstance.objSelectedOutputDevice = objop;
                mHubManagerInstance.controlDeviceTypeSource = OutputScreen;
                if(objop.objCommandType.volume.count > 0){
                    mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
                    mHubManagerInstance.objSelectedZone.bottomControlDevice = mHubManagerInstance.controlDeviceTypeBottom;
                }
                [APIManager reloadSourceSubView];
                [self.collectionInputDevice scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
            else{
                
                OutputDevice *objop = [self.arrInputs objectAtIndex:indexPath.row];
                //NSLog(@"cellForRow 2 %@",objop.outputType);
                mHubManagerInstance.objSelectedOutputDevice = objop;
                mHubManagerInstance.controlDeviceTypeSource = OutputScreen;
                if([objop.CreatedName containsString:@"CEC"]){
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CEC_COMMAND"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CEC_COMMAND"];
                }
                if([objop.CreatedName containsString:@"CEC"] && ![[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecUI"])
                {
                    
                }
                else{
                    [APIManager reloadSourceSubView];
                    [self.collectionInputDevice scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                    
                }
            }
        }
        else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CEC_COMMAND"];
            AVRDevice *objAVR = [self.arrInputs objectAtIndex:indexPath.row];
            mHubManagerInstance.objSelectedAVRDevice = objAVR;
            mHubManagerInstance.controlDeviceTypeSource = AVRSource;
            // mHubManagerInstance.controlDeviceTypeBottom = AVRSource;
            [APIManager reloadSourceSubView];
        }
    }
    @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        CGSize size = CGSizeMake(SCREEN_WIDTH/4, self.collectionInputDevice.frame.size.height);
        // DDLogDebug(@"Landscape size %@", NSStringFromCGSize(size));
        return size;
    }
    else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
        CGSize size = CGSizeMake(SCREEN_WIDTH/4.8, self.collectionInputDevice.frame.size.height);
        // DDLogDebug(@"Landscape size %@", NSStringFromCGSize(size));
        return size;
    }
    
    else {
        if ([AppDelegate appDelegate].deviceType == tabletLarge) {
            CGSize size = CGSizeMake(SCREEN_WIDTH/4, self.collectionInputDevice.frame.size.height);
            // DDLogDebug(@"Landscape size %@", NSStringFromCGSize(size));
            return size;
            
        } else {
            CGSize size = CGSizeMake(SCREEN_WIDTH/4, self.collectionInputDevice.frame.size.height);
            // DDLogDebug(@"Landscape size %@", NSStringFromCGSize(size));
            return size;
        }
    }
}

#pragma mark - Zone is auto mode enabled or not

-(BOOL)isAUtoEnabledORNot
{
    @try {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MappingKeyData"] isKindOfClass:NSArray.class]){
            NSArray *array_mappingData = [[NSUserDefaults standardUserDefaults]valueForKey:@"MappingKeyData" ];
            for(int i =0 ;i < array_mappingData.count;i++)
            {
                NSDictionary *dataDictionary = [array_mappingData objectAtIndex:i];
                if ([dataDictionary isKindOfClass:[NSDictionary class]]) {
                    NSString *modeObj = [Utility checkNullForKey:kMODE Dictionary:dataDictionary];
                    NSString *zoneID = [Utility checkNullForKey:kZONE_ID Dictionary:dataDictionary];
                    Zone *zoneObj = [Zone getFilteredZoneData:zoneID ZoneData:mHubManagerInstance.objSelectedHub.HubZoneData];
                    if([zoneID isEqualToString:mHubManagerInstance.objSelectedZone.zone_id])
                    {
                        if([modeObj isEqualToString:kAUTO])
                        {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - SearchData Delegate
-(void) searchData:(SearchData *)searchData didFindDataArray:(NSMutableArray *)arrSearchedData {
    @try {
        BOOL isDataFound = false;
        for (SearchData *objData in arrSearchedData) {
            for (Hub *objHub in objData.arrItems) {
                if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3 && objHub.Generation == mHub4KV3) {
                    mHubManagerInstance.objSelectedHub = [Hub updateHubAddress_From:objHub To:mHubManagerInstance.objSelectedHub];
                    isDataFound = false;
                    break;
                } else {
                    if ([objHub.SerialNo isEqualToString:mHubManagerInstance.objSelectedHub.SerialNo]) {
                        mHubManagerInstance.objSelectedHub = [Hub updateHubAddress_From:objHub To:mHubManagerInstance.objSelectedHub];
                        isDataFound = false;
                        break;
                    }
                }
            }
        }
        
        if (isDataFound) {
            [self dataFoundViewReload];
        } else {
            [self errorMessageOverlayNavigation];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) dataFoundViewReload {
    @try {
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            [mHubManagerInstance syncGlobalManagerObjectV0];
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
        } else {
            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) errorMessageOverlayNavigation {
    @try {
        ErrorMessageOverlayVC *objVC = [mainStoryboard   instantiateViewControllerWithIdentifier:@"ErrorMessageOverlayVC"];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.isFirstAppORMosUpdateAlertPage = NO;
        
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self presentViewController:objVC animated:YES completion:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}




@end
