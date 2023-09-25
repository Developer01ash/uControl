//
//  ContinuityHub.m
//  mHubApp
//
//  Created by Anshul Jain on 28/08/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "ContinuityHub.h"
#import "ContinuityDevice.h"

@implementation ContinuityHub

-(id)init
{
    self = [super init];
    self.OutputCount = 0;
    self.InputCount = 0;
    
    self.HubInputData = [[NSMutableArray alloc] init];
    self.HubOutputData = [[NSMutableArray alloc] init];
    
    self.Name = @"";
    self.Mac = UNKNOWN_MAC;
    self.Address = UNKNOWN_IP;
    self.Generation = -1;
    self.BootFlag = 1;
    self.SerialNo = UNKNOWN_SERIALNO;
    self.modelName      = @"";

    self.apiVersion     = 1.0;
    self.mosVersion     = 0.0;
    self.strMOSVersion  = @"";

    self.AVR_IRPack     = false;
    self.isPaired       = false;

    return self;
}

+(ContinuityHub*) getObjectFromDictionary:(NSDictionary*)dictResp {
    ContinuityHub *objReturn=[[ContinuityHub alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.OutputCount = [[dictResp valueForKey:kOUTPUTCOUNT] integerValue];
            objReturn.InputCount = [[dictResp valueForKey:kINPUTCOUNT] integerValue];
            objReturn.Name = [dictResp valueForKey:kNAME];
            objReturn.Mac = [dictResp valueForKey:kMAC];
            objReturn.Address = [dictResp valueForKey:kADDRESS];
            objReturn.Generation = (HubModel)[[dictResp valueForKey:kGENERATION] integerValue];
            objReturn.modelName = [dictResp valueForKey:kMODELNAME];
            objReturn.BootFlag = [[dictResp valueForKey:kBOOTFLAG] boolValue];
            objReturn.SerialNo = [dictResp valueForKey:kSERIALNO];
            
            objReturn.HubInputData = [ContinuityDevice getObjectArray:[dictResp valueForKey:kHUBINPUTDATA]];
            objReturn.HubOutputData = [ContinuityDevice getObjectArray:[dictResp valueForKey:kHUBOUTPUTDATA]];

            float fltAPIVer = [[dictResp valueForKey:kAPIVERSION] floatValue];
            NSString *strMOSVer = [dictResp valueForKey:kMOSVERSION]; //@"7.01";

            objReturn.apiVersion = (fltAPIVer == 0 ? 1.0 : fltAPIVer);
            objReturn.strMOSVersion = strMOSVer;
            objReturn.mosVersion = [strMOSVer floatValue];

            objReturn.AVR_IRPack = [[dictResp valueForKey:kAVR_IRPACK] boolValue];
            objReturn.isPaired = [[dictResp valueForKey:kISPAIRED] boolValue];

        }
    } @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
    return objReturn;
}

-(NSDictionary*) dictionaryRepresentation {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSNumber numberWithInteger:self.OutputCount] forKey:kOUTPUTCOUNT];
        [dict setValue:[NSNumber numberWithInteger:self.InputCount] forKey:kINPUTCOUNT];
        [dict setValue:[ContinuityDevice getDictionaryArray:self.HubOutputData] forKey:kHUBOUTPUTDATA];
        [dict setValue:[ContinuityDevice getDictionaryArray:self.HubInputData] forKey:kHUBINPUTDATA];
        [dict setValue:self.Name forKey:kNAME];
        [dict setValue:self.Mac forKey:kMAC];
        [dict setValue:self.Address forKey:kADDRESS];
        [dict setValue:[NSNumber numberWithInteger:self.Generation] forKey:kGENERATION];
        [dict setValue:self.modelName forKey:kMODELNAME];
        [dict setValue:[NSNumber numberWithBool:self.BootFlag] forKey:kBOOTFLAG];
        [dict setValue:self.SerialNo forKey:kSERIALNO];
        [dict setValue:[NSNumber numberWithFloat:self.apiVersion] forKey:kAPIVERSION];
        [dict setValue:[NSNumber numberWithFloat:self.mosVersion] forKey:kMOSVERSION];
        [dict setValue:self.strMOSVersion forKey:kSTRMOSVERSION];
        [dict setValue:[NSNumber numberWithBool:self.AVR_IRPack] forKey:kAVR_IRPACK];
        [dict setValue:[NSNumber numberWithBool:self.isPaired] forKey:kISPAIRED];

        return dict;
    } @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeInteger:self.OutputCount forKey:kOUTPUTCOUNT];
        [encoder encodeInteger:self.InputCount forKey:kINPUTCOUNT];
        [encoder encodeObject:self.HubOutputData forKey:kHUBOUTPUTDATA];
        [encoder encodeObject:self.HubInputData forKey:kHUBINPUTDATA];
        [encoder encodeObject:self.Name forKey:kNAME];
        [encoder encodeObject:self.Mac forKey:kMAC];
        [encoder encodeObject:self.Address forKey:kADDRESS];
        [encoder encodeInteger:self.Generation forKey:kGENERATION];
        [encoder encodeObject:self.modelName forKey:kMODELNAME];
        [encoder encodeBool:self.BootFlag forKey:kBOOTFLAG];
        [encoder encodeObject:self.SerialNo forKey:kSERIALNO];

        [encoder encodeFloat:self.apiVersion forKey:kAPIVERSION];
        [encoder encodeFloat:self.mosVersion forKey:kMOSVERSION];
        [encoder encodeObject:self.strMOSVersion forKey:kSTRMOSVERSION];
        [encoder encodeBool:self.AVR_IRPack forKey:kAVR_IRPACK];
        [encoder encodeBool:self.isPaired forKey:kISPAIRED];

    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            self.OutputCount    = [decoder decodeIntegerForKey:kOUTPUTCOUNT];
            self.InputCount     = [decoder decodeIntegerForKey:kINPUTCOUNT];
            
            self.HubInputData   = [decoder decodeObjectForKey:kHUBINPUTDATA];
            self.HubOutputData  = [decoder decodeObjectForKey:kHUBOUTPUTDATA];
            
            self.Name           = [decoder decodeObjectForKey:kNAME];
            self.Mac            = [decoder decodeObjectForKey:kMAC];
            self.Address        = [decoder decodeObjectForKey:kADDRESS];
            self.Generation     = (HubModel)[decoder decodeIntegerForKey:kGENERATION];
            self.modelName      = [decoder decodeObjectForKey:kMODELNAME];
            self.BootFlag       = [decoder decodeBoolForKey:kBOOTFLAG];
            self.SerialNo       = [decoder decodeObjectForKey:kSERIALNO];

            self.apiVersion     = [decoder decodeFloatForKey:kAPIVERSION];
            self.AVR_IRPack     = [decoder decodeBoolForKey:kAVR_IRPACK];

            self.mosVersion     = [decoder decodeFloatForKey:kMOSVERSION];
            self.strMOSVersion  = [[decoder decodeObjectForKey:kSTRMOSVERSION] isNotEmpty] ? [decoder decodeObjectForKey:kSTRMOSVERSION] : [NSString stringWithFormat:@"%.02f", self.mosVersion];
            self.isPaired       = [decoder decodeBoolForKey:kUSERINFO];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
    return self;
}

-(BOOL) isAPIV2 {
    @try {
        BOOL isReturn = false;
        if (self.apiVersion >= 2.0) {
            isReturn = true;
        }
        return isReturn;
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
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
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
}

@end
