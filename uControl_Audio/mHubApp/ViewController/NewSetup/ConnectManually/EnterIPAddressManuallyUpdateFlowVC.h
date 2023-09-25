//
//  EnterIPAddressManuallyUpdateFlowVC.h
//  mHubApp
//
//  Created by Rave Digital on 12/01/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManuallyIPAddressContainerVC.h"
//NS_ASSUME_NONNULL_BEGIN

@interface EnterIPAddressManuallyUpdateFlowVC : UIViewController <UIGestureRecognizerDelegate, ManuallyIPAddressContainerDelegate, UITableViewDelegate> {
    NSIndexPath *selectedIndexPath;
}
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UIView *viewIPAddress;
@property (weak, nonatomic) IBOutlet UITableView *tblSelection;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblDeviceType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewIPAddress;

//@property (nonatomic) NSMutableArray *arrData;

@property (nonatomic) HubModel hubModel;
@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property(nonatomic, assign) HDASetupType setupType;
@property(nonatomic, assign) HDAPairSetupLevel setupLevel;
@property(nonatomic) NSInteger navigateFromType;
@end
//NS_ASSUME_NONNULL_END
