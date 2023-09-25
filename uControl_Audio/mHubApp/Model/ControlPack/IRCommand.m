//
//  IRCommand.m
//  mHubApp
//
//  Created by Yashica Agrawal on 25/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "IRCommand.h"

@implementation IRCommand

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
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return objReturn;
}

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
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:[NSNumber numberWithInteger:self.command_id] forKey:kCommandId];
        [encoder encodeObject:self.label forKey:kCommandXMLLabel];
        [encoder encodeObject:self.code forKey:kCommandXMLCode];
        [encoder encodeObject:[NSNumber numberWithBool:self.repeat] forKey:kCommandXMLRepeat];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
                //decode properties, other class vars
            self.command_id = [[decoder decodeObjectForKey:kCommandId] integerValue];
            self.label = [decoder decodeObjectForKey:kCommandXMLLabel];
            self.code = [decoder decodeObjectForKey:kCommandXMLCode];
            self.repeat = [[decoder decodeObjectForKey:kCommandXMLRepeat] boolValue];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

+(IRCommand*)getFilteredCommandData:(NSInteger)command_id IRCommands:(NSMutableArray*)arrIRCommands {
    // Label, code, repeat flag
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"command_id = %@", [NSNumber numberWithInteger:command_id]];
    NSArray *arrCmdFiltered = [arrIRCommands filteredArrayUsingPredicate:predicate];
    IRCommand *objReturn = nil;
    objReturn =  arrCmdFiltered.count > 0 ? arrCmdFiltered.firstObject : nil;
    return objReturn;
}
@end
