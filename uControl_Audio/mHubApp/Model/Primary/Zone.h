//
//  Zone.h
//  mHubApp
//
//  Created by Anshul Jain on 24/04/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

/*
 Zone contains basic details like zone_id, zone_label, input connected, output list, volume value, mute status, etc.
 */

#import <Foundation/Foundation.h>
typedef NS_OPTIONS(NSInteger, OutputTypeInZone) {
    audioOnly    = 0,
    videoOnly     = 1,
    audioVideoZone    = 2,
    allMasterOutputs    = 3,
};

@interface Zone : NSObject
@property(nonatomic, retain) NSString *zone_id;
@property(nonatomic, retain) NSString *zone_label;
@property(nonatomic, retain) NSMutableArray *arrOutputs;
@property(nonatomic, assign) NSInteger audio_input;
@property(nonatomic, assign) NSInteger video_input;
@property(nonatomic, assign) NSInteger disp_audio_input;
@property(nonatomic, assign) NSInteger paired_audio_input;
@property(nonatomic, assign) NSInteger OutputTypeInSelectedZone;
@property(nonatomic, assign) NSInteger avr_id;

@property(nonatomic, assign) NSInteger Volume;
@property(nonatomic, assign) BOOL isMute;
@property(nonatomic, assign) BOOL isDeleted;
@property(nonatomic, assign) BOOL isGrouped;
@property(nonatomic, assign) BOOL isAuto_switch_mode;

@property(nonatomic, retain) UIImage *imgGroupedZone;
@property(nonatomic, retain) UIImage *imgControlGroupBG;
@property(nonatomic, assign) BOOL isIRPackAvailable;
@property(nonatomic, assign) ControlDeviceType bottomControlDevice;


+(Zone*) getZoneObject_From:(Zone *)objFrom To:(Zone*)objTo;
+(Zone*) getZoneObjectFromDictionary:(NSDictionary*)dictResp Hub:(Hub*)objHub;
+(Zone*) getZoneStatusObjectFromDictionary:(NSDictionary*)dictResp;

+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp Hub:(Hub*)objHub;
+(NSMutableArray*) getObjectVolumeArray:(NSMutableArray*)arrResp Hub:(Hub*)objHub;
+(NSMutableArray*) getObjectArrayJSON:(NSDictionary*)dictResp;

-(NSDictionary*) dictionaryRepresentation;
+(NSMutableArray*) getDictionaryArray:(NSMutableArray*)arrResp;

+(Zone*)getFilteredZoneData:(NSString*)zone_id ZoneData:(NSMutableArray*)arrZoneData;
+(NSString*)getFilteredZoneId:(NSString*)zone_id ZoneIds:(NSMutableArray*)arrZoneIds;

@end
