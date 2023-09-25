//
//  Controls.m
//  mHubApp
//
//  Created by Rave Digital on 31/05/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "Controls.h"

@implementation Controls

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeObject:self.control_id forKey:kMACROID];
        [encoder encodeObject:self.control_name forKey:kMACRONAME];
        [encoder encodeObject:self.control_description forKey:kMACRODESCRIPTION];
        [encoder encodeObject:self.control_type forKey:kTYPE];
        [encoder encodeObject:self.device_type forKey:kDEVICE_TYPE];
        [encoder encodeObject:self.arrZoneIds forKey:kGROUPZONES];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            self.control_id = [decoder decodeObjectForKey:kMACROID];
            self.control_name = [decoder decodeObjectForKey:kMACRONAME];
            self.control_type = [decoder decodeObjectForKey:kTYPE];
            self.control_description = [decoder decodeObjectForKey:kMACRODESCRIPTION];
            self.device_type = [decoder decodeObjectForKey:kDEVICE_TYPE];
            self.arrZoneIds = [decoder decodeObjectForKey:kGROUPZONES];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

#pragma mark - GET Controls OBJECT
+(Controls *) getObjectFromDictionary:(NSDictionary*)dictResp {
    Controls *objReturn = [[Controls alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            NSString *strMacroId = [Utility checkNullForKey:kMACROID Dictionary:dictResp];
            if (![strMacroId isNotEmpty]) {
                strMacroId = [Utility checkNullForKey:kMACROID_V1 Dictionary:dictResp];
            }
            objReturn.control_id = strMacroId;

            NSString *strMacroName = [Utility checkNullForKey:kMACRONAME Dictionary:dictResp];
            if (![strMacroName isNotEmpty]) {
                strMacroName = [Utility checkNullForKey:kMACRONAME_V1 Dictionary:dictResp];
            }
            objReturn.control_name = strMacroName;

            NSString *strTypeName = [Utility checkNullForKey:kTYPE Dictionary:dictResp];
            if (![strTypeName isNotEmpty]) {
                strTypeName = [Utility checkNullForKey:kTYPE Dictionary:dictResp];
            }
            objReturn.control_type = strTypeName;

            id arrZones = [Utility checkNullForKey:kGROUPZONES Dictionary:dictResp];
            if ([arrZones isKindOfClass:[NSArray class]]) {
                objReturn.arrZoneIds = [[NSMutableArray alloc] initWithArray:arrZones];
            } else {
                objReturn.arrZoneIds = [[NSMutableArray alloc] init];
            }
            
            NSString *strDeviceType = [Utility checkNullForKey:kDEVICE_TYPE Dictionary:dictResp];
            if ([strDeviceType isNotEmpty]) {
                objReturn.device_type = [Utility checkNullForKey:kDEVICE_TYPE Dictionary:dictResp];
            }
            
            
        }
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
                Controls *objDevice = [Controls getObjectFromDictionary:dictResp];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


+(NSMutableArray*) getObjectV2Array:(NSMutableArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                Controls *objDevice = [Controls getObjectFromV2Dictionary:dictResp];
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
        //DDLogDebug(@"self.macro_id %@ and %@",self.macro_id,kMACROID);
        [dict setValue:self.control_id forKey:kMACROID];
        [dict setValue:self.control_name forKey:kMACRONAME];
        [dict setValue:self.control_description forKey:kMACRODESCRIPTION];
        [dict setValue:self.control_type forKey:kTYPE];
        [dict setValue:self.device_type forKey:kDEVICE_TYPE];
        [dict setValue:self.arrZoneIds forKey:kGROUPZONES];
        
        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*)getDictionaryArray:(NSMutableArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                Controls *objDevice = [arrResp objectAtIndex:i];
                NSDictionary *dictResp = [objDevice dictionaryRepresentation];
                [arrReturn addObject:dictResp];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(Controls*) getObjectFromV2Dictionary:(NSDictionary*)dictResp {
    Controls *objReturn = [[Controls alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.control_id = [Utility checkNullForKey:kMACROID Dictionary:dictResp];
            objReturn.control_name = [Utility checkNullForKey:kMACRONAME Dictionary:dictResp];
            objReturn.control_description = [Utility checkNullForKey:kMACRODESCRIPTION Dictionary:dictResp];
            objReturn.control_type = [Utility checkNullForKey:kTYPE Dictionary:dictResp];
            objReturn.device_type = [Utility checkNullForKey:kDEVICE_TYPE Dictionary:dictResp];
            objReturn.arrZoneIds = [Utility checkNullForKey:kGROUPZONES Dictionary:dictResp];
            
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}


@end
