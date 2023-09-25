//
//  CellControl.m
//  mHubApp
//
//  Created by Anshul Jain on 06/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "CellControl.h"

@implementation CellControl

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        {
        }
    return self;
}

+(CGSize)sizeCellControl {
    CGSize returnSize = CGSizeZero;
    
    if (IS_IPHONE_4_HEIGHT) {
        returnSize = kControlButton4S;
    } else if (IS_IPHONE_5_HEIGHT){
        returnSize = kControlButton5;
    } else if (IS_IPHONE_6_WIDTH) {
        returnSize = kControlButton6;
    } else if (IS_IPHONE_6_PLUS_WIDTH) {
        returnSize = kControlButton6Plus;
    } else if (IS_IPAD_PRO_1024) {
        returnSize = kControlButtonPro;
    } else if (IS_IPAD) {
        returnSize = kControlButtonMini;
    }
    return returnSize;
}

@end
