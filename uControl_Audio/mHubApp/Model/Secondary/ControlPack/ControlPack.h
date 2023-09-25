//
//  ControlPack.h
//  mHubApp
//
//  Created by Anshul Jain on 24/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlPack : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) Meta *meta;
//@property (nonatomic, retain) NSMutableArray *downloadTest;
//@property (nonatomic, retain) id grid;

@property (nonatomic, retain) NSMutableArray *ir;
@property (nonatomic, retain) NSMutableArray *appUI;
@property (nonatomic, retain) NSMutableArray *continuity;

+(ControlPack*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(ControlPack*) getObjectFromXMLDictionary:(NSDictionary*)dictResp;

@end
