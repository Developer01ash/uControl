//
//  ControlGroup.m
//  mHubApp
//
//  Created by Anshul Jain on 25/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ControlGroup.h"

@implementation ControlGroup
+(ControlGroup*) getObjectFromDictionary:(NSDictionary*)dictResp IRCommands:(NSMutableArray*)arrIRCommands Order:(NSInteger)intOrder {
    ControlGroup *objReturn = [[ControlGroup alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            NSString *strType = [Utility checkNullForKey:kCPControlType Dictionary:dictResp];
            if ([strType isKindOfClass:[NSString class]]) {
                if ([strType isEqualToString:kCPCGGesture]) {
                    objReturn.type = GestureKey;
                    objReturn.order = [Order initWithType:GesturePad Order:intOrder+1];
                } else if ([strType isEqualToString:kCPCGNavigation]){
                    objReturn.type = Direction;
                    objReturn.order = [Order initWithType:DirectionPad Order:intOrder+1];
                } else if ([strType isEqualToString:kCPCGPlayhead]){
                    objReturn.type = Playhead;
                    objReturn.order = [Order initWithType:PlayheadPad Order:intOrder+1];
                } else if ([strType isEqualToString:kCPCGNumerical]){
                    objReturn.type = Number;
                    objReturn.order = [Order initWithType:NumberPad Order:intOrder+1];
                } else if ([strType isEqualToString:kCPCGCustom]){
                    objReturn.type = Custom;
                    objReturn.order = [Order initWithType:CustomPad Order:intOrder+1];
                }
                else {
                    objReturn.order = [[Order alloc] init];
                }
            }

            objReturn.visibility = [ControlVisibility initWithControlVisibility_MobileSmall:[Utility checkNullForKey:kDeviceTypeMobileSmall Dictionary:dictResp] MobileLarge:[Utility checkNullForKey:kDeviceTypeMobileLarge Dictionary:dictResp] TabletSmall:[Utility checkNullForKey:kDeviceTypeTabletSmall Dictionary:dictResp] TabletLarge:[Utility checkNullForKey:kDeviceTypeTabletLarge Dictionary:dictResp]];
            
            id tempUI = [Utility checkNullForKey:kCPControlGroupUI Dictionary:dictResp];
            if ([tempUI isKindOfClass:[NSArray class]]) {
                objReturn.arrUIElements = [[NSMutableArray alloc]initWithArray:[UiCommand getObjectArray:[Utility checkNullForKey:kCPControlGroupUI Dictionary:dictResp] IRCommands:arrIRCommands]];
            } else {
                objReturn.arrUIElements = [[NSMutableArray alloc]initWithArray:[UiCommand getObjectArray:[NSArray arrayWithObject:[Utility checkNullForKey:kCPControlGroupUI Dictionary:dictResp]] IRCommands:arrIRCommands]];
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(ControlGroup*) getObjectForGestureView_IRCommands:(NSMutableArray*)arrIRCommands {
    ControlGroup *objReturn = [[ControlGroup alloc] init];
    @try {
        objReturn.type = Gesture;
        objReturn.order = [[Order alloc] init];
        objReturn.visibility = [[ControlVisibility alloc] init];
        objReturn.arrUIElements = [[NSMutableArray alloc]initWithArray:[UiCommand getObjectArrayForGestureView_IRCommands:arrIRCommands]];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(ControlGroup*) getObjectForPowerButton_IRCommands:(NSMutableArray*)arrIRCommands {
    ControlGroup *objReturn = [[ControlGroup alloc] init];
    @try {
        objReturn.type = PowerKey;
        objReturn.order = [[Order alloc] init];
        objReturn.visibility = [[ControlVisibility alloc] init];
        objReturn.arrUIElements = [[NSMutableArray alloc]initWithArray:[UiCommand getObjectArrayForPowerButton_IRCommands:arrIRCommands]];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(ControlGroup*) getObjectForVolumeButton_IRCommands:(NSMutableArray*)arrIRCommands {
    ControlGroup *objReturn = [[ControlGroup alloc] init];
    @try {
        objReturn.type = Volume;
        objReturn.order = [[Order alloc] init];
        objReturn.visibility = [[ControlVisibility alloc] init];
        objReturn.arrUIElements = [[NSMutableArray alloc]initWithArray:[UiCommand getObjectArrayForVolumeButton_IRCommands:arrIRCommands]];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(NSMutableArray*) getObjectArray:(NSArray*)arrResp IRCommands:(NSMutableArray*)arrIRCommands {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if ([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                ControlGroup *objDevice = [ControlGroup getObjectFromDictionary:dictResp IRCommands:arrIRCommands Order:i];
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
        [encoder encodeInteger:self.type forKey:kCPControlType];
        [encoder encodeObject:self.order forKey:kCPControlOrder];
        [encoder encodeObject:self.visibility forKey:kCPControlGroupVisibility];
        [encoder encodeObject:self.arrUIElements forKey:kCPControlGroupUI];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.type           = [decoder decodeIntegerForKey:kCPControlType];
            self.order          = [decoder decodeObjectForKey:kCPControlOrder];
            self.visibility     = [decoder decodeObjectForKey:kCPControlGroupVisibility];
            self.arrUIElements  = [decoder decodeObjectForKey:kCPControlGroupUI];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
