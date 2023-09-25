//
//  LeftPanelDisplayDeviceVC.h
//  mHubApp
//
//  Created by Anshul Jain on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutputDevice.h"

@interface LeftPanelDisplayDeviceVC : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIColor *tintColor;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_version;

@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnSettings;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSettingButtonHeightConstant;
@property (weak, nonatomic) IBOutlet UIButton *btnEditDone;

- (IBAction)btnSettings_Clicked:(UIButton *)sender;
- (IBAction)btnEditDone_Clicked:(UIButton *)sender;

@end
