//
//  CustomNavigationBar.m
//  mHubApp
//
//  Created by Anshul Jain on 07/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NewSetupVC.h"
#import "CustomNavigationBar.h"
#import "UIViewController+LGSideMenuController.h"

//static CGFloat const kNavigationAddHeight   = 36.0f;
static CGFloat const kInsetBottom_iPhone_Small          = -7.0f;
static CGFloat const kInsetBottomBackIcon_iPhone_Small  = 5.0f;
static CGFloat const kSubtractY_iPhone_Small            = 8.0f;
//static CGFloat const kiPhone_Small_4_5_6_height         = 64.4f;
//static CGFloat const kiPhone_Small_4_5_6_Y              = 10.0f;
static CGFloat const kiPhone_Small_4_5_6_height         = 60.0f;
static CGFloat const kiPhone_Small_4_5_6_Y              = 0.0f;

static CGFloat const kInsetBottom_iPhone_iPad           = -12.0f;
static CGFloat const kInsetBottomBackIcon_iPhone_iPad   = 0.0f;
static CGFloat const kSubtractY_iPhone_iPad             = 15.0f;
static CGFloat const kiPhone_iPad_height                = 60.0f;
static CGFloat const kiPhone_iPad_Y                     = 0.0f;

@implementation CustomNavigationBar

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize navigationBarSize = [super sizeThatFits:size];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            navigationBarSize.height = kiPhone_Small_4_5_6_height;
        } else {
            navigationBarSize.height = kiPhone_iPad_height;
        }
    return navigationBarSize;
}

- (void)setFrame:(CGRect)frame {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            frame.size.height = kiPhone_Small_4_5_6_height;
        } else {
            frame.size.height = kiPhone_iPad_height;
        }
    [super setFrame:frame];
}

- (void)layoutSubviews {
    @try {
        [super layoutSubviews];
        
        for (UIView *subview in [self subviews]) {
            //DDLogDebug(@"subview == %@", subview);
            if ([NSStringFromClass([subview class]) containsString:@"BarBackground"]) {
                CGRect subViewFrame = subview.frame;
                // DDLogDebug(@"Frame 1 == %@", NSStringFromCGRect(subViewFrame));
                subViewFrame.origin.y = 0;
                if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                    subViewFrame.size.height = kiPhone_Small_4_5_6_height;
                } else {
                    subViewFrame.size.height = kiPhone_iPad_height;
                }
                // DDLogDebug(@"Frame 2 == %@", NSStringFromCGRect(subViewFrame));
                [subview setFrame: subViewFrame];
            } else if ([NSStringFromClass([subview class]) containsString:@"BarContentView"]) {
                CGRect subViewFrame = subview.frame;
                // DDLogDebug(@"Frame 3 == %@", NSStringFromCGRect(subViewFrame));
                if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                    subViewFrame.origin.y = kiPhone_Small_4_5_6_Y;
                    subViewFrame.size.height = kiPhone_Small_4_5_6_height;
                } else {
                    subViewFrame.origin.y = kiPhone_iPad_Y;
                    subViewFrame.size.height = kiPhone_iPad_height;
                }
                // DDLogDebug(@"Frame 4 == %@", NSStringFromCGRect(subViewFrame));
                [subview setFrame: subViewFrame];
            }
        }

        ThemeColor *objTheme;
        if ([AppDelegate appDelegate].flowType == HDA_SetupFlow) {
            objTheme = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColoursSetup];;
        } else {
            objTheme = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColours];;
        }
        
        
        [[UINavigationBar appearance] setBackgroundColor: [AppDelegate appDelegate].themeColours.colorBackground];
        [[UINavigationBar appearance] setBarTintColor: [AppDelegate appDelegate].themeColours.colorBackground];
        [[UINavigationBar appearance] setTintColor:objTheme.colorHeaderText];
        [[UINavigationBar appearance] setTranslucent:false];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];
        [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage alloc]init] ];
        
        
        
        

//        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//            statusBar.backgroundColor = objTheme.colorNavigationBar;
//        }
      
        
       
        if (@available(iOS 13, *)) {
            UIView *statusBar = [[UIView alloc]initWithFrame:UIApplication.sharedApplication.keyWindow.windowScene.statusBarManager.statusBarFrame];
                statusBar.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
                       statusBar.tag = 100;
            [UIApplication.sharedApplication.keyWindow addSubview:statusBar];
           } else {
               UIView *statusBar = (UIView *)[UIApplication.sharedApplication valueForKey:@"statusBarWindow.statusBar"];
               statusBar.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
               
        }


        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, kInsetBottomBackIcon_iPhone_Small, 0);
        UIImage *backArrowImage = [kImageIconNavBack imageWithAlignmentRectInsets:insets];
    // [[UINavigationBar appearance] setBackIndicatorImage:backArrowImage];
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:objTheme.colorHeaderText, NSForegroundColorAttributeName,textFontLight20, NSFontAttributeName, nil]];
        } else {
            insets = UIEdgeInsetsMake(0, 0, kInsetBottomBackIcon_iPhone_iPad, 0);
            UIImage *backArrowImage = [kImageIconNavBack imageWithAlignmentRectInsets:insets];
            [[UINavigationBar appearance] setBackIndicatorImage:backArrowImage];
            [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:objTheme.colorHeaderText, NSForegroundColorAttributeName,textFontLight30, NSFontAttributeName, nil]];
        }

        if([UIButton respondsToSelector:@selector(appearanceWhenContainedInInstancesOfClasses:)]) {
            [[UIButton appearanceWhenContainedInInstancesOfClasses: @[UINavigationBar.class]] setTintColor:objTheme.colorHeaderText];
        }
        
        if (SYSTEM_VERSION_LESS_THAN(@"11.0")) {
//            [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backArrowImage];
            CGFloat verticalOffset = kInsetBottom_iPhone_iPad;
            if ([AppDelegate appDelegate].deviceType == mobileSmall) {
                verticalOffset = kInsetBottom_iPhone_Small;
                [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];

                UINavigationItem *navigationItem = [self topItem];
                CGFloat fltX = 0.0f;
                CGFloat fltY = 0.0f;
                CGFloat fltWidth = 0.0f;
                CGFloat fltHeight = 0.0f;
                for (UIView *subview in [self subviews]) {
                    //DDLogDebug(@"subview == %@", subview);
                    if (subview == [[navigationItem leftBarButtonItem] customView]) {
                        fltX = subview.frame.origin.x;
                        fltY = subview.frame.origin.y-kSubtractY_iPhone_Small;
                        fltHeight = 40.0f;
                        fltWidth = fltHeight*1.5;
                        CGRect newLeftButtonRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
                        [subview setFrame:newLeftButtonRect];
                    } else if (subview == [navigationItem titleView]) {
                        fltX = 80.0f;
                        fltY = 15.0f;
                        fltHeight = 40.0f;
                        fltWidth = SCREEN_WIDTH-170.0f;
                        CGRect newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
                        [subview setFrame:newTitleRect];
                    } else if (subview == [[navigationItem rightBarButtonItem] customView]) {
                        fltX = subview.frame.origin.x;
                        fltY = subview.frame.origin.y-kSubtractY_iPhone_Small;
                        fltHeight = 40.0f;
                        fltWidth = fltHeight*1.5; //1.67;
                        CGRect newRightButtonRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
                        [subview setFrame:newRightButtonRect];
                    }
                }
            } else {
                verticalOffset = kInsetBottom_iPhone_iPad;
                [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
                
                UINavigationItem *navigationItem = [self topItem];
                CGFloat fltX = 0.0f;
                CGFloat fltY = 0.0f;
                CGFloat fltWidth = 0.0f;
                CGFloat fltHeight = 0.0f;
                for (UIView *subview in [self subviews]) {
                    //DDLogDebug(@"subview == %@", subview);
                    if (subview == [[navigationItem leftBarButtonItem] customView]) {
                        fltX = subview.frame.origin.x;
                        fltY = subview.frame.origin.y-kSubtractY_iPhone_iPad;
                        fltHeight = 40.0f;
                        fltWidth = fltHeight*1.5;
                        CGRect newLeftButtonRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
                        [subview setFrame:newLeftButtonRect];
                    } else if (subview == [navigationItem titleView]) {
                        fltX = 80.0f;
                        fltY = 0.0f;
                        fltHeight = 40.0f;
                        fltWidth = SCREEN_WIDTH-170.0f;
                        CGRect newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
                        [subview setFrame:newTitleRect];
                    } else if (subview == [[navigationItem rightBarButtonItem] customView]) {
                        fltX = subview.frame.origin.x;
                        fltY = subview.frame.origin.y-kSubtractY_iPhone_iPad;
                        fltHeight = 40.0f;
                        fltWidth = fltHeight*1.5; //1.67;
                        CGRect newRightButtonRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
                        [subview setFrame:newRightButtonRect];
                    }
                }
            }
        }
        
        
        
        

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}



+(UIView *)customNavigationLabel:(NSString*)strTitle {
    CGRect newTitleRect;
    CGFloat fltX = 0.0f;
    CGFloat fltY = 0.0f;
    CGFloat fltWidth = 0.0f;
    CGFloat fltHeight = 0.0f;
    
    if (IS_IPAD) {
        fltHeight = kiPhone_iPad_height;
        //fltWidth = SCREEN_WIDTH-170.0f; //fltHeight*14.5;
        fltWidth = SCREEN_WIDTH; //fltHeight*14.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    } else {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            fltHeight = kiPhone_Small_4_5_6_height;
        } else {
            fltHeight = kiPhone_iPad_height;
        }
        fltWidth = SCREEN_WIDTH; //fltHeight*7.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    }
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, fltY, fltWidth, fltHeight)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.backgroundColor = colorClear;
    lbNavTitle.textColor = colorWhite;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        lbNavTitle.font = textFontLight18;
    } else {
        lbNavTitle.font = textFontLight22;
    }
    lbNavTitle.numberOfLines = 1;
    lbNavTitle.minimumScaleFactor = 8/lbNavTitle.font.pointSize;
    lbNavTitle.adjustsFontSizeToFitWidth = YES;
    lbNavTitle.text = NSLocalizedString(strTitle, @"");
    
    UIView * view = [[UIView alloc] initWithFrame:newTitleRect];
    //view.backgroundColor = UIColor.yellowColor;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 13, 32, 32);
    UIImage * landscapeImage = kImageIconNextArrow;
    UIImage * portraitImage = [[UIImage alloc] initWithCGImage: landscapeImage.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationDown];
    [btn setImage:portraitImage forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:false];
   // [btn addTarget:[AppDelegate appDelegate] action:@selector(btnSendComment_pressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnClick_BiggerArea = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClick_BiggerArea.frame = CGRectMake(0, 0, 64, 64);
    [btnClick_BiggerArea addTarget:[AppDelegate appDelegate]
            action:@selector(btnSendComment_pressed)
         forControlEvents:UIControlEventTouchUpInside];
    UIView * viewBorder;
    
    if (IS_IPAD) {
        viewBorder = [[UIView alloc] initWithFrame:CGRectMake(5, fltHeight-5, SCREEN_WIDTH-35, 1)];
    }
    else
    {
        viewBorder = [[UIView alloc] initWithFrame:CGRectMake(5, fltHeight-1, SCREEN_WIDTH-35, 1)];
    }
    
    viewBorder.backgroundColor = colorGunGray_272726;
    
    [view addSubview:lbNavTitle];
    [view addSubview:btnClick_BiggerArea];
    [view addSubview:btn];
    [view addSubview:viewBorder];
//    <UIView: 0x7fd9ec489680; frame = (5 56; 775 4); layer = <CALayer: 0x60000055d860>>
//    <UIView: 0x7fd9ec48a700; frame = (5 56; 775 4); layer = <CALayer: 0x6000001c8fe0>>
//
    return view;
}

+(UIView *)customNavigationLabelWITHOUT_BackArrow:(NSString*)strTitle {
    CGRect newTitleRect;
    CGFloat fltX = 0.0f;
    CGFloat fltY = 0.0f;
    CGFloat fltWidth = 0.0f;
    CGFloat fltHeight = 0.0f;
    
    if (IS_IPAD) {
        fltHeight = kiPhone_iPad_height;
        //fltWidth = SCREEN_WIDTH-170.0f; //fltHeight*14.5;
        fltWidth = SCREEN_WIDTH; //fltHeight*14.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    } else {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            fltHeight = kiPhone_Small_4_5_6_height;
        } else {
            fltHeight = kiPhone_iPad_height;
        }
        fltWidth = SCREEN_WIDTH; //fltHeight*7.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    }
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, fltY, fltWidth, fltHeight)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.backgroundColor = colorClear;
    lbNavTitle.textColor = colorWhite;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        lbNavTitle.font = textFontLight18;
    } else {
        lbNavTitle.font = textFontLight22;
    }
    lbNavTitle.numberOfLines = 1;
    lbNavTitle.minimumScaleFactor = 8/lbNavTitle.font.pointSize;
    lbNavTitle.adjustsFontSizeToFitWidth = YES;
    lbNavTitle.text = NSLocalizedString(strTitle, @"");
    
    UIView * view = [[UIView alloc] initWithFrame:newTitleRect];
    //view.backgroundColor = UIColor.yellowColor;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 13, 32, 32);
    UIImage * landscapeImage = kImageIconNextArrow;
    UIImage * portraitImage = [[UIImage alloc] initWithCGImage: landscapeImage.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationDown];
    [btn setImage:portraitImage forState:UIControlStateNormal];
    [btn addTarget:[AppDelegate appDelegate]
            action:@selector(btnSendComment_pressed)
         forControlEvents:UIControlEventTouchUpInside];
    UIView * viewBorder;
    
    if (IS_IPAD) {
        viewBorder = [[UIView alloc] initWithFrame:CGRectMake(5, fltHeight-4, SCREEN_WIDTH-35, 4)];
    }
    else
    {
        viewBorder = [[UIView alloc] initWithFrame:CGRectMake(5, fltHeight-1, SCREEN_WIDTH-35, 1)];
    }
    
    viewBorder.backgroundColor = colorGunGray_272726;
    
    [view addSubview:lbNavTitle];
  //  [view addSubview:btn];
   // [view addSubview:viewBorder];

    return view;
}



+(UILabel*)customNavigationLabel_LeftAlign:(NSString*)strTitle {
    CGRect newTitleRect;
    CGFloat fltX = 0.0f;
    CGFloat fltY = 0.0f;
    CGFloat fltWidth = 0.0f;
    CGFloat fltHeight = 0.0f;
    
    if (IS_IPAD) {
        fltHeight = kiPhone_iPad_height;
        fltWidth = SCREEN_WIDTH-65.0f; //fltHeight*14.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    } else {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            fltHeight = kiPhone_Small_4_5_6_height;
        } else {
            fltHeight = kiPhone_iPad_height;
        }
        fltWidth = SCREEN_WIDTH-45.0f; //fltHeight*7.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    }
    // DDLogDebug(@"customNavigationLabel frame == %@", NSStringFromCGRect(newTitleRect));

    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:newTitleRect];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.backgroundColor = colorClear;
    lbNavTitle.textColor = [AppDelegate appDelegate].themeColours.colorHeaderText;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        lbNavTitle.font = textFontLight18;
    } else {
        lbNavTitle.font = textFontLight22;
    }
    lbNavTitle.numberOfLines = 1;
    lbNavTitle.minimumScaleFactor = 8/lbNavTitle.font.pointSize;
    lbNavTitle.adjustsFontSizeToFitWidth = YES;
    lbNavTitle.text = NSLocalizedString(strTitle, @"");
    return lbNavTitle;
}

+(UIView *)customNavigationLabelSettings:(NSString*)strTitle {
    CGRect newTitleRect;
    CGFloat fltX = 0.0f;
    CGFloat fltY = 0.0f;
    CGFloat fltWidth = 0.0f;
    CGFloat fltHeight = 0.0f;
    
    if (IS_IPAD) {
        fltHeight = kiPhone_iPad_height;
        //fltWidth = SCREEN_WIDTH-170.0f; //fltHeight*14.5;
        fltWidth = SCREEN_WIDTH; //fltHeight*14.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    } else {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            fltHeight = kiPhone_Small_4_5_6_height;
        } else {
            fltHeight = kiPhone_iPad_height;
        }
        fltWidth = SCREEN_WIDTH; //fltHeight*7.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    }
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, fltY, fltWidth, fltHeight)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.backgroundColor = colorClear;
    lbNavTitle.textColor = colorWhite;
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        lbNavTitle.font = textFontLight18;
    } else {
        lbNavTitle.font = textFontLight22;
    }
    lbNavTitle.numberOfLines = 1;
    lbNavTitle.minimumScaleFactor = 8/lbNavTitle.font.pointSize;
    lbNavTitle.adjustsFontSizeToFitWidth = YES;
    lbNavTitle.text = NSLocalizedString(strTitle, @"");
    
    UIView * view = [[UIView alloc] initWithFrame:newTitleRect];
    //view.backgroundColor = UIColor.yellowColor;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 13, 32, 32);
    [btn setUserInteractionEnabled:false];
    UIImage * landscapeImage = kImageIconNextArrow;
    UIImage * portraitImage = [[UIImage alloc] initWithCGImage: landscapeImage.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationDown];
    [btn setImage:portraitImage forState:UIControlStateNormal];
    //[btn addTarget:[AppDelegate appDelegate] action:@selector(btnSendComment_pressed2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnClick_BiggerArea = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClick_BiggerArea.frame = CGRectMake(0, 0, 64, 64);
    [btnClick_BiggerArea addTarget:[AppDelegate appDelegate]
            action:@selector(btnSendComment_pressed2)
         forControlEvents:UIControlEventTouchUpInside];
    UIView * viewBorder;
    
    if (IS_IPAD) {
        viewBorder = [[UIView alloc] initWithFrame:CGRectMake(5, fltHeight-4, SCREEN_WIDTH-35, 4)];

    }
    else
    {
        viewBorder = [[UIView alloc] initWithFrame:CGRectMake(5, fltHeight-1, SCREEN_WIDTH-35, 1)];
    }
    
    viewBorder.backgroundColor = colorGunGray_272726;
    
    [view addSubview:lbNavTitle];
    [view addSubview:btnClick_BiggerArea];
    [view addSubview:btn];
    [view addSubview:viewBorder];

    return view;
}




+(UIView *)customNavigationLabelControlView:(NSString*)strTitle {
    CGRect newTitleRect;
    //    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
    CGFloat fltX = 0.0f;
    CGFloat fltY = 0.0f;
    CGFloat fltWidth = 0.0f;
    CGFloat fltHeight = 0.0f;
    if (IS_IPAD) {
        //fltY = 28.0f;
        fltHeight = heightFooterView;
        fltWidth = SCREEN_WIDTH-200.0f; //fltHeight*14.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    } else {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            fltHeight = kiPhone_Small_4_5_6_height;
        } else {
            fltHeight = kiPhone_iPad_height;
        }
        fltWidth = SCREEN_WIDTH-180.0f; //fltHeight*7.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    }
    //    } else {
    //        newTitleRect = CGRectZero;
    //    }

    // DDLogDebug(@"customNavigationLabelControlView frame == %@", NSStringFromCGRect(newTitleRect));
    
    UIView * view = [[UIView alloc] initWithFrame:newTitleRect];
    
    //view.backgroundColor =  UIColor.yellowColor;
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(-120, fltY, fltWidth, 44)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
   // lbNavTitle.backgroundColor =  UIColor.redColor;
    //lbNavTitle.textColor = [AppDelegate appDelegate].themeColours.colorHeaderText;
    lbNavTitle.textColor = UIColor.whiteColor;
    [view setUserInteractionEnabled:false];
    [lbNavTitle setUserInteractionEnabled:false];

    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        lbNavTitle.font = textFontLight18;
    } else {
        lbNavTitle.font = textFontLight22;
    }
    lbNavTitle.numberOfLines = 1;
    lbNavTitle.minimumScaleFactor = 8/lbNavTitle.font.pointSize;
    lbNavTitle.adjustsFontSizeToFitWidth = YES;
    lbNavTitle.text = NSLocalizedString(strTitle, @"");
    [view addSubview:lbNavTitle];
    return view;
}
+(UIButton *)customNavigationButtonControlView:(NSString*)strTitle {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(tapGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:strTitle forState:UIControlStateNormal];
    CGRect newTitleRect;
    button.backgroundColor = [UIColor greenColor];
    //    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
    CGFloat fltX = 0.0f;
    CGFloat fltY = 0.0f;
    CGFloat fltWidth = 0.0f;
    CGFloat fltHeight = 0.0f;
    if (IS_IPAD) {
        //fltY = 28.0f;
        fltHeight = heightFooterView;
        fltWidth = SCREEN_WIDTH-350.0f; //fltHeight*14.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    } else {
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            fltHeight = kiPhone_Small_4_5_6_height;
        } else {
            fltHeight = kiPhone_iPad_height;
        }
        fltWidth = SCREEN_WIDTH-180.0f; //fltHeight*7.5;
        newTitleRect = CGRectMake(fltX, fltY, fltWidth, fltHeight);
    }
    button.frame = newTitleRect;
   // [view addSubview:button];
    return button;
}

#pragma mark - UIGestureRecognizers
- (void)tapGesture:(UIButton *)gesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadLeftMenu object:self userInfo:nil];
}

@end
