//
//  WifiConnectedVC.h
//  mHubApp
//
//  Created by Ashutosh Tiwari on 03/01/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WifiConnectedVC : UIViewController

@property(nonatomic,weak)IBOutlet UILabel *lbl_heading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading2;
@property(nonatomic,weak)IBOutlet CustomButton *btn_connectToDevice;
@property(nonatomic,weak)IBOutlet CustomButton_NoBorder *btn_MainMenu;
@end

NS_ASSUME_NONNULL_END
