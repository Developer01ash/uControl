//
//  ManuallyEnterSlaveIPAddressVC.h
//  mHubApp
//
//  Created by rave on 9/18/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManuallyIPAddressContainerVC.h"

@interface ManuallyEnterSlaveIPAddressVC : UIViewController <UIGestureRecognizerDelegate, ManuallyIPAddressContainerDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblDeviceType;
@property (weak, nonatomic) IBOutlet UITableView *tblSelection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblDeviceType;

//@property (nonatomic) HubModel hubModel;

@property(nonatomic, assign) HDASetupType setupType;
@property(nonatomic, assign) HDAPairSetupLevel setupLevel;

@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrSelectedSlaveDevice;

@end
