//
//  CellFooter.h
//  mHubApp
//
//  Created by Anshul Jain on 26/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellFooter : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgSettings;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopImageSetting;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomImageSetting;
@end
