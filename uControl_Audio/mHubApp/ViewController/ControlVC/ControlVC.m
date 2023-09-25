//
//  ControlVC.m
//  mHubApp
//
//  Created by Anshul Jain on 21/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ControlVC.h"
#import "CellPower.h"
#import <WatchConnectivity/WatchConnectivity.h>



/**
 This VC loads when Selected device type is MHUB Pro or MHUB V4 means those device support uControl-IRpack as Standalone or as Master of Stack.
 Multiple functionality covered in this VC:
 1. This is the base class for Container like InputDeviceVC, SourceContainerVC.
 2. Power button at the top right of the Navigation bar sets from here.
 3. When device is already connected and afterwards if application goes in background or terminated then after coming into the foreground state, this class will check for the connection to selected MHUB device and if connection is unsuccessful then search again for the device to find correct device.
 
 Following is hierarchy of parent class ControlVC:
 1. ControlVC:
 1.1. InputDeviceVC
 1.2. SourceContainerVC:
 1.2.1. InputOutputContainerVC:
 1.2.1.1. OutputControlVC
 1.2.2.2. ControlGroupBGVC:
 1.2.2.2.1. ControlTypeVC
 1.2.2.1.2. GroupContainerVC:
 1.2.2.1.2.1. ControlNoneVC
 1.2.2.1.2.2. DynamicControlGroupVC
 */

@interface ControlVC ()
@end

@implementation ControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    @try {
        self.navigationItem.backBarButtonItem = customBackBarButton;
        self.navigationController.navigationBar.backgroundColor =  [AppDelegate appDelegate].themeColours.colorBackground;
        // Do any additional setup after loading the view.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadControlVC object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationReloadControlVC
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadZoneControlVC object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationReloadZoneControlVC
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadControlVC_ViewWillAppear object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationReloadControlVC_ViewWillAppear
                                                   object:nil];
        UITapGestureRecognizer *tapGesturePower = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturePowerTableView:)];
        tapGesturePower.delegate = self;
        tapGesturePower.numberOfTapsRequired = 1;
        tapGesturePower.numberOfTouchesRequired = 1;
        tapGesturePower.cancelsTouchesInView = NO;
        [self.viewOpaquePower addGestureRecognizer:tapGesturePower];
        if (mHubManagerInstance.objSelectedHub.Generation != mHub4KV3) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(longPressRecognizerHandler_ReorderTableview:)];
            longPress.minimumPressDuration = 2.0;
            [self.tblPowerControl addGestureRecognizer:longPress];
        }
        [self setHiddenPowerTableView:true];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            [APIManager zoneSwitchStatus:mHubManagerInstance.objSelectedHub Zone:mHubManagerInstance.objSelectedZone completion:^(APIV2Response *responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self viewDidAppear:false];
                });
            }];
        });
        [[AppDelegate appDelegate] hockeyEventLog:NSStringFromClass([ControlVC class])];
        
        if ([WCSession isSupported]) {
            _wc_session = [WCSession defaultSession];
            _wc_session.delegate = self;
            [_wc_session activateSession];
                 NSLog(@"HIIII");
             }
        
        
        
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
- (void)session:(nonnull WCSession *)session didReceiveApplicationContext:(nonnull NSDictionary<NSString *,id> *)applicationContext {
   NSString *text = [applicationContext objectForKey:@"text"];
   dispatch_async(dispatch_get_main_queue(), ^{
       NSLog(@"HIIII %@",text);
   });
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message
{
    NSLog(@"didReceiveMessage  phone %@",message);
    if(session.isReachable)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:mHubManagerInstance.objSelectedHub.Address forKey:@"IPAddress"];
        NSLog(@"mHubManagerInstance.objSelectedHub.HubSequenceList %@",mHubManagerInstance.objSelectedHub.HubSequenceList);
        [dict setValue:[Sequence getDictionaryArray:mHubManagerInstance.objSelectedHub.HubSequenceList] forKey:@"SequenceList"];
       // [dict setValue:mHubManagerInstance.objSelectedHub.HubSequenceList forKey:@"SequenceList"];
//        NSError * err;
//        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
//        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        [dict2 setValue:myString forKey:@"IPAddress2"];
        [session sendMessage:dict replyHandler:nil errorHandler:nil];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    NSLog(@"views c %@",self.navigationController.viewControllers);
    if(WCSession.isSupported)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:mHubManagerInstance.objSelectedHub.Address forKey:@"IPAddress"];
        [dict setValue:mHubManagerInstance.objSelectedHub.HubSequenceList forKey:@"SequenceList"];
        [_wc_session sendMessage:dict replyHandler:nil errorHandler:nil];
    }
    else
    {
        _wc_session = WCSession.defaultSession;
        _wc_session.delegate = self;
        [_wc_session activateSession];
    }
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @try {
       // self.view.backgroundColor = [UIColor colorWithRed:26.0 green:26.0 blue:26.0 alpha:1.0];
        self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
        if ([AppDelegate appDelegate].deviceType == tabletLarge) {
            [[AppDelegate appDelegate] setShouldRotate:YES];
        }
        
        if ([AppDelegate appDelegate].isRebootNavigation) {
            [AppDelegate appDelegate].isRebootNavigation = false;
            if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
                if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                    [self getSystemDetails:mHubManagerInstance.objSelectedHub Stacked:mHubManagerInstance.isPairedDevice Slave:mHubManagerInstance.arrSlaveAudioDevice];
                } else {
                    [self apiGetmHubDetails];
                }
            }
        }
        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            Zone *objZone = mHubManagerInstance.objSelectedZone;
            if ([objZone isNotEmpty]) {
                [APIManager reloadSourceSubView];
            }
        } else {
            OutputDevice *objOutput = mHubManagerInstance.objSelectedOutputDevice;
            if ([objOutput isNotEmpty]) {
                [APIManager reloadSourceSubView];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    @try {
        //self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        self.view.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
        //self.btnLeftBarButton.imageView.image = [self.btnLeftBarButton.imageView.image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
       // [self.btnLeftBarButton.imageView setTintColor:[AppDelegate appDelegate].themeColours.colorHeaderText];
        
//        UIBarButtonItem *spaceFix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
//        spaceFix.width = 5;
//        self.navigationItem.leftBarButtonItems = @[spaceFix, self.btnLeftBarButton];
//
//        UIBarButtonItem *spaceFix2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
//        spaceFix2.width = -5;
//        self.navigationItem.rightBarButtonItems = @[spaceFix2, self.btnRightBarButton];

        //Dynamic height as per number of rown in content of table view
        CGFloat heightPower = MIN(self.tblPowerControl.bounds.size.height, self.tblPowerControl.contentSize.height);
        self.heightConstraintTblPowerControl.constant = heightPower;
        
        if (IS_IPHONE_4_OR_5_WIDTH) {
            CGFloat fltConstant = (SCREEN_HEIGHT*0.06)/3;
            self.heightInputControl.constant = fltConstant;
        }
        
        CGFloat fltConstant = 0.0f;
        switch ([AppDelegate appDelegate].deviceType) {
            case mobileSmall: {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
                    fltConstant = 13.0f;
                }
                break;
            }
                
            case mobileLarge: {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
                    fltConstant = 13.0f;
                }
                break;
            }
                
            case tabletSmall: {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") && SYSTEM_VERSION_LESS_THAN(@"12.0")) {
                    fltConstant = 13.0f;
                } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"12.0")) {
                    fltConstant = 7.0f;
                }
                break;
            }
                
            case tabletLarge: {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") && SYSTEM_VERSION_LESS_THAN(@"12.0")) {
                    fltConstant = 13.0f;
                } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"12.0")) {
                    fltConstant = 7.0f;
                }
                break;
            }
            default:
                break;
        }
        //fltConstant = 0.0;
        self.constraintInputControlTopConstant.constant = fltConstant;
        self.constraintViewOpaqueTopConstant.constant = fltConstant;
        self.constraintPowerControlTopConstant.constant = fltConstant;
        
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            self.constraintInputControlHeightConstant.constant = heightTableViewRow_SmallMobile;
        } else {
            self.constraintInputControlHeightConstant.constant = heightTableViewRow;
        }
        
        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            Zone *objZone = mHubManagerInstance.objSelectedZone;
            if (objZone != nil) {
                NSString *strName = objZone.zone_label;
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelControlView:[strName uppercaseString]];
            }
        } else {
            OutputDevice *objOutput = mHubManagerInstance.objSelectedOutputDevice;
            if (objOutput != nil) {
                NSString *strName = objOutput.CreatedName;
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelControlView:[strName uppercaseString]];
            }
        }
        
        [self.view layoutIfNeeded];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)testValue:(UIButton *)sender
//{
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Interger Only"
//                                                                                      message: @"Input Press and HOLD integer values"
//                                                                                  preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"PRESS";
//            textField.text = [NSString stringWithFormat:@"%f", [AppDelegate appDelegate].pressVal];
//            textField.textColor = [UIColor whiteColor];
//            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            textField.borderStyle = UITextBorderStyleRoundedRect;
//        }];
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"HOLD";
//            textField.text = [NSString stringWithFormat:@"%f", [AppDelegate appDelegate].holdVal];
//            textField.textColor = [UIColor whiteColor];
//            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            textField.borderStyle = UITextBorderStyleRoundedRect;
//
//        }];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            NSArray * textfields = alertController.textFields;
//            UITextField * namefield = textfields[0];
//            double pressdouble = [namefield.text doubleValue];
//            [AppDelegate appDelegate].pressVal = pressdouble;
//
//            UITextField * passwordfiled = textfields[1];
//            double holddouble = [passwordfiled.text doubleValue];
//            [AppDelegate appDelegate].holdVal = holddouble;
//            NSLog(@"%@:%f",namefield.text,[AppDelegate appDelegate].pressVal);
//            NSLog(@"%@:%f",namefield.text,[AppDelegate appDelegate].holdVal);
//
//        }]];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

/*
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 }
 */

- (void) receiveNotification:(NSNotification *) notification {
    DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
    @try {
        if ([[notification name] isEqualToString:kNotificationReloadZoneControlVC]) {
            Zone *objInfo = [notification.userInfo isNotEmpty] ? [Zone getZoneObjectFromDictionary:notification.userInfo Hub:mHubManagerInstance.objSelectedHub] :  mHubManagerInstance.objSelectedZone;
            if (objInfo != nil) {
                NSString *strName = [objInfo.zone_label uppercaseString];
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelControlView:strName];
            }
            // By this code, there will be no delay when coming from left menu or side menu
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
            dispatch_async(queue, ^{
                [APIManager zoneSwitchStatus:mHubManagerInstance.objSelectedHub Zone:objInfo completion:^(APIV2Response *responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self viewDidAppear:false];
                    });
                }];
            });
            
        } else if ([[notification name] isEqualToString:kNotificationReloadControlVC_ViewWillAppear]) {
            [self showHidePowerButtonOnTopRight];
        } else {
            OutputDevice *objInfo = [notification.userInfo isNotEmpty] ? [OutputDevice getOutputObjectFromDictionary:notification.userInfo Hub:mHubManagerInstance.objSelectedHub] : mHubManagerInstance.objSelectedOutputDevice;
            if (objInfo != nil) {
                NSString *strName = [objInfo.CreatedName uppercaseString];
                self.navigationItem.titleView = [CustomNavigationBar customNavigationLabelControlView:strName];
            }
            // By this code, there will be no delay when coming from left menu or side menu
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
            dispatch_async(queue, ^{
                [APIManager getSwitchStatus:objInfo.Index completion:^(APIResponse *responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self viewDidAppear:false];
                    });
                }];
            });
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Power Control Command
- (IBAction)btnRightNavBar_Clicked:(id)sender {
    @try {
        [[CustomAVPlayer sharedInstance] soundPlay:Beep];
        if (self.tblPowerControl.hidden == true) {
            [self setHiddenPowerTableView:false];
        } else {
            [self setHiddenPowerTableView:true];
        }
        return;
        if (arrPowerControlCommand.count < 2) {
            SectionSetting *objSection = [arrPowerControlCommand firstObject];
            switch (objSection.sectionType) {
                case HDA_DisplayPower:
                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[objSection.arrRow firstObject] PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo TouchType:Normal];
                    break;
                case HDA_SourcePower:
                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[objSection.arrRow firstObject] PortNo:mHubManagerInstance.objSelectedInputDevice.PortNo  TouchType:Normal];
                    break;
                case HDA_AVRPower:
                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[objSection.arrRow firstObject] PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo  TouchType:Normal];
                    break;
                case HDA_AudioDevice:
                    // Audio changes for single slave-OLD
                    [APIManager controlMuteAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id Mute:true];
                    break;
                default:
                    break;
            }
        } else {
            if (self.tblPowerControl.hidden == true) {
                [self setHiddenPowerTableView:false];
            } else {
                [self setHiddenPowerTableView:true];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)showHidePowerButtonOnTopRight {
    @try {
        [self setHiddenPowerTableView:true];

        // Array to maintain power button long press view
        arrPowerControlCommand = [[NSMutableArray alloc] init];
        
        OutputDevice *objOutput = mHubManagerInstance.objSelectedOutputDevice;
        if([objOutput.CreatedName containsString:@"CEC"] && ![[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecPower"])
        {
        [self.btnRightBarButton setHidden:true];
        return;
        }
        NSArray *arrOutputControlCommand = [[NSArray alloc] initWithArray:objOutput.objCommandType.powerKey];
        InputDevice *objInput;
        NSArray *arrInputControlCommand;
        if([mHubManagerInstance.objSelectedInputDevice isKindOfClass:[InputDevice class]]){
            objInput = mHubManagerInstance.objSelectedInputDevice;
            arrInputControlCommand = [[NSArray alloc] initWithArray:objInput.objCommandType.powerKey];
        }
        
        AVRDevice *objAVR = mHubManagerInstance.objSelectedAVRDevice;
        NSArray *arrAVRControlCommand = [[NSArray alloc] initWithArray:objAVR.objCommandType.powerKey];
        if (arrOutputControlCommand.count == 0 && arrInputControlCommand.count == 0 && mHubManagerInstance.arrAudioSourceDeviceManaged.count == 0) {
           //Previous code, before adding power button for Audio control
            [self.btnRightBarButton setHidden:true];
            //New code for adding power button for Audio output too.
            if(mHubManagerInstance.objSelectedOutputDevice.Index == 0 && mHubManagerInstance.objSelectedHub.isPro2Setup)
            {
                //MUTE/Unmute for Audio output in zone.
                [self.btnRightBarButton setHidden:false];
                NSString *strDisplayName = [NSString stringWithFormat:@"%@ Audio", mHubManagerInstance.objSelectedZone.zone_label];
                SectionSetting *objSection = [SectionSetting initWithTitle:strDisplayName SectionType:HDA_AudioDevice RowArray:arrOutputControlCommand];
                [arrPowerControlCommand addObject:objSection];
            }
            else
            {
                [self.btnRightBarButton setHidden:true];
            }
        } else {
            [self.btnRightBarButton setHidden:false];
            

            
            // If Output power key available
            if (arrOutputControlCommand.count > 0) {
                //NSString *strDisplayName = [NSString stringWithFormat:@"TURN ON/OFF %@ DISPLAY", objOutput.CreatedName];
                NSString *strDisplayName;
                if(mHubManagerInstance.objSelectedHub.isZPSetup && !mHubManagerInstance.objSelectedHub.isPaired){
                    strDisplayName = [NSString stringWithFormat:@"%@ DISPLAY",objOutput.CreatedName];
                }
                else
                {
                    strDisplayName = [NSString stringWithFormat:@"%@ DISPLAY", mHubManagerInstance.objSelectedZone.zone_label];
                }
                SectionSetting *objSection = [SectionSetting initWithTitle:strDisplayName SectionType:HDA_DisplayPower RowArray:arrOutputControlCommand];
                [arrPowerControlCommand addObject:objSection];
            }
            
            if (mHubManagerInstance.controlDeviceTypeSource == AVRSource) {
                // If AVR power key available
                if (arrAVRControlCommand.count > 0) {
                    //NSString *strAVRName = [NSString stringWithFormat:@"TURN ON/OFF %@", objAVR.CreatedName];
                    NSString *strAVRName = [NSString stringWithFormat:@"%@", objAVR.CreatedName];
                    SectionSetting *objSection = [SectionSetting initWithTitle:strAVRName SectionType:HDA_AVRPower RowArray:arrAVRControlCommand];
                    [arrPowerControlCommand addObject:objSection];
                }
            } else if (mHubManagerInstance.controlDeviceTypeSource == InputSource) {
                // If input power key available
                if (arrInputControlCommand.count > 0) {
                   // NSString *strSourceName = [NSString stringWithFormat:@"TURN ON/OFF %@", objInput.CreatedName];
                    NSString *strSourceName = [NSString stringWithFormat:@"%@", objInput.CreatedName];
                    SectionSetting *objSection = [SectionSetting initWithTitle:strSourceName SectionType:HDA_SourcePower RowArray:arrInputControlCommand];
                    [arrPowerControlCommand addObject:objSection];
                }
            }


            //There is no need to add AUdio in power button menu for pro2 devices.
          //  if(!mHubManagerInstance.objSelectedHub.isPro2Setup && !mHubManagerInstance.objSelectedHub.isPaired){
            /******* START:ADDED THIS CODE FOR SHOWING AUDIO IN POWER BUTTON MENU WITH MUTE/UNMUTE ******/
            if(mHubManagerInstance.objSelectedZone.arrOutputs.count == 1 )
            {
                OutputDevice *obj = [mHubManagerInstance.objSelectedZone.arrOutputs objectAtIndex:0];
                if([obj.outputType_VideoOrAudio containsString:@"audio"])
                {
                    NSString *strDisplayName = [NSString stringWithFormat:@"%@ Audio", mHubManagerInstance.objSelectedZone.zone_label];
                    SectionSetting *objSection = [SectionSetting initWithTitle:strDisplayName SectionType:HDA_AudioDevice RowArray:arrOutputControlCommand];
                    [arrPowerControlCommand addObject:objSection];
                }
                
            }
            else if(mHubManagerInstance.arrAudioSourceDeviceManaged.count > 0 && mHubManagerInstance.objSelectedZone.OutputTypeInSelectedZone != allMasterOutputs)
            {
                //NSString *strDisplayName = [NSString stringWithFormat:@"TURN ON/OFF %@ DISPLAY", objOutput.CreatedName];
                NSString *strDisplayName = [NSString stringWithFormat:@"%@ Audio", mHubManagerInstance.objSelectedZone.zone_label];
                SectionSetting *objSection = [SectionSetting initWithTitle:strDisplayName SectionType:HDA_AudioDevice RowArray:arrOutputControlCommand];
                [arrPowerControlCommand addObject:objSection];
            }
           // }
                
            /******* END ******/

            
            if(arrPowerControlCommand.count == 0)
            {
                 [self.btnRightBarButton setHidden:true];
            }
            if(arrPowerControlCommand.count == 1)
            {
                SectionSetting *objSection = [arrPowerControlCommand objectAtIndex:0];
                bool commandExp1Exist = false;
                bool commandExp2Exist = false;
                bool commandToggleExist = false;
                for (int counter = 0; counter < objSection.arrRow.count; counter++) {
                    Command *objCommand = [objSection.arrRow objectAtIndex:(NSUInteger)counter];
                    //NSLog(@"command_id %ld and name objCommand %@",(long)objCommand.command_id,objCommand.label);
                    if(objCommand.command_id == 39){
                        //NSLog(@" 39 exist command_id");
                        commandExp1Exist= true;
                    }
                    if (objCommand.command_id == 49){
                        commandExp2Exist= true;
                        //NSLog(@" 49 exist command_id");
                    }
                    if (objCommand.command_id == 38){
                        commandToggleExist = true;
                        //NSLog(@" 38 exist command_id");
                    }
                }
                if(commandExp1Exist || commandExp2Exist)
                {
                    if(commandToggleExist)
                    {
                        [self.btnRightBarButton setImage:kImageIconPowerClearColor_New forState:UIControlStateNormal];
                    }
                    else
                    {
                        [self.btnRightBarButton setImage:kImageIconPowerClearColor_New forState:UIControlStateNormal];
                    }
                }
                else
                {
                   // [self.btnRightBarButton setImage:kImageIconPowerMain forState:UIControlStateNormal];
                    [self.btnRightBarButton setImage:kImageIconPowerClearColor_New forState:UIControlStateNormal];
                }
            }
            else
            {
                [self.btnRightBarButton setImage:kImageIconPowerClearColor_New forState:UIControlStateNormal];
            }
        }
        [self.tblPowerControl reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)tapGesturePowerTableView:(UITapGestureRecognizer *)gesture {
    [self setHiddenPowerTableView:true];
}

-(void)setHiddenPowerTableView:(BOOL)isHide {
    @try {
        ThemeColor *objTheme = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColours];
        [self.tblPowerControl setBackgroundColor:objTheme.colorPowerControlBG];
        [self.viewOpaquePower setBackgroundColor:objTheme.colorBackground];
        
         //Dynamic height as per number of rown in content of table view
        CGFloat heightPower = MIN(self.tblPowerControl.bounds.size.height, self.tblPowerControl.contentSize.height);
        self.heightConstraintTblPowerControl.constant = heightPower;
        
        if (isHide) {
            /*To hide*/
            [self.tblPowerControl viewWithAnimations:^{
                [self.tblPowerControl setAlpha:0.0f];
                [self.viewOpaquePower setAlpha:0.0f];
            } AndCompletion:^(BOOL finished) {
                [self.tblPowerControl setHidden:isHide];
                [self.viewOpaquePower setHidden:isHide];
            }];
        } else {
            /*To unhide*/
            [self.tblPowerControl setHidden:isHide];
            [self.viewOpaquePower setHidden:isHide];
            [self.tblPowerControl viewWithAnimations:^{
                [self.tblPowerControl setAlpha:1.0f];
                [self.viewOpaquePower setAlpha:0.5f];
            } AndCompletion:nil];
        }
      
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrPowerControlCommand.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    SectionSetting *objSection = [arrPowerControlCommand objectAtIndex:section];
    //    return objSection.arrRow.count;
    return 1;
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
        CellPower *cell = [tableView dequeueReusableCellWithIdentifier:@"CellPower"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellPower"];
        }
        if(arrPowerControlCommand.count > 0){
//        cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorPowerControlBG;
//        [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorPowerControlBorder BorderWidth:1.0];
//        [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorPowerControlText];
        
        SectionSetting *objSection = [arrPowerControlCommand objectAtIndex:indexPath.section];
        cell.lblName.text = [objSection.Title uppercaseString];
        if(objSection.sectionType == HDA_AudioDevice)
        {
             cell.imgConnected.image = kImageIconPowerMain;
        }
        for (int counter = 0; counter < objSection.arrRow.count; counter++) {
            Command *objCommand = [objSection.arrRow objectAtIndex:(NSUInteger)counter];
            
            if(objCommand.command_id == 39 || objCommand.command_id == 49)
            {
                cell.imgConnected.image = kImageIconPowerExplicitBlue;
            }
            else
            {
                cell.imgConnected.image = kImageIconPowerMain;
            }
        }
        }
        
        
        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(Command*)getCommandData:(NSInteger)command_id commandArray:(NSMutableArray *)arrRow{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"command_id == %d", command_id];
    NSArray *arrCmdDataFiltered = [arrRow filteredArrayUsingPredicate:predicate];
    Command *objCmdData = nil;
    objCmdData =  arrCmdDataFiltered.count > 0 ? arrCmdDataFiltered.firstObject : nil;
    return objCmdData;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        SectionSetting *objSection = [arrPowerControlCommand objectAtIndex:indexPath.section];
        [[CustomAVPlayer sharedInstance] soundPlay:Beep];
        CellPower *cell = [self.tblPowerControl cellForRowAtIndexPath:indexPath];
        switch (objSection.sectionType) {
            case HDA_DisplayPower:
                // Previously only command 38 was sent, but below code is new changes for command 39 and 49.
                //[APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[[objSection.arrRow firstObject]] PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo];
                //New code
                if(cell.imgConnected.image == kImageIconPowerExplicitBlue)
                {
                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:49 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo  TouchType:Normal];
                }
                else{
                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:38 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo  TouchType:Normal];
                }

                
                //                for (int counter = 0; counter < objSection.arrRow.count; counter++) {
                //                    Command *objCommand = [objSection.arrRow objectAtIndex:(NSUInteger)counter];
                //                    if(objCommand.command_id == 39 || objCommand.command_id == 49)
                //                    {
                //                        [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:49 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo];
                //                    }
                //                    else
                //                    {
                //                        [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:38 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo];
                //                    }
                //                }

                break;
            case HDA_SourcePower:
                // Previously only command 38 was sent, but below code is new changes for command 39 and 49.
                // [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[objSection.arrRow firstObject] PortNo:mHubManagerInstance.objSelectedInputDevice.PortNo];
                //New code
                if(cell.imgConnected.image == kImageIconPowerExplicitBlue)
                {
                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:49 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedInputDevice.PortNo  TouchType:Normal];
                }
                else{
                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:38 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedInputDevice.PortNo  TouchType:Normal];
                }
                break;
            case HDA_AVRPower:
                // Previously only command 38 was sent, but below code is new changes for command 39 and 49.
                
                //[APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[objSection.arrRow firstObject] PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo];
                //New code
                if(cell.imgConnected.image == kImageIconPowerExplicitBlue)
                {
                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:49 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo  TouchType:Normal];
                }
                else{
                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:38 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo  TouchType:Normal];
                }
                break;
                case HDA_AudioDevice:
                if(mHubManagerInstance.objSelectedZone.isMute){
                // Audio changes for single slave-OLD
                    mHubManagerInstance.objSelectedZone.isMute = false;
                [APIManager controlMuteAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id Mute:false];
                }
                else{
                      mHubManagerInstance.objSelectedZone.isMute = true;
                    [APIManager controlMuteAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id Mute:true];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMuteStateChanged object:self];

                break;
            
            default:
                break;
        }
        [self setHiddenPowerTableView:true];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
- (void)longPressRecognizerHandler_ReorderTableview:(id)sender {
    @try {
        //    if (self.isEdit) {
        // self.isEdit = true;
        // [self.btnEditDone setHidden:false];
        // [self.tableView reloadData];
        
        UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
        UIGestureRecognizerState state = longPress.state;
        
        CGPoint location = [longPress locationInView:self.tblPowerControl];
        NSIndexPath *indexPath = [self.tblPowerControl indexPathForRowAtPoint:location];
        
        static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
        static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
        
        switch (state) {
            case UIGestureRecognizerStateBegan: {
                if (indexPath) {
                    @try {
                        SectionSetting *objSection = [arrPowerControlCommand objectAtIndex:indexPath.section];
                        [[CustomAVPlayer sharedInstance] soundPlay:Beep];
                        CellPower *cell = [self.tblPowerControl cellForRowAtIndexPath:indexPath];
                        switch (objSection.sectionType) {
                            case HDA_DisplayPower:
                                // Previously only command 38 was sent, but below code is new changes for command 39 and 49.
                                //[APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[objSection.arrRow firstObject] PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo];
                                //New code
                                if(cell.imgConnected.image == kImageIconPowerExplicitBlue)
                                {
                                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:39 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo  TouchType:Normal];
                                }
                                
                                break;
                            case HDA_SourcePower:
                                
                                // Previously only command 38 was sent, but below code is new changes for command 39 and 49.
                                //[APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[objSection.arrRow firstObject] PortNo:mHubManagerInstance.objSelectedInputDevice.PortNo];
                                //New code
                                if(cell.imgConnected.image == kImageIconPowerExplicitBlue)
                                {
                                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:39 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedInputDevice.PortNo  TouchType:Normal];
                                }
                                break;
                            case HDA_AVRPower:
                                
                                // Previously only command 38 was sent, but below code is new changes for command 39 and 49.
                                //[APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[objSection.arrRow firstObject] PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo];
                                //New code
                                if(cell.imgConnected.image == kImageIconPowerExplicitBlue)
                                {
                                    [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:[self getCommandData:39 commandArray:objSection.arrRow] PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo  TouchType:Normal];
                                }
                                break;
                            default:
                                break;
                        }
                        [self setHiddenPowerTableView:true];
                    } @catch (NSException *exception) {
                        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
                    }
                }
                break;
            }
                
            case UIGestureRecognizerStateChanged: {
                CGPoint center = snapshot.center;
                center.y = location.y;
                snapshot.center = center;
                
                
                break;
            }
                
            default: {
                // Clean up.
                UITableViewCell *cell = [self.tblPowerControl cellForRowAtIndexPath:sourceIndexPath];
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



#pragma mark - Method apiGetmHubDetails
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
                [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
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
                [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
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
