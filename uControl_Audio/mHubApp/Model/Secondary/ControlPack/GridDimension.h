//
//  GridDimension.h
//  mHubApp
//
//  Created by Anshul Jain on 07/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridDimension : NSObject
@property (nonatomic) NSInteger row;  // X define Row Number
@property (nonatomic) NSInteger column; // Y define Column Number

+(GridDimension*) initWithRows:(NSInteger)intRow Column:(NSInteger)intColumn;

@end
