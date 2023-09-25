//
//  AddLabelsVC.h
//  mHubApp
//
//  Created by Anshul Jain on 02/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, LabelType)
{
    Display = 0,
    Source  = 1,
};

@interface AddLabelsVC : UIViewController
@property(nonatomic) LabelType labelType;
@end
