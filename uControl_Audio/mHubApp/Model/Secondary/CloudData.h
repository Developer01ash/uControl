//
//  CloudData.h
//  mHubApp
//
//  Created by Anshul Jain on 26/04/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSerial_Number  @"serial_no"
#define kMHUB_Name      @"mhub_name"
#define kMhub_Image     @"imgMHub"

@interface CloudData : NSObject
@property(nonatomic, retain) NSString *strSerialNo;
@property(nonatomic, retain) NSString *strMHubName;
@property(nonatomic, retain) UIImage *imgMHub;

+(CloudData*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectArray:(NSArray*)arrResp;

@end
