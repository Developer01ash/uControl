//
//  CustomNavigationBar.h
//  mHubApp
//
//  Created by Anshul Jain on 07/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGSideMenuController.h"

@interface CustomNavigationBar : UINavigationBar<UIGestureRecognizerDelegate>
+(UIView *)customNavigationLabel:(NSString*)strTitle;
+(UIView *)customNavigationLabelSettings:(NSString*)strTitle;
+(UIView *)customNavigationLabelControlView:(NSString*)strTitle;
+(UIButton *)customNavigationButtonControlView:(NSString*)strTitle ;
+(UIBarButtonItem *)customRightButtonControlView:(NSString*)strTitle;
+(UIBarButtonItem *)customLeftButtonControlView:(NSString*)strTitle;
+(UILabel*)customNavigationLabel_LeftAlign:(NSString*)strTitle;
+(UIView *)customNavigationLabelWITHOUT_BackArrow:(NSString*)strTitle;
+(void)navigationBarWithLeftRightButtons;
@end
