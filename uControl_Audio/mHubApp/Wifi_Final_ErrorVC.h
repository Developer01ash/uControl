//
//  Wifi_Final_ErrorVC.h
//  mHubApp
//
//  Created by Rave Digital on 02/02/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Wifi_Final_ErrorVC : UIViewController
@property(nonatomic,weak)IBOutlet UILabel *lbl_heading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_heading2;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading2;
@property(nonatomic,weak)IBOutlet UILabel *lbl_heading3;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading3;
@property(nonatomic,weak)IBOutlet CustomButton *btn_tryAgain;
@end

NS_ASSUME_NONNULL_END
