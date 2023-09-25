//
//  IRCommand.m
//  mHubApp
//
//  Created by Anshul Jain on 25/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "IRCommand.h"

@implementation IRCommand

#pragma mark - GET IRCOMMAND OBJECT
+(IRCommand*) getObjectFromDictionary:(NSDictionary*)dictResp {
    IRCommand *objReturn=[[IRCommand alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.command_id = [[Utility checkNullForKey:kCommandId Dictionary:dictResp] integerValue];
            objReturn.label = [Utility checkNullForKey:kCommandXMLLabel Dictionary:dictResp];

            objReturn.code = [Utility checkNullForKey:kCommandXMLCode Dictionary:dictResp];
            objReturn.repeat = [[Utility checkNullForKey:kCommandXMLRepeat Dictionary:dictResp] boolValue];

//            id tempCode = [Utility checkNullForKey:kCommandXMLCode Dictionary:dictResp];
//            if ([tempCode isKindOfClass:[NSDictionary class]]) {
//                objReturn.code = [Utility checkNullForKey:kCommandXMLText Dictionary:tempCode];
//                objReturn.repeat = [[Utility checkNullForKey:kCommandXMLRepeat Dictionary:tempCode] boolValue];
//            } else {
//                objReturn.code = tempCode;
//                objReturn.repeat = false;
//            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(IRCommand*) getObjectFromXMLDictionary:(NSDictionary*)dictResp {
    IRCommand *objReturn=[[IRCommand alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.command_id = [[Utility checkNullForKey:kCommandXMLId Dictionary:dictResp] integerValue];
            objReturn.label = [Utility checkNullForKey:kCommandXMLLabel Dictionary:dictResp];
            
            // objReturn.code = [Utility checkNullForKey:kCommandXMLCode Dictionary:dictResp];
            // objReturn.repeat = [[Utility checkNullForKey:kCommandXMLRepeat Dictionary:dictResp] boolValue];

            id tempCode = [Utility checkNullForKey:kCommandXMLCode Dictionary:dictResp];
            if ([tempCode isKindOfClass:[NSDictionary class]]) {
                objReturn.code = [Utility checkNullForKey:kCommandXMLText Dictionary:tempCode];
                objReturn.repeat = [[Utility checkNullForKey:kCommandXMLRepeat Dictionary:tempCode] boolValue];
            } else {
                objReturn.code = tempCode;
                objReturn.repeat = false;
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - GET IRCOMMAND OBJECT ARRAY
+(NSMutableArray*) getObjectArray:(NSArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                IRCommand *objDevice = [IRCommand getObjectFromDictionary:dictResp];
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
        if([arrResp isNotEmpty] && [arrResp isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                IRCommand *objDevice = [IRCommand getObjectFromXMLDictionary:dictResp];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - GET FILTERED OBJECT
+(IRCommand*)getFilteredCommandData:(NSInteger)command_id IRCommands:(NSMutableArray*)arrIRCommands {
    // Label, code, repeat flag
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"command_id = %@", [NSNumber numberWithInteger:command_id]];
    NSArray *arrCmdFiltered = [arrIRCommands filteredArrayUsingPredicate:predicate];
    IRCommand *objReturn = nil;
    objReturn =  arrCmdFiltered.count > 0 ? arrCmdFiltered.firstObject : nil;
    return objReturn;
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeInteger:self.command_id forKey:kCommandId];
        [encoder encodeObject:self.label forKey:kCommandXMLLabel];
        [encoder encodeObject:self.code forKey:kCommandXMLCode];
        [encoder encodeBool:self.repeat forKey:kCommandXMLRepeat];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
//
- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.command_id = [decoder decodeIntegerForKey:kCommandId];
            self.label      = [decoder decodeObjectForKey:kCommandXMLLabel];
            self.code       = [decoder decodeObjectForKey:kCommandXMLCode];
            self.repeat     = [decoder decodeBoolForKey:kCommandXMLRepeat];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
