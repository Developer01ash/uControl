//
//  CellCloudDevice.m
//  mHubApp
//
//  Created by Anshul Jain on 26/04/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "CellCloudDevice.h"

@implementation CellCloudDevice

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = colorClear;
    self.lblCell.textColor = [AppDelegate appDelegate].themeColours.colorNormalText;
    self.lblCell.textAlignment = NSTextAlignmentCenter;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblCell setFont:textFontLight10];
    } else {
        [self.lblCell setFont:textFontLight13];
    }
    self.lblCell.backgroundColor = colorClear;
    
    [self.imgCell setTintColor:[AppDelegate appDelegate].themeColours.colorNormalText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
