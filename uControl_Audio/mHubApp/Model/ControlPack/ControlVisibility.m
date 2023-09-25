//
//  ControlVisibility.m
//  mHubApp
//
//  Created by Yashica Agrawal on 25/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ControlVisibility.h"

@implementation ControlVisibility 

-(id)init {
    self = [super init];
    @try {
        self.mobileSmall = true;
        self.mobileLarge = true;
        self.tabletSmall = true;
        self.tabletLarge = true;
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

+(ControlVisibility*) initWithControlVisibility_MobileSmall:(NSString*)strMobileSmall MobileLarge:(NSString*)strMobileLarge TabletSmall:(NSString*)strTabletSmall TabletLarge:(NSString*)strTabletLarge {
    ControlVisibility *objReturn=[[ControlVisibility alloc] init];
    @try {
        objReturn.mobileSmall = [Utility getBoolValue:strMobileSmall];
        objReturn.mobileLarge = [Utility getBoolValue:strMobileLarge];
        objReturn.tabletSmall = [Utility getBoolValue:strTabletSmall];
        objReturn.tabletLarge = [Utility getBoolValue:strTabletLarge];
    } @catch (NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return objReturn;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:[NSNumber numberWithBool:self.mobileSmall] forKey:kDeviceTypeMobileSmall];
        [encoder encodeObject:[NSNumber numberWithBool:self.mobileLarge] forKey:kDeviceTypeMobileLarge];
        [encoder encodeObject:[NSNumber numberWithBool:self.tabletSmall] forKey:kDeviceTypeTabletSmall];
        [encoder encodeObject:[NSNumber numberWithBool:self.tabletLarge] forKey:kDeviceTypeTabletLarge];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
                //decode properties, other class vars
            self.mobileSmall = [[decoder decodeObjectForKey:kDeviceTypeMobileSmall] boolValue];
            self.mobileLarge = [[decoder decodeObjectForKey:kDeviceTypeMobileLarge] boolValue];
            self.tabletSmall = [[decoder decodeObjectForKey:kDeviceTypeTabletSmall] boolValue];
            self.tabletLarge = [[decoder decodeObjectForKey:kDeviceTypeTabletLarge] boolValue];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

@end
