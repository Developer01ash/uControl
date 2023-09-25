//
//  MainViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 25.04.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

/**
 This VC is used from library Sample LGSideMenuControllerDemo. This is the base class of the SideMenu For Both Class OutputDeviceVC or LeftPanelDisplayDeviceVC.
 In this class, property like leftpanel width according to iOS device resolution and background colour according to theme are assigning.
 Functionality like Hide/Show LeftPanel also handle by this class.
 */

#import "MainViewController.h"
#import "SplashVC.h"
#import "OutputDeviceVC.h"
#import "LeftPanelDisplayDeviceVC.h"
#import "AppDelegate.h"

@interface MainViewController ()

@property (strong, nonatomic) OutputDeviceVC *leftViewController;
@property (strong, nonatomic) LeftPanelDisplayDeviceVC *leftViewControllerSSDP;
@property (assign, nonatomic) NSUInteger type;

@end

@implementation MainViewController

- (void)setupWithPresentationStyle:(LGSideMenuPresentationStyle)style
                              type:(NSUInteger)type
{
    if ([mHubManagerInstance.objSelectedHub isUControlSupport]){
        UIStoryboard *storyboard = controlStoryboard;
        _leftViewController = [storyboard instantiateViewControllerWithIdentifier:@"OutputDeviceVC"];
    } else {
        UIStoryboard *storyboard = settingsStoryboard;
        _leftViewControllerSSDP = [storyboard instantiateViewControllerWithIdentifier:@"LeftPanelDisplayDeviceVC"];
    }

        // -----
//    if ([AppDelegate appDelegate].deviceType == tabletLarge) {
//        CGFloat width = SCREEN_WIDTH/3;
//        [self setLeftViewEnabledWithWidth:width
//                        presentationStyle:LGSideMenuPresentationStyleSlideBelow
//                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnPadLandscape];
//
//    } else {
//        CGFloat width = SCREEN_WIDTH/2;
//        [self setLeftViewEnabledWithWidth:(width < 250.0f ? 250.0f : width)
//                        presentationStyle:style
//                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];
//    }

    CGFloat width = SCREEN_WIDTH;
    CGFloat width_half = SCREEN_WIDTH/2;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        width = width-heightFooterView_SmallMobile;
    } else {
        width = width-heightFooterView;
    }
    
    [self setLeftViewEnabledWithWidth:(width > 400.0f ? width_half : width)
                    presentationStyle:style
                 alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];
    
    self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
    self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;
    self.leftViewBackgroundColor = [AppDelegate appDelegate].themeColours.colorOutputBackground;
    self.leftViewBackgroundImage = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorOutputBackground Frame:self.leftView.frame];

    if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
        _leftViewController.tableView.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputBackground;
        // -----
        [_leftViewController.tableView reloadData];
        [self.leftView addSubview:_leftViewController.view];
    } else {
        _leftViewControllerSSDP.tableView.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputBackground;
        // -----
        [_leftViewControllerSSDP.tableView reloadData];
        [self.leftView addSubview:_leftViewControllerSSDP.view];
    }
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];
    if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
        if (![UIApplication sharedApplication].isStatusBarHidden && (_type == 2 || _type == 3))
            _leftViewController.view.frame = CGRectMake(0.f , 20.f, size.width, size.height-20.f);
        else
            _leftViewController.view.frame = CGRectMake(0.f , 0.f, size.width, size.height);
    } else {
        if (![UIApplication sharedApplication].isStatusBarHidden && (_type == 2 || _type == 3))
            _leftViewControllerSSDP.view.frame = CGRectMake(0.f , 20.f, size.width, size.height-20.f);
        else
            _leftViewControllerSSDP.view.frame = CGRectMake(0.f , 0.f, size.width, size.height);
    }
}

@end
