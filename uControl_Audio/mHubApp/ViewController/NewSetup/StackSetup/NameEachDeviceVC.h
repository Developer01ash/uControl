//
//  NameEachDeviceVC.h
//  mHubApp
//
//  Created by Rave Digital on 23/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NameEachDeviceVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet LabelHeader *lblHeader;
@property (weak, nonatomic) IBOutlet LabelSubHeader *lblSubHeader;
@property (weak, nonatomic) IBOutlet CustomButton *btnContinue;
@property (weak, nonatomic) IBOutlet UITableView *tbl_devices;
@property (strong, nonatomic) Hub *masterDevice;
@property (strong, nonatomic) NSMutableArray <Hub*>*arr_device_name;
@end

NS_ASSUME_NONNULL_END
