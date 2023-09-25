//
//  SetupMismatchViewController.h
//  mHubApp
//
//  Created by Rave on 20/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetupMismatchViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *arrSearchData;
@property (weak, nonatomic) IBOutlet UITableView *tbl_mismatchWithVersion;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblConnectionOption;
@property(weak,nonatomic) IBOutlet UILabel *lbl_mismatchMessage;
@property (weak, nonatomic) IBOutlet CustomButton *btn_returnToMenu;
@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property ( nonatomic)BOOL isSoftware_mismatch;
@end

NS_ASSUME_NONNULL_END
