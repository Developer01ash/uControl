//
//  mHubManager.h
//  mHubApp
//
//  Created by Yashica Agrawal on 26/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

    // ** Hub default value Constant ** //
#define UNKNOWN_MAC @"00:00:00:00:00:00"
#define UNKNOWN_IP @"0.0.0.0"
#define UNKNOWN_SERIALNO @"X0X0X0X0X0X0X0X0X0X0X0X0X0"

    // ** Selected Hub Shared Constant ** //
#define mHubManagerInstance [mHubManager sharedInstance]

@interface mHubManager : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) Hub *objSelectedHub;
@property (strong, nonatomic) OutputDevice *objSelectedOutputDevice;
@property (strong, nonatomic) InputDevice *objSelectedInputDevice;
//@property (nonatomic) BOOL isForwardCommand;

+ (void)saveCustomObject:(mHubManager *)object key:(NSString *)key;
+ (mHubManager *)loadCustomObjectWithKey:(NSString *)key;
@end
