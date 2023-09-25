//
//  APIResponse.m
//  mHubApp
//
//  Created by Anshul Jain on 21/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "APIResponse.h"

@implementation APIResponse

+(APIResponse*) getObjectFromDictionary:(NSDictionary*)dictResp {
    APIResponse *objReturn = [[APIResponse alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.error = [[Utility checkNullForKey:kERROR Dictionary:dictResp] boolValue];
            objReturn.response = [Utility checkNullForKey:kRESPONSE Dictionary:dictResp];
            objReturn.data = [Utility checkNullForKey:kDATA Dictionary:dictResp];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(APIResponse*) getObjectFromFile:(NSDictionary*)dictResp {
    APIResponse *objReturn = [[APIResponse alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.error = false;
            objReturn.response = dictResp;
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(APIResponse*) getExceptionalResponse:(NSException*)exception {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    APIResponse *objReturn = [[APIResponse alloc] init];
    objReturn.error = true;
    objReturn.response = [exception debugDescription];
    return objReturn;
}

+(APIResponse*) getErrorResponse:(NSError*)error {
    DDLogError(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, error);
    APIResponse *objReturn = [[APIResponse alloc] init];
    objReturn.error = true;
    objReturn.response = [error localizedDescription];
    return objReturn;
}

+(APIResponse*) getInternetNotAvailableResponse {
    DDLogError(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, ALERT_MESSAGE_INTERNETNOTAVAILABEL);
    APIResponse *objReturn = [[APIResponse alloc] init];
    objReturn.error = true;
    objReturn.response = ALERT_MESSAGE_INTERNETNOTAVAILABEL;
    return objReturn;
}

+(APIResponse*) getFileNotFoundResponse {
    DDLogError(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, ALERT_MESSAGE_INTERNETNOTAVAILABEL);
    APIResponse *objReturn = [[APIResponse alloc] init];
    objReturn.error = true;
    objReturn.response = ALERT_MESSAGE_FILENOTFOUND;
    return objReturn;
}

+(APIResponse*) getAPINotFoundResponse {
    DDLogError(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, ALERT_MESSAGE_INTERNETNOTAVAILABEL);
    APIResponse *objReturn = [[APIResponse alloc] init];
    objReturn.error = true;
    objReturn.response = ALERT_MESSAGE_APINOTFOUND;
    return objReturn;
}

@end

@implementation APIV2Response

+(APIV2Response*) getObjectFromDictionary:(NSDictionary*)dictResp {
    APIV2Response *objReturn = [[APIV2Response alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            id header = [Utility checkNullForKey:kHEADER Dictionary:dictResp];
            if ([header isKindOfClass:[NSDictionary class]]) {
                objReturn.version = [[Utility checkNullForKey:kVERSION Dictionary:header] floatValue];
                // objReturn.error = [[Utility checkNullForKey:kERROR Dictionary:header] boolValue];
            }

            id data = [Utility checkNullForKey:kDATA Dictionary:dictResp];
            if ([data isNotEmpty]) {
                objReturn.error = false;
                if ([data isKindOfClass:[NSDictionary class]]) {
                    if (objReturn.error) {
                        objReturn.error_description = [Utility checkNullForKey:kERROR_DESCRIPTION Dictionary:data];
                    } else {
                        objReturn.data_description = data; // [Utility checkNullForKey:kDATA_DESCRIPTION Dictionary:data];
                    }
                } else if ([data isKindOfClass:[NSArray class]]) {
                    objReturn.data_description = data; // [Utility checkNullForKey:kDATA_DESCRIPTION Dictionary:data];
                }
            } else {
                objReturn.error = true;
                id error = [Utility checkNullForKey:kERROR Dictionary:dictResp];
                if ([error isKindOfClass:[NSDictionary class]]) {
                    objReturn.error_description = [Utility checkNullForKey:kERROR_DESCRIPTION Dictionary:error];
                } else {
                    objReturn.error_description = error;
                }
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(APIV2Response*) getObjectFromFile:(NSDictionary*)dictResp {
    APIV2Response *objReturn = [[APIV2Response alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.error = false;
            objReturn.data_description = dictResp;
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(APIV2Response*) getExceptionalResponse:(NSException*)exception {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    APIV2Response *objReturn = [[APIV2Response alloc] init];
    objReturn.error = true;
    objReturn.error_description = [exception debugDescription];
    return objReturn;
}

+(APIV2Response*) getErrorResponse:(NSError*)error {
    DDLogError(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, error);
    APIV2Response *objReturn = [[APIV2Response alloc] init];
    objReturn.error = true;
    objReturn.error_description = [error localizedDescription];
    return objReturn;
}

+(APIV2Response*) getInternetNotAvailableResponse {
    DDLogError(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, ALERT_MESSAGE_INTERNETNOTAVAILABEL);
    APIV2Response *objReturn = [[APIV2Response alloc] init];
    objReturn.error = true;
    objReturn.error_description = ALERT_MESSAGE_INTERNETNOTAVAILABEL;
    return objReturn;
}

+(APIV2Response*) getFileNotFoundResponse {
    DDLogError(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, ALERT_MESSAGE_INTERNETNOTAVAILABEL);
    APIV2Response *objReturn = [[APIV2Response alloc] init];
    objReturn.error = true;
    objReturn.error_description = ALERT_MESSAGE_FILENOTFOUND;
    return objReturn;
}

+(APIV2Response*) getAPINotFoundResponse {
    DDLogError(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, ALERT_MESSAGE_INTERNETNOTAVAILABEL);
    APIV2Response *objReturn = [[APIV2Response alloc] init];
    objReturn.error = true;
    objReturn.error_description = ALERT_MESSAGE_APINOTFOUND;
    return objReturn;
}

+(APIV2Response*) getObjectFromAPIResponse:(APIResponse*)objResponse {
    APIV2Response *objReturn = [[APIV2Response alloc] init];
    @try {
        if ([objResponse isKindOfClass:[APIResponse class]]) {
            objReturn.error = objResponse.error;
            if (objReturn.error) {
                objReturn.error_description = objResponse.response;
            } else {
                objReturn.data_description = objResponse.response;
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

@end
