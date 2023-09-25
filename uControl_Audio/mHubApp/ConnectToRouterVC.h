//
//  ConnectToRouterVC.h
//  mHubApp
//
//  Created by Ashutosh Tiwari on 20/12/19.
//  Copyright © 2019 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinNetworkVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConnectToRouterVC : UIViewController<UITextFieldDelegate>
{

}
@property(nonatomic,weak)IBOutlet UILabel *lbl_heading;
@property(nonatomic,weak)IBOutlet UITextField *txtField_password;
@property(nonatomic,weak)IBOutlet CustomButton *btn_ssidNameDisplay;
@property(nonatomic,weak)IBOutlet CustomButton *btn_joinNetwork;
@property(nonatomic,strong)NSString *SSIDNameStr;
@property(nonatomic,strong)NSString *encryptionNameStr;

@end

NS_ASSUME_NONNULL_END
