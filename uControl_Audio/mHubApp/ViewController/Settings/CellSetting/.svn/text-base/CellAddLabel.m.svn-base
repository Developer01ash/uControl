//
//  CellAddLabel.m
//  mHubApp
//
//  Created by Anshul Jain on 02/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "CellAddLabel.h"

@implementation CellAddLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = colorClear;
    [self.txtCell setBackgroundColor:[AppDelegate appDelegate].themeColours.colorNavigationBar];
    [self.txtCell setTextColor:[AppDelegate appDelegate].themeColours.colorHeaderText];
    [self.txtCell addBorder_Color:[AppDelegate appDelegate].themeColours.colorTableCellBorder BorderWidth:1.0];
    //self.txtCell.delegate = self;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.txtCell.leftView = paddingView;
    self.txtCell.leftViewMode = UITextFieldViewModeAlways;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.txtCell setFont:textFontLight10];
    } else {
        [self.txtCell setFont:textFontLight13];
    }

    [self.lblCell setTextColor:[AppDelegate appDelegate].themeColours.colorNormalText];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblCell setFont:textFontLight10];
    } else {
        [self.lblCell setFont:textFontLight13];
    }
    // [self.lblCell setBackgroundColor:[UIColor greenColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
