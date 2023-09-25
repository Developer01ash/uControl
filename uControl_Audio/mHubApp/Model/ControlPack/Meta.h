//
//  Meta.h
//  mHubApp
//
//  Created by Yashica Agrawal on 24/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meta : NSObject
@property (nonatomic, retain) NSString *deviceID;
@property (nonatomic, retain) NSString *version;
+(Meta*) getObjectFromDictionary:(NSDictionary*)dictResp;

@end
