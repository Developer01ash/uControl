//
//  CustomButtonForControls.m
//  mHubApp
//
//  Created by Apple on 18/06/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "CustomButtonForControls.h"

@implementation CustomButtonForControls
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
//    self.layer.borderWidth = 1.0f;
//    self.layer.borderColor = colorMiddleGray_868787.CGColor;
//    [self.titleLabel.text uppercaseString];
////    self.textAlignment = NSTextAlignmentLeft;
//    [self.titleLabel setTextColor:[AppDelegate appDelegate].themeColoursSetup.colorNormalText];
//    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
//        [self.titleLabel setFont:textFontBold10];
//       
//    } else {
//        [self.titleLabel setFont:textFontBold12];
//
//    }
}

@end
