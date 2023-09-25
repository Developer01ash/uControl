//
//  UIView+Additional.h
//  mHubApp
//
//  Created by Anshul Jain on 20/12/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additional)
- (void)crossDissolveTransitionWithAnimations:(void (^ __nullable)(void))animations AndCompletion:(void (^ __nullable)(BOOL finished))completion;
- (void)flipFromBottomTransitionWithAnimations:(void (^ __nullable)(void))animations AndCompletion:(void (^ __nullable)(BOOL finished))completion;

- (void)viewWithAnimations:(void (^ __nullable)(void))animations AndCompletion:(void (^ __nullable)(BOOL finished))completion;

- (void)fadeInWithCompletion:(void (^ __nullable)(BOOL finished))completion;
- (void)fadeOutWithCompletion:(void (^ __nullable)(BOOL finished))completion;
- (void)viewFadeOut_FadeIn:(UIView*_Nullable)viewFadeIn;

- (void)leftSlideWithCompletion:(void (^ __nullable)(BOOL finished))completion;
- (void)rightSlideWithCompletion:(void (^ __nullable)(BOOL finished))completion;
- (void)upSlideWithCompletion:(void (^ __nullable)(BOOL finished))completion;
- (void)downSlideWithCompletion:(void (^ __nullable)(BOOL finished))completion;

- (void)zoomInCompletion:(void (^ __nullable)(BOOL finished))completion;
- (void)zoomOutCompletion:(void (^ __nullable)(BOOL finished))completion;

- (void)zoomInShapeCompletion:(void (^ __nullable)(BOOL finished))completion;
- (void)zoomOutShapeCompletion:(void (^ __nullable)(BOOL finished))completion;
- (void)viewShapeFadeOut_FadeIn:(UIView*_Nullable)viewFadeIn;

- (void)addBorderAndRoundedCorner_Color:(UIColor*_Nullable)color BorderWidth:(CGFloat)borderWidth CornerRadius:(CGFloat)cornerRadius;
- (void)addBorder_Color:(UIColor*_Nullable)color BorderWidth:(CGFloat)borderWidth;
- (void)addRoundedCorner_CornerRadius:(CGFloat)cornerRadius;
@end
