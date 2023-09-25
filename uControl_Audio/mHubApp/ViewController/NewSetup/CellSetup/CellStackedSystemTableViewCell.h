//
//  CellStackedSystemTableViewCell.h
//  mHubApp
//
//  Created by Rave on 21/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellStackedSystemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_master;
@property (weak, nonatomic) IBOutlet UIImageView *img_slave;
@property (weak, nonatomic) IBOutlet UIImageView *img_selected_yes_no;
@property (weak, nonatomic) IBOutlet UILabel *lbl_HubIPAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbl_StackSystem;
@property (weak, nonatomic) IBOutlet UIView *view_withIpAddress;
@end

NS_ASSUME_NONNULL_END
