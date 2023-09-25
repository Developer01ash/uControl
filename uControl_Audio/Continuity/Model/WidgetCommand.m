//
//  WidgetCommand.m
//  mHubApp
//
//  Created by Anshul Jain on 24/08/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "WidgetCommand.h"

@implementation WidgetCommand

-(id)init {
    self = [super init];
    @try {
        self.command_id = -1;
        self.code = @"";
        self.label = @"";
        self.image_light = nil;
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
    return self;
}

+(WidgetCommand*) getObjectFromDictionary:(NSDictionary *)dictResp {
    WidgetCommand *objReturn = [[WidgetCommand alloc] init];
    @try {
        objReturn.command_id = [[dictResp valueForKey:kWidgetCommandId] integerValue];
        objReturn.code = [dictResp valueForKey:kWidgetCommandCode];
        objReturn.label = [dictResp valueForKey:kWidgetCommandLabel];
        objReturn.image_light = [dictResp valueForKey:kWidgetCommandImageLight];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
    return objReturn;
}

+(NSMutableArray*) getObjectArray:(NSArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
            for (int i = 0; i < [arrResp count]; i++) {
                NSDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                WidgetCommand *objDevice = [WidgetCommand getObjectFromDictionary:dictResp];
                [arrReturn addObject:objDevice];
            }
        return arrReturn;
    } @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);;
    }
}

-(NSDictionary*) dictionaryRepresentation {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSNumber numberWithInteger:self.command_id] forKey:kWidgetCommandId];
        [dict setValue:self.code forKey:kWidgetCommandCode];
        [dict setValue:self.label forKey:kWidgetCommandLabel];
        [dict setValue:self.image_light forKey:kWidgetCommandImageLight];
        return dict;
    } @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);
    }
}

@end
