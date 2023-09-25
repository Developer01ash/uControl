//
//  ControlLocation.m
//  mHubApp
//
//  Created by Yashica Agrawal on 25/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ControlLocation.h"

@implementation ControlLocation

-(id)init {
    self = [super init];
    @try {
        self.mobileSmall = [Location getObjectFromString:@""];
        self.mobileLarge = [Location getObjectFromString:@""];
        self.tabletSmall = [Location getObjectFromString:@""];
        self.tabletLarge = [Location getObjectFromString:@""];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

+(ControlLocation*) initWithLocation:(NSDictionary *)dictLocation {
    ControlLocation *objReturn=[[ControlLocation alloc] init];
    @try {
        objReturn.mobileSmall = [Location getObjectFromString:[Utility checkNullForKey:kDeviceTypeMobileSmall Dictionary:dictLocation]];
        objReturn.mobileLarge = [Location getObjectFromString:[Utility checkNullForKey:kDeviceTypeMobileLarge Dictionary:dictLocation]];
        objReturn.tabletSmall = [Location getObjectFromString:[Utility checkNullForKey:kDeviceTypeTabletSmall Dictionary:dictLocation]];
        objReturn.tabletLarge = [Location getObjectFromString:[Utility checkNullForKey:kDeviceTypeTabletLarge Dictionary:dictLocation]];
    } @catch (NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return objReturn;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:self.mobileSmall forKey:kDeviceTypeMobileSmall];
        [encoder encodeObject:self.mobileLarge forKey:kDeviceTypeMobileLarge];
        [encoder encodeObject:self.tabletSmall forKey:kDeviceTypeTabletSmall];
        [encoder encodeObject:self.tabletLarge forKey:kDeviceTypeTabletLarge];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
                //decode properties, other class vars
            self.mobileSmall = [decoder decodeObjectForKey:kDeviceTypeMobileSmall];
            self.mobileLarge = [decoder decodeObjectForKey:kDeviceTypeMobileLarge];
            self.tabletSmall = [decoder decodeObjectForKey:kDeviceTypeTabletSmall];
            self.tabletLarge = [decoder decodeObjectForKey:kDeviceTypeTabletLarge];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

@end
