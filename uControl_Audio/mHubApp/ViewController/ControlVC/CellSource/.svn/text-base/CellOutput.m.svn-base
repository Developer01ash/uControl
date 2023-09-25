//
//  CellOutput.m
//  mHubApp
//
//  Created by Anshul Jain on 22/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "CellOutput.h"

@implementation CellOutput

- (void)awakeFromNib {
    [super awakeFromNib];
    ThemeColor *objTheme = [AppDelegate appDelegate].themeColours;
    self.backgroundColor = objTheme.colorOutputBackground;
    self.selectedBackgroundView.backgroundColor = objTheme.colorOutputSelectedBackground;
    [self.imgBackground addBorder_Color:objTheme.colorOutputBorder BorderWidth:1.0];
    [self.lblName setTextColor:objTheme.colorOutputText];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblName setFont:textFontLight10];
    } else {
        [self.lblName setFont:textFontLight13];
    }
    //[self.btnCellDelete setBackgroundColor:colorYellow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (IBAction)btnCellDelete_Clicked:(id)sender {
    if (self.delegate) {
        [self.delegate didReceivedTapOnCellDeleteButton:self];
    }
}
@end
