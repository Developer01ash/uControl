//
//  StartWifiSetupViewController.h
//  mHubApp
//
//  Created by Ashutosh Tiwari on 19/12/19.
//  Copyright © 2019 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifiSetupInstructionViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface StartWifiSetupViewController : UIViewController

@property(nonatomic,weak)IBOutlet CustomButton *btn_start;
@property(nonatomic,weak)IBOutlet UILabel *lbl_header;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeader;


@end

NS_ASSUME_NONNULL_END
