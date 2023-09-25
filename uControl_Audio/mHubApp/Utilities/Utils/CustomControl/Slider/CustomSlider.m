//
//  CustomSlider.m
//  mHubApp
//
//  Created by Anshul Jain on 13/12/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "CustomSlider.h"

@implementation CustomSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)trackRectForBounds:(CGRect)bounds {
    @try {
        CGRect newRect = [super trackRectForBounds:bounds];
        newRect.size.height = 5.0f;
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
/*
-(void) layoutSubviews {
    @try {
        [super layoutSubviews];
        [[UISlider appearance] setThumbImage:kImageIconAudioSlider forState:UIControlStateNormal];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
*/

@end
