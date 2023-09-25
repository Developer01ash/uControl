//
//  UpdateAvailableViewController.h
//  mHubApp
//
//  Created by Rave on 06/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchData.h"



NS_ASSUME_NONNULL_BEGIN

@interface UpdateAvailableViewController : UIViewController
{
    
}
@property (strong, nonatomic) NSMutableArray *arrSearchData;
@property (strong, nonatomic) NSString *latestOSVersion;
@property (weak, nonatomic) IBOutlet UITableView *tbl_hubListWithVersion;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblConnectionOption;
@property(weak,nonatomic) IBOutlet UILabel *lbl_updateMessage;
@property (weak, nonatomic) IBOutlet CustomButton *btn_updateHub;
@property (weak, nonatomic) IBOutlet CustomButton *gotoMenu;

@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property (weak, nonatomic) IBOutlet UIView *view_checkingUpdates;
@property(weak,nonatomic) IBOutlet UILabel *lbl_HoldForUpdateMsg;
@property(nonatomic) NSInteger navigateFromType;

@property (strong, nonatomic) Hub *objSelectedMHubDevice_ForSetupConfirmation;
@property (assign, nonatomic) BOOL isSelectedPaired_ForSetupConfirmation;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrSelectedSlaveDevice_ForSetupConfirmation;
@end

NS_ASSUME_NONNULL_END
