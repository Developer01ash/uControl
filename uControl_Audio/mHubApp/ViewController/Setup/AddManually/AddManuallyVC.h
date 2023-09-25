//
//  AddManuallyVC.h
//  mHubApp
//
//  Created by rave on 9/18/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectVC.h"
#import "IPAddressContainerVC.h"

@interface AddManuallyVC : UIViewController <UIGestureRecognizerDelegate, IPAddressContainerDelegate, UITableViewDelegate> {
    NSIndexPath *selectedIndexPath;
}
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblDeviceType;
@property (weak, nonatomic) IBOutlet UIView *viewIPAddress;
@property (weak, nonatomic) IBOutlet UITableView *tblSelection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblDeviceType;

@property (nonatomic) NSMutableArray *arrData;

@property (nonatomic) HubModel hubModel;
@end
