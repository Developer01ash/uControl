//
//  WidgetCommand.h
//  mHubApp
//
//  Created by Anshul Jain on 24/08/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWidgetCommandId            @"command_id"
#define kWidgetCommandCode          @"code"
#define kWidgetCommandLabel         @"label"
#define kWidgetCommandImageLight    @"image_light"

@interface WidgetCommand : NSObject
@property(nonatomic) NSInteger command_id;
@property(nonatomic, retain) NSString *code;
@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) UIImage *image_light;

+(WidgetCommand*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectArray:(NSArray*)arrResp;
-(NSDictionary*) dictionaryRepresentation;

@end
