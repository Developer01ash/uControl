//
//  UICommand.m
//  mHubApp
//
//  Created by Yashica Agrawal on 22/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "UICommand.h"

@implementation UICommand

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
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

+(UICommand*) getObjectFromDictionary:(NSDictionary*)dictResp IRCommands:(NSMutableArray*)arrIRCommands {
    UICommand *objReturn=[[UICommand alloc] init];
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
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
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
            UICommand *objReturn=[[UICommand alloc] init];
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
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return arrReturn;
}

+(NSMutableArray*) getObjectArrayForPowerButton_IRCommands:(NSMutableArray*)arrIRCommands {
    NSMutableArray *arrReturn=[[NSMutableArray alloc] init];
    @try {
        NSArray *arrPower = [NSArray arrayWithObjects:
                               [NSNumber numberWithInteger:Power],
                               nil];
        
        for (int counter = 0; counter < arrPower.count; counter++) {
            UICommand *objReturn=[[UICommand alloc] init];
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
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
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
            UICommand *objReturn=[[UICommand alloc] init];
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
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return arrReturn;
}

+(NSMutableArray*) getObjectArray:(NSArray*)arrResp IRCommands:(NSMutableArray*)arrIRCommands {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                UICommand *objDevice = [UICommand getObjectFromDictionary:dictResp IRCommands:arrIRCommands];
                if (objDevice.command_id > -1) {
                    [arrReturn addObject:objDevice];
                }
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
        [encoder encodeObject:[NSNumber numberWithInteger:self.command_id] forKey:kCommandXMLId];
        [encoder encodeObject:self.label forKey:kCommandXMLLabel];
        [encoder encodeObject:self.code forKey:kCommandXMLCode];
        [encoder encodeObject:[NSNumber numberWithBool:self.repeat] forKey:kCommandXMLRepeat];
        [encoder encodeObject:[NSNumber numberWithInteger:self.uitype] forKey:kCPControlType];
        [encoder encodeObject:self.location forKey:kCPControlLocation];
        [encoder encodeObject:self.size forKey:kCPControlSize];
        [encoder encodeObject:self.visibility forKey:kCPControlGroupVisibility];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
                //decode properties, other class vars
            self.command_id = [[decoder decodeObjectForKey:kCommandXMLId] integerValue];
            self.label = [decoder decodeObjectForKey:kCommandXMLLabel];
            self.code = [decoder decodeObjectForKey:kCommandXMLCode];
            self.repeat = [[decoder decodeObjectForKey:kCommandXMLRepeat] boolValue];
            self.uitype = [[decoder decodeObjectForKey:kCPControlType] integerValue];
            self.location = [decoder decodeObjectForKey:kCPControlLocation];
            self.size = [decoder decodeObjectForKey:kCPControlSize];
            self.visibility = [decoder decodeObjectForKey:kCPControlGroupVisibility];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

@end
