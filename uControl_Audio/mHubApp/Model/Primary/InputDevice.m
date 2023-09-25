//
//  InputDevice.m
//  mHubApp
//
//  Created by Anshul Jain on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/*
 Input Device contains basic details of the Input i.e. Source device like UnitId, Index, PortNo., Name, IRPack(objCommandType), Continuity detail, etc.
 */

#import "InputDevice.h"

@implementation InputDevice

#pragma mark - GET INPUT OBJECT
+(InputDevice*) getObjectFromDictionary:(NSDictionary*)dictResp Hub:(Hub*)objHub {
    InputDevice *objReturn=[[InputDevice alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.Name = [Utility checkNullForKey:kNAME Dictionary:dictResp];
            objReturn.CreatedName = [Utility checkNullForKey:kCREATEDNAME Dictionary:dictResp];
            objReturn.Index = [[Utility checkNullForKey:kINDEX Dictionary:dictResp] integerValue];
            
            
            if ([objReturn.Name isEqualToString:@""]) {
                objReturn.Name = [NSString stringWithFormat:@"Input %ld", (long)objReturn.Index];
            }

            if (![objReturn.CreatedName isNotEmpty]) {
                objReturn.CreatedName = objReturn.Name;
            }
            if([[Utility checkNullForKey:kIRMAP Dictionary:dictResp] isNotEmpty]){
                objReturn.PortNo = [[Utility checkNullForKey:kIRMAP Dictionary:dictResp] integerValue];
            }
            else{
            objReturn.PortNo = objReturn.Index;
            }
            objReturn.irmapId = [[Utility checkNullForKey:kIRMAP Dictionary:dictResp] integerValue];
           // objReturn.isDeleted = true;

            if ([objHub isUControlSupport]) {
                if ([objHub isAPIV2]) {
                    [APIManager fileIRPackXML_Hub:objHub PortId:objReturn.PortNo completion:^(APIV2Response *responseObject) {
                        if (responseObject.error) {
                            objReturn.sourceType = Uncontrollable;
                            objReturn.objCommandType = [[CommandType alloc]init];
                            objReturn.arrContinuity = [[NSMutableArray alloc] init];
                        } else {
                            XMLResponse *objXML = [XMLResponse getObjectFromDictionary:responseObject.data_description CDeviceType:InputSource];
                            objReturn.sourceType = InputSource;
                            objReturn.objCommandType = [CommandType getObjectForInput_fromArray:objXML.controlPack.appUI];
                            objReturn.arrContinuity = [[NSMutableArray alloc] initWithArray:objXML.controlPack.continuity];
                        }
                        [CommandType saveCustomObject:objReturn.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objReturn.PortNo]];
                        [ContinuityCommand saveCustomObject:objReturn.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objReturn.PortNo]];
                    }];
                } else {
                    [APIManager getInputIREngineStatus:objReturn.PortNo completion:^(APIResponse *responseObject) {
                        if (responseObject.error) {
                            objReturn.sourceType = Uncontrollable;
                            objReturn.objCommandType = [[CommandType alloc]init];
                            objReturn.arrContinuity = [[NSMutableArray alloc] init];
                        } else {
                            objReturn.sourceType = InputSource;

                            ControlPack *objControlPack = [ControlPack getObjectFromDictionary:responseObject.response];
                            objReturn.objCommandType = [CommandType getObjectForInput_fromArray:objControlPack.appUI];
                            objReturn.arrContinuity = [[NSMutableArray alloc] initWithArray:objControlPack.continuity];
                        }
                        [CommandType saveCustomObject:objReturn.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objReturn.PortNo]];
                        [ContinuityCommand saveCustomObject:objReturn.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objReturn.PortNo]];
                    }];
                }
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(InputDevice*) getInputObjectFromIndex:(NSInteger)intIndex {
    InputDevice *objReturn=[[InputDevice alloc] init];
    @try {
        objReturn.Index = intIndex;
        objReturn.Name = [NSString stringWithFormat:@"Input %ld", (long)intIndex];
        objReturn.CreatedName = @"";
        if (![objReturn.CreatedName isNotEmpty]) {
            objReturn.CreatedName = objReturn.Name;
        }
        objReturn.PortNo = objReturn.Index;
       // objReturn.isDeleted = false;
        objReturn.sourceType = Uncontrollable;
        objReturn.objCommandType = [[CommandType alloc]init];
        objReturn.arrContinuity = [[NSMutableArray alloc] init];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(InputDevice*) getTempInputObjectFromIndex:(NSInteger)intIndex Hub:(Hub*)objHub {
    InputDevice *objReturn=[[InputDevice alloc] init];
    @try {
        objReturn.UnitId = objHub.UnitId;
        objReturn.Index = intIndex;
        switch (intIndex) {
            case 1:
                objReturn.Name = @"PRO (OUTPUT A)";
                break;
            case 2:
                objReturn.Name = @"PRO (OUTPUT B)";
                break;
            case 3:
                objReturn.Name = @"Chromecast";
                break;
            default:
                objReturn.Name = [NSString stringWithFormat:@"Input %ld", (long)intIndex];
                break;
        }

        objReturn.CreatedName = @"";
        if (![objReturn.CreatedName isNotEmpty]) {
            objReturn.CreatedName = objReturn.Name;
        }
        objReturn.PortNo = objReturn.Index;
       // objReturn.isDeleted = false;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(InputDevice*) getObjectFromJSON_Key:(NSString*)strKey Value:(NSString*)strValue {
    InputDevice *objReturn = [[InputDevice alloc] init];
    @try {
        objReturn.Name = strValue;
        objReturn.Index = [strKey integerValue];

        if ([objReturn.Name isEqualToString:@""]) {
            objReturn.Name = [NSString stringWithFormat:@"Input %ld", (long)objReturn.Index];
        }
        if (![objReturn.CreatedName isNotEmpty]) {
            objReturn.CreatedName = objReturn.Name;
        }
        objReturn.PortNo = objReturn.Index;
     //   objReturn.isDeleted = true;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(InputDevice*) getObjectFromSystemDictionary:(NSDictionary*)dictResp Hub:(Hub*)objHub {
    InputDevice *objReturn=[[InputDevice alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.UnitId = objHub.UnitId;
            objReturn.Index = [[Utility checkNullForKey:kLABELID Dictionary:dictResp] integerValue];
            objReturn.Name = [Utility checkNullForKey:kLABEL Dictionary:dictResp];
            
            if([[Utility checkNullForKey:kSHOW Dictionary:dictResp] isNotEmpty]){
            objReturn.isDeleted = [[Utility checkNullForKey:kSHOW Dictionary:dictResp] boolValue];
            }
            else
            {
                if([objHub isZPSetup] || objHub.Generation ==  mHubS){
                    objReturn.isDeleted = false;
                }
                else{
                objReturn.isDeleted = true;
                }
            }
             //NSLog(@"label name value %@ %d",objReturn.Name,objReturn.isDeleted);
            if ([objReturn.Name isEqualToString:@""]) {
                objReturn.Name = [NSString stringWithFormat:@"Input %ld", (long)objReturn.Index];
            }
            if (![objReturn.CreatedName isNotEmpty]) {
                objReturn.CreatedName = objReturn.Name;
            }
            //objReturn.PortNo = objReturn.Index;
            if([[Utility checkNullForKey:kIRMAP Dictionary:dictResp] isNotEmpty]){
                objReturn.PortNo = [[Utility checkNullForKey:kIRMAP Dictionary:dictResp] integerValue];
            }
            else{
            objReturn.PortNo = objReturn.Index;
            }
            objReturn.irmapId = [[Utility checkNullForKey:kIRMAP Dictionary:dictResp] integerValue];
           // objReturn.isDeleted = false;
            //NSLog(@"label name value %@",objReturn.Name);

            // Get casheIRPack from UserDefaults.
            id cacheCommandData = [CommandType retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objReturn.PortNo]];
            if ([cacheCommandData isNotEmpty]) {
                if ([cacheCommandData isKindOfClass:[CommandType class]]) {
                    objReturn.objCommandType = cacheCommandData;
                } else {
                    objReturn.objCommandType = [[CommandType alloc]init];
                }
                id cacheContinuityData = [ContinuityCommand retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objReturn.PortNo]];
                if ([cacheContinuityData isNotEmpty] && [cacheContinuityData isKindOfClass:[NSMutableArray class]]) {
                    objReturn.arrContinuity = cacheContinuityData;
                } else {
                    objReturn.arrContinuity = [[NSMutableArray alloc] init];
                }
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(InputDevice*) getIRPackStatusFromDictionary:(NSDictionary*)dictResp {
    InputDevice *objReturn = [[InputDevice alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.Index = [[Utility checkNullForKey:kLABELID Dictionary:dictResp] integerValue];
            objReturn.isIRPack = [[Utility checkNullForKey:kIRPACK Dictionary:dictResp] boolValue];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - GET INPUT OBJECT ARRAY
+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp Hub:(Hub*)objHub {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                InputDevice *objDevice = [InputDevice getObjectFromDictionary:dictResp Hub:(Hub*)objHub];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getInputObjectArrayFromIndex:(NSInteger)InputCount {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        for (int i = 1; i <= InputCount; i++) {
            InputDevice *objDevice = [InputDevice getInputObjectFromIndex:i];
            [arrReturn addObject:objDevice];
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getTempInputObjectArray:(NSInteger)InputCount Hub:(Hub*)objHub {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        for (int i = 1; i <= InputCount; i++) {
            InputDevice *objDevice = [InputDevice getTempInputObjectFromIndex:i Hub:objHub];
            [arrReturn addObject:objDevice];
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}



+(NSMutableArray*) getObjectArrayJSON:(NSDictionary*)dictResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];

        for (NSString* key in dictResp) {
            NSString *strValue = [Utility checkNullForKey:key Dictionary:dictResp];
            InputDevice *objDevice = [InputDevice getObjectFromJSON_Key:key Value:strValue];
            [arrReturn addObject:objDevice];
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getObjectArraySystem:(NSMutableArray*)arrResp Hub:(Hub*)objHub mainRootDictionary:(NSDictionary *)mainDictResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
//        NSLog(@"mainRootDictionary input audio or video %@ and bolol %d",mainDictResp,[[Utility checkNullForKey:@"label_editable" Dictionary:mainDictResp] boolValue]);
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                InputDevice *objDevice = [InputDevice getObjectFromSystemDictionary:dictResp Hub:(Hub*)objHub];

                // To check whether we need to show ARC devices or not, we need to save type of the inputs with all input devices.
                objDevice.inputType = [Utility checkNullForKey:kTYPE Dictionary:mainDictResp];
                
//                if([objDevice.inputType isEqualToString:@"hdbaset arc" ])
//                {
//                    if([objHub isZPSetup] || objHub.Generation ==  mHubS || [objHub.UnitId containsString:@"S"] ){//For new devices like zp and mhubs, its value is changed as per older scenerio.
//                        objDevice.isDeleted = false;
//                    }
//                    else{
//                        objDevice.isDeleted = true;
//                    }
//                    //objDevice.isDeleted = true;
//                }
//                else if([objDevice.inputType isEqualToString:@"hdmi arc" ] || [objDevice.inputType isEqualToString:@"optical" ] || [objDevice.inputType isEqualToString:@"stereo jack" ] || [objDevice.inputType isEqualToString:@"coaxial" ] ||  [objDevice.inputType isEqualToString:@"multiport" ] )
//                {
//                    if([objHub isZPSetup] || objHub.Generation ==  mHubS || [objHub.UnitId containsString:@"S"] ){
//                        objDevice.isDeleted = false;
//                    }
//                    else{
//                        objDevice.isDeleted = true;
//                    }
//                   // objDevice.isDeleted = true;
//                }
//                

                // Changes from pro2 devices, IF kLABEL_EDITABLE is false means user can not change input names and thats why we are making it based on different parameters below.
                if([[Utility checkNullForKey:kLABEL_EDITABLE Dictionary:mainDictResp]isNotEmpty ] )
                {
                    NSString *str = [Utility checkNullForKey:@"label" Dictionary:mainDictResp];
                    str =  [str lowercaseString];
                    //NSLog(@"mainRootDictionary str %@ %d",str,[[Utility checkNullForKey:kLABEL_EDITABLE Dictionary:mainDictResp] boolValue]);
                    BOOL flag = true;
                    if([str containsString:@"video"])
                    {
                        flag = false;
                    }
                    if([str containsString:@"hdbaset"])
                    {
                        flag = true;
                    }
                    if([str containsString:@"hdmi"])
                    {
                        flag = true;
                    }

                    if(![[Utility checkNullForKey:kLABEL_EDITABLE Dictionary:mainDictResp] boolValue] )
                    {
                        NSString *newLabelName = [NSString stringWithFormat:@"%@ %@ %@ %@",[Utility checkNullForKey:@"label" Dictionary:mainDictResp],[Utility checkNullForKey:kSTART_LABEL_PREFIX Dictionary:mainDictResp],[Utility integerToCharacter:i+1],[Utility checkNullForKey:kSTART_LABEL_SUFFIX Dictionary:mainDictResp] ];
                        objDevice.Name = newLabelName;
                        objDevice.CreatedName = newLabelName;//[Utility checkNullForKey:kLABEL Dictionary:dictResp];
                        //NSLog(@"mainRootDictionary newLabelName %@ %ld %lu ",newLabelName,(long)objDevice.Index,(unsigned long)objDevice.sourceType);
                    }
                }
                else
                {
                    //The names are editable and don't need to make them by code.
                    objDevice.Name = objDevice.Name;
                    objDevice.CreatedName = objDevice.CreatedName;
                }
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getIRPackStatusArray:(NSMutableArray*)arrResp InputArray:(NSMutableArray*)arrInput {
    @try {
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                InputDevice *objDevice = [InputDevice getIRPackStatusFromDictionary:dictResp ];
                for (InputDevice *objIP in arrInput) {
                    if (objIP.Index == objDevice.Index) {
                        objIP.isIRPack = objDevice.isIRPack;
                        break;

                    }
                }
            }
        }
        return arrInput;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - DICTIONARY FORMAT
-(NSDictionary*) dictionaryRepresentation {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.Name forKey:kNAME];
        [dict setValue:self.CreatedName forKey:kCREATEDNAME];
        [dict setValue:[NSNumber numberWithInteger:self.Index] forKey:kINDEX];
        [dict setValue:[NSNumber numberWithInteger:self.PortNo] forKey:kPORTNO];
        [dict setValue:[NSNumber numberWithBool:self.isDeleted] forKey:kISDELETED];
         [dict setValue:[NSNumber numberWithBool:self.isShow] forKey:kISSHOW];
        [dict setValue:[NSNumber numberWithBool:self.isIRPack] forKey:kISIRPACK];
        [dict setValue:[NSNumber numberWithInteger:self.irmapId] forKey:kIRMAP];


        [dict setValue:self.objCommandType forKey:kCOMMANDOBJECT];
        [dict setValue:self.arrContinuity forKey:kCONTINUITYARRAY];
        [dict setValue:[NSNumber numberWithInteger:self.sourceType] forKey:kSOURCETYPE];
        [dict setValue:self.inputType forKey:kTYPE];


        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(NSDictionary*) dictionaryServerRepresentation {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.Name forKey:kNAME];
        [dict setValue:self.CreatedName forKey:kCREATEDNAME];
        [dict setValue:[NSNumber numberWithInteger:self.Index] forKey:kINDEX];
        [dict setValue:[NSNumber numberWithInteger:self.PortNo] forKey:kPORTNO];
        [dict setValue:self.inputType forKey:kTYPE];
        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(void)updateNamesOfInputs:(InputDevice *)objFrom To:(InputDevice *)objTo
{
    if(objFrom.Index == objTo.Index)
    {
        objFrom.Name = objTo.Name;
        objFrom.CreatedName = objTo.CreatedName;
    }
}

+(NSMutableArray*)getDictionaryArray:(NSMutableArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                InputDevice *objDevice = [arrResp objectAtIndex:i];
                NSDictionary *dictResp = [objDevice dictionaryServerRepresentation];
                [arrReturn addObject:dictResp];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - GET FILTERED OBJECT
+(InputDevice*)getFilteredInputDeviceData:(NSInteger)Index InputData:(NSMutableArray*)arrInputData {
    @try {
        NSPredicate *predicate;
//        if([mHubManagerInstance.objSelectedHub isZPSetup]){
//            predicate = [NSPredicate predicateWithFormat:@"PortNo = %@", [NSNumber numberWithInteger:Index]];
//        }
//        else
//        {
            predicate = [NSPredicate predicateWithFormat:@"Index = %@", [NSNumber numberWithInteger:Index]];
       // }
        NSArray *arrOPFiltered = [arrInputData filteredArrayUsingPredicate:predicate];
        InputDevice *objReturn = nil;
        objReturn =  arrOPFiltered.count > 0 ? arrOPFiltered.firstObject : nil;
        return objReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(InputDevice*)getFilteredInputDeviceWithCommandData:(NSInteger)Index Hub:(Hub *)objHub {
    @try {
        InputDevice *objReturn = [[InputDevice alloc] init];

        for (InputDevice *objIPTemp in objHub.HubInputData) {
            if (Index == objIPTemp.Index) {
                if (objIPTemp.isIRPack == true) {
                    id cacheCommandData = [CommandType retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objIPTemp.PortNo]];
                    if ([cacheCommandData isNotEmpty]) {
                        if ([cacheCommandData isKindOfClass:[CommandType class]]) {
                            objIPTemp.objCommandType = cacheCommandData;
                        } else {
                            objIPTemp.objCommandType = [[CommandType alloc]init];
                        }

                        id cacheContinuityData = [ContinuityCommand retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objIPTemp.PortNo]];
                        if ([cacheContinuityData isNotEmpty] && [cacheContinuityData isKindOfClass:[NSMutableArray class]]) {
                            objIPTemp.arrContinuity = cacheContinuityData;
                        } else {
                            objIPTemp.arrContinuity = [[NSMutableArray alloc] init];
                        }
                    } else {
                        [APIManager fileIRPackXML_Hub:objHub PortId:objIPTemp.PortNo completion:^(APIV2Response *responseObject) {
                            if (responseObject.error) {
                                objIPTemp.sourceType = Uncontrollable;
                                objIPTemp.objCommandType = [[CommandType alloc]init];
                                objIPTemp.arrContinuity = [[NSMutableArray alloc] init];
                            } else {
                                XMLResponse *objXML = [XMLResponse getObjectFromDictionary:responseObject.data_description CDeviceType:InputSource];
                                objIPTemp.sourceType = InputSource;
                                objIPTemp.objCommandType = [CommandType getObjectForInput_fromArray:objXML.controlPack.appUI];
                                objIPTemp.arrContinuity = [[NSMutableArray alloc] initWithArray:objXML.controlPack.continuity];
                            }
                            [CommandType saveCustomObject:objIPTemp.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objIPTemp.PortNo]];
                            [ContinuityCommand saveCustomObject:objIPTemp.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objIPTemp.PortNo]];
                        }];
                    }
                }
                objReturn = objIPTemp;
                break;
            }
        }
        return objReturn;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeObject:self.UnitId forKey:kUNIT_ID];
        [encoder encodeObject:self.Name forKey:kNAME];
        [encoder encodeObject:self.CreatedName forKey:kCREATEDNAME];
        [encoder encodeInteger:self.Index forKey:kINDEX];
        [encoder encodeInteger:self.PortNo forKey:kPORTNO];
        [encoder encodeBool:self.isDeleted forKey:kISDELETED];
        [encoder encodeBool:self.isShow forKey:kISSHOW];
        [encoder encodeBool:self.isIRPack forKey:kISIRPACK];
        [encoder encodeObject:self.objCommandType forKey:kCOMMANDOBJECT];
        [encoder encodeObject:self.arrContinuity forKey:kCONTINUITYARRAY];
        [encoder encodeInteger:self.sourceType forKey:kSOURCETYPE];
        [encoder encodeObject:self.inputType forKey:kTYPE];
        [encoder encodeInteger:self.irmapId forKey:kIRMAP];


    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            self.UnitId         = [decoder decodeObjectForKey:kUNIT_ID];
            self.Name           = [decoder decodeObjectForKey:kNAME];
            self.CreatedName    = [decoder decodeObjectForKey:kCREATEDNAME];
            @try {
                self.Index      = [decoder decodeIntegerForKey:kINDEX];
                self.PortNo     = [decoder decodeIntegerForKey:kPORTNO];
                self.irmapId     = [decoder decodeIntegerForKey:kIRMAP];
                self.inputType    = [decoder decodeObjectForKey:kTYPE];
                self.sourceType = (ControlDeviceType)[decoder decodeIntegerForKey:kSOURCETYPE];
            } @catch(NSException *exception) {
                self.Index      = [[decoder decodeObjectForKey:kINDEX] integerValue];
                self.PortNo     = [[decoder decodeObjectForKey:kPORTNO] integerValue];
                self.inputType    = [decoder decodeObjectForKey:kTYPE];
                self.sourceType = (ControlDeviceType)[[decoder decodeObjectForKey:kSOURCETYPE] integerValue];
            }
            self.isDeleted      = [decoder decodeBoolForKey:kISDELETED];
            self.isShow         = [decoder decodeBoolForKey:kISSHOW];
            self.isIRPack       = [decoder decodeBoolForKey:kISIRPACK];

            self.objCommandType = [decoder decodeObjectForKey:kCOMMANDOBJECT];
            self.arrContinuity  = [decoder decodeObjectForKey:kCONTINUITYARRAY];

        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
