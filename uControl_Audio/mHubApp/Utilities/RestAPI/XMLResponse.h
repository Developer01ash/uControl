//
//  XMLResponse.h
//  mHubApp
//
//  Created by Anshul Jain on 22/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLResponse : NSObject
@property (nonatomic, retain) ControlPack *controlPack;
@property (nonatomic, retain) Meta *meta;
@property (nonatomic, retain) NSArray <Command*>*IRCommandPacket;

+(XMLResponse*) getObjectFromDictionary:(NSDictionary*)dictResp CDeviceType:(ControlDeviceType)type;
+(XMLResponse *) getObjectFromDictionaryForMeta:(NSDictionary*)dictResp ;
@end
