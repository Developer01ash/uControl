//
//  ContinuityDevice.m
//  mHubApp
//
//  Created by Anshul Jain on 28/08/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "ContinuityDevice.h"

@implementation ContinuityDevice

+(ContinuityDevice*) getObjectFromDictionary:(NSDictionary*)dictResp {
    ContinuityDevice *objReturn=[[ContinuityDevice alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.Name = [dictResp valueForKey:kNAME];
            objReturn.CreatedName = [dictResp valueForKey:kCREATEDNAME];
            objReturn.Index = [[dictResp valueForKey:kINDEX] integerValue];
            objReturn.PortNo = [[dictResp valueForKey:kPORTNO] integerValue];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
    return objReturn;
}

+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if(arrResp != nil && arrResp.count > 0) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                ContinuityDevice *objDevice = [ContinuityDevice getObjectFromDictionary:dictResp];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
}


-(NSDictionary*) dictionaryRepresentation {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.Name forKey:kNAME];
        [dict setValue:self.CreatedName forKey:kCREATEDNAME];
        [dict setValue:[NSNumber numberWithInteger:self.Index] forKey:kINDEX];
        [dict setValue:[NSNumber numberWithInteger:self.PortNo] forKey:kPORTNO];
        return dict;
    } @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
}

+(NSMutableArray*)getDictionaryArray:(NSMutableArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                ContinuityDevice *objDevice = [arrResp objectAtIndex:i];
                NSDictionary *dictResp = [objDevice dictionaryRepresentation];
                [arrReturn addObject:dictResp];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeObject:self.Name forKey:kNAME];
        [encoder encodeObject:self.CreatedName forKey:kCREATEDNAME];
        [encoder encodeInteger:self.Index forKey:kINDEX];
        [encoder encodeInteger:self.PortNo forKey:kPORTNO];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            self.Name           = [decoder decodeObjectForKey:kNAME];
            self.CreatedName    = [decoder decodeObjectForKey:kCREATEDNAME];
            self.Index          = [decoder decodeIntegerForKey:kINDEX];
            self.PortNo         = [decoder decodeIntegerForKey:kPORTNO];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
    return self;
}

@end
