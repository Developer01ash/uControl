//
//  ConnectedWifiViewController.h
//  mHubApp
//
//  Created by Ashutosh Tiwari on 19/12/19.
//  Copyright © 2019 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGRoute.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConnectedWifiViewController : UIViewController
@property(weak,nonatomic) IBOutlet UIButton *wifiNameBtn;
@property(nonatomic,weak)IBOutlet CustomButton *btn_continue;
@property(weak,nonatomic) IBOutlet UILabel *lbl_title;

@end

NS_ASSUME_NONNULL_END
