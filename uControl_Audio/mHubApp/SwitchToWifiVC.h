//
//  SwitchToWifiVC.h
//  mHubApp
//
//  Created by Rave Digital on 01/02/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwitchToWifiVC : UIViewController
@property(nonatomic,weak)IBOutlet UILabel *lbl_heading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_password;
@property(nonatomic,weak)IBOutlet UILabel *lbl_hdanywhere;
@property(nonatomic,weak)IBOutlet CustomButton *btn_connected;
@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@end

NS_ASSUME_NONNULL_END
