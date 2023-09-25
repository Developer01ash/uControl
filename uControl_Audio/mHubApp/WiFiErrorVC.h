//
//  WiFiErrorVC.h
//  mHubApp
//
//  Created by Rave Digital on 02/02/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WiFiErrorVC : UIViewController
@property(nonatomic,weak)IBOutlet UILabel *lbl_heading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading;
@property(nonatomic,weak)IBOutlet CustomButton *btn_tryAgain;
@property(nonatomic) NSInteger errorType;
@end

NS_ASSUME_NONNULL_END
