//
//  ControlVisibility.m
//  mHubApp
//
//  Created by Anshul Jain on 25/10/16.
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
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
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
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeBool:self.mobileSmall forKey:kDeviceTypeMobileSmall];
        [encoder encodeBool:self.mobileLarge forKey:kDeviceTypeMobileLarge];
        [encoder encodeBool:self.tabletSmall forKey:kDeviceTypeTabletSmall];
        [encoder encodeBool:self.tabletLarge forKey:kDeviceTypeTabletLarge];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.mobileSmall = [decoder decodeBoolForKey:kDeviceTypeMobileSmall];
            self.mobileLarge = [decoder decodeBoolForKey:kDeviceTypeMobileLarge];
            self.tabletSmall = [decoder decodeBoolForKey:kDeviceTypeTabletSmall];
            self.tabletLarge = [decoder decodeBoolForKey:kDeviceTypeTabletLarge];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
