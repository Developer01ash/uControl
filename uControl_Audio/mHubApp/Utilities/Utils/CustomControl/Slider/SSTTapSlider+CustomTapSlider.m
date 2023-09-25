//
//  SSTTapSlider+CustomTapSlider.m
//  mHubApp
//
//  Created by Anshul Jain on 11/01/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "SSTTapSlider+CustomTapSlider.h"

@implementation SSTTapSlider (CustomTapSlider)

- (CGRect)trackRectForBounds:(CGRect)bounds {
    @try {
        CGRect newRect = [super trackRectForBounds:bounds];
        newRect.size.height = 3.0f;
        return newRect;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return true;
}
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return  true;
}
@end
