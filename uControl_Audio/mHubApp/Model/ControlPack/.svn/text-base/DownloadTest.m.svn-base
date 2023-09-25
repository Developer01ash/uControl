//
//  DownloadTest.m
//  mHubApp
//
//  Created by Yashica Agrawal on 24/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "DownloadTest.h"

@implementation DownloadTest
+(DownloadTest*) getObjectFromDictionary:(NSDictionary*)dictResp {
    DownloadTest *objReturn=[[DownloadTest alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.test_id = [Utility checkNullForKey:kCPDTTestId Dictionary:dictResp];
            objReturn.test_label = [Utility checkNullForKey:kCPDTLabel Dictionary:dictResp];
            objReturn.test_description = [Utility checkNullForKey:kCPDTDescription Dictionary:dictResp];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return objReturn;
}

+(NSMutableArray*) getObjectArray:(NSArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                DownloadTest *objDevice = [DownloadTest getObjectFromDictionary:dictResp];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:self.test_id forKey:kCPDTTestId];
        [encoder encodeObject:self.test_label forKey:kCPDTLabel];
        [encoder encodeObject:self.test_description forKey:kCPDTDescription];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
                //decode properties, other class vars
            self.test_id = [decoder decodeObjectForKey:kCPDTTestId];
            self.test_label = [decoder decodeObjectForKey:kCPDTLabel];
            self.test_description = [decoder decodeObjectForKey:kCPDTDescription];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

@end
