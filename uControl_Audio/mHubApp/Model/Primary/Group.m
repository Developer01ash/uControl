//
//  Group.m
//  mHubApp
//
//  Created by Anshul Jain on 22/01/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

/*
 Group is collection of different Zone in which only one video is allowed other can be audio and maximum zone number will be 4. This object contains Id, Name, array of Zones, Its Volume, and Mute Status.
 */

#import "Group.h"

@implementation Group

-(id)init {
    self = [super init];
    self.GroupId            = @"";
    self.GroupName          = @"";
    self.arrGroupedZones    = [[NSMutableArray alloc] init];
    self.GroupVolume        = 100;
    self.GroupMute          = false;
    return self;
}

-(id)initWithGroup:(Group *)groupData {
    self = [super init];
    @try {
        self.GroupId            = groupData.GroupId;
        self.GroupName          = groupData.GroupName;
        self.arrGroupedZones    = groupData.arrGroupedZones;
        self.GroupVolume        = groupData.GroupVolume;
        self.GroupMute          = groupData.GroupMute;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

+(Group*) initWithName:(NSString*)strName ZoneArray:(NSMutableArray*)arrZones {
    Group *objReturn = [[Group alloc] init];
    @try {
        objReturn.GroupName = strName;
        objReturn.arrGroupedZones = arrZones;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark -
+(Group*) getGroupObject_From:(Group *)objFrom To:(Group*)objTo {
    Group *objReturn = [[Group alloc] initWithGroup:objTo];
    @try {
        if ([objFrom.GroupId isNotEmpty]) {
            objReturn.GroupId = objFrom.GroupId;
        }

        if ([objFrom.GroupName isNotEmpty]) {
            objReturn.GroupName = objFrom.GroupName;
        }

        if ([objFrom.arrGroupedZones isNotEmpty]) {
            objReturn.arrGroupedZones = objFrom.arrGroupedZones;
        }

        if (objFrom.GroupVolume != 0) {
            objReturn.GroupVolume = objFrom.GroupVolume;
        }

        if (objFrom.GroupMute == true) {
            objReturn.GroupMute = objFrom.GroupMute;
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - GET OBJECT METHODS

+(Group*) getObjectFromDictionary:(NSDictionary*)dictResp {
    Group *objReturn = [[Group alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.GroupId = [Utility checkNullForKey:kGROUPID Dictionary:dictResp];
            objReturn.GroupName = [Utility checkNullForKey:kGROUPLABEL Dictionary:dictResp];
            id arrZones = [Utility checkNullForKey:kGROUPZONES Dictionary:dictResp];
            if ([arrZones isKindOfClass:[NSArray class]]) {
                objReturn.arrGroupedZones = [[NSMutableArray alloc] initWithArray:arrZones];
            } else {
                objReturn.arrGroupedZones = [[NSMutableArray alloc] init];
            }
            objReturn.GroupVolume = [[Utility checkNullForKey:kGROUPVOLUME Dictionary:dictResp] integerValue];
            objReturn.GroupMute = [[Utility checkNullForKey:kGROUPMUTE Dictionary:dictResp] boolValue];
        }
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - GET OBJECT ARRAY
+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp {
    @try {
        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
        if([arrResp isNotEmpty]) {
            for (int i = 0; i < [arrResp count]; i++) {
                NSMutableDictionary *dictResp = [[arrResp objectAtIndex:i] mutableCopy];
                Group *objDevice = [Group getObjectFromDictionary:dictResp];
                [arrReturn addObject:objDevice];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - GET DICTIONARY FROM OBJECT

-(NSDictionary*) dictionaryRepresentation {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.GroupId forKey:kGROUPID];
        [dict setValue:self.GroupName forKey:kGROUPLABEL];
        [dict setValue:self.arrGroupedZones forKey:kGROUPZONES];
        [dict setValue:[NSNumber numberWithInteger:self.GroupVolume] forKey:kGROUPVOLUME];
        [dict setValue:[NSNumber numberWithBool:self.GroupMute] forKey:kGROUPMUTE];
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
                Group *objDevice = [arrResp objectAtIndex:i];
                NSDictionary *dictResp = [objDevice dictionaryRepresentation];
                [arrReturn addObject:dictResp];
            }
        }
        return arrReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - GET FILTERED OBJECT
+(Group*) getFilteredGroupData:(NSString*)GroupId Group:(NSMutableArray*)arrGroup {
    @try {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"GroupId = %@", GroupId];
        NSArray *arrGAFiltered = [arrGroup filteredArrayUsingPredicate:predicate];
        Group *objReturn = nil;
        objReturn =  arrGAFiltered.count > 0 ? arrGAFiltered.firstObject : nil;
        return objReturn;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeObject:self.GroupId forKey:kGROUPID];
        [encoder encodeObject:self.GroupName forKey:kGROUPLABEL];
        [encoder encodeObject:self.arrGroupedZones forKey:kGROUPZONES];
        [encoder encodeInteger:self.GroupVolume forKey:kGROUPVOLUME];
        [encoder encodeBool:self.GroupMute forKey:kGROUPMUTE];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            self.GroupId            = [decoder decodeObjectForKey:kGROUPID];
            self.GroupName          = [decoder decodeObjectForKey:kGROUPLABEL];
            self.arrGroupedZones    = [decoder decodeObjectForKey:kGROUPZONES];
            self.GroupVolume        = [decoder decodeIntegerForKey:kGROUPVOLUME];
            self.GroupMute          = [decoder decodeBoolForKey:kGROUPMUTE];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
