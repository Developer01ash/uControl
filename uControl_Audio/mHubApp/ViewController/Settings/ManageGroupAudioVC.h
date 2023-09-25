//
//  ManageGroupAudioVC.h
//  mHubApp
//
//  Created by Anshul Jain on 22/01/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ActionType) {
    Insert  = 0,
    Update  = 1,
    Delete  = 2
};

@interface ManageGroupAudioVC : UIViewController
@property(nonatomic, retain) SectionSetting *selectedSetting;
@property(nonatomic, retain) Group *objGroup;
@end
