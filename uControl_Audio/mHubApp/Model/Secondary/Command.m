//
//  Command.m
//  mHubApp
//
//  Created by Anshul Jain on 24/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "Command.h"

@implementation Command

-(id)init {
    self = [super init];
    @try {
        self.command_id = -1;
        self.code = @"";
        self.label = @"";
        self.image = nil;
        self.image_light = nil;
        self.image_label = @"";
        self.isVisible = false;
        self.isRepeat = false;
        self.locationX = 0;
        self.locationY = 0;
        self.locationXLandscape = 0;
        self.locationYLandscape = 0;
        self.sizeWidth = 1;
        self.sizeHeight = 1;
        self.ctrlType = UInone;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

#pragma mark - GET COMMAND OBJECT
+(Command*) getObjectFromDictionary:(NSDictionary*)dictResp {
    Command *objReturn=[[Command alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {

            objReturn.command_id = [[Utility checkNullForKey:kCommandId Dictionary:dictResp] integerValue];
            objReturn.code = [Utility checkNullForKey:kCommandCode Dictionary:dictResp];

            objReturn.label = [Utility checkNullForKey:kCommandLabel Dictionary:dictResp];
            
            NSString *strImage = [Utility checkNullForKey:kCommandImage Dictionary:dictResp];
            if ([strImage isNotEmpty]){
                objReturn.image = [UIImage imageNamed:strImage];
            }
           // NSLog(@"strImage %@ AND %@",strImage);
            NSString *strImageLight = [Utility checkNullForKey:kCommandImageLight Dictionary:dictResp];
            if ([strImageLight isNotEmpty]){
                objReturn.image_light = [UIImage imageNamed:strImageLight];
            }

            if (([strImage isNotEmpty]) && [strImage containsString:@"color"]) {
                objReturn.image_label = strImage;
            }
            
            objReturn.isVisible = false;
            
            objReturn.isRepeat = [[Utility checkNullForKey:kCommandIsRepeat Dictionary:dictResp] boolValue];
            objReturn.locationX = [[Utility checkNullForKey:@"x" Dictionary:dictResp] integerValue];
            objReturn.locationY = [[Utility checkNullForKey:@"y" Dictionary:dictResp] integerValue];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(Command*) getObjectFromXMLDictionary:(NSDictionary*)dictResp {
    Command *objReturn=[[Command alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.command_id = [[Utility checkNullForKey:kCommandXMLId Dictionary:dictResp] integerValue];
            objReturn.label = [Utility checkNullForKey:kCommandXMLLabel Dictionary:dictResp];

            id tempCode = [Utility checkNullForKey:kCommandXMLCode Dictionary:dictResp];
            if ([tempCode isKindOfClass:[NSDictionary class]]) {
                objReturn.code = [Utility checkNullForKey:kCommandXMLText Dictionary:tempCode];
                objReturn.isRepeat = [[Utility checkNullForKey:kCommandXMLRepeat Dictionary:tempCode] boolValue];
            } else {
                objReturn.code = tempCode;
                objReturn.isRepeat = false;
            }

            NSString *strImage = [Utility checkNullForKey:kCommandImage Dictionary:dictResp];
            if ([strImage isNotEmpty])
                objReturn.image = [UIImage imageNamed:strImage];

            NSString *strImageLight = [Utility checkNullForKey:kCommandImageLight Dictionary:dictResp];
            if ([strImageLight isNotEmpty]){
                objReturn.image_light = [UIImage imageNamed:strImageLight];
            }

            if (([strImage isNotEmpty]) && [strImage containsString:@"color"]) {
                objReturn.image_label = strImage;
            }

            objReturn.isVisible = false;
            objReturn.locationX = [[Utility checkNullForKey:@"x" Dictionary:dictResp] integerValue];
            objReturn.locationY = [[Utility checkNullForKey:@"y" Dictionary:dictResp] integerValue];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - GET COMMAND OBJECT ARRAY
+(NSMutableArray*) getObjectArray:(NSArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if ([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                Command *objDevice = [Command getObjectFromDictionary:dictResp];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getXMLObjectArray:(NSArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if ([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                Command *objDevice = [Command getObjectFromXMLDictionary:dictResp];
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
        [encoder encodeInteger:self.command_id forKey:kCommandId];
        [encoder encodeObject:self.code forKey:kCommandCode];
        [encoder encodeObject:self.label forKey:kCommandLabel];
        [encoder encodeObject:self.image forKey:kCommandImage];
        [encoder encodeObject:self.image_light forKey:kCommandImageLight];
        [encoder encodeObject:self.image_label forKey:kCommandImageLabel];
        [encoder encodeBool:self.isVisible forKey:kCommandIsVisible];
        [encoder encodeBool:self.isRepeat forKey:kCommandIsRepeat];
        [encoder encodeInteger:self.locationX forKey:kCommandLocationX];
        [encoder encodeInteger:self.locationY forKey:kCommandLocationY];
        [encoder encodeInteger:self.locationXLandscape forKey:kCommandLocationXLandscape];
        [encoder encodeInteger:self.locationYLandscape forKey:kCommandLocationYLandscape];
        [encoder encodeInteger:self.sizeWidth forKey:kCommandSizeWidth];
        [encoder encodeInteger:self.sizeHeight forKey:kCommandSizeHeight];
        
        [encoder encodeInteger:self.ctrlType forKey:kCommandUIType];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.code               = [decoder decodeObjectForKey:kCommandCode];
            self.label              = [decoder decodeObjectForKey:kCommandLabel];
            self.image              = [decoder decodeObjectForKey:kCommandImage];
            self.image_light        = [decoder decodeObjectForKey:kCommandImageLight];
            self.image_label        = [decoder decodeObjectForKey:kCommandImageLabel];
            @try {
                self.command_id         = [decoder decodeIntegerForKey:kCommandId];
                self.isVisible          = [decoder decodeBoolForKey:kCommandIsVisible];
                self.isRepeat           = [decoder decodeBoolForKey:kCommandIsRepeat];
                self.locationX          = [decoder decodeIntegerForKey:kCommandLocationX];
                self.locationY          = [decoder decodeIntegerForKey:kCommandLocationY];
                self.locationXLandscape = [decoder decodeIntegerForKey:kCommandLocationXLandscape];
                self.locationYLandscape = [decoder decodeIntegerForKey:kCommandLocationYLandscape];
                self.sizeWidth          = [decoder decodeIntegerForKey:kCommandSizeWidth];
                self.sizeHeight         = [decoder decodeIntegerForKey:kCommandSizeHeight];
                self.ctrlType           = [decoder decodeIntegerForKey:kCommandUIType];
            } @catch(NSException *exception) {
                self.command_id         = [[decoder decodeObjectForKey:kCommandId] integerValue];
                self.isVisible          = [[decoder decodeObjectForKey:kCommandIsVisible] boolValue];
                self.isRepeat           = [[decoder decodeObjectForKey:kCommandIsRepeat] boolValue];
                self.locationX          = [[decoder decodeObjectForKey:kCommandLocationX] integerValue];
                self.locationY          = [[decoder decodeObjectForKey:kCommandLocationY] integerValue];
                self.locationXLandscape = [[decoder decodeObjectForKey:kCommandLocationXLandscape] integerValue];
                self.locationYLandscape = [[decoder decodeObjectForKey:kCommandLocationYLandscape] integerValue];
                self.sizeWidth          = [[decoder decodeObjectForKey:kCommandSizeWidth] integerValue];
                self.sizeHeight         = [[decoder decodeObjectForKey:kCommandSizeHeight] integerValue];
                self.ctrlType           = [[decoder decodeObjectForKey:kCommandUIType] integerValue];
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

/*+(ControlDeviceType) getSourceType_Name:(NSString*)strDeviceName SourceType:(ControlDeviceType)type {
    ControlDeviceType sourceType = Uncontrollable;

    if (type > Uncontrollable) {
        sourceType = type;
    }
    return sourceType;
}*/

+(ControlUIType) getControlUIType:(NSString*)strControlUIType {
    ControlUIType uitype = UInone;
    
    if ([strControlUIType isEqualToString:kCPControlUIGesture]) {
        uitype = UIgesture;
    } else if ([strControlUIType isEqualToString:kCPControlUIButton]){
        uitype = UIbutton;
    } else {
        uitype = UInone;
    }
    return uitype;
}

+(Command*)getLocalCommandData:(NSInteger)command_id {
    NSArray *arrCommandData = [[NSArray alloc] initWithArray:[Command getObjectArray:[AppDelegate appDelegate].arrControlData]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"command_id == %d", command_id];
    NSArray *arrCmdDataFiltered = [arrCommandData filteredArrayUsingPredicate:predicate];
    Command *objCmdData = nil;
    objCmdData =  arrCmdDataFiltered.count > 0 ? arrCmdDataFiltered.firstObject : nil;
    return objCmdData;
}

@end
