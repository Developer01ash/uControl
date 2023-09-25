//
//  HubDevicesListViewController.h
//  mHubApp
//
//  Created by Rave on 17/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HubDevicesListViewController : UIViewController<NSNetServiceDelegate, NSNetServiceBrowserDelegate>
{
    NSIndexPath *selectedDeviceIndexpath;
    NSMutableArray <NSIndexPath*>*arrSelectedDeviceIndexPath;
    NSMutableArray *arrSelectedDeviceIndexPath_bool;
    
    BOOL isDeviceSelected;
}
@property (weak, nonatomic) NSMutableArray <SearchData*>*arrSearchData;
@property (strong, nonatomic) NSMutableArray *arrSearchDataClass;
@property (weak, nonatomic) IBOutlet UITableView *tblSearch;
@property (weak, nonatomic) IBOutlet UILabel *lbl_deviceFound;
@property (weak, nonatomic) IBOutlet CustomButton *btnContinue;

@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property(nonatomic, assign) HDASetupType setupType;
@property(nonatomic, assign) HDAPairSetupLevel setupLevel;
@property(nonatomic) NSInteger navigateFromType;
@end

NS_ASSUME_NONNULL_END
