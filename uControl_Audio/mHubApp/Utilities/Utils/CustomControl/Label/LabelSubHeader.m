//
//  LabelSubHeader.m
//  mHubApp
//
//  Created by Rave Digital on 01/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "LabelSubHeader.h"

@implementation LabelSubHeader
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = colorClear;
    //[self.text uppercaseString];
    [self setTextColor:colorMiddleGray_868787];
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self setFont:textFontRegular12];
    } else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
        [self setFont:textFontRegular16];
    }
    else{
            [self setFont:textFontRegular18];
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
