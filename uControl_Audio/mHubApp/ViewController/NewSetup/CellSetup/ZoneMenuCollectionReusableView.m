//
//  ZoneMenuCollectionReusableView.m
//  mHubApp
//
//  Created by Apple on 24/06/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "ZoneMenuCollectionReusableView.h"

@implementation ZoneMenuCollectionReusableView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.lblTitle setFont:textFontRegular12];
    }else if ([AppDelegate appDelegate].deviceType == mobileLarge) {
        [self.lblTitle setFont:textFontRegular16];
    }else {
        [self.lblTitle setFont:textFontRegular18];
    }
   
}
@end
