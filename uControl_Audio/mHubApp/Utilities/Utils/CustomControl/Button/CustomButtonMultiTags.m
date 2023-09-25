//
//  CustomButtonMultiTags.m
//  mHubApp
//
//  Created by Rave Digital on 15/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "CustomButtonMultiTags.h"

@implementation CustomButtonMultiTags

-(void)awakeFromNib
{
    [super awakeFromNib];
   // self.backgroundColor = color;
   
    
    [self setTitle:@"IDENTIFY" forState:UIControlStateNormal];
    [self.titleLabel.text uppercaseString];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        self.titleLabel.font = textFontBold10;
        //[self.titleLabel setFont:textFontBold100];
    }else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
        self.titleLabel.font = textFontBold12;
    }
    else {
        self.titleLabel.font = textFontBold14;

    }
    //[self.titleLabel setTextColor:colorRed];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
