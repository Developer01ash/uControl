//
//  Grid.m
//  mHubApp
//
//  Created by Anshul Jain on 07/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "Grid.h"

@implementation Grid

-(id)init {
    self = [super init];
    @try {
        self.mobileSmall = [[GridDimension alloc] init];
        self.mobileLarge = [[GridDimension alloc] init];
        self.tabletSmall = [[GridDimension alloc] init];
        self.tabletLarge = [[GridDimension alloc] init];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

+(Grid*) initWithGrid {
    Grid *objReturn=[[Grid alloc] init];
    @try {
        objReturn.mobileSmall = [GridDimension initWithRows:5 Column:3];
        objReturn.mobileLarge = [GridDimension initWithRows:7 Column:4];
        objReturn.tabletSmall = [GridDimension initWithRows:7 Column:4];
        objReturn.tabletLarge = [GridDimension initWithRows:9 Column:7];
        objReturn.tabletLargeLandscape = [GridDimension initWithRows:9 Column:7];

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
        [encoder encodeObject:self.tabletLargeLandscape forKey:kDeviceTypeTabletLargeLandscape];
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
            self.tabletLargeLandscape = [decoder decodeObjectForKey:kDeviceTypeTabletLargeLandscape];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
