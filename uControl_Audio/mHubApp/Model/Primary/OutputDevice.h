//
//  OutputDevice.h
//  mHubApp
//
//  Created by Anshul Jain on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/*
 Output Device contains basic details of the Output i.e. Display device like UnitId, Index, PortNo., Name, IRPack(objCommandType), background Image, etc.
 */

#import <Foundation/Foundation.h>
#import "Hub.h"

@interface OutputDevice : NSObject

@property(nonatomic, retain) NSString *UnitId;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *CreatedName;
@property(nonatomic, retain) NSString *outputType;
@property(nonatomic, assign) NSInteger Index;
@property(nonatomic, assign) NSInteger PortNo;
@property(nonatomic, assign) NSInteger irmapId;
@property(nonatomic, retain) NSString *outputType_VideoOrAudio;
@property(nonatomic, assign) BOOL isDeleted;
@property(nonatomic, assign) BOOL isIRPack;

@property(nonatomic, retain) CommandType *objCommandType;
@property(nonatomic, assign) ControlDeviceType sourceType;
@property(nonatomic, retain) UIImage *imgControlGroup;
@property(nonatomic, assign) ControlDeviceType selectedControlDeviceType;

@property(nonatomic, assign) BOOL isGrouped;
@property(nonatomic, retain) UIImage *imgGroupedOutput;
@property(nonatomic, assign) NSInteger Volume;
@property(nonatomic, assign) BOOL isMute;
@property(nonatomic, assign) NSInteger InputIndex;

+(OutputDevice*) getOutputObject_From:(OutputDevice *)objFrom To:(OutputDevice*)objTo;

+(OutputDevice*) getOutputObjectFromDictionary:(NSDictionary*)dictResp Hub:(Hub*)objHub;
+(OutputDevice*) getObjectStatusFromDictionary:(NSDictionary*)dictResp;

+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp Hub:(Hub*)objHub;
+(NSMutableArray*) getOutputObjectArray:(NSMutableArray*)arrResp Hub:(Hub*)objHub;
+(NSMutableArray*) getOutputObjectArrayFromIndex:(NSInteger)OutputCount;

+(NSMutableArray*) getTempOutputObjectArray:(NSInteger)OutputCount Hub:(Hub*)objHub;
+(NSMutableArray*) getObjectArrayGroup:(NSMutableArray*)arrResp;
+(NSMutableArray*) getObjectArrayJSON:(NSDictionary*)dictResp InputCount:(NSInteger)InputCount;
//+(NSMutableArray*) getObjectArraySystem:(NSMutableArray*)arrResp Hub:(Hub*)objHub;
+(NSMutableArray*) getObjectArraySystem:(NSMutableArray*)arrResp Hub:(Hub*)objHub keyValue:(NSString *)key_VideoAudio;

+(NSMutableArray*) getZoneOutputObjectArray:(NSArray*)arrResp;
+(NSMutableArray*) getIRPackStatusArray:(NSMutableArray*)arrResp OutputArray:(NSMutableArray*)arrOutput;

-(NSDictionary*) dictionaryRepresentation;
+(NSMutableArray*) getDictionaryArray:(NSMutableArray*)arrResp;
+(NSMutableArray*) getServerDictionaryArray:(NSMutableArray*)arrResp;

+(OutputDevice*)getFilteredOutputDeviceData:(NSInteger)Index OutputData:(NSMutableArray*)arrOutputData;


@end
