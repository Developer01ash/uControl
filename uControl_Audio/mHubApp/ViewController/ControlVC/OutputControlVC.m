//
//  OutputControlVC.m
//  mHubApp
//
//  Created by Anshul Jain on 22/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
 This is the container view, Child Class of InputOutputConatinerVC.
 This class is dedicated to following:
    1. Output/display volume for display devices.
    2. AVR volume handling for Video.
    3. Zone Volume handling in Audio.
    4. Group Volume handing in Audio.
 */

#import "OutputControlVC.h"
#import <QuartzCore/QuartzCore.h>

#define kPortraitContraintConstant 0
#define kLandscapeContraintConstant 0
#define kPortraitContraintConstantiPhone 0

@interface OutputControlVC ()<CustomAVPlayerDelegate> {
    int tapCount;
    NSInteger lastVolumeValue;
    BOOL lastMuteStatus;
    NSInteger intLastInputSelected;
    double timerSeconds_PlusButton;
    double timerSeconds_MinusButton;
    TouchActivity touchActivity_PlusBtn;
    TouchActivity touchActivity_MinusBtn;
    NSTimer *timerObjButton;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgHDALogo;
@property (weak, nonatomic) IBOutlet UIView *viewDisplayControl;

@property (weak, nonatomic) IBOutlet CustomButtonForControls *btnOutputAVRAudioSwitch;
@property (weak, nonatomic) IBOutlet UIView *viewVolume;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewVolumeBG;
@property (weak, nonatomic) IBOutlet CustomButtonForControls *btnVolumeMinus;
@property (weak, nonatomic) IBOutlet UILabel *lblTVVolume;
@property (weak, nonatomic) IBOutlet CustomButtonForControls *btnVolumePlus;
@property (weak, nonatomic) IBOutlet CustomButtonForControls *btnVolumeMute;

@property (weak, nonatomic) IBOutlet UIView *viewAudioSlider;
@property (weak, nonatomic) IBOutlet SSTTapSlider *sliderAudioVolume;
@property (weak, nonatomic) IBOutlet CustomButtonForControls *btnMHUBAudioOutput;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *gestureLongPressButtonOutputAVRAudioSwitch;

@property (nonatomic, retain) NSArray *arrControlCommand;

@end

@implementation OutputControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    @try {
        self.navigationItem.backBarButtonItem = customBackBarButton;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadOutputControl object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationReloadOutputControl
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadOutputControlSlider object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotificationSlider:)
                                                     name:kNotificationReloadOutputControlSlider
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadOutputControlLabel object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotificationLabel:)
                                                     name:kNotificationReloadOutputControlLabel
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationMuteStateChanged object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationMuteStateChanged
                                                   object:nil];




        
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadInputOutputContainer object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(receiveNotificationNew:)
//                                                     name:kNotificationReloadInputOutputContainer
//                                                   object:nil];

        tapCount = 0; // Count tap on Slider

       // [[CustomAVPlayer sharedInstance] setHardwareVolumeControl];
       // [CustomAVPlayer sharedInstance].delegate = self;

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    @try {
        [self selectedDeviceReloadData:false];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture_HandlePlus:)];
        [longPress setDelegate:self];
        [longPress setCancelsTouchesInView:true];
        [self.btnVolumePlus addGestureRecognizer:longPress];
        
        UILongPressGestureRecognizer *longPressMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture_HandleMinus:)];
        [longPressMinus setDelegate:self];
        [longPressMinus setCancelsTouchesInView:true];
        [self.btnVolumeMinus addGestureRecognizer:longPressMinus];
        
        touchActivity_PlusBtn = Normal;
        touchActivity_MinusBtn = Normal;
        
       
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    @try {

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)longPressGesture_HandlePlus:(UILongPressGestureRecognizer*)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"UIGestureRecognizerStateBegan BUTTON");
           self->timerObjButton =  [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer *timer) {
                self->timerSeconds_PlusButton = self->timerSeconds_PlusButton + 0.1;
              // NSLog(@"TOUCHES for %f",self->timerSeconds_PlusButton);//finger touch went right
                if (self->timerSeconds_PlusButton >= [AppDelegate appDelegate].pressVal && self->touchActivity_PlusBtn == Normal) {
                    CustomButton *btnSender = (CustomButton *)sender.view;
                    self->touchActivity_PlusBtn = Normal;
                    [self btnVolumePlus_Clicked:btnSender];
                    self->touchActivity_PlusBtn = Hold;
                }
                if (self->timerSeconds_PlusButton >= [AppDelegate appDelegate].holdVal && self->touchActivity_PlusBtn == Hold) {
//                    [self->timerObjButton invalidate];
//                    self->timerObjButton = nil;
                    self->timerSeconds_PlusButton = 0.0;
                    CustomButton *btnSender = (CustomButton *)sender.view;
                    self->touchActivity_PlusBtn = Hold;
                    [self btnVolumePlus_Clicked:btnSender];
                }
                else{
//                    [self->timerObjButton invalidate];
//                    self->timerObjButton = nil;
                }
            }];
            
           // NSLog(@"UIGestureRecognizerStateBegan BUTTON ");
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            //NSLog(@"UIGestureRecognizerStateChanged  BUTTON");
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self->timerObjButton invalidate];
            self->timerObjButton = nil;
            self->timerSeconds_PlusButton = 0.0;
            CustomButton *btnSender = (CustomButton *)sender.view;
            if(self->touchActivity_PlusBtn == Hold){
                self->touchActivity_PlusBtn = Release;
                [self btnVolumePlus_Clicked:btnSender];
                self->touchActivity_PlusBtn = Normal;
            }
            else if(timerSeconds_PlusButton < [AppDelegate appDelegate].pressVal){
                self->touchActivity_PlusBtn = Normal;
                [self btnVolumePlus_Clicked:btnSender];
                
            }
            NSLog(@"UIGestureRecognizerStateEnded  BUTTON ");
        }
        default:
            break;
    }
}

-(void)longPressGesture_HandleMinus:(UILongPressGestureRecognizer*)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"UIGestureRecognizerStateBegan BUTTON");
           self->timerObjButton =  [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer *timer) {
                self->timerSeconds_MinusButton = self->timerSeconds_MinusButton + 0.1;
               //NSLog(@"TOUCHES for %f",self->timerSeconds_MinusButton);//finger touch went right
                if (self->timerSeconds_MinusButton >= [AppDelegate appDelegate].pressVal && self->touchActivity_MinusBtn == Normal) {
                    CustomButton *btnSender = (CustomButton *)sender.view;
                    self->touchActivity_MinusBtn = Normal;
                    [self btnVolumeMinus_Clicked:btnSender];
                    self->touchActivity_MinusBtn = Hold;
                }
                if (self->timerSeconds_MinusButton >= [AppDelegate appDelegate].holdVal && self->touchActivity_MinusBtn == Hold) {
//                    [self->timerObjButton invalidate];
//                    self->timerObjButton = nil;
                    self->timerSeconds_MinusButton = 0.0;
                    CustomButton *btnSender = (CustomButton *)sender.view;
                    self->touchActivity_MinusBtn = Hold;
                    [self btnVolumeMinus_Clicked:btnSender];
                }
                else{
//                    [self->timerObjButton invalidate];
//                    self->timerObjButton = nil;
                }
            }];
            
            NSLog(@"UIGestureRecognizerStateBegan BUTTON ");
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
          //  NSLog(@"UIGestureRecognizerStateChanged  BUTTON");
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self->timerObjButton invalidate];
            self->timerObjButton = nil;
            self->timerSeconds_MinusButton = 0.0;
            CustomButton *btnSender = (CustomButton *)sender.view;
            if(self->touchActivity_MinusBtn == Hold){
                self->touchActivity_MinusBtn = Release;
                [self btnVolumeMinus_Clicked:btnSender];
                self->touchActivity_MinusBtn = Normal;
            }
            else if(timerSeconds_MinusButton < [AppDelegate appDelegate].pressVal){
                self->touchActivity_MinusBtn = Normal;
                [self btnVolumeMinus_Clicked:btnSender];
                
            }
            
            NSLog(@"UIGestureRecognizerStateEnded  BUTTON ");
            break;
        }
        default:
            break;
    }
}

#pragma mark - NSNotification receiver methods
- (void) receiveNotification:(NSNotification *) notification {
    DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
    @try {
        
        if ([[notification name] isEqualToString:kNotificationMuteStateChanged]) {
              Zone *objZone = mHubManagerInstance.objSelectedZone;
                Group *objGroup = mHubManagerInstance.objSelectedGroup;

            if ([objGroup isNotEmpty] && mHubManagerInstance.objSelectedHub.HubZoneData.count > 0) {
                              [self setSliderAudioVolume:objGroup InputIndex:objZone.audio_input];
                          } else {
                              [self setSliderAudioVolume:objZone InputIndex:objZone.audio_input];
                          }
        }
        else{
        [self selectedDeviceReloadData:false];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) receiveNotificationSlider:(NSNotification *) notification {
    DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
    @try {
        //testgroupchanges ok
        // DDLogDebug(@"Notification Info == %@", notification.userInfo);
        NSInteger intAverage = [[notification.userInfo valueForKey:kSLIDERAVERAGE] integerValue];
        [self.sliderAudioVolume setValue:intAverage];
        lastVolumeValue = intAverage;
        [self setSliderTrackColor:self.sliderAudioVolume];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) receiveNotificationLabel:(NSNotification *) notification {
    DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
    @try {
        //testgroupchanges ok
        // DDLogDebug(@"Notification Info == %@", notification.userInfo);
        NSInteger intInputIndex = [[notification.userInfo valueForKey:kINPUTINDEX] integerValue];
        [self btnMHUBAudioOutputLabeling:lastMuteStatus InputIndex:intInputIndex];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) selectedDeviceReloadData:(BOOL)isAnimated {
    @try {
        DDLogDebug(@"%s", __FUNCTION__);
        [self.view setBackgroundColor:[AppDelegate appDelegate].themeColours.colorControlOutputBackground];
        [self.imgViewVolumeBG setTintColor:[AppDelegate appDelegate].themeColours.colorControlOutputVolumeBG];
        UIImage *image = [kImageIconTVWrapper imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        [self.imgViewVolumeBG setImage:image];
        [self.lblTVVolume setFont:textFontRegular10];
        [self.btnMHUBAudioOutput.titleLabel setFont:textFontRegular10];
        BOOL deviceSetup_ARC;
         if([mHubManagerInstance.objSelectedHub isPro2Setup] || [mHubManagerInstance.objSelectedHub is411Setup] ){
             deviceSetup_ARC = true;
         }
         else
         {
             deviceSetup_ARC = false;
         }
        OutputDevice *objOutput = mHubManagerInstance.objSelectedOutputDevice;
        AVRDevice *objAVR = mHubManagerInstance.objSelectedAVRDevice;
        Zone *objZone = mHubManagerInstance.objSelectedZone;
        Group *objGroup = mHubManagerInstance.objSelectedGroup;

        BOOL isContainVideoOutput = false;
        for (int i = 0; i < objZone.arrOutputs.count; i++) {
        OutputDevice *obj = [objZone.arrOutputs objectAtIndex:i];
        if([obj.outputType_VideoOrAudio containsString:@"video"] || [obj.UnitId isEqualToString:@"M1"])
        {
            isContainVideoOutput = true;
        }
        ////NSLog(@"array output %@  %@  %ld",obj.CreatedName,obj.Name,(long)obj.Index);
        }
//           if([mHubManagerInstance.objSelectedHub isZPSetup] && ![mHubManagerInstance.objSelectedHub isPairedSetup])
//        {
//                [self.viewDisplayControl viewFadeOut_FadeIn:self.imgHDALogo];
//                return;
//        }

        if ([mHubManagerInstance.objSelectedHub isAPIV2] && [objZone isNotEmpty]) {
            mHubManagerInstance.controlDeviceTypeBottom = objZone.bottomControlDevice;
//            if([mHubManagerInstance.objSelectedHub isPro2Setup]){
//                mHubManagerInstance.controlDeviceTypeBottom = HybridSource;
//            }
//            else if([mHubManagerInstance.objSelectedHub isPro2Setup] && !isContainVideoOutput){
//            mHubManagerInstance.controlDeviceTypeBottom = AudioSource;
//            }
        } else if ([objOutput isNotEmpty]) {
            mHubManagerInstance.controlDeviceTypeBottom = objOutput.selectedControlDeviceType;
        }
       
        if(mHubManagerInstance.controlDeviceTypeSource == AVRSource && mHubManagerInstance.objSelectedAVRDevice.isIRPack)
        {
            mHubManagerInstance.controlDeviceTypeBottom = AVRSource;
        }
//        
        switch (mHubManagerInstance.controlDeviceTypeBottom) {
            case OutputScreen: {
                if (objOutput.objCommandType.volume.count == 0) {
                    if(([mHubManagerInstance.objSelectedHub isPro2Setup] || [mHubManagerInstance.objSelectedHub is411Setup] )&& isContainVideoOutput ){
                                  self.arrControlCommand = [[NSArray alloc] initWithArray:objOutput.objCommandType.volume];
                                  [self.btnOutputAVRAudioSwitch setImage: deviceSetup_ARC?kImageIconTVSpeakerDisplay:kImageIconTVDisplay forState:UIControlStateNormal];
                                  [self.lblTVVolume setText:@"TV"];
                                  [self.btnVolumeMute setImage:kImageIconTVMute forState:UIControlStateNormal];
                    }
                    else{
                    [self setSelectedDeviceToGlobalObject:AVRSource];
                    [self selectedDeviceReloadData:false];
                    }
                    break;
                } else {
                    self.arrControlCommand = [[NSArray alloc] initWithArray:objOutput.objCommandType.volume];
                    [self.btnOutputAVRAudioSwitch setImage: deviceSetup_ARC?kImageIconTVSpeakerDisplay:kImageIconTVDisplay forState:UIControlStateNormal];
                    [self.lblTVVolume setText:@"TV"];
                    [self.btnVolumeMute setImage:kImageIconTVMute forState:UIControlStateNormal];
                }
                break;
            }
            case HybridSource: {
                self.arrControlCommand = [[NSArray alloc] initWithArray:objOutput.objCommandType.volume];
                [self.btnOutputAVRAudioSwitch setImage:kImageIconTVSpeakerDisplay forState:UIControlStateNormal];
                [self.lblTVVolume setText:@"TV"];
                [self.btnVolumeMute setImage:kImageIconTVMute forState:UIControlStateNormal];
                break;
//                           if (objOutput.objCommandType.volume.count == 0) {
//                               if([mHubManagerInstance.objSelectedHub isPro2Setup] && isContainVideoOutput ){
//                                             self.arrControlCommand = [[NSArray alloc] initWithArray:objOutput.objCommandType.volume];
//                                             [self.btnOutputAVRAudioSwitch setImage:kImageIconTVSpeakerDisplay forState:UIControlStateNormal];
//                                             [self.lblTVVolume setText:@"TV"];
//                                             [self.btnVolumeMute setImage:kImageIconTVMute forState:UIControlStateNormal];
//                               }
//                               else{
//                               [self setSelectedDeviceToGlobalObject:AVRSource];
//                               [self selectedDeviceReloadData:false];
//                               }
//                               break;
//                           }
                       }
            case AVRSource: {
                if(objZone.OutputTypeInSelectedZone  == audioOnly || (objAVR.objCommandType.volume.count == 0 && [mHubManagerInstance.objSelectedHub isPairedSetup]))
                
                {
                    [self setSelectedDeviceToGlobalObject:AudioSource];
                    [self selectedDeviceReloadData:false];
                    return;
                } else {
                    self.arrControlCommand = [[NSArray alloc] initWithArray:objAVR.objCommandType.volume];
                    [self.btnOutputAVRAudioSwitch setImage:kImageIconTVAVR forState:UIControlStateNormal];
                    [self.lblTVVolume setText:@"AVR"];
                    [self.btnVolumeMute setImage:kImageIconTVMute forState:UIControlStateNormal];
                }
                break;
            }
            case AudioSource: {
                self.arrControlCommand = [[NSArray alloc] init];
                 [self.btnOutputAVRAudioSwitch setImage:kImageIconTVAUDIO forState:UIControlStateNormal];
                
               // [self.btnOutputAVRAudioSwitch setImage:[mHubManagerInstance.objSelectedHub isPro2Setup]?kImageIconTVSpeakerDisplay:kImageIconTVAUDIO forState:UIControlStateNormal];
                // Check for Group available
                if ([objGroup isNotEmpty] && mHubManagerInstance.objSelectedHub.HubZoneData.count > 0) {
                    [self setSliderAudioVolume:objGroup InputIndex:objZone.audio_input];
                } else {
                    [self setSliderAudioVolume:objZone InputIndex:objZone.audio_input];
                }
                break;
            }
            default: {
                if (objOutput.objCommandType.volume.count == 0) {
                  //  [self.viewDisplayControl viewFadeOut_FadeIn:self.imgHDALogo];
                    [self setSelectedDeviceToGlobalObject:OutputScreen];
                    [self selectedDeviceReloadData:false];
                    return;
                } else {
                    self.arrControlCommand = [[NSArray alloc] initWithArray:objOutput.objCommandType.volume];
                    [self.btnOutputAVRAudioSwitch setImage:deviceSetup_ARC?kImageIconTVSpeakerDisplay:kImageIconTVDisplay forState:UIControlStateNormal];
                    [self.lblTVVolume setText:@"TV"];
                    [self.btnVolumeMute setImage:kImageIconTVMute forState:UIControlStateNormal];
                    if([mHubManagerInstance.objSelectedHub isPro2Setup] || [mHubManagerInstance.objSelectedHub is411Setup])
                    {
                        [self setSelectedDeviceToGlobalObject:HybridSource];
                    }
                    else
                    {
                        [self setSelectedDeviceToGlobalObject:OutputScreen];
                    }
                }
                break;
            }
        }
        
        
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
                            }
                        }
        
                    }
        //New Code by ANSHUL
        if ((mHubManagerInstance.objSelectedHub.AVR_IRPack && objAVR.objCommandType.volume.count > 0) || ([mHubManagerInstance.objSelectedHub isPairedSetup])) {
            if( (mHubManagerInstance.objSelectedHub.AVR_IRPack && objOutput.objCommandType.volume.count  != 0))
            {
                self.btnOutputAVRAudioSwitch.userInteractionEnabled = true;
            }
            else if(newTempArr.count == 0  && objOutput.objCommandType.volume.count  == 0)
            {
                 self.btnOutputAVRAudioSwitch.userInteractionEnabled = false;
            }
            else if(newTempArr.count == 0  && mHubManagerInstance.objSelectedHub.AVR_IRPack)
            {
                self.btnOutputAVRAudioSwitch.userInteractionEnabled = false;
            }
            else{
                self.btnOutputAVRAudioSwitch.userInteractionEnabled = true;
            }
        }
        else if([mHubManagerInstance.objSelectedHub isPro2Setup] || [mHubManagerInstance.objSelectedHub is411Setup]){
             self.btnOutputAVRAudioSwitch.userInteractionEnabled = true;
           // mHubManagerInstance.controlDeviceTypeBottom = AudioSource;
        }
        else {
                        self.btnOutputAVRAudioSwitch.userInteractionEnabled = false;
        }
        //Older Code
//            if ((mHubManagerInstance.objSelectedHub.AVR_IRPack && objAVR.objCommandType.volume.count > 0) || ([mHubManagerInstance.objSelectedHub isPairedSetup])) {

//        } else {
//            self.btnOutputAVRAudioSwitch.userInteractionEnabled = false;
//        }
        
        if (mHubManagerInstance.controlDeviceTypeBottom == AudioSource) {
            
//            NSMutableArray *newTempArr = [[NSMutableArray alloc] init];
//            for(int i = 0 ; i < [mHubManagerInstance.arrAudioSourceDeviceManaged count]; i++)
//            {
//
//                InputDevice *objInput = [mHubManagerInstance.arrAudioSourceDeviceManaged objectAtIndex:i];
//                NSMutableArray *arrOutDevice = [[NSMutableArray alloc] initWithArray:mHubManagerInstance.objSelectedZone.arrOutputs];
//
//                for(int i = 0 ; i < [arrOutDevice count]; i++)
//                {
//                    OutputDevice *outputObj = (OutputDevice *)[arrOutDevice objectAtIndex:i];
//                    if([objInput.UnitId isEqualToString:outputObj.UnitId ])
//
//                    {
//                        [newTempArr addObject:objInput];
//                    }
//                }
//
//            }
//
           if(newTempArr.count == 0)
           {

              // [self.viewDisplayControl setHidden:true];
               [self.viewDisplayControl viewFadeOut_FadeIn:self.imgHDALogo];
           }
            else
            {

            [self.imgHDALogo viewFadeOut_FadeIn:self.viewDisplayControl];

            [self.btnVolumePlus fadeOutWithCompletion:^(BOOL finished) {
                [self.btnVolumePlus setHidden:true];
            }];
            [self.lblTVVolume fadeOutWithCompletion:^(BOOL finished) {
                [self.lblTVVolume setHidden:true];
            }];
            [self.btnVolumeMinus fadeOutWithCompletion:^(BOOL finished) {
                [self.btnVolumeMinus setHidden:true];
            }];
            [self.viewVolume viewShapeFadeOut_FadeIn:self.viewAudioSlider];
           
             [self.viewAudioSlider fadeInWithCompletion:^(BOOL finished) {
                           [self.viewAudioSlider setHidden:false];
                       }];
            [self.btnVolumeMute fadeInWithCompletion:^(BOOL finished) {
                               [self.btnVolumeMute setHidden:false];
                           }];
             
               
//            if(![mHubManagerInstance.objSelectedHub isPro2Setup]){
//            [self.viewVolume viewShapeFadeOut_FadeIn:self.viewAudioSlider];
//            }
//            else
//            {
//                [self.btnVolumeMute fadeOutWithCompletion:^(BOOL finished) {
//                                   [self.btnVolumeMute setHidden:true];
//                               }];
//                [self.viewVolume.subviews setValue:@YES forKeyPath:@"hidden"];
//            }
            //Changes for Group audio animation. Anshul 30 Jan
//            if (self.delegate) {
//                [self.delegate didReceivedReloadGroupVolume:Uncontrollable];
//            }
            }
            if (self.delegate) {
                [self.delegate didReceivedReloadGroupVolume:Uncontrollable];
                [self.delegate didReceivedReloadAudioDevice:Uncontrollable];
                
            }
        }
    else {
            if (self.delegate) {
                [self.delegate didReceivedReloadGroupVolume:Uncontrollable];
                [self.delegate didReceivedReloadAudioDevice:Uncontrollable];
                
            }
        if([objOutput.CreatedName containsString:@"CEC"] && ![[NSUserDefaults standardUserDefaults]boolForKey:@"FLAG_CecVolume"])
        {
            [self.viewDisplayControl viewFadeOut_FadeIn:self.imgHDALogo];
            return;
        }
            if (self.arrControlCommand.count != 0) {
            [self.viewAudioSlider viewShapeFadeOut_FadeIn:self.viewVolume];
            [self.btnVolumePlus fadeInWithCompletion:^(BOOL finished) {
                [self.btnVolumePlus setHidden:false];
            }];
            [self.lblTVVolume fadeInWithCompletion:^(BOOL finished) {
                [self.lblTVVolume setHidden:false];
            }];
            [self.btnVolumeMinus fadeInWithCompletion:^(BOOL finished) {
                [self.btnVolumeMinus setHidden:false];
            }];
            }
            
          if (self.arrControlCommand.count == 0) {
               // if(![mHubManagerInstance.objSelectedHub isPro2Setup]){
                   //[self.viewDisplayControl viewFadeOut_FadeIn:self.imgHDALogo];
                    self.btnVolumePlus.infoData = nil;
                    self.btnVolumeMinus.infoData = nil;
                    self.btnVolumeMute.infoData = nil;
                
                [self.viewAudioSlider fadeOutWithCompletion:^(BOOL finished) {
                    [self.viewAudioSlider setHidden:true];
                    [self.viewAudioSlider.subviews setValue:@YES forKeyPath:@"hidden"];
                }];
                [self.viewVolume fadeOutWithCompletion:^(BOOL finished) {
                    [self.viewVolume setHidden:true];
                    [self.viewVolume.subviews setValue:@YES forKeyPath:@"hidden"];
                }];
                [self.btnVolumeMute fadeOutWithCompletion:^(BOOL finished) {
                    [self.btnVolumeMute setHidden:true];
                }];
              if (mHubManagerInstance.controlDeviceTypeBottom == AVRSource) {
                  [self.viewDisplayControl viewFadeOut_FadeIn:self.imgHDALogo];

              }
            } else {
                [self.btnOutputAVRAudioSwitch fadeInWithCompletion:^(BOOL finished) {
                    [self.btnOutputAVRAudioSwitch setHidden:false];
                }];
                [self.btnVolumeMute fadeInWithCompletion:^(BOOL finished) {
                    [self.btnVolumeMute setHidden:false];
                }];
                [self.imgHDALogo viewFadeOut_FadeIn:self.viewDisplayControl];
                
                for (Command *obj in self.arrControlCommand) {
                    switch (obj.command_id) {
                        case VolUp: {
                            self.btnVolumePlus.infoData = obj;
                            self.btnVolumePlus.enabled = obj.isVisible;
                        }
                            break;
                        case VolDown: {
                            self.btnVolumeMinus.infoData = obj;
                            self.btnVolumeMinus.enabled = obj.isVisible;
                        }
                            break;
                        case VolMute: {
                            self.btnVolumeMute.infoData = obj;
                            self.btnVolumeMute.enabled = obj.isVisible;
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) setSelectedDeviceToGlobalObject:(ControlDeviceType)selectedDevice {
    @try {
        mHubManagerInstance.controlDeviceTypeBottom = selectedDevice;

        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            mHubManagerInstance.objSelectedZone.bottomControlDevice = mHubManagerInstance.controlDeviceTypeBottom;
            for (int counter = 0; counter < mHubManagerInstance.objSelectedHub.HubZoneData.count; counter++) {
                Zone *objOP = [mHubManagerInstance.objSelectedHub.HubZoneData objectAtIndex:counter];
                if ([objOP.zone_id isEqualToString:mHubManagerInstance.objSelectedZone.zone_id]) {
                    objOP.bottomControlDevice = mHubManagerInstance.controlDeviceTypeBottom;
                    [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:counter withObject:objOP];
                    break;
                }
            }
            // Leftpanel Data Arrange
            [mHubManagerInstance reSyncLeftPanelDataV2];
        } else {
            mHubManagerInstance.objSelectedOutputDevice.selectedControlDeviceType = mHubManagerInstance.controlDeviceTypeBottom;
            for (int counter = 0; counter < mHubManagerInstance.objSelectedHub.HubOutputData.count; counter++) {
                OutputDevice *objOP = [mHubManagerInstance.objSelectedHub.HubOutputData objectAtIndex:counter];
                if (objOP.Index == mHubManagerInstance.objSelectedOutputDevice.Index) {
                    objOP.selectedControlDeviceType = mHubManagerInstance.controlDeviceTypeBottom;
                    [mHubManagerInstance.objSelectedHub.HubOutputData replaceObjectAtIndex:counter withObject:objOP];
                    break;
                }
            }
            // Leftpanel Data Arrange
            [mHubManagerInstance reSyncLeftPanelData];
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

#pragma mark - DISPLAY/AVR/AUDIO Button Click Methods
- (IBAction)btnOutputAVRAudioSwitch_Clicked:(id)sender {
    @try {
        [[CustomAVPlayer sharedInstance] soundPlay:Click];
        CustomButtonForControls *btnSender = (CustomButtonForControls *)sender;
        [btnSender leftSlideWithCompletion:^(BOOL finished) {
            [self btnDisplayAVRAudioImage_Update:btnSender];
            [btnSender rightSlideWithCompletion:^(BOOL finished) {
                [self selectedDeviceReloadData:true];
            }];
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)btnDisplayAVRAudioImage_Update:(CustomButtonForControls*)btnSender {
    @try {
        BOOL deviceSetup_ARC;
        if([mHubManagerInstance.objSelectedHub isPro2Setup] || [mHubManagerInstance.objSelectedHub is411Setup] ){
            deviceSetup_ARC = true;
        }
        else
        {
            deviceSetup_ARC = false;
        }
        
        
        if ([btnSender.currentImage isEqual:deviceSetup_ARC?kImageIconTVSpeakerDisplay:kImageIconTVDisplay] && mHubManagerInstance.objSelectedHub.AVR_IRPack) {
            //[btnSender setImage:kImageIconTVAVR forState:UIControlStateNormal];
            if( mHubManagerInstance.objSelectedZone.OutputTypeInSelectedZone == audioOnly)
            {
                 mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
            }
            else{
                mHubManagerInstance.controlDeviceTypeBottom = AVRSource;
            }
                 
            
            
        } else if (([btnSender.currentImage isEqual:kImageIconTVAVR] || [btnSender.currentImage isEqual:deviceSetup_ARC?kImageIconTVSpeakerDisplay:kImageIconTVDisplay]) && ([mHubManagerInstance.objSelectedHub isPairedSetup] || [mHubManagerInstance.objSelectedHub isPro2Setup]) ) {
            //[btnSender setImage:kImageIconTVAUDIO forState:UIControlStateNormal];
            // There is no need to show single speaker icon in PRO2 devices because there is hybrid icon which will handle UI for TV as well as speaker too. so single click will be TV and long press will load Audio source. So we are writing below condition if device is pro2 then this will be toggle only between TV(Hybrid icon) and AVR(If exists). so pro2 device will again load TV/hybrid after the AVR. BELOW IF CONDITIONS WRITTEN FOR THE SAME OTHERWISE It toggles between, TV, AVR and single speaker icon.
            if([mHubManagerInstance.objSelectedHub isPro2Setup] && mHubManagerInstance.objSelectedZone.arrOutputs.count > 1 ){
                OutputDevice *unitIdat0 = [mHubManagerInstance.objSelectedZone.arrOutputs objectAtIndex:0];
                OutputDevice *unitIdat1 = [mHubManagerInstance.objSelectedZone.arrOutputs objectAtIndex:1];
                
                if(([unitIdat0.UnitId containsString:@"M"] && [unitIdat1.UnitId containsString:@"M"]) ||  ([unitIdat0.UnitId containsString:@"H"] && [unitIdat1.UnitId containsString:@"H"])){
                     mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
                }
                else
                {
                     mHubManagerInstance.controlDeviceTypeBottom = AudioSource;
                }
            }
            else if([mHubManagerInstance.objSelectedHub isPro2Setup] )
            {
                mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
            }
            else if([mHubManagerInstance.objSelectedHub isZPSetup] && mHubManagerInstance.objSelectedZone.arrOutputs.count >= 1 )
            {
                if( mHubManagerInstance.objSelectedZone.OutputTypeInSelectedZone == audioVideoZone){
                    mHubManagerInstance.controlDeviceTypeBottom = AudioSource;
                }else{
                mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
                }
            }
            else
            {
                mHubManagerInstance.controlDeviceTypeBottom = AudioSource;
            }

        } else {
            mHubManagerInstance.controlDeviceTypeBottom = OutputScreen;
        }
        [self setSelectedDeviceToGlobalObject:mHubManagerInstance.controlDeviceTypeBottom];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


- (void) receiveNotificationNew:(NSNotification *) notification {
    @try {
      //  [self performSelector:@selector(callScreen) withObject:nil afterDelay:3.0];
        // DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
//                if (mHubManagerInstance.controlDeviceTypeBottom == AudioSource) {
//                    if (self.delegate) {
//                        [self.delegate didReceivedReloadGroupVolume:Uncontrollable];
//                        [self.delegate didReceivedReloadAudioDevice:AudioSource];
//                    }
//                } else {
//                    if (self.delegate) {
//                        [self.delegate didReceivedReloadGroupVolume:Uncontrollable];
//                        [self.delegate didReceivedReloadAudioDevice:AudioSource];
//                    }
//                }
      //  [self btnOutputAVRAudioSwitch_LongPress:nil];
 
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)callScreen
{
    if (self.delegate) {
        [self.delegate didReceivedReloadGroupVolume:Uncontrollable];
        [self.delegate didReceivedReloadAudioDevice:AudioSource];
    }
}

- (IBAction)btnOutputAVRAudioSwitch_LongPress:(UILongPressGestureRecognizer *)sender {
    @try {
        if (sender.state == UIGestureRecognizerStateBegan) {
            // For the pro2 devices, there will be no separate Audio source at the bottom, this will be manage by single Hybrid icon, which will be TV after click on AVR and long press will load audio source. So below we are writing the conditions for pro2 unit, that if device is pro2 then Long press icon will be Hybrid icon for loading audio source on long press. For another units this condition will remain same and older code is written in else condition. Pro2 is checking for output screen and rest is checking for single speaker icon that is audio source.
            if([mHubManagerInstance.objSelectedHub isPro2Setup] || [mHubManagerInstance.objSelectedHub is411Setup] || [mHubManagerInstance.objSelectedHub isZPSetup]){
                if (mHubManagerInstance.controlDeviceTypeBottom == OutputScreen || mHubManagerInstance.controlDeviceTypeBottom == HybridSource) {
                    if (self.delegate) {
                        [self.delegate didReceivedReloadGroupVolume:Uncontrollable];
                        [self.delegate didReceivedReloadAudioDevice:HybridSource];
                    }
                }
                else if (mHubManagerInstance.controlDeviceTypeBottom == AudioSource) {
                        [self.delegate didReceivedReloadGroupVolume:Uncontrollable];
                        [self.delegate didReceivedReloadAudioDevice:AudioSource];
                }
                else {
                    if (self.delegate) {
                        [self.delegate didReceivedReloadAudioDevice:Uncontrollable];
                    }
                }
            }
            else{
            if (mHubManagerInstance.controlDeviceTypeBottom == AudioSource) {
                if (self.delegate) {
                    [self.delegate didReceivedReloadGroupVolume:Uncontrollable];
                    [self.delegate didReceivedReloadAudioDevice:AudioSource];
                }
            } else {
                if (self.delegate) {
                    [self.delegate didReceivedReloadAudioDevice:Uncontrollable];
                }
            }
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Volume Control Buttons
- (IBAction)btnVolumeMinus_Clicked:(id)sender {
    @try {
        [[CustomAVPlayer sharedInstance] soundPlay:Beep];
        CustomButtonForControls *btnSender = (CustomButtonForControls *)sender;
        Command *objCmd = (Command *)btnSender.infoData;
        switch (mHubManagerInstance.controlDeviceTypeBottom) {
            case HybridSource:
            [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo  TouchType:touchActivity_MinusBtn];
            break;
            case OutputScreen:
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo  TouchType:touchActivity_MinusBtn];
                break;
                
            case AVRSource:
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo  TouchType:touchActivity_MinusBtn];
                break;
            default:
                break;
        }
        
        //touchActivity_MinusBtn = Normal;
        //Below code is to Hide the Table view of audio inputs.
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowHideInputOutputContainer object:self];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnVolumePlus_Clicked:(id)sender {
    @try {
        [[CustomAVPlayer sharedInstance] soundPlay:Beep];
        CustomButtonForControls *btnSender = (CustomButtonForControls *)sender;
        Command *objCmd = (Command *)btnSender.infoData;
        switch (mHubManagerInstance.controlDeviceTypeBottom) {
            case OutputScreen:
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo  TouchType:touchActivity_PlusBtn];
                break;
            case HybridSource:
            [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo  TouchType:touchActivity_PlusBtn];
            break;
                
            case AVRSource:
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo  TouchType:touchActivity_PlusBtn];
                break;
            default:
                break;
        }
        //touchActivity_PlusBtn = Normal;
        //Below code is to Hide the Table view of audio inputs.
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowHideInputOutputContainer object:self];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnVolumeMute_Clicked:(id)sender {
    @try {
        [[CustomAVPlayer sharedInstance] soundPlay:Beep];
        CustomButtonForControls *btnSender = (CustomButtonForControls *)sender;
        Command *objCmd = (Command *)btnSender.infoData;
        switch (mHubManagerInstance.controlDeviceTypeBottom) {
                //NSLog(@"controlDeviceTypeBottom %lu",(unsigned long)mHubManagerInstance.controlDeviceTypeBottom);
            case HybridSource: {
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo  TouchType:Normal];
                break;
            }
            case OutputScreen: {
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo  TouchType:Normal];
                break;
            }
            case AVRSource: {
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo  TouchType:Normal];
                break;
            }
            case AudioSource: {
                
                if ([btnSender.currentImage isEqual:kImageIconAudioMuteActive]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [btnSender setImage:kImageIconAudioMuteInActive forState:UIControlStateNormal];
                        });
                    [self.sliderAudioVolume setMinimumTrackTintColor:colorDarkGray_272727];
                    [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEndGray forState:UIControlStateNormal];
                    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"BtnVoloumeState"];
                    [self setAudioZoneOrGroupControlMute:true];
                } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                    [btnSender setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
                     });
                    [self setSliderTrackColor:self.sliderAudioVolume];
                    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"BtnVoloumeState"];
                    [self setAudioZoneOrGroupControlMute:false];
                }
                break;
            }
            default:
                break;
        }
        //Below code is to Hide the Table view of audio inputs.
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowHideInputOutputContainer object:self];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - MHUB Audio Control
-(void) setSliderAudioVolume:(id)sender InputIndex:(NSInteger)intAudioInputIndex {
    @try {
        Group *objGroup;
        Zone *objZone;
        if ([sender isKindOfClass:[Group class]]) {
            objGroup  = (Group*)sender;
            lastVolumeValue = objGroup.GroupVolume;
            lastMuteStatus = objGroup.GroupMute;
        } else {
            objZone  = (Zone*)sender;
            lastVolumeValue = objZone.Volume;
            lastMuteStatus = objZone.isMute;
        }
        [self.sliderAudioVolume setValue:lastVolumeValue];
        [self setSliderTrackColor:self.sliderAudioVolume];
        if (!lastMuteStatus) {
            [self.btnVolumeMute setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
        } else {
            [self.btnVolumeMute setImage:kImageIconAudioMuteInActive forState:UIControlStateNormal];
            [self.sliderAudioVolume setMinimumTrackTintColor:colorDarkGray_272727];
            [self.sliderAudioVolume setThumbImage:kImageIconAudioSliderEndGray forState:UIControlStateNormal];
        }
        self.btnVolumeMute.infoData = sender;
        [self btnMHUBAudioOutputLabeling:objZone.isMute InputIndex:objZone.audio_input];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) setSliderTrackColor:(SSTTapSlider*)sTapSlider {
    @try {
        if (sTapSlider.value == sTapSlider.minimumValue) {
            [sTapSlider setMinimumTrackTintColor:colorDarkGray_202020];
            [sTapSlider setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
        } else if (sTapSlider.value == sTapSlider.maximumValue) {
            [sTapSlider setMinimumTrackTintColor:colorWhite_254254254];
            [sTapSlider setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
        } else {
            [sTapSlider setMinimumTrackTintColor:colorWhite_254254254];
            [sTapSlider setThumbImage:kImageIconAudioSlider forState:UIControlStateNormal];
        }
        //Below code is to Hide the Table view of audio inputs.
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowHideInputOutputContainer object:self];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) btnMHUBAudioOutputLabeling:(BOOL)isMuted InputIndex:(NSInteger) intAudioInputIndex {
    @try {
        lastMuteStatus = isMuted;
        if([mHubManagerInstance.objSelectedHub isPro2Setup] && [mHubManagerInstance.objSelectedHub isPaired])
        {
            
        }
        intLastInputSelected = intAudioInputIndex == 0 ? mHubManagerInstance.objSelectedZone.audio_input : intAudioInputIndex;
        //[self.btnMHUBAudioOutput setTitleColor:[AppDelegate appDelegate].themeColours.colorSettingControlBorder forState:UIControlStateNormal];
        [self.btnMHUBAudioOutput setTitleColor:[AppDelegate appDelegate].themeColours.colorInputSelectedText forState:UIControlStateNormal];
        NSMutableString *strTitle = [[NSMutableString alloc] init];
        InputDevice *objAIP = [InputDevice getFilteredInputDeviceData:intLastInputSelected InputData:mHubManagerInstance.arrAudioSourceDeviceManaged];
        NSString *strMuted = @" (MUTED)";
        NSString *strGroupAudio = @" (AUDIO GROUPED)";
        if ([objAIP isNotEmpty]) {
            [strTitle appendString:objAIP.CreatedName];
        }
        if (isMuted) {
            [strTitle appendString:strMuted];
        }
        else if ([mHubManagerInstance.objSelectedGroup.GroupName isNotEmpty]) {
            [strTitle appendString:strGroupAudio];
        }
        [self.btnMHUBAudioOutput setTitle:[strTitle uppercaseString] forState:UIControlStateNormal];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnMHUBAudioOutput_Clicked:(CustomButtonForControls *)sender {
    @try {
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
#pragma mark - SSTTapSliderDelegate
- (void)tapSlider:(SSTTapSlider *)tapSlider valueDidChange:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
     [self setSliderTrackColor:tapSlider];
     //[self setAudioZoneOrGroupControlVolume:value];
}

- (void)tapSlider:(SSTTapSlider *)tapSlider tapEndedWithValue:(float)value {
    [self setSliderTrackColor:tapSlider];
    [self setAudioZoneOrGroupControlVolume:value];
    [self.btnVolumeMute setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
}

- (void)tapSlider:(SSTTapSlider *)tapSlider panBeganWithValue:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
}

- (void)tapSlider:(SSTTapSlider *)tapSlider panEndedWithValue:(float)value {
    // DDLogDebug(@"%@ (%f)", NSStringFromSelector(_cmd), value);
      //[self.btnVolumeMute setHidden:NO];
    //NSLog(@"SSLider value 3 %f",value);
    [self setSliderTrackColor:tapSlider];
    [self setAudioZoneOrGroupControlVolume:value];
    [self.btnVolumeMute setImage:kImageIconAudioMuteActive forState:UIControlStateNormal];
    [self setAudioZoneOrGroupControlMute:false];
}

#pragma mark - API Calling Methods
//-(void) switchInAudioDevice {
//    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
//    [APIManager switchIn_Address:mHubManagerInstance.objSelectedHub.Address OutputIndex:mHubManagerInstance.objSelectedOutputDevice.Index InputIndex:mHubManagerInstance.objSelectedOutputDevice.Index];
//}

-(void) setAudioZoneOrGroupControlVolume:(NSInteger)value {
    @try {
        if (value != lastVolumeValue) {
            //testgroupchanges ok
            if ([mHubManagerInstance.objSelectedGroup isNotEmpty]) {
                mHubManagerInstance.objSelectedGroup.GroupVolume = value;
                // Shifted Up
                mHubManagerInstance.objSelectedHub.HubGroupData = [mHubManagerInstance updateGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:mHubManagerInstance.objSelectedGroup];
                [self btnMHUBAudioOutputLabeling:mHubManagerInstance.objSelectedGroup.GroupMute InputIndex:intLastInputSelected];
                if (self.delegate) {
                    [self.delegate didReceivedReloadGroupVolume:AudioSource];
                    [self.delegate didReceivedSliderAudioVolumeValueChanged_Previous:lastVolumeValue New:value];
                }
                mHubManagerInstance.objSelectedHub.HubZoneData = [mHubManagerInstance updateZoneFromGroupZoneData:mHubManagerInstance.arrSelectedGroupZoneList AllZoneData:mHubManagerInstance.objSelectedHub.HubZoneData];
                lastVolumeValue = value;
                // Audio changes for slave-OLD
               [APIManager groupManager_Address:mHubManagerInstance.objSelectedHub.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Volume completion:^(APIV2Response *responseObject) {
                   if (!responseObject.error) {
                   }
               }];
                /*
                 // Audio changes for slave-NEW
                Hub *objAudioSlave = [mHubManagerInstance.arrSlaveAudioDevice firstObject];
                DDLogDebug(@"slave IP address groupManager_Address %@", objAudioSlave.Address);
                [APIManager groupManager_Address:objAudioSlave.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Volume completion:^(APIV2Response *responseObject) {
                    if (!responseObject.error) {
                    }
                }];
                */
            } else
            {
                mHubManagerInstance.objSelectedZone.Volume = value;
                for (int counter = 0; counter < [mHubManagerInstance.objSelectedHub.HubZoneData count]; counter++) {
                    Zone *objZoneTemp = [mHubManagerInstance.objSelectedHub.HubZoneData objectAtIndex:counter];
                    if ([mHubManagerInstance.objSelectedZone.zone_id isEqualToString:objZoneTemp.zone_id]) {
                        [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:counter withObject:mHubManagerInstance.objSelectedZone];
                        break;
                    }
                }
                [self btnMHUBAudioOutputLabeling:mHubManagerInstance.objSelectedZone.isMute InputIndex:intLastInputSelected];
                lastVolumeValue = value;
                
                // Audio changes for single slave-OLD
                [APIManager controlVolumeAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id Volume:value];
                /*
                // Audio changes for single slave-NEW
                Hub *objAudioSlave = [mHubManagerInstance.arrSlaveAudioDevice firstObject];
                DDLogDebug(@"slave IP address controlVolumeAudioZone_Address  %@", objAudioSlave.Address);
                //[APIManager controlVolumeAudioZone_Address:objAudioSlave.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id Volume:value];
                */
                
                /*
                // SWITCHING: Direct Connection with Slave without Zone, in that case we commented above "slave-NEW" code, because that is used to send with Zone ID
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
            }
            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) setAudioZoneOrGroupControlMute:(BOOL)isMute {
    @try {
        //testgroupchanges ok
        if ([mHubManagerInstance.objSelectedGroup isNotEmpty]) {
            mHubManagerInstance.objSelectedGroup.GroupMute = isMute;

            mHubManagerInstance.objSelectedHub.HubGroupData = [mHubManagerInstance updateGroupData:mHubManagerInstance.objSelectedHub.HubGroupData Group:mHubManagerInstance.objSelectedGroup];

            [self btnMHUBAudioOutputLabeling:isMute InputIndex:intLastInputSelected];
            if (self.delegate) {
                [self.delegate didReceivedReloadGroupVolume:AudioSource];
                [self.delegate didReceivedTapOnGroupVolumeMuteButton:isMute];
            }
             // Audio changes for single slave-OLD           
            [APIManager groupManager_Address:mHubManagerInstance.objSelectedHub.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Mute completion:^(APIV2Response *responseObject) {
                if (!responseObject.error) {
                }
            }];
            /*
            // Audio changes for single slave-NEW
            Hub *objAudioSlave = [mHubManagerInstance.arrSlaveAudioDevice firstObject];
            DDLogDebug(@"slave IP address groupManager_Address  %@", objAudioSlave.Address);
            [APIManager groupManager_Address:objAudioSlave.Address Group:mHubManagerInstance.objSelectedGroup Operation:GRPO_Mute completion:^(APIV2Response *responseObject) {
                if (!responseObject.error) {
                }
            }];
             */
        } else {
            mHubManagerInstance.objSelectedZone.isMute = isMute;
            for (int counter = 0; counter < [mHubManagerInstance.objSelectedHub.HubZoneData count]; counter++) {
                Zone *objZoneTemp = [mHubManagerInstance.objSelectedHub.HubZoneData objectAtIndex:counter];
                if ([mHubManagerInstance.objSelectedZone.zone_id isEqualToString:objZoneTemp.zone_id]) {
                    [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:counter withObject:mHubManagerInstance.objSelectedZone];
                    break;
                }
            }
            [self btnMHUBAudioOutputLabeling:isMute InputIndex:intLastInputSelected];
            // [APIManager controlMute_Address:mHubManagerInstance.objSelectedHub.Address OutputIndex:mHubManagerInstance.objSelectedOutputDevice.Index Mute:isMute];
            
             // Audio changes for single slave-OLD
            [APIManager controlMuteAudioZone_Address:mHubManagerInstance.objSelectedHub.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id Mute:isMute];
            
            /*
            // Audio changes for single slave-NEW
            Hub *objAudioSlave = [mHubManagerInstance.arrSlaveAudioDevice firstObject];
            DDLogDebug(@"slave IP addresscontrolMuteAudioZone_Address  %@", objAudioSlave.Address);
           // [APIManager controlMuteAudioZone_Address:objAudioSlave.Address ZoneId:mHubManagerInstance.objSelectedZone.zone_id Mute:isMute];
            */
            
            /*
            // SWITCHING: Direct Connection with Slave without Zone, in that case we commented above "slave-NEW" code, because that is used to send with Zone ID
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
        }
        [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - CustomAVPlayerDelegate Method
-(void) didReceivedHardwareVolumeVideo_OldValue:(NSInteger)intOldValue NewValue:(NSInteger)intNewValue {
    @try {
        NSInteger intDifference = intNewValue - intOldValue;
        switch (mHubManagerInstance.controlDeviceTypeBottom) {
            case HybridSource: {
                if (intDifference > 0) {
                    [self btnVolumePlus_Clicked:self.btnVolumePlus];
                } else if (intDifference < 0) {
                    [self btnVolumeMinus_Clicked:self.btnVolumeMinus];
                }
                break;
            }
            case OutputScreen: {
                if (intDifference > 0) {
                    [self btnVolumePlus_Clicked:self.btnVolumePlus];
                } else if (intDifference < 0) {
                    [self btnVolumeMinus_Clicked:self.btnVolumeMinus];
                }
                break;
            }
            case AVRSource: {
                if (intDifference > 0) {
                    [self btnVolumePlus_Clicked:self.btnVolumePlus];
                } else if (intDifference < 0) {
                    [self btnVolumeMinus_Clicked:self.btnVolumeMinus];
                }
                break;
            }
            case AudioSource: {
                SSTTapSlider *tapSlider = self.sliderAudioVolume;
                tapSlider.value = intNewValue;
                // DDLogDebug(@"Volume == %ld", (long)intNewValue);
                [self setAudioZoneOrGroupControlVolume:intNewValue];
                [self setSliderTrackColor:tapSlider];
                break;
            }
            default:
                break;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}

@end
