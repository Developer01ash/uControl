//
//  CellFooter.m
//  mHubApp
//
//  Created by Anshul Jain on 26/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "CellFooter.h"
#define kPortraitContraintConstantiPhone4 10

@implementation CellFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputBackground;
    self.imgBackground.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputBackground;
    self.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorOutputBackground Frame:self.imgBackground.frame];
    [self.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorOutputBorder BorderWidth:1.0];
    [self.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorOutputText];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblName setFont:textFontLight10];
    } else {
        [self.lblName setFont:textFontLight13];
    }

    if (IS_IPHONE_4_HEIGHT) {
        self.constraintTopImageSetting.constant = kPortraitContraintConstantiPhone4;
        self.constraintBottomImageSetting.constant = kPortraitContraintConstantiPhone4;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
