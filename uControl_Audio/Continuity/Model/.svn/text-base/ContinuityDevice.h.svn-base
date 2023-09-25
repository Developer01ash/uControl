//
//  ContinuityDevice.h
//  mHubApp
//
//  Created by Anshul Jain on 28/08/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContinuityDevice : NSObject
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *CreatedName;
@property(nonatomic, assign) NSInteger Index;
@property(nonatomic, assign) NSInteger PortNo;

+(ContinuityDevice*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectArray:(NSMutableArray*)arrResp;
-(NSDictionary*) dictionaryRepresentation;
+(NSMutableArray*)getDictionaryArray:(NSMutableArray*)arrResp;

@end
