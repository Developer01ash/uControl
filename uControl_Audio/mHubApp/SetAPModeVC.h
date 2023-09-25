//
//  SetAPModeVC.h
//  mHubApp
//
//  Created by Ashutosh Tiwari on 19/03/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifiConnectedVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface SetAPModeVC : UIViewController
@property(nonatomic,strong)Hub *objSelectedDevice;
@property(nonatomic,weak)IBOutlet UILabel *lbl_headingTitle1;
@property(nonatomic,weak)IBOutlet UILabel *lbl_headingTitle2;
@property(nonatomic,weak)IBOutlet CustomButton *btn_solid;
@property(nonatomic,weak)IBOutlet CustomButton *btn_flashing;
@end

NS_ASSUME_NONNULL_END
