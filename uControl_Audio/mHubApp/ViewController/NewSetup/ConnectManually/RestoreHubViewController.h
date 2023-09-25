//
//  RestoreHubViewController.h
//  mHubApp
//
//  Created by Rave on 18/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManuallySetupVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface RestoreHubViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *arrSearchData;
@property (weak, nonatomic) IBOutlet CustomButton *btn_restoreMhub;
@property (weak, nonatomic) IBOutlet UILabel  *lbl_titleWarning;
@property (weak, nonatomic) IBOutlet UILabel  *lbl_restoreWarning;
@property (weak, nonatomic) IBOutlet CustomButton *btn_goBack;
@property (weak, nonatomic) IBOutlet CustomButton *btn_MAINMENU;
@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property (weak, nonatomic) IBOutlet UIView *view_roundView;
@property (weak, nonatomic) IBOutlet UIImageView *img_restoreSuccess_YES_NO;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_heightCenterUIView;

@end

NS_ASSUME_NONNULL_END
