//
//  UiCommand.h
//  mHubApp
//
//  Created by Anshul Jain on 22/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UiCommand : NSObject

@property(nonatomic) NSInteger command_id;
@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) NSString *code;
@property(nonatomic) BOOL repeat;

//@property(nonatomic, retain) UIImage *image;
//@property(nonatomic, retain) UIImage *image_disable;

@property(nonatomic) ControlUIType uitype;
@property(nonatomic, retain) ControlLocation *location;
@property(nonatomic, retain) ControlSize *size;
@property(nonatomic, retain) ControlVisibility *visibility;


+(UiCommand*) getObjectFromDictionary:(NSDictionary*)dictResp IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getObjectArray:(NSArray*)arrResp IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getObjectArrayForGestureView_IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getObjectArrayForPowerButton_IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getObjectArrayForVolumeButton_IRCommands:(NSMutableArray*)arrIRCommands;

@end
