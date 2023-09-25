//
//  WifiDevicesListVC.h
//  mHubApp
//
//  Created by Ashutosh Tiwari on 16/03/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WifiDevicesListVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (strong, nonatomic) NSMutableArray <SearchData*>*arrSearchData;
@property (weak, nonatomic) IBOutlet UITableView *tblSearch;
@property (strong, nonatomic) Hub *objSelectedMHubDevice;

@end

NS_ASSUME_NONNULL_END
