//
//  Meta.h
//  mHubApp
//
//  Created by Anshul Jain on 24/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meta : NSObject
@property (nonatomic, retain) NSString *deviceID;
@property (nonatomic, retain) NSString *version;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *manufacturer;

+(Meta*) getObjectFromDictionary:(NSDictionary*)dictResp;

@end
