//
//  ControlSize.h
//  mHubApp
//
//  Created by Yashica Agrawal on 03/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlSize : NSObject
@property(nonatomic, retain) SizeUI *mobileSmall;
@property(nonatomic, retain) SizeUI *mobileLarge;
@property(nonatomic, retain) SizeUI *tabletSmall;
@property(nonatomic, retain) SizeUI *tabletLarge;

+(ControlSize*) initWithSize_Width:(NSDictionary*)dictWidth Height:(NSDictionary*)dictHeight;

@end
