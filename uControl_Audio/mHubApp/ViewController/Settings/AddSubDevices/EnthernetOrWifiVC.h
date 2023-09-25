//
//  EnthernetOrWifiVC.h
//  mHubApp
//
//  Created by Apple on 05/02/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnthernetOrWifiVC : UIViewController

@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrMhubDevicesFound;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;
@end

NS_ASSUME_NONNULL_END
