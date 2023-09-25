//
//  mHubManager.h
//  mHubApp
//
//  Created by Anshul Jain on 26/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/*
 Set mHubManager Object is a singleton class to store all details and data required by the project for cache.

 @param Hub *objSelectedHub;                            Object to save Selected MHUB device detail either it is Standalone MHUB or Master MHUB
 @param OutputDevice *objSelectedOutputDevice;          Object to save Display Output Device detail whose Volume controls shown at the bottom of the screen and through which Input Output switching work.
 @param InputDevice *objSelectedInputDevice;            Object to save Source Input Device detail whose Remote/IR controls drawn at the middle of the screen and through which Zone or Output is connected.
 @param Zone *objSelectedZone;                          Object to save Zone (which contains either single or multiple Outputs. Single Zone consist only one display and other can be audio.) Device detail whose Volume controls shown at the bottom of the screen in case of Audio device and through which Input Zone switching work.
 @param Group *objSelectedGroup;                        Object to save Group which consist of current selected Zone on which Audio works.
 @param NSMutableArray *arrLeftPanelRearranged;         Array to save Rearranged Left Panel data which is visible there. It consist of Output/Zone and Sequences device.
 @param NSMutableArray *arrSourceDeviceManaged;         Array to save Rearranged Above Input Display devices which is visible. It consist of Input and AVR device.
 @param NSMutableArray *arrAudioSourceDeviceManaged;    Array of All Audio Input devices which display from the bottom of the screen on Video Stack case.
 @param float appApiVersion;                            Store Current API version available at the MHUB-OS.
 @param float mosVersion;                               Store Current MHUB-OS version in float format.
 @param NSString *strMOSVersion;                        Store Current MHUB-OS version in String format.
 @param AVRDevice *objSelectedAVRDevice;                Object to save AVR device details which is available on either port no. 9 or 17 depends on 4x4 or 8x8 configuartion of diplay device respectively.
 @param ControlDeviceType controlDeviceTypeSource;      Variable to save above currently selected device in the input panel i.e. Input or AVR
 @param ControlDeviceType controlDeviceTypeBottom;      Variable to save bottom currently selected device in the Volume control Area i.e. Output or AVR or Audio.
 @param BOOL isPairedDevice;                            Boolean to save system pairing/stack state.
 @param HubModel masterHubModel;                        If stacked system then to save Master MHUB type. NOT USED NOW. INSTEAD objSelectedHub Generation Code is used.
 @param NSMutableArray <Hub*>*arrSlaveAudioDevice;      If system is stacked type then to store the MHUB slave device.
 @param NSMutableArray <Zone*>*arrSelectedGroupZoneList;    If zone is available in the Group, then this Array is used to save all Zone list of the group along with the current Zone.

 */

#import <Foundation/Foundation.h>

    // ** MHUB Manager Parameter Keys ** //
#define kMHUBMANAGERINSTANCE        @"mHubManagerInstance"

#define kSELECTEDHUBMODEL           @"SelectedHubModel"
#define kSELECTEDOUTPUTDEVICE       @"SelectedOutputDevice"
#define kSELECTEDINPUTDEVICE        @"SelectedInputDevice"
#define kSELECTEDZONE               @"SelectedZone"
#define kSELECTEDGROUP              @"SelectedGroup"
#define kLEFTPANELREARRANGEDARRAY   @"LeftPanelRearrangedArray"
#define kSOURCEDEVICEMANAGEDARRAY   @"SourceDeviceManagedArray"
#define kAUDIOSOURCEDEVICEARRAY     @"AudioSourceDeviceManagedArray"
#define kOutputTypeInSelectedZone     @"OutputTypeInSelectedZone"

#define kAPPAPIVERSION              @"appApiVersion"
#define kMOSVERSION                 @"mosVersion"
#define kSTRMOSVERSION              @"strMOSVersion"
#define kSTRMOSBENCHMARKVERSION     @"mos_version_benchmark"

#define kSELECTEDAVRDEVICE          @"SelectedAVRDevice"
#define kCONTROLDEVICETYPESOURCE    @"ControlDeviceTypeSource"
#define kCONTROLDEVICETYPEBOTTOM    @"ControlDeviceTypeBottom"

#define kSELECTEDCONTINUITYARRAY    @"SelectedContinuityArray"

#define kPAIREDDEVICE               @"PairedDevice"
#define kMASTERHUBMODEL             @"MasterHubModel"
#define kSLAVEAUDIODEVICEARRAY      @"SlaveAudioDeviceArray"
#define kGROUPEDAUDIOARRAY          @"GroupedAudioArray"
#define kSELECTEDGROUPZONELIST      @"SelectedGroupZoneList"

#define kSELECTEDGROUPZONELIST      @"SelectedGroupZoneList"
#define kZPARRAYAVR      @"arrayAVR"
#define kZPARRAYOUTPUT      @"arrayOutPut"
#define kZPARRAYINPUT      @"arrayInput"
#define kARRDEVICEADDEDFORPROFILE      @"arrDeviceAddedForProfile"


    // ** Hub default value Constant ** //
#define UNKNOWN_MAC         @"00:00:00:00:00:00"
#define UNKNOWN_IP          @"0.0.0.0"
#define UNKNOWN_SERIALNO    @""

    // ** Selected Hub Shared Constant ** //
#define mHubManagerInstance [mHubManager sharedInstance]

@interface mHubManager : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) Hub *objSelectedHub;
@property (strong, nonatomic) OutputDevice *objSelectedOutputDevice;
@property (strong, nonatomic) InputDevice *objSelectedInputDevice;
@property (strong, nonatomic) Zone *objSelectedZone;
@property (strong, nonatomic) Group *objSelectedGroup;
@property (strong, nonatomic) NSMutableArray *arrLeftPanelRearranged;
@property (strong, nonatomic) NSMutableArray *arrSourceDeviceManaged;
@property (strong, nonatomic) NSMutableArray *arrAudioSourceDeviceManaged;

@property (assign, nonatomic) float appApiVersion;
@property (assign, nonatomic) float mosVersion;
@property (strong, nonatomic) NSString *strMOSVersion;
@property (strong, nonatomic) AVRDevice *objSelectedAVRDevice;
@property (assign, nonatomic) ControlDeviceType controlDeviceTypeSource;
@property (assign, nonatomic) ControlDeviceType controlDeviceTypeBottom;
@property (assign, nonatomic) NSInteger OutputTypeInSelectedZone;

@property (assign, nonatomic) BOOL isPairedDevice;
@property (assign, nonatomic) HubModel masterHubModel;

@property (strong, nonatomic) NSMutableArray <Hub*>*arrSlaveAudioDevice;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrAudioDeviceHybrid;

@property (strong, nonatomic) NSMutableArray <Zone*>*arrSelectedGroupZoneList;
@property (strong, nonatomic) NSMutableArray *arrayInput;
@property (strong, nonatomic) NSMutableArray *arrayOutPut;
@property (strong, nonatomic) NSMutableArray *arrayAVR;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrDeviceAddedForProfile;

-(void) saveCustomObject:(mHubManager *)object key:(NSString *)key;
-(mHubManager*) retrieveCustomObjectWithKey:(NSString *)key;
-(void) deletemHubManagerObjectData;

-(void) syncGlobalManagerObjectV0;
-(void) syncGlobalManagerObjectV1;
-(void) syncGlobalManagerObjectV2;

-(void) reSyncLeftPanelData;
-(void) updateLeftPanelData;
-(void) reSyncLeftPanelDataV2;
-(void) updateLeftPanelDataV2;
//-(void) reSyncSourceData;
-(void) updateSourceData;

-(BOOL) searchQuickActionInShortcutItems:(Sequence*)objSeq;
-(void) addSequenceToQuickActions:(Sequence*)objSeq;
-(void) updateActiontoShortCutItems:(NSMutableArray*)arrSequence;
-(void) removeActionToShortCutItems:(Sequence*)objSeq;
-(void) removeAllActionfromShortCutItems;

-(NSMutableArray*) getZoneDataFromGroup:(NSArray*)arrZoneData ZoneIds:(NSMutableArray*)arrZoneIds;
//-(NSMutableArray*) getGroupZoneData:(NSMutableArray*)arrZoneData ZoneIds:(NSMutableArray*)arrZoneIds;
-(NSMutableArray*) getGroupZone:(NSArray*)arrGroupZone;
-(NSMutableArray*) updateGroupData:(NSMutableArray*)arrGroupList Group:(Group*)objGroup;
-(NSMutableArray*) deleteGroupData:(NSMutableArray*)arrGroupList Group:(Group*)objGroup;

-(OutputDevice*) getOutputFromZone:(Zone*)objZone;
-(void) getGroupFromZone:(Zone*)objZone GroupData:(NSMutableArray*)arrGroupData AllZoneData:(NSMutableArray*)arrZoneData completion:(void (^)(Group * objGroup, NSMutableArray <Zone*>*arrGroupZoneData))handler;
-(NSMutableArray <Zone*>*) updateZoneFromGroupZoneData:(NSMutableArray<Zone*>*)arrGroupZoneData AllZoneData:(NSMutableArray<Zone*>*)arrZoneData;
-(void) saveZPAVRArray:(NSMutableArray *)avrArr ;
-(void) saveZPOutputArray:(NSMutableArray *)OPArr;
-(void) saveZPInputArray:(NSMutableArray *)IPArr ;
-(void)  updateMhubInputData ;
@end
