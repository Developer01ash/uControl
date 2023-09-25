//
//  CustomButton.m
//  mHubApp
//
//  Created by Anshul Jain on 27/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
@synthesize infoData;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = colorClear;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = colorMiddleGray_868787.CGColor;
    [self.titleLabel.text uppercaseString];
//    self.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.titleLabel setFont:textFontBold10];
    } else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
        [self.titleLabel setFont:textFontBold12];
    }else {
        [self.titleLabel setFont:textFontBold14];

    }
}

@end
