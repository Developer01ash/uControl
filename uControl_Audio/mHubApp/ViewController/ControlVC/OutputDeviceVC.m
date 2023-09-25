//
//  OutputDeviceVC.m
//  mHubApp
//
//  Created by Anshul Jain on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
 VC to show Leftpanel data i.e. List of Output/Zone and Sequence when ControlVC load as main screen. In this file we can rearrange Output/Zone and Sequence by long press and move and we can also delete or remove Output/Zone and Sequence temporarily.
 */

#import "OutputDeviceVC.h"
#import "CellOutput.h"
#import "CellFooter.h"
#import "UIViewController+LGSideMenuController.h"
#import "Utility.h"
#import "SettingsVC.h"
#import "ZoneMenuCollectionReusableView.h"
#import "NewZoneView.h"


#define kPortraitContraintConstantiPhone4 10
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@interface OutputDeviceVC ()<CellOutputDelegate>
@property (strong, nonatomic) NSMutableArray *arrTableData;
@property (strong, nonatomic) NSMutableArray *arrSequenceData;
@property (strong, nonatomic) NSMutableArray *arrSequences_filterByZoneId;
@property (strong, nonatomic) NSMutableArray *arrAllControlsData;
@property (strong, nonatomic) NSMutableArray *arrControls_filterByZoneId;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation OutputDeviceVC {
//    __weak UIView *_staticView;
    NSTimer *seqTimer;
    CGFloat secondsTimer;
    NSIndexPath *seqenceIndexP;
    double touchnHoldSequenceTime;
    NSTimer *timerObj;
    UILongPressGestureRecognizer *longPress;
    double touchnHoldControlsTime;
    NSTimer *timerObj_zoneControls;
    UILongPressGestureRecognizer *longPressControls;

}

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.navigationItem.backBarButtonItem = customBackBarButton;
        self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
        // Do any additional setup after loading the view.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadOutput object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationReloadOutput
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotificationZoneMenuHide:)
                                                     name:kNotificationHideZoneMenu
                                                   object:nil];


        //UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressRecognizerHandler_ReorderTableview:)];
        
       // [self.tableView addGestureRecognizer:longPress];
        longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(longPressRecognizerHandler_ReorderCollectionView:)];
        longPress.enabled = true;
        [self.collectionOutputDev addGestureRecognizer:longPress];
        [self.collectionSequence addGestureRecognizer:longPress];
        
        longPressControls = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(longPressRecognizerHandler_collectionZoneControls:)];
        [self.collectionZoneControls addGestureRecognizer:longPressControls];
       // [self.collectionOutputDev registerClass:NSStringFromClass([ZoneMenuCollectionReusableView class]) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZoneMenuCollectionReusableView"];
        
        //[self.collectionOutputDev registerClass:[ZoneMenuCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZoneMenuCollectionReusableView"];
         
        

        self.isEdit = false;
        [self.btnEditDone setHidden:true];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }

}


-(void)viewWillAppear:(BOOL)animated {
    @try {

        [super viewWillAppear:animated];
        [self removeTopView];
        //Below code is to change the orientation of down arrow image on zone name. By default it should be up as list is closed.
//        UIImage* sourceImage = self.downArrow_zoneName.image;
//        [self.collectionOutputDev setHidden:true];
//        self.downArrow_zoneName.image = [UIImage imageWithCGImage:sourceImage.CGImage
//                                                        scale:sourceImage.scale
//                                                  orientation:UIImageOrientationDown];
       
        ThemeColor *objTheme = [AppDelegate appDelegate].themeColours;

        [self.tableView setBackgroundColor:objTheme.colorOutputBackground];
        [self.collectionOutputDev setBackgroundColor:objTheme.colorOutputBackground];
       // [self.btnSettings setBackgroundColor:objTheme.colorOutputBackground];
        [self.btnSettings.imageView setTintColor:objTheme.colorOutputText];
        UIImage *image = [kImageIconSettings imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        [self.btnSettings.imageView setImage:image];
        //[self.btnSettings addBorder_Color:objTheme.colorSettingControlBorder BorderWidth:1.0];
        
        UIImage *imageDownArrow = [kImageIconDownArrow imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        [self.downArrowImage setTintColor:objTheme.colorDownArrow];
        [self.downArrowImage setImage:imageDownArrow];

        //    UIImage * landscapeImage = kImageHDALogo;
        //    UIImage * portraitImage = [[UIImage alloc] initWithCGImage: landscapeImage.CGImage
        //                                                         scale: 1.0
        //                                                   orientation: UIImageOrientationLeft];
        //    [self.imgHeader setImage:portraitImage];

        [self outputDataRearrangement];
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) outputDataRearrangement {
    @try {

        self.arrTableData = [[NSMutableArray alloc] initWithArray:mHubManagerInstance.arrLeftPanelRearranged];
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        // To Remove the duplicate data.
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:self.arrTableData];
        self.arrTableData = [orderedSet array].mutableCopy;
        self.arrSequenceData = [[NSMutableArray alloc]init];
        self.arrSequences_filterByZoneId = [[NSMutableArray alloc]init];
        self.arrControls_filterByZoneId = [[NSMutableArray alloc]init];
        for(int i = 0 ; i < self.arrTableData.count;i++)
        {
            if ([self.arrTableData[i] isKindOfClass:[Sequence class]])
            {
                Sequence *obj = self.arrTableData[i];
                [self.arrSequenceData addObject:obj];
                [self.arrSequences_filterByZoneId addObject:obj];//temporary
                
            }
            else if ([self.arrTableData[i] isKindOfClass:[Controls class]])
            {
                Controls *obj = self.arrTableData[i];
                [self.arrControls_filterByZoneId addObject:obj];//temporary
            }
            else
            {
               
                [tempArray addObject:self.arrTableData[i]];
            }
        }
        self.arrTableData =  tempArray;
        //If there is no sequences then no need to show anything.
        if(![self.arrSequenceData isNotEmpty]){
            [self.collectionSequence setHidden:true];
            self.layoutCons_sequencesHeight.constant = 0;
        }else{
            [self filterSequencesByZoneId];//THis method will filter the sequences according to zone ids.
            [self.collectionSequence setHidden:false];
            //self.layoutCons_sequencesHeight.constant = self.view.frame.size.height/4;
            self.layoutCons_sequencesHeight.constant = (self.arrSequences_filterByZoneId.count * 50) + 60;
        }
        //If there is no controls then no need to show anything.
        if(![self.arrControls_filterByZoneId isNotEmpty]){
            [self.collectionZoneControls setHidden:true];
        }else{
            [self.collectionZoneControls setHidden:false];
        }
        [self.tableView reloadData];
        [self.collectionOutputDev reloadData];
        [self.collectionSequence reloadData];
        [self.collectionZoneControls reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)filterSequencesByZoneId{
    @try {
        self.arrSequences_filterByZoneId = [[NSMutableArray alloc]init];
        for(int i = 0 ; i < self.arrSequenceData.count;i++){
                Sequence *obj = self.arrSequenceData[i];
                if ([obj.arrZoneIds containsObject:mHubManagerInstance.objSelectedZone.zone_id]) {
                    [self.arrSequences_filterByZoneId addObject:obj];
                }
        }
        self.layoutCons_sequencesHeight.constant = (self.arrSequences_filterByZoneId.count * 50) + 60;
        [self.collectionSequence reloadData];
        
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}


- (void)viewWillLayoutSubviews {
    @try {
        [super viewWillLayoutSubviews];
        [self.collectionOutputDev setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.collectionOutputDev setContentSize:CGSizeMake(self.collectionOutputDev.contentSize.width, self.view.frame.size.height)];
        [self.collectionOutputDev reloadData];
        [self.collectionSequence setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.collectionSequence setContentSize:CGSizeMake(self.collectionSequence.contentSize.width, self.view.frame.size.height)];
        [self.collectionSequence reloadData];
        NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        //NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString * versionBuildString = [NSString stringWithFormat:@"v.%@", appVersionString];
        [self.lbl_version setText:versionBuildString];
        [self.lbl_connectedHub_ProfileName setText:mHubManagerInstance.objSelectedHub.modelName];
        if ([AppDelegate appDelegate].deviceType == tabletLarge) {
            [[AppDelegate appDelegate] setShouldRotate:YES];
        }
        [self.zoneNameBtn setTitleColor:colorWhite forState:UIControlStateNormal];
        [self.zoneNameBtn setTitleColor:colorWhite forState:UIControlStateSelected];
        [self.zoneNameBtn setBackgroundColor:colorClear];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            self.constraintSettingButtonHeightConstant.constant = heightFooterView_SmallMobile;
            [self.lbl_connectedHub_ProfileName setFont:textFontBold12];
            [self.lbl_version setFont:textFontBold10];
            [self.zoneNameBtn.titleLabel setFont:textFontBold12];
            [self.lbl_zoneTitle setFont:textFontRegular12];
        }
        else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
            self.constraintSettingButtonHeightConstant.constant = heightFooterView_SmallMobile;
            [self.lbl_connectedHub_ProfileName setFont:textFontBold14];
            [self.lbl_version setFont:textFontBold10];
            [self.zoneNameBtn.titleLabel setFont:textFontBold14];
            [self.lbl_zoneTitle setFont:textFontRegular16];
        }
        else {
            [self.lbl_connectedHub_ProfileName setFont:textFontBold16];
            [self.lbl_version setFont:textFontBold13];
            [self.zoneNameBtn.titleLabel setFont:textFontBold16];
            self.constraintSettingButtonHeightConstant.constant = heightFooterView;
            [self.lbl_zoneTitle setFont:textFontRegular18];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) receiveNotificationZoneMenuHide:(NSNotification *) notification {
    @try {
       // DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
        self.zoneNameBtn.selected = !self.zoneNameBtn.selected;
        [self.collectionOutputDev setHidden:true];
        UIImage* sourceImage = self.downArrow_zoneName.image;
        self.downArrow_zoneName.image = [UIImage imageWithCGImage:sourceImage.CGImage
                                                    scale:sourceImage.scale
                                              orientation:UIImageOrientationUp];
        longPress.enabled = true;
        touchnHoldSequenceTime = 0;
        CellOutputCollectionViewCell *cell = (CellOutputCollectionViewCell *)[self.collectionSequence cellForItemAtIndexPath:self->seqenceIndexP];
        [cell.sequenceProgress_byTime setProgress:0.0];
        [timerObj invalidate];
        timerObj = nil;
        [cell.seqTimer invalidate];
        cell.seqTimer = nil;
        touchnHoldControlsTime = 0;
        longPressControls.enabled = true;
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) receiveNotification:(NSNotification *) notification {
    @try {
       // DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
        [self viewWillAppear:false];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnSettings_Clicked:(UIButton *)sender {
    @try {
        SettingsVC *objSettings = [settingsStoryboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
        [(UINavigationController *)[self sideMenuController].rootViewController pushViewController:objSettings animated:YES];
        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(IBAction)ClickOn_DownstairsVideo:(id)sender{
    @try {
    ListOfProfileDevicesVC *objVC = [settingsStoryboard   instantiateViewControllerWithIdentifier:@"ListOfProfileDevicesVC"];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:objVC animated:YES completion:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(IBAction)ClickOn_Zones:(UIButton *)sender{
    @try {
        sender.selected = !sender.selected;
        UIImage* sourceImage = self.downArrow_zoneName.image;
        if(sender.selected){
            //Below code is to change the orientation of down arrow image on zone name. By default it should be up as list is closed.
            self.downArrow_zoneName.image = [UIImage imageWithCGImage:sourceImage.CGImage
                                                            scale:sourceImage.scale
                                                      orientation:UIImageOrientationDown];
        [self.collectionOutputDev setHidden:false];
        }
        else{
            [self.collectionOutputDev setHidden:true];
            self.downArrow_zoneName.image = [UIImage imageWithCGImage:sourceImage.CGImage
                                                        scale:sourceImage.scale
                                                  orientation:UIImageOrientationUp];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)dismissCancel_ZoneWindow:(UIButton *)sender {
    @try {
        [self.collectionOutputDev setHidden:true];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnEditDone_Clicked:(UIButton *)sender {
    @try {
        [self longPressViewHandler_HeaderView:sender];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void)updateTimer_zoneControl:(NSTimer *)timer
{
    @try {
        touchnHoldControlsTime = touchnHoldControlsTime + 1;
        UILongPressGestureRecognizer *longPress = [timer userInfo];
        if(touchnHoldControlsTime > 2)
        {
            [timerObj_zoneControls invalidate];
            timerObj_zoneControls = nil;
            if(longPressControls.isEnabled){
                longPressControls.enabled = false;
            }
            CGPoint location = [longPress locationInView:self.collectionZoneControls];
            NSIndexPath *indexPath = [self.collectionZoneControls indexPathForItemAtPoint:location];
            Controls *controlObj = self.arrControls_filterByZoneId[indexPath.row];
                [APIManager executeFunction:mHubManagerInstance.objSelectedHub.Address functionId:controlObj.control_id isFlag:false completion:^(APIV2Response *responseObject) {
                    if (!responseObject.error) {
                        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                    }
                }];
           
            
        }
    
} @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}
- (void)longPressRecognizerHandler_collectionZoneControls:(id)sender {
    @try {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
        UIGestureRecognizerState state = longPress.state;
        switch (state) {
            case UIGestureRecognizerStateBegan: {
                touchnHoldControlsTime = 0;
                timerObj_zoneControls = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer_zoneControl:) userInfo:longPress repeats:YES];
                break;
            }
                
            case UIGestureRecognizerStateEnded: {
                [timerObj_zoneControls invalidate];
                timerObj_zoneControls = nil;
    CGPoint location = [longPress locationInView:self.collectionZoneControls];
    NSIndexPath *indexPath = [self.collectionZoneControls indexPathForItemAtPoint:location];
    Controls *controlObj = self.arrControls_filterByZoneId[indexPath.row];
        [APIManager executeFunction:mHubManagerInstance.objSelectedHub.Address functionId:controlObj.control_id isFlag:false completion:^(APIV2Response *responseObject) {
            if (!responseObject.error) {
                [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
            }
        }];
                break;
            }
            default: {
                
                break;
            }
        
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void)updateTimer:(NSTimer *)timer
{
    @try {
        touchnHoldSequenceTime = touchnHoldSequenceTime + 1;
        if(touchnHoldSequenceTime > 2)
        {
            [timerObj invalidate];
            timerObj = nil;
            if(longPress.isEnabled){
            longPress.enabled = false;
            }
            Sequence *obj = self.arrSequences_filterByZoneId[self->seqenceIndexP.row];
            if(obj.isFunction)//If the function is true, means its a super sequence and in case of super sequence Bool will be append at end of url
            {
            
            if(obj.eTime_forSeqences > 0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                [self setTopView];
                        self->secondsTimer = 0.0;
                        counter = 0;
                CellOutputCollectionViewCell *cell = (CellOutputCollectionViewCell *)[self.collectionSequence cellForItemAtIndexPath:self->seqenceIndexP];
                CGFloat tempObj = obj.eTime_forSeqences/1000 ;// Convert in mili secon
                CGFloat tempObj2 = tempObj/100 ;// to loop it 100 times from total time.
                cell.seqTimer = [NSTimer scheduledTimerWithTimeInterval:tempObj2 target:self selector:@selector(updateSequenceProgressByColor:) userInfo:obj repeats:YES];
                        //self->seqenceIndexP = indexPath;
                    });
            }
            
                [APIManager executeSuperSequence:mHubManagerInstance.objSelectedHub.Address SequenceId:obj.macro_id isSuperSeq:false completion:^(APIV2Response *responseObject) {
                    if (!responseObject.error) {
                       // [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                    }
                }];
            }
        }
    
} @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}
- (void)longPressRecognizerHandler_ReorderCollectionView:(id)sender {
    @try {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
        UIGestureRecognizerState state = longPress.state;
        CGPoint location = [longPress locationInView:self.collectionSequence];
        NSIndexPath *indexPath = [self.collectionSequence indexPathForItemAtPoint:location];
        self->seqenceIndexP = indexPath;
        switch (state) {
            case UIGestureRecognizerStateBegan: {
                touchnHoldSequenceTime = 0;
                timerObj = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
                break;
            }
                
            case UIGestureRecognizerStateEnded: {
                [timerObj invalidate];
                timerObj = nil;
                
                Sequence *obj = self.arrSequences_filterByZoneId[indexPath.row];
                if(obj.isFunction)//If the function is true, means its a super sequence and in case of super sequence Bool will be append at end of url
                {
                
                if(obj.eTime_forSeqences > 0){
                       // dispatch_async(dispatch_get_main_queue(), ^{
                    [self setTopView];
                           secondsTimer = 0.0;
                            counter = 0;
                            CellOutputCollectionViewCell *cell = (CellOutputCollectionViewCell *)[self.collectionSequence cellForItemAtIndexPath:indexPath];
                    CGFloat tempObj = obj.eTime_forSeqences/1000 ;// Convert in mili secon
                    CGFloat tempObj2 = tempObj/100 ;// to loop it 100 times from total time.
                            cell.seqTimer = [NSTimer scheduledTimerWithTimeInterval:tempObj2 target:self selector:@selector(updateSequenceProgressByColor:) userInfo:obj repeats:YES];
                          //  self->seqenceIndexP = indexPath;
                       // });
                }
                
                    [APIManager executeSuperSequence:mHubManagerInstance.objSelectedHub.Address SequenceId:obj.macro_id isSuperSeq:false completion:^(APIV2Response *responseObject) {
                        if (!responseObject.error) {
                           // [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                        }
                    }];
                }
                break;
            }
            default: {
                
                break;
            }
        }
    
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)longPressRecognizerHandler_ReorderCollectionView_old:(id)sender {
    @try {
        //    if (self.isEdit) {
        self.isEdit = true;
        [self.btnEditDone setHidden:false];
        [self.collectionOutputDev reloadData];
        [self.collectionSequence reloadData];

        UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
        UIGestureRecognizerState state = longPress.state;
        
        CGPoint location = [longPress locationInView:self.collectionOutputDev];
        NSIndexPath *indexPath = [self.collectionOutputDev indexPathForItemAtPoint:location];
        static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
        static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
        switch (state) {
            case UIGestureRecognizerStateBegan: {
                if (indexPath) {
                    sourceIndexPath = indexPath;
                    UICollectionViewCell *cell = [self.collectionOutputDev cellForItemAtIndexPath:indexPath];
                    // Take a snapshot of the selected row using helper method.
                    snapshot = [self customSnapshoFromView:cell];
                    // Add the snapshot as subview, centered at cell's center...
                    __block CGPoint center = cell.center;
                    snapshot.center = center;
                    snapshot.alpha = 0.0;
                    [self.collectionOutputDev addSubview:snapshot];
                    [UIView animateWithDuration:ANIMATION_DURATION_MOVE animations:^{
                        // Offset for gesture location.
                        center.y = location.y;
                        snapshot.center = center;
                        snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                        snapshot.alpha = 0.98;
                        cell.alpha = 0.0;
                        cell.hidden = YES;
                    }];
                }
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGPoint center = snapshot.center;
                center.y = location.y;
                snapshot.center = center;
                // Is destination valid and is it different from source?
                if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                    // ... update data source.
                    [self.arrTableData exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    // ... move the rows.
                    [self.collectionOutputDev moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    // ... and update source so it is in sync with UI changes.
                    sourceIndexPath = indexPath;
                    // mHubManagerInstance.arrLeftPanelRearranged = [[NSMutableArray alloc] initWithArray:self.arrTableData];
                    // [mHubManager saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                }
                break;
            }
            default: {
                // Clean up.
                UICollectionViewCell *cell = [self.collectionOutputDev cellForItemAtIndexPath:sourceIndexPath];
                cell.alpha = 0.0;
                [UIView animateWithDuration:ANIMATION_DURATION_MOVE animations:^{
                    snapshot.center = cell.center;
                    snapshot.transform = CGAffineTransformIdentity;
                    snapshot.alpha = 0.0;
                    cell.alpha = 1.0;
                } completion:^(BOOL finished) {
                    cell.hidden = NO;
                    sourceIndexPath = nil;
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                }];
                break;
            }
        }
        //    } else {
        //        self.isEdit = true;
        //        [self.btnEditDone setHidden:false];
        //        [self.tableView reloadData];
        //    }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)longPressRecognizerHandler_ReorderTableview:(id)sender {
    @try {
        //    if (self.isEdit) {
        self.isEdit = true;
        [self.btnEditDone setHidden:false];
        [self.tableView reloadData];

        UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
        UIGestureRecognizerState state = longPress.state;
        
        CGPoint location = [longPress locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        
        static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
        static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
        
        switch (state) {
            case UIGestureRecognizerStateBegan: {
                if (indexPath) {
                    sourceIndexPath = indexPath;
                    
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    
                    // Take a snapshot of the selected row using helper method.
                    snapshot = [self customSnapshoFromView:cell];
                    
                    // Add the snapshot as subview, centered at cell's center...
                    __block CGPoint center = cell.center;
                    snapshot.center = center;
                    snapshot.alpha = 0.0;
                    [self.tableView addSubview:snapshot];
                    [UIView animateWithDuration:ANIMATION_DURATION_MOVE animations:^{
                        
                        // Offset for gesture location.
                        center.y = location.y;
                        snapshot.center = center;
                        snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                        snapshot.alpha = 0.98;
                        cell.alpha = 0.0;
                        cell.hidden = YES;
                        
                    }];
                }
                break;
            }
                
            case UIGestureRecognizerStateChanged: {
                CGPoint center = snapshot.center;
                center.y = location.y;
                snapshot.center = center;
                
                // Is destination valid and is it different from source?
                if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                    
                    // ... update data source.
                    [self.arrTableData exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    
                    // ... move the rows.
                    [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    
                    // ... and update source so it is in sync with UI changes.
                    sourceIndexPath = indexPath;
                    
                    // mHubManagerInstance.arrLeftPanelRearranged = [[NSMutableArray alloc] initWithArray:self.arrTableData];
                    // [mHubManager saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                }
                break;
            }
                
            default: {
                // Clean up.
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
                cell.alpha = 0.0;
                
                [UIView animateWithDuration:ANIMATION_DURATION_MOVE animations:^{
                    
                    snapshot.center = cell.center;
                    snapshot.transform = CGAffineTransformIdentity;
                    snapshot.alpha = 0.0;
                    cell.alpha = 1.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = NO;
                    sourceIndexPath = nil;
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                    
                }];
                
                break;
            }
        }
        //    } else {
        //        self.isEdit = true;
        //        [self.btnEditDone setHidden:false];
        //        [self.tableView reloadData];
        //    }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)longPressViewHandler_HeaderView:(id)sender {
    @try {
        self.isEdit = false;
        [self.btnEditDone setHidden:true];
        [self.tableView reloadData];
        [self.collectionOutputDev reloadData];
        [self.collectionSequence reloadData];

        mHubManagerInstance.arrLeftPanelRearranged = [[NSMutableArray alloc] initWithArray:self.arrTableData];
        [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrTableData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectZero];
    return viewHeader;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        CellOutput *cell = [tableView dequeueReusableCellWithIdentifier:@"CellOutput"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellOutput"];
        }
        ThemeColor *objTheme = [AppDelegate appDelegate].themeColours;
        cell.delegate = self;
        cell.indexPathCell = indexPath;
        cell.backgroundColor = objTheme.colorOutputBackground;
        cell.selectedBackgroundView.backgroundColor = objTheme.colorOutputSelectedBackground;
        [cell.lblName setTextColor:objTheme.colorOutputText];
        
        if ([self.arrTableData[indexPath.row] isKindOfClass:[OutputDevice class]]) {
            OutputDevice *obj = self.arrTableData[indexPath.row];
            NSString *strName = obj.CreatedName;
            cell.lblName.text = [strName uppercaseString];
            
            if (obj.objCommandType.volume.count > 0) {
                cell.imgConnected.hidden = false;
                cell.imgConnected.image = kImageIconIREnabled;
            } else {
                cell.imgConnected.hidden = true;
                cell.imgConnected.image = nil;
            }
            if (obj.Index == mHubManagerInstance.objSelectedOutputDevice.Index) {
                cell.imgBackground.backgroundColor = objTheme.colorOutputSelectedBackground;
                cell.imgBackground.image = [Utility imageWithColor:objTheme.colorOutputSelectedBackground Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:objTheme.colorOutputSelectedText];
                [cell.imgBackground addBorder_Color:objTheme.colorOutputSelectedBorder BorderWidth:1.0];
                
            } else {
                cell.imgBackground.backgroundColor = objTheme.colorOutputBackground;
                cell.imgBackground.image = [Utility imageWithColor:objTheme.colorOutputBackground Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:objTheme.colorOutputText];
                [cell.imgBackground addBorder_Color:objTheme.colorOutputBorder BorderWidth:1.0];
            }
        } else if ([self.arrTableData[indexPath.row] isKindOfClass:[Sequence class]]) {
            Sequence *obj = self.arrTableData[indexPath.row];
            NSString *strName = obj.uControl_name;
            cell.lblName.text = [strName uppercaseString];
            
            cell.imgConnected.hidden = false;
            cell.imgConnected.image = kImageIconSequence;
            
            cell.imgBackground.backgroundColor = objTheme.colorOutputBackground;
            cell.imgBackground.image = [Utility imageWithColor:objTheme.colorOutputBackground Frame:cell.imgBackground.frame];
            [cell.lblName setTextColor:objTheme.colorOutputText];
            [cell.imgBackground addBorder_Color:objTheme.colorOutputBorder BorderWidth:1.0];
        } else if ([self.arrTableData[indexPath.row] isKindOfClass:[Zone class]]) {
            Zone *obj = self.arrTableData[indexPath.row];
            NSString *strName = obj.zone_label;
            cell.lblName.text = [strName uppercaseString];
            
            if (obj.isIRPackAvailable == true) {
                cell.imgConnected.hidden = false;
                cell.imgConnected.image = kImageIconIREnabled;
            } else {
                cell.imgConnected.hidden = true;
                cell.imgConnected.image = nil;
            }
            
            if ([obj.zone_id isEqualToString:mHubManagerInstance.objSelectedZone.zone_id]) {
                cell.imgBackground.backgroundColor = objTheme.colorOutputSelectedBackground;
                cell.imgBackground.image = [Utility imageWithColor:objTheme.colorOutputSelectedBackground Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:objTheme.colorOutputSelectedText];
                [cell.imgBackground addBorder_Color:objTheme.colorOutputSelectedBorder BorderWidth:1.0];
            } else {
                cell.imgBackground.backgroundColor = objTheme.colorOutputBackground;
                cell.imgBackground.image = [Utility imageWithColor:objTheme.colorOutputBackground Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:objTheme.colorOutputText];
                [cell.imgBackground addBorder_Color:objTheme.colorOutputBorder BorderWidth:1.0];
            }
        }
        
        if (self.isEdit) {
            [cell.btnCellDelete setHidden:false];
            CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-1.0));
            CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(1.0));
            cell.contentView.transform = leftWobble;  // starting point
            [UIView beginAnimations:@"wobble" context:(__bridge void * _Nullable)(cell.contentView)];
            [UIView setAnimationRepeatAutoreverses:YES]; // important
            [UIView setAnimationRepeatCount:HUGE_VALF];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
            cell.contentView.transform = rightWobble; // end here & auto-reverse
            [UIView commitAnimations];
        } else {
            [cell.btnCellDelete setHidden:true];
            CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
            CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
            cell.contentView.transform = leftWobble;  // starting point
            [UIView beginAnimations:@"wobble" context:(__bridge void * _Nullable)(cell.contentView)];
            [UIView setAnimationRepeatAutoreverses:YES]; // important
            [UIView setAnimationRepeatCount:1];
            [UIView setAnimationDuration:0.125];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
            cell.contentView.transform = rightWobble; // end here & auto-reverse
            [UIView commitAnimations];
        }
        
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) wobbleEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    @try {
        if ([finished boolValue]) {
            UIView* item = (__bridge UIView *)context;
            item.transform = CGAffineTransformIdentity;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) didReceivedTapOnCellDeleteButton:(CellOutput *)sender {
    @try {
        DDLogDebug(@"<%s> sender == %@", __FUNCTION__, sender);

        if ([self.arrTableData[sender.indexPathCell.row] isKindOfClass:[OutputDevice class]]) {
            OutputDevice *objOP = self.arrTableData[sender.indexPathCell.row];
            for (int counter = 0; counter < mHubManagerInstance.objSelectedHub.HubOutputData.count; counter++) {
                OutputDevice *objOPList = mHubManagerInstance.objSelectedHub.HubOutputData[counter];
                if (objOPList.Index == objOP.Index) {
                    objOPList.isDeleted = true;
                    [mHubManagerInstance.objSelectedHub.HubOutputData replaceObjectAtIndex:counter withObject:objOPList];
                    break;
                }
            }
        } else if ([self.arrTableData[sender.indexPathCell.row] isKindOfClass:[Sequence class]]) {
            Sequence *objSeq = self.arrTableData[sender.indexPathCell.row];

            for (int counter = 0; counter < mHubManagerInstance.objSelectedHub.HubSequenceList.count; counter++) {
                Sequence *objSeqList = mHubManagerInstance.objSelectedHub.HubSequenceList[counter];
                if ([objSeqList.macro_id isEqualToString:objSeq.macro_id]) {
                    objSeqList.isDeleted = true;
                    [mHubManagerInstance.objSelectedHub.HubSequenceList replaceObjectAtIndex:counter withObject:objSeqList];
                    break;
                }
            }
        } else if ([self.arrTableData[sender.indexPathCell.row] isKindOfClass:[Zone class]]) {
            Zone *objZone = self.arrTableData[sender.indexPathCell.row];
            for (int counter = 0; counter < mHubManagerInstance.objSelectedHub.HubZoneData.count; counter++) {
                Zone *objZoneList = mHubManagerInstance.objSelectedHub.HubZoneData[counter];
                if ([objZoneList.zone_id isEqualToString:objZone.zone_id]) {
                    objZoneList.isDeleted = true;
                    [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:counter withObject:objZoneList];
                    break;
                }
            }
        }
        [self.arrTableData removeObjectAtIndex:sender.indexPathCell.row];
        [self.tableView reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if (!self.isEdit) {
            if ([
                 self.arrTableData[indexPath.row] isKindOfClass:[OutputDevice class]]) {
                [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:nil];
                OutputDevice *objOP = self.arrTableData[indexPath.row];
               // [self.tableView reloadData];
                [self.collectionOutputDev reloadData];
                mHubManagerInstance.objSelectedOutputDevice = objOP;
                mHubManagerInstance.controlDeviceTypeSource = InputSource;
                mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadControlVC object:self userInfo:[objOP dictionaryRepresentation]];
                
            } else if ([self.arrTableData[indexPath.row] isKindOfClass:[Sequence class]]) {
                Sequence *obj = self.arrTableData[indexPath.row];
                [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
                if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                    [APIManager executeSequence:mHubManagerInstance.objSelectedHub.Address SequenceId:obj.macro_id isSuperSeq:false completion:^(APIV2Response *responseObject) {
                        if (!responseObject.error) {
                            [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                        }
                    }];
                } else {
                    [APIManager playMacro_AlexaName:obj.alexa_name completion:^(APIResponse *responseObject) {
                        if (!responseObject.error) {
                             [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                            [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                        }
                    }];
                }

            } else if ([self.arrTableData[indexPath.row] isKindOfClass:[Zone class]]) {
                Zone *obj = self.arrTableData[indexPath.row];
                mHubManagerInstance.objSelectedZone = obj;
                // As we added Display UI in TOP BAR based on IR Pack, so in new conditions there can be display/output can occur in source list. So added code for Outputscreen too, otherwise in older code it only handling input source in TOP bar.
                if(mHubManagerInstance.controlDeviceTypeSource == OutputScreen){

                }
                else
                {
                    mHubManagerInstance.controlDeviceTypeSource = InputSource;
                }
//                //mHubManagerInstance.controlDeviceTypeSource = InputSource;
//                if(obj.OutputTypeInSelectedZone == videoOnly || obj.OutputTypeInSelectedZone == audioVideoZone)
//                {
//                    mHubManagerInstance.controlDeviceTypeBottom = HybridSource;
//                }
//                else
//                {
//                     mHubManagerInstance.controlDeviceTypeBottom = AudioSource;
//                }
                
                
//                if([mHubManagerInstance.objSelectedHub isPro2Setup])
//                {
//                     mHubManagerInstance.controlDeviceTypeBottom = HybridSource;
//                }
//                else
//                {
//                     mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
//                }
               

//                if ([mHubManagerInstance.objSelectedHub isPro2Setup ]) {
//                     mHubManagerInstance.controlDeviceTypeBottom = AudioSource;
//                }
//                else{
//                mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
//                }
                NSDictionary *dict = [obj dictionaryRepresentation];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadZoneControlVC object:self userInfo:dict];
//                // DDLogDebug(@"dictZone == %@", dict);
//                [self.tableView reloadData];
//                [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                //                [APIManager pingToTheHubExistOrNot:mHubManagerInstance.objSelectedHub];

                // Changes for not to hold screen and remove delays
                 [self.tableView reloadData];
                [self.collectionOutputDev reloadData];
                [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadZoneControlVC object:self userInfo:dict];
                    
                }];
            }
        }
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
                    isDataFound = true;
                    break;
                } else {
                    if ([objHub.SerialNo isEqualToString:mHubManagerInstance.objSelectedHub.SerialNo]) {
                        mHubManagerInstance.objSelectedHub = [Hub updateHubAddress_From:objHub To:mHubManagerInstance.objSelectedHub];
                        isDataFound = true;
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

#pragma mark - UICOllectioview
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    if(view == self.collectionZoneControls){
        return self.arrControls_filterByZoneId.count;
    }
    else if(view == self.collectionSequence){
        return self.arrSequences_filterByZoneId.count;
    }
    else{
        return self.arrTableData.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        CellOutputCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellOutputCollectionViewCell" forIndexPath:indexPath];
    
        ThemeColor *objTheme = [AppDelegate appDelegate].themeColours;
        cell.delegate = self;
        cell.indexPathCell = indexPath;
        cell.backgroundColor = objTheme.colorOutputBackground;
        cell.selectedBackgroundView.backgroundColor = objTheme.colorOutputSelectedBackground;
        [cell.lblName setTextColor:objTheme.colorOutputText];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [cell.lblName setFont:textFontBold10];
        }
        else if ([AppDelegate appDelegate].deviceType == mobileLarge){
            [cell.lblName setFont:textFontBold12];
        }
        else {
            [cell.lblName setFont:textFontBold14];
        }
        
        if(collectionView == self.collectionZoneControls){
            if ([self.arrControls_filterByZoneId[indexPath.row] isKindOfClass:[Controls class]]) {
                Controls *obj = self.arrControls_filterByZoneId[indexPath.row];
            cell.imgBackground.backgroundColor = [UIColor darkGrayColor];
                if([obj.device_type isEqualToString:@"AIR_CONDITIONER"]){
                    cell.imgBackground.image = [UIImage imageNamed:@"ac"];
                }
                else if([obj.device_type isEqualToString:@"LIGHTBULB"]){
                    cell.imgBackground.image = [UIImage imageNamed:@"light"];
                }
                else if([obj.device_type isEqualToString:@"AIR_HEATER"]){
                    cell.imgBackground.image = [UIImage imageNamed:@"heating"];
                }
                else if([obj.device_type isEqualToString:@"DOOR"]){
                    cell.imgBackground.image = [UIImage imageNamed:@"door"];
                }
                else if([obj.device_type isEqualToString:@"FAN"]){
                    cell.imgBackground.image = [UIImage imageNamed:@"fan"];
                }
                else if([obj.device_type isEqualToString:@"SWITCH"]){
                    cell.imgBackground.image = [UIImage imageNamed:@"switch"];
                }
                else if([obj.device_type isEqualToString:@"CAMERA"]){
                    cell.imgBackground.image = [UIImage imageNamed:@"cctv"];
                }
                else if([obj.device_type isEqualToString:@"WINDOW"]){
                    cell.imgBackground.image = [UIImage imageNamed:@"window-blinds"];
                }
                else {
                    cell.imgBackground.image = [UIImage imageNamed:@"in-line-power"];//Others
                }
            
            [cell.imgBackground addBorder_Color:UIColor.blackColor BorderWidth:1.0];
           }
        }
        else if(collectionView == self.collectionSequence){
            if ([self.arrSequences_filterByZoneId[indexPath.row] isKindOfClass:[Sequence class]]) {
               Sequence *obj = self.arrSequences_filterByZoneId[indexPath.row];
               NSString *strName = obj.uControl_name;
               cell.lblName.text = [strName uppercaseString];
               
//               cell.imgConnected.hidden = false;
//               cell.imgConnected.image = kImageIconSequence;
               
               cell.imgBackground.backgroundColor = objTheme.colorOutputBackground;
               cell.imgBackground.image = [Utility imageWithColor:objTheme.colorOutputBackground Frame:cell.imgBackground.frame];
               [cell.lblName setTextColor:objTheme.colorOutputText];
               [cell.imgBackground addBorder_Color:UIColor.blackColor BorderWidth:1.0];
           }
        }
        else{
        if ([self.arrTableData[indexPath.row] isKindOfClass:[OutputDevice class]]) {
            OutputDevice *obj = self.arrTableData[indexPath.row];
            NSString *strName = obj.CreatedName;
            cell.lblName.text = [strName uppercaseString];
            
            if (obj.objCommandType.volume.count > 0) {
                cell.imgConnected.hidden = false;
                cell.imgConnected.image = kImageIconIREnabled;
            } else {
                cell.imgConnected.hidden = true;
                cell.imgConnected.image = nil;
            }
            if (obj.Index == mHubManagerInstance.objSelectedOutputDevice.Index) {
                [self.zoneNameBtn setTitle:[strName uppercaseString] forState:UIControlStateNormal];
                cell.imgBackground.backgroundColor = colorMiddleGray_868787;
                cell.imgBackground.image = [Utility imageWithColor:colorMiddleGray_868787 Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:objTheme.colorNormalText];
                [cell.imgBackground addBorder_Color:UIColor.blackColor BorderWidth:1.0];
                
            } else {
                cell.imgBackground.backgroundColor = objTheme.colorOutputSelectedBackground;
                cell.imgBackground.image = [Utility imageWithColor:objTheme.colorOutputSelectedBackground Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:objTheme.colorOutputText];
                
                [cell.imgBackground addBorder_Color:UIColor.blackColor BorderWidth:1.0];
            }
        }  else if ([self.arrTableData[indexPath.row] isKindOfClass:[Zone class]]) {
            Zone *obj = self.arrTableData[indexPath.row];
            NSString *strName = obj.zone_label;
            cell.lblName.text = [strName uppercaseString];
            
            if (obj.isIRPackAvailable == true) {
                cell.imgConnected.hidden = false;
                cell.imgConnected.image = kImageIconIREnabled;
            } else {
                cell.imgConnected.hidden = true;
                cell.imgConnected.image = nil;
            }
            
            if ([obj.zone_id isEqualToString:mHubManagerInstance.objSelectedZone.zone_id]) {
                [self.zoneNameBtn setTitle:[strName uppercaseString] forState:UIControlStateNormal];
                cell.imgBackground.backgroundColor = colorMiddleGray_868787;
                cell.imgBackground.image = [Utility imageWithColor:colorMiddleGray_868787 Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:objTheme.colorOutputSelectedText];
                [cell.imgBackground addBorder_Color:UIColor.blackColor BorderWidth:1.0];
            } else {
                cell.imgBackground.backgroundColor = objTheme.colorOutputBackground;
                cell.imgBackground.image = [Utility imageWithColor:objTheme.colorOutputBackground Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:objTheme.colorOutputText];
                [cell.imgBackground addBorder_Color:UIColor.blackColor BorderWidth:1.0];
            }
        }
        }
        if (self.isEdit) {
            [cell.btnCellDelete setHidden:false];
            CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-1.0));
            CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(1.0));
            cell.contentView.transform = leftWobble;  // starting point
            [UIView beginAnimations:@"wobble" context:(__bridge void * _Nullable)(cell.contentView)];
            [UIView setAnimationRepeatAutoreverses:YES]; // important
            [UIView setAnimationRepeatCount:HUGE_VALF];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
            cell.contentView.transform = rightWobble; // end here & auto-reverse
            [UIView commitAnimations];
        } else {
            [cell.btnCellDelete setHidden:true];
            CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
            CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
            cell.contentView.transform = leftWobble;  // starting point
            [UIView beginAnimations:@"wobble" context:(__bridge void * _Nullable)(cell.contentView)];
            [UIView setAnimationRepeatAutoreverses:YES]; // important
            [UIView setAnimationRepeatCount:1];
            [UIView setAnimationDuration:0.125];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
            cell.contentView.transform = rightWobble; // end here & auto-reverse
            [UIView commitAnimations];
        }
        cell.imgConnected.hidden = true;
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

CGFloat timerTotal = 0;
CGFloat counter = 0;


-(void)updateSequenceProgressByColor:(NSTimer *)timer
{
    @try {
        Sequence *obj = [timer userInfo];
        //NSLog(@"secondsTimer %f",secondsTimer);
        CGFloat tempObj = obj.eTime_forSeqences/1000 ;// Convert in mili secon
        CGFloat tempObj2 = tempObj/100 ;// to loop it 100 times from total time.
        //NSLog(@"secondsTimer tempObj22 %f",tempObj);
        secondsTimer =   secondsTimer + tempObj2;
        counter = counter + 1;
        //NSLog(@"counter %f",counter);
        NSLog(@"seq name %f %f %f",counter,tempObj2,secondsTimer);
        CellOutputCollectionViewCell *cell = (CellOutputCollectionViewCell *)[self.collectionSequence cellForItemAtIndexPath:self->seqenceIndexP];
        if(secondsTimer > tempObj)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            [cell.seqTimer invalidate];
            cell.seqTimer = nil;
            [self removeTopView];
            });
            [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
//            [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
//            if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
//                if(obj.isFunction)//If the function is true, means its a super sequence and in case of super sequence Bool will be append at end of url
//                {
//                    [APIManager executeSuperSequence:mHubManagerInstance.objSelectedHub.Address SequenceId:obj.macro_id isSuperSeq:true completion:^(APIV2Response *responseObject) {
//                        if (!responseObject.error) {
//                            [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
//                        }
//                    }];
//                }else{
//                [APIManager executeSequence:mHubManagerInstance.objSelectedHub.Address SequenceId:obj.macro_id isSuperSeq:obj.isFunction completion:^(APIV2Response *responseObject) {
//                    if (!responseObject.error) {
//                        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
//                    }
//                }];
//                }
//            } else {
//                [APIManager playMacro_AlexaName:obj.alexa_name completion:^(APIResponse *responseObject) {
//                    if (!responseObject.error) {
//                         [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
//                        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
//                    }
//                }];
//            }
        }
        else{
        [cell.sequenceProgress_byTime setProgress:counter/100];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}

UIView *aView;

-(void)setTopView{
    @try {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }

    aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    aView.backgroundColor = [UIColor clearColor];
    aView.center = window.center;
    [window insertSubview:aView aboveSubview:self.view];
    [window bringSubviewToFront:aView];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)removeTopView
{@try {
    [aView removeFromSuperview];
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if (!self.isEdit) {
        if(collectionView == self.collectionSequence)
        {
             if ([self.arrSequences_filterByZoneId[indexPath.row] isKindOfClass:[Sequence class]]) {
                Sequence *obj = self.arrSequences_filterByZoneId[indexPath.row];
                 
                 if(obj.eTime_forSeqences > 0){
                    // dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self setTopView];
                        secondsTimer = 0.0;
                        counter = 0;
                         CellOutputCollectionViewCell *cell = (CellOutputCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                     CGFloat tempObj = obj.eTime_forSeqences/1000 ;// Convert in mili secon
                     CGFloat tempObj2 = tempObj/100 ;// to loop it 100 times from total time.
                         cell.seqTimer = [NSTimer scheduledTimerWithTimeInterval:tempObj2 target:self selector:@selector(updateSequenceProgressByColor:) userInfo:obj repeats:YES];
                         self->seqenceIndexP = indexPath;
                    // });
                 }
              //   else{
                [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
                if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                    if(obj.isFunction)//If the function is true, means its a super sequence and in case of super sequence Bool will be append at end of url
                    {
                        [APIManager executeSuperSequence:mHubManagerInstance.objSelectedHub.Address SequenceId:obj.macro_id isSuperSeq:true completion:^(APIV2Response *responseObject) {
                            if (!responseObject.error) {
                             //   [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                            }
                        }];
                    }else{
                    [APIManager executeSequence:mHubManagerInstance.objSelectedHub.Address SequenceId:obj.macro_id isSuperSeq:obj.isFunction completion:^(APIV2Response *responseObject) {
                        if (!responseObject.error) {
                            //[[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                        }
                    }];
                    }
                } else {
                    [APIManager playMacro_AlexaName:obj.alexa_name completion:^(APIResponse *responseObject) {
                        if (!responseObject.error) {
                             [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                            [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                        }
                    }];
                }
              //   }
            }
        }
        else if(collectionView == self.collectionZoneControls){
            if ([self.arrControls_filterByZoneId[indexPath.row] isKindOfClass:[Controls class]]) {
                Controls *controlObj = self.arrControls_filterByZoneId[indexPath.row];
                [APIManager executeFunction:mHubManagerInstance.objSelectedHub.Address functionId:controlObj.control_id isFlag:true completion:^(APIV2Response *responseObject) {
                    if (!responseObject.error) {
                        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                    }
                }];
            }
        }
        else{
            if ([self.arrTableData[indexPath.row] isKindOfClass:[OutputDevice class]]) {
                [self.collectionOutputDev setHidden:true];
                [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:nil];
                OutputDevice *objOP = self.arrTableData[indexPath.row];
                [self.tableView reloadData];
                [self.collectionOutputDev reloadData];
                mHubManagerInstance.objSelectedOutputDevice = objOP;
                mHubManagerInstance.controlDeviceTypeSource = InputSource;
                mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadControlVC object:self userInfo:[objOP dictionaryRepresentation]];
                
            }  else if ([self.arrTableData[indexPath.row] isKindOfClass:[Zone class]]) {
                [self.collectionOutputDev setHidden:true];
                Zone *obj = self.arrTableData[indexPath.row];
                mHubManagerInstance.objSelectedZone = obj;
                // As we added Display UI in TOP BAR based on IR Pack, so in new conditions there can be display/output can occur in source list. So added code for Outputscreen too, otherwise in older code it only handling input source in TOP bar.
                if(mHubManagerInstance.controlDeviceTypeSource == OutputScreen){

                }
                else
{
                    mHubManagerInstance.controlDeviceTypeSource = InputSource;
                }
//                //mHubManagerInstance.controlDeviceTypeSource = InputSource;
//                if(obj.OutputTypeInSelectedZone == videoOnly || obj.OutputTypeInSelectedZone == audioVideoZone)
//                {
//                    mHubManagerInstance.controlDeviceTypeBottom = HybridSource;
//                }
//                else
//                {
//                     mHubManagerInstance.controlDeviceTypeBottom = AudioSource;
//                }
                
                
//                if([mHubManagerInstance.objSelectedHub isPro2Setup])
//                {
//                     mHubManagerInstance.controlDeviceTypeBottom = HybridSource;
//                }
//                else
//                {
//                     mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
//                }
               

//                if ([mHubManagerInstance.objSelectedHub isPro2Setup ]) {
//                     mHubManagerInstance.controlDeviceTypeBottom = AudioSource;
//                }
//                else{
//                mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
//                }
                NSDictionary *dict = [obj dictionaryRepresentation];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadZoneControlVC object:self userInfo:dict];
//                // DDLogDebug(@"dictZone == %@", dict);
//                [self.tableView reloadData];
//                [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                //                [APIManager pingToTheHubExistOrNot:mHubManagerInstance.objSelectedHub];

                // Changes for not to hold screen and remove delays
                 [self.tableView reloadData];
                [self.collectionOutputDev reloadData];
                [self filterSequencesByZoneId];
                [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadZoneControlVC object:self userInfo:dict];
                    
                }];
            }
        }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView ==  self.collectionZoneControls)
    {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            CGSize size = CGSizeMake(40, 40);
            return size;
        }
        else
        {
            CGSize size = CGSizeMake(50 , 50);
            return size;
        }
    }
    else if(collectionView ==  self.collectionSequence)
    {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            CGSize size = CGSizeMake(self.collectionSequence.frame.size.width, 40);
            return size;
        }
        else
        {
            CGSize size = CGSizeMake(self.collectionSequence.frame.size.width , 50);
            return size;
        }
      
        
    }else{
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        CGSize size = CGSizeMake(SCREEN_WIDTH/3.50, 40);
        // DDLogDebug(@"Landscape size %@", NSStringFromCGSize(size));
        return size;
    }
    else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
        CGSize size = CGSizeMake(SCREEN_WIDTH/3.95, 50);
        // DDLogDebug(@"Landscape size %@", NSStringFromCGSize(size));
        return size;
    }
    
    else {
        if ([AppDelegate appDelegate].deviceType == tabletSmall) {
            CGSize size = CGSizeMake(SCREEN_WIDTH/6, 50);
            // DDLogDebug(@"Landscape size %@", NSStringFromCGSize(size));
            return size;
            
        } else {
            CGSize size;
            if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft  ){
                    //do something or rather
                 size = CGSizeMake(SCREEN_WIDTH/8.6, 50);
                    NSLog(@"landscape left");
                return size;
                }
                else if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
                    //do something or rather
                     size = CGSizeMake(SCREEN_WIDTH/8.6, 50);
                    NSLog(@"landscape right");
                    return size;
                }
                else{
                    //do something or rather
                     size = CGSizeMake(SCREEN_WIDTH/6, 50);
                    NSLog(@"portrait");
                    return size;
                }
            //return size;
            // DDLogDebug(@"Landscape size %@", NSStringFromCGSize(size));
            
        }
    }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
        
        if (kind == UICollectionElementKindSectionHeader) {
            ZoneMenuCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                 UICollectionElementKindSectionHeader withReuseIdentifier:@"ZoneMenuCollectionReusableView" forIndexPath:indexPath];
            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                [headerView.lblTitle setFont:textFontRegular12];
            }
            else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
                [headerView.lblTitle setFont:textFontRegular16];
            }
            else {
                [headerView.lblTitle setFont:textFontRegular18];
            }
            if(collectionView == self.collectionSequence)
            {
                [headerView.lblTitle setText:@"Sequences"];
            }
            else if(collectionView == self.collectionOutputDev)
            {
                [headerView.lblTitle setText:@"Zones"];
            }
            else
            {
                [headerView.lblTitle setText:@"Zone Controls"];
            }
           
            ThemeColor *objTheme = [AppDelegate appDelegate].themeColours;
            [headerView.lblTitle setTextColor:colorWhite];
            headerView.viewBorder.backgroundColor = colorGunGray_272726;
            reusableview = headerView;
        }
    else
    {
        NewZoneView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                             UICollectionElementKindSectionFooter withReuseIdentifier:@"NewZoneView" forIndexPath:indexPath];
        [headerView.btn_footer setTitle:@"Cancel" forState:UIControlStateNormal];
        [headerView.btn_footer setTitleColor:colorWhite forState:UIControlStateNormal];
        reusableview = headerView;
        return headerView;
    }

   
    
    //[self updateSectionHeader:headerView forIndexPath:indexPath];

    return reusableview;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return  CGSizeMake(SCREEN_WIDTH, heightTableViewRow);
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//referenceSizeForHeaderInSection:(NSInteger)section
//{
//
//    return  CGSizeMake(SCREEN_WIDTH, heightTableViewRow);
//}
//- (void)updateSectionHeader:(UICollectionReusableView *)header forIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *text = [NSString stringWithFormat:@"header #%i", indexPath.row];
//    header.label.text = text;
//}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    @try {
        // Make an image from the input view.
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
        [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        // Create an image view.
        UIView *snapshot = [[UIImageView alloc] initWithImage:image];
        snapshot.layer.masksToBounds = NO;
        snapshot.layer.cornerRadius = 0.0;
        snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
        snapshot.layer.shadowRadius = 5.0;
        snapshot.layer.shadowOpacity = 0.4;

        return snapshot;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
