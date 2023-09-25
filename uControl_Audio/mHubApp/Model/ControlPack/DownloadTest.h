//
//  DownloadTest.h
//  mHubApp
//
//  Created by Yashica Agrawal on 24/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadTest : NSObject
@property (nonatomic, retain) NSString *test_id;
@property (nonatomic, retain) NSString *test_label;
@property (nonatomic, retain) NSString *test_description;

+(DownloadTest*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(NSMutableArray*) getObjectArray:(NSArray*)arrResp;
@end
