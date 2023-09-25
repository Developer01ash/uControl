//
//  SizeUI.h
//  mHubApp
//
//  Created by Yashica Agrawal on 03/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SizeUI : NSObject
@property (nonatomic) NSInteger sizeWidth;  // X define Row Number
@property (nonatomic) NSInteger sizeHeight; // Y define Column Number

+(SizeUI*) initWithWidth:(NSString*)strWidth Height:(NSString *)strHeight;

@end
