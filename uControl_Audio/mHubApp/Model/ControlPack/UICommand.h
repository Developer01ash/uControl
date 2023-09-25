//
//  UICommand.h
//  mHubApp
//
//  Created by Yashica Agrawal on 22/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UICommand : NSObject

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


+(UICommand*) getObjectFromDictionary:(NSDictionary*)dictResp IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getObjectArray:(NSArray*)arrResp IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getObjectArrayForGestureView_IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getObjectArrayForPowerButton_IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getObjectArrayForVolumeButton_IRCommands:(NSMutableArray*)arrIRCommands;

@end
