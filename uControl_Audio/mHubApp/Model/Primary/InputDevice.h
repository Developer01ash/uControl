//
//  InputDevice.h
//  mHubApp
//
//  Created by Anshul Jain on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/*
 Input Device contains basic details of the Input i.e. Source device like UnitId, Index, PortNo., Name, IRPack(objCommandType), Continuity detail, etc.
*/

#import <Foundation/Foundation.h>
#import "Hub.h"

@interface InputDevice : NSObject

@property(nonatomic, retain) NSString *UnitId;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *CreatedName;
@property(nonatomic, retain) NSString *inputType;
@property(nonatomic, assign) NSInteger Index;
@property(nonatomic, assign) NSInteger PortNo;
@property(nonatomic, assign) NSInteger irmapId;
@property(nonatomic, assign) BOOL isDeleted;
@property(nonatomic, assign) BOOL isShow;

@property(nonatomic, assign) BOOL isIRPack;

@property(nonatomic, retain) CommandType *objCommandType;
@property(nonatomic, assign) ControlDeviceType sourceType;
@property(nonatomic, retain) NSMutableArray<ContinuityCommand*>*arrContinuity;

+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp Hub:(Hub*)objHub;
+(NSMutableArray*) getInputObjectArrayFromIndex:(NSInteger)InputCount;
+(NSMutableArray*) getTempInputObjectArray:(NSInteger)InputCount Hub:(Hub*)objHub;
+(NSMutableArray*) getObjectArrayJSON:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectArraySystem:(NSMutableArray*)arrResp Hub:(Hub*)objHub mainRootDictionary:(NSDictionary *)mainDictResp;
+(NSMutableArray*) getIRPackStatusArray:(NSMutableArray*)arrResp InputArray:(NSMutableArray*)arrInput;

-(NSDictionary*) dictionaryRepresentation;
-(NSDictionary*) dictionaryServerRepresentation;
+(NSMutableArray*) getDictionaryArray:(NSMutableArray*)arrResp;

+(InputDevice*)getFilteredInputDeviceData:(NSInteger)Index InputData:(NSMutableArray*)arrInputData;
+(InputDevice*)getFilteredInputDeviceWithCommandData:(NSInteger)Index Hub:(Hub *)objHub;
+(void)updateNamesOfInputs:(InputDevice *)objFrom To:(InputDevice *)objTo;

@end
