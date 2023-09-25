//
//  JoinNetworkVC.h
//  mHubApp
//
//  Created by Ashutosh Tiwari on 03/01/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifiConnectedVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JoinNetworkVC : UIViewController
@property(nonatomic,strong)NSString *SSIDNameStr;
@property(nonatomic,strong)NSString *passwordStr;
@property(nonatomic,strong)NSString *encryptionNameStr;
@property(nonatomic,weak)IBOutlet CustomButton *btn_solid;
@property(nonatomic,weak)IBOutlet CustomButton_NoBorder *btn_flashing;
@property(nonatomic,weak)IBOutlet UILabel *lbl_heading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_pleaseWait;
@property(nonatomic,weak)IBOutlet UIImageView *img_spinner;
@property(nonatomic,weak)IBOutlet UILabel *lbl_progress;



@end

NS_ASSUME_NONNULL_END
