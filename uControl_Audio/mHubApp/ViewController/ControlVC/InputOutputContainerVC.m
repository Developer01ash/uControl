//
//  InputOutputContainerVC.m
//  mHubApp
//
//  Created by Anshul Jain on 15/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
 This is the container view, child Class of SourceContainerVC.
 This is the base class for Container like ControlGroupBGVC and OutputControlVC.
 This is important class when system is configured as Stack. Following functionality performed here:
 1. Switch between Input and Zone for connected stacked Audio device.
 2. Grouped Zone Volume handling for connected stacked Audio device.
 */

#import "InputOutputContainerVC.h"
#import "CellPower.h"
#import "CellGroupVolume.h"

@interface InputOutputContainerVC ()<UIGestureRecognizerDelegate, CellGroupVolumeDelegate, OutputControlDelegate> {
    NSMutableArray *arrAudioDevice;
    NSTimer *timerHideGroup;
    NSInteger seconds;
}
@property (weak, nonatomic) IBOutlet UIView *vcControlView;
@property (weak, nonatomic) IBOutlet UIView *vcBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintOutputControlConstant;
@property (weak, nonatomic) IBOutlet UIView *viewOpaqueAudio;
@property (weak, nonatomic) IBOutlet UITableView *tblAudioOutput;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintTblAudioOutput;
@property (weak, nonatomic) IBOutlet UIView *viewOpaqueAudioGroupVolume;
@property (weak, nonatomic) IBOutlet UITableView *tblAudioGroupVolume;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintTblAudioGroupVolume;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintVCBottomView;

@end

@implementation InputOutputContainerVC
- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.navigationItem.backBarButtonItem = customBackBarButton;
        
        UITapGestureRecognizer *tapGestureAudio = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAudioTableView:)];
        tapGestureAudio.delegate = self;
        tapGestureAudio.numberOfTapsRequired = 1;
        tapGestureAudio.numberOfTouchesRequired = 1;
        tapGestureAudio.cancelsTouchesInView = NO;
        [self.viewOpaqueAudio addGestureRecognizer:tapGestureAudio];
        
        UISwipeGestureRecognizer *swipeGestureAudio = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAudioTableView:)];
        [swipeGestureAudio setDelegate:self];
        [swipeGestureAudio setNumberOfTouchesRequired:1];
        [swipeGestureAudio setDirection:UISwipeGestureRecognizerDirectionDown];
        [self.viewOpaqueAudio addGestureRecognizer:swipeGestureAudio];
        
        UITapGestureRecognizer *tapGestureGroupVolume = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureGroupVolumeTableView:)];
        tapGestureGroupVolume.delegate = self;
        tapGestureGroupVolume.numberOfTapsRequired = 1;
        tapGestureGroupVolume.numberOfTouchesRequired = 1;
        tapGestureGroupVolume.cancelsTouchesInView = NO;
        [self.viewOpaqueAudioGroupVolume addGestureRecognizer:tapGestureGroupVolume];
        
        [self setHiddenAudioTableView:true];
        [self setHiddenGroupVolumeTableView:true];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadInputOutputContainer object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationReloadInputOutputContainer
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationShowHideInputOutputContainer object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotificationForShowHideTableView:)
                                                     name:kNotificationShowHideInputOutputContainer
                                                   object:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            self.heightConstraintOutputControlConstant.constant = heightFooterView_SmallMobile;
        } else {
            self.heightConstraintOutputControlConstant.constant = heightFooterView;
        }
        [self.view layoutIfNeeded];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    @try {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if ([[segue identifier] isEqualToString:kOutputControlVC]) {
            OutputControlVC *objCtrlType = (OutputControlVC *)[segue destinationViewController];
            objCtrlType.delegate = self;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Audio Source Device
-(void)showHideAudioTable:(BOOL)isHide deviceType:(ControlDeviceType)devType {
    @try {
        DDLogDebug(@"%s", __FUNCTION__);
        //testgroupchanges ok
        //  arrAudioDevice = [[NSMutableArray alloc] initWithArray: mHubManagerInstance.arrAudioSourceDeviceManaged];
        // This code filter the audio inputs, which is only connected with Zone, not all audio inputs must be shown.
                BOOL isContainVideoOutput = false;
              for (int i = 0; i < mHubManagerInstance.objSelectedZone.arrOutputs.count; i++) {
              OutputDevice *obj = [mHubManagerInstance.objSelectedZone.arrOutputs objectAtIndex:i];
            if(mHubManagerInstance.objSelectedZone.arrOutputs.count == 1 && [obj.outputType_VideoOrAudio containsString:@"audio"]){
                
            }
            else if([obj.outputType_VideoOrAudio containsString:@"video"] || [obj.UnitId isEqualToString:@"M1"]){
                  isContainVideoOutput = true;
              }
              ////NSLog(@"array output %@  %@  %ld",obj.CreatedName,obj.Name,(long)obj.Index);
              }
         arrAudioDevice = [[NSMutableArray alloc] init];
        if([mHubManagerInstance.objSelectedHub is411Setup])
        {
            InputDevice *aTempObj = [[InputDevice alloc] init];
            aTempObj.Index =  1;
            aTempObj.CreatedName = @"HDBASET ARC";
            aTempObj.Name =  @"HDBASET ARC";
            aTempObj.isDeleted = true;
             
            InputDevice *aTempObj2 = [[InputDevice alloc] init];
            aTempObj2.Index =  0;
            aTempObj2.isDeleted = true;
            aTempObj2.CreatedName = [NSString stringWithFormat:@"%@ %@", @"Default Audio",mHubManagerInstance.objSelectedInputDevice.CreatedName];
            aTempObj2.Name =  [NSString stringWithFormat:@"%@ %@", @"Default Audio",mHubManagerInstance.objSelectedInputDevice.CreatedName];
            [arrAudioDevice addObject:aTempObj2];
            [arrAudioDevice addObject:aTempObj];
        }
        if([mHubManagerInstance.objSelectedHub isPro2Setup] || [mHubManagerInstance.objSelectedHub isZPSetup]){
            if([self isAUtoEnabledORNot] && isContainVideoOutput){
            if(devType == AudioSource){
                InputDevice *aTempObj = [[InputDevice alloc] init];
                aTempObj.Index =  [self getInputID];//[self getInputID]
                aTempObj.PortNo = [self getInputID];
                aTempObj.UnitId = @"S";
                aTempObj.isDeleted = true;
                aTempObj.CreatedName = [NSString stringWithFormat:@"%@ %@", @"Match Audio With",mHubManagerInstance.objSelectedInputDevice.CreatedName];
                aTempObj.Name =  [NSString stringWithFormat:@"%@ %@", @"Match Audio With",mHubManagerInstance.objSelectedInputDevice.CreatedName];
                [arrAudioDevice addObject:aTempObj];
                [mHubManagerInstance.arrAudioSourceDeviceManaged addObject:aTempObj];
            }
        }
       
             if(devType != AudioSource && isContainVideoOutput){
            InputDevice *aTempObj = [[InputDevice alloc] init];
            aTempObj.Index =  0;
            aTempObj.PortNo = 0;
            aTempObj.isDeleted = true;
            if([mHubManagerInstance.objSelectedHub isPaired]){
                aTempObj.UnitId = @"M1";
            }else{
            aTempObj.UnitId = @"H1";
            }
            aTempObj.CreatedName = [NSString stringWithFormat:@"%@ %@", @"Default Audio",mHubManagerInstance.objSelectedInputDevice.CreatedName];
            aTempObj.Name =  [NSString stringWithFormat:@"%@ %@", @"Default Audio",mHubManagerInstance.objSelectedInputDevice.CreatedName];
            [arrAudioDevice addObject:aTempObj];
             }
    }
        
         
       // }
        NSMutableArray *newTempArr = [[NSMutableArray alloc] init];
        for(int i = 0 ; i < [mHubManagerInstance.arrAudioSourceDeviceManaged count]; i++)
            {
            InputDevice *objInput = [mHubManagerInstance.arrAudioSourceDeviceManaged objectAtIndex:i];
            NSMutableArray *arrOutDevice = [[NSMutableArray alloc] initWithArray:mHubManagerInstance.objSelectedZone.arrOutputs];
            for(int i = 0 ; i < [arrOutDevice count]; i++)
                {
                    OutputDevice *outputObj = (OutputDevice *)[arrOutDevice objectAtIndex:i];
                    if([objInput.UnitId isEqualToString:outputObj.UnitId ])
                    {
                         [newTempArr addObject:objInput];
                        if(devType == HybridSource)
                        {
                            if([objInput.UnitId isEqualToString:mHubManagerInstance.objSelectedHub.UnitId])
                            {
                                
                            }
                            else
                            {
                                [newTempArr removeObject:objInput];
                            }
                                               
                        }
                        else
                        {
                            if([objInput.UnitId isEqualToString:mHubManagerInstance.objSelectedHub.UnitId])
                            {
                                 [newTempArr removeObject:objInput];
                            }
                            else
                            {
                               
                            }
                        }
                    }
                }
            }

        // In the pro2 standalone units, there is no need to show all "hdbaset arc" and "hdmi arc" inputs. So if there is Video OUTPUT in selected Zone then all inputs will not shown which have type "hdbaset arc" and "hdmi arc", only single single object will be shown of "hdbaset arc" and "hdmi arc". so this single object will be added to inputs array those index/position is matched with index/position of video output in the zone.
        if([mHubManagerInstance.objSelectedHub isPro2Setup] && mHubManagerInstance.objSelectedOutputDevice.Index != 0 ){
            OutputDevice *objOutput = mHubManagerInstance.objSelectedOutputDevice;
            NSMutableArray *hdBaseArr =  [[NSMutableArray alloc] init];
            NSMutableArray *hdmiArr = [[NSMutableArray alloc] init];
            NSMutableArray *normalArr = [[NSMutableArray alloc] init];
            for(int i = 0 ; i < [newTempArr count]; i++)
                {
                InputDevice *objInput = [newTempArr objectAtIndex:i];
                //NSLog(@"INPUT NAME %@ input type %@ UNIT %@",objInput.CreatedName,objInput.inputType,objInput.UnitId);
                if([objInput.inputType isEqualToString:@"hdbaset arc" ])
                {
                    [hdBaseArr addObject:objInput];
                }
                else if([objInput.inputType isEqualToString:@"hdmi arc" ])
                {
                    [hdmiArr addObject:objInput];
                }
                else
                {
                    [normalArr addObject:objInput];
                }
                }

            // To Remove the duplicate data.
            NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:hdBaseArr];
            hdBaseArr = [orderedSet array].mutableCopy;
            NSOrderedSet *orderedSet2 = [NSOrderedSet orderedSetWithArray:hdmiArr];
            hdmiArr = [orderedSet2 array].mutableCopy;
            //NSOrderedSet *orderedSet3 = [NSOrderedSet orderedSetWithArray:normalArr];
            //normalArr = [orderedSet3 array].mutableCopy;
            if(mHubManagerInstance.objSelectedZone.arrOutputs.count == 1 && [objOutput.outputType_VideoOrAudio containsString:@"audio"])
            {
                
            }
            else if([objOutput.CreatedName containsString:@"Video"] || devType == HybridSource)
            {
                if([hdBaseArr isNotEmpty])
                [normalArr addObject:[hdBaseArr objectAtIndex:objOutput.Index-1]];
                if([hdmiArr isNotEmpty])
                [normalArr addObject:[hdmiArr objectAtIndex:objOutput.Index-1]];
            }
            
            
           // arrAudioDevice = [[NSMutableArray alloc] initWithArray: normalArr];
           // mHubManagerInstance.objSelectedOutputDevice
            [arrAudioDevice addObjectsFromArray:normalArr] ;
        }
        else
        {
            //arrAudioDevice = [[NSMutableArray alloc] initWithArray: newTempArr];
            [arrAudioDevice addObjectsFromArray:newTempArr] ;
        }
        if([mHubManagerInstance.objSelectedHub isPro2Setup] ){
        [self getZoneInputsFromPortPairing:arrAudioDevice];
        }

        //arrAudioDevice = [arrAudioDevice valueForKeyPath:@"@distinctUnionOfObjects.self"];
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrAudioDevice];
        arrAudioDevice = [orderedSet array].mutableCopy;
      //  if(mHubManagerInstance.objSelectedHub.mosVersion > 8.23){
        NSMutableArray *arrObj = [[NSMutableArray alloc]initWithArray:arrAudioDevice];
        for (int i = 0 ; i < [arrAudioDevice count]; i++) {
            InputDevice *objInput = [arrAudioDevice objectAtIndex:i];
            if (!objInput.isDeleted) {
                [arrObj removeObject:objInput];
            }
        }
        arrAudioDevice = arrObj;
        //}
        //arrAudioDevice = [[NSOrderedSet orderedSetWithArray:arrAudioDevice]allObjects];
        [self setHiddenAudioTableView:isHide];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
//yes right whatever sending from this, is coming to this section. see my screen shot. But without real time push notification
- (void)tapGestureAudioTableView:(UIGestureRecognizer *)gesture {
    [self setHiddenAudioTableView:true];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(NSInteger)getInputID
{
    @try {
                        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MappingKeyData"] isKindOfClass:NSArray.class]){
                            NSArray *array_mappingData = [[NSUserDefaults standardUserDefaults]valueForKey:@"MappingKeyData" ];
                            for(int i =0 ;i < array_mappingData.count;i++)
                                {
                                NSDictionary *dataDictionary = [array_mappingData objectAtIndex:i];
                                    if ([dataDictionary isKindOfClass:[NSDictionary class]]) {
                                        NSString *zoneID = [Utility checkNullForKey:kZONE_ID Dictionary:dataDictionary];
                                        if([zoneID isEqualToString:mHubManagerInstance.objSelectedZone.zone_id])
                                        {
                                            NSDictionary *dataInputDict = [dataDictionary objectForKey:kINPUT];
                                            NSInteger inputIndx = [Utility characterToInteger:[Utility checkNullForKey:kINPUT_ID Dictionary:dataInputDict]];
                                            return inputIndx;
                                        }
                                    }
                                }
                        }
    return 0;
    } @catch (NSException *exception) {
           [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
       }
}
-(NSInteger)getOutputID
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
                                        if([zoneID isEqualToString:mHubManagerInstance.objSelectedZone.zone_id])
                                        {
                                            NSDictionary *dataOutputDict = [dataDictionary objectForKey:kOUTPUT];
                                            NSInteger outputIndx = [Utility characterToInteger:[Utility checkNullForKey:kOUTPUT_ID Dictionary:dataOutputDict]];
                                            return outputIndx;
                                            //                                        if(outputIndx == mHubManagerInstance.objSelectedOutputDevice.Index)
                                            //                                            {
                                            //                                            NSDictionary *dataInputDict = [dataDictionary objectForKey:kINPUT];
                                            //                                            NSInteger IndexVal = [[dataInputDict objectForKey:kINPUT_ID]integerValue ];
                                            //                                            if(IndexVal  == objInput.Index)
                                            //                                                {
                                            //                                                [newTempArr removeObject:objInput];
                                            //                                                }
                                            //                                            }
                                        }
                                    }
                                }
                        }
    return 0;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

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
                                        //NSLog(@"zone id %@ and zone label %@",zoneObj.zone_id,zoneObj.zone_label);
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
-(NSInteger)getZoneInputsFromPortPairing:(NSMutableArray *)arrInputs{
    @try {
                        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MappingKeyData"] isKindOfClass:NSArray.class]){
                            NSArray *array_mappingData = [[NSUserDefaults standardUserDefaults]valueForKey:@"MappingKeyData" ];
                            for(int i =0 ;i < array_mappingData.count;i++)
                                {
                                NSDictionary *dataDictionary = [array_mappingData objectAtIndex:i];
                                    if ([dataDictionary isKindOfClass:[NSDictionary class]]) {
//                                        NSString *modeObj = [Utility checkNullForKey:kMODE Dictionary:dataDictionary];
                                        NSString *zoneID = [Utility checkNullForKey:kZONE_ID Dictionary:dataDictionary];
                                        Zone *zoneObj = [Zone getFilteredZoneData:zoneID ZoneData:mHubManagerInstance.objSelectedHub.HubZoneData];
                                        NSDictionary *dataInputDict = [dataDictionary objectForKey:kINPUT];
                                        NSInteger inputIndex = [Utility characterToInteger:[Utility checkNullForKey:kINPUT_ID Dictionary:dataInputDict]];
                                        
                                        //NSLog(@"zone id %@ and zone label %@",zoneObj.zone_id,zoneObj.zone_label);
                                        if([zoneID isNotEmpty]){
                                        for (int i = 0 ; i < [arrInputs count]; i++) {
                                               InputDevice *inputDev = (InputDevice *)[arrInputs objectAtIndex:i];
                                                //NSLog(@"zone id %ld and zone label %@",inputDev.Index,zoneObj.zone_label);
                                            if(![inputDev.Name containsString:@"Match Audio"]){
                                               if(inputDev.Index == inputIndex)
                                               {
                                                   InputDevice *obj = [arrAudioDevice objectAtIndex:i];
                                                   obj.CreatedName = [NSString stringWithFormat:@"%@ Audio",zoneObj.zone_label];
                                                   //NSLog(@"zone id %ld and zone label %@",inputDev.Index,zoneObj.zone_label);
                                               }
                                            }
//                                            if([zoneID isEqualToString:mHubManagerInstance.objSelectedZone.zone_id])
//                                            {
                                                if(![inputDev.Name containsString:@"Match Audio"]){

                                                if(inputDev.Index == inputIndex)
                                                {
                                                    [arrAudioDevice removeObject:inputDev];
                                                    
                                                }
                                                }
                                               
                                            //}
                                           }
                                        }
                                    }
                                }
                        }
   
    return 0;
        } @catch (NSException *exception) {
            [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
        }
}

-(void)setHiddenAudioTableView:(BOOL)isHide {
    @try {
        ThemeColor *objTheme = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColours];
        [self.viewOpaqueAudio setBackgroundColor:objTheme.colorBackground];
        [self.tblAudioOutput setBackgroundColor:objTheme.colorPowerControlBG];
        [self.tblAudioOutput reloadData];
        
        if (isHide) {
            /*To hide*/
            [self.viewOpaqueAudio setHidden:isHide];
            [self.tblAudioOutput downSlideWithCompletion:^(BOOL finished) {
            }];
        } else {
            /*To unhide*/
            //Anshul 2020: Below one was the previous code.
            //CGFloat heightAudio = MAX(self.tblAudioOutput.bounds.size.height, self.tblAudioOutput.contentSize.height);
            //to change dynamic height between ARC and audio inputs, i just used actual content height.
            CGFloat heightAudio =  self.tblAudioOutput.contentSize.height;
            
            //NSLog(@"bounds height %f and content size height %f",self.tblAudioOutput.bounds.size.height,self.tblAudioOutput.contentSize.height);
            if ([AppDelegate appDelegate].deviceType == mobileSmall && heightAudio > 350) {
                heightAudio = 350.0f;
            } else if ([AppDelegate appDelegate].deviceType == mobileLarge && heightAudio > 450) {
                heightAudio = 450.0f;
            } else if ([AppDelegate appDelegate].deviceType == tabletSmall && heightAudio > 450) {
                heightAudio = 450.0f;
            } else if ([AppDelegate appDelegate].deviceType == tabletLarge && heightAudio > 800) {
                heightAudio = 800.0f;
            }
            self.heightConstraintTblAudioOutput.constant = heightAudio;
            
            [self.tblAudioOutput upSlideWithCompletion:^(BOOL finished) {
                [self.viewOpaqueAudio setHidden:isHide];
                CGFloat yView = self.view.frame.size.height - (self.vcBottomView.frame.size.height+heightAudio);
                if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                    self.tblAudioOutput.frame = CGRectMake(0, yView, SCREEN_WIDTH, heightAudio);
                } else {
                    self.tblAudioOutput.frame = CGRectMake(0, yView, SCREEN_WIDTH, heightAudio);
                }
            }];
        }
        //[self.tblAudioOutput reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}



#pragma mark - Audio Group Volume
-(void)showHideGroupVolume:(BOOL)isHide {
    @try {
        [self setHiddenGroupVolumeTableView:isHide];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)tapGestureGroupVolumeTableView:(UITapGestureRecognizer *)gesture {
    [self setHiddenGroupVolumeTableView:true];
}

-(void)setHiddenGroupVolumeTableView:(BOOL)isHide {
    @try {
        ThemeColor *objTheme = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColours];
        [self.viewOpaqueAudioGroupVolume setBackgroundColor:objTheme.colorBackground];
        [self.tblAudioGroupVolume setBackgroundColor:objTheme.colorPowerControlBG];
        
        self.heightConstraintTblAudioGroupVolume.constant = SCREEN_HEIGHT*0.6;
        [self.tblAudioGroupVolume reloadData];
        [self.tblAudioGroupVolume layoutIfNeeded];
        
        //self.tblAudioGroupVolume.backgroundColor =  [UIColor redColor];
        
        if (isHide) {
            /*To hide*/
            [self.viewOpaqueAudioGroupVolume setHidden:isHide];
            [self.tblAudioGroupVolume setHidden:YES];
            [self.tblAudioGroupVolume downSlideWithCompletion:^(BOOL finished) {
            }];
        } else {
            /*To unhide*/
            [self setTimerHideGroup];
            [self.tblAudioGroupVolume setHidden:NO];

            CGFloat heightAudio = MIN(self.tblAudioGroupVolume.bounds.size.height, self.tblAudioGroupVolume.contentSize.height);
            self.heightConstraintTblAudioGroupVolume.constant = heightAudio;
            if (self.viewOpaqueAudioGroupVolume.isHidden && mHubManagerInstance.arrSelectedGroupZoneList.count > 0) {
                [self.tblAudioGroupVolume upSlideWithCompletion:^(BOOL finished) {
                    [self.viewOpaqueAudioGroupVolume setHidden:isHide];
                    CGFloat yView = self.view.frame.size.height - (self.vcBottomView.frame.size.height+heightAudio);
                    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                        self.tblAudioGroupVolume.frame = CGRectMake(0, yView, SCREEN_WIDTH, heightAudio);
                    } else {
                        self.tblAudioGroupVolume.frame = CGRectMake(0, yView, SCREEN_WIDTH, heightAudio);
                    }
                }];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) setTimerHideGroup {
    @try {
        [timerHideGroup invalidate];
        seconds = 5;
        timerHideGroup = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(timerHideGroupRun)
                                                        userInfo:nil
                                                         repeats:YES];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) timerHideGroupRun {
    @try {
        if (seconds > 0) {
            // DDLogDebug(@"seconds = %ld", seconds);
            seconds--;
        } else {
            [timerHideGroup invalidate];
            [self setHiddenGroupVolumeTableView:true];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.tblAudioOutput]) {
        return 15.0;
    } else {
        return 0.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderCellIdentifier = @"HeaderCellAudioInput";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderCellIdentifier];
    }

    UITapGestureRecognizer *tapGestureAudio = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAudioTableView:)];
    tapGestureAudio.delegate = self;
    tapGestureAudio.numberOfTapsRequired = 1;
    tapGestureAudio.numberOfTouchesRequired = 1;
    tapGestureAudio.cancelsTouchesInView = NO;
    [cell addGestureRecognizer:tapGestureAudio];
    
    UISwipeGestureRecognizer *swipeGestureAudio = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAudioTableView:)];
    [swipeGestureAudio setDelegate:self];
    [swipeGestureAudio setNumberOfTouchesRequired:1];
    [swipeGestureAudio setDirection:UISwipeGestureRecognizerDirectionDown];
    [cell addGestureRecognizer:swipeGestureAudio];

    return cell;
}

-(UIView *) tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectZero];
    return viewFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tblAudioOutput]) {
        return arrAudioDevice.count;
    } else if ([tableView isEqual:self.tblAudioGroupVolume]) {
        return mHubManagerInstance.arrSelectedGroupZoneList.count;
    } else {
        return 0;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if ([tableView isEqual:self.tblAudioGroupVolume]) {
    //        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
    //            return heightFooterView_SmallMobile;
    //        } else {
    //            return heightFooterView;
    //        }
    //    } else {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
    }
    //    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if ([tableView isEqual:self.tblAudioGroupVolume]) {
            CellGroupVolume *cell = [tableView dequeueReusableCellWithIdentifier:@"CellGroupVolume"];
            if (cell == nil) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellGroupVolume"];
            }
            [cell setBackgroundColor:[AppDelegate appDelegate].themeColours.colorPowerControlBG];
            [cell setTag:indexPath.row];
            cell.delegate = self;
            cell.cellIndexPath = indexPath;
            Zone *objZone = [mHubManagerInstance.arrSelectedGroupZoneList objectAtIndex:indexPath.row];
            [cell.lblGroupOutputName setTextColor:[AppDelegate appDelegate].themeColours.colorSettingControlBorder];
            [cell.lblGroupOutputName setFont:textFontLight10];
            [cell.lblGroupOutputName setText:[objZone.zone_label uppercaseString]];
            [cell.sliderGroupVolumeOutput setValue:objZone.Volume];
            [cell.sliderGroupVolumeOutput setTag:indexPath.row];
            cell.btnGroupVolumeMute.infoData = objZone;
            [cell.btnGroupVolumeMute setTag:indexPath.row];
            
            if ([AppDelegate appDelegate].themeColours.themeType == Light) {
                [cell.btnGroupAudioImage setImage:kImageIconAudioPairedGray forState:UIControlStateNormal];
                if (!objZone.isMute) {
                    [cell.btnGroupVolumeMute setImage:kImageIconAudioMuteActiveGray forState:UIControlStateNormal];
                } else {
                    [cell.btnGroupVolumeMute setImage:kImageIconAudioMuteInActiveGray forState:UIControlStateNormal];
                }
                [cell.sliderGroupVolumeOutput setMinimumTrackTintColor:colorGray_646464];
                [cell.sliderGroupVolumeOutput setMaximumTrackTintColor:colorWhite_254254254];
            } else {
                [cell.btnGroupAudioImage setImage:kImageIconAudioPaired forState:UIControlStateNormal];
                if (!objZone.isMute) {
                    [cell.btnGroupVolumeMute setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
                } else {
                    [cell.btnGroupVolumeMute setImage:kImageIconAudioMuteInActive forState:UIControlStateNormal];
                }
                [cell.sliderGroupVolumeOutput setMinimumTrackTintColor:colorWhite_254254254];
                [cell.sliderGroupVolumeOutput setMaximumTrackTintColor:colorDarkGray_202020];
            }
            return cell;
        } else {
            CellPower *cell = [tableView dequeueReusableCellWithIdentifier:@"CellPower"];
            if (cell == nil) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellPower"];
            }
//            cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorPowerControlBG;
            [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorPowerControlBorder BorderWidth:0.0];
            //[cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorPowerControlText];
            
            InputDevice *objInput = [arrAudioDevice objectAtIndex:indexPath.row];
            if([mHubManagerInstance.objSelectedHub isPro2Setup] && (mHubManagerInstance.controlDeviceTypeBottom  == HybridSource || mHubManagerInstance.controlDeviceTypeBottom  == OutputScreen))
            {
                if (objInput.Index == mHubManagerInstance.objSelectedZone.disp_audio_input) {
                    [cell.imgBackground setImage:[Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorInputSelectedBackground Frame:cell.imgBackground.frame]];
                    [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorInputSelectedText];
                }
                else
                    {
                        
                    [cell.imgBackground setImage:[Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorInputBackground Frame:cell.imgBackground.frame]];
                        [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorInputText];
                    }
            }
            else
            {
                if (objInput.Index == mHubManagerInstance.objSelectedZone.audio_input) {
                     [cell.imgBackground setImage:[Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorInputSelectedBackground Frame:cell.imgBackground.frame]];
                    [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorInputSelectedText];
                    
                }
                else
                    {
                    [cell.imgBackground setImage:[Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorInputBackground Frame:cell.imgBackground.frame]];
                        [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorInputText];
                    }
            }
//            if (objInput.Index == mHubManagerInstance.objSelectedZone.audio_input) {
//                [cell.imgBackground setImage:[Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorPowerControlBorder Frame:cell.imgBackground.frame]];
//            }
//            else
//                {
//                [cell.imgBackground setImage:[Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorPowerControlBG Frame:cell.imgBackground.frame]];
//                }
            cell.lblName.text = [objInput.CreatedName uppercaseString];
            //cell.backgroundColor = [UIColor greenColor];
            return cell;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if ([tableView isEqual:self.tblAudioOutput]) {
            InputDevice *objInput = [arrAudioDevice objectAtIndex:indexPath.row];
            [self switchInAudioDevice_InputIndex:objInput];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)didReceivedTapOnCellGroupImageButton:(CellGroupVolume *)sender {
    @try {
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)didReceivedTapOnCellGroupVolumeMuteButton:(CellGroupVolume *)sender {
    @try {
        [[CustomAVPlayer sharedInstance] soundPlay:Beep];
        CustomButton *btnSender = (CustomButton *)sender.btnGroupVolumeMute;
        Zone *objZone = (Zone*)btnSender.infoData;
        if (objZone.isMute) {
            [self setAudioControlMute:false ForOutputMute:btnSender];
        } else {
            [self setAudioControlMute:true ForOutputMute:btnSender];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if ([tableView isEqual:self.tblAudioOutput]) {
        return NO;
    } else {
        return NO;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[self deleteAudioOutput:indexPath];
    }
}

#pragma mark - CellGroupAudioDelegate
- (void)didReceivedTapOnCellDeleteButton:(CellGroupVolume *)sender {
    [self deleteAudioOutput:sender.cellIndexPath];
}


#pragma mark - SSTTapSliderDelegate
- (void)tapSlider:(SSTTapSlider *)tapSlider valueDidChange:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
    // [self setAudioControlVolume:value GroupAvg:false ForOutputSlider:tapSlider];
    // [self updateSliderValueAverage];
}

- (void)tapSlider:(SSTTapSlider *)tapSlider tapEndedWithValue:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
    [self setAudioControlVolume:value GroupAvg:false ForOutputSlider:tapSlider];
    [self updateSliderValueAverage];
}

- (void)tapSlider:(SSTTapSlider *)tapSlider panBeganWithValue:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
    // [self setAudioControlVolume:value ForOutputSlider:tapSlider];
}

- (void)tapSlider:(SSTTapSlider *)tapSlider panEndedWithValue:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
    [self setAudioControlVolume:value GroupAvg:false ForOutputSlider:tapSlider];
    [self updateSliderValueAverage];
}

#pragma mark - OutputControlDelegate
-(void) didReceivedReloadAudioDevice:(ControlDeviceType)deviceType {
    @try {
        // DDLogDebug(@"<%s deviceType == %ld>", __FUNCTION__, (unsigned long)deviceType);
        if (deviceType == AudioSource || deviceType == HybridSource) {
            [self showHideAudioTable:false deviceType:deviceType];
        } else {
            [self showHideAudioTable:true deviceType:deviceType];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
/* Please take Pull, as i have added another cell on Appoinments tab. and started working on medical questionnaire views.

 */
- (void) receiveNotification:(NSNotification *) notification {
    @try {
        // DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
        [self didReceivedReloadGroupVolume:Uncontrollable];
        [self didReceivedReloadAudioDevice:AudioSource];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) receiveNotificationForShowHideTableView:(NSNotification *) notification {
    @try {
        // DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
        [self setHiddenAudioTableView:true];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) didReceivedReloadGroupVolume:(ControlDeviceType)deviceType {
    @try {
        // DDLogDebug(@"<%s deviceType == %ld>", __FUNCTION__, (unsigned long)deviceType);
        if (deviceType == AudioSource) {
            [self showHideGroupVolume:false];
        } else {
            [self showHideGroupVolume:true];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) didReceivedTapOnGroupVolumeMuteButton:(BOOL)sender {
    @try {
        DDLogDebug(@"<%s == %d>", __FUNCTION__, sender);
        for (int counter = 0; counter < mHubManagerInstance.arrSelectedGroupZoneList.count; counter++) {
            // OutputDevice *objAOP = [arrGroupOutput objectAtIndex:counter];
            // NSIndexPath* indexpath = [NSIndexPath indexPathForRow:counter inSection:0]; // in case this row in in your first section
            // CellGroupVolume* cell = [self.tblAudioGroupVolume cellForRowAtIndexPath:indexpath];
            // CustomButton *btnSender = cell.btnGroupVolumeMute;
            // btnSender.infoData.isMute = sender;
            // [self setAudioControlMute:sender ForOutputMute:btnSender];
            mHubManagerInstance.arrSelectedGroupZoneList[counter].isMute = sender;
        }
        [self.tblAudioGroupVolume reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) didReceivedSliderAudioVolumeValueChanged_Previous:(NSInteger)intPValue New:(NSInteger)intNValue {
    @try {
        DDLogDebug(@"<%s Previous == %ld, New == %ld>", __FUNCTION__, (long)intPValue, (long)intNValue);
        NSInteger diff = intNValue-intPValue;
        // DDLogDebug(@"Slider value diff == (%ld)", (long)diff);
        for (int counter = 0; counter < mHubManagerInstance.arrSelectedGroupZoneList.count; counter++) {
            //OutputDevice *objAOP = [arrGroupOutput objectAtIndex:counter];
            NSIndexPath* indexpath = [NSIndexPath indexPathForRow:counter inSection:0]; // in case this row in in your first section
            CellGroupVolume* cell = [self.tblAudioGroupVolume cellForRowAtIndexPath:indexpath];
            SSTTapSlider* tapSlider = cell.sliderGroupVolumeOutput;
            DDLogDebug(@"Slider value == (%f)", tapSlider.value);
            NSInteger intDiff = tapSlider.value+diff;
            DDLogDebug(@"intDiff == (%ld)", (long)intDiff);
            if (intDiff < 0) {
                [tapSlider setValue:0 animated:true];
                //[self setAudioControlVolume:0 ForOutputSlider:tapSlider];
            } else if (intDiff > 100) {
                [tapSlider setValue:100 animated:true];
                //[self setAudioControlVolume:100 ForOutputSlider:tapSlider];
            } else {
                [tapSlider setValue:intDiff animated:true];
                //[self setAudioControlVolume:intDiff ForOutputSlider:tapSlider];
            }
            mHubManagerInstance.arrSelectedGroupZoneList[counter].Volume = tapSlider.value;
        }
        // [self.tblAudioGroupVolume reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - API Calling Methods
-(void) switchInAudioDevice_InputIndex:(InputDevice *)selectedInputdevice {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        OutputDevice *tempObj = [[OutputDevice alloc]init];
        NSInteger intInputIndex = selectedInputdevice.Index;
        //If there is hybrid icon then audio input must be save on disp_audio_input otherwise slave audio input will be store on audio_input
        if([mHubManagerInstance.objSelectedHub isPro2Setup] && (mHubManagerInstance.controlDeviceTypeBottom  == HybridSource || mHubManagerInstance.controlDeviceTypeBottom  == OutputScreen))
        {
            mHubManagerInstance.objSelectedZone.disp_audio_input = intInputIndex;
        }
        else
        {
            mHubManagerInstance.objSelectedZone.audio_input = intInputIndex;
        }
        
        NSInteger intOutputIndex;
        NSInteger portPairingIndex;
        portPairingIndex = [self getOutputID];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
            for (int j = 0; j < mHubManagerInstance.objSelectedZone.arrOutputs.count; j++) {
                OutputDevice *obj2 = [mHubManagerInstance.objSelectedZone.arrOutputs objectAtIndex:j ];
                if([selectedInputdevice.UnitId isEqualToString: obj2.UnitId])
                    {
                    [tempArr addObject:obj2];
                    tempObj = obj2;
                    }
                else if([selectedInputdevice.UnitId containsString:@"S"] && [obj2.UnitId containsString:@"S"])
                {
                    tempObj = obj2;
                }
            }


         for (int i = 0; i < tempArr.count; i++)
             {
             OutputDevice *obj1 = [tempArr objectAtIndex:i ];
            intOutputIndex = obj1.Index;
             }
        if(intInputIndex == 0)
        {
            if([selectedInputdevice.CreatedName containsString:@"Default Audio"])
            {
                
            }
            else{
            intInputIndex = [self getInputID];
            }
        }
        if(([tempObj.UnitId containsString:@"M"] || [tempObj.UnitId containsString:@"H"] )&& portPairingIndex != 0 )
        {
            intOutputIndex = portPairingIndex;
        }
        else if([tempObj.UnitId containsString:@"M"] || [tempObj.UnitId containsString:@"H"])
        {
            NSString *aStr1 = [NSString stringWithFormat:@"%ld",intOutputIndex+ mHubManagerInstance.arrSourceDeviceManaged.count];
            intOutputIndex = [Utility characterToInteger:aStr1];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadOutputControlLabel object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:intInputIndex] forKey:kINPUTINDEX]];
            [self.tblAudioOutput reloadData];
        //Without completion block
        if([mHubManagerInstance.objSelectedHub isPro2Setup])
        {
                if([tempObj.UnitId containsString:@"S"]){
                    [APIManager switchInAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id InputIndex:intInputIndex];
                }
                else{
                     [APIManager switchIn_Address:mHubManagerInstance.objSelectedHub.Address OutputIndex:intOutputIndex InputIndex:intInputIndex];
                }
           
        }
        else if([mHubManagerInstance.objSelectedHub is411Setup])//This condition added for 411 devices. where two ARC options are added hardcoded in the list.
        {
            intOutputIndex = mHubManagerInstance.objSelectedOutputDevice.Index;
            NSString *outputID = [NSString stringWithFormat:@"%@",[Utility integerToCharacter:intOutputIndex]];
            if(intInputIndex == 1) //True for hdbaset arc
                [APIManager switchInAudio411ARC_Address:mHubManagerInstance.objSelectedHub.Address flagOutputIndex:outputID  flagInputIndex:@"true"];
            else {// False for default audio
                [APIManager switchInAudio411ARC_Address:mHubManagerInstance.objSelectedHub.Address flagOutputIndex:outputID  flagInputIndex:@"false"];;
            }
        }
        else
            {
            [APIManager switchInAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id InputIndex:intInputIndex];
            }


        //With completion block
        // Audio changes for single slave-OLD
        //        [APIManager switchInAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id InputIndex:intInputIndex  completion:^(APIV2Response *responseObject) {
        //
        ////            if (responseObject.error) {
        ////                dispatch_async(dispatch_get_main_queue(), ^{
        ////                    if ([responseObject.error_description isEqualToString:HUB_APPUPDATE_MESSAGE]) {
        ////                        [[AppDelegate appDelegate] methodToCheckUpdatedVersionOnAppStore];
        ////                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
        ////                    } else {
        ////                        if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
        ////                            [[SearchDataManager sharedInstance] startSearchNetwork];
        ////                            [SearchDataManager sharedInstance].delegate = self;
        ////                        }
        ////                    }
        ////                });
        ////            } else {
        ////
        ////            }
        //        }];
        /*
         // Audio changes for single slave-NEW
         Hub *objAudioSlave = [mHubManagerInstance.arrSlaveAudioDevice firstObject];
         // [APIManager switchInAudioZone_Address:objAudioSlave.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id InputIndex:intInputIndex];
         */

        
        // SWITCHING: Direct Connection with Slave without Zone, in that case we commented above "slave-NEW" code, because that is used to send with Zone ID
        /*
         Zone *objZoneList0 = mHubManagerInstance.objSelectedHub.HubZoneData[0];
         if(objZoneList0.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager switchIn_Address:objAudioSlave.Address OutputIndex:1 InputIndex:intInputIndex - mHubManagerInstance.objSelectedHub.InputCount];
         }

         Zone *objZoneList1 = mHubManagerInstance.objSelectedHub.HubZoneData[1];
         if(objZoneList1.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager switchIn_Address:objAudioSlave.Address OutputIndex:2 InputIndex:intInputIndex- mHubManagerInstance.objSelectedHub.InputCount];
         }

         Zone *objZoneList2 = mHubManagerInstance.objSelectedHub.HubZoneData[2];
         if(objZoneList2.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager switchIn_Address:objAudioSlave.Address OutputIndex:3 InputIndex:intInputIndex-mHubManagerInstance.objSelectedHub.InputCount];
         }

         Zone *objZoneList3 = mHubManagerInstance.objSelectedHub.HubZoneData[3];
         if(objZoneList3.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager switchIn_Address:objAudioSlave.Address OutputIndex:4 InputIndex:intInputIndex-mHubManagerInstance.objSelectedHub.InputCount];
         }

         */
       
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) setAudioControlVolume:(NSInteger)value GroupAvg:(BOOL)isGroupAvg ForOutputSlider:(SSTTapSlider*)tapSlider {
    @try {
        Zone *objZone = [mHubManagerInstance.arrSelectedGroupZoneList objectAtIndex:tapSlider.tag];
        if (value == tapSlider.minimumValue) {
            [tapSlider setMinimumTrackTintColor:colorDarkGray_202020];
            [tapSlider setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
            if ([AppDelegate appDelegate].themeColours.themeType == Light) {
                [tapSlider setMinimumTrackTintColor:colorLightGray_230230230];
                [tapSlider setMaximumTrackTintColor:colorWhite_254254254];
            } else {
                [tapSlider setMinimumTrackTintColor:colorDarkGray_202020];
                [tapSlider setMaximumTrackTintColor:colorDarkGray_202020];
            }
        } else if (value == tapSlider.maximumValue) {
            [tapSlider setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
            if ([AppDelegate appDelegate].themeColours.themeType == Light) {
                [tapSlider setMinimumTrackTintColor:colorGray_646464];
                [tapSlider setMaximumTrackTintColor:colorLightGray_230230230];
            } else {
                [tapSlider setMinimumTrackTintColor:colorWhite_254254254];
                [tapSlider setMaximumTrackTintColor:colorDarkGray_202020];
            }
        } else {
            [tapSlider setThumbImage:kImageIconAudioSlider forState:UIControlStateNormal];
            if ([AppDelegate appDelegate].themeColours.themeType == Light) {
                [tapSlider setMinimumTrackTintColor:colorGray_646464];
                [tapSlider setMaximumTrackTintColor:colorWhite_254254254];
            } else {
                [tapSlider setMinimumTrackTintColor:colorWhite_254254254];
                [tapSlider setMaximumTrackTintColor:colorDarkGray_202020];
            }
        }
        objZone.Volume = value;
        [mHubManagerInstance.arrSelectedGroupZoneList replaceObjectAtIndex:tapSlider.tag withObject:objZone];
        //testgroupchanges ok
        // [APIManager controlVolume_Address:mHubManagerInstance.objSelectedHub.Address OutputIndex:objAOP.Index Volume:value];
        
        // Audio changes for single slave-OLD
        [APIManager controlVolumeAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:objZone.zone_id Volume:value];

        
        /*
         // Audio changes for single slave-NEW
         Hub *objAudioSlave = [mHubManagerInstance.arrSlaveAudioDevice firstObject];
         //  [APIManager controlVolumeAudioZone_Address:objAudioSlave.Address ZoneId:objZone.zone_id Volume:value];
         */
        
        // SWITCHING: Direct Connection with Slave without Zone, in that case we commented above "slave-NEW" code, because that is used to send with Zone ID
        /*
         Zone *objZoneList0 = mHubManagerInstance.objSelectedHub.HubZoneData[0];
         if(objZoneList0.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager controlVolume_Address:objAudioSlave.Address OutputIndex:1 Volume:value];

         }

         Zone *objZoneList1 = mHubManagerInstance.objSelectedHub.HubZoneData[1];
         if(objZoneList1.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager controlVolume_Address:objAudioSlave.Address OutputIndex:2 Volume:value];

         }

         Zone *objZoneList2 = mHubManagerInstance.objSelectedHub.HubZoneData[2];
         if(objZoneList2.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager controlVolume_Address:objAudioSlave.Address OutputIndex:3 Volume:value];
         }

         Zone *objZoneList3 = mHubManagerInstance.objSelectedHub.HubZoneData[3];
         if(objZoneList3.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager controlVolume_Address:objAudioSlave.Address OutputIndex:4 Volume:value];
         }

         */
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) setAudioControlMute:(BOOL)isMute ForOutputMute:(CustomButton*)btnSender {
    @try {
        Zone *objZone = (Zone*)btnSender.infoData;
        if (!isMute) {
            if ([AppDelegate appDelegate].themeColours.themeType == Light) {
                [btnSender setImage:kImageIconAudioMuteActiveGray forState:UIControlStateNormal];
            } else {
                [btnSender setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
            }
        } else {
            if ([AppDelegate appDelegate].themeColours.themeType == Light) {
                [btnSender setImage:kImageIconAudioMuteInActiveGray forState:UIControlStateNormal];
            } else {
                [btnSender setImage:kImageIconAudioMuteInActive forState:UIControlStateNormal];
            }
        }
        objZone.isMute = isMute;
        [mHubManagerInstance.arrSelectedGroupZoneList replaceObjectAtIndex:btnSender.tag withObject:objZone];
        
        //testgroupchanges ok
        // [APIManager controlMute_Address:mHubManagerInstance.objSelectedHub.Address OutputIndex:objOP.Index Mute:isMute];
        
        // Audio changes for single slave-OLD
        [APIManager controlMuteAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:objZone.zone_id Mute:isMute];

        // Audio changes for single slave-NEW
        /*
         Hub *objAudioSlave = [mHubManagerInstance.arrSlaveAudioDevice firstObject];
         DDLogDebug(@"slave IP address controlMuteAudioZone_Address %@", objAudioSlave.Address);
         //[APIManager controlMuteAudioZone_Address:objAudioSlave.Address ZoneId:objZone.zone_id Mute:isMute];
         */

        // SWITCHING: Direct Connection with Slave without Zone, in that case we commented above "slave-NEW" code, because that is used to send with Zone ID
        /*
         Zone *objZoneList0 = mHubManagerInstance.objSelectedHub.HubZoneData[0];
         if(objZoneList0.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager controlMute_Address:objAudioSlave.Address OutputIndex:1 Mute:isMute];

         }

         Zone *objZoneList1 = mHubManagerInstance.objSelectedHub.HubZoneData[1];
         if(objZoneList1.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager controlMute_Address:objAudioSlave.Address OutputIndex:2 Mute:isMute];

         }

         Zone *objZoneList2 = mHubManagerInstance.objSelectedHub.HubZoneData[2];
         if(objZoneList2.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager controlMute_Address:objAudioSlave.Address OutputIndex:3 Mute:isMute];
         }

         Zone *objZoneList3 = mHubManagerInstance.objSelectedHub.HubZoneData[3];
         if(objZoneList3.zone_id == mHubManagerInstance.objSelectedZone.zone_id)
         {
         [APIManager controlMute_Address:objAudioSlave.Address OutputIndex:4 Mute:isMute];
         }
         */
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(NSString *)convertDisplayID:(NSString *)string
{
    NSString *newStr = [string lowercaseString];
    if([newStr isEqualToString:@"a"])
    {
        return @"i";
    }
    if([newStr isEqualToString:@"b"])
    {
        return @"j";
    }
    if([newStr isEqualToString:@"c"])
    {
        return @"k";
    }
    if([newStr isEqualToString:@"d"])
    {
        return @"l";
    }
    if([newStr isEqualToString:@"e"])
    {
        return @"m";
    }
    if([newStr isEqualToString:@"f"])
    {
        return @"n";
    }
    if([newStr isEqualToString:@"g"])
    {
        return @"o";
    }
    if([newStr isEqualToString:@"h"])
    {
        return @"p";
    }
    return newStr;
    
}
-(void) deleteAudioOutput:(NSIndexPath *)indexPath {
    @try {
        
        [mHubManagerInstance.arrSelectedGroupZoneList removeObjectAtIndex:indexPath.row];
        [mHubManagerInstance.objSelectedGroup.arrGroupedZones removeObjectAtIndex:indexPath.row];

        if (mHubManagerInstance.arrSelectedGroupZoneList.count <= 1) {

            // Audio changes for single slave-OLD
            [APIManager groupManager_Address:mHubManagerInstance.objSelectedHub.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Delete completion:^(APIV2Response *responseObject) {

                /*
                 // Audio changes for single slave-NEW
                 Hub *objAudioSlave = [mHubManagerInstance.arrSlaveAudioDevice firstObject];
                 DDLogDebug(@"slave IP address objAudioSlave %@", objAudioSlave.Address);
                 [APIManager groupManager_Address:objAudioSlave.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Delete completion:^(APIV2Response *responseObject) {

                 */
                NSDictionary *dict;
                if (responseObject.error) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                } else {
                    for (int i = 0; i < mHubManagerInstance.objSelectedHub.HubZoneData.count; i++) {
                        Zone *tempZone = mHubManagerInstance.objSelectedHub.HubZoneData[i];
                        if ([mHubManagerInstance.objSelectedGroup.arrGroupedZones containsObject:tempZone.zone_id]) {
                            tempZone.isGrouped = NO;
                            tempZone.imgGroupedZone = nil;
                            if ([mHubManagerInstance.objSelectedZone.zone_id isEqualToString:tempZone.zone_id]) {
                                mHubManagerInstance.objSelectedZone = tempZone;
                                dict = [tempZone dictionaryRepresentation];
                            }
                        }
                        [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:i withObject:tempZone];
                    }
                    
                    
                    
                    //************
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadZoneControlVC object:self userInfo:dict];
                    
                    
                    
                    mHubManagerInstance.objSelectedHub.HubGroupData = [[NSMutableArray alloc] initWithArray:[mHubManagerInstance deleteGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:mHubManagerInstance.objSelectedGroup]];

                    mHubManagerInstance.objSelectedGroup = nil;
                    [mHubManagerInstance.arrSelectedGroupZoneList removeAllObjects];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                }
            }];
        } else {
            // Audio changes for single slave-OLD
            [APIManager groupManager_Address:mHubManagerInstance.objSelectedHub.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Add completion:^(APIV2Response *responseObject) {


                /*
                 // Audio changes for single slave-NEW
                 Hub *objAudioSlave = [mHubManagerInstance.arrSlaveAudioDevice firstObject];
                 DDLogDebug(@"slave IP address groupManager_Address %@", objAudioSlave.Address);
                 [APIManager groupManager_Address:objAudioSlave.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Add completion:^(APIV2Response *responseObject) {
                 */
                NSDictionary *dict;
                if (responseObject.error) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                } else {
                    
                    for (int i = 0; i < mHubManagerInstance.objSelectedHub.HubZoneData.count; i++) {
                        Zone *tempZone = mHubManagerInstance.objSelectedHub.HubZoneData[i];
                        if ([mHubManagerInstance.objSelectedGroup.arrGroupedZones containsObject:tempZone.zone_id]) {
                            tempZone.isGrouped = NO;
                            tempZone.imgGroupedZone = nil;
                            if ([mHubManagerInstance.objSelectedZone.zone_id isEqualToString:tempZone.zone_id]) {
                                mHubManagerInstance.objSelectedZone = tempZone;
                                dict = [tempZone dictionaryRepresentation];
                            }
                            
                        }
                        [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:i withObject:tempZone];
                    }
                    
                    
                    
                    //************
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadZoneControlVC object:self userInfo:dict];
                    
                    
                    mHubManagerInstance.objSelectedHub.HubGroupData = [mHubManagerInstance updateGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:mHubManagerInstance.objSelectedGroup];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                }
            }];
        }
        [self.tblAudioGroupVolume reloadData];
        [self.tblAudioGroupVolume layoutIfNeeded];
        
        CGFloat heightAudio = MIN(self.tblAudioGroupVolume.bounds.size.height, self.tblAudioGroupVolume.contentSize.height);
        self.heightConstraintTblAudioGroupVolume.constant = heightAudio;
        
        CGFloat yView = self.view.frame.size.height - (self.vcBottomView.frame.size.height+heightAudio);
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            self.tblAudioGroupVolume.frame = CGRectMake(0, yView, SCREEN_WIDTH, heightAudio);
        } else {
            self.tblAudioGroupVolume.frame = CGRectMake(0, yView, SCREEN_WIDTH, heightAudio);
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) updateSliderValueAverage {
    NSInteger intTotalValue = 0;
    NSInteger intNoOfDevice = mHubManagerInstance.arrSelectedGroupZoneList.count;
    for (int counter = 0; counter < mHubManagerInstance.arrSelectedGroupZoneList.count; counter++) {
        //OutputDevice *objAOP = [arrGroupOutput objectAtIndex:counter];
        NSIndexPath* indexpath = [NSIndexPath indexPathForRow:counter inSection:0]; // in case this row in in your first section
        CellGroupVolume* cell = [self.tblAudioGroupVolume cellForRowAtIndexPath:indexpath];
        SSTTapSlider* tapSlider = cell.sliderGroupVolumeOutput;
        // DDLogDebug(@"Slider value == (%f)", tapSlider.value);
        intTotalValue+=tapSlider.value;
    }
    NSInteger intAverage = intTotalValue/intNoOfDevice;
    DDLogDebug(@"Average == %ld", (long)intAverage);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadOutputControlSlider object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:intAverage] forKey:kSLIDERAVERAGE]];
}

-(void) updateSliderValueAverageToGroupFromZone {
    @try {
        NSInteger intTotalValue = 0;
        NSInteger intNoOfDevice = mHubManagerInstance.arrSelectedGroupZoneList.count;
        for (int counter = 0; counter < mHubManagerInstance.arrSelectedGroupZoneList.count; counter++) {
            //OutputDevice *objAOP = [arrGroupOutput objectAtIndex:counter];
            NSIndexPath* indexpath = [NSIndexPath indexPathForRow:counter inSection:0]; // in case this row in in your first section
            CellGroupVolume* cell = [self.tblAudioGroupVolume cellForRowAtIndexPath:indexpath];
            SSTTapSlider* tapSlider = cell.sliderGroupVolumeOutput;
            // DDLogDebug(@"Slider value == (%f)", tapSlider.value);
            intTotalValue+=tapSlider.value;
        }

        NSInteger intAverage = intTotalValue/intNoOfDevice;
        DDLogDebug(@"Average == %ld", (long)intAverage);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadOutputControlSlider object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:intAverage] forKey:kSLIDERAVERAGE]];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
@end
