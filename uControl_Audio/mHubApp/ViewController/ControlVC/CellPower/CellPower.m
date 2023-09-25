//
//  CellPower.m
//  mHubApp
//
//  Created by Anshul Jain on 15/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "CellPower.h"

@implementation CellPower

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [AppDelegate appDelegate].themeColours.colorPowerControlBG;
   // [self.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorPowerControlBorder BorderWidth:1.0];
    [self.imgBackground addBorder_Color:UIColor.whiteColor BorderWidth:1.0];

  //  [self.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorPowerControlText];
    [self.lblName setTextColor:UIColor.whiteColor];

    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblName setFont:textFontRegular10];
    } else {
        [self.lblName setFont:textFontRegular13];
    }
    
    [self.imgConnected setHidden:false];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
