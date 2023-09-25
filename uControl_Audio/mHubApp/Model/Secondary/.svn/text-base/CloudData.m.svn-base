//
//  CloudData.m
//  mHubApp
//
//  Created by Anshul Jain on 26/04/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "CloudData.h"

@implementation CloudData

+(CloudData*) getObjectFromDictionary:(NSDictionary*)dictResp {
    CloudData *objReturn=[[CloudData alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.strSerialNo = [Utility checkNullForKey:kSerial_Number Dictionary:dictResp];
            objReturn.strMHubName = [Utility checkNullForKey:kMHUB_Name Dictionary:dictResp];
            
            
            if ([objReturn.strMHubName isContainString:kDEVICEMODEL_MHUB4K431] || [objReturn.strMHubName isContainString:[Hub getmHub4KV3Name:MHUB4K431]] || [objReturn.strMHubName isContainString:[Hub getHubName:mHub4KV3]]) {
                objReturn.imgMHub = kDEVICEMODEL_IMAGE_MHUB4K431;
            } else if ([objReturn.strMHubName isContainString:kDEVICEMODEL_MHUB4K862] || [objReturn.strMHubName isContainString:[Hub getmHub4KV3Name:MHUB4K862]] || [objReturn.strMHubName isContainString:[Hub getHubName:mHub4KV3]]) {
                objReturn.imgMHub = kDEVICEMODEL_IMAGE_MHUB4K862;
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(NSMutableArray*) getObjectArray:(NSArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if ([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                CloudData *objDevice = [CloudData getObjectFromDictionary:dictResp];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:self.strSerialNo forKey:kSerial_Number];
        [encoder encodeObject:self.strMHubName forKey:kMHUB_Name];
        [encoder encodeObject:self.imgMHub forKey:kMhub_Image];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.strSerialNo = [decoder decodeObjectForKey:kSerial_Number];
            self.strMHubName = [decoder decodeObjectForKey:kMHUB_Name];
            self.imgMHub = [decoder decodeObjectForKey:kMhub_Image];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
