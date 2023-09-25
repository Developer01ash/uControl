//
//  Group.h
//  mHubApp
//
//  Created by Anshul Jain on 22/01/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

/*
 Group is collection of different Zone in which only one video is allowed other can be audio and maximum zone number will be 4. This object contains Id, Name, array of Zones, Its Volume, and Mute Status.
 */

#import <Foundation/Foundation.h>

@interface Group : NSObject
@property(nonatomic, retain) NSString *GroupId;
@property(nonatomic, retain) NSString *GroupName;
@property(nonatomic, retain) NSMutableArray<NSString*>*arrGroupedZones; // Array of String ZoneIds 
@property(nonatomic, assign) NSInteger GroupVolume;
@property(nonatomic, assign) BOOL GroupMute;

-(id)initWithGroup:(Group *)groupData;
+(Group*) initWithName:(NSString*)strName ZoneArray:(NSMutableArray*)arrZones;
+(Group*) getGroupObject_From:(Group *)objFrom To:(Group*)objTo;

+(Group*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp;

-(NSDictionary*) dictionaryRepresentation;
+(NSMutableArray*) getDictionaryArray:(NSMutableArray*)arrResp;

+(Group*)getFilteredGroupData:(NSString*)GroupId Group:(NSMutableArray*)arrGroup;
@end
