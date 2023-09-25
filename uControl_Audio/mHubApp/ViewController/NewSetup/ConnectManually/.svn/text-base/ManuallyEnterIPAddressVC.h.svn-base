//
//  ManuallyEnterIPAddressVC.h
//  mHubApp
//
//  Created by rave on 9/18/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManuallyIPAddressContainerVC.h"

@interface ManuallyEnterIPAddressVC : UIViewController <UIGestureRecognizerDelegate, ManuallyIPAddressContainerDelegate, UITableViewDelegate> {
    NSIndexPath *selectedIndexPath;
}
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblDeviceType;
@property (weak, nonatomic) IBOutlet UIView *viewIPAddress;
@property (weak, nonatomic) IBOutlet UITableView *tblSelection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblDeviceType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewIPAddress;

@property (nonatomic) NSMutableArray *arrData;

@property (nonatomic) HubModel hubModel;

@property(nonatomic, assign) HDASetupType setupType;
@property(nonatomic, assign) HDAPairSetupLevel setupLevel;

@end
