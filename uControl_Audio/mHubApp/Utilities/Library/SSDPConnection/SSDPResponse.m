//
//  SSDPResponse.m
//  mHubApp
//
//  Created by Anshul Jain on 01/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "SSDPResponse.h"

@implementation SSDPResponse
+(SSDPResponse*) initWithStatus:(SSDPConnectionStatus)status Response:(id)response {
    SSDPResponse *objReturn=[[SSDPResponse alloc] init];
    @try {
        if (status) {
            objReturn.status = status;
            objReturn.response = response;
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}
@end
