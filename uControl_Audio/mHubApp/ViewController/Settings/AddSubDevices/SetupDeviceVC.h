//
//  SetupDeviceVC.h
//  mHubApp
//
//  Created by Apple on 05/02/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetupDeviceVC : UIViewController

{
    SFSafariViewController *safariVC;
    NSMutableArray *arrConfirmationData;
}

@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property (assign, nonatomic) BOOL isSelectedPaired;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrSelectedSlaveDevice;

@property (weak, nonatomic) IBOutlet UIView *viewConfirmationStatusBG;
@property (weak, nonatomic) IBOutlet CustomButton *btnConfirmationStatus;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITableView *tblConfirmationOption;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblConfirmationOption;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;


- (IBAction)btnConfirmationStatus_Clicked:(CustomButton *)sender;
- (IBAction)pageControl_ValueChanged:(CustomPageControl *)sender;
@end

NS_ASSUME_NONNULL_END
