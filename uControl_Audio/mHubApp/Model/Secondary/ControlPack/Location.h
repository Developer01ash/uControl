//
//  Location.h
//  mHubApp
//
//  Created by Anshul Jain on 25/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
@property (nonatomic) NSInteger locationX;  // X define Row Number
@property (nonatomic) NSInteger locationY;  // Y define Column Number
@property (nonatomic) NSInteger locationXLandscape;  // X define Row Number
@property (nonatomic) NSInteger locationYLandscape;  // Y define Column Number

+(Location*) getObjectFromString:(NSString*)strResp;
@end
