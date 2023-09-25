//
//  LabelHeader.m
//  mHubApp
//
//  Created by Rave Digital on 01/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "LabelHeader.h"

@implementation LabelHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = colorClear;
    //[self.text uppercaseString];
    [self setTextColor:colorWhite];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self setFont:textFontBold12];
    } else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
        [self setFont:textFontBold16];
    }
    else{
            [self setFont:textFontBold18];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
