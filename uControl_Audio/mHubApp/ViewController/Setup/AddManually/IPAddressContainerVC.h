//
//  IPAddressContainerVC.h
//  mHubApp
//
//  Created by Yashica Agrawal on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPAddressContainerDelegate <NSObject>

@optional
- (void) animateView:(BOOL)isUp;
@end

@interface IPAddressContainerVC : UIViewController{
    id <IPAddressContainerDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtIPPart1;
@property (weak, nonatomic) IBOutlet UITextField *txtIPPart2;
@property (weak, nonatomic) IBOutlet UITextField *txtIPPart3;
@property (weak, nonatomic) IBOutlet UITextField *txtIPPart4;

@end
