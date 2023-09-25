//
//  DeviceListToUpdateVC.h
//  mHubApp
//
//  Created by Rave Digital on 12/01/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellHeaderImage.h"
#import "CellSetupDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeviceListToUpdateVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tbl_devices;
@property (weak, nonatomic) IBOutlet UILabel *lbl_availableSystems;
@property (weak, nonatomic) IBOutlet CustomButton *btnContinue;
@property (weak, nonatomic) IBOutlet CustomButton *btnAdvance;
@property (strong, nonatomic) NSMutableArray <Hub*>*arr_devices;
@property(nonatomic) NSInteger navigateFromType;
@end

NS_ASSUME_NONNULL_END
