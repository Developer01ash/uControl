//
//  ArrangeVideoDevicesVC.h
//  mHubApp
//
//  Created by Rave Digital on 01/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArrangeVideoDevicesVC : UIViewController<UITableViewDragDelegate,UITableViewDropDelegate>
@property (weak, nonatomic) IBOutlet LabelHeader *lblHeader;
@property (weak, nonatomic) IBOutlet LabelSubHeader *lblSubHeader;
@property (weak, nonatomic) IBOutlet CustomButton *btnContinue;
@property (weak, nonatomic) IBOutlet UITableView *tbl_top;
@property (weak, nonatomic) IBOutlet UITableView *tbl_bottom;
@property (strong, nonatomic) NSMutableArray <SearchData*>*arrSearchData;
@property (strong, nonatomic) NSMutableArray <Hub*>*arr_deviceAddedTop;
@property (strong, nonatomic) NSMutableArray <Hub*>*arr_bottomDeviceList;
@property (strong, nonatomic) NSMutableArray <SearchData*>*ArrTempData;
@property (strong, nonatomic) Hub *masterDevice;
@property (weak, nonatomic) IBOutlet UIView *view_bottomTbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl_assignVideos;
@property (weak, nonatomic) IBOutlet CustomButton *btn_addToSystem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfTable;
@end

NS_ASSUME_NONNULL_END
