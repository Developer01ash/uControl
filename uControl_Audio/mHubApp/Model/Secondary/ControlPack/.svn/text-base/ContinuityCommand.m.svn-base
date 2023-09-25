//
//  ContinuityCommand.m
//  mHubApp
//
//  Created by Anshul Jain on 23/08/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "ContinuityCommand.h"
#import <NotificationCenter/NotificationCenter.h>

@implementation ContinuityCommand

-(id)init {
    self = [super init];
    @try {
        self.command_id = -1;
        self.code = @"";
        self.label = @"";
        self.image_light = nil;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

+(ContinuityCommand*) getObjectFromCommandId:(NSInteger)intCommandId IRCommands:(NSMutableArray*)arrIRCommands {
    ContinuityCommand *objReturn = [[ContinuityCommand alloc] init];
    @try {
        objReturn.command_id = intCommandId;

        // Label, code, repeat flag
        IRCommand *objIRCommand = [IRCommand getFilteredCommandData:objReturn.command_id IRCommands:arrIRCommands];
        if (objReturn.command_id == objIRCommand.command_id) {
            objReturn.label = objIRCommand.label;
            objReturn.code = objIRCommand.code;
        }

        Command *objCmdData = [Command getLocalCommandData:intCommandId];
        if (objReturn.command_id == objCmdData.command_id) {
            if (objReturn.command_id == 0) {
                objReturn.label = objReturn.label;
            } else {
                objReturn.label = [objReturn.label isNotEmpty] ? objReturn.label : objCmdData.label;
            }
            objReturn.image_light = objCmdData.image_light;
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(NSMutableArray*) getObjectArray:(NSString*)strResp IRCommands:(NSMutableArray*)arrIRCommands {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if ([strResp isNotEmpty] && [strResp isKindOfClass:[NSString class]]) {
            NSArray *arrResp = [[NSArray alloc] initWithArray:[strResp componentsSeparatedByString:@","]];
            for (int i = 0; i < [arrResp count]; i++) {
                NSString *strResp = [[arrResp objectAtIndex:i] mutableCopy];
                ContinuityCommand *objDevice = [ContinuityCommand getObjectFromCommandId:[strResp integerValue] IRCommands:arrIRCommands];
                if ([objDevice.code isNotEmpty]) {
                    [arrReturn addObject:objDevice];
                }
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(NSDictionary*) dictionaryRepresentation {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSNumber numberWithInteger:self.command_id] forKey:kCommandId];
        [dict setValue:self.code forKey:kCommandCode];
        [dict setValue:self.label forKey:kCommandLabel];
        [dict setValue:self.image_light forKey:kCommandImageLight];
        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getDictionaryArray:(NSMutableArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                ContinuityCommand *objDevice = [arrResp objectAtIndex:i];
                NSDictionary *dictResp = [objDevice dictionaryRepresentation];
                [arrReturn addObject:dictResp];
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
        [encoder encodeObject:self.image_light forKey:kCommandImageLight];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            @try {
                self.command_id = [decoder decodeIntegerForKey:kCommandId];
            } @catch(NSException *exception) {
                self.command_id = [[decoder decodeObjectForKey:kCommandId] integerValue];
            }
            self.code           = [decoder decodeObjectForKey:kCommandCode];
            self.label          = [decoder decodeObjectForKey:kCommandLabel];
            self.image_light    = [decoder decodeObjectForKey:kCommandImageLight];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

+ (void)saveCustomObject:(NSArray *)array key:(NSString *)key {
    @try {
        
        NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:array];
        if ([key isEqualToString:kSELECTEDCONTINUITYARRAY]) {
#ifdef DEVELOPMENT
            if (array.count > 0) {
                [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:kNotificationIndentifierContinuityDev];
            }
            NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:kNotificationBundleIndentifierDev];
            [sharedDefaults setObject:encodedArray forKey:key];
            
#else
            if (array.count > 0) {
                [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:kNotificationIndentifierContinuityProd];
            }
            NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:kNotificationBundleIndentifierProd];
            [sharedDefaults setObject:encodedArray forKey:key];
#endif

            NSData *encodedInputDevice = [NSKeyedArchiver archivedDataWithRootObject:[mHubManagerInstance.objSelectedInputDevice dictionaryServerRepresentation]];
            [sharedDefaults setObject:encodedInputDevice forKey:kSELECTEDINPUTDEVICE];
            
            NSData *encodedHubData = [NSKeyedArchiver archivedDataWithRootObject:[mHubManagerInstance.objSelectedHub dictionaryRepresentation]];
            [sharedDefaults setObject:encodedHubData forKey:kSELECTEDHUBMODEL];
            [sharedDefaults synchronize];

        } else {
            [Utility saveUserDefaults:key value:encodedArray];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+ (NSMutableArray *)retrieveCustomObjectWithKey:(NSString *)key {
    @try {
        NSMutableArray *object = [[NSMutableArray alloc] init];
        NSData *encodedObject = [Utility retrieveUserDefaults:key];
        if ([encodedObject isNotEmpty]) {
            object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        }
        return object;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
