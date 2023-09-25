//
//  ControlTypeVC.h
//  mHubApp
//
//  Created by Anshul Jain on 22/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControlTypeDelegate <NSObject>
@optional
- (void)didReceivedTapOnControlTypeButton:(NSString *)strButtonInfo;
@end

@interface ControlTypeVC : UIViewController {
    id <ControlTypeDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
@property (strong, nonatomic) NSString *strButtonInfo;

@end
