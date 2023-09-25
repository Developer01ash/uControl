//
//  ControlSize.m
//  mHubApp
//
//  Created by Yashica Agrawal on 03/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ControlSize.h"

@implementation ControlSize

-(id)init {
    self = [super init];
    @try {
        self.mobileSmall = [[SizeUI alloc] init];
        self.mobileLarge = [[SizeUI alloc] init];
        self.tabletSmall = [[SizeUI alloc] init];
        self.tabletLarge = [[SizeUI alloc] init];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

+(ControlSize*) initWithSize_Width:(NSDictionary*)dictWidth Height:(NSDictionary*)dictHeight {
    ControlSize *objReturn=[[ControlSize alloc] init];
    @try {
        objReturn.mobileSmall = [SizeUI initWithWidth:[Utility checkNullForKey:kDeviceTypeMobileSmall Dictionary:dictWidth] Height:[Utility checkNullForKey:kDeviceTypeMobileSmall Dictionary:dictHeight]];
        objReturn.mobileLarge = [SizeUI initWithWidth:[Utility checkNullForKey:kDeviceTypeMobileLarge Dictionary:dictWidth] Height:[Utility checkNullForKey:kDeviceTypeMobileLarge Dictionary:dictHeight]];
        objReturn.tabletSmall = [SizeUI initWithWidth:[Utility checkNullForKey:kDeviceTypeTabletSmall Dictionary:dictWidth] Height:[Utility checkNullForKey:kDeviceTypeTabletSmall Dictionary:dictHeight]];
        objReturn.tabletLarge = [SizeUI initWithWidth:[Utility checkNullForKey:kDeviceTypeTabletLarge Dictionary:dictWidth] Height:[Utility checkNullForKey:kDeviceTypeTabletLarge Dictionary:dictHeight]];
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
