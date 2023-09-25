//
//  Controls.h
//  mHubApp
//
//  Created by Rave Digital on 31/05/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Controls : NSObject
@property(nonatomic, retain) NSString *control_id;
@property(nonatomic, retain) NSString *control_name;
@property(nonatomic, retain) NSString *control_description;
@property(nonatomic, retain) NSString *control_type;
@property(nonatomic, retain) NSString *device_type;
@property(nonatomic, retain) NSMutableArray<NSString*>*arrZoneIds; // Array of String ZoneIds

+(Controls *) getObjectFromDictionary:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp;
+(NSMutableArray*) getObjectXMLArray:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectV2Array:(NSMutableArray*)arrResp;
-(NSDictionary*) dictionaryRepresentation;
+(NSMutableArray*)getDictionaryArray:(NSMutableArray*)arrResp;
@end

NS_ASSUME_NONNULL_END
