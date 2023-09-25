//
//  CellSetupDevice.m
//  mHubApp
//
//  Created by Anshul Jain on 24/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "CellSetupDevice.h"

@implementation CellSetupDevice
{
    CAShapeLayer *yourViewBorder;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = colorClear;
    //    self.imgCellBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColoursSetup.colorBackground Frame:self.imgCellBackground.frame];
    //[self.imgCellBackground addBorder_Color:[AppDelegate appDelegate].themeColoursSetup.colorTableCellBorder BorderWidth:1.0];
    
    self.lblCell.backgroundColor = colorClear;
    self.lblCell.textColor = [AppDelegate appDelegate].themeColoursSetup.colorNormalText;
    self.lblCell.textAlignment = NSTextAlignmentLeft;
    self.lblAddress.textColor = [AppDelegate appDelegate].themeColoursSetup.colorNormalText;
    self.lblAddress.textAlignment = NSTextAlignmentLeft;
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblCell setFont:textFontBold12];
        [self.lblAddress setFont:textFontRegular12];
        [self.btn_identity.titleLabel setFont:textFontBold10];
    }else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
        [self.lblCell setFont:textFontBold14];
        [self.lblAddress setFont:textFontRegular14];
        [self.btn_identity.titleLabel setFont:textFontBold12];
    }else {
        [self.lblCell setFont:textFontBold16];
        [self.lblAddress setFont:textFontRegular16];
        [self.btn_identity.titleLabel setFont:textFontBold14];
    }
    
    [self.imgCell setTintColor:[AppDelegate appDelegate].themeColoursSetup.colorHeaderText];
    [self.imgCell setContentMode:UIViewContentModeScaleToFill];
    
    // yourViewBorder.bounds = self.viewDassedLine.bounds;
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutSubviews];
    if (self.viewDassedLine != nil)
    {
        // set proper content offset
        yourViewBorder = [CAShapeLayer layer];
        //yourViewBorder.position = CGPointMake(0, 0);
        yourViewBorder.strokeColor = [UIColor lightGrayColor].CGColor;
        yourViewBorder.fillColor = nil;
        yourViewBorder.lineDashPattern = @[@4, @4];
        [self.viewDassedLine.layer addSublayer:yourViewBorder];
        yourViewBorder.frame = self.viewDassedLine.bounds;
        yourViewBorder.path = [UIBezierPath bezierPathWithRect:self.viewDassedLine.bounds].CGPath;
    }
    //           [self.viewDassedLine setHidden:true];
}




- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
