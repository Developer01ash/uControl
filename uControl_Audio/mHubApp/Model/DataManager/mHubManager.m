//
//  mHubManager.m
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

#import "mHubManager.h"

@implementation mHubManager

+ (instancetype)sharedInstance {
    static mHubManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[mHubManager alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    self.arrLeftPanelRearranged     = [[NSMutableArray alloc] init];
    self.arrSourceDeviceManaged     = [[NSMutableArray alloc] init];
    self.arrAudioSourceDeviceManaged= [[NSMutableArray alloc] init];
    self.appApiVersion              = 1.0;
    self.strMOSVersion              = @"";
    self.controlDeviceTypeSource    = Uncontrollable;
    self.controlDeviceTypeBottom    = Uncontrollable;
    self.OutputTypeInSelectedZone   = audioOnly;
    self.isPairedDevice             = false;
    self.arrSlaveAudioDevice        = [[NSMutableArray alloc] init];
    self.arrSelectedGroupZoneList   = [[NSMutableArray alloc] init];
    self.arrayAVR   = [[NSMutableArray alloc] init];
    self.arrayOutPut   = [[NSMutableArray alloc] init];
    self.arrayInput   = [[NSMutableArray alloc] init];
    self.arrDeviceAddedForProfile = [[NSMutableArray alloc] init];
    
    return self;
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:self.objSelectedHub forKey:kSELECTEDHUBMODEL];
        [encoder encodeObject:self.objSelectedInputDevice forKey:kSELECTEDINPUTDEVICE];
        [encoder encodeObject:self.objSelectedOutputDevice forKey:kSELECTEDOUTPUTDEVICE];
        [encoder encodeObject:self.objSelectedAVRDevice forKey:kSELECTEDAVRDEVICE];

        [encoder encodeObject:self.objSelectedZone forKey:kSELECTEDZONE];
        [encoder encodeObject:self.objSelectedGroup forKey:kSELECTEDGROUP];

        [encoder encodeObject:self.arrLeftPanelRearranged forKey:kLEFTPANELREARRANGEDARRAY];
        [encoder encodeObject:self.arrSourceDeviceManaged forKey:kSOURCEDEVICEMANAGEDARRAY];
        [encoder encodeObject:self.arrAudioSourceDeviceManaged forKey:kAUDIOSOURCEDEVICEARRAY];


        [encoder encodeInteger:self.controlDeviceTypeSource forKey:kCONTROLDEVICETYPESOURCE];
        [encoder encodeInteger:self.controlDeviceTypeBottom forKey:kCONTROLDEVICETYPEBOTTOM];
        [encoder encodeInteger:self.OutputTypeInSelectedZone forKey:kOutputTypeInSelectedZone];
        

        [encoder encodeFloat:self.appApiVersion forKey:kAPPAPIVERSION];
        [encoder encodeFloat:self.mosVersion forKey:kMOSVERSION];
        [encoder encodeObject:self.strMOSVersion forKey:kSTRMOSVERSION];

        [encoder encodeBool:self.isPairedDevice forKey:kPAIREDDEVICE];
        [encoder encodeInteger:self.masterHubModel forKey:kMASTERHUBMODEL];

        [encoder encodeObject:self.arrSlaveAudioDevice forKey:kSLAVEAUDIODEVICEARRAY];
        [encoder encodeObject:self.arrSelectedGroupZoneList forKey:kSELECTEDGROUPZONELIST];

        [encoder encodeObject:self.arrayAVR forKey:kZPARRAYAVR];
        [encoder encodeObject:self.arrayOutPut forKey:kZPARRAYOUTPUT];
        [encoder encodeObject:self.arrayInput forKey:kZPARRAYINPUT];
        [encoder encodeObject:self.arrDeviceAddedForProfile forKey:kARRDEVICEADDEDFORPROFILE];


    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.objSelectedHub             = [decoder decodeObjectForKey:kSELECTEDHUBMODEL];
            self.objSelectedInputDevice     = [decoder decodeObjectForKey:kSELECTEDINPUTDEVICE];
            self.objSelectedOutputDevice    = [decoder decodeObjectForKey:kSELECTEDOUTPUTDEVICE];
            self.objSelectedZone            = [decoder decodeObjectForKey:kSELECTEDZONE];
            self.objSelectedGroup           = [decoder decodeObjectForKey:kSELECTEDGROUP];
            self.arrLeftPanelRearranged     = [decoder decodeObjectForKey:kLEFTPANELREARRANGEDARRAY];
            self.arrSourceDeviceManaged     = [decoder decodeObjectForKey:kSOURCEDEVICEMANAGEDARRAY];
            self.arrAudioSourceDeviceManaged= [decoder decodeObjectForKey:kAUDIOSOURCEDEVICEARRAY];
            self.appApiVersion              = [decoder decodeFloatForKey:kAPPAPIVERSION];
            self.mosVersion                 = [decoder decodeFloatForKey:kMOSVERSION];
            self.strMOSVersion              = [[decoder decodeObjectForKey:kSTRMOSVERSION] isNotEmpty] ? [decoder decodeObjectForKey:kSTRMOSVERSION] : [NSString stringWithFormat:@"%.02f", self.mosVersion];
            self.objSelectedAVRDevice       = [decoder decodeObjectForKey:kSELECTEDAVRDEVICE];
            self.controlDeviceTypeSource    = (ControlDeviceType)[decoder decodeIntegerForKey:kCONTROLDEVICETYPESOURCE];
            self.controlDeviceTypeBottom    = (ControlDeviceType)[decoder decodeIntegerForKey:kCONTROLDEVICETYPEBOTTOM];
            self.isPairedDevice             = [decoder decodeBoolForKey:kPAIREDDEVICE];
            self.masterHubModel             = (HubModel)[decoder decodeIntegerForKey:kMASTERHUBMODEL];
            self.arrSlaveAudioDevice        = [decoder decodeObjectForKey:kSLAVEAUDIODEVICEARRAY];
            self.arrSelectedGroupZoneList   = [decoder decodeObjectForKey:kSELECTEDGROUPZONELIST];
            self.OutputTypeInSelectedZone = [decoder decodeIntegerForKey:kOutputTypeInSelectedZone];

            self.arrayAVR        = [decoder decodeObjectForKey:kZPARRAYAVR];
            self.arrayOutPut        = [decoder decodeObjectForKey:kZPARRAYOUTPUT];
            self.arrayInput        = [decoder decodeObjectForKey:kZPARRAYINPUT];
            self.arrDeviceAddedForProfile        = [decoder decodeObjectForKey:kARRDEVICEADDEDFORPROFILE];

        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

#pragma mark - Manage mHubManager Object
-(void) saveCustomObject:(mHubManager *)object key:(NSString *)key {
    @try {
        // if (![object.objSelectedHub.Address isEqualToString:STATICTESTIP]) {
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
            [Utility saveUserDefaults:key value:encodedObject];
        // }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(mHubManager*) retrieveCustomObjectWithKey:(NSString *)key {
    @try {
        mHubManager *object = [[mHubManager alloc] init];
        NSData *encodedObject = [Utility retrieveUserDefaults:key];
        if ([encodedObject isNotEmpty]) {
            object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
            return object;
        } else {
            return nil;
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) deletemHubManagerObjectData {
    @try {
        [Utility deleteAllUserDefaults];
        [Utility removeAllImageFromDocumentDirectory];
        

        self.objSelectedHub                 = nil;
        self.objSelectedInputDevice         = nil;
        self.objSelectedOutputDevice        = nil;
        self.objSelectedZone                = nil;
        self.objSelectedGroup               = nil;
       
        self.arrLeftPanelRearranged         = [[NSMutableArray alloc] init];
        self.arrSourceDeviceManaged         = [[NSMutableArray alloc] init];
        self.arrAudioSourceDeviceManaged    = [[NSMutableArray alloc] init];
        self.objSelectedAVRDevice           = nil;
        self.controlDeviceTypeSource        = Uncontrollable;
        self.controlDeviceTypeBottom        = Uncontrollable;
        self.isPairedDevice                 = false;
        self.masterHubModel                 = mHubFake;
        self.arrSlaveAudioDevice            = [[NSMutableArray alloc] init];
        self.arrSelectedGroupZoneList       = [[NSMutableArray alloc] init];
        self.OutputTypeInSelectedZone       = audioOnly;
        self.arrayAVR   = [[NSMutableArray alloc] init];
           self.arrayOutPut   = [[NSMutableArray alloc] init];
           self.arrayInput   = [[NSMutableArray alloc] init];
       // self.arrDeviceAddedForProfile =  [[NSMutableArray alloc]init];
        [self removeAllActionfromShortCutItems];
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
        [ContinuityCommand saveCustomObject:@[] key:kSELECTEDCONTINUITYARRAY];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Manage Global Object
-(void) syncGlobalManagerObjectV0 {
    @try {

        // Leftpanel Data Arrange
        [self reSyncLeftPanelData];

        // Source Managed Data
        [self reSyncSourceData];

        if (self.objSelectedHub.HubOutputData.count > 0) {
            self.objSelectedOutputDevice = (OutputDevice*)self.objSelectedHub.HubOutputData.firstObject;
            [SSDPManager getSSDPSwitchStatus:(int) self.objSelectedOutputDevice.Index completion:^(APIResponse *objResponse) {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:HUB_SUCCESS];
            }];
        }
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) syncGlobalManagerObjectV1 {
    @try {
        // Leftpanel Data Arrange
        [self reSyncLeftPanelData];

        // Source Managed Data
        [self reSyncSourceData];


        if (self.objSelectedHub.HubOutputData.count > 0) {
            if ([self.objSelectedOutputDevice isNotEmpty]) {
                for (OutputDevice *objOP in self.objSelectedHub.HubOutputData) {
                    if (objOP.Index == self.objSelectedOutputDevice.Index) {
                        self.objSelectedOutputDevice = objOP;
                    }
                }
                for (InputDevice *objIP in self.objSelectedHub.HubInputData) {
                    if (objIP.Index == self.objSelectedInputDevice.Index) {
                        self.objSelectedInputDevice = objIP;
                        [ContinuityCommand saveCustomObject:[ContinuityCommand getDictionaryArray:objIP.arrContinuity] key:kSELECTEDCONTINUITYARRAY];
                    }
                }
            } else {
                self.objSelectedOutputDevice = (OutputDevice*) self.objSelectedHub.HubOutputData.firstObject;
                [APIManager getSwitchStatus:self.objSelectedOutputDevice.Index completion:^(APIResponse *responseObject) {
                    if (responseObject.error) {
                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.response];
                    }
                }];
            }
        }

        if (self.objSelectedHub.AVR_IRPack && self.objSelectedHub.HubAVRList.count > 0) {
            self.objSelectedAVRDevice = self.objSelectedHub.HubAVRList.firstObject;
        }

        if ([self.objSelectedHub isPairedSetup]) {
            self.masterHubModel = mHubPro;
            self.arrSlaveAudioDevice = [[NSMutableArray alloc] initWithArray:[Hub getAudioObjectArrayFromCount:2]];

            for (int counter = 0; counter < self.arrSlaveAudioDevice.count; counter++) {
                [APIManager mHUBAudioStateXML_Audio:[self.arrSlaveAudioDevice objectAtIndex:counter] completion:^(APIResponse *responseObject) {
                    if (responseObject.error) {
                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.response];
                    } else {
                        [self.arrSlaveAudioDevice replaceObjectAtIndex:counter withObject:responseObject.response];
                    }
                }];
            }
        } else {
            self.arrSlaveAudioDevice = [[NSMutableArray alloc] init];
        }

        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) syncGlobalManagerObjectV2 {
    @try {
        /* ========= Data Management ======== */

        for (Zone *objZone in self.objSelectedHub.HubZoneData) {
            OutputDevice *objOPZone = [self getOutputFromZone:objZone];
            NSInteger intIndex = -1;
            intIndex = [objZone.arrOutputs indexOfObject:objOPZone];
            for (OutputDevice *objOP in self.objSelectedHub.HubOutputData) {
                ////NSLog(@"objOPZone.Index == %ld AND objOP.Index == %ld",(long)objOPZone.Index , (long)objOP.Index);
                if (objOPZone.Index == objOP.Index) {
                    OutputDevice *objOPTemp = [OutputDevice getOutputObject_From:objOPZone To:objOP];
                    objZone.isIRPackAvailable = objOPTemp.objCommandType.volume.count > 0 ? true : false;
                    [objZone.arrOutputs replaceObjectAtIndex:intIndex withObject:objOPTemp];
                    break;
                }
            }
            //August2020: After the pro2 devices. The below code is written to define whether Zone is Audio only, video only or both audio,video outputs.
            BOOL flagAllMasters = true;
            for (int i = 0; i < objZone.arrOutputs.count; i++) {
                        OutputDevice *obj = [objZone.arrOutputs objectAtIndex:i];
                        if([obj.UnitId containsString:@"S"])
                        {
                            flagAllMasters = false;
                        }
            }
                       if(objZone.arrOutputs.count == 1)
                       {
                           OutputDevice *obj = [objZone.arrOutputs objectAtIndex:0];
                           if([obj.outputType_VideoOrAudio containsString:@"audio"])
                           {
                               objZone.OutputTypeInSelectedZone = audioOnly;
                           }
                           else  if(![obj.outputType_VideoOrAudio isNotEmpty] && [obj.UnitId containsString:@"S"])
                           {
                               objZone.OutputTypeInSelectedZone = audioOnly;
                           }
                           else
                           {
                                objZone.OutputTypeInSelectedZone = videoOnly;
                           }
                           
                       }
                       else if(flagAllMasters)
                       {
                           objZone.OutputTypeInSelectedZone = allMasterOutputs;
                       }
                       else // if([obj.outputType_VideoOrAudio containsString:@"video"] || [obj.UnitId isEqualToString:@"M1"])
                        {
                             objZone.OutputTypeInSelectedZone = audioVideoZone;
                         }

            self.OutputTypeInSelectedZone = objZone.OutputTypeInSelectedZone;
        }
        // Leftpanel Data Arrange
        [self reSyncLeftPanelDataV2];
        // Source Managed Data
        [self reSyncSourceDataV2];

        if (self.objSelectedHub.AVR_IRPack && self.objSelectedHub.HubAVRList.count > 0) {
            self.objSelectedAVRDevice = self.objSelectedHub.HubAVRList.firstObject;
        }
        else
        {
            
        }

        if (self.objSelectedHub.HubZoneData.count > 0) {
            if ([self.objSelectedZone isNotEmpty]) {
                self.objSelectedZone = [Zone getFilteredZoneData:self.objSelectedZone.zone_id ZoneData:self.objSelectedHub.HubZoneData];
            } else {
                self.objSelectedZone = (Zone*) self.objSelectedHub.HubZoneData.firstObject;
            }

            OutputDevice *objOPZone = [self getOutputFromZone:self.objSelectedZone];;

            if ([objOPZone isNotEmpty]) {
                objOPZone = [OutputDevice getOutputObject_From:objOPZone To:[OutputDevice getFilteredOutputDeviceData:objOPZone.Index OutputData:self.objSelectedHub.HubOutputData]];
            }

            if ([objOPZone isNotEmpty]) {
                self.objSelectedOutputDevice = objOPZone;
            }

            for (InputDevice *objIP in self.objSelectedHub.HubInputData) {
                if (self.objSelectedOutputDevice.InputIndex == objIP.Index) {
                    self.objSelectedInputDevice = objIP;
                    break;
                }
            }

            [self getGroupFromZone:self.objSelectedZone GroupData:self.objSelectedHub.HubGroupData AllZoneData:self.objSelectedHub.HubZoneData completion:^(Group *objGroup, NSMutableArray<Zone *> *arrGroupZoneData) {
                if ([objGroup isNotEmpty]) {
                    self.objSelectedGroup = [[Group alloc] initWithGroup:objGroup];
                }
                if ([arrGroupZoneData isNotEmpty]) {
                    // assigning Zone value to array from string value.
                    self.arrSelectedGroupZoneList = [[NSMutableArray alloc] initWithArray:arrGroupZoneData];
                }
            }];
        }
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Manage LeftPanel Device Data

-(void) reSyncLeftPanelData {
    @try {
        NSMutableArray *arrCombinedData;
        if ([self.arrLeftPanelRearranged isNotEmpty]) {
            arrCombinedData = [[NSMutableArray alloc] initWithArray:self.arrLeftPanelRearranged];
            
            for (int counter = 0; counter < arrCombinedData.count; counter++) {
                NSObject *objTableData = [arrCombinedData objectAtIndex:counter];
                if ([objTableData isKindOfClass:[OutputDevice class]]) {
                    OutputDevice *objOPTemp = (OutputDevice*)objTableData;
                    for (int counter = 0; counter < self.objSelectedHub.HubOutputData.count; counter++) {
                        OutputDevice *objOPList = self.objSelectedHub.HubOutputData[counter];
                        if (objOPTemp.Index == objOPList.Index) {
                            objOPList.isDeleted = false;
                            [self.objSelectedHub.HubOutputData replaceObjectAtIndex:counter withObject:objOPList];
                        }
                    }
                } else {
                    Sequence *objSeqTemp = (Sequence*)objTableData;
                    for (int counter = 0; counter < self.objSelectedHub.HubSequenceList.count; counter++) {
                        Sequence *objSeqList = self.objSelectedHub.HubSequenceList[counter];
                        if ([objSeqTemp.macro_id isEqualToString:objSeqList.macro_id]) {
                            objSeqList.isDeleted = false;
                            [self.objSelectedHub.HubSequenceList replaceObjectAtIndex:counter withObject:objSeqList];
                        }
                    }
                }
            }
            
            NSMutableArray *arrOutputs = [[NSMutableArray alloc] initWithArray:self.objSelectedHub.HubOutputData];
            NSMutableArray *arrSequence = [[NSMutableArray alloc] initWithArray:self.objSelectedHub.HubSequenceList];
            
            for (int counter = 0; counter < arrCombinedData.count; counter++) {
                NSObject *objTableData = [arrCombinedData objectAtIndex:counter];
                if ([objTableData isKindOfClass:[OutputDevice class]]) {
                    OutputDevice *objOPTemp = (OutputDevice*)objTableData;
                    for (OutputDevice *objOP in arrOutputs) {
                        if (objOPTemp.Index == objOP.Index) {
                            objOP.isDeleted = false;
                            [arrCombinedData replaceObjectAtIndex:counter withObject:objOP];
                        }
                    }
                } else {
                    Sequence *objSeqTemp = (Sequence*)objTableData;
                    Sequence *objSeq = [Sequence getFilteredSequenceData:objSeqTemp.macro_id Sequence:arrSequence];
                    if ([objSeq isNotEmpty]) {
                        if ([objSeqTemp.macro_id isEqualToString:objSeq.macro_id]) {
                            objSeq.isDeleted = false;
                            [arrCombinedData replaceObjectAtIndex:counter withObject:objSeq];
                        }
                    } else {
                        [arrCombinedData removeObject:objSeqTemp];
                    }
                }
            }
        } else {
            arrCombinedData = [[NSMutableArray alloc] init];
            for (int counter = 0; counter < self.objSelectedHub.HubOutputData.count; counter++) {
                OutputDevice *objOPList = self.objSelectedHub.HubOutputData[counter];
                objOPList.isDeleted = false;
                [self.objSelectedHub.HubOutputData replaceObjectAtIndex:counter withObject:objOPList];
            }
            for (int counter = 0; counter < self.objSelectedHub.HubSequenceList.count; counter++) {
                Sequence *objSeqList = self.objSelectedHub.HubSequenceList[counter];
                objSeqList.isDeleted = false;
                [self.objSelectedHub.HubSequenceList replaceObjectAtIndex:counter withObject:objSeqList];
            }
            [arrCombinedData addObjectsFromArray:self.objSelectedHub.HubOutputData];
            [arrCombinedData addObjectsFromArray:self.objSelectedHub.HubSequenceList];
            [arrCombinedData addObjectsFromArray:self.objSelectedHub.HubControlsList];
        }
        self.arrLeftPanelRearranged = [[NSMutableArray alloc] initWithArray:arrCombinedData];
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
        [APIManager reloadDisplaySubView];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) updateLeftPanelData {
    @try {
        NSMutableArray *arrCombinedData = [[NSMutableArray alloc] initWithArray:self.arrLeftPanelRearranged];
        NSMutableArray *arrOutputs = [[NSMutableArray alloc] initWithArray:self.objSelectedHub.HubOutputData];
        NSMutableArray *arrSequence = [[NSMutableArray alloc] initWithArray:self.objSelectedHub.HubSequenceList];
        
        for (int counter = 0; counter < arrCombinedData.count; counter++) {
            NSObject *objTableData = [arrCombinedData objectAtIndex:counter];
            if ([objTableData isKindOfClass:[OutputDevice class]]) {
                OutputDevice *objOPTemp = (OutputDevice*)objTableData;
                OutputDevice *objOP = [OutputDevice getFilteredOutputDeviceData:objOPTemp.Index OutputData:arrOutputs];
                if ([objOP isNotEmpty] && objOPTemp.isDeleted == false && objOPTemp.Index == objOP.Index) {
                    [arrCombinedData replaceObjectAtIndex:counter withObject:objOP];
                } else {
                    [arrCombinedData removeObject:objOPTemp];
                }
            } else {
                Sequence *objSeqTemp = (Sequence*)objTableData;
                Sequence *objSeq = [Sequence getFilteredSequenceData:objSeqTemp.macro_id Sequence:arrSequence];
                if ([objSeq isNotEmpty] && objSeqTemp.isDeleted == false && [objSeqTemp.macro_id isEqualToString:objSeq.macro_id]) {
                    [arrCombinedData replaceObjectAtIndex:counter withObject:objSeq];
                } else {
                    [arrCombinedData removeObject:objSeqTemp];
                }
            }
        }
        
        for (OutputDevice *objOP in arrOutputs) {
            OutputDevice *objOPFilter;
            for (NSObject *objTableData in arrCombinedData) {
                if ([objTableData isKindOfClass:[OutputDevice class]]) {
                    OutputDevice *objOPTemp = (OutputDevice*)objTableData;
                    if (objOP.Index == objOPTemp.Index) {
                        objOPFilter = objOPTemp;
                    }
                }
            }
            if (![objOPFilter isNotEmpty] && objOP.isDeleted == false) {
                [arrCombinedData addObject:objOP];
            }
        }
        
        for (Sequence *objSeq in arrSequence) {
            Sequence *objSeqFilter;
            for (NSObject *objTableData in arrCombinedData) {
                if ([objTableData isKindOfClass:[Sequence class]]) {
                    Sequence *objSeqTemp = (Sequence*)objTableData;
                    if ([objSeq.macro_id isEqualToString:objSeqTemp.macro_id]) {
                        objSeqFilter = objSeqTemp;
                    }
                }
            }
            if (![objSeqFilter isNotEmpty] && objSeq.isDeleted == false) {
                [arrCombinedData addObject:objSeq];
            }
        }
        
        self.arrLeftPanelRearranged = [[NSMutableArray alloc] initWithArray:arrCombinedData];
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
        [APIManager reloadDisplaySubView];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(void) saveZPAVRArray:(NSMutableArray *)avrArr {
    self.arrayAVR = avrArr;
    [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
}
-(void) saveZPOutputArray:(NSMutableArray *)OPArr {
    self.arrayOutPut = OPArr;
    [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
}
-(void) saveZPInputArray:(NSMutableArray *)IPArr {
    self.arrayInput = IPArr;
    [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
}


#pragma mark - Manage LeftPanel Device Data V2

-(void) reSyncLeftPanelDataV2 {
    @try {
        NSMutableArray *arrCombinedData;
        if ([self.arrLeftPanelRearranged isNotEmpty]) {
            arrCombinedData = [[NSMutableArray alloc] initWithArray:self.arrLeftPanelRearranged];
            for (int counter = 0; counter < arrCombinedData.count; counter++) {
                NSObject *objTableData = [arrCombinedData objectAtIndex:counter];
                if ([objTableData isKindOfClass:[Zone class]]) {
                    Zone *objZoneTemp = (Zone*)objTableData;
                    for (int counter = 0; counter < self.objSelectedHub.HubZoneData.count; counter++) {
                        Zone *objZoneList = self.objSelectedHub.HubZoneData[counter];
                        if ([objZoneTemp.zone_id isEqualToString:objZoneList.zone_id]) {
                            objZoneList.isDeleted = false;
                            [self.objSelectedHub.HubZoneData replaceObjectAtIndex:counter withObject:objZoneList];
                            break;
                        }
                    }
                } else if ([objTableData isKindOfClass:[Sequence class]]) {
                    Sequence *objSeqTemp = (Sequence*)objTableData;
                    for (int counter = 0; counter < self.objSelectedHub.HubSequenceList.count; counter++) {
                        Sequence *objSeqList = self.objSelectedHub.HubSequenceList[counter];
                        if ([objSeqTemp.macro_id isEqualToString:objSeqList.macro_id]) {
                            objSeqList.isDeleted = false;
                            [self.objSelectedHub.HubSequenceList replaceObjectAtIndex:counter withObject:objSeqList];
                            break;
                        }
                    }
                }
            }

            NSMutableArray *arrZones = [[NSMutableArray alloc] initWithArray: self.objSelectedHub.HubZoneData];
            NSMutableArray *arrSequence = [[NSMutableArray alloc] initWithArray: self.objSelectedHub.HubSequenceList];

            for (int counter = 0; counter < arrCombinedData.count; counter++) {
                NSObject *objTableData = [arrCombinedData objectAtIndex:counter];
                if ([objTableData isKindOfClass:[Zone class]]) {
                    Zone *objZoneTemp = (Zone*)objTableData;
                    /*for (Zone *objZone in arrZones) {
                        if ([objZoneTemp.zone_id isEqualToString:objZone.zone_id]) {
                            objZone.isDeleted = false;
                            [arrCombinedData replaceObjectAtIndex:counter withObject:objZone];
                        }
                    }*/

                    Zone *objZone = [Zone getFilteredZoneData:objZoneTemp.zone_id ZoneData:arrZones];
                    if ([objZone isNotEmpty] && objZoneTemp.isDeleted == false && [objZoneTemp.zone_id isEqualToString:objZone.zone_id]) {
                        [arrCombinedData replaceObjectAtIndex:counter withObject:objZone];
                    } else {
                        [arrCombinedData removeObject:objZoneTemp];
                    }

                } else if ([objTableData isKindOfClass:[Sequence class]]) {
                    Sequence *objSeqTemp = (Sequence*)objTableData;
                    Sequence *objSeq = [Sequence getFilteredSequenceData:objSeqTemp.macro_id Sequence:arrSequence];
                    if ([objSeq isNotEmpty]) {
                        if ([objSeqTemp.macro_id isEqualToString:objSeq.macro_id]) {
                            objSeq.isDeleted = false;
                            [arrCombinedData replaceObjectAtIndex:counter withObject:objSeq];
                        }
                    } else {
                        [arrCombinedData removeObject:objSeqTemp];
                    }
                }
            }
        } else {
            arrCombinedData = [[NSMutableArray alloc] init];
            for (int counter = 0; counter < self.objSelectedHub.HubZoneData.count; counter++) {
                Zone *objZoneList = self.objSelectedHub.HubZoneData[counter];
                ////NSLog(@"self.objSelectedHub.HubZoneData %d",self.objSelectedHub.HubZoneData[counter].isDeleted);
                objZoneList.isDeleted = false;
                [self.objSelectedHub.HubZoneData replaceObjectAtIndex:counter withObject:objZoneList];
            }
            for (int counter = 0; counter < self.objSelectedHub.HubSequenceList.count; counter++) {
                Sequence *objSeqList = self.objSelectedHub.HubSequenceList[counter];
                objSeqList.isDeleted = false;
                [self.objSelectedHub.HubSequenceList replaceObjectAtIndex:counter withObject:objSeqList];
            }
            
            [arrCombinedData addObjectsFromArray:self.objSelectedHub.HubZoneData];
            [arrCombinedData addObjectsFromArray:self.objSelectedHub.HubSequenceList];
            [arrCombinedData addObjectsFromArray:self.objSelectedHub.HubControlsList];
        }
        self.arrLeftPanelRearranged = [[NSMutableArray alloc] initWithArray:arrCombinedData];
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
        [APIManager reloadDisplaySubView];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) updateLeftPanelDataV2 {
    @try {
        NSMutableArray *arrCombinedData = [[NSMutableArray alloc] initWithArray:self.arrLeftPanelRearranged];
        NSMutableArray *arrZones = [[NSMutableArray alloc] initWithArray:self.objSelectedHub.HubZoneData];
        NSMutableArray *arrSequence = [[NSMutableArray alloc] initWithArray:self.objSelectedHub.HubSequenceList];

        for (int counter = 0; counter < arrCombinedData.count; counter++) {
            NSObject *objTableData = [arrCombinedData objectAtIndex:counter];
            if ([objTableData isKindOfClass:[Zone class]]) {
                Zone *objZoneTemp = (Zone*)objTableData;
                Zone *objZone = [Zone getFilteredZoneData:objZoneTemp.zone_id ZoneData:arrZones];
                if ([objZone isNotEmpty] && objZoneTemp.isDeleted == false && [objZoneTemp.zone_id isEqualToString:objZone.zone_id]) {
                    [arrCombinedData replaceObjectAtIndex:counter withObject:objZone];
                } else {
                    [arrCombinedData removeObject:objZoneTemp];
                    self.objSelectedHub.HubZoneData[counter].isDeleted = objZoneTemp.isDeleted;
                }
                
            } else if ([objTableData isKindOfClass:[Sequence class]]) {
                Sequence *objSeqTemp = (Sequence*)objTableData;
                Sequence *objSeq = [Sequence getFilteredSequenceData:objSeqTemp.macro_id Sequence:arrSequence];
                if ([objSeq isNotEmpty] && objSeqTemp.isDeleted == false && [objSeqTemp.macro_id isEqualToString:objSeq.macro_id]) {
                    [arrCombinedData replaceObjectAtIndex:counter withObject:objSeq];
                } else {
                    [arrCombinedData removeObject:objSeqTemp];
                }
            }
        }

        for (Zone *objZone in arrZones) {
            Zone *objZoneFilter;
            for (NSObject *objTableData in arrCombinedData) {
                if ([objTableData isKindOfClass:[Zone class]]) {
                    Zone *objZoneTemp = (Zone*)objTableData;
                    if ([objZone.zone_id isEqualToString:objZoneTemp.zone_id]) {
                        objZoneFilter = objZoneTemp;
                    }
                }
            }
            if (![objZoneFilter isNotEmpty] && objZone.isDeleted == false) {
                [arrCombinedData addObject:objZone];
            }
        }

        for (Sequence *objSeq in arrSequence) {
            Sequence *objSeqFilter;
            for (NSObject *objTableData in arrCombinedData) {
                if ([objTableData isKindOfClass:[Sequence class]]) {
                    Sequence *objSeqTemp = (Sequence*)objTableData;
                    if ([objSeq.macro_id isEqualToString:objSeqTemp.macro_id]) {
                        objSeqFilter = objSeqTemp;
                    }
                }
            }
            if (![objSeqFilter isNotEmpty] && objSeq.isDeleted == false) {
                [arrCombinedData addObject:objSeq];
            }
        }

        self.arrLeftPanelRearranged = [[NSMutableArray alloc] initWithArray:arrCombinedData];
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
        [APIManager reloadDisplaySubView];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Manage Source Device Data

-(void) reSyncSourceData {
    @try {
        NSMutableArray *arrInputData;
        if ([self.arrSourceDeviceManaged isNotEmpty]) {
            arrInputData = [[NSMutableArray alloc] initWithArray:self.arrSourceDeviceManaged];
            
            for (int counter = 0; counter < arrInputData.count; counter++) {
                InputDevice *objIPTemp = (InputDevice*)[arrInputData objectAtIndex:counter];
                for (int counter = 0; counter < self.objSelectedHub.HubInputData.count; counter++) {
                    InputDevice *objIPList = self.objSelectedHub.HubInputData[counter];
                    if (objIPTemp.Index == objIPList.Index) {
                        objIPList.isDeleted = false;
                        [self.objSelectedHub.HubInputData replaceObjectAtIndex:counter withObject:objIPList];
                    }
                }
            }
            
            NSMutableArray *arrInputs = [[NSMutableArray alloc] initWithArray:self.objSelectedHub.HubInputData];
            
            for (int counter = 0; counter < arrInputData.count; counter++) {
                InputDevice *objIPTemp = (InputDevice*)[arrInputData objectAtIndex:counter];
                for (InputDevice *objIP in arrInputs) {
                    if ([objIP isNotEmpty] && objIPTemp.isDeleted == false && objIPTemp.Index == objIP.Index) {
                        [arrInputData replaceObjectAtIndex:counter withObject:objIP];
                        //break;
                    }
                }
            }
        } else {
            arrInputData = [[NSMutableArray alloc] init];
            for (int counter = 0; counter < self.objSelectedHub.HubInputData.count; counter++) {
                InputDevice *objIPList = self.objSelectedHub.HubInputData[counter];
                objIPList.isDeleted = false;
                [self.objSelectedHub.HubInputData replaceObjectAtIndex:counter withObject:objIPList];
            }
            [arrInputData addObjectsFromArray:self.objSelectedHub.HubInputData];
        }
        self.arrSourceDeviceManaged = [[NSMutableArray alloc] initWithArray:arrInputData];
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
        [APIManager reloadSourceSubView];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)  updateSourceData {
    @try {
        NSMutableArray *arrInputData = [[NSMutableArray alloc] initWithArray:self.arrSourceDeviceManaged];
        NSMutableArray *arrInputs = [[NSMutableArray alloc] initWithArray:self.objSelectedHub.HubInputData];
        
        for (int counter = 0; counter < arrInputData.count; counter++) {
            InputDevice *objIPTemp = (InputDevice*)[arrInputData objectAtIndex:counter];
            InputDevice *objIP = [InputDevice getFilteredInputDeviceData:objIPTemp.Index InputData:arrInputs];
            objIPTemp.isDeleted = objIP.isDeleted;
            if ([objIP isNotEmpty] && objIPTemp.isDeleted == true && objIPTemp.Index == objIP.Index) {
                [arrInputData replaceObjectAtIndex:counter withObject:objIP];
            } else {
               // [arrInputData removeObject:objIPTemp];
            }
        }
        
        for (InputDevice *objIP in arrInputs) {
            InputDevice *objIPFilter;
            for (NSObject *objTableData in arrInputData) {
                if ([objTableData isKindOfClass:[InputDevice class]]) {
                    InputDevice *objSeqTemp = (InputDevice*)objTableData;
                    if (objIP.Index == objSeqTemp.Index) {
                        objIPFilter = objSeqTemp;
                    }
                }
            }
            if (![objIPFilter isNotEmpty] && objIP.isDeleted == true) {
                [arrInputData addObject:objIP];
            }
        }
        
        self.arrSourceDeviceManaged = [[NSMutableArray alloc] initWithArray:arrInputData];
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
        [APIManager reloadSourceSubView];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - Manage Source Device Data V2

-(void) reSyncSourceDataV2 {
    @try {
        NSMutableArray *arrInputData;
        NSMutableArray *arrAudioInputData;
        if ([self.arrSourceDeviceManaged isNotEmpty]) {
            // if device available in array then add by fitering device
            arrInputData = [[NSMutableArray alloc] initWithArray:self.arrSourceDeviceManaged];
            arrAudioInputData = [[NSMutableArray alloc] initWithArray:self.arrAudioSourceDeviceManaged];
            for (int counter = 0; counter < arrInputData.count; counter++) {
                InputDevice *objIPTemp = (InputDevice*)[arrInputData objectAtIndex:counter];
                for (int counter = 0; counter < self.objSelectedHub.HubInputData.count; counter++) {
                    InputDevice *objIPList = self.objSelectedHub.HubInputData[counter];
                    if (objIPTemp.Index == objIPList.Index) {
                       // objIPList.isDeleted = false;
                        [self.objSelectedHub.HubInputData replaceObjectAtIndex:counter withObject:objIPList];
                    }
                }

                for (Hub *objSlave in self.arrSlaveAudioDevice) {
                    for (int counter = 0; counter < objSlave.HubInputData.count; counter++) {
                        InputDevice *objIPList = objSlave.HubInputData[counter];
                        if (objIPTemp.Index == objIPList.Index) {
                          //  objIPList.isDeleted = false;
                            [objSlave.HubInputData replaceObjectAtIndex:counter withObject:objIPList];
                        }
                    }
                }
            }

            for (int counter = 0; counter < arrInputData.count; counter++) {
                InputDevice *objIPTemp = (InputDevice*)[arrInputData objectAtIndex:counter];
                for (InputDevice *objIP in self.objSelectedHub.HubInputData) {
                    objIPTemp.isDeleted = objIP.isDeleted;
                    if ([objIP isNotEmpty] && objIPTemp.isDeleted == true && objIPTemp.Index == objIP.Index) {
                        [arrInputData replaceObjectAtIndex:counter withObject:objIP];
                        //break;
                    }
                }
                if ([self.objSelectedHub isPairedSetup]) {
                    if (self.objSelectedHub.Generation == mHubAudio) {
                        for (Hub *objSlave in self.arrSlaveAudioDevice) {
                            for (InputDevice *objIP in objSlave.HubInputData) {
                                if ([objIP isNotEmpty] && objIPTemp.isDeleted == true && objIPTemp.Index == objIP.Index) {
                                    [arrInputData replaceObjectAtIndex:counter withObject:objIP];
                                    //break;
                                }
                            }
                        }
                    }
                }
            }
            

            if ([self.objSelectedHub isPairedSetup]) {
                if (self.objSelectedHub.Generation != mHubAudio && arrAudioInputData.count > 0) {
                    for (Hub *objSlave in self.arrSlaveAudioDevice) {
                        for (int counter = 0; counter < objSlave.HubInputData.count; counter++) {
                             InputDevice *objIP = objSlave.HubInputData[counter];
                            for (int j = 0; j < arrAudioInputData.count; j++) {
                                InputDevice *objIPTemp = (InputDevice*)[arrAudioInputData objectAtIndex:j];
                                if ([objIP isNotEmpty] && objIPTemp.Index == objIP.Index) {
                                    [arrAudioInputData replaceObjectAtIndex:j withObject:objIP];
                                }
                            }
                        }
                    }
                } else {
                    for (Hub *objSlave in self.arrSlaveAudioDevice) {
                        for (int counter = 0; counter < objSlave.HubInputData.count; counter++) {
                            InputDevice *objIPList = objSlave.HubInputData[counter];
//                            objIPList.isDeleted = false;
                            [objSlave.HubInputData replaceObjectAtIndex:counter withObject:objIPList];
                        }
                        [arrAudioInputData addObjectsFromArray:objSlave.HubInputData];
                    }
                }
            }
            
             if (self.objSelectedHub.Generation == mHubPro2 ) {
                  for (int counter = 0; counter < self.objSelectedHub.HubInputDataAudioInStandalone.count; counter++) {
                      InputDevice *objIP =self.objSelectedHub.HubInputDataAudioInStandalone[counter];
                      for (int j = 0; j < arrAudioInputData.count; j++) {
                          InputDevice *objIPTemp = (InputDevice*)[arrAudioInputData objectAtIndex:j];
                          if ([objIP isNotEmpty] && objIPTemp.Index == objIP.Index) {
                              [arrAudioInputData replaceObjectAtIndex:j withObject:objIP];
                          }
                      }
                  }
             }
            
            
            
        } else {
            // Else add all device to array
            arrInputData = [[NSMutableArray alloc] init];
            arrAudioInputData = [[NSMutableArray alloc] init];

            for (int counter = 0; counter < self.objSelectedHub.HubInputData.count; counter++) {
                InputDevice *objIPList = self.objSelectedHub.HubInputData[counter];
               // objIPList.isDeleted = false;
                [self.objSelectedHub.HubInputData replaceObjectAtIndex:counter withObject:objIPList];
            }
            [arrInputData addObjectsFromArray:self.objSelectedHub.HubInputData];

            for (int counter = 0; counter < self.objSelectedHub.HubInputDataAudioInStandalone.count; counter++) {
                InputDevice *objIPList = self.objSelectedHub.HubInputDataAudioInStandalone[counter];
                //objIPList.isDeleted = false;
                [self.objSelectedHub.HubInputDataAudioInStandalone replaceObjectAtIndex:counter withObject:objIPList];
            }
            [arrAudioInputData addObjectsFromArray:self.objSelectedHub.HubInputDataAudioInStandalone];

            if ([self.objSelectedHub isPairedSetup]) {
                if (self.objSelectedHub.Generation == mHubAudio) {
                    for (Hub *objSlave in self.arrSlaveAudioDevice) {
                        for (int counter = 0; counter < objSlave.HubInputData.count; counter++) {
                            InputDevice *objIPList = objSlave.HubInputData[counter];
                         //   objIPList.isDeleted = false;
                            [objSlave.HubInputData replaceObjectAtIndex:counter withObject:objIPList];
                        }
                        [arrInputData addObjectsFromArray:objSlave.HubInputData];
                    }
                }
                //Below Else if newly added after ZP stack introduced. Bcz from ZP stack video inputs are added in slave devices.
                else if (self.objSelectedHub.Generation == mHubZP) {
                    for (Hub *objSlave in self.arrSlaveAudioDevice) {
                        for (int counter = 0; counter < objSlave.HubInputData.count; counter++) {
                            InputDevice *objIPList = objSlave.HubInputData[counter];
                         //   objIPList.isDeleted = false;
                            [objSlave.HubInputData replaceObjectAtIndex:counter withObject:objIPList];
                        }
                        [arrInputData addObjectsFromArray:objSlave.HubInputData];
                    }
                }
                //Above Else if newly added after ZP stack introduced. Bcz from ZP stack video inputs are added in slave devices.
                else {
                    if (self.objSelectedHub.Generation != mHubZP){
                    for (Hub *objSlave in self.arrSlaveAudioDevice) {
                        for (int counter = 0; counter < objSlave.HubInputData.count; counter++) {
                            InputDevice *objIPList = objSlave.HubInputData[counter];
                            //objIPList.isDeleted = false;
                            [objSlave.HubInputData replaceObjectAtIndex:counter withObject:objIPList];
                        }
                        [arrAudioInputData addObjectsFromArray:objSlave.HubInputData];
                    }
                    }
                }
            }
        }
        self.arrSourceDeviceManaged = [[NSMutableArray alloc] initWithArray:arrInputData];
        self.arrAudioSourceDeviceManaged = [[NSMutableArray alloc] initWithArray:arrAudioInputData];
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
        [APIManager reloadSourceSubView];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) updateSourceDataV2 {
    @try {
        NSMutableArray *arrInputData = [[NSMutableArray alloc] initWithArray:self.arrSourceDeviceManaged];
        NSMutableArray *arrInputs = [[NSMutableArray alloc] initWithArray:self.objSelectedHub.HubInputData];

        for (int counter = 0; counter < arrInputData.count; counter++) {
            InputDevice *objIPTemp = (InputDevice*)[arrInputData objectAtIndex:counter];
            InputDevice *objIP = [InputDevice getFilteredInputDeviceData:objIPTemp.Index InputData:arrInputs];
            if ([objIP isNotEmpty] && objIPTemp.isDeleted == false && objIPTemp.Index == objIP.Index) {
                [arrInputData replaceObjectAtIndex:counter withObject:objIP];
            } else {
                [arrInputData removeObject:objIPTemp];
            }
        }

        for (InputDevice *objIP in arrInputs) {
            InputDevice *objIPFilter;
            for (NSObject *objTableData in arrInputData) {
                if ([objTableData isKindOfClass:[InputDevice class]]) {
                    InputDevice *objSeqTemp = (InputDevice*)objTableData;
                    if (objIP.Index == objSeqTemp.Index) {
                        objIPFilter = objSeqTemp;
                    }
                }
            }
            if (![objIPFilter isNotEmpty] && objIP.isDeleted == false) {
                [arrInputData addObject:objIP];
            }
        }

        self.arrSourceDeviceManaged = [[NSMutableArray alloc] initWithArray:arrInputData];
        [self saveCustomObject:self key:kMHUBMANAGERINSTANCE];
        [APIManager reloadSourceSubView];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Manage Sequence to Shortcuts/Quick Action
-(BOOL) searchQuickActionInShortcutItems:(Sequence*)objSeq {
    @try {
        BOOL isReturn = false;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            NSArray <UIApplicationShortcutItem *> *existingShortcutItems = [[UIApplication sharedApplication] shortcutItems];
            NSMutableArray <UIApplicationShortcutItem *> *updatedShortcutItems = [existingShortcutItems mutableCopy];
            for (int counter = 0; counter < [updatedShortcutItems count]; counter++) {
                Sequence *userInfo = [Sequence getObjectFromDictionary:[updatedShortcutItems objectAtIndex:counter].userInfo];
                if ([userInfo.macro_id isNotEmpty]) {
                    if ([objSeq.macro_id isEqualToString: userInfo.macro_id]) {
                        isReturn = true;
                        break;
                    }
                }
            }
        }
        return isReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) addSequenceToQuickActions:(Sequence*)objSeq {
    @try {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            NSArray <UIApplicationShortcutItem *> *existingShortcutItems = [[UIApplication sharedApplication] shortcutItems];
            if ([existingShortcutItems count]) {
                NSMutableArray <UIApplicationShortcutItem *> *updatedShortcutItems = [existingShortcutItems mutableCopy];
                [updatedShortcutItems addObject:[self createItemNumber:objSeq]];
                [[UIApplication sharedApplication] setShortcutItems: updatedShortcutItems];
            } else {
                [UIApplication sharedApplication].shortcutItems = @[[self createItemNumber:objSeq]];
            }
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(UIApplicationShortcutItem*) createItemNumber:(Sequence*)objSeq {
    @try {
        UIApplicationShortcutItem *newItem = [[UIApplicationShortcutItem alloc] initWithType:
                                              [[NSString stringWithFormat: NSLocalizedString(objSeq.uControl_name, nil)] uppercaseString]
                                                                              localizedTitle:[[NSString stringWithFormat: NSLocalizedString(objSeq.uControl_name, nil)] uppercaseString]
                                                                           localizedSubtitle:nil
                                                                                        icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"HDA_icon_sequence"]
                                                                                    userInfo:[objSeq dictionaryRepresentation]];
        return newItem;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) updateActiontoShortCutItems:(NSMutableArray*)arrSequence {
    @try {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            NSArray <UIApplicationShortcutItem *> *existingShortcutItems = [[UIApplication sharedApplication] shortcutItems];
            NSMutableArray <UIApplicationShortcutItem *> *updatedShortcutItems = [existingShortcutItems mutableCopy];
            
            NSMutableArray *arrItemsToRemove = [[NSMutableArray alloc] init];
            for (int counter = 0; counter < [updatedShortcutItems count]; counter++) {
                Sequence *userInfo = [Sequence getObjectFromDictionary:[updatedShortcutItems objectAtIndex:counter].userInfo];
                if ([userInfo.macro_id isNotEmpty]) {
                    Sequence *objSeqSearch = [Sequence getFilteredSequenceData:userInfo.macro_id Sequence:arrSequence];
                    if (![objSeqSearch isNotEmpty]) {
                        [arrItemsToRemove addObject:[updatedShortcutItems objectAtIndex:counter]];
                    }
                } else {
                    NSString *strShortCutTitle = [[updatedShortcutItems objectAtIndex:counter].localizedTitle uppercaseString];
                    if ([strShortCutTitle isNotEmpty]) {
                        Sequence *objSeqSearch = [Sequence getFilteredSequenceDataByName:strShortCutTitle Sequence:arrSequence];
                        if (![objSeqSearch isNotEmpty]) {
                            [arrItemsToRemove addObject:[updatedShortcutItems objectAtIndex:counter]];
                        }
                    }
                }
            }
            
            if ([arrItemsToRemove isNotEmpty]) {
                [updatedShortcutItems removeObjectsInArray:arrItemsToRemove];
                [[UIApplication sharedApplication] setShortcutItems: updatedShortcutItems];
            }
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) removeActionToShortCutItems:(Sequence*)objSeq {
    @try {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            NSArray <UIApplicationShortcutItem *> *existingShortcutItems = [[UIApplication sharedApplication] shortcutItems];
            NSMutableArray <UIApplicationShortcutItem *> *updatedShortcutItems = [existingShortcutItems mutableCopy];
            
            NSInteger indexToRemove = -1;
            for (int counter = 0; counter < [updatedShortcutItems count]; counter++) {
                Sequence *userInfo = [Sequence getObjectFromDictionary:[updatedShortcutItems objectAtIndex:counter].userInfo];
                if ([userInfo.macro_id isNotEmpty]) {
                    if ([objSeq.macro_id isEqualToString: userInfo.macro_id]) {
                        indexToRemove = counter;
                        break;
                    }
                } else {
                    NSString *strShortCutTitle = [[updatedShortcutItems objectAtIndex:counter].localizedTitle uppercaseString];
                    if ([strShortCutTitle isNotEmpty]) {
                        if ([objSeq.uControl_name isEqualToString:strShortCutTitle]) {
                            indexToRemove = counter;
                            break;
                        }
                    }
                }
            }
            if (indexToRemove > -1) {
                [updatedShortcutItems removeObjectAtIndex:indexToRemove];
                [[UIApplication sharedApplication] setShortcutItems: updatedShortcutItems];
            }
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) removeAllActionfromShortCutItems {
    @try {
        NSMutableArray <UIApplicationShortcutItem *> *updatedShortcutItems = [[NSMutableArray alloc] init];
        [[UIApplication sharedApplication] setShortcutItems: updatedShortcutItems];
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Manage Group Data
-(NSMutableArray*) getZoneDataFromGroup:(NSArray*)arrZoneData ZoneIds:(NSMutableArray*)arrZoneIds {
    @try {
        // Get Filtered All Zone Data according to Group Data.
        NSMutableArray *arrManageGroup = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrZoneData count]; counter++) {
            Zone *objZone = [arrZoneData objectAtIndex:counter];
            // Zone *objZoneGrp = [Zone getFilteredZoneData:objZone.zone_id ZoneData:arrGroup];
            // ZONE UPDATE
            if (arrZoneIds.count > 0) {
                NSString *strZoneGroup = [Zone getFilteredZoneId:objZone.zone_id ZoneIds:arrZoneIds];
                if ([strZoneGroup isNotEmpty] && [objZone.zone_id isEqualToString:strZoneGroup]) {
                    objZone.isGrouped = true;
                    objZone.imgGroupedZone = kImageCheckMark;
                } else {
                    if (objZone.isGrouped) {
                        continue;
                    }
                    objZone.isGrouped = false;
                    objZone.imgGroupedZone = nil;
                }
            }
            
            [arrManageGroup addObject:objZone];
        }
        return arrManageGroup;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(NSMutableArray*) getGroupZoneData:(NSMutableArray*)arrZoneData ZoneIds:(NSMutableArray*)arrZoneIds {
    @try {
        // Get Array og Group Zone Data from ZoneIds array
        NSMutableArray *arrManageGroupZone = [[NSMutableArray alloc] init];
        for (NSString *strZoneId in arrZoneIds) {
            Zone *objZoneGrp = [Zone getFilteredZoneData:strZoneId ZoneData:arrZoneData];
            if ([objZoneGrp isNotEmpty]) {
                [arrManageGroupZone addObject:objZoneGrp];
            }
        }
        return arrManageGroupZone;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(NSMutableArray*) getGroupZone:(NSArray*)arrGroupZone {
    @try {
        // Get Filtered Group Zone Data for Display
        NSMutableArray *arrManageGroup = [[NSMutableArray alloc] init];
        for (int counterGrp = 0; counterGrp < [arrGroupZone count]; counterGrp++) {
            Zone *objZone = [arrGroupZone objectAtIndex:counterGrp];
            if (objZone.isGrouped) {
                [arrManageGroup addObject:objZone.zone_id];
            }
        }
        return arrManageGroup;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(NSMutableArray*) updateGroupData:(NSMutableArray*)arrGroupList Group:(Group*)objGroup {
    @try {
        NSMutableArray *arrGroupDataList = [[NSMutableArray alloc] initWithArray:arrGroupList];

        Group *objGrp = [Group getFilteredGroupData:objGroup.GroupId Group:arrGroupDataList];
        if ([objGrp isNotEmpty]) {
            for (int counter = 0; counter < arrGroupDataList.count; counter++) {
                Group *objGroupTemp = (Group*)[arrGroupDataList objectAtIndex:counter];
                if ([objGroupTemp.GroupId isEqualToString:objGrp.GroupId]) {
                    [arrGroupDataList replaceObjectAtIndex:counter withObject:objGroup];
                    break;
                }
            }
        } else {
            [arrGroupDataList addObject:objGroup];
        }
        return arrGroupDataList;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(NSMutableArray*) deleteGroupData:(NSMutableArray*)arrGroupList Group:(Group*)objGroup {
    @try {
        if ([objGroup isNotEmpty]) {
            for (int counter = 0; counter < arrGroupList.count; counter++) {
                Group *objGroupTemp = (Group*)[arrGroupList objectAtIndex:counter];
                if ([objGroupTemp.GroupId isEqualToString: objGroup.GroupId]) {
                    [arrGroupList removeObjectAtIndex:counter];
                    break;
                }
            }
        }
        return arrGroupList;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Manage Zone Data
-(OutputDevice*) getOutputFromZone:(Zone*)objZone {
    @try {
        OutputDevice *objOPZone;
        for (OutputDevice *objOP in objZone.arrOutputs) {
            if ([self.objSelectedHub isVideoUnit:objOP.UnitId]) {
                objOPZone = objOP;
            }
        }

        /*if (![objOPZone isNotEmpty]) {
            objOPZone = [objZone.arrOutputs firstObject];
        }*/
        return objOPZone;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) getGroupFromZone:(Zone*)objZone GroupData:(NSMutableArray*)arrGroupData AllZoneData:(NSMutableArray*)arrZoneData completion:(void (^)(Group * objGroup, NSMutableArray <Zone*>*arrGroupZoneData))handler {
    @try {
        Group *objGroupReturn;
        NSMutableArray <Zone*>*arrZoneReturn = [[NSMutableArray alloc] init];
        // Find Group from Group list which contains current selected Zone
        if (arrGroupData.count > 0) {
            for (Group *objGrp in arrGroupData) {
                BOOL isTheObjectThere = [objGrp.arrGroupedZones containsObject:objZone.zone_id];
                if (isTheObjectThere) {
                    objGroupReturn = [[Group alloc] initWithGroup:objGrp];
                }
                /*for (NSString *strZoneId in objGrp.arrGroupedZones) {
                    if ([objZone.zone_id isEqualToString:strZoneId]) {
                        objReturn = [[Group alloc] initWithGroup:objGrp];
                        break;
                    }
                    }*/
                if ([objGroupReturn isNotEmpty]) {
                    // assigning Zone value to array from string value.
                    arrZoneReturn = [[NSMutableArray alloc] initWithArray:[self getGroupZoneData:arrZoneData ZoneIds:objGroupReturn.arrGroupedZones]];
                    break;
                }
            }
        } else {
            objGroupReturn = nil;
        }
        handler(objGroupReturn, arrZoneReturn);
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(NSMutableArray <Zone*>*) updateZoneFromGroupZoneData:(NSMutableArray<Zone*>*)arrGroupZoneData AllZoneData:(NSMutableArray<Zone*>*)arrZoneData {
    @try {
        // Find Group from Group list which contains current selected Zone
        if (arrGroupZoneData.count > 0) {
            for (int counter = 0; counter < arrZoneData.count; counter++) {
                Zone *objZone = [arrZoneData objectAtIndex:counter];
                Zone *objGrpZone = [Zone getFilteredZoneData:objZone.zone_id ZoneData:arrGroupZoneData];
                if ([objGrpZone isNotEmpty] && [objZone.zone_id isEqualToString:objGrpZone.zone_id]) {
                    [arrZoneData replaceObjectAtIndex:counter withObject:objGrpZone];
                }
            }
        }
        return arrZoneData;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
