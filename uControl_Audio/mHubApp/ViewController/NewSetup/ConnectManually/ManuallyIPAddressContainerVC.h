//
//  ManuallyIPAddressContainerVC.h
//  mHubApp
//
//  Created by Anshul Jain on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManuallyIPAddressContainerDelegate <NSObject>
@optional
- (void) animateView:(BOOL)isUp;
- (void) setIPAddress:(NSString*)strAddress;
@end

@interface ManuallyIPAddressContainerVC : UIViewController{
    id <ManuallyIPAddressContainerDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtIPPart1;
@property (weak, nonatomic) IBOutlet UITextField *txtIPPart2;
@property (weak, nonatomic) IBOutlet UITextField *txtIPPart3;
@property (weak, nonatomic) IBOutlet UITextField *txtIPPart4;

@end
