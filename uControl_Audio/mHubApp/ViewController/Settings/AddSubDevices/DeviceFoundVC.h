//
//  DeviceFoundVC.h
//  mHubApp
//
//  Created by Apple on 05/02/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceFoundVC : UIViewController


@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrMhubDevicesFound;
@end

NS_ASSUME_NONNULL_END
