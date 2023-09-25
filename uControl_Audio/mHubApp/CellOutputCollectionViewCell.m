//
//  CellOutputCollectionViewCell.m
//  mHubApp
//
//  Created by Apple on 16/02/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "CellOutputCollectionViewCell.h"

@implementation CellOutputCollectionViewCell

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
    [self.sequenceProgress_byTime setTrackTintColor:colorClear];
    [self.sequenceProgress_byTime setProgressTintColor:colorProPink];
    //[self.btnCellDelete setBackgroundColor:colorYellow];
}


- (IBAction)btnCellDelete_Clicked:(id)sender {
    if (self.delegate) {
        [self.delegate didReceivedTapOnCellDeleteButton:self];
    }
}
@end
