//
//  Hub.m
//  mHubApp
//
//  Created by Anshul Jain on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/*
 Heart class of the whole project. Means that this is the Primary object of the whole Models and Syatem which comprises of all basic details of the MHUB device like Unit Id, Name, Model Generation Object consist of pairing properties like UnitId, IP Address, SerialNo, array of input devices, output devices, zones, AVR, Group etc.
 */

#import "Hub.h"

@implementation Hub

+(NSString*)getHubName:(HubModel)model {
    switch (model)
    {
        case mHubFake:
        return @"MHUBFake";    break;
        case mHubPro:
        return @"MHUB PRO";  break;
        case mHub4KV3:
        return @"MHUB (2016-17)";  break;
        case mHub4KV4:
        return @"MHUB U";  break;
        case mHubMAX:
        return @"MHUB MAX";     break;
        case mHubAudio:
        return @"MHUB AUDIO";     break;
        case mHubPro2:
        return @"MHUB Pro2";     break;
        case mHub411:
        return @"MHUB U 411";     break;
        case mHubZP:
        return @"uControl Zone Processor";     break;
        case mHubS:
        return @"MHUB S (2021)";     break;
        default:
        return @"";  break;
            // return @"Please update MHUB Model";  break;
    }
}

+(NSArray*) getHubList {
    NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
    for(int i = mHubPro; i < HubCount; ++i) {
        [arrReturn addObject:[self getHubName:i]];
    }
    return arrReturn;
}

+(NSArray*) getVideoHubList {
    NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
    for(int i = mHubPro; i < HubCount-1; ++i) {
        [arrReturn addObject:[self getHubName:i]];
    }
    return arrReturn;
}

+(NSArray*) getVideoMasterHubList {
    NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
    for(int i = mHubPro; i < HubCount-1; ++i) {
        if (i == mHub4KV3) {
            continue;
        }
        [arrReturn addObject:[self getHubName:i]];
    }
    return arrReturn;
}

+(NSArray*) getAudioHubList {
    NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
    for(int i = mHubAudio; i < HubCount; ++i) {
        [arrReturn addObject:[self getHubName:i]];
    }
    return arrReturn;
}

+(NSString*)getmHub4KV3Name:(mHub4KV3Type)model {
    switch (model) {
        case MHUB4K431: return @"MHUB4K431";    break;
        case MHUB4K862: return @"MHUB4K862";    break;
       // default:        return @"Please update MHUB Model"; break;
            default:        return @""; break;
    }
}

+(NSArray*) getmHub4KV3List {
    NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
    for(int i = MHUB4K431; i < mHub4KV3Count; ++i) {
        [arrReturn addObject:[self getmHub4KV3Name:i]];
    }
    return arrReturn;
}

+(Hub*) getGenerationFromModelName:(Hub*)objReturn {
    @try {
        if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUB4K44PRO] || [objReturn.modelName isContainString:kDEVICEMODEL_MHUBPRO4440]) {
            objReturn.OutputCount = 4;
            objReturn.InputCount = 4;
            objReturn.Generation = mHubPro;
        }
        else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUBPRO24440]) {
            objReturn.OutputCount = 4;
            objReturn.InputCount = 4;
            objReturn.Generation = mHubPro2;
        }
        else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUBPRO288100]) {
            objReturn.OutputCount = 8;
            objReturn.InputCount = 8;
            objReturn.Generation = mHubPro2;
        }
        else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUB4K88PRO] || [objReturn.modelName isContainString:kDEVICEMODEL_MHUBPRO8840]) {
            objReturn.OutputCount = 8;
            objReturn.InputCount = 8;
            objReturn.Generation = mHubPro;
        } else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUBMAX44]) {
            objReturn.OutputCount = 4;
            objReturn.InputCount = 4;
            objReturn.Generation = mHubMAX;
        } else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUB431U] || [objReturn.modelName isContainString:kDEVICEMODEL_MHUB431U40] ) {
            objReturn.OutputCount = 4;
            objReturn.InputCount = 4;
            objReturn.Generation = mHub4KV4;
        } else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUB862U] || [objReturn.modelName isContainString:kDEVICEMODEL_MHUB862U40]) {
            objReturn.OutputCount = 8;
            objReturn.InputCount = 8;
            objReturn.Generation = mHub4KV4;
        } else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUBAUDIO64]) {
            objReturn.OutputCount = 4;
            objReturn.InputCount = 6;
            objReturn.Generation = mHubAudio;
        }
        else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUBU41140]) {
            objReturn.OutputCount = 2;
            objReturn.InputCount = 4;
            objReturn.Generation = mHub411;
        }
        else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUBZP5]) {
            objReturn.OutputCount = 1;
            objReturn.InputCount = 5;
            objReturn.Generation = mHubZP;
        }
        else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUBZPMINI]) {
            objReturn.OutputCount = 1;
            objReturn.InputCount = 1;
            objReturn.Generation = mHubZP;
        }
        else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUB_S]) {
            objReturn.OutputCount = 8;
            objReturn.InputCount = 8;
            objReturn.Generation = mHubS;
        }
        else {
            objReturn.OutputCount = 0;
            objReturn.InputCount = 0;
        }

        return objReturn;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSString*) getModelName:(Hub*)hubObject {
    @try {
        NSString *strNameReturn = @"";
        if ([hubObject.modelName isNotEmpty]) {
            strNameReturn = hubObject.modelName;
        } else {
            strNameReturn = [Hub getHubName:hubObject.Generation];
        }
        return strNameReturn;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSString*) getMhubDisplayName:(Hub*)hubObject {
    @try {
        NSString *strNameReturn = @"";
        if ([hubObject.Name isNotEmpty]) {
            strNameReturn = hubObject.Name;
        } else if ([hubObject.Official_Name isNotEmpty]) {
            strNameReturn = hubObject.Official_Name;
        } else if ([hubObject.modelName isNotEmpty]) {
            strNameReturn = hubObject.modelName;
        }
        [APIManager writeNormalStringWithTimeStamp:[NSString stringWithFormat:@"METHOD:*getMhubDisplayName*\nhubObject.Name=%@\nhubObject.Official_Name=%@\nhubObject.modelName=%@",hubObject.Name,hubObject.Official_Name,hubObject.modelName]];
        return strNameReturn;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - HUB Intializer

-(id)init {
    self = [super init];
    @try {
        self.UnitId         = @"";
        self.Name           = @"";
        self.Official_Name  = @"";
        self.Mac            = UNKNOWN_MAC;
        self.Address        = UNKNOWN_IP;
        self.Generation     = -1;
        self.BootFlag       = false;
        self.webSocketFlag  = false;
        self.SerialNo       = UNKNOWN_SERIALNO;
        self.UserInfo       = nil;
        self.apiVersion     = 1.0;
        self.mosVersion     = 0.0;
        self.MHub_BenchMarkVersion     = 0.0;
        self.strMOSVersion  = @"";
       
        self.modelName      = @"";
        
        self.AVR_IRPack     = false;
        self.isPaired       = false;
        self.isAutoSwitchMode       = false;
        
        self.OutputCount    = 0;
        self.InputCount     = 0;
        
        self.HubInputData   = [[NSMutableArray alloc] init];
        self.HubInputDataAudioInStandalone =  [[NSMutableArray alloc] init];
        self.HubOutputData  = [[NSMutableArray alloc] init];
        self.HubZoneData    = [[NSMutableArray alloc] init];
        self.HubGroupData   = [[NSMutableArray alloc] init];
        self.HubSequenceList= [[NSMutableArray alloc] init];
        self.HubAVRList     = [[NSMutableArray alloc] init];
        self.HubControlsList     = [[NSMutableArray alloc] init];
        self.PairingDetails = [[Pair alloc] init];
        self.hubName_InStack = @"";
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

-(id)initWithHub:(Hub *)hubData {
    self = [super init];
    @try {
        self.UnitId         = hubData.UnitId;
        self.Name           = hubData.Name;
        self.Official_Name  = hubData.Official_Name;
        self.Mac            = hubData.Mac;
        self.Address        = [hubData.Address isNotEmpty] ? hubData.Address : UNKNOWN_IP;
        self.Generation     = hubData.Generation;
        self.modelName      = [Hub getModelName:hubData];
        self.BootFlag       = hubData.BootFlag;
        self.webSocketFlag  = hubData.webSocketFlag;
        self.SerialNo       = hubData.SerialNo;
        self.UserInfo       = hubData.UserInfo;

        self.apiVersion     = hubData.apiVersion;
        self.mosVersion     = hubData.mosVersion;
        self.strMOSVersion  = hubData.strMOSVersion;
        self.AVR_IRPack     = hubData.AVR_IRPack;
        self.isPaired       = hubData.isPaired;
         self.isAutoSwitchMode       = hubData.isAutoSwitchMode;
        
        self.MHub_BenchMarkVersion  = hubData.MHub_BenchMarkVersion;
        self.APP_BenchMarkVersion  = hubData.APP_BenchMarkVersion;
        self.MHub_LatestVersion  = hubData.MHub_LatestVersion;
        self.OutputCount    = hubData.OutputCount;
        self.InputCount     = hubData.InputCount;

        self.HubInputData    = hubData.HubInputData;
        self.HubOutputData   = hubData.HubOutputData;
        self.HubZoneData     = hubData.HubZoneData;
        self.HubGroupData    = hubData.HubGroupData;
        self.HubSequenceList = hubData.HubSequenceList;
        self.HubControlsList = hubData.HubControlsList;
        self.HubAVRList      = hubData.HubAVRList;
       
        self.PairingDetails = hubData.PairingDetails;
        self.HubInputDataAudioInStandalone =  hubData.HubInputDataAudioInStandalone;
        self.hubName_InStack = hubData.hubName_InStack;


    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

-(id)initWithDemoAudioDevice {
    self = [super init];
    @try {
        self.UnitId         = @"";
        self.Name           = @"";
        self.Official_Name  = @"";
        self.Mac            = UNKNOWN_MAC;
        self.Address        = UNKNOWN_IP;
        self.BootFlag       = false;
        self.webSocketFlag  = false;
        self.SerialNo       = UNKNOWN_SERIALNO;
        self.UserInfo       = nil;
        self.apiVersion     = 2.0;
        self.APP_BenchMarkVersion     = 0.0;
        self.apiVersion     = 2.0;
        self.modelName      = kDEVICEMODEL_MHUBAUDIO64;

        self.OutputCount    = 0;
        self.InputCount     = 0;

        self.HubInputData   = [[NSMutableArray alloc] init];
        self.HubInputDataAudioInStandalone =  [[NSMutableArray alloc] init];

        self.HubOutputData  = [[NSMutableArray alloc] init];
        self.HubZoneData    = [[NSMutableArray alloc] init];
        self.HubGroupData   = [[NSMutableArray alloc] init];
        self.HubSequenceList= [[NSMutableArray alloc] init];
        self.HubAVRList     = [[NSMutableArray alloc] init];
        self.HubControlsList= [[NSMutableArray alloc] init];
        self.isPaired       = false;
          self.isAutoSwitchMode       = false;
        
        self.PairingDetails = [[Pair alloc] init];
        self.hubName_InStack = @"";

    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

-(id)initWithDemoMhubSDevice {
    self = [super init];
    @try {
        self.UnitId         = @"";
        self.Name           = @"";
        self.Official_Name  = @"";
        self.Mac            = UNKNOWN_MAC;
        self.Address        = UNKNOWN_IP;
        self.BootFlag       = false;
        self.webSocketFlag  = false;
        self.SerialNo       = UNKNOWN_SERIALNO;
        self.UserInfo       = nil;
        self.apiVersion     = 2.0;
        self.APP_BenchMarkVersion     = 0.0;
        self.apiVersion     = 2.0;
        self.modelName      = kDEVICEMODEL_MHUBS;

        self.OutputCount    = 0;
        self.InputCount     = 0;

        self.HubInputData   = [[NSMutableArray alloc] init];
        self.HubInputDataAudioInStandalone =  [[NSMutableArray alloc] init];

        self.HubOutputData  = [[NSMutableArray alloc] init];
        self.HubZoneData    = [[NSMutableArray alloc] init];
        self.HubGroupData   = [[NSMutableArray alloc] init];
        self.HubSequenceList= [[NSMutableArray alloc] init];
        self.HubAVRList     = [[NSMutableArray alloc] init];
        self.HubControlsList= [[NSMutableArray alloc] init];
        self.isPaired       = false;
          self.isAutoSwitchMode       = false;
        
        self.PairingDetails = [[Pair alloc] init];
        self.hubName_InStack = @"";

    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

#pragma mark -
+(Hub*) getHubObject_From:(Hub *)objFrom To:(Hub*)objTo {
    Hub *objReturn = [[Hub alloc] initWithHub:objTo];
    @try {
        if ([objFrom.UnitId isNotEmpty]) {
            if ([objFrom.UnitId isNotEmpty]) {
                objReturn.UnitId = objFrom.UnitId;
            }

            if ([objFrom.Name isNotEmpty]) {
                objReturn.Name = objFrom.Name;
            }

            if ([objFrom.Official_Name isNotEmpty]) {
                objReturn.Official_Name = objFrom.Official_Name;
            }
            if ([objFrom.hubName_InStack isNotEmpty]) {
                objReturn.hubName_InStack = objFrom.hubName_InStack;
            }
           
            if ([objFrom.Mac isNotEmpty]) {
                objReturn.Mac = objFrom.Mac;
            }
            
            if (![objFrom.Address isIPAddressEmpty]) {
                objReturn.Address = objFrom.Address;
            }
            
            if (objFrom.Generation != 0) {
                objReturn.Generation = objFrom.Generation;
            }
            
            if ([objFrom.modelName isNotEmpty]) {
                objReturn.modelName = objFrom.modelName;
            }
            
            if (objFrom.BootFlag == true) {
                objReturn.BootFlag = objFrom.BootFlag;
            }
            if (objFrom.webSocketFlag == true) {
                objReturn.webSocketFlag = objFrom.webSocketFlag;
            }

            if ([objFrom.SerialNo isNotEmpty]) {
                objReturn.SerialNo = objFrom.SerialNo;
            }
            
            if ([objFrom.UserInfo isNotEmpty]) {
                objReturn.UserInfo = objFrom.UserInfo;
            }
            
            if (objFrom.apiVersion != 0) {
                objReturn.apiVersion = objFrom.apiVersion;
            }

            if (objFrom.mosVersion != 0) {
                objReturn.mosVersion = objFrom.mosVersion;
            }
            
            if (objFrom.MHub_BenchMarkVersion != 0) {
                objReturn.MHub_BenchMarkVersion = objFrom.MHub_BenchMarkVersion;
            }

            if ([objFrom.strMOSVersion isNotEmpty]) {
                objReturn.strMOSVersion = objFrom.strMOSVersion;
            }
            
            if (objFrom.OutputCount != 0) {
                objReturn.OutputCount = objFrom.OutputCount;
            }

            if (objFrom.InputCount != 0) {
                objReturn.InputCount = objFrom.InputCount;
            }
            
            if (objFrom.AVR_IRPack == true) {
                objReturn.AVR_IRPack = objFrom.AVR_IRPack;
            }
            
            if (objFrom.isPaired == true) {
                objReturn.isPaired = objFrom.isPaired;
            }
            
            if (objFrom.isAutoSwitchMode == true) {
                objReturn.isAutoSwitchMode = objFrom.isAutoSwitchMode;
            }
            

            if ([objFrom.HubInputData isNotEmpty]) {
                objReturn.HubInputData = objFrom.HubInputData;
            }
            
            if ([objFrom.HubOutputData isNotEmpty]) {
                objReturn.HubOutputData = objFrom.HubOutputData;
            }
            if ([objFrom.HubZoneData isNotEmpty]) {
                objReturn.HubZoneData = objFrom.HubZoneData;
            }
            if ([objFrom.HubGroupData isNotEmpty]) {
                objReturn.HubGroupData = objFrom.HubGroupData;
            }
            if ([objFrom.HubSequenceList isNotEmpty]) {
                objReturn.HubSequenceList = objFrom.HubSequenceList;
            }
            if ([objFrom.HubControlsList isNotEmpty]) {
                objReturn.HubControlsList = objFrom.HubControlsList;
            }
            if ([objFrom.HubAVRList isNotEmpty]) {
                objReturn.HubAVRList = objFrom.HubAVRList;
            }
            if (![objFrom.PairingDetails isPairEmpty]) {
                objReturn.PairingDetails = objFrom.PairingDetails;
            }
            if (![objFrom.HubInputDataAudioInStandalone isNotEmpty]) {
                objReturn.HubInputDataAudioInStandalone = objFrom.HubInputDataAudioInStandalone;
            }


        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}


+(Hub*) updateHubAddress_From:(Hub*)objFrom To:(Hub*)objTo {
    Hub *objReturn = [[Hub alloc] initWithHub:objTo];
    @try {
        if ([objFrom isNotEmpty]) {
            if (![objFrom.Address isIPAddressEmpty] && [objFrom.SerialNo isEqualToString:objReturn.SerialNo]) {
                objReturn.Address = objFrom.Address;
            } else {
                objReturn = [Hub getHubObject_From:objFrom To:objTo];
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - GET OBJECT METHODS

+(Hub*) getObjectFromDictionary:(NSDictionary*)dictResp DataSync:(BOOL)isSync {
    Hub *objReturn = [[Hub alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.Name = [Utility checkNullForKey:kNAME Dictionary:dictResp];
            objReturn.Mac = [Utility checkNullForKey:kMAC Dictionary:dictResp];
            if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
                objReturn.Generation = mHubPro;
                objReturn.modelName = [Hub getModelName:mHubManagerInstance.objSelectedHub];
                objReturn.Address = STATICTESTIP_PRO;
            } else {
                objReturn.Address = [Utility checkNullForKey:kADDRESS Dictionary:dictResp];
                objReturn.Generation = (HubModel)[[Utility checkNullForKey:kGENERATION Dictionary:dictResp] integerValue];
                objReturn.modelName = [Hub getModelName:objReturn];
            }
            objReturn.BootFlag = [[Utility checkNullForKey:kBOOTFLAG Dictionary:dictResp] boolValue];
            objReturn.webSocketFlag = [[Utility checkNullForKey:kWEBSOCKETFLAG Dictionary:dictResp] boolValue];
            objReturn.SerialNo = [Utility checkNullForKey:kSERIALNO Dictionary:dictResp];
            
            float apiVer = [[Utility checkNullForKey:kAPIVERSION Dictionary:dictResp] floatValue];
            objReturn.apiVersion = apiVer > 0.0 ? apiVer : 1.0;

            objReturn.OutputCount = [[Utility checkNullForKey:kOUTPUTCOUNT Dictionary:dictResp] integerValue];
            objReturn.InputCount = [[Utility checkNullForKey:kINPUTCOUNT Dictionary:dictResp] integerValue];
            
            objReturn.AVR_IRPack = [[Utility checkNullForKey:kAVR_IRPACK Dictionary:dictResp] boolValue];

            if (isSync) {
                objReturn.HubInputData = [[NSMutableArray alloc] initWithArray:[InputDevice getObjectArray:[Utility checkNullForKey:kHUBINPUTDATA Dictionary:dictResp] Hub:objReturn]];
                objReturn.HubInputDataAudioInStandalone = [[NSMutableArray alloc] initWithArray:[InputDevice getObjectArray:[Utility checkNullForKey:kHUBINPUTDATAAUDIOSTANDALONE Dictionary:dictResp] Hub:objReturn]];
                objReturn.HubOutputData = [[NSMutableArray alloc] initWithArray:[OutputDevice getObjectArray:[Utility checkNullForKey:kHUBOUTPUTDATA Dictionary:dictResp] Hub:objReturn]];

                if (objReturn.AVR_IRPack) {
                    objReturn.HubAVRList = [[NSMutableArray alloc] initWithArray:[AVRDevice getObjectArray_Hub:objReturn]];;
                } else {
                    objReturn.HubAVRList = [[NSMutableArray alloc] init];
                }
            }
            
            if (isSync && objReturn.Generation != mHub4KV3) {
                [APIManager getSequenceList:objReturn.strMOSVersion completion:^(APIResponse *responseObject) {
                    if (responseObject.error) {
                        objReturn.HubSequenceList = [[NSMutableArray alloc] init];
                        [mHubManagerInstance removeAllActionfromShortCutItems];
                    } else {
                        objReturn.HubSequenceList = [[NSMutableArray alloc] initWithArray:responseObject.response];
                        [mHubManagerInstance updateActiontoShortCutItems:objReturn.HubSequenceList];
                    }
                }];
            }
            
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(Hub*) getObjectFromDictionary:(NSDictionary*)dictResp {
    Hub *objReturn=[[Hub alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.UnitId = [Utility checkNullForKey:kUNIT_ID Dictionary:dictResp];
            objReturn.Name = [Utility checkNullForKey:kNAME Dictionary:dictResp];
            objReturn.Mac = [Utility checkNullForKey:kMAC Dictionary:dictResp];
            if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
                // objReturn.Generation = mHubPro;
                objReturn.modelName = kDEVICEMODEL_MHUBAUDIO64;
                objReturn.Address = STATICTESTIP_PRO;
            } else {
                objReturn.Address = [Utility checkNullForKey:kADDRESS Dictionary:dictResp];
                // objReturn.Generation = (HubModel)[[Utility checkNullForKey:kGENERATION Dictionary:dictResp] integerValue];
                objReturn.modelName = kDEVICEMODEL_MHUBAUDIO64;
            }
            objReturn.BootFlag = [[Utility checkNullForKey:kBOOTFLAG Dictionary:dictResp] boolValue];
            objReturn.webSocketFlag = [[Utility checkNullForKey:kWEBSOCKETFLAG Dictionary:dictResp] boolValue];
            
            objReturn.SerialNo = [Utility checkNullForKey:kSERIALNO Dictionary:dictResp];

            float apiVer = [[Utility checkNullForKey:kAPIVERSION Dictionary:dictResp] floatValue];
            objReturn.apiVersion = apiVer > 0.0 ? apiVer : 2.0;

            objReturn.OutputCount = [[Utility checkNullForKey:kOUTPUTCOUNT Dictionary:dictResp] integerValue];
            objReturn.InputCount = [[Utility checkNullForKey:kINPUTCOUNT Dictionary:dictResp] integerValue];

            objReturn.HubInputData = [[NSMutableArray alloc] initWithArray:[InputDevice getObjectArray:[Utility checkNullForKey:kHUBINPUTDATA Dictionary:dictResp] Hub:objReturn]];
            objReturn.HubInputDataAudioInStandalone = [[NSMutableArray alloc] initWithArray:[InputDevice getObjectArray:[Utility checkNullForKey:kHUBINPUTDATAAUDIOSTANDALONE Dictionary:dictResp] Hub:objReturn]];

            objReturn.HubOutputData = [[NSMutableArray alloc] initWithArray:[OutputDevice getObjectArray:[Utility checkNullForKey:kHUBOUTPUTDATA Dictionary:dictResp] Hub:objReturn]];

            [APIManager getSequenceList:objReturn.strMOSVersion completion:^(APIResponse *responseObject) {
                if (responseObject.error) {
                    objReturn.HubSequenceList = [[NSMutableArray alloc] init];
                    [mHubManagerInstance removeAllActionfromShortCutItems];
                } else {
                    objReturn.HubSequenceList = [[NSMutableArray alloc] initWithArray:responseObject.response];
                    [mHubManagerInstance updateActiontoShortCutItems:objReturn.HubSequenceList];
                }
            }];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark -
+(Hub*) getObjectFromSystemInfoStandaloneDictionary:(NSDictionary*)dictResp ToHub:(Hub*)objReturn {
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictStack = [Utility checkNullForKey:kSTACK Dictionary:dictResp];
//            if ([dictStack isKindOfClass:[NSDictionary class]]) {
//                objReturn.isPaired  = [[Utility checkNullForKey:kSTACK_STATUS Dictionary:dictStack] boolValue];
//            }
            [APIManager writeNormalStringWithTimeStamp:[NSString stringWithFormat:@"METHOD:*getObjectFromSystemInfoStandaloneDictionary*\n%@",dictResp]];
            NSDictionary *dictMhub;
            dictMhub = [Utility checkNullForKey:kMHUBJSON Dictionary:dictResp];
            if(![dictMhub isNotEmpty])
            {
                dictMhub = [Utility checkNullForKey:kOS Dictionary:dictResp];
            }
            if ([dictMhub isKindOfClass:[NSDictionary class]]) {
                objReturn.UnitId        = [Utility checkNullForKey:kUNIT_ID Dictionary:dictMhub];
                objReturn.Official_Name = [Utility checkNullForKey:kMHUB_OFFICIAL_NAME Dictionary:dictMhub];
                if([[Utility checkNullForKey:kMHUB_NAME Dictionary:dictMhub] isKindOfClass:[NSString class]]){
                objReturn.Name          = [Utility checkNullForKey:kMHUB_NAME Dictionary:dictMhub];
                }
                else
                {
                NSDictionary *masterNSlaveName_dictionary = [Utility checkNullForKey:kMHUB_NAME Dictionary:dictMhub];
                objReturn.Name          = [masterNSlaveName_dictionary objectForKey:@"M1"];
                }
                objReturn.SerialNo      = [Utility checkNullForKey:kSERIAL_NUMBER Dictionary:dictMhub];
                objReturn.BootFlag      = [[Utility checkNullForKey:kFIRST_BOOT Dictionary:dictMhub] boolValue];
                objReturn.webSocketFlag      = [[Utility checkNullForKey:kWS Dictionary:dictMhub] boolValue];

                float fltAPIVer         = [[Utility checkNullForKey:kAPI Dictionary:dictMhub] floatValue];
                objReturn.apiVersion    = (fltAPIVer == 0 ? 1.0 : fltAPIVer);

                NSString *strMOSVer     = [Utility checkNullForKey:kMHUBOS_VERSION Dictionary:dictMhub]; //@"7.01";
                objReturn.strMOSVersion = strMOSVer;
                objReturn.mosVersion    = [strMOSVer floatValue];
            }

            NSDictionary *dictIODATA = [Utility checkNullForKey:kIO_DATA Dictionary:dictResp];
            if ([dictIODATA isKindOfClass:[NSDictionary class]]) {
                if (objReturn.Generation == mHubAudio) {
                    id arrInputAudio = [Utility checkNullForKey:kINPUT_AUDIO Dictionary:dictIODATA];
                    if ([arrInputAudio isKindOfClass:[NSArray class]]) {
                        objReturn.InputCount    = 0;
                        objReturn.HubInputData  = [[NSMutableArray alloc] init];

                        for (NSDictionary *dictIPA in arrInputAudio) {
                           // //NSLog(@"label_editable value %@",[Utility checkNullForKey:@"label_editable" Dictionary:dictIPA]);
                            objReturn.InputCount += [[Utility checkNullForKey:kPORTS Dictionary:dictIPA] integerValue];
                            [objReturn.HubInputData addObjectsFromArray:[InputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictIPA] Hub:objReturn mainRootDictionary:dictIPA]];
                        }
                    }

                    id arrOutputAudio = [Utility checkNullForKey:kOUTPUT_AUDIO Dictionary:dictIODATA];
                    if ([arrOutputAudio isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dictOPA in arrOutputAudio) {
                            objReturn.OutputCount   = [[Utility checkNullForKey:kPORTS Dictionary:dictOPA] integerValue];
                            objReturn.HubOutputData = [OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPA] Hub:objReturn keyValue:kOUTPUT_AUDIO];
                        }
                    }
                } else {
                    id arrInputVideo = [Utility checkNullForKey:kINPUT_VIDEO Dictionary:dictIODATA];
                    if ([arrInputVideo isKindOfClass:[NSArray class]]) {
                        objReturn.InputCount = 0;
                        objReturn.HubInputData = [[NSMutableArray alloc] init];
                        for (NSDictionary *dictIPV in arrInputVideo) {
                            objReturn.InputCount    = [[Utility checkNullForKey:kPORTS Dictionary:dictIPV] integerValue];
                            objReturn.HubInputData  = [InputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictIPV] Hub:objReturn mainRootDictionary:dictIPV];
                        }
                    }

                    id arrOutputVideo = [Utility checkNullForKey:kOUTPUT_VIDEO Dictionary:dictIODATA];
                    if ([arrOutputVideo isKindOfClass:[NSArray class]]) {
                        objReturn.OutputCount = 0;
                        objReturn.HubOutputData = [[NSMutableArray alloc] init];
                        for (NSDictionary *dictOPV in arrOutputVideo) {
                           //objReturn.OutputCount   = [[Utility checkNullForKey:kPORTS Dictionary:dictOPV] integerValue];
                            objReturn.OutputCount   += [[Utility checkNullForKey:kPORTS Dictionary:dictOPV] integerValue];
                            if(objReturn.HubOutputData.count > 0)
                            {
                               
                                [objReturn.HubOutputData addObjectsFromArray:[OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPV] Hub:objReturn keyValue:kOUTPUT_VIDEO]];
                                //objReturn.HubOutputData = [OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPV] Hub:objReturn];
                            }
                            else
                            {
                                //objReturn.OutputCount   = [[Utility checkNullForKey:kPORTS Dictionary:dictOPV] integerValue];
                                objReturn.HubOutputData = [OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPV] Hub:objReturn keyValue:kOUTPUT_VIDEO];
                            }
                            
                        }
                    }
                    if (objReturn.Generation == mHubPro2 ) {
                        id arrInputAudio = [Utility checkNullForKey:kINPUT_AUDIO Dictionary:dictIODATA];
                        if ([arrInputAudio isKindOfClass:[NSArray class]]) {
                            objReturn.InputCount    = 0;
                            objReturn.HubInputDataAudioInStandalone  = [[NSMutableArray alloc] init];
                            for (NSDictionary *dictIPA in arrInputAudio) {
                                 ////NSLog(@"label_editable value %@",[Utility checkNullForKey:@"label_editable" Dictionary:dictIPA]);
                                objReturn.InputCount += [[Utility checkNullForKey:kPORTS Dictionary:dictIPA] integerValue];
                                [objReturn.HubInputDataAudioInStandalone addObjectsFromArray:[InputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictIPA] Hub:objReturn mainRootDictionary:dictIPA]];
                            }
                        }
                        

                        id arrOutputAudio = [Utility checkNullForKey:kOUTPUT_AUDIO Dictionary:dictIODATA];
                        if ([arrOutputAudio isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *dictOPA in arrOutputAudio) {
                                objReturn.OutputCount   += [[Utility checkNullForKey:kPORTS Dictionary:dictOPA] integerValue];
                                //objReturn.HubOutputData = [OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPA] Hub:objReturn];
                                [objReturn.HubOutputData addObjectsFromArray:[OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPA] Hub:objReturn keyValue:kOUTPUT_AUDIO]];
                            }
                        }
                    }

                    //Adding CEC option complusory for pro2 , 411 and ZP devices.
                    if(objReturn.Generation == mHubPro2 || objReturn.Generation == mHub411 || objReturn.Generation == mHubZP || objReturn.Generation == mHubS)
                        {
                        id dictCECData = [Utility checkNullForKey:@"cec" Dictionary:dictIODATA];
                        if ([dictCECData isKindOfClass:[NSDictionary class]]) {
                            //NSLog(@"Dict value %@",dictCECData);
                            objReturn.HubCECData = dictCECData;
                        }
                        OutputDevice *aObj = [[OutputDevice alloc]init ];
                        aObj.Index  = 100;
                        aObj.sourceType = OutputScreen;
                        aObj.isIRPack = true;
                        aObj.Name = @"CEC";
                        aObj.CreatedName = @"CEC";
                        aObj.PortNo = 4;
                        objReturn.OutputCount += 1;
                            
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Index == %ld", 100];
                            NSArray *arrCmdDataFiltered = [objReturn.HubOutputData filteredArrayUsingPredicate:predicate];
                            if([arrCmdDataFiltered isNotEmpty])
                            {
//                                OutputDevice *aObj = (OutputDevice *)[arrCmdDataFiltered objectAtIndex:0];
//                                if([objReturn.HubOutputData containsObject:aObj]){
//                                
//                                    }
                                
                            }else
                            {
                                [objReturn.HubOutputData addObject:aObj];
                            }
                        
                        }
                }
            }
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(void) getObjectFromSystemInfoStackedDictionary:(NSDictionary*)dictResp ToHub:(Hub*)objMaster Slave:(NSMutableArray*)arrSlaveDevice completion:(void (^)(Hub* objReturnMaster, NSMutableArray* arrReturnSlaveDevice)) handler {
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictIODATA = [Utility checkNullForKey:kSTACKED_IO Dictionary:dictResp];
            if ([dictIODATA isKindOfClass:[NSDictionary class]]) {

                if (objMaster.Generation != mHubAudio) {
                    id dictInputVideo = [Utility checkNullForKey:kSTACK_INPUT_VIDEO Dictionary:dictIODATA];
                    if ([dictInputVideo isKindOfClass:[NSDictionary class]]) {
                        objMaster.InputCount    = [[Utility checkNullForKey:kPORTS Dictionary:dictInputVideo] integerValue];
                        objMaster.HubInputData  = [InputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictInputVideo] Hub:objMaster mainRootDictionary:dictInputVideo];
                    }
                    id dictOutputVideo = [Utility checkNullForKey:kSTACK_OUTPUT_VIDEO Dictionary:dictIODATA];
                    if ([dictOutputVideo isKindOfClass:[NSDictionary class]]) {
                        objMaster.OutputCount   = [[Utility checkNullForKey:kPORTS Dictionary:dictOutputVideo] integerValue];
                        objMaster.HubOutputData = [OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOutputVideo] Hub:objMaster keyValue:kSTACK_OUTPUT_VIDEO];
                    }
                    
                    //New code after ZP stack introduced
                    // Getting all inputs. In ZP stack inputs will be appear in slave.
                    id arrInputVideo = [Utility checkNullForKey:kINPUT_VIDEO Dictionary:dictInputVideo];
                    if ([arrInputVideo isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dictIPA in arrInputVideo) {
                        NSString *strUnitId = [Utility checkNullForKey:kUNIT_ID Dictionary:dictIPA];
                        ////NSLog(@"strUnitId %@ and dictIPA %@",strUnitId, dictIPA);
                        if ([strUnitId isEqualToString:objMaster.UnitId]) {
                            objMaster.InputCount += [[Utility checkNullForKey:kPORTS Dictionary:dictIPA] integerValue];
                            [objMaster.HubInputData addObjectsFromArray:[InputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictIPA] Hub:objMaster mainRootDictionary:dictIPA]];
                        } else {
                            for (Hub* objSlave in arrSlaveDevice) {
                                if ([strUnitId isEqualToString:objSlave.UnitId]) {
                                    objMaster.InputCount += [[Utility checkNullForKey:kPORTS Dictionary:dictIPA] integerValue];
                                    [objMaster.HubInputData addObjectsFromArray:[InputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictIPA] Hub:objSlave mainRootDictionary:dictIPA]];
                                    break;
                                }
                            }
                        }
                    }
                    }
                    NSLog(@"master.HubInputData %@ ",objMaster.HubInputData);
                    
                    // Getting all outputs. In ZP stack inputs will be appear in slave.
                    id arrOutputVideo = [Utility checkNullForKey:kOUTPUT_VIDEO Dictionary:dictOutputVideo];
                    if ([arrOutputVideo isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dictOPA in arrOutputVideo) {
                        NSString *strUnitId = [Utility checkNullForKey:kUNIT_ID Dictionary:dictOPA];
                        ////NSLog(@"strUnitId %@ and dictIPA %@",strUnitId, dictIPA);
                        if ([strUnitId isEqualToString:objMaster.UnitId]) {
                            objMaster.OutputCount += [[Utility checkNullForKey:kPORTS Dictionary:dictOPA] integerValue];
                            objMaster.HubOutputData = [OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPA] Hub:objMaster keyValue:kSTACK_OUTPUT_AUDIO];
                           // [objMaster.HubOutputData addObjectsFromArray:[OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictIPA] Hub:objMaster mainRootDictionary:dictIPA]];
                        } else {
                            for (Hub* objSlave in arrSlaveDevice) {
                                if ([strUnitId isEqualToString:objSlave.UnitId]) {
                                    objMaster.OutputCount += [[Utility checkNullForKey:kPORTS Dictionary:dictOPA] integerValue];
                                    if(objMaster.HubOutputData.count > 0)
                                    {
                                        [objMaster.HubOutputData addObjectsFromArray:[OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPA] Hub:objSlave keyValue:kOUTPUT_VIDEO]];
                                    }
                                    else
                                    {
                                        objMaster.HubOutputData = [OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPA] Hub:objSlave keyValue:kOUTPUT_VIDEO];
                                    }
                                   
                                    //[objMaster.HubOutputData addObjectsFromArray:[OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPA] Hub:objSlave mainRootDictionary:dictIPA]];
                                    break;
                                }
                            }
                        }
                    }
                    }
                    NSLog(@"master.HubOutputData %@ ",objMaster.HubOutputData);
                    
                }
                
                id arrIRDATA = [Utility checkNullForKey:kCPIR Dictionary:dictIODATA];
                if ([arrIRDATA isKindOfClass:[NSDictionary class]]) {
                    id arrAVRDATA = [Utility checkNullForKey:kIRPACKSTATUSAVR Dictionary:arrIRDATA];
                    if ([arrAVRDATA isKindOfClass:[NSArray class]]) {
                        NSMutableArray *arrAVRList = [[NSMutableArray alloc] initWithArray:arrAVRDATA];
                        objMaster.HubAVRList = [[NSMutableArray alloc] init];
                            [objMaster.HubAVRList addObjectsFromArray:[AVRDevice getObjectArray:arrAVRList Hub:objMaster]];
                        
                    }
                }

                id dictInputAudio = [Utility checkNullForKey:kSTACK_INPUT_AUDIO Dictionary:dictIODATA];
                if ([dictInputAudio isKindOfClass:[NSDictionary class]]) {
                    id arrInputAudio = [Utility checkNullForKey:kINPUT_AUDIO Dictionary:dictInputAudio];
                    if ([arrInputAudio isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dictIPA in arrInputAudio) {
                            NSString *strUnitId = [Utility checkNullForKey:kUNIT_ID Dictionary:dictIPA];
                            ////NSLog(@"strUnitId %@ and dictIPA %@",strUnitId, dictIPA);
                            if ([strUnitId isEqualToString:objMaster.UnitId]) {
                                objMaster.InputCount += [[Utility checkNullForKey:kPORTS Dictionary:dictIPA] integerValue];
                                [objMaster.HubInputData addObjectsFromArray:[InputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictIPA] Hub:objMaster mainRootDictionary:dictIPA]];
                            } else {
                                for (Hub* objSlave in arrSlaveDevice) {
                                    if ([strUnitId isEqualToString:objSlave.UnitId]) {
                                        objSlave.InputCount += [[Utility checkNullForKey:kPORTS Dictionary:dictIPA] integerValue];
                                        [objSlave.HubInputData addObjectsFromArray:[InputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictIPA] Hub:objSlave mainRootDictionary:dictIPA]];
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }

                id dictOutputAudio = [Utility checkNullForKey:kSTACK_OUTPUT_AUDIO Dictionary:dictIODATA];
                if ([dictOutputAudio isKindOfClass:[NSDictionary class]]) {
                    id arrOutputAudio = [Utility checkNullForKey:kOUTPUT_AUDIO Dictionary:dictOutputAudio];
                    if ([arrOutputAudio isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dictOPA in arrOutputAudio) {
                            NSString *strUnitId = [Utility checkNullForKey:kUNIT_ID Dictionary:dictOPA];
                            if ([strUnitId isEqualToString:objMaster.UnitId]) {
                                objMaster.OutputCount = [[Utility checkNullForKey:kPORTS Dictionary:dictOPA] integerValue];
                                objMaster.HubOutputData = [OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPA] Hub:objMaster keyValue:kSTACK_OUTPUT_AUDIO];
                            } else {
                                for (Hub* objSlave in arrSlaveDevice) {
                                    if ([strUnitId isEqualToString:objSlave.UnitId]) {
                                        objSlave.OutputCount = [[Utility checkNullForKey:kPORTS Dictionary:dictOPA] integerValue];
                                        objSlave.HubOutputData = [OutputDevice getObjectArraySystem:[Utility checkNullForKey:kLABELS Dictionary:dictOPA] Hub:objSlave keyValue:kSTACK_OUTPUT_AUDIO];
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
      
                id arrUnits = [Utility checkNullForKey:kSTACK_UNIT_INFO Dictionary:dictResp];
                if ([arrUnits isKindOfClass:[NSArray class]]) {
                    
            
                    
                    for (NSDictionary *dictOPA in arrUnits) {
                        NSString *strUnitId = [Utility checkNullForKey:kUNIT_ID Dictionary:dictOPA];
                        if ([strUnitId isEqualToString:objMaster.UnitId]) {
                            objMaster.Name          = [Utility checkNullForKey:kMHUB_NAME Dictionary:dictOPA];
                        }
                        else {
                            for (Hub* objSlave in arrSlaveDevice) {
                                if ([strUnitId isEqualToString:objSlave.UnitId]) {
                                    objSlave.Name          = [Utility checkNullForKey:kMHUB_NAME Dictionary:dictOPA];
                                    break;
                                }
                            }
                        }
                        }
                        
                    }
            

            id dictMappingDATA = [Utility checkNullForKey:kMAPPING Dictionary:dictResp] ;
            [[NSUserDefaults standardUserDefaults]setValue:dictMappingDATA forKey:@"MappingKeyData"];
            
            //Adding CEC option complusory for pro2 , 411 and ZP devices.
            if(objMaster.Generation == mHubPro2 || objMaster.Generation == mHub411 || objMaster.Generation == mHubZP || objMaster.Generation == mHubS)
                {
                id dictCECData = [Utility checkNullForKey:@"cec" Dictionary:dictIODATA];
                if ([dictCECData isKindOfClass:[NSDictionary class]]) {
                    //NSLog(@"Dict value %@",dictCECData);
                    objMaster.HubCECData = dictCECData;
                }
                OutputDevice *aObj = [[OutputDevice alloc]init ];
                aObj.Index  = 100;
                aObj.sourceType = OutputScreen;
                aObj.isIRPack = true;
                aObj.Name = @"CEC";
                aObj.CreatedName = @"CEC";
                aObj.PortNo = 4;
                objMaster.OutputCount += 1;
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Index == %ld", 100];
                    NSArray *arrCmdDataFiltered = [objMaster.HubOutputData filteredArrayUsingPredicate:predicate];
                    if([arrCmdDataFiltered isNotEmpty])
                    {
//                                OutputDevice *aObj = (OutputDevice *)[arrCmdDataFiltered objectAtIndex:0];
//                                if([objReturn.HubOutputData containsObject:aObj]){
//
//                                    }
                        
                    }else
                    {
                        [objMaster.HubOutputData addObject:aObj];
                    }
                
                }

            handler (objMaster, arrSlaveDevice);
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
        handler (objMaster, arrSlaveDevice);
    }
}

#pragma mark - GET Image name based on device type MHUB OBJECT

+(UIImage *)getHubDeviceImage:(NSString *)secType{
    
    
    UIImage *imageObj;
    if ([secType isContainString:kDEVICEMODEL_MHUB4K44PRO] || [secType isContainString:kDEVICEMODEL_MHUBPRO24440] ) {
        imageObj = kDEVICEMODEL_IMAGE_MHUB4K44PRO_CARBONITE;

    }
    if ([secType isContainString:kDEVICEMODEL_MHUB4K88PRO] || [secType isContainString:kDEVICEMODEL_MHUBPRO288100]) {
        imageObj =  kDEVICEMODEL_IMAGE_MHUB4K88PRO_CARBONITE;
    }
    if ([secType isContainString:kDEVICEMODEL_MHUB4K431]) {
        imageObj =  kDEVICEMODEL_IMAGE_MHUB4K431_CARBONITE;
    }
    if ([secType isContainString:kDEVICEMODEL_MHUB4K862]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUB4K862_CARBONITE;
    }
    
    if ([secType isContainString:kDEVICEMODEL_MHUB431U]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUB431U_CARBONITE;
    }
    if ([secType isContainString:kDEVICEMODEL_MHUB862U]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUB862U_CARBONITE;
    }
    
    if ([secType isContainString:kDEVICEMODEL_MHUBPRO4440]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBPRO4440_CARBONITE;
    }
    if ([secType isContainString:kDEVICEMODEL_MHUBPRO8840]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBPRO8840_CARBONITE;
    }
    
    if ([secType isContainString:kDEVICEMODEL_MHUBAUDIO64]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBAUDIO64_CARBONITE;
    }
    
    if ([secType isContainString:kDEVICEMODEL_MHUBMAX44]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBMAX44_CARBONITE;
    }
    if ([secType isContainString:kDEVICEMODEL_MHUBU41140]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBU41140_CARBONITE;
    }
    if ([secType isContainString:kDEVICEMODEL_MHUBZP5]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBUZP5_CARBONITE;
    }
    if ([secType isContainString:kDEVICEMODEL_MHUBZPMINI]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBUZP1_CARBONITE;
    }
    if ([secType isContainString:kDEVICEMODEL_MHUB_S]) {
        imageObj =   kDEVICEMODEL_IMAGE_MHUBUZP1_CARBONITE;
    }
    return imageObj;
    
}

#pragma mark - GET SEARCH MHUB OBJECT
+(Hub*) getObjectFromMDNSObject:(NSNetService*)service {
    Hub *objReturn=[[Hub alloc] init];
    @try {
        //DDLogDebug(@"service == %@", service);
        if (service) {
            objReturn.UserInfo = service;
            NSString *strModelName = [service name];
            objReturn.modelName = strModelName;
            objReturn = [Hub getGenerationFromModelName:objReturn];
            NSArray *strings = [strModelName componentsSeparatedByString:@"#"];
            if (strings.count > 0) {
                objReturn.Name = [[strings firstObject] getTrimmedString];
            } else {
                objReturn.Name = [Hub getMhubDisplayName:objReturn];
            }
            if([objReturn.Name containsString:@"-"])
                {
                NSArray *tempArry = [objReturn.Name componentsSeparatedByString:@"-"];
                if(tempArry.count > 2)
                {
                     objReturn.Name= [tempArry objectAtIndex:1];
                }
                else
                {
                     objReturn.Name= [tempArry firstObject];
                }

            }
            [APIManager writeNormalStringWithTimeStamp:[NSString stringWithFormat:@"METHOD:*getObjectFromMDNSObject*\nobjReturn.modelName=%@\nobjReturn.Name=%@",objReturn.modelName,objReturn.Name]];
        }

    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(Hub*) getObjectFromSSDPXMLDictionary:(NSDictionary*)dictResp {
    Hub *objReturn=[[Hub alloc] init];
    @try {
        //DDLogDebug(@"detail == %@", dictResp);
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.Name          = [Utility checkNullForKey:kFRIENDLYNAME Dictionary:dictResp];
            objReturn.SerialNo      = [Utility checkNullForKey:kSERIALNUMBER Dictionary:dictResp];
            NSURL *url              = [NSURL URLWithString:[Utility checkNullForKey:kPRESENTATIONURL Dictionary:dictResp]];
            objReturn.Address       = [url host];
            objReturn.Generation    = mHub4KV3;
            objReturn.modelName     = [Utility checkNullForKey:kMODELNAME Dictionary:dictResp];
            objReturn.BootFlag      = true;
            if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUB4K431]) {
                objReturn.OutputCount   = 4;
                objReturn.InputCount    = 4;
            } else if ([objReturn.modelName isContainString:kDEVICEMODEL_MHUB4K862]) {
                objReturn.OutputCount   = 8;
                objReturn.InputCount    = 8;
            } else {
                objReturn.OutputCount   = 0;
                objReturn.InputCount    = 0;
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - GET MHUB OBJECT FROM XML/JSON
+(Hub*) getHubObjectFromConfigXML:(NSDictionary*)dictResp SearchHub:(Hub*)objHub {
    @try {
        //NSLog(@"getHubObjectFromConfigXML %@",dictResp);

        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objHub.Official_Name    = [Utility checkNullForKey:kOFFICIALNAME Dictionary:dictResp];
            objHub.modelName        = [Utility checkNullForKey:kPRODUCTCODE Dictionary:dictResp];
            objHub.Generation       = (HubModel)[[Utility checkNullForKey:kGENERATIONFLAG Dictionary:dictResp] integerValue];

            float fltAPIVer         = [[Utility checkNullForKey:kAPI Dictionary:dictResp] floatValue];
            NSString *strMOSVer     = [Utility checkNullForKey:kDASH Dictionary:dictResp]; //@"7.01";

            objHub.apiVersion       = (fltAPIVer == 0 ? 1.0 : fltAPIVer);
            objHub.strMOSVersion    = strMOSVer;
            objHub.mosVersion       = [strMOSVer floatValue];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objHub;
}

+(Hub*) getHubObjectFromUserProfileXML:(NSDictionary*)dictResp SearchHub:(Hub*)objHub {
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objHub.Mac      = [Utility checkNullForKey:kMACADDRESS Dictionary:dictResp];
            objHub.BootFlag = [[Utility checkNullForKey:kFIRSTBOOTXML Dictionary:dictResp] boolValue];
            objHub.SerialNo = [Utility checkNullForKey:kSERIAL Dictionary:dictResp];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objHub;
}

#pragma mark -
+(Hub*) getHubObjectFromConfigJSON:(NSDictionary*)dictResp SearchHub:(Hub*)objHub {
    @try {
         //NSLog(@"getHubObjectFromConfigJSON %@",dictResp);
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            [APIManager writeNormalStringWithTimeStamp:[NSString stringWithFormat:@"METHOD:*getHubObjectFromConfigJSON*\n%@",dictResp]];
            objHub.Official_Name    = [Utility checkNullForKey:kOFFICIAL_NAME Dictionary:dictResp];
            objHub.modelName        = [Utility checkNullForKey:kPRODUCT_CODE Dictionary:dictResp];
            objHub                  = [Hub getGenerationFromModelName:objHub];
            objHub.SerialNo         = [Utility checkNullForKey:kSERIAL_NUMBER Dictionary:dictResp];

            float fltAPIVer         = [[Utility checkNullForKey:kAPI Dictionary:dictResp] floatValue];
            NSString *strMOSVer     = [Utility checkNullForKey:kMHUBOS_VERSION Dictionary:dictResp]; //@"7.01";

            objHub.apiVersion       = (fltAPIVer == 0 ? 1.0 : fltAPIVer);
            objHub.strMOSVersion    = strMOSVer;
            objHub.mosVersion       = [strMOSVer floatValue];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objHub;
}

+(Hub*) getHubObjectFromUserProfileJSON:(NSDictionary*)dictResp SearchHub:(Hub*)objHub {
    @try {
        //NSLog(@"getHubObjectFromUserProfileJSON %@",dictResp);
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
             [APIManager writeNormalStringWithTimeStamp:[NSString stringWithFormat:@"METHOD:*getHubObjectFromUserProfileJSON*\n%@",dictResp]];
            NSDictionary *dictMhub  = [Utility checkNullForKey:kMHUBJSON Dictionary:dictResp];
            objHub.BootFlag         = [[Utility checkNullForKey:kFIRST_BOOT Dictionary:dictMhub] boolValue];
            objHub.webSocketFlag      = [[Utility checkNullForKey:kWS Dictionary:dictMhub] boolValue];

            // NSDictionary *dictIOLabels   = [Utility checkNullForKey:kIO_LABELS Dictionary:[Utility checkNullForKey:kCONFIG Dictionary:dictResp]];
            // objHub.HubInputData          = [InputDevice getObjectArrayJSON:[Utility checkNullForKey:kINPUTS Dictionary:dictIOLabels]];
            // objHub.HubOutputData         = [OutputDevice getObjectArrayJSON:[Utility checkNullForKey:kOUTPUTS Dictionary:dictIOLabels] InputCount:objHub.HubInputData.count];
            // objHub.HubZoneData           = [Zone getObjectArrayJSON:[Utility checkNullForKey:kZONES Dictionary:dictIOLabels]];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objHub;
}

+(Hub*) getHubObjectFromPairJSON:(PairDetail*)objPair {
    @try {
        Hub *objReturn=[[Hub alloc] init];
        if ([objPair isNotEmpty]) {
            objReturn.UnitId = objPair.unit_id;
            objReturn.Address = objPair.ip_address;
            objReturn.SerialNo = objPair.serial_number;
        }
        return objReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark -
+(Hub*) getAudioObjectFromCount:(NSInteger)intCount {
    Hub *objReturn = [[Hub alloc] initWithDemoAudioDevice];
    @try {
        objReturn.UnitId        = [NSString stringWithFormat:@"S%ld", (long)intCount];
        objReturn.Generation    = mHubAudio;
        objReturn.modelName     = [Hub getModelName:objReturn];
        objReturn.Name          = [Hub getMhubDisplayName:objReturn];
        objReturn.OutputCount   = 4;
        objReturn.InputCount    = 6;
        objReturn.HubOutputData = [[NSMutableArray alloc] initWithArray:[OutputDevice getTempOutputObjectArray:objReturn.OutputCount Hub:objReturn]];
        objReturn.HubInputData  = [[NSMutableArray alloc] initWithArray:[InputDevice getTempInputObjectArray:objReturn.InputCount Hub:objReturn]];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(Hub*) getSlaveMubSObjectFromCount:(NSInteger)intCount {
    Hub *objReturn = [[Hub alloc] initWithDemoMhubSDevice];
    @try {
        objReturn.UnitId        = [NSString stringWithFormat:@"S%ld", (long)intCount];
        objReturn.Generation    = mHubS;
        objReturn.modelName     = [Hub getModelName:objReturn];
        objReturn.Name          = [Hub getMhubDisplayName:objReturn];
        objReturn.OutputCount   = 4;
        objReturn.InputCount    = 6;
        objReturn.HubOutputData = [[NSMutableArray alloc] initWithArray:[OutputDevice getTempOutputObjectArray:objReturn.OutputCount Hub:objReturn]];
        objReturn.HubInputData  = [[NSMutableArray alloc] initWithArray:[InputDevice getTempInputObjectArray:objReturn.InputCount Hub:objReturn]];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - GET OBJECT ARRAY
+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                Hub *objDevice = [Hub getObjectFromDictionary:dictResp];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getAudioObjectArrayFromCount:(NSInteger)AudioCount {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        for (int i = 1; i <= AudioCount; i++) {
            Hub *objDevice = [Hub getAudioObjectFromCount:i];
            [arrReturn addObject:objDevice];
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getObjectArrayFromPairJSON:(Pair*)objPair {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if ([objPair isNotEmpty]) {
            NSArray *arrSlave = [[NSArray alloc] initWithArray:objPair.arrSlave];
            for (int counter = 0; counter < arrSlave.count; counter++) {
                PairDetail *objPairDetail = [arrSlave objectAtIndex:counter];
                Hub *objDevice=[[Hub alloc] initWithHub:[Hub getHubObjectFromPairJSON:objPairDetail]];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark - DICTIONARY FORMAT
-(NSDictionary*) dictionaryRepresentation {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.UnitId forKey:kUNIT_ID];
        [dict setValue:self.Name forKey:kNAME];
        [dict setValue:self.Official_Name forKey:kOFFICIALNAME];
        [dict setValue:self.Mac forKey:kMAC];
        [dict setValue:self.Address forKey:kADDRESS];
        [dict setValue:[NSNumber numberWithInteger:self.Generation] forKey:kGENERATION];
        [dict setValue:self.modelName forKey:kMODELNAME];
        [dict setValue:[NSNumber numberWithBool:self.BootFlag] forKey:kBOOTFLAG];
        [dict setValue:[NSNumber numberWithBool:self.webSocketFlag] forKey:kWEBSOCKETFLAG];
        [dict setValue:self.SerialNo forKey:kSERIALNO];

        [dict setValue:[NSNumber numberWithInteger:self.OutputCount] forKey:kOUTPUTCOUNT];
        [dict setValue:[NSNumber numberWithInteger:self.InputCount] forKey:kINPUTCOUNT];

        [dict setValue:[OutputDevice getServerDictionaryArray:self.HubOutputData] forKey:kHUBOUTPUTDATA];
        [dict setValue:[InputDevice getDictionaryArray:self.HubInputData] forKey:kHUBINPUTDATA];
         [dict setValue:[InputDevice getDictionaryArray:self.HubInputDataAudioInStandalone] forKey:kHUBINPUTDATAAUDIOSTANDALONE];
        [dict setValue:self.hubName_InStack forKey:kMHUB_NAME_INSTACK];
        

        if (self.Generation != mHub4KV3) {
            // [dict setValue:self.UserInfo forKey:kUSERINFO];
            [dict setValue:[NSNumber numberWithFloat:self.apiVersion] forKey:kAPIVERSION];
            [dict setValue:[NSNumber numberWithFloat:self.mosVersion] forKey:kMOSVERSION];
            [dict setValue:[NSNumber numberWithFloat:self.MHub_BenchMarkVersion] forKey:kSTRMOSBENCHMARKVERSION];
            
            [dict setValue:self.strMOSVersion forKey:kSTRMOSVERSION];
            [dict setValue:[NSNumber numberWithBool:self.AVR_IRPack] forKey:kAVR_IRPACK];
            [dict setValue:[NSNumber numberWithBool:self.isPaired] forKey:kISPAIRED];
            [dict setValue:[NSNumber numberWithBool:self.isAutoSwitchMode] forKey:kISAUTOSWITCHMODE];
            
            [dict setValue:[Zone getDictionaryArray:self.HubZoneData] forKey:kHUBZONEDATA];
            [dict setValue:[Group getDictionaryArray:self.HubGroupData] forKey:kHUBGROUPDATA];
            [dict setValue:[Sequence getDictionaryArray:self.HubSequenceList] forKey:kHUBSEQUENCELIST];
            [dict setValue:[AVRDevice getDictionaryArray:self.HubAVRList] forKey:kHUBAVRLIST];

            [dict setValue:[self.PairingDetails dictionaryRepresentation] forKey:kPAIRING_DETAILS];
            [dict setValue:[Controls getDictionaryArray:self.HubControlsList] forKey:kHUBCONTROLSDATA];
        }

        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Support Check Method

-(BOOL) isAPIV2 {
    @try {
        BOOL isReturn = false;
        if (self.apiVersion >= 2.0) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL) isUControlSupport {
    @try {
        BOOL isReturn = false;
        if (self.Generation == mHubPro || self.Generation == mHub4KV4 || self.Generation == mHubPro2 || self.Generation == mHub411 || self.Generation == mHubZP || self.Generation == mHubS) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
//
-(BOOL) isSwitchSupportOnly {
    @try {
        BOOL isReturn = false;
        if (self.Generation == mHub4KV3  || self.Generation == mHubMAX || self.Generation == mHubAudio) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL) isGroupSupport {
    @try {
        BOOL isReturn = false;
        if ([self isAPIV2] && (self.Generation == mHubAudio || [self isPairedSetup])) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL) isDemoMode {
    @try {
        BOOL isReturn = false;
        if ([self.Address isEqualToString:STATICTESTIP_PRO]) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL) isPairedSetup {
    @try {
        BOOL isReturn = false;
        if (self.isPaired == true) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL) isPro2Setup {
    @try {
        BOOL isReturn = false;
        if ([self isAPIV2] && (self.Generation == mHubPro2 )) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
-(BOOL) isZPSetup {
    @try {
        BOOL isReturn = false;
        if ([self isAPIV2] && (self.Generation == mHubZP )) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL) is411Setup {
    @try {
        BOOL isReturn = false;
        if ([self isAPIV2] && (self.Generation == mHub411 )) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL) isWifiSetup {
    @try {
        BOOL isReturn = false;
        if (self.Generation == mHubZP || self.Generation == mHub411  ) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL) isAlreadyPairedSetup {
    @try {
        BOOL isReturn = false;
        if (self.isPaired == true && self.BootFlag == true) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL) isVideoUnit:(NSString*)strUnitId {
    @try {
        BOOL isReturn = false;
        if (([self.UnitId isEqualToString:kUNITID_VIDEO] || [self.UnitId isEqualToString:kUNITID_HYBRID] || [self.UnitId isEqualToString:kUNITID_MASTER])) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL) isVideoWithMOS {
    @try {
        BOOL isReturn = false;
        if (self.Generation == mHubPro  || self.Generation == mHubMAX || self.Generation == mHub4KV4 || self.Generation == mHubPro2 || self.Generation == mHubS) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - CHECK FOR AVAILABLE DEVICE
+(void) deviceAvailableForPair:(Hub*)objMaster Slaves:(NSMutableArray*)arrSlaves completion:(void (^)(BOOL isMaster, BOOL isSlave, Hub *objWarningSlave))handler {
    @try {
        BOOL isMasterAvailable = false;
        BOOL isSlaveAvailable = false;
        Hub *objSlaveReturn = nil;
        if (objMaster.BootFlag == true) {
            isMasterAvailable = true;
        } else {
            for(Hub *objSlave in arrSlaves) {
                if (objSlave.BootFlag == true) {
                    isSlaveAvailable = true;
                    objSlaveReturn = [[Hub alloc] initWithHub:objSlave];
                    break;
                }
            }
        }
        handler(isMasterAvailable, isSlaveAvailable, objSlaveReturn);
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:self.UnitId forKey:kUNIT_ID];
        [encoder encodeObject:self.Name forKey:kNAME];
        [encoder encodeObject:self.Official_Name forKey:kOFFICIALNAME];
        [encoder encodeObject:self.hubName_InStack forKey:kMHUB_NAME_INSTACK];

        [encoder encodeObject:self.Mac forKey:kMAC];
        [encoder encodeObject:self.Address forKey:kADDRESS];
        [encoder encodeInteger:self.Generation forKey:kGENERATION];
        [encoder encodeObject:self.modelName forKey:kMODELNAME];
        [encoder encodeBool:self.BootFlag forKey:kBOOTFLAG];
        [encoder encodeBool:self.webSocketFlag forKey:kWEBSOCKETFLAG];

        [encoder encodeObject:self.SerialNo forKey:kSERIALNO];
        // [encoder encodeObject:self.UserInfo forKey:kUSERINFO];
        [encoder encodeFloat:self.apiVersion forKey:kAPIVERSION];
        [encoder encodeFloat:self.mosVersion forKey:kMOSVERSION];
        [encoder encodeFloat:self.MHub_BenchMarkVersion forKey:kSTRMOSBENCHMARKVERSION];
        [encoder encodeObject:self.strMOSVersion forKey:kSTRMOSVERSION];
        [encoder encodeBool:self.AVR_IRPack forKey:kAVR_IRPACK];
        [encoder encodeBool:self.isPaired forKey:kISPAIRED];
        [encoder encodeBool:self.isAutoSwitchMode forKey:kISAUTOSWITCHMODE];
        
        [encoder encodeInteger:self.OutputCount forKey:kOUTPUTCOUNT];
        [encoder encodeInteger:self.InputCount forKey:kINPUTCOUNT];

        [encoder encodeObject:self.HubOutputData forKey:kHUBOUTPUTDATA];
        [encoder encodeObject:self.HubInputData forKey:kHUBINPUTDATA];
        [encoder encodeObject:self.HubInputDataAudioInStandalone forKey:kHUBINPUTDATAAUDIOSTANDALONE];


        [encoder encodeObject:self.HubZoneData forKey:kHUBZONEDATA];
        [encoder encodeObject:self.HubGroupData forKey:kHUBGROUPDATA];
        [encoder encodeObject:self.HubSequenceList forKey:kHUBSEQUENCELIST];
        [encoder encodeObject:self.HubAVRList forKey:kHUBAVRLIST];
        [encoder encodeObject:self.PairingDetails forKey:kPAIRING_DETAILS];
        [encoder encodeObject:self.HubControlsList forKey:kHUBCONTROLSDATA];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.Name           = [decoder decodeObjectForKey:kNAME];
            self.Mac            = [decoder decodeObjectForKey:kMAC];
            self.Address        = [decoder decodeObjectForKey:kADDRESS];
            self.modelName      = [decoder decodeObjectForKey:kMODELNAME];
            self.SerialNo       = [decoder decodeObjectForKey:kSERIALNO];

            self.HubInputData   = [decoder decodeObjectForKey:kHUBINPUTDATA];
            self.HubInputDataAudioInStandalone   = [decoder decodeObjectForKey:kHUBINPUTDATAAUDIOSTANDALONE];
            self.HubOutputData  = [decoder decodeObjectForKey:kHUBOUTPUTDATA];
            self.HubSequenceList= [decoder decodeObjectForKey:kHUBSEQUENCELIST];
            self.HubAVRList     = [decoder decodeObjectForKey:kHUBAVRLIST];
            self.HubControlsList= [decoder decodeObjectForKey:kHUBCONTROLSDATA];
            // Data type change for the Numerical type of value which throw exception.
            @try {
                self.Generation     = (HubModel)[decoder decodeIntegerForKey:kGENERATION];
                self.BootFlag       = [decoder decodeBoolForKey:kBOOTFLAG];
                self.webSocketFlag       = [decoder decodeBoolForKey:kWEBSOCKETFLAG];
                
                self.OutputCount    = [decoder decodeIntegerForKey:kOUTPUTCOUNT];
                self.InputCount     = [decoder decodeIntegerForKey:kINPUTCOUNT];
            } @catch(NSException *exception) {
                self.Generation     = (HubModel)[[decoder decodeObjectForKey:kGENERATION] integerValue];
                self.BootFlag       = [[decoder decodeObjectForKey:kBOOTFLAG] boolValue];
                self.webSocketFlag       = [decoder decodeBoolForKey:kWEBSOCKETFLAG];
                self.OutputCount    = [[decoder decodeObjectForKey:kOUTPUTCOUNT] integerValue];
                self.InputCount     = [[decoder decodeObjectForKey:kINPUTCOUNT] integerValue];
            }

            self.UnitId         = [decoder decodeObjectForKey:kUNIT_ID];
            self.Official_Name  = [decoder decodeObjectForKey:kOFFICIALNAME];
            self.hubName_InStack  = [decoder decodeObjectForKey:kMHUB_NAME_INSTACK];
            
            self.apiVersion     = [decoder decodeFloatForKey:kAPIVERSION];
            self.AVR_IRPack     = [decoder decodeBoolForKey:kAVR_IRPACK];

            self.mosVersion     = [decoder decodeFloatForKey:kMOSVERSION];
            self.MHub_BenchMarkVersion     = [decoder decodeFloatForKey:kSTRMOSBENCHMARKVERSION];
            

            self.strMOSVersion  = [[decoder decodeObjectForKey:kSTRMOSVERSION] isNotEmpty] ? [decoder decodeObjectForKey:kSTRMOSVERSION] : [NSString stringWithFormat:@"%.02f", self.mosVersion];
            self.isPaired       = [decoder decodeBoolForKey:kISPAIRED];
            self.isAutoSwitchMode       = [decoder decodeBoolForKey:kISAUTOSWITCHMODE];


            self.HubZoneData    = [decoder decodeObjectForKey:kHUBZONEDATA];
            self.HubGroupData   = [decoder decodeObjectForKey:kHUBGROUPDATA];

            self.PairingDetails = [decoder decodeObjectForKey:kPAIRING_DETAILS];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
