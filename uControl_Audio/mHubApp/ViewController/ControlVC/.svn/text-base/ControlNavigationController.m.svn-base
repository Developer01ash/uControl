//
//  ControlNavigationController.m
//  mHubApp
//
//  Created by Anshul Jain on 22/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ControlNavigationController.h"

@interface ControlNavigationController ()

@end

@implementation ControlNavigationController

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

@end
