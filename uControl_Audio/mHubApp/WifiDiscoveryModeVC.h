//
//  WifiDiscoveryModeVC.h
//  mHubApp
//
//  Created by Rave Digital on 31/01/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WifiDiscoveryModeVC : UIViewController
@property(nonatomic,weak)IBOutlet UILabel *lbl_heading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading;
@property(nonatomic,weak)IBOutlet CustomButton *btn_flashing;
@property(nonatomic,weak)IBOutlet CustomButton_NoBorder *btn_solid;
@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property(nonatomic, assign) HubModel modelType;
@end

NS_ASSUME_NONNULL_END
