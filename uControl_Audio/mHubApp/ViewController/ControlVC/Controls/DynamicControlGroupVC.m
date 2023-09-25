//
//  DynamicControlGroupVC.m
//  mHubApp
//
//  Created by Anshul Jain on 07/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
 This is the container view, Child Class of GroupContainerVC.
 This container loads according to selected ControlGroup.
 This is one of the important class of the project as it display dynamic remote view according to Device size, grid and position description available in the IRPack detail.
 This view have some key functionality like command buttom clicks, different gestures command calls.

 */

#import "DynamicControlGroupVC.h"

#define kPortraitContraintConstantiPhone 15
#define kPortraitContraintConstantiPad 15
#define kLandscapeContraintConstantiPad 15

@interface DynamicControlGroupVC () <UIGestureRecognizerDelegate> {
    BOOL isSwipeEnd;
    UISwipeGestureRecognizerDirection singleTouchSwipeSenderDirection;
    NSTimer *timerObj;
    NSTimer *timerObjButton;
    double timerSeconds_value;
    double timerSeconds_forButton;
    GestureType gestureTypeObj;
    TouchActivity touchActivityGESTURE;
    TouchActivity touchActivityBUTTON;
}
@property (weak, nonatomic) IBOutlet UIView *subviewControl;
@property (nonatomic, retain) NSArray *arrControlCommandGesture;
@property (nonatomic, retain) NSArray *arrControlCommand;
@property (weak, nonatomic) IBOutlet UIImageView *imgSeperator;
@property (weak, nonatomic) IBOutlet UIView *viewControlBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgControlBackgroundShadow;
//@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation DynamicControlGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    touchActivityBUTTON =  Normal;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yourUpdateMethodGoesHere:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    touchActivityBUTTON =  normal;
    touchActivityGESTURE = normal;
}

- (void) yourUpdateMethodGoesHere:(NSNotification *) note {
    @try {
        touchActivityBUTTON =  normal;
    touchActivityGESTURE = Normal;
    if([timerObj isValid] || timerObj != nil){
        [self stopAndResetGestureTimer];
    }
    if([timerObjButton isValid]){
    [self->timerObjButton invalidate];
    self->timerObjButton = nil;
    self->timerSeconds_forButton = 0.0;
    }
} @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)stopAndResetGestureTimer
{
    @try {
    [timerObj invalidate];
    timerObj = nil;
    timerSeconds_value = 0.0;
    
} @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)updateTimer
{
    @try {
    //NSLog(@"TOUCHES for %f",timerSeconds_value);//finger touch went right
    timerSeconds_value = timerSeconds_value + 0.1;
   // NSLog(@"TOUCHES HOLD for %f",[AppDelegate appDelegate].holdVal);
    if(timerSeconds_value == [AppDelegate appDelegate].pressVal && touchActivityGESTURE  == Normal)
    {
      //  NSLog(@"TOUCHES for %f %ld",timerSeconds_value,gestureTypeObj);//finger touch went right
        touchActivityGESTURE  = Hold;
        [self callGestureCommand:gestureTypeObj TouchType:Normal];
    }
    if(timerSeconds_value >= [AppDelegate appDelegate].holdVal && touchActivityGESTURE  == Hold)
    {
        //NSLog(@"TOUCHES HOLD for %f %ld",timerSeconds_value,gestureTypeObj);//finger touch went right
        timerSeconds_value = 0.0;
        [self callGestureCommand:gestureTypeObj TouchType:Hold];
    }
    else
    {

    }
    
} @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}



-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    @try {
        if (IS_IPAD) {
            UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            if (UIInterfaceOrientationIsLandscape(orientation)) {
                [self viewDesign_Orientation:false];
            } else {
                [self viewDesign_Orientation:true];
            }
        } else {
            [self viewDesign_Orientation:true];
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

-(void) viewDesign_Orientation:(BOOL)isPortrait {
    @try {
        NSArray *arrSubView = self.subviewControl.subviews;
        for (UIView *view in arrSubView) {
            [view removeFromSuperview];
        }
        
        //** Condition to select ControlGroupType. **//
        //** 1. GestureControl **//
        //** 2. Numurical KeyPad **//
        //** 3. Navigation KeyPad **//
        //** 4. Playhead KeyPad **//

        switch (mHubManagerInstance.controlDeviceTypeSource) {
            case InputSource: {
                InputDevice *objInput = mHubManagerInstance.objSelectedInputDevice;
                if ([self.segueIdentifier isEqualToString:kControlTypeGesturePad]) {
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gestureKey];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypeNumberPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.number];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypeDirectionPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.direction];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypePlayheadPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.playhead];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                }else if ([self.segueIdentifier isEqualToString:kControlTypeCustomControl]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.custom];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                } else {
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.allCommands];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                }
                break;
            }
            case AVRSource: {
                AVRDevice *objAVR = mHubManagerInstance.objSelectedAVRDevice;
                if ([self.segueIdentifier isEqualToString:kControlTypeGesturePad]) {
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.gestureKey];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypeNumberPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.number];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypeDirectionPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.direction];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypePlayheadPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.playhead];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.gesture];
                }else if ([self.segueIdentifier isEqualToString:kControlTypeCustomControl]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.custom];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.gesture];
                }  else {
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.allCommands];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.gesture];
                }
                break;
            }
            case OutputScreen: {
                OutputDevice *objOutput = mHubManagerInstance.objSelectedOutputDevice;
                if ([self.segueIdentifier isEqualToString:kControlTypeGesturePad]) {
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.gestureKey];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypeNumberPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.number];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypeDirectionPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.direction];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypePlayheadPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.playhead];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.gesture];
                }else if ([self.segueIdentifier isEqualToString:kControlTypeCustomControl]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.custom];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.gesture];
                } else {
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.allCommands];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.gesture];
                }
                break;
            }
            default: {
                InputDevice *objInput = mHubManagerInstance.objSelectedInputDevice;
                if ([self.segueIdentifier isEqualToString:kControlTypeGesturePad]) {
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gestureKey];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypeNumberPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.number];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypeDirectionPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.direction];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                } else if ([self.segueIdentifier isEqualToString:kControlTypePlayheadPad]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.playhead];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                }else if ([self.segueIdentifier isEqualToString:kControlTypeCustomControl]){
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.custom];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                }  else {
                    self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.allCommands];
                    self.arrControlCommandGesture = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.gesture];
                }
                mHubManagerInstance.controlDeviceTypeSource = InputSource;
                break;
            }
        }
        
        NSInteger widthDivider = 0;
        NSInteger heightDivider = 0;
        float viewConstant = kPortraitContraintConstantiPad;
        
        //** Object to get grid size accordint to device type, i.e. smallMobile, largeMobile, smallTablet and largeTablet. **//
        Grid *objGrid = [Grid initWithGrid];
        
        //** Condition to apply side pade paddings in the subview according to device type. **//
        switch ([AppDelegate appDelegate].deviceType) {
            case mobileSmall: {
                viewConstant = kPortraitContraintConstantiPhone;
                widthDivider = objGrid.mobileSmall.column;
                heightDivider = objGrid.mobileSmall.row;
            }
                break;
                
            case mobileLarge: {
                viewConstant = kPortraitContraintConstantiPhone;
                widthDivider = objGrid.mobileLarge.column;
                heightDivider = objGrid.mobileLarge.row;
            }
                break;
                
            case tabletSmall: {
                widthDivider = objGrid.tabletSmall.column;
                heightDivider = objGrid.tabletSmall.row;
            }
                break;
                
            case tabletLarge: {
                if (isPortrait) {
                    viewConstant = kPortraitContraintConstantiPad;
                    widthDivider = objGrid.tabletLarge.column;
                    heightDivider = objGrid.tabletLarge.row;
                } else {
                    viewConstant = kLandscapeContraintConstantiPad;
                    widthDivider = objGrid.tabletLargeLandscape.column;
                    heightDivider = objGrid.tabletLargeLandscape.row;
                }
            }
                break;
            default:
                break;
        }
        CGFloat padding = 5;
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        CGFloat cellWidth = 0;
        CGFloat cellHeight = 0;

        CGSize viewFrame = self.view.frame.size;
        
        CGFloat viewW = viewFrame.width-(viewConstant*2+20);
        cellWidth = viewW/widthDivider;
        CGFloat viewH = viewFrame.height-(viewConstant*4); //-10;
        cellHeight = viewH/heightDivider;
        //** If cellHeight is greater then 2/3rd of cellWidth then cellHeight replace by 2/3rd of cellWidth, i.e. Width:Height = 3:2 **//
//        if (cellHeight > cellWidth*0.66f) {
//            cellHeight = cellWidth*0.66f;
//        }
        
        NSInteger widthMultiplier = 1;
        NSInteger heightMultiplier = 1;
        CGFloat viewWidth = 0;
        CGFloat viewHeight = 0;
        
        NSInteger locationX = 0;
        NSInteger locationY = 0;
        
        NSMutableArray *arrSkipLocation = [[NSMutableArray alloc] init];
        //** Loop to draw gesture view and buttons according to coordinates in grid value. **//
        for (int heightCounter = 1; heightCounter <= heightDivider; heightCounter++) {
            for (int widthCounter = 1; widthCounter <= widthDivider; widthCounter++) {
                
                //DDLogDebug(@"heightCounter == %d, widthDivider == %d", heightCounter, widthCounter);
                //** arrSkipLocation contains current loop location than skip this coordinates and continue to next value. **//
                BOOL isSkip = false;
                for (int skip = 0; skip < arrSkipLocation.count; skip++) {
                    Location *objLoc = (Location*)[arrSkipLocation objectAtIndex:skip];
                    if (objLoc.locationX == heightCounter && objLoc.locationY == widthCounter) {
                        //DDLogDebug(@"skip-heightCounter == %d, skip-widthCounter == %d", heightCounter, widthCounter);
                        [arrSkipLocation removeObjectAtIndex:skip];
                        isSkip = true;
                        break;
                    }
                }
                if (isSkip) {
                    continue;
                }
                
                Command *objCommand = [self searchCommand_Orientation:isPortrait LocationX:heightCounter LocationY:widthCounter];
                
                if (![objCommand.image isNotEmpty]) {
                    Command *objCmdData = [Command getLocalCommandData:objCommand.command_id];
                    if (objCmdData.image) {
                        objCommand.image = objCmdData.image;
                        objCommand.image_light = objCmdData.image_light;
                        objCommand.image_label = objCmdData.image_label;
                    }
                }
                if (isPortrait) {
                    locationX = objCommand.locationX;
                    locationY = objCommand.locationY;
                } else {
                    locationX = objCommand.locationXLandscape;
                    locationY = objCommand.locationYLandscape;
                }
                
                widthMultiplier = objCommand.sizeWidth;
                heightMultiplier = objCommand.sizeHeight;
                if (heightMultiplier > heightDivider)
                    heightMultiplier = heightDivider;
                
                //** Subview have widthMultiplier OR heightMultiplier value greater than 1. Then, it needs to skip some grid value.  **//
                if (widthMultiplier > 1 || heightMultiplier > 1) {
                    //** This loop is to calculate skip value and store into the array arrSkipLocation **//
                    for (int skipCounterHeight = heightCounter; skipCounterHeight <= heightMultiplier; skipCounterHeight++) {
                        for (int skipCounterWidth = widthCounter; skipCounterWidth <= widthMultiplier; skipCounterWidth++) {
                            Location *objSkip = [Location getObjectFromString:[NSString stringWithFormat:@"%d,%d", skipCounterHeight, skipCounterWidth]];
                            //DDLogDebug(@"skipCounterHeight == %d, skipCounterWidth == %d", skipCounterHeight, skipCounterWidth);
                            [arrSkipLocation addObject:objSkip];
                        }
                    }
                }
                viewX = cellWidth*(widthCounter-1);
                viewY = cellHeight*(heightCounter-1);
                viewWidth = cellWidth*widthMultiplier;
                viewHeight = cellHeight*heightMultiplier;
                
                ThemeColor *objTheme = [AppDelegate appDelegate].themeColours;
                
                //** Condition to draw view according to control type i.e. Gesture view or Button. **//
                switch (objCommand.ctrlType) {
                    case UIgesture: {
                        UIView *viewBG = [[UIView alloc] init];
                        [viewBG setBackgroundColor:colorClear];
                        [viewBG setFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
                        [viewBG addBorder_Color:colorClear BorderWidth:1.0];

                        if (viewWidth > 0 && viewHeight > 0) {
                            
                            UIView *viewGesture = [[UIView alloc] init];
                            [viewGesture setFrame:CGRectMake(0+padding, 0+padding, viewWidth-padding*2, viewHeight-padding*2)];
                            [viewGesture setBackgroundColor:objTheme.colorControlDefault];
                            [viewGesture addBorder_Color:objTheme.colorControlBorder BorderWidth:1.0];
                            viewGesture.tag = 101;
                            [self gestureView:viewGesture];
                            
                            [viewBG addSubview:viewGesture];
                        }
                        [self.subviewControl addSubview:viewBG];
                    }
                        break;
                        
                    case UIbutton: {
                        
                        UIView *viewBG = [[UIView alloc] init];
                        [viewBG setBackgroundColor:colorClear];
                        [viewBG setFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
                        [viewBG addBorder_Color:colorClear BorderWidth:1.0];

                        //** if button viewWidth AND viewHeight is ZERO then it don't need to draw. **//
                        //Previous If Condition. After ZP AND CEC, We have removed check of commands, because its not coming for this devices.
                        //if (viewWidth > 0 && viewHeight > 0 && [objCommand.code isNotEmpty]) {
                        //New IF condition without commands check
                        if (viewWidth > 0 && viewHeight > 0) {
                            CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
                            button.infoData = objCommand;
                            [button addTarget:self action:@selector(btnCommand_Clicked:) forControlEvents:UIControlEventTouchUpInside];
                            if(objCommand.command_id == 10 || objCommand.command_id == 11 || objCommand.command_id == 34 || objCommand.command_id == 35){
                            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture_HandleButton:)];
                            [longPress setDelegate:self];
                            [longPress setCancelsTouchesInView:true];
                            [button addGestureRecognizer:longPress];
                            }
                            
                            [button setFrame:CGRectMake(0+padding, 0+padding, viewWidth-padding*2, viewHeight-padding*2)];
                            
                            //** if control object contains image then, show addimage to button else lable. **//
                            if ([objCommand.image isNotEmpty] || [objCommand.image_light isNotEmpty]) {
                                //DDLogDebug(@"objCommand.image_label == %@", objCommand.image_label);
                                
                                //** Select Image by Theme Type i.e. Dark or Light **//
                                switch (objTheme.themeType) {
                                    case Dark: {
                                        // if ([objCommand.image_label isNotEmpty] && [objCommand.image_label containsString:@"color"]) {
                                        //      [button setImage:objCommand.image forState:UIControlStateNormal];
                                        // } else {
                                            [button setImage:objCommand.image forState:UIControlStateNormal];
                                            if (objTheme.isButtonBorder) {
                                                 [button setBackgroundColor:objTheme.colorControlDefault];
                                                [button addBorder_Color:objTheme.colorControlBorder BorderWidth:1.0];

                                            } else {
                                                [button setBackgroundColor:colorClear];
                                                [button addBorder_Color:colorClear BorderWidth:1.0];
                                            }
                                        // }
                                    }
                                        break;
                                        
                                    case Light: {
                                        // if ([objCommand.image_label isNotEmpty] && [objCommand.image_label containsString:@"color"]) {
                                        //     [button setImage:objCommand.image_light forState:UIControlStateNormal];
                                        // } else {
                                            [button setImage:objCommand.image_light forState:UIControlStateNormal];
                                            if (objTheme.isButtonBorder) {
                                                [button setBackgroundColor:objTheme.colorControlDefault];
                                                [button addBorder_Color:objTheme.colorControlBorder BorderWidth:1.0];
                                            } else {
                                                [button setBackgroundColor:colorClear];
                                                [button addBorder_Color:colorClear BorderWidth:1.0];
                                            }
                                        // }
                                        break;
                                    }
                                    default:
                                        break;
                                }
                                button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                            } else if ([objCommand.label isNotEmpty]) {
                                [button setTitle:[NSString stringWithFormat:@"%@", [objCommand.label uppercaseString]] forState:UIControlStateNormal];
                                switch ([AppDelegate appDelegate].deviceType) {
                                    case mobileSmall: {
                                        if (IS_IPHONE_5_HEIGHT) {
                                            button.titleLabel.font = textFontSemiBold9;
                                        } else {
                                            button.titleLabel.font = textFontSemiBold12;
                                        }
                                        break;
                                    }
                                    case mobileLarge: {
                                        button.titleLabel.font = textFontSemiBold10;
                                        break;
                                    }
                                    case tabletSmall: {
                                        button.titleLabel.font = textFontSemiBold11;
                                        break;
                                    }
                                    case tabletLarge:   {
                                        if (IS_IPAD_PRO_1024) {
                                            button.titleLabel.font = textFontSemiBold16;
                                        } else {
                                            button.titleLabel.font = textFontSemiBold11;
                                        }
                                        break;
                                    }
                                    default:    break;
                                }
                                button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                                button.titleEdgeInsets  = UIEdgeInsetsMake(5, 5, 5, 5);
                                if (objCommand.isVisible) {
                                    [button setTitleColor:objTheme.colorControlText forState:UIControlStateNormal];
                                } else {
                                    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                                }
                                if (objTheme.isButtonBorder) {
                                    [button setBackgroundColor:objTheme.colorControlDefault];
                                    [button addBorder_Color:objTheme.colorControlBorder BorderWidth:1.0];
                                } else {
                                    [button setBackgroundColor:colorClear];
                                    [button addBorder_Color:colorClear BorderWidth:1.0];
                                }
                            } else {
                                [button setBackgroundColor:colorClear];
                            }
                            [viewBG addSubview:button];
                        }
                        [self.subviewControl addSubview:viewBG];
                    }
                        break;
                        
                    default: {
                        //** Defult control create a blank view. **//
                        UIView *viewBG = [[UIView alloc] init];
                        [viewBG setBackgroundColor:colorClear];
                        [viewBG setFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
                        [viewBG addBorder_Color:colorClear BorderWidth:1.0];
                        [self.subviewControl addSubview:viewBG];
                    }
                        break;
                }
                [self.viewControlBackground setBackgroundColor:objTheme.colorControlBackground];
                [self.subviewControl setBackgroundColor:colorClear];
                
                switch (objTheme.themeType) {
                    case Dark: {
                        [self.imgControlBackgroundShadow setImage:kImageShadowThemeBlack];
                        [self.imgSeperator setBackgroundColor:colorDarkGray_262626];
                        break;
                    }
                    case Light: {
                        [self.imgControlBackgroundShadow setImage:kImageShadowThemeWhite];
                        [self.imgSeperator setBackgroundColor:colorLightGray_179179179];
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void)longPressGesture_HandleButton:(UILongPressGestureRecognizer*)sender
{
    @try {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
           // NSLog(@"UIGestureRecognizerStateBegan BUTTON");
           self->timerObjButton =  [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer *timer) {
                self->timerSeconds_forButton = self->timerSeconds_forButton + 0.1;
               NSLog(@"TOUCHES for %f %f %f",self->timerSeconds_forButton,[AppDelegate appDelegate].pressVal,[AppDelegate appDelegate].holdVal);//finger touch went right
                if (self->timerSeconds_forButton >= [AppDelegate appDelegate].pressVal && self->touchActivityBUTTON == Normal) {
                    CustomButton *btnSender = (CustomButton *)sender.view;
                    self->touchActivityBUTTON = Normal;
                    [self btnCommand_Clicked:btnSender];
                    self->touchActivityBUTTON = Hold;
                }
                if (self->timerSeconds_forButton >= [AppDelegate appDelegate].holdVal && self->touchActivityBUTTON == Hold) {
                    self->timerSeconds_forButton = 0.0;
                    CustomButton *btnSender = (CustomButton *)sender.view;
                    self->touchActivityBUTTON = Hold;
                    [self btnCommand_Clicked:btnSender];
                }
                else{
//                    [self->timerObjButton invalidate];
//                    self->timerObjButton = nil;
                }
            }];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            break;
        }

        case UIGestureRecognizerStateEnded: {
            [self->timerObjButton invalidate];
            self->timerObjButton = nil;
            self->timerSeconds_forButton = 0.0;
            CustomButton *btnSender = (CustomButton *)sender.view;
            if(self->touchActivityBUTTON == Hold){
                self->touchActivityBUTTON = Release;
                [self btnCommand_Clicked:btnSender];
                self->touchActivityBUTTON = Normal;
            }
            else if(timerSeconds_forButton < [AppDelegate appDelegate].pressVal){
                touchActivityBUTTON = Normal;
                [self btnCommand_Clicked:btnSender];
            }
            //NSLog(@"UIGestureRecognizerStateEnded  BUTTON ");
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            CustomButton *btnSender = (CustomButton *)sender.view;
            [self->timerObjButton invalidate];
            self->timerObjButton = nil;
            self->timerSeconds_forButton = 0.0;
            touchActivityBUTTON = Normal;
            [self btnCommand_Clicked:btnSender];
            break;
        }
        default:
            break;
    }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void) btnCommand_Clicked:(UIButton*)sender {
    @try {
        [[CustomAVPlayer sharedInstance] soundPlay:Beep];
        CustomButton *btnSender = (CustomButton *)sender;
        Command *objCmd = (Command *)btnSender.infoData;
        if(objCmd.command_id == 10 || objCmd.command_id == 11 || objCmd.command_id == 34 || objCmd.command_id == 35)
        {
           
        }
        else
        {
            [self->timerObjButton invalidate];
            self->timerObjButton = nil;
            self->timerSeconds_forButton = 0.0;
            
            [self stopAndResetGestureTimer];
            touchActivityBUTTON = Normal;
            touchActivityGESTURE = Release;
        }
        switch (mHubManagerInstance.controlDeviceTypeSource) {
            case InputSource:
                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CEC_COMMAND"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ZPOUTPUT"];
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedInputDevice.PortNo  TouchType:touchActivityBUTTON];
                break;
            case AVRSource:
                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CEC_COMMAND"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ZPOUTPUT"];
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo  TouchType:touchActivityBUTTON];
                break;
            case OutputScreen:
                if([mHubManagerInstance.objSelectedOutputDevice.CreatedName containsString:@"CEC"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CEC_COMMAND"];
                }
                else{
                     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CEC_COMMAND"];
                }
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZPOUTPUT"];
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo  TouchType:touchActivityBUTTON];
                break;
            default:
                break;
        }
        //touchActivityBUTTON = Normal;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(Command*)searchCommand_Orientation:(BOOL)isPortrait LocationX:(NSInteger)locationX LocationY:(NSInteger)locationY {
    @try {
        Command *objCommand = nil;
        if (self.arrControlCommand.count > 0) {
            NSArray *subPredicates;
            if (isPortrait) {
                NSPredicate *predicateX = [NSPredicate predicateWithFormat:@"locationX = %@", [NSNumber numberWithInteger:locationX]];
                NSPredicate *predicateY = [NSPredicate predicateWithFormat:@"locationY = %@", [NSNumber numberWithInteger:locationY]];
                subPredicates = [NSArray arrayWithObjects:predicateX, predicateY, nil];
            } else {
                NSPredicate *predicateXLandscape = [NSPredicate predicateWithFormat:@"locationXLandscape = %@", [NSNumber numberWithInteger:locationX]];
                NSPredicate *predicateYLandscape = [NSPredicate predicateWithFormat:@"locationYLandscape = %@", [NSNumber numberWithInteger:locationY]];
                subPredicates = [NSArray arrayWithObjects:predicateXLandscape, predicateYLandscape, nil];
            }
            NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
            NSArray *filteredArray = [self.arrControlCommand filteredArrayUsingPredicate:predicate];
            objCommand =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
        }
        
        if (objCommand == nil) {
            objCommand = [[Command alloc] init];
        }
        return objCommand;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark -- Gesture Handle methods

-(void) gestureView:(UIView*)viewGesture {
    @try {
        
        UITapGestureRecognizer *tapGestureSingle;
        UITapGestureRecognizer *tapGestureDouble;
        
        UISwipeGestureRecognizer *swipeGestureSingleRight;
        UISwipeGestureRecognizer *swipeGestureSingleLeft;
        UISwipeGestureRecognizer *swipeGestureSingleUp;
        UISwipeGestureRecognizer *swipeGestureSingleDown;
        
        UISwipeGestureRecognizer *swipeGestureDoubleRight;
        UISwipeGestureRecognizer *swipeGestureDoubleLeft;
        UISwipeGestureRecognizer *swipeGestureDoubleUp;
        UISwipeGestureRecognizer *swipeGestureDoubleDown;
        
        
        UILongPressGestureRecognizer *longPress;
        
        tapGestureSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture_Handle:)];
        [tapGestureSingle setDelegate:self];
        [tapGestureSingle setNumberOfTapsRequired:1];
        [tapGestureSingle setNumberOfTouchesRequired:1];
        [viewGesture addGestureRecognizer:tapGestureSingle];
        
        tapGestureDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture_Handle:)];
        [tapGestureDouble setDelegate:self];
        [tapGestureDouble setNumberOfTapsRequired:1];
        [tapGestureDouble setNumberOfTouchesRequired:2];
        [viewGesture addGestureRecognizer:tapGestureDouble];
        
        swipeGestureSingleUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureSingle_Handle:)];
        [swipeGestureSingleUp setDelegate:self];
        [swipeGestureSingleUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [swipeGestureSingleUp setNumberOfTouchesRequired:1];
        [viewGesture addGestureRecognizer:swipeGestureSingleUp];
        
        swipeGestureSingleDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureSingle_Handle:)];
        [swipeGestureSingleDown setDelegate:self];
        [swipeGestureSingleDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [swipeGestureSingleDown setNumberOfTouchesRequired:1];
        [viewGesture addGestureRecognizer:swipeGestureSingleDown];
        
        swipeGestureSingleRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureSingle_Handle:)];
        [swipeGestureSingleRight setDelegate:self];
        [swipeGestureSingleRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [swipeGestureSingleRight setNumberOfTouchesRequired:1];
        [viewGesture addGestureRecognizer:swipeGestureSingleRight];
        
        swipeGestureSingleLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureSingle_Handle:)];
        [swipeGestureSingleLeft setDelegate:self];
        [swipeGestureSingleLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [swipeGestureSingleLeft setNumberOfTouchesRequired:1];
        [viewGesture addGestureRecognizer:swipeGestureSingleLeft];
        
        
        swipeGestureDoubleUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureDouble_Handle:)];
        [swipeGestureDoubleUp setDelegate:self];
        [swipeGestureDoubleUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [swipeGestureDoubleUp setNumberOfTouchesRequired:2];
        [viewGesture addGestureRecognizer:swipeGestureDoubleUp];
        
        swipeGestureDoubleDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureDouble_Handle:)];
        [swipeGestureDoubleDown setDelegate:self];
        [swipeGestureDoubleDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [swipeGestureDoubleDown setNumberOfTouchesRequired:2];
        [viewGesture addGestureRecognizer:swipeGestureDoubleDown];
        
        swipeGestureDoubleRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureDouble_Handle:)];
        [swipeGestureDoubleRight setDelegate:self];
        [swipeGestureDoubleRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [swipeGestureDoubleRight setNumberOfTouchesRequired:2];
        [viewGesture addGestureRecognizer:swipeGestureDoubleRight];
        
        swipeGestureDoubleLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureDouble_Handle:)];
        [swipeGestureDoubleLeft setDelegate:self];
        [swipeGestureDoubleLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [swipeGestureDoubleLeft setNumberOfTouchesRequired:2];
        [viewGesture addGestureRecognizer:swipeGestureDoubleLeft];
        
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture_Handle:)];
        [longPress setDelegate:self];
        [longPress setCancelsTouchesInView:true];
        [viewGesture addGestureRecognizer:longPress];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [panRecognizer setMinimumNumberOfTouches:1];
            [panRecognizer setMaximumNumberOfTouches:1];
            [viewGesture addGestureRecognizer:panRecognizer];
           
        
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    //NSLog(@"UIPanGestureRecognizer %ld", sender.state);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateEnded: {
           // NSLog(@"UIGestureRecognizerStateEnded PAN");
            [self stopAndResetGestureTimer];
            if(touchActivityGESTURE == Hold){
                [self callGestureCommand:gestureTypeObj TouchType:Release];
                touchActivityGESTURE = Release;
            }
            else if(timerSeconds_value < [AppDelegate appDelegate].pressVal){
                touchActivityGESTURE = Normal;
                [self callGestureCommand:gestureTypeObj TouchType:Normal];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            NSLog(@"UIGestureRecognizerStateCancelled");
            [self stopAndResetGestureTimer];
            touchActivityGESTURE = Release;
            [self callGestureCommand:gestureTypeObj TouchType:Release];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            //NSLog(@"UIGestureRecognizerStateChanged");
            break;
        }
        default:
            break;
    }

}
- (void)tapGesture_Handle:(UITapGestureRecognizer*)sender {
    @try {
        //DDLogDebug(@"tapGesture_Handle : %lu, %lu", (unsigned long)tapSender.numberOfTouchesRequired, (unsigned long)tapSender.numberOfTouches);
        isSwipeEnd = false;
        [self flashView];
        switch (sender.numberOfTouches) {
            case 1:
                if(timerSeconds_value < [AppDelegate appDelegate].pressVal)
                {
                    [self stopAndResetGestureTimer];
                    touchActivityGESTURE = Normal;
                [self callGestureCommand:SingleTap_Select TouchType:Normal];
                   
                }else {
                    gestureTypeObj = SingleTap_Select;
                }
                break;
            case 2:
                [self callGestureCommand:DoubleTap_Back TouchType:Normal];
                break;
            default:
                break;
        }
        [[CustomAVPlayer sharedInstance] soundPlay:Beep];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)swipeGestureDouble_Handle:(UISwipeGestureRecognizer*)sender {
    @try {
        //DDLogDebug(@"swipeGestureDouble_Handle : %lu , %lu, %lu", (unsigned long)swipeSender.direction, (unsigned long)swipeSender.numberOfTouchesRequired, (unsigned long)swipeSender.numberOfTouches);
        isSwipeEnd = false;
        [self flashView];
        switch (sender.direction) {
            case UISwipeGestureRecognizerDirectionUp:
                [self callGestureCommand:DoubleSwipeUp_Play TouchType:Normal];
                break;
            case UISwipeGestureRecognizerDirectionDown:
                [self callGestureCommand:DoubleSwipeDown_Pause TouchType:Normal];
                break;
            case UISwipeGestureRecognizerDirectionLeft:
                [self callGestureCommand:DoubleSwipeLeft_Rewind TouchType:Normal];
                break;
            case UISwipeGestureRecognizerDirectionRight:
                [self callGestureCommand:DoubleSwipeRight_Fastforward TouchType:Normal];
                break;
            default:
                break;
        }
        [[CustomAVPlayer sharedInstance] soundPlay:Swipe];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)swipeGestureSingle_Handle:(UISwipeGestureRecognizer*)sender {
    @try {
        //DDLogDebug(@"swipeGestureSingle_Handle : %lu , %lu, %lu", (unsigned long)swipeSender.direction, (unsigned long)swipeSender.numberOfTouchesRequired, (unsigned long)swipeSender.numberOfTouches);
        isSwipeEnd = false;
        [self flashView];
        switch (sender.state) {
            case UIGestureRecognizerStateBegan: {
                NSLog(@"SWIPE BEGAN");
                break;
            }
            case UIGestureRecognizerStateEnded: {
                NSLog(@"SWIPE end");
               
                break;
            }
            case UIGestureRecognizerStateCancelled: {
                NSLog(@"SWIPE cancel");
                
                break;
            }
            case UIGestureRecognizerStateChanged: {
            NSLog(@"swipe change");
                break;
            }
            default:
                break;
        }
        switch (sender.direction) {
            case UISwipeGestureRecognizerDirectionUp:
                if(timerSeconds_value < [AppDelegate appDelegate].pressVal && touchActivityGESTURE == Release)
                {
                    touchActivityGESTURE = Normal;
                    //gestureTypeObj = SingleSwipeUp_ArrowUp;
                    //[self stopAndResetGestureTimer];
                    [self callGestureCommand:SingleSwipeUp_ArrowUp TouchType:Normal];
                }
                else{
                    gestureTypeObj = SingleSwipeUp_ArrowUp;
                }
                
                break;
            case UISwipeGestureRecognizerDirectionDown:
                if(timerSeconds_value < [AppDelegate appDelegate].pressVal && touchActivityGESTURE == Release)
                {
                    touchActivityGESTURE = Normal;
                   // gestureTypeObj = SingleSwipeDown_ArrowDown;
                    //[self stopAndResetGestureTimer];
                    [self callGestureCommand:SingleSwipeDown_ArrowDown TouchType:Normal];
                }
                else{
                    gestureTypeObj = SingleSwipeDown_ArrowDown;
                }
               
                break;
            case UISwipeGestureRecognizerDirectionLeft:
                if(timerSeconds_value < [AppDelegate appDelegate].pressVal && touchActivityGESTURE == Release)
                {
                    touchActivityGESTURE = Normal;
                    //[self stopAndResetGestureTimer];
                  //  gestureTypeObj = SingleSwipeLeft_ArrowLeft;
                    [self callGestureCommand:SingleSwipeLeft_ArrowLeft TouchType:Normal];
                }
                else{
                    gestureTypeObj = SingleSwipeLeft_ArrowLeft;
                }
                
                break;
            case UISwipeGestureRecognizerDirectionRight:
                if(timerSeconds_value < [AppDelegate appDelegate].pressVal && touchActivityGESTURE == Release)
                {
                    touchActivityGESTURE = Normal;
                   // gestureTypeObj = SingleSwipeRight_ArrowRight;
                    //[self stopAndResetGestureTimer];
                [self callGestureCommand:SingleSwipeRight_ArrowRight TouchType:Normal];
                }
                else{
                    gestureTypeObj = SingleSwipeRight_ArrowRight;
                }
                break;
            default:
                break;
        }
        [[CustomAVPlayer sharedInstance] soundPlay:Swipe];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void)longPressGesture_Handle:(UILongPressGestureRecognizer*)sender
{
    @try {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"UIGestureRecognizerStateBegan LONGPRESS");
            touchActivityGESTURE = Hold;
            gestureTypeObj = SingleTap_Select;
            break;
        }
        case UIGestureRecognizerStateChanged: {
          
            //NSLog(@"UIGestureRecognizerStateChanged");
            break;
        }

        case UIGestureRecognizerStateEnded: {
            NSLog(@"UIGestureRecognizerStateEnded LONGPRESS");
            [self stopAndResetGestureTimer];
            if(touchActivityGESTURE == Hold){
                touchActivityGESTURE = Release;
                [self callGestureCommand:gestureTypeObj TouchType:Release];
            }
            else if(timerSeconds_value < [AppDelegate appDelegate].pressVal){
                touchActivityGESTURE = Normal;
                [self callGestureCommand:gestureTypeObj TouchType:Normal];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            NSLog(@"UIGestureRecognizerStateCancelled longpress");
            [self stopAndResetGestureTimer];
            touchActivityGESTURE = Release;
            [self callGestureCommand:gestureTypeObj TouchType:Release];
            break;
        }
        default:
            break;
    }
    } @catch (NSException *exception) {
            [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
        }
}
//-(void)longPressGesture_Handle2:(UILongPressGestureRecognizer*)sender {
//    // DDLogDebug(@"isSwipeEnd == %d, long press detected == %lu", isSwipeEnd, (unsigned long)singleTouchSwipeSenderDirection);
//    @try {
//        [self flashView];
//        if (isSwipeEnd) {
//            switch (singleTouchSwipeSenderDirection) {
//                case UISwipeGestureRecognizerDirectionUp:
//                    [self callGestureCommand:SingleSwipeUp_ArrowUp];
//                    break;
//                case UISwipeGestureRecognizerDirectionDown:
//                    [self callGestureCommand:SingleSwipeDown_ArrowDown];
//                    break;
//                case UISwipeGestureRecognizerDirectionLeft:
//                    [self callGestureCommand:SingleSwipeLeft_ArrowLeft];
//                    break;
//                case UISwipeGestureRecognizerDirectionRight:
//                    [self callGestureCommand:SingleSwipeRight_ArrowRight];
//                    break;
//                default:
//                    break;
//            }
//            [[CustomAVPlayer sharedInstance] soundPlay:Swipe];
//            if (sender.state == UIGestureRecognizerStateEnded) {
//                // DDLogDebug(@"long press ended");
//                isSwipeEnd = false;
//                [sender.view removeGestureRecognizer:sender];
//            }
//        }
//    } @catch (NSException *exception) {
//        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
//    }
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {    
    return YES;
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    @try {
        //NSLog(@"touchesMoved");
//        UITouch *aTouch = [touches anyObject];
//                CGPoint newLocation = [aTouch locationInView:self.view];
//                CGPoint prevLocation = [aTouch previousLocationInView:self.view];
//
//                if (newLocation.x > prevLocation.x) {
//                    NSLog(@"finger touch went right");//finger touch went right
//                } else {
//                    NSLog(@"finger touch went left");//finger touch went left
//                }
//                if (newLocation.y > prevLocation.y) {
//                    NSLog(@"finger touch went upwards");//finger touch went upwards
//                } else {
//                    NSLog(@"finger touch went downwards");//finger touch went downwards
//                }
        if (isSwipeEnd) {
            //DDLogDebug(@"touchesMoved == %d", isSwipeEnd);
            [super touchesBegan:touches withEvent:event];
        } else {
            return;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
@try {
            UITouch *aTouch = [touches anyObject];
            CGPoint newLocation = [aTouch locationInView:self.view];
            NSLog(@"touchesBegan %f %f %ld",newLocation.x,newLocation.y,aTouch.view.tag);//finger touch went right
            if(aTouch.view.tag == 101){
            touchActivityGESTURE = Normal;
            timerSeconds_value = 0.0;
            timerObj = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
            }
            else
            {
                touchActivityGESTURE = Normal;
                [self stopAndResetGestureTimer];
            }
           
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    @try {
        NSLog(@"touchesEnded");//finger touch went right
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}

-(void) callGestureCommand:(GestureType)type TouchType:(TouchActivity)getTouchType {
    @try {
        Command *objCmd;
        for (Command *obj in self.arrControlCommandGesture) {
            if (obj.command_id == type) {
                objCmd = obj;
                break;
            }
        }
        switch (mHubManagerInstance.controlDeviceTypeSource) {
            case InputSource:
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ZPOUTPUT"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CEC_COMMAND"];
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedInputDevice.PortNo TouchType:getTouchType];
                break;
            case OutputScreen:
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZPOUTPUT"];
                if([mHubManagerInstance.objSelectedOutputDevice.CreatedName containsString:@"CEC"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CEC_COMMAND"];
                }
                else{
                     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CEC_COMMAND"];
                }
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedOutputDevice.PortNo TouchType:getTouchType];
                break;
            case AVRSource:
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ZPOUTPUT"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CEC_COMMAND"];
                [APIManager callExecuteCommand_Hub:mHubManagerInstance.objSelectedHub Command:objCmd PortNo:mHubManagerInstance.objSelectedAVRDevice.PortNo TouchType:getTouchType];
                break;
            default:
                break;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)flashView {
    [self.subviewControl viewWithAnimations:^{
        self.subviewControl.alpha = ALPHA_MIN;
    } AndCompletion:^(BOOL finished) {
        self.subviewControl.alpha = ALPHA_MAX;
    }];
}
@end
