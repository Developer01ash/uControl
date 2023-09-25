//
//  CellSetting.m
//  mHubApp
//
//  Created by Anshul Jain on 24/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "CellSetting.h"

@implementation CellSetting

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = colorClear;
    self.imgCellBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorBackground Frame:self.imgCellBackground.frame];
    [self.imgCellBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorTableCellBorder BorderWidth:1.0];

    self.lblCell.backgroundColor = colorClear;
    self.lblCell.textColor = [AppDelegate appDelegate].themeColours.colorNormalText;
    self.lblCell.textAlignment = NSTextAlignmentCenter;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblCell setFont:textFontLight10];
    } else {
        [self.lblCell setFont:textFontLight13];
    }

    [self.imgCell setTintColor:[AppDelegate appDelegate].themeColours.colorHeaderText];
    [self.imgCell setContentMode:UIViewContentModeScaleToFill];
    [self.border setBackgroundColor:colorMiddleGray_868787];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
