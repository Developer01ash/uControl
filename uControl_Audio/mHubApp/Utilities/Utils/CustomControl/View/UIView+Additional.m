//
//  UIView+Additional.m
//  mHubApp
//
//  Created by Anshul Jain on 20/12/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "UIView+Additional.h"

//static const float ANIMATION_DURATION_DEFAULT = 0.25f;
//static const float ANIMATION_DELAY_DEFAULT = 0.1f;
//static const float ANIMATION_DURATION_FADEIN = 0.25f;
//static const float ANIMATION_DURATION_FADEOUT = 0.25f;

static const float ANIMATION_DURATION_DEFAULT = 0;
static const float ANIMATION_DELAY_DEFAULT =0;
static const float ANIMATION_DURATION_FADEIN = 0;
static const float ANIMATION_DURATION_FADEOUT = 0;

@implementation UIView (Additional)

- (void)crossDissolveTransitionWithAnimations:(void (^ __nullable)(void))animations AndCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView transitionWithView:self
                      duration:ANIMATION_DURATION_DEFAULT
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animations
                    completion:completion];
}

- (void)flipFromBottomTransitionWithAnimations:(void (^ __nullable)(void))animations AndCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView transitionWithView:self
                      duration:ANIMATION_DURATION_DEFAULT
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:animations
                    completion:completion];
}

- (void)viewWithAnimations:(void (^ __nullable)(void))animations AndCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:ANIMATION_DURATION_DEFAULT animations:animations completion:completion];
}

- (void)fadeInWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:ANIMATION_DURATION_FADEIN animations:^{
        [self setAlpha:1];
        [self.subviews setValue:@NO forKeyPath:@"hidden"];
    } completion:completion];
}

- (void)fadeOutWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:ANIMATION_DURATION_FADEOUT animations:^{
        [self setAlpha:0];
        [self.subviews setValue:@YES forKeyPath:@"hidden"];
    } completion:completion];
}
//
- (void)viewFadeOut_FadeIn:(UIView*)viewFadeIn {
    @try {
        [self fadeOutWithCompletion:^(BOOL finished) {
            [self setHidden:true];
            [viewFadeIn setHidden:false];
            [viewFadeIn fadeInWithCompletion:nil];
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)leftSlideWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    CGRect slideLeftFrame = self.frame;
    slideLeftFrame.origin.x = -(slideLeftFrame.size.width+0.0f);
    [UIView animateWithDuration:ANIMATION_DURATION_DEFAULT
                          delay:ANIMATION_DELAY_DEFAULT
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = slideLeftFrame;
                         [self fadeOutWithCompletion:^(BOOL finished) {
                             [self setHidden:true];
                         }];
                     } completion:completion];
}

- (void)rightSlideWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [self fadeInWithCompletion:^(BOOL finished) {
        [self setHidden:false];
        CGRect slideRightFrame = self.frame;
        slideRightFrame.origin.x = 0.0f;
        [UIView animateWithDuration:ANIMATION_DURATION_DEFAULT
                              delay:ANIMATION_DELAY_DEFAULT
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.frame = slideRightFrame;
                         } completion:completion];
    }];
}

- (void)upSlideWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    //[self fadeInWithCompletion:^(BOOL finished) {
        // set frame down to bottom first
        self.alpha = 1.0;
        CGRect slideDownFrame = self.frame;
        CGFloat tempY = 0.0;
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            tempY = heightFooterView_SmallMobile;
        } else {
            tempY = heightFooterView;
        }
        slideDownFrame.origin.y = SCREEN_HEIGHT - tempY;
        self.frame = slideDownFrame;

        // process to upslide them
        [self setHidden:false];
        CGRect slideUpFrame = self.frame;
        CGRect superViewFrame = self.superview.frame;

        if (@available(iOS 11.0, *)) {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            CGFloat bottomPadding = window.safeAreaInsets.bottom;
            slideUpFrame.origin.y = superViewFrame.size.height-(slideUpFrame.size.height+bottomPadding)-tempY;
        } else {
            slideUpFrame.origin.y = superViewFrame.size.height-slideUpFrame.size.height-tempY;
        }
        [UIView animateWithDuration:0.3f
                              delay:ANIMATION_DELAY_DEFAULT
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.frame = slideUpFrame;
                         } completion:completion];
    //}];
}

- (void)downSlideWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    CGRect slideDownFrame = self.frame;
    slideDownFrame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:ANIMATION_DURATION_DEFAULT
                          delay:ANIMATION_DELAY_DEFAULT
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = slideDownFrame;
                         [self fadeOutWithCompletion:^(BOOL finished) {
                             [self setHidden:true];
                         }];
                     } completion:completion];
}

- (void)zoomInCompletion:(void (^ __nullable)(BOOL finished))completion {
    //for zoom in
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:ANIMATION_DURATION_DEFAULT
                     animations:^{
                         self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     } completion:completion];
}

- (void)zoomOutCompletion:(void (^ __nullable)(BOOL finished))completion {
    // for zoom out
    [UIView animateWithDuration:ANIMATION_DURATION_DEFAULT
                     animations:^{
                         self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                     } completion:completion];
}

- (void)zoomInShapeCompletion:(void (^ __nullable)(BOOL finished))completion {
    //for zoom in
    [UIView animateWithDuration:0.0 animations:^{
        [self setAlpha:1];
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 0.1);
        [UIView animateWithDuration:ANIMATION_DURATION_DEFAULT
                         animations:^{
                             self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                         } completion:completion];
    }];
}

- (void)zoomOutShapeCompletion:(void (^ __nullable)(BOOL finished))completion {
    // for zoom out
    [UIView animateWithDuration:ANIMATION_DURATION_DEFAULT
                     animations:^{
                         self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 0.1);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.0 animations:^{
                             [self setAlpha:0];
                         } completion:completion];
                     }];
}

- (void)viewShapeFadeOut_FadeIn:(UIView*_Nullable)viewFadeIn {
    @try {
        [self zoomOutShapeCompletion:^(BOOL finished) {
            [self setHidden:true];
            [viewFadeIn setHidden:false];
            [viewFadeIn zoomInShapeCompletion:nil];
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Border and Color
- (void)addBorderAndRoundedCorner_Color:(UIColor*_Nullable)color BorderWidth:(CGFloat)borderWidth CornerRadius:(CGFloat)cornerRadius {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = true;
}

- (void)addBorder_Color:(UIColor*_Nullable)color BorderWidth:(CGFloat)borderWidth {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = true;
}

- (void)addRoundedCorner_CornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = true;
}

@end
