//
//  SubSettingsVC.h
//  mHubApp
//
//  Created by Anshul Jain on 03/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SettingType)
{
    mHubSystemPro,
    mHubSystemV3,
    AddLabels,
    CloudAccount,
    UControlSettings,
};

@interface SubSettingsVC : UIViewController
//@property(nonatomic) SettingType settingType;
@property(nonatomic, retain) SectionSetting *selectedSetting;
@end
