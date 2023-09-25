//
//  AVRDevice.h
//  mHubApp
//
//  Created by Anshul Jain on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/*
 AVR is an additional port in MHUB. This object basic details of the Input i.e. Source device like UnitId, Index, PortNo., Name, IRPack(objCommandType), Continuity detail, Volume, Mute etc.
 */

#import <Foundation/Foundation.h>
#import "Hub.h"

@interface AVRDevice : NSObject

@property(nonatomic, retain) NSString *UnitId;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *CreatedName;
@property(nonatomic, assign) NSInteger Index;
@property(nonatomic, assign) NSInteger PortNo;
@property(nonatomic, assign) BOOL isDeleted;
@property(nonatomic, assign) BOOL isIRPack;

@property(nonatomic, retain) CommandType *objCommandType;
@property(nonatomic, assign) ControlDeviceType sourceType;
@property(nonatomic, retain) NSMutableArray<ContinuityCommand*>*arrContinuity;

@property(nonatomic, assign) BOOL isGrouped;
@property(nonatomic, retain) UIImage *imgOutput;
@property(nonatomic, assign) NSInteger Volume;
@property(nonatomic, assign) BOOL isMute;

+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp Hub:(Hub*)objHub;
+(NSMutableArray*) getObjectArray_Hub:(Hub*)objHub;
+(NSMutableArray*) getIRPackStatusArray:(Hub*)objHub;
+(NSMutableArray*) getDictionaryArray:(NSMutableArray*)arrResp;
+(AVRDevice*) getIRPackStatusFromObject:(Hub*)objHub ;

+(AVRDevice*) getFilteredInputDeviceData:(NSInteger)Index InputData:(NSMutableArray*)arrInputData;
+(NSMutableArray*) getIRPackStatusArray:(NSMutableArray*)arrResp AVRArray:(NSMutableArray*)arrAVRs;
@end
