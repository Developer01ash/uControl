//
//  CustomButton_NoBorder.m
//  mHubApp
//
//  Created by Rave Digital on 04/02/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "CustomButton_NoBorder.h"

@implementation CustomButton_NoBorder

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
    self.layer.borderWidth = 0.0f;
    
    [self.titleLabel.text uppercaseString];
//    self.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.titleLabel setFont:textFontBold10];
       
    } else {
        [self.titleLabel setFont:textFontBold13];

    }
}

@end
