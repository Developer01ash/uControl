//
//  Location.m
//  mHubApp
//
//  Created by Anshul Jain on 25/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "Location.h"

@implementation Location
+(Location*) getObjectFromString:(NSString*)strResp {
    Location *objReturn=[[Location alloc] init];
    @try {
        if ([strResp isNotEmpty] && [strResp isKindOfClass:[NSString class]]) {
            NSArray *strings = [strResp componentsSeparatedByString:@","];
            
            if (strings.count > 3) {
                if ([strings objectAtIndex:1]) {
                    objReturn.locationY = [[strings objectAtIndex:1] integerValue];
                } else {
                    objReturn.locationY = 0;
                }
                
                if ([strings objectAtIndex:0]) {
                    objReturn.locationX = [[strings objectAtIndex:0] integerValue];
                } else {
                    objReturn.locationX = 0;
                }

                if ([strings objectAtIndex:3]) {
                    objReturn.locationYLandscape = [[strings objectAtIndex:3] integerValue];
                } else {
                    objReturn.locationYLandscape = 0;
                }

                if ([strings objectAtIndex:2]) {
                    objReturn.locationXLandscape = [[strings objectAtIndex:2] integerValue];
                } else {
                    objReturn.locationXLandscape = 0;
                }

            } else if (strings.count > 1) {
                if ([strings objectAtIndex:1]) {
                    objReturn.locationY = [[strings objectAtIndex:1] integerValue];
                    objReturn.locationYLandscape = [[strings objectAtIndex:1] integerValue];
                } else {
                    objReturn.locationY = 0;
                    objReturn.locationYLandscape = 0;
                }

                if ([strings objectAtIndex:0]) {
                    objReturn.locationX = [[strings objectAtIndex:0] integerValue];
                    objReturn.locationXLandscape = [[strings objectAtIndex:0] integerValue];
                } else {
                    objReturn.locationX = 0;
                    objReturn.locationXLandscape = 0;
                }
            } else {
                objReturn.locationX = 0;
                objReturn.locationY = 0;
                objReturn.locationXLandscape = 0;
                objReturn.locationYLandscape = 0;
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeInteger:self.locationX forKey:kCommandXMLLocationX];
        [encoder encodeInteger:self.locationY forKey:kCommandXMLLocationY];
        [encoder encodeInteger:self.locationXLandscape forKey:kCommandXMLLocationXLandscape];
        [encoder encodeInteger:self.locationYLandscape forKey:kCommandXMLLocationYLandscape];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.locationX          = [decoder decodeIntegerForKey:kCommandXMLLocationX];
            self.locationY          = [decoder decodeIntegerForKey:kCommandXMLLocationY];
            self.locationXLandscape = [decoder decodeIntegerForKey:kCommandXMLLocationXLandscape];
            self.locationYLandscape = [decoder decodeIntegerForKey:kCommandXMLLocationYLandscape];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
