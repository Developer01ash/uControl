//
//  WifiSetupInstructionViewController.h
//  mHubApp
//
//  Created by Ashutosh Tiwari on 19/12/19.
//  Copyright © 2019 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectedWifiViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WifiSetupInstructionViewController : UIViewController

@property(nonatomic,weak)IBOutlet CustomButton *btn_settings;
@property(nonatomic,weak)IBOutlet CustomButton *btn_continue;
@property(nonatomic,weak)IBOutlet UILabel *lbl_title1;
@property(nonatomic,weak)IBOutlet UILabel *lbl_title2;
@property(nonatomic,weak)IBOutlet UILabel *lbl_password;



@end

NS_ASSUME_NONNULL_END
