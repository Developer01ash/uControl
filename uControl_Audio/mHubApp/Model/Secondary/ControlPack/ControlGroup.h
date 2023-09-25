//
//  ControlGroup.h
//  mHubApp
//
//  Created by Anshul Jain on 25/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlGroup : NSObject
@property (nonatomic) ControlType type;
@property (nonatomic, retain) Order *order;
@property (nonatomic, retain) ControlVisibility* visibility;
@property (nonatomic, retain) NSMutableArray *arrUIElements;

+(ControlGroup*) getObjectForGestureView_IRCommands:(NSMutableArray*)arrIRCommands;
+(ControlGroup*) getObjectForPowerButton_IRCommands:(NSMutableArray*)arrIRCommands;
+(ControlGroup*) getObjectForVolumeButton_IRCommands:(NSMutableArray*)arrIRCommands;
+(NSMutableArray*) getObjectArray:(NSArray*)arrResp IRCommands:(NSMutableArray*)arrIRCommands;
@end
