//
//  AboutUcontrolVC.h
//  mHubApp
//
//  Created by Apple on 23/07/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutUcontrolVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblAppVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblSerialNo;
@property (weak, nonatomic) IBOutlet UILabel *lblMOSVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblAppVersion_value;
@property (weak, nonatomic) IBOutlet UILabel *lblSerialNo_value;
@property (weak, nonatomic) IBOutlet UILabel *lblMOSVersion_value;
@end

NS_ASSUME_NONNULL_END
