//
//  CellHubUpdateVersionTableViewCell.h
//  mHubApp
//
//  Created by Rave on 12/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellHubUpdateVersionTableViewCell : UITableViewCell

    @property (weak, nonatomic) IBOutlet UIImageView *imgHubDevice;
    @property (weak, nonatomic) IBOutlet UIImageView *img_mismatch_yes_no;
    @property (weak, nonatomic) IBOutlet UILabel *lbl_HubVersion;
    @property (weak, nonatomic) IBOutlet UILabel *lbl_HubName;
    @property (weak, nonatomic) IBOutlet UILabel *lbl_HubAddress;
    @property (weak, nonatomic) IBOutlet UIView *view_roundView;
    
    //@property (weak, nonatomic) IBOutlet UIView *viewCellBackground;
    //@property (weak, nonatomic) IBOutlet UILabel *lblCellHeader;
    @property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_heightCenterView;


@end

NS_ASSUME_NONNULL_END
