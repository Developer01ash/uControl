//
//  CellSetup.h
//  mHubApp
//
//  Created by Yashica Agrawal on 29/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSetup : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;

@property (weak, nonatomic) IBOutlet UIView *viewCellBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblCellHeader;
@end
