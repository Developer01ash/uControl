//
//  Command.h
//  mHubApp
//
//  Created by Anshul Jain on 24/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ControlGroupType)
{
    ControlNone     = 0,
    GesturePad      = 1,
    NumberPad       = 2,
    DirectionPad    = 3,
    PlayheadPad     = 4,
    CustomPad       = 5,
    ControlTypeCount
};

typedef NS_ENUM(NSUInteger, ControlType)
{
    Volume      = 0,
    PowerKey,
    Gesture,
    GestureKey,
    Number,
    Direction,
    Playhead,
    Custom,
    
    CommandTypeCount
};

typedef NS_ENUM(NSUInteger, PowerType)
{
    Power      = 38,
    PowerOn      = 49,
    PowerOff     = 39
};

typedef NS_ENUM(NSUInteger, VolumeControl)
{
    VolUp      = 34,
    VolDown    = 35,
    VolMute    = 36
};

typedef NS_ENUM(NSUInteger, TouchActivity)
{
    Normal      = 1,
    Hold    = 2,
    Release    = 3
};

typedef NS_ENUM(NSUInteger, GestureType)
{
    SingleTap_Select            = 25,
    DoubleTap_Back              = 26,
    SingleSwipeUp_ArrowUp       = 21,
    SingleSwipeDown_ArrowDown   = 22,
    SingleSwipeLeft_ArrowLeft   = 23,
    SingleSwipeRight_ArrowRight = 24,
    DoubleSwipeUp_Play          = 12,
    DoubleSwipeDown_Pause       = 13,
    DoubleSwipeRight_Fastforward= 16,
    DoubleSwipeLeft_Rewind      = 18
};

typedef NS_ENUM(NSUInteger, ControlDeviceType) {
    Uncontrollable = 0,
    InputSource ,
    OutputScreen,
    AVRSource   ,
    AudioSource ,
    HybridSource
};

/*typedef NS_ENUM(NSUInteger, SourceType) {
    Uncontrollable = 0,
    Sky,
    AppleTV,
    Roku,
    BlueRay,
    XBox,
    NowTV,
    FireTV,
    OutputScreen,
};*/

typedef NS_ENUM(NSUInteger, DeviceType) {
    mobileSmall,
    mobileLarge,
    tabletSmall,
    tabletLarge
};

typedef NS_ENUM(NSUInteger, ControlUIType) {
    UInone = 0,
    UIgesture,
    UIbutton
};

#define kDeviceIRPackDefaults           @"IRPackPort-%ld"
#define kDeviceContinuityDefaults       @"ContinuityPort-%ld"

#define kCommandControlPowerKey         @"PowerKey"
#define kCommandControlKeyPadVolume     @"VolumeKeyPad"
#define kCommandControlKeyPadGesture    @"GestureKeyPad"
#define kCommandControlGestureView      @"GestureView"
#define kCommandControlKeyPadNumber     @"NumberKeyPad"
#define kCommandControlKeyPadDirection  @"DirectionKeyPad"
#define kCommandControlKeyPadPlayhead   @"PlayheadKeyPad"

#define kCommandId                      @"command_id"
#define kCommandCode                    @"code"
#define kCommandLabel                   @"label"
#define kCommandImage                   @"image"
#define kCommandImageLight              @"image_light"
//#define kCommandImageDisable            @"image_disable"
#define kCommandImageLabel              @"image_label"
#define kCommandIsVisible               @"isVisible"
#define kCommandIsRepeat                @"repeat"
#define kCommandLocationX               @"locationX" // X define Row Number
#define kCommandLocationY               @"locationY" // Y define Column Number
#define kCommandLocationXLandscape      @"locationXLandscape" // X define Row Number
#define kCommandLocationYLandscape      @"locationYLandscape" // Y define Column Number
#define kCommandUIType                  @"UIType"
#define kCommandSizeWidth               @"sizeWidth"
#define kCommandSizeHeight              @"sizeHeight"

#define kAllCommands                    @"allCommands"
#define kArrCGOrder                     @"arrCGOrder"

#define kVolume     @"volume"
#define kPowerKey   @"powerKey"
#define kGesture    @"gesture"
#define kGestureKey @"gestureKey"
#define kNumber     @"number"
#define kDirection  @"direction"
#define kPlayhead   @"playhead"
#define kCustom   @"custom"



@interface Command : NSObject
@property(nonatomic) NSInteger command_id;
@property(nonatomic, retain) NSString *code;
@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) UIImage *image_light;
@property(nonatomic, retain) NSString *image_label;
@property(nonatomic) BOOL isVisible;
@property(nonatomic) BOOL isRepeat;
@property(nonatomic) NSInteger locationX;
@property(nonatomic) NSInteger locationY;
@property(nonatomic) NSInteger locationXLandscape;
@property(nonatomic) NSInteger locationYLandscape;
@property(nonatomic) NSInteger sizeWidth;
@property(nonatomic) NSInteger sizeHeight;

@property(nonatomic) ControlUIType ctrlType;


//+(Command*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectArray:(NSArray*)arrResp;
+(NSMutableArray*) getXMLObjectArray:(NSArray*)arrResp;
//+(ControlDeviceType) getSourceType_Name:(NSString*)strDeviceName SourceType:(ControlDeviceType)type;
+(ControlUIType) getControlUIType:(NSString*)strControlUIType;
+(Command*)getLocalCommandData:(NSInteger)command_id;
@end
