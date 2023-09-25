//
//  ContinuityCommand.h
//  mHubApp
//
//  Created by Yashica Agrawal on 23/08/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContinuityCommand : NSObject
@property(nonatomic) NSInteger command_id;
@property(nonatomic, retain) NSString *code;
@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) UIImage *image_light;

+(ContinuityCommand*) getObjectFromCommandId:(NSInteger)intCommandId IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getObjectArray:(NSString*)strResp IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getDictionaryArray:(NSMutableArray*)arrResp;
+ (void)saveCustomObject:(NSArray *)array key:(NSString *)key;
+ (NSMutableArray *)retrieveCustomObjectWithKey:(NSString *)key;

@end
