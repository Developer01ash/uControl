//
//  CellSetupDevice.h
//  mHubApp
//
//  Created by Anshul Jain on 24/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButtonMultiTags.h"

@interface CellSetupDevice : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCellBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgCell;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckMark;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblClickingNo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_foundation;
@property (weak, nonatomic) IBOutlet UILabel *lbl_foundationConnected;
@property (weak, nonatomic) IBOutlet UILabel *lbl_deviceCount;

@property (weak, nonatomic) IBOutlet CustomButtonMultiTags *btn_identity;
@property (weak, nonatomic) IBOutlet UIView *viewBottomBorder;
@property (weak, nonatomic) IBOutlet UIView *viewDassedLine;
@property (weak, nonatomic) IBOutlet UIView *viewBG;
//Below properties only for single view controller where need to give name of devices in stack.
@property (weak, nonatomic) IBOutlet UITextField *txtF_deviceName;
@property (weak, nonatomic) IBOutlet UIView *view_textFieldNCount;
@end
