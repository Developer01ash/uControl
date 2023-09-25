//
//  UiCommand.m
//  mHubApp
//
//  Created by Anshul Jain on 22/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "UiCommand.h"

@implementation UiCommand

-(id)init {
    self = [super init];
    @try {
        self.command_id = -1;
        self.label = @"";
        self.code = @"";
        self.repeat = false;
        self.uitype = UInone;
        self.location = [[ControlLocation alloc]init];
        self.size = [[ControlSize alloc] init];
        self.visibility = [[ControlVisibility alloc] init];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

+(UiCommand*) getObjectFromDictionary:(NSDictionary*)dictResp IRCommands:(NSMutableArray*)arrIRCommands {
    UiCommand *objReturn=[[UiCommand alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
                // Command_Id
            id commandid = [Utility checkNullForKey:kCommandXMLId Dictionary:dictResp];

            if ([commandid isKindOfClass:[NSString class]] && [commandid isEqualToString:@""]) {
                return objReturn;
            } else {
                objReturn.command_id = [commandid integerValue];
            }
            IRCommand *obj = [IRCommand getFilteredCommandData:objReturn.command_id IRCommands:arrIRCommands];
            if (obj.command_id == objReturn.command_id) {
                objReturn.label = obj.label;
                objReturn.code = obj.code;
                objReturn.repeat = obj.repeat;
            }
                // uitype
            NSString *strType = [Utility checkNullForKey:kCPControlType Dictionary:dictResp];

            objReturn.uitype = [Command getControlUIType:strType];

            NSDictionary *dictLocation = [Utility checkNullForKey:kCPControlLocation Dictionary:dictResp];
                // device location
            objReturn.location = [ControlLocation initWithLocation:dictLocation];

                // size
            NSDictionary *dictWidth = [Utility checkNullForKey:kCPControlWidth Dictionary:dictResp];
            NSDictionary *dictHeight = [Utility checkNullForKey:kCPControlHeight Dictionary:dictResp];
            if (![dictHeight isKindOfClass:[NSDictionary class]]) {
                dictHeight = dictWidth;
            }
            objReturn.size = [ControlSize initWithSize_Width:dictWidth Height:dictHeight];

                // visibility
            objReturn.visibility = [ControlVisibility initWithControlVisibility_MobileSmall:[Utility checkNullForKey:kDeviceTypeMobileSmall Dictionary:dictResp] MobileLarge:[Utility checkNullForKey:kDeviceTypeMobileLarge Dictionary:dictResp] TabletSmall:[Utility checkNullForKey:kDeviceTypeTabletSmall Dictionary:dictResp] TabletLarge:[Utility checkNullForKey:kDeviceTypeTabletLarge Dictionary:dictResp]];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(NSMutableArray*) getObjectArrayForGestureView_IRCommands:(NSMutableArray*)arrIRCommands {
    NSMutableArray *arrReturn=[[NSMutableArray alloc] init];
    @try {
        NSArray *arrGesture = [NSArray arrayWithObjects:
                               [NSNumber numberWithInteger:SingleTap_Select],
                               [NSNumber numberWithInteger:DoubleTap_Back],
                               [NSNumber numberWithInteger:SingleSwipeUp_ArrowUp],
                               [NSNumber numberWithInteger:SingleSwipeDown_ArrowDown],
                               [NSNumber numberWithInteger:SingleSwipeLeft_ArrowLeft],
                               [NSNumber numberWithInteger:SingleSwipeRight_ArrowRight],
                               [NSNumber numberWithInteger:DoubleSwipeUp_Play],
                               [NSNumber numberWithInteger:DoubleSwipeDown_Pause],
                               [NSNumber numberWithInteger:DoubleSwipeLeft_Rewind],
                               [NSNumber numberWithInteger:DoubleSwipeRight_Fastforward],
                               nil];

        for (int counter = 0; counter < arrGesture.count; counter++) {
            UiCommand *objReturn=[[UiCommand alloc] init];
                // Command_Id
            objReturn.command_id = [[arrGesture objectAtIndex:counter] integerValue];

            IRCommand *obj = [IRCommand getFilteredCommandData:objReturn.command_id IRCommands:arrIRCommands];
            if (obj.command_id == objReturn.command_id) {
                objReturn.label = obj.label;
                objReturn.code = obj.code;
                objReturn.repeat = obj.repeat;
            }
                // uitype
            NSString *strType = @"gesture";
            objReturn.uitype = [Command getControlUIType:strType];

                // device location
            objReturn.location = [[ControlLocation alloc] init];

                // size
            objReturn.size = [[ControlSize alloc] init];

                // visibility
            objReturn.visibility = [[ControlVisibility alloc] init];

            [arrReturn addObject:objReturn];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return arrReturn;
}

+(NSMutableArray*) getObjectArrayForPowerButton_IRCommands:(NSMutableArray*)arrIRCommands {
    NSMutableArray *arrReturn=[[NSMutableArray alloc] init];
    @try {
        NSArray *arrPower = [NSArray arrayWithObjects:
                               [NSNumber numberWithInteger:Power],[NSNumber numberWithInteger:PowerOn],[NSNumber numberWithInteger:PowerOff],
                               nil];

        for (int counter = 0; counter < arrPower.count; counter++) {
            UiCommand *objReturn=[[UiCommand alloc] init];
            // Command_Id
            objReturn.command_id = [[arrPower objectAtIndex:counter] integerValue];

            IRCommand *obj = [IRCommand getFilteredCommandData:objReturn.command_id IRCommands:arrIRCommands];
            if (obj.command_id == objReturn.command_id) {
                objReturn.label = obj.label;
                objReturn.code = obj.code;
                objReturn.repeat = obj.repeat;
                // uitype
                objReturn.uitype = [Command getControlUIType:@"button"];
                // device location
                objReturn.location = [[ControlLocation alloc] init];
                // size
                objReturn.size = [[ControlSize alloc] init];
                // visibility
                objReturn.visibility = [[ControlVisibility alloc] init];
                [arrReturn addObject:objReturn];
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return arrReturn;
}

+(NSMutableArray*) getObjectArrayForVolumeButton_IRCommands:(NSMutableArray*)arrIRCommands {
    NSMutableArray *arrReturn=[[NSMutableArray alloc] init];
    @try {
        NSArray *arrVolume = [NSArray arrayWithObjects:
                               [NSNumber numberWithInteger:VolUp],
                               [NSNumber numberWithInteger:VolDown],
                               [NSNumber numberWithInteger:VolDown],
                               nil];

        for (int counter = 0; counter < arrVolume.count; counter++) {
            UiCommand *objReturn=[[UiCommand alloc] init];
            // Command_Id
            objReturn.command_id = [[arrVolume objectAtIndex:counter] integerValue];

            IRCommand *obj = [IRCommand getFilteredCommandData:objReturn.command_id IRCommands:arrIRCommands];
            if (obj.command_id == objReturn.command_id) {
                objReturn.label = obj.label;
                objReturn.code = obj.code;
                objReturn.repeat = obj.repeat;
                // uitype
                objReturn.uitype = [Command getControlUIType:@"button"];
                // device location
                objReturn.location = [[ControlLocation alloc] init];
                // size
                objReturn.size = [[ControlSize alloc] init];
                // visibility
                objReturn.visibility = [[ControlVisibility alloc] init];
                [arrReturn addObject:objReturn];
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return arrReturn;
}

+(NSMutableArray*) getObjectArray:(NSArray*)arrResp IRCommands:(NSMutableArray*)arrIRCommands {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                UiCommand *objDevice = [UiCommand getObjectFromDictionary:dictResp IRCommands:arrIRCommands];
                if (objDevice.command_id > -1) {
                    [arrReturn addObject:objDevice];
                }
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
        [encoder encodeInteger:self.command_id forKey:kCommandXMLId];
        [encoder encodeObject:self.label forKey:kCommandXMLLabel];
        [encoder encodeObject:self.code forKey:kCommandXMLCode];
        [encoder encodeBool:self.repeat forKey:kCommandXMLRepeat];
        [encoder encodeInteger:self.uitype forKey:kCPControlType];
        [encoder encodeObject:self.location forKey:kCPControlLocation];
        [encoder encodeObject:self.size forKey:kCPControlSize];
        [encoder encodeObject:self.visibility forKey:kCPControlGroupVisibility];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.command_id = [decoder decodeIntegerForKey:kCommandXMLId];
            self.label = [decoder decodeObjectForKey:kCommandXMLLabel];
            self.code = [decoder decodeObjectForKey:kCommandXMLCode];
            self.repeat = [decoder decodeBoolForKey:kCommandXMLRepeat];
            self.uitype = [decoder decodeIntegerForKey:kCPControlType];
            self.location = [decoder decodeObjectForKey:kCPControlLocation];
            self.size = [decoder decodeObjectForKey:kCPControlSize];
            self.visibility = [decoder decodeObjectForKey:kCPControlGroupVisibility];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
