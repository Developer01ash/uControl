//
//  SelectMasterControllerVC.h
//  mHubApp
//
//  Created by Rave Digital on 01/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectMasterControllerVC : UIViewController
{
    
}
@property (weak, nonatomic) IBOutlet LabelHeader *lblHeader;
@property (weak, nonatomic) IBOutlet LabelSubHeader *lblSubHeader;
@property (weak, nonatomic) IBOutlet CustomButton *btnContinue;
@property (weak, nonatomic) IBOutlet UITableView *tbl_masterDevice;
@property (weak, nonatomic) IBOutlet UITableView *tbl_selectFromBottom;
@property (weak, nonatomic) IBOutlet UIView *view_bottomTbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl_assignVideos;
@property (weak, nonatomic) IBOutlet CustomButton *btn_addToSystem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfTable;
@property (strong, nonatomic) NSMutableArray <SearchData*>*arrSearchData;
@property (strong, nonatomic) NSMutableArray *arrMasterControllers;
@property (strong, nonatomic) Hub *masterDevice;
@property (strong, nonatomic) NSMutableArray <Hub*>*arr_deviceAddedTop;
@end

NS_ASSUME_NONNULL_END
