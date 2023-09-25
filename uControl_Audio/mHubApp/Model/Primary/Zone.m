//
//  Zone.m
//  mHubApp
//
//  Created by Anshul Jain on 24/04/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

/*
 Zone contains basic details like zone_id, zone_label, input connected, output list, volume value, mute status, etc.
 */

#import "Zone.h"

@implementation Zone
#pragma mark - HUB Intializer

-(id)init {
    self = [super init];
    @try {
        self.zone_id        = @"";
        self.zone_label     = @"";
        self.arrOutputs     = [[NSMutableArray alloc] init];
        self.audio_input    = 0;
        self.video_input    = 0;
        self.disp_audio_input    = 0;
        self.Volume         = 0;
        self.isMute         = false;
        self.isDeleted      = true;
        self.isGrouped      = false;
        self.imgGroupedZone = nil;
        self.imgControlGroupBG  = nil;
        self.isIRPackAvailable = false;
        self.bottomControlDevice  = Uncontrollable;
        //Anshul Changes after pro2 devices.
        //self.isAuto_switch_mode = false;
        self.OutputTypeInSelectedZone = 0;
        self.avr_id        = 0;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

-(id)initWithZone:(Zone *)zoneData {
    self = [super init];
    @try {
        self.zone_id        = zoneData.zone_id;
        self.zone_label     = zoneData.zone_label;
        self.arrOutputs     = zoneData.arrOutputs;
        self.audio_input    = zoneData.audio_input;
        self.video_input    = zoneData.video_input;
        self.disp_audio_input=  zoneData.disp_audio_input;
        self.Volume         = zoneData.Volume;
        self.isMute         = zoneData.isMute;
        self.isDeleted      = zoneData.isDeleted;
        self.isGrouped      = zoneData.isGrouped;
        self.imgGroupedZone = zoneData.imgGroupedZone;

        self.imgControlGroupBG  = zoneData.imgControlGroupBG;
        self.isIRPackAvailable  = zoneData.isIRPackAvailable;

        self.bottomControlDevice  = zoneData.bottomControlDevice;
       // self.isAuto_switch_mode = zoneData.isAuto_switch_mode;
        self.OutputTypeInSelectedZone =  zoneData.OutputTypeInSelectedZone;
        self.avr_id        = zoneData.avr_id;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

#pragma mark -
+(Zone*) getZoneObject_From:(Zone *)objFrom To:(Zone*)objTo {
    Zone *objReturn = [[Zone alloc] initWithZone:objTo];
    @try {
        if ([objFrom.zone_id isNotEmpty]) {
            objReturn.zone_id = objFrom.zone_id;
        }

        if ([objFrom.zone_label isNotEmpty]) {
            objReturn.zone_label = objFrom.zone_label;
        }

        if ([objFrom.arrOutputs isNotEmpty]) {
            objReturn.arrOutputs = objFrom.arrOutputs;
        }

        if (objFrom.audio_input != 0) {
            objReturn.audio_input = objFrom.audio_input;
        }

        if (objFrom.video_input != 0) {
            objReturn.video_input = objFrom.video_input;
        }
        if (objFrom.disp_audio_input != 0) {
            objReturn.disp_audio_input = objFrom.disp_audio_input;
        }
        
 
        if (objFrom.Volume != 0) {
            objReturn.Volume = objFrom.Volume;
        }

        //if (objFrom.isMute == true) {
            objReturn.isMute = objFrom.isMute;
        //}

        if (objFrom.isDeleted == true) {
            objReturn.isDeleted = objFrom.isDeleted;
        }

        if (objFrom.isGrouped == true) {
            objReturn.isGrouped = objFrom.isGrouped;
        }

        if ([objFrom.imgGroupedZone isNotEmpty]) {
            objReturn.imgGroupedZone = objFrom.imgGroupedZone;
        }

        if ([objFrom.imgControlGroupBG isNotEmpty]) {
            objReturn.imgControlGroupBG = objFrom.imgControlGroupBG;
        }

        if (objFrom.isIRPackAvailable == true) {
            objReturn.isIRPackAvailable = objFrom.isIRPackAvailable;
        }

         if (objFrom.bottomControlDevice != 0) {
        objReturn.bottomControlDevice = objFrom.bottomControlDevice;
         }

//        if (objFrom.isAuto_switch_mode == true) {
//                objReturn.isAuto_switch_mode = objFrom.isAuto_switch_mode;
//        }

        if (objFrom.OutputTypeInSelectedZone != 0) {
            objReturn.OutputTypeInSelectedZone =  objFrom.OutputTypeInSelectedZone;
        }
        if (objFrom.avr_id != 0) {
            objReturn.avr_id = objFrom.avr_id;
        }

    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - GET ZONE OBJECT
+(Zone*) getObjectFromDictionary:(NSDictionary*)dictResp Hub:(Hub*)objHub {
    Zone *objReturn = [[Zone alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.zone_id = [Utility checkNullForKey:kZONE_ID Dictionary:dictResp];
            objReturn.zone_label = [Utility checkNullForKey:kZONE_LABEL Dictionary:dictResp];
            objReturn.arrOutputs = [[NSMutableArray alloc] initWithArray:[OutputDevice getZoneOutputObjectArray:[Utility checkNullForKey:kOUTPUTS Dictionary:dictResp]]];
            objReturn.isDeleted = true;
            //objReturn.isAuto_switch_mode = [[Utility checkNullForKey:kAuto_Switch_Mode Dictionary:dictResp] boolValue];
            if ([[dictResp objectForKey:kAVR] isNotEmpty]) {
                objReturn.avr_id = [[Utility checkNullForKey:kAVR Dictionary:dictResp] integerValue];
            }

            if ([[dictResp objectForKey:kIMGCONTROLGROUPBG] isNotEmpty]) {
                objReturn.imgControlGroupBG = [dictResp objectForKey:kIMGCONTROLGROUPBG];
            } else {
                UIImage *imgBG = [Utility retrieveImageFromDocumentDirectory_ZoneId:objReturn.zone_id];
                if ([imgBG isNotEmpty]) {
                    objReturn.imgControlGroupBG = imgBG;
                } else {
                    objReturn.imgControlGroupBG = nil;
                }
            }
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(Zone*) getZoneObjectFromDictionary:(NSDictionary*)dictResp Hub:(Hub*)objHub {
    Zone *objReturn = [[Zone alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.zone_id           = [Utility checkNullForKey:kZONE_ID Dictionary:dictResp];
            objReturn.zone_label        = [Utility checkNullForKey:kZONE_LABEL Dictionary:dictResp];
            objReturn.arrOutputs        = [[NSMutableArray alloc] initWithArray:[OutputDevice getOutputObjectArray:[Utility checkNullForKey:kOUTPUTS Dictionary:dictResp] Hub:objHub]];
            objReturn.audio_input       = [[Utility checkNullForKey:kAUDIO_INPUT Dictionary:dictResp] integerValue];
            objReturn.video_input       = [[Utility checkNullForKey:kVIDEO_INPUT Dictionary:dictResp] integerValue];
            objReturn.disp_audio_input   = [[Utility checkNullForKey:kDISP_AUDIO_INPUT Dictionary:dictResp] integerValue];
            objReturn.Volume            = [[Utility checkNullForKey:kVOLUME Dictionary:dictResp] integerValue];
            objReturn.isMute            = [[Utility checkNullForKey:kMUTE Dictionary:dictResp] boolValue];
            objReturn.isDeleted         = [[Utility checkNullForKey:kISDELETED Dictionary:dictResp] boolValue];
            objReturn.isGrouped         = [[Utility checkNullForKey:kISGROUPED Dictionary:dictResp] boolValue];
            objReturn.imgGroupedZone    = [Utility checkNullForKey:kGROUPEDZONEIMAGE Dictionary:dictResp];
            if ([[dictResp objectForKey:kAVR] isNotEmpty]) {
                objReturn.avr_id =  [[Utility checkNullForKey:kAVR Dictionary:dictResp] integerValue];
            }
            if ([[dictResp objectForKey:kIMGCONTROLGROUPBG] isNotEmpty]) {
                objReturn.imgControlGroupBG = [dictResp objectForKey:kIMGCONTROLGROUPBG];
            } else {
                UIImage *imgBG = [Utility retrieveImageFromDocumentDirectory_ZoneId:objReturn.zone_id];
                if ([imgBG isNotEmpty]) {
                    objReturn.imgControlGroupBG = imgBG;
                } else {
                    objReturn.imgControlGroupBG = nil;
                }
            }
            objReturn.isIRPackAvailable = [[Utility checkNullForKey:kISIRPACKAVAILABLE Dictionary:dictResp] boolValue];
            objReturn.bottomControlDevice = (ControlDeviceType)[[Utility checkNullForKey:kBOTTOMCONTROLDEVICE Dictionary:dictResp] integerValue];
            //Changes by anshul after pro2 device. For auto/manual mode and what type of Output zone is containing, video,audio or audio/video both.
            //objReturn.isAuto_switch_mode = [[Utility checkNullForKey:kAuto_Switch_Mode Dictionary:dictResp] boolValue];
            //August2020: After the pro2 devices. The below code is written to define whether Zone is Audio only, video only or both audio,video outputs.
            BOOL flagAllMasters = true;
            for (int i = 0; i < objReturn.arrOutputs .count; i++) {
                        OutputDevice *obj = [objReturn.arrOutputs objectAtIndex:i];
                        if([obj.UnitId containsString:@"S"])
                        {
                            flagAllMasters = false;
                        }
            }
                       if(objReturn.arrOutputs.count == 1)
                       {
                           OutputDevice *obj = [objReturn.arrOutputs objectAtIndex:0];
                           if([obj.outputType_VideoOrAudio containsString:@"audio"])
                           {
                               objReturn.OutputTypeInSelectedZone = audioOnly;
                           }
                           else  if(![obj.outputType_VideoOrAudio isNotEmpty] && [obj.UnitId containsString:@"S"])
                           {
                               objReturn.OutputTypeInSelectedZone = audioOnly;
                           }
                           else
                           {
                                objReturn.OutputTypeInSelectedZone = videoOnly;
                           }
                           
                       }
                       else if(flagAllMasters)
                       {
                           objReturn.OutputTypeInSelectedZone = allMasterOutputs;
                       }
                       else // if([obj.outputType_VideoOrAudio containsString:@"video"] || [obj.UnitId isEqualToString:@"M1"])
                        {
                             objReturn.OutputTypeInSelectedZone = audioVideoZone;
                         }
                         ////NSLog(@"array output %@  %@  %ld",obj.CreatedName,obj.Name,(long)obj.Index);
                      //   }
            //objReturn.OutputTypeInSelectedZone       = [[Utility checkNullForKey:kOutputTypeInSelectedZone Dictionary:dictResp] integerValue];
            

        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(Zone*) getObjectVolumeFromDictionary:(NSDictionary*)dictResp {
    Zone *objReturn = [[Zone alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.zone_id = [Utility checkNullForKey:kZONE_ID Dictionary:dictResp];
            if ([[dictResp objectForKey:kAVR] isNotEmpty]) {
                objReturn.avr_id =  [[Utility checkNullForKey:kAVR Dictionary:dictResp] integerValue];
            }
            NSArray *arrState = [Utility checkNullForKey:kZONE_STATE Dictionary:dictResp];
            if ([arrState isKindOfClass:[NSArray class]]) {
                for (int counter = 0; counter < arrState.count; counter++) {
                    NSDictionary *dict = [arrState objectAtIndex:counter];
                    OutputDevice *objOPStatus = [OutputDevice getObjectStatusFromDictionary:dict];
                    [objReturn.arrOutputs addObject:objOPStatus];
                }
            }
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(Zone*) getZoneStatusObjectFromDictionary:(NSDictionary*)dictResp {
    Zone *objReturn = [[Zone alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.zone_id           = [Utility checkNullForKey:kZONE_ID Dictionary:dictResp];
            objReturn.audio_input       = [[Utility checkNullForKey:kAUDIO_INPUT Dictionary:dictResp] integerValue];
            objReturn.video_input       = [[Utility checkNullForKey:kVIDEO_INPUT Dictionary:dictResp] integerValue];
            objReturn.disp_audio_input       = [[Utility checkNullForKey:kDISP_AUDIO_INPUT Dictionary:dictResp] integerValue];
            objReturn.Volume            = [[Utility checkNullForKey:kVOLUME Dictionary:dictResp] integerValue];
            objReturn.isMute            = [[Utility checkNullForKey:kMUTE Dictionary:dictResp] boolValue];
         //   objReturn.avr_id           = [Utility checkNullForKey:kAVR Dictionary:dictResp];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(Zone*) getObjectFromJSON_Key:(NSString*)strKey Value:(NSString*)strValue {
    Zone *objReturn = [[Zone alloc] init];
    @try {
        objReturn.zone_label = strValue;
        objReturn.zone_id = strKey;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - GET ZONE OBJECT ARRAY
+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp Hub:(Hub*)objHub {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                Zone *objDevice = [Zone getObjectFromDictionary:dictResp Hub:objHub];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getObjectVolumeArray:(NSMutableArray*)arrResp Hub:(Hub*)objHub {
    @try {
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                Zone *objVolume = [Zone getObjectVolumeFromDictionary:dictResp];
                for (Zone *objZone in objHub.HubZoneData) {
                    objZone.avr_id = objVolume.avr_id;//objVolume is coming with avrID and to update avr_id value in objHub.HubZoneData, we are writing this code.
                    if ([objVolume.zone_id isEqualToString:objZone.zone_id]) {
                        NSInteger intVolume = 0;
                        for (OutputDevice *objOP in objZone.arrOutputs) {
                            for (OutputDevice *objOPStatus in objVolume.arrOutputs) {
                                if (objOPStatus.Index == objOP.Index) {
                                    objOP.InputIndex = objOPStatus.InputIndex;
                                    objOP.Volume = objOPStatus.Volume;
                                    objOP.isMute = objOPStatus.isMute;
                                    intVolume += objOP.Volume;
                                    break;
                                }
                            }
                        }
                        ////NSLog(@"objZone.arrOutputs %lu",(unsigned long)objZone.arrOutputs.count);
                        if(objZone.arrOutputs.count > 0){
                        objZone.Volume = intVolume/objZone.arrOutputs.count;
                        }
                        break;
                    }
                }
            }
        }
        return objHub.HubZoneData;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getObjectArrayJSON:(NSDictionary*)dictResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];

        for (NSString* key in dictResp) {
            NSString *strValue = [Utility checkNullForKey:key Dictionary:dictResp];
            Zone *objDevice = [Zone getObjectFromJSON_Key:key Value:strValue];
            [arrReturn addObject:objDevice];
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
        [dict setValue:self.zone_id forKey:kZONE_ID];
        [dict setValue:self.zone_label forKey:kZONE_LABEL];
        [dict setValue:[OutputDevice getDictionaryArray:self.arrOutputs] forKey:kOUTPUTS];
        [dict setValue:[NSNumber numberWithInteger:self.Volume] forKey:kVOLUME];
        [dict setValue:[NSNumber numberWithBool:self.isMute] forKey:kMUTE];
        [dict setValue:[NSNumber numberWithBool:self.isDeleted] forKey:kISDELETED];
        [dict setValue:[NSNumber numberWithBool:self.isGrouped] forKey:kISGROUPED];
        [dict setValue:self.imgGroupedZone forKey:kGROUPEDZONEIMAGE];
        [dict setValue:self.imgControlGroupBG forKey:kIMGCONTROLGROUPBG];
        [dict setValue:[NSNumber numberWithBool:self.isIRPackAvailable] forKey:kISIRPACKAVAILABLE];
        [dict setValue:[NSNumber numberWithInteger:self.bottomControlDevice] forKey:kBOTTOMCONTROLDEVICE];
        //[dict setValue:[NSNumber numberWithBool:self.isAuto_switch_mode] forKey:kAuto_Switch_Mode];
        [dict setValue:[NSNumber numberWithInteger:self.OutputTypeInSelectedZone] forKey:kOutputTypeInSelectedZone];
        [dict setValue:[NSNumber numberWithInteger:self.avr_id] forKey:kAVR];
        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getDictionaryArray:(NSMutableArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                Zone *objDevice = [arrResp objectAtIndex:i];
                NSDictionary *dictResp = [objDevice dictionaryRepresentation];
                [arrReturn addObject:dictResp];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - GET FILTERED OBJECT
+(Zone*)getFilteredZoneData:(NSString*)zone_id ZoneData:(NSMutableArray*)arrZoneData {
    @try {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"zone_id = %@", zone_id];
        NSArray *arrZoneFiltered = [arrZoneData filteredArrayUsingPredicate:predicate];
        Zone *objReturn = nil;
        objReturn =  arrZoneFiltered.count > 0 ? arrZoneFiltered.firstObject : nil;
        return objReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSString*)getFilteredZoneId:(NSString*)zone_id ZoneIds:(NSMutableArray*)arrZoneIds {
    @try {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",zone_id]; // if you need case sensitive search avoid '[c]' in the predicate

//        NSArray *results = [arrZoneIds filteredArrayUsingPredicate:predicate];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"zone_id = %@", zone_id];

        NSArray *arrZoneFiltered = [arrZoneIds filteredArrayUsingPredicate:predicate];
        NSString *strReturn = nil;
        strReturn =  arrZoneFiltered.count > 0 ? arrZoneFiltered.firstObject : nil;
        return strReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeObject:self.zone_id forKey:kZONE_ID];
        [encoder encodeObject:self.zone_label forKey:kZONE_LABEL];
        [encoder encodeObject:self.arrOutputs forKey:kOUTPUTS];
        [encoder encodeInteger:self.audio_input forKey:kAUDIO_INPUT];
        [encoder encodeInteger:self.video_input forKey:kVIDEO_INPUT];
        [encoder encodeInteger:self.disp_audio_input forKey:kDISP_AUDIO_INPUT];
        [encoder encodeInteger:self.Volume forKey:kVOLUME];
        [encoder encodeBool:self.isMute forKey:kMUTE];
        [encoder encodeBool:self.isDeleted forKey:kISDELETED];
        [encoder encodeBool:self.isGrouped forKey:kISGROUPED];
        [encoder encodeObject:self.imgGroupedZone forKey:kGROUPEDZONEIMAGE];
        [encoder encodeObject:self.imgControlGroupBG forKey:kIMGCONTROLGROUPBG];
        [encoder encodeBool:self.isIRPackAvailable forKey:kISIRPACKAVAILABLE];
        [encoder encodeInteger:self.bottomControlDevice forKey:kBOTTOMCONTROLDEVICE];
        //[encoder encodeInteger:self.isAuto_switch_mode forKey:kAuto_Switch_Mode];
        [encoder encodeInteger:self.OutputTypeInSelectedZone forKey:kOutputTypeInSelectedZone];
        [encoder encodeInteger:self.avr_id forKey:kAVR];


    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            self.zone_id        = [decoder decodeObjectForKey:kZONE_ID];
            self.zone_label     = [decoder decodeObjectForKey:kZONE_LABEL];
            self.arrOutputs     = [decoder decodeObjectForKey:kOUTPUTS];
            self.audio_input    = [decoder decodeIntegerForKey:kAUDIO_INPUT];
            self.video_input    = [decoder decodeIntegerForKey:kVIDEO_INPUT];
            self.disp_audio_input    = [decoder decodeIntegerForKey:kDISP_AUDIO_INPUT];
            self.Volume         = [decoder decodeIntegerForKey:kVOLUME];
            self.isMute         = [decoder decodeBoolForKey:kMUTE];
            self.isDeleted      = [decoder decodeBoolForKey:kISDELETED];
            self.isGrouped      = [decoder decodeBoolForKey:kISGROUPED];
            self.imgGroupedZone = [decoder decodeObjectForKey:kGROUPEDZONEIMAGE];
            self.imgControlGroupBG  = [decoder decodeObjectForKey:kIMGCONTROLGROUPBG];
            self.isIRPackAvailable  = [decoder decodeBoolForKey:kISIRPACKAVAILABLE];
            self.bottomControlDevice  = (ControlDeviceType)[decoder decodeIntegerForKey:kBOTTOMCONTROLDEVICE] ;
           // self.isAuto_switch_mode = [decoder decodeBoolForKey:kAuto_Switch_Mode];
            self.OutputTypeInSelectedZone    = [decoder decodeIntegerForKey:kOutputTypeInSelectedZone];
            self.avr_id        = [decoder decodeIntegerForKey:kAVR];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
