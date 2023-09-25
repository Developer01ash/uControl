//
//  CellHubUpdateVersionTableViewCell.m
//  mHubApp
//
//  Created by Rave on 12/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "CellHubUpdateVersionTableViewCell.h"

@implementation CellHubUpdateVersionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = colorClear;
   // [self.view_roundView addBorder_Color:[AppDelegate appDelegate].themeColoursSetup.colorTableCellBorder BorderWidth:3.0];
    [self.view_roundView addBorder_Color:[UIColor colorWithRed:26.0/255.0f  green:26.0/255.0f blue:26.0/255.0f alpha:1.0] BorderWidth:5.0];
    [self.view_roundView addRoundedCorner_CornerRadius:self.view_roundView.frame.size.width/2];
    [self.lbl_HubVersion setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
    [self.lbl_HubVersion setFont:textFontRegular12];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
