//
//  SourceSwitchVC.m
//  mHubApp
//
//  Created by Anshul Jain on 03/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//
/**
 This VC loads when Selected device type is MHUB V3, MHUB MAX or MHUB Audio as Standalone or as Master of Stack.
 Multiple functionality covered in this VC:
 1. Switch between Input and Output device for V3 and MAX.
 2. Switch between Input and Zone for Audio.
 3. Zone Volume handling in Audio.
 4. Group Volume handing in Audio.
 5. When device is already connected and afterwards if application goes in background or terminated then after coming into the foreground state, this class will check for the connection to selected MHUB device and if connection is unsuccessful then search again for the device to find correct device.

 */

#import "SourceSwitchVC.h"
#import "CellInput.h"
#import "CellPower.h"
#import "CellGroupVolume.h"

@interface SourceSwitchVC ()<SearchDataManagerDelegate, UIGestureRecognizerDelegate, CellGroupVolumeDelegate, CustomAVPlayerDelegate> {
    int tapCount;
    NSInteger lastVolumeValue;
    BOOL lastMuteStatus;
    NSInteger intLastInputSelected;
    NSTimer *timerHideGroup;
    NSInteger seconds;
}

@property (weak, nonatomic) IBOutlet UIButton *btnLeftBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgNavBarShadow;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBGShadow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewBackgroundTopConstant;
@property (weak, nonatomic) IBOutlet UITableView *tblInputDevices;

@property (weak, nonatomic) IBOutlet UIImageView *imgFooterHDALogo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNavBarTopConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFooterHeightConstant;

@property (weak, nonatomic) IBOutlet UIView *viewAudioSlider;
@property (weak, nonatomic) IBOutlet CustomButtonForControls *btnAudioMute;
@property (weak, nonatomic) IBOutlet SSTTapSlider *sliderAudioVolume;
@property (weak, nonatomic) IBOutlet CustomButtonForControls *btnMHUBAudio;
@property (weak, nonatomic) IBOutlet CustomButtonForControls *btnMHUBAudioOutputLable;

@property (weak, nonatomic) IBOutlet UIView *viewOpaqueAudioGroupVolume;
@property (weak, nonatomic) IBOutlet UITableView *tblAudioGroupVolume;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintTblAudioGroupVolume;

@property (nonatomic, retain) NSMutableArray *arrInputs;

@end

@implementation SourceSwitchVC

- (void)viewDidLoad {
    @try {
//        [super viewDidLoad];
        self.navigationItem.backBarButtonItem = customBackBarButton;
       // self.navigationItem.hidesBackButton = true;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadSourceSwitch object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationReloadSourceSwitch
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadSourceSwitch_ViewWillAppear object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationReloadSourceSwitch_ViewWillAppear
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadZoneSourceSwitch object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationReloadZoneSourceSwitch
                                                   object:nil];

        UITapGestureRecognizer *tapGestureGroupVolume = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureGroupVolumeTableView:)];
        tapGestureGroupVolume.delegate = self;
        tapGestureGroupVolume.numberOfTapsRequired = 1;
        tapGestureGroupVolume.numberOfTouchesRequired = 1;
        tapGestureGroupVolume.cancelsTouchesInView = NO;
        [self.viewOpaqueAudioGroupVolume addGestureRecognizer:tapGestureGroupVolume];
        [self setHiddenGroupVolumeTableView:true];

//        if (mHubManagerInstance.objSelectedHub.Generation != mHub4KV3) {
//            [[CustomAVPlayer sharedInstance] setHardwareVolumeControl];
//            [CustomAVPlayer sharedInstance].delegate = self;
//        }
        // In this class there is no function /code written for this button, so button click is not needed.
        [self.btnMHUBAudio setUserInteractionEnabled:NO];
        ////NSLog(@"mHubManagerInstance.objSelectedZone %@",mHubManagerInstance.objSelectedZone.zone_id);
                Zone *obj = mHubManagerInstance.objSelectedZone;
                mHubManagerInstance.objSelectedZone = obj;
                NSDictionary *dict = [obj dictionaryRepresentation];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadZoneSourceSwitch object:self userInfo:dict];
        [[AppDelegate appDelegate] hockeyEventLog:NSStringFromClass([SourceSwitchVC class])];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) receiveNotification:(NSNotification *) notification {
    DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
    @try {
        if ([[notification name] isEqualToString:kNotificationReloadZoneSourceSwitch]) {
            Zone *objInfo = [notification.userInfo isNotEmpty] ? [Zone getZoneObjectFromDictionary:notification.userInfo Hub:mHubManagerInstance.objSelectedHub] :  mHubManagerInstance.objSelectedZone;

            [APIManager getMHUBZoneStatus:mHubManagerInstance.objSelectedHub Zone:objInfo completion:^(APIV2Response *responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!responseObject.error) {
                        Zone *objZoneStatus = (Zone*)responseObject.data_description;
                        mHubManagerInstance.objSelectedZone = objZoneStatus;
                        for (InputDevice *objIP in mHubManagerInstance.objSelectedHub.HubInputData) {
                            if (objZoneStatus.audio_input == objIP.Index) {
                                mHubManagerInstance.objSelectedInputDevice = objIP;
                                break;
                            }
                        }
                        [self.tblInputDevices reloadData];
                        [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                        [self updateTitleAndBackgroundImage];
                    }
                });
            }];            
        } else if ([[notification name] isEqualToString:kNotificationReloadSourceSwitch]) {

            OutputDevice *objInfo = [notification.userInfo isNotEmpty] ? [OutputDevice getOutputObjectFromDictionary:notification.userInfo Hub:mHubManagerInstance.objSelectedHub] : mHubManagerInstance.objSelectedOutputDevice;

            if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
                [SSDPManager getSSDPSwitchStatus:(int)objInfo.Index completion:^(APIResponse *objResponse) {
                    [self.tblInputDevices reloadData];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                }];
            } else {
                [APIManager getSwitchStatus:objInfo.Index completion:^(APIResponse *responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tblInputDevices reloadData];
                        [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    });
                }];
            }

            [self updateTitleAndBackgroundImage];
        } else {
            [self viewWillAppear:false];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        [self.navigationController.navigationBar setHidden:NO];
        [self updateSubViewColorAndVisiblity];
        
        self.arrInputs = [[NSMutableArray alloc] initWithArray:mHubManagerInstance.arrSourceDeviceManaged];
        ////NSLog(@"self.arrInputs 11  %@",self.arrInputs);

       // //NSLog(@"self.arrInputs 22 %@",[self.arrInputs sortedArrayUsingSelector: @selector(compare:)]);
       
       // NSArray *array = /* loaded from file */;
      //  self.arrInputs = [self.arrInputs sortedArrayUsingSelector: @selector(compare:)];
        
       // [self.arrInputs sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
        [self.arrInputs sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        ////NSLog(@"self.arrInputs 33  %@",self.arrInputs);
        for (InputDevice *objIP in self.arrInputs) {
            if (objIP.Index == mHubManagerInstance.objSelectedInputDevice.Index) {
                mHubManagerInstance.objSelectedInputDevice = objIP;
            }
        }
        
        [self updateTitleAndBackgroundImage];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) updateSubViewColorAndVisiblity {
    @try {
        self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
        self.btnLeftBarButton.imageView.image = [self.btnLeftBarButton.imageView.image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        [self.btnLeftBarButton.imageView setTintColor:[AppDelegate appDelegate].themeColours.colorHeaderText];
        
        self.imgBackground.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
        [[AppDelegate appDelegate] setShouldRotate:NO];
        
        [self.viewBackground setBackgroundColor:[AppDelegate appDelegate].themeColours.colorControlBackground];
        
        switch ([AppDelegate appDelegate].themeColours.themeType) {
            case Dark: {
                [self.imgNavBarShadow setImage:kImageShadowThemeBlack];
                [self.imgViewBGShadow setImage:kImageShadowThemeBlack];
                break;
            }
            case Light: {
                [self.imgNavBarShadow setImage:kImageShadowThemeWhite];
                [self.imgViewBGShadow setImage:kImageShadowThemeWhite];
                break;
            }
            default:
                break;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) updateTitleAndBackgroundImage {
    @try {
        OutputDevice *objOutput = mHubManagerInstance.objSelectedOutputDevice;
        Zone *objZone = mHubManagerInstance.objSelectedZone;
        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            if (objZone != nil) {
                NSString *strName = objZone.zone_label;
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelWITHOUT_BackArrow:[strName uppercaseString]];
            }

            if ([objZone.imgControlGroupBG isNotEmpty]) {
                self.imgBackground.image = objZone.imgControlGroupBG;
                switch ([AppDelegate appDelegate].themeColours.themeType) {
                    case Dark:
                        self.imgBackground.alpha = 0.2f;
                        break;
                    case Light:
                        self.imgBackground.alpha = 0.5f;
                        break;
                    default:
                        break;
                }
            } else {
                self.imgBackground.image = nil;
            }
        } else {
            if (objOutput != nil) {
                NSString *strName = objOutput.CreatedName;
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelWITHOUT_BackArrow:[strName uppercaseString]];
            }
            if ([objOutput.imgControlGroup isNotEmpty]) {
                self.imgBackground.image = objOutput.imgControlGroup;
                switch ([AppDelegate appDelegate].themeColours.themeType) {
                    case Dark:
                        self.imgBackground.alpha = 0.2f;
                        break;
                    case Light:
                        self.imgBackground.alpha = 0.5f;
                        break;
                    default:
                        break;
                }
            } else {
                self.imgBackground.image = nil;
            }
        }

        [self.tblInputDevices reloadData];

        if (mHubManagerInstance.objSelectedHub.Generation == mHubAudio) {
            [self.viewAudioSlider setHidden:false];
            [self.imgFooterHDALogo setHidden:true];

            // Get Group from Group list which contains current selected Zone
            [mHubManagerInstance getGroupFromZone:mHubManagerInstance.objSelectedZone GroupData:mHubManagerInstance.objSelectedHub.HubGroupData AllZoneData:mHubManagerInstance.objSelectedHub.HubZoneData completion:^(Group *objGroup, NSMutableArray<Zone *> *arrGroupZoneData) {
                if ([objGroup isNotEmpty]) {
                    mHubManagerInstance.objSelectedGroup = [[Group alloc] initWithGroup:objGroup];
                } else {
                    mHubManagerInstance.objSelectedGroup = nil;
                }
                if ([arrGroupZoneData isNotEmpty]) {
                    // assigning Zone value to array from string value.
                    mHubManagerInstance.arrSelectedGroupZoneList = [[NSMutableArray alloc] initWithArray:arrGroupZoneData];
                } else {
                    mHubManagerInstance.arrSelectedGroupZoneList = [[NSMutableArray alloc] init];
                }
            }];

            if ([mHubManagerInstance.objSelectedGroup isNotEmpty] && mHubManagerInstance.objSelectedHub.HubZoneData.count > 0) {

                lastVolumeValue = mHubManagerInstance.objSelectedGroup.GroupVolume;
                [self.sliderAudioVolume setValue:lastVolumeValue];

                if (self.sliderAudioVolume.value == self.sliderAudioVolume.minimumValue) {
                    [self.sliderAudioVolume setMinimumTrackTintColor:colorDarkGray_202020];
                    [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
                } else if (self.sliderAudioVolume.value == self.sliderAudioVolume.maximumValue) {
                    [self.sliderAudioVolume setMinimumTrackTintColor:colorWhite_254254254];
                    [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
                } else {
                    [self.sliderAudioVolume setMinimumTrackTintColor:colorWhite_254254254];
                    [self.sliderAudioVolume setThumbImage:kImageIconAudioSlider forState:UIControlStateNormal];
                }

                if (!mHubManagerInstance.objSelectedGroup.GroupMute) {
                    [self.btnAudioMute setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
                } else {
                    [self.btnAudioMute setImage:kImageIconAudioMuteInActive forState:UIControlStateNormal];
                    [self.sliderAudioVolume setMinimumTrackTintColor:colorDarkGray_272727];
                    [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEndGray forState:UIControlStateNormal];
                }
                self.btnAudioMute.infoData = mHubManagerInstance.objSelectedGroup;
                [self btnMHUBAudioOutputLabeling:mHubManagerInstance.objSelectedGroup.GroupMute InputIndex:objZone.audio_input];

            } else {
                [self.sliderAudioVolume setValue:objZone.Volume];
                lastVolumeValue = objZone.Volume;

                if (self.sliderAudioVolume.value == self.sliderAudioVolume.minimumValue) {
                    [self.sliderAudioVolume setMinimumTrackTintColor:colorDarkGray_202020];
                    [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
                } else if (self.sliderAudioVolume.value == self.sliderAudioVolume.maximumValue) {
                    [self.sliderAudioVolume setMinimumTrackTintColor:colorWhite_254254254];
                    [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
                } else {
                    [self.sliderAudioVolume setMinimumTrackTintColor:colorWhite_254254254];
                    [self.sliderAudioVolume setThumbImage:kImageIconAudioSlider forState:UIControlStateNormal];
                }

                if (!objZone.isMute) {
                    [self.btnAudioMute setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
                } else {
                    [self.btnAudioMute setImage:kImageIconAudioMuteInActive forState:UIControlStateNormal];
                    [self.sliderAudioVolume setMinimumTrackTintColor:colorDarkGray_272727];
                    [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEndGray forState:UIControlStateNormal];
                }
                self.btnMHUBAudio.infoData = objZone;
                [self btnMHUBAudioOutputLabeling:objZone.isMute InputIndex:objZone.audio_input];
            }
        } else {
            [self.imgFooterHDALogo setHidden:false];
            [self.viewAudioSlider setHidden:true];
        }

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) btnMHUBAudioOutputLabeling:(BOOL)isMuted InputIndex:(NSInteger) intAudioInputIndex {
    @try {
        lastMuteStatus = isMuted;
        intLastInputSelected = intAudioInputIndex == 0 ? mHubManagerInstance.objSelectedZone.audio_input : intAudioInputIndex;
        [self.btnMHUBAudioOutputLable setTitleColor:[AppDelegate appDelegate].themeColours.colorSettingControlBorder forState:UIControlStateNormal];

        NSMutableString *strTitle = [[NSMutableString alloc] init];

        NSString *strMuted = @" (MUTED)";
        NSString *strGroupAudio = @" (AUDIO GROUPED)";

        InputDevice *objAIP = [mHubManagerInstance.objSelectedInputDevice isNotEmpty] ? mHubManagerInstance.objSelectedInputDevice : [mHubManagerInstance.objSelectedHub.HubInputData objectAtIndex:intLastInputSelected];
        [strTitle appendString:objAIP.CreatedName];

        if (isMuted) {
            [strTitle appendString:strMuted];
        } else {
            if ([mHubManagerInstance.objSelectedGroup isNotEmpty]) {
                [strTitle appendString:strGroupAudio];
            }
        }
        [self.btnMHUBAudioOutputLable setTitle:[strTitle uppercaseString] forState:UIControlStateNormal];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewWillLayoutSubviews {
    @try {
        [super viewWillLayoutSubviews];

        CGFloat fltConstant = 15.0f;
        switch ([AppDelegate appDelegate].deviceType) {
            case mobileSmall: {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
                    fltConstant = 28.0f;
                }
                break;
            }

            case mobileLarge: {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
                    fltConstant = 28.0f;
                }
                break;
            }

            case tabletSmall: {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") && SYSTEM_VERSION_LESS_THAN(@"12.0")) {
                    fltConstant = 28.0f;
                } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"12.0")) {
                    fltConstant = 22.0f;
                }
                break;
            }

            case tabletLarge: {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") && SYSTEM_VERSION_LESS_THAN(@"12.0")) {
                    fltConstant = 28.0f;
                } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"12.0")) {
                    fltConstant = 22.0f;
                }
                break;
            }
            default:
                break;
        }

        self.constraintNavBarTopConstant.constant = fltConstant-15.0f;
        self.constraintViewBackgroundTopConstant.constant = fltConstant;

        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            self.constraintFooterHeightConstant.constant = heightFooterView_SmallMobile;
        } else {
            self.constraintFooterHeightConstant.constant = heightFooterView;
        }

        self.automaticallyAdjustsScrollViewInsets = YES;
        [self.tblInputDevices reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    @try {
        [super viewDidAppear:animated];
        if ([AppDelegate appDelegate].isRebootNavigation) {
            [AppDelegate appDelegate].isRebootNavigation = false;
            switch (mHubManagerInstance.objSelectedHub.Generation) {
                case mHub4KV3: {
                    [self connectSSDPDevice];
                    break;
                }
                default: {
                    if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                        [self getSystemDetails:mHubManagerInstance.objSelectedHub Stacked:mHubManagerInstance.isPairedDevice Slave:mHubManagerInstance.arrSlaveAudioDevice];
                    } else {
                        [self apiGetmHubDetails];
                    }
                    break;
                }
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tblAudioGroupVolume]) {
        return mHubManagerInstance.arrSelectedGroupZoneList.count;
    } else {
        return self.arrInputs.count;
    }
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
        if ([tableView isEqual:self.tblAudioGroupVolume]) {
            CellGroupVolume *cell = [tableView dequeueReusableCellWithIdentifier:@"CellGroupVolume"];
            cell = nil;
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

            CellSetup *cell = [tableView dequeueReusableCellWithIdentifier:@"CellInputDevices"];
            if (cell == nil) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellInputDevices"];
            }
            InputDevice *obj = [self.arrInputs objectAtIndex:indexPath.row];
            [cell.lblCell setText:[obj.CreatedName uppercaseString]];
            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                [cell.lblCell setFont:textFontLight10];
            } else {
                [cell.lblCell setFont:textFontLight13];
            }


            if (obj.Index == mHubManagerInstance.objSelectedInputDevice.Index) {
                [cell.lblCell setTextColor:[AppDelegate appDelegate].themeColours.colorLimitedInputSelectedText];
                cell.imgBackground.backgroundColor = [AppDelegate appDelegate].themeColours.colorLimitedInputSelectedBackground;
                [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorLimitedInputSelectedBorder BorderWidth:1.0];

            } else {
                [cell.lblCell setTextColor:[AppDelegate appDelegate].themeColours.colorLimitedInputText];
                cell.imgBackground.backgroundColor = [AppDelegate appDelegate].themeColours.colorLimitedInputBackground;
                [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorLimitedInputBorder BorderWidth:1.0];
            }
            return cell;
        }
    }
    @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        InputDevice *obj = [self.arrInputs objectAtIndex:indexPath.row];
        mHubManagerInstance.objSelectedInputDevice = obj;
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            [SSDPManager putSSDPSwitchIn_OutputIndex:mHubManagerInstance.objSelectedOutputDevice.Index InputIndex:obj.Index completion:^(APIResponse *objResponse) {
                if (!objResponse.error) {
                    [self.tblInputDevices reloadData];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                }
            }];
        } else if (mHubManagerInstance.objSelectedHub.Generation == mHubAudio) {
            [self switchInAudioDevice:obj];
        } else {
            if (mHubManagerInstance.objSelectedOutputDevice.Index == 0) {
                [[AppDelegate appDelegate] showHudView:ShowMessage Message:HUB_SELECTEDDEVICE];
            } else {
                if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                    [APIManager switchInZoneOutputToInput:mHubManagerInstance.objSelectedHub Zone:mHubManagerInstance.objSelectedZone InputDevice:obj completion:^(APIV2Response *responseObject) {
                        [self.tblInputDevices reloadData];
                        [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    }];
                } else {
                    [APIManager putSwitchIn_OutputIndex:mHubManagerInstance.objSelectedOutputDevice.Index InputIndex:obj.Index completion:^(APIResponse *responseObject) {
                        [self.tblInputDevices reloadData];
                        [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    }];
                }
            }
        }
    }
    @catch (NSException *exception) {
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
        CustomButtonForControls *btnSender = (CustomButtonForControls *)sender.btnGroupVolumeMute;
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
    return NO;
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

#pragma mark - SSDP Method
-(void)connectSSDPDevice {
    @try {
        [SSDPManager connectSSDPmHub_Completion:^(APIResponse *objResponse) {
            //DDLogDebug(@"isSuccess == %@", isSuccess ? @"true" : @"false");
            if (objResponse.error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
                        [[SearchDataManager sharedInstance] startSearchNetwork];
                        [SearchDataManager sharedInstance].delegate = self;
                    }
                });
            } else {
                [mHubManagerInstance syncGlobalManagerObjectV0];
            }
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - REST API methods
-(void) apiGetmHubDetails {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        [APIManager getmHubDetails_DataSync:false completion:^(APIResponse *responseObject) {
            if (responseObject.error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([responseObject.response isEqualToString:HUB_APPUPDATE_MESSAGE]) {
                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.response];
                    } else {
                        if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
                            [[SearchDataManager sharedInstance] startSearchNetwork];
                            [SearchDataManager sharedInstance].delegate = self;
                        }
                    }
                });
            } else {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) getSystemDetails:(Hub*)objDevice Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:HUB_CONNECTING];
        [APIManager getAllMHUBDetails:objDevice Stacked:isStacked Slave:arrSlaveDevice Sync:false completion:^(APIV2Response *responseObject) {
            if (responseObject.error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([responseObject.error_description isEqualToString:HUB_APPUPDATE_MESSAGE]) {
                        [[AppDelegate appDelegate] methodToCheckUpdatedVersionOnAppStore];
                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
                    } else {
                        if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
                            [[SearchDataManager sharedInstance] startSearchNetwork];
                            [SearchDataManager sharedInstance].delegate = self;
                        }
                    }
                });
            } else {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:HUB_SUCCESS];
            }
        }];
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

            if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                [self getSystemDetails:mHubManagerInstance.objSelectedHub Stacked:mHubManagerInstance.isPairedDevice Slave:mHubManagerInstance.arrSlaveAudioDevice];
            } else {
                [mHubManagerInstance syncGlobalManagerObjectV1];
            }
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

#pragma mark - MHUB Audio Control
- (IBAction)btnMHUBAudio_Clicked:(CustomButtonForControls *)sender {
    @try {

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnAudioMute_Clicked:(CustomButtonForControls *)sender {
    @try {
        [[CustomAVPlayer sharedInstance] soundPlay:Beep];
        CustomButtonForControls *btnSender = (CustomButtonForControls *)sender;
        if ([btnSender.currentImage isEqual:kImageIconAudioMuteActive]) {
            [btnSender setImage:kImageIconAudioMuteInActive forState:UIControlStateNormal];
            [self.sliderAudioVolume setMinimumTrackTintColor:colorDarkGray_272727];
            [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEndGray forState:UIControlStateNormal];

            [self setAudioControlMute:true ForOutputMute:btnSender];
        } else {
            [btnSender setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
            if (self.sliderAudioVolume.value == self.sliderAudioVolume.minimumValue) {
                [self.sliderAudioVolume setMinimumTrackTintColor:colorDarkGray_202020];
                [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
            } else if (self.sliderAudioVolume.value == self.sliderAudioVolume.maximumValue) {
                [self.sliderAudioVolume setMinimumTrackTintColor:colorWhite_254254254];
                [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
            } else {
                [self.sliderAudioVolume setMinimumTrackTintColor:colorWhite_254254254];
                [self.sliderAudioVolume setThumbImage:kImageIconAudioSlider forState:UIControlStateNormal];
            }

            [self setAudioControlMute:false ForOutputMute:btnSender];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - SSTTapSliderDelegate

- (void)tapSlider:(SSTTapSlider *)tapSlider valueDidChange:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
    // [self setAudioControlVolume:value GroupAvg:false ForOutputSlider:tapSlider];
}

- (void)tapSlider:(SSTTapSlider *)tapSlider tapEndedWithValue:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
    [self setAudioControlVolume:value GroupAvg:false ForOutputSlider:tapSlider];
    [self setAudioControlMute:false ForOutputMute:self.btnAudioMute];

    //[self.btnAudioMute setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
}

- (void)tapSlider:(SSTTapSlider *)tapSlider panBeganWithValue:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
}

- (void)tapSlider:(SSTTapSlider *)tapSlider panEndedWithValue:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
    [self setAudioControlVolume:value GroupAvg:false ForOutputSlider:tapSlider];
    [self setAudioControlMute:false ForOutputMute:self.btnAudioMute];

   // [self.btnAudioMute setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
}

#pragma mark - API Calling Methods

-(void) switchInAudioDevice:(InputDevice*)objInput {
    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
    //Without completion block
    [APIManager switchInAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id InputIndex:objInput.Index];
    //With completion block
//    [APIManager switchInAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id InputIndex:objInput.Index completion:^(APIV2Response *responseObject) {
//
//        if (responseObject.error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([responseObject.error_description isEqualToString:HUB_APPUPDATE_MESSAGE]) {
//                    [[AppDelegate appDelegate] methodToCheckUpdatedVersionOnAppStore];
//                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
//                } else {
//                    if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
//                        [[SearchDataManager sharedInstance] startSearchNetwork];
//                        [SearchDataManager sharedInstance].delegate = self;
//                    }
//                }
//            });
//        } else {
//            if ([mHubManagerInstance.objSelectedGroup isNotEmpty]) {
//                [self btnMHUBAudioOutputLabeling:mHubManagerInstance.objSelectedGroup.GroupMute InputIndex:intLastInputSelected];
//            }
//            else
//            {
//                [self btnMHUBAudioOutputLabeling:mHubManagerInstance.objSelectedZone.isMute InputIndex:objInput.Index];
//            }
//            [self.tblInputDevices reloadData];
//            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
//        }
//    }];
    if ([mHubManagerInstance.objSelectedGroup isNotEmpty]) {
        [self btnMHUBAudioOutputLabeling:mHubManagerInstance.objSelectedGroup.GroupMute InputIndex:intLastInputSelected];
    }
    else
    {
        [self btnMHUBAudioOutputLabeling:mHubManagerInstance.objSelectedZone.isMute InputIndex:objInput.Index];
    }
    [self.tblInputDevices reloadData];
    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
   
}

#pragma mark - Audio Group Volume

- (void)tapGestureGroupVolumeTableView:(UITapGestureRecognizer *)gesture {
    [self setHiddenGroupVolumeTableView:true];
}

-(void)setHiddenGroupVolumeTableView:(BOOL)isHide {
    @try {
        ThemeColor *objTheme = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColours];
        [self.viewOpaqueAudioGroupVolume setBackgroundColor:objTheme.colorBackground];
        [self.tblAudioGroupVolume setBackgroundColor:objTheme.colorPowerControlBG];
        [self.tblAudioGroupVolume setBackgroundColor:[UIColor clearColor]];

        self.heightConstraintTblAudioGroupVolume.constant = SCREEN_HEIGHT*0.6;
        [self.tblAudioGroupVolume reloadData];
        [self.tblAudioGroupVolume layoutIfNeeded];

        if (isHide) {
            /*To hide*/
            [self.viewOpaqueAudioGroupVolume setHidden:isHide];
            [self.tblAudioGroupVolume downSlideWithCompletion:^(BOOL finished) {
            }];
        } else {
            /*To unhide*/
            //[self setTimerHideGroup];

            CGFloat heightAudio = MIN(self.tblAudioGroupVolume.bounds.size.height, self.tblAudioGroupVolume.contentSize.height);
            self.heightConstraintTblAudioGroupVolume.constant = heightAudio;
            if (self.viewOpaqueAudioGroupVolume.isHidden && mHubManagerInstance.arrSelectedGroupZoneList.count > 0) {
                [self.tblAudioGroupVolume upSlideWithCompletion:^(BOOL finished) {
                    [self.viewOpaqueAudioGroupVolume setHidden:isHide];
//                    CGFloat yView = self.view.frame.size.height - (self.viewAudioSlider.frame.size.height+heightAudio);
//                    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
//                        self.tblAudioGroupVolume.frame = CGRectMake(0, yView, SCREEN_WIDTH, heightAudio);
//                    } else {
//                        self.tblAudioGroupVolume.frame = CGRectMake(0, yView, SCREEN_WIDTH, heightAudio);
//                    }
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
        seconds = 3;
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
            //DDLogDebug(@"seconds = %ld", seconds);
            seconds--;
        } else {
            [timerHideGroup invalidate];
            [self setHiddenGroupVolumeTableView:true];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) setAudioControlVolume:(NSInteger)value GroupAvg:(BOOL)isGroupAvg ForOutputSlider:(SSTTapSlider*)tapSlider {
    @try {
        // DDLogDebug(@"Volume == %ld", (long)value);

        if (isGroupAvg == false) {
            if ([mHubManagerInstance.objSelectedGroup isNotEmpty] && [tapSlider isEqual:self.sliderAudioVolume]) {
                if (value != lastVolumeValue) {
                    mHubManagerInstance.objSelectedGroup.GroupVolume = value;

                    // Shifted Up
                    mHubManagerInstance.objSelectedHub.HubGroupData = [mHubManagerInstance updateGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:mHubManagerInstance.objSelectedGroup];
                    [self btnMHUBAudioOutputLabeling:mHubManagerInstance.objSelectedGroup.GroupMute InputIndex:intLastInputSelected];
                    [self setHiddenGroupVolumeTableView:false];
                    [self updateSliderValueToZoneFromGroup_Previous:lastVolumeValue New:value];
                    mHubManagerInstance.objSelectedHub.HubZoneData = [mHubManagerInstance updateZoneFromGroupZoneData:mHubManagerInstance.arrSelectedGroupZoneList AllZoneData:mHubManagerInstance.objSelectedHub.HubZoneData];
                    lastVolumeValue = value;

                    [APIManager groupManager_Address:mHubManagerInstance.objSelectedHub.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Volume completion:^(APIV2Response *responseObject) {
                        if (!responseObject.error) {
                        }
                    }];
                }
            } else {
                if (value != lastVolumeValue) {
                    Zone *objZone;
                    if ([tapSlider isEqual:self.sliderAudioVolume]) {
                        objZone = mHubManagerInstance.objSelectedZone;
                    } else {
                        objZone = [mHubManagerInstance.arrSelectedGroupZoneList objectAtIndex:tapSlider.tag];
                    }

                    [APIManager controlVolumeAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:objZone.zone_id Volume:value];


                    if ([tapSlider isEqual:self.sliderAudioVolume]) {
                        objZone.Volume = value;
                        mHubManagerInstance.objSelectedZone.Volume = objZone.Volume;
                    } else {
                        objZone.Volume = value;
                        [mHubManagerInstance.arrSelectedGroupZoneList replaceObjectAtIndex:tapSlider.tag withObject:objZone];
                    }

                    for (int counter = 0; counter < [mHubManagerInstance.objSelectedHub.HubZoneData count]; counter++) {
                        Zone *objZoneTemp = [mHubManagerInstance.objSelectedHub.HubZoneData objectAtIndex:counter];
                        if ([objZone.zone_id isEqualToString:objZoneTemp.zone_id]) {
                            [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:counter withObject:objZone];
                            break;
                        }
                    }
                    [self btnMHUBAudioOutputLabeling:objZone.isMute InputIndex:intLastInputSelected];
                    [self setHiddenGroupVolumeTableView:false];
                    lastVolumeValue = value;

                    if ([mHubManagerInstance.objSelectedGroup isNotEmpty]) {
                        [self updateSliderValueAverageToGroupFromZone];
                    }
                }
            }
            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];

            if ([tapSlider isEqual:self.sliderAudioVolume]) {
                if (tapSlider.value == tapSlider.minimumValue) {
                    [tapSlider setMinimumTrackTintColor:colorDarkGray_202020];
                    [tapSlider setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
                } else if (tapSlider.value == tapSlider.maximumValue) {
                    [tapSlider setMinimumTrackTintColor:colorWhite_254254254];
                    [tapSlider setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
                } else {
                    [tapSlider setMinimumTrackTintColor:colorWhite_254254254];
                    [tapSlider setThumbImage:kImageIconAudioSlider forState:UIControlStateNormal];
                }
            } else {
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
            }

        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) setAudioControlMute:(BOOL)isMute ForOutputMute:(CustomButtonForControls *)btnSender {
    @try {
        if ([btnSender isEqual:self.btnAudioMute]) {
            if (!isMute) {
                [btnSender setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
            } else {
                [btnSender setImage:kImageIconAudioMuteInActive forState:UIControlStateNormal];
            }
        } else {
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
        }

        if ([mHubManagerInstance.objSelectedGroup isNotEmpty] && [btnSender isEqual:self.btnAudioMute]) {
            mHubManagerInstance.objSelectedGroup.GroupMute = isMute;

            mHubManagerInstance.objSelectedHub.HubGroupData = [mHubManagerInstance updateGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:mHubManagerInstance.objSelectedGroup];
            [self btnMHUBAudioOutputLabeling:isMute InputIndex:intLastInputSelected];
            [self setHiddenGroupVolumeTableView:false];
            [self updateMuteStatusFromGroupToZone:isMute];
            [APIManager groupManager_Address:mHubManagerInstance.objSelectedHub.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Mute completion:^(APIV2Response *responseObject) {
                if (!responseObject.error) {
                }
            }];
        } else {
            if ([btnSender isEqual:self.btnAudioMute]) {
                btnSender.infoData = mHubManagerInstance.objSelectedZone;
            }
            Zone *objZone = (Zone*)btnSender.infoData;
            [APIManager controlMuteAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:objZone.zone_id Mute:isMute];


            if ([btnSender isEqual:self.btnAudioMute]) {
                objZone.isMute = isMute;
                mHubManagerInstance.objSelectedZone.isMute = objZone.isMute;
            } else {
                objZone.isMute = isMute;
                [mHubManagerInstance.arrSelectedGroupZoneList replaceObjectAtIndex:btnSender.tag withObject:objZone];
            }

            for (int counter = 0; counter < [mHubManagerInstance.objSelectedHub.HubZoneData count]; counter++) {
                Zone *objZoneTemp = [mHubManagerInstance.objSelectedHub.HubZoneData objectAtIndex:counter];
                if ([objZone.zone_id isEqualToString:objZoneTemp.zone_id]) {
                    [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:counter withObject:objZone];
                    break;
                }
            }

            [self btnMHUBAudioOutputLabeling:isMute InputIndex:intLastInputSelected];
            [self setHiddenGroupVolumeTableView:false];
        }
        [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) deleteAudioOutput:(NSIndexPath *)indexPath {
    @try {
        [mHubManagerInstance.arrSelectedGroupZoneList removeObjectAtIndex:indexPath.row];
        [mHubManagerInstance.objSelectedGroup.arrGroupedZones removeObjectAtIndex:indexPath.row];

        if (mHubManagerInstance.arrSelectedGroupZoneList.count <= 1) {
            [APIManager groupManager_Address:mHubManagerInstance.objSelectedHub.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Delete completion:^(APIV2Response *responseObject) {
                if (responseObject.error) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                } else {
                    mHubManagerInstance.objSelectedHub.HubGroupData = [[NSMutableArray alloc] initWithArray:[mHubManagerInstance deleteGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:mHubManagerInstance.objSelectedGroup]];

                    mHubManagerInstance.objSelectedGroup = nil;
                    [mHubManagerInstance.arrSelectedGroupZoneList removeAllObjects];
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                }
            }];
        } else {
            mHubManagerInstance.objSelectedHub.HubGroupData = [mHubManagerInstance updateGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:mHubManagerInstance.objSelectedGroup];
            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];

            [APIManager groupManager_Address:mHubManagerInstance.objSelectedHub.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Add completion:^(APIV2Response *responseObject) {
                if (responseObject.error) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                } else {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                }
            }];
        }
        [self.tblAudioGroupVolume reloadData];
        [self.tblAudioGroupVolume layoutIfNeeded];

        CGFloat heightAudio = MIN(self.tblAudioGroupVolume.bounds.size.height, self.tblAudioGroupVolume.contentSize.height);
        self.heightConstraintTblAudioGroupVolume.constant = heightAudio;

        CGFloat yView = self.view.frame.size.height - (self.viewAudioSlider.frame.size.height+heightAudio);
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            self.tblAudioGroupVolume.frame = CGRectMake(0, yView, SCREEN_WIDTH, heightAudio);
        } else {
            self.tblAudioGroupVolume.frame = CGRectMake(0, yView, SCREEN_WIDTH, heightAudio);
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
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
            //DDLogDebug(@"Slider value == (%f)", tapSlider.value);
            intTotalValue+=tapSlider.value;
        }

        NSInteger intAverage = intTotalValue/intNoOfDevice;
        DDLogDebug(@"Average == %ld", (long)intAverage);
        [self.sliderAudioVolume setValue:intAverage];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) updateSliderValueToZoneFromGroup_Previous:(NSInteger)intPValue New:(NSInteger)intNValue {
    @try {
        // DDLogDebug(@"<%s Previous == %ld, New == %ld>", __FUNCTION__, (long)intPValue, (long)intNValue);
        NSInteger diff = intNValue-intPValue;
        // DDLogDebug(@"Slider value diff == (%ld)", (long)diff);
        for (int counter = 0; counter < mHubManagerInstance.arrSelectedGroupZoneList.count; counter++) {
            //OutputDevice *objAOP = [arrGroupOutput objectAtIndex:counter];
            NSIndexPath* indexpath = [NSIndexPath indexPathForRow:counter inSection:0]; // in case this row in in your first section
            CellGroupVolume* cell = [self.tblAudioGroupVolume cellForRowAtIndexPath:indexpath];
            SSTTapSlider* tapSlider = cell.sliderGroupVolumeOutput;
            // DDLogDebug(@"Slider value == (%f)", tapSlider.value);
            NSInteger intDiff = tapSlider.value+diff;
            // DDLogDebug(@"intDiff == (%ld)", (long)intDiff);
            if (intDiff < 0) {
                [tapSlider setValue:0 animated:true];
                //[self setAudioControlVolume:0 GroupAvg:true ForOutputSlider:tapSlider];
            } else if (intDiff > 100) {
                [tapSlider setValue:100 animated:true];
                //[self setAudioControlVolume:100 GroupAvg:true ForOutputSlider:tapSlider];
            } else {
                [tapSlider setValue:intDiff animated:true];
                //[self setAudioControlVolume:intDiff GroupAvg:true ForOutputSlider:tapSlider];
            }
            mHubManagerInstance.arrSelectedGroupZoneList[counter].Volume = tapSlider.value;
        }
        [self.tblAudioGroupVolume reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) updateMuteStatusFromGroupToZone:(BOOL)sender {
    @try {
        DDLogDebug(@"<%s == %d>", __FUNCTION__, sender);
        for (int counter = 0; counter < mHubManagerInstance.arrSelectedGroupZoneList.count; counter++) {
            // OutputDevice *objAOP = [arrGroupOutput objectAtIndex:counter];
            // NSIndexPath* indexpath = [NSIndexPath indexPathForRow:counter inSection:0]; // in case this row in in your first section
            // CellGroupVolume* cell = [self.tblAudioGroupVolume cellForRowAtIndexPath:indexpath];
            // CustomButtonForControls *btnSender = cell.btnGroupVolumeMute;
            // btnSender.infoData.isMute = sender;
            // [self setAudioControlMute:sender ForOutputMute:btnSender];
            mHubManagerInstance.arrSelectedGroupZoneList[counter].isMute = sender;
        }
        [self.tblAudioGroupVolume reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - CustomAVPlayerDelegate Method

-(void) didReceivedHardwareVolumeAudio_OldValue:(NSInteger)intOldValue NewValue:(NSInteger)intNewValue {
    @try {
            NSInteger value = intNewValue;
            SSTTapSlider *tapSlider = self.sliderAudioVolume;
            tapSlider.value = value;
            // DDLogDebug(@"Volume == %ld", (long)value);
            if ([mHubManagerInstance.objSelectedGroup isNotEmpty]) {
                if (value != lastVolumeValue) {
                    mHubManagerInstance.objSelectedGroup.GroupVolume = value;

                    // Shifted Up
                    mHubManagerInstance.objSelectedHub.HubGroupData = [mHubManagerInstance updateGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:mHubManagerInstance.objSelectedGroup];
                    [self btnMHUBAudioOutputLabeling:mHubManagerInstance.objSelectedGroup.GroupMute InputIndex:intLastInputSelected];
                    [self setHiddenGroupVolumeTableView:false];
                    [self updateSliderValueToZoneFromGroup_Previous:lastVolumeValue New:value];
                    mHubManagerInstance.objSelectedHub.HubZoneData = [mHubManagerInstance updateZoneFromGroupZoneData:mHubManagerInstance.arrSelectedGroupZoneList AllZoneData:mHubManagerInstance.objSelectedHub.HubZoneData];
                    lastVolumeValue = value;

                    // API Call for Group Volume
                    [APIManager groupManager_Address:mHubManagerInstance.objSelectedHub.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Volume completion:^(APIV2Response *responseObject) {
                        if (!responseObject.error) {
                        }
                    }];
                }
            } else {
                if (value != lastVolumeValue) {
                    Zone *objZone = mHubManagerInstance.objSelectedZone;

                    // API Call for Zone Volume
                    [APIManager controlVolumeAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:objZone.zone_id Volume:value];

                    objZone.Volume = value;
                    mHubManagerInstance.objSelectedZone.Volume = objZone.Volume;

                    for (int counter = 0; counter < [mHubManagerInstance.objSelectedHub.HubZoneData count]; counter++) {
                        Zone *objZoneTemp = [mHubManagerInstance.objSelectedHub.HubZoneData objectAtIndex:counter];
                        if ([objZone.zone_id isEqualToString:objZoneTemp.zone_id]) {
                            [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:counter withObject:objZone];
                            break;
                        }
                    }
                    [self btnMHUBAudioOutputLabeling:objZone.isMute InputIndex:intLastInputSelected];
                    [self setHiddenGroupVolumeTableView:false];
                    lastVolumeValue = value;

                    if ([mHubManagerInstance.objSelectedGroup isNotEmpty]) {
                        [self updateSliderValueAverageToGroupFromZone];
                    }
                }
            }
            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];


            if ([tapSlider isEqual:self.sliderAudioVolume]) {
                if (tapSlider.value == tapSlider.minimumValue) {
                    [tapSlider setMinimumTrackTintColor:colorDarkGray_202020];
                    [tapSlider setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
                } else if (tapSlider.value == tapSlider.maximumValue) {
                    [tapSlider setMinimumTrackTintColor:colorWhite_254254254];
                    [tapSlider setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
                } else {
                    [tapSlider setMinimumTrackTintColor:colorWhite_254254254];
                    [tapSlider setThumbImage:kImageIconAudioSlider forState:UIControlStateNormal];
                }
            } else {
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
            }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
