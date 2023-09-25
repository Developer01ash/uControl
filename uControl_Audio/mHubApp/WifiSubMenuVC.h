//
//  WifiSubMenuVC.h
//  mHubApp
//
//  Created by Ashutosh Tiwari on 16/03/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifiDevicesListVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface WifiSubMenuVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblManuallySetup;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblManuallySetup;
@property (strong, nonatomic) NSMutableArray <SearchData*>*arrSearchData;
@property(nonatomic) NSInteger navigateFromType;

@property (strong, nonatomic) IBOutlet UIButton *btn_footer;
@end

NS_ASSUME_NONNULL_END
