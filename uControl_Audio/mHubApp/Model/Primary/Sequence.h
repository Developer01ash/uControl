//
//  Sequence.h
//  mHubApp
//
//  Created by Anshul Jain on 19/08/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

/*
 Sequence is group of commands comprises in a single unit known as MACRO or Sequence contains basic details like id, name, descriptions, etc.
 */

#import <Foundation/Foundation.h>

@interface Sequence : NSObject
@property(nonatomic, retain) NSString *macro_id;
@property(nonatomic, retain) NSString *macro_name;
@property(nonatomic, retain) NSString *uControl_name;
@property(nonatomic, retain) NSString *alexa_name;
@property(nonatomic, retain) NSString *macro_description;
@property(nonatomic, assign) BOOL isDeleted;
@property(nonatomic, assign) double eTime_forSeqences;
@property(nonatomic, retain) NSMutableArray<NSString*>*arrZoneIds; // Array of String ZoneIds
@property(nonatomic, assign) BOOL isFunction;


+(Sequence*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp;
+(NSMutableArray*) getObjectXMLArray:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectV2Array:(NSMutableArray*)arrResp;
-(NSDictionary*) dictionaryRepresentation;
+(NSMutableArray*)getDictionaryArray:(NSMutableArray*)arrResp;
 
+(Sequence*)getFilteredSequenceData:(NSString*)macro_id Sequence:(NSMutableArray*)arrSequence;
+(Sequence*)getFilteredSequenceDataByName:(NSString*)uControl_name Sequence:(NSMutableArray*)arrSequence;

@end
