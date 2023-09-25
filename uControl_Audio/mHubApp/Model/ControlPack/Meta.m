//
//  Meta.m
//  mHubApp
//
//  Created by Yashica Agrawal on 24/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "Meta.h"

@implementation Meta
+(Meta*) getObjectFromDictionary:(NSDictionary*)dictResp {
    Meta *objReturn=[[Meta alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.deviceID = [Utility checkNullForKey:kCPMetaDeviceID Dictionary:dictResp];
            objReturn.version = [Utility checkNullForKey:kCPMetaVersion Dictionary:dictResp];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return objReturn;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:self.deviceID forKey:kCPMetaDeviceID];
        [encoder encodeObject:self.version forKey:kCPMetaVersion];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
                //decode properties, other class vars
            self.deviceID = [decoder decodeObjectForKey:kCPMetaDeviceID];
            self.version = [decoder decodeObjectForKey:kCPMetaVersion];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}


@end
