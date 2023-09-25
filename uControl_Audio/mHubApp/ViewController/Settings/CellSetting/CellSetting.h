//
//  CellSetting.h
//  mHubApp
//
//  Created by Anshul Jain on 24/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSetting : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCellBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgCell;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblCell_SubTitle;
@property (weak, nonatomic) IBOutlet UIView *border;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;

@end
