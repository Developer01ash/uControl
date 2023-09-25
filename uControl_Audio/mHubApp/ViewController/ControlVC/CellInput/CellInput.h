//
//  CellInput.h
//  mHubApp
//
//  Created by Anshul Jain on 23/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellInput : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblInputName;
@property (weak, nonatomic) IBOutlet UIView *view_sourceCountBG;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sourceCount;

@property (weak, nonatomic) IBOutlet UIImageView *img_sourceIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceDisplayTop_position;

@end
