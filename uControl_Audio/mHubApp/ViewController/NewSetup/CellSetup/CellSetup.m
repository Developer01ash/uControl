//
//  CellSetup.m
//  mHubApp
//
//  Created by Anshul Jain on 29/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "CellSetup.h"

@implementation CellSetup

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = colorClear;
    [self.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColoursSetup.colorTableCellBorder BorderWidth:1.0];
    [self.lblCell setTextColor:colorWhite];
    [self.lblCell setFont:textFontBold13];
    [self.viewBottomBorder setBackgroundColor:colorMiddleGray_868787];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
