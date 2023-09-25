//
//  ControlLocation.m
//  mHubApp
//
//  Created by Anshul Jain on 25/10/16.
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
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

+(ControlLocation*) initWithLocation:(NSDictionary *)dictLocation {
    ControlLocation *objReturn=[[ControlLocation alloc] init];
    @try {
        if ([dictLocation isKindOfClass:[NSDictionary class]]) {
            objReturn.mobileSmall = [Location getObjectFromString:[Utility checkNullForKey:kDeviceTypeMobileSmall Dictionary:dictLocation]];
            objReturn.mobileLarge = [Location getObjectFromString:[Utility checkNullForKey:kDeviceTypeMobileLarge Dictionary:dictLocation]];
            objReturn.tabletSmall = [Location getObjectFromString:[Utility checkNullForKey:kDeviceTypeTabletSmall Dictionary:dictLocation]];
            objReturn.tabletLarge = [Location getObjectFromString:[Utility checkNullForKey:kDeviceTypeTabletLarge Dictionary:dictLocation]];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:self.mobileSmall forKey:kDeviceTypeMobileSmall];
        [encoder encodeObject:self.mobileLarge forKey:kDeviceTypeMobileLarge];
        [encoder encodeObject:self.tabletSmall forKey:kDeviceTypeTabletSmall];
        [encoder encodeObject:self.tabletLarge forKey:kDeviceTypeTabletLarge];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.mobileSmall = [decoder decodeObjectForKey:kDeviceTypeMobileSmall];
            self.mobileLarge = [decoder decodeObjectForKey:kDeviceTypeMobileLarge];
            self.tabletSmall = [decoder decodeObjectForKey:kDeviceTypeTabletSmall];
            self.tabletLarge = [decoder decodeObjectForKey:kDeviceTypeTabletLarge];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
