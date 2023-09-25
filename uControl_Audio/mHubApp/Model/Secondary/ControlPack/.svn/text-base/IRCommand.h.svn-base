//
//  IRCommand.h
//  mHubApp
//
//  Created by Anshul Jain on 25/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRCommand : NSObject
@property(nonatomic) NSInteger command_id;
@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) NSString *code;
@property(nonatomic) BOOL repeat;

//+(IRCommand*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectArray:(NSArray*)arrResp;
+(NSMutableArray*) getXMLObjectArray:(NSArray*)arrResp;

+(IRCommand*)getFilteredCommandData:(NSInteger)command_id IRCommands:(NSMutableArray*)arrIRCommands;

@end
