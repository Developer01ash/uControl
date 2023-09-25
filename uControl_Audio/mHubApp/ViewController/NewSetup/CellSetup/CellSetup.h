//
//  CellSetup.h
//  mHubApp
//
//  Created by Anshul Jain on 29/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSetup : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblCell_SubTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgSettingIcon;
@property (weak, nonatomic) IBOutlet UISwitch *switch_onOFF;
@property (weak, nonatomic) IBOutlet UIView *viewCellBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblCellHeader;
@property (weak, nonatomic) IBOutlet CustomButton *btn_footer;
@property (weak, nonatomic) IBOutlet UIView *viewBottomBorder;
@property (weak, nonatomic) IBOutlet UIImageView *imgNextArrow;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_headerSettingsIcon;

@end
