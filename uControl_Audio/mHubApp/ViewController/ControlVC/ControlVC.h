//
//  ControlVC.h
//  mHubApp
//
//  Created by Anshul Jain on 21/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGSideMenuController.h"
#import "GroupContainerVC.h"
#import "ControlTypeVC.h"
#import "OutputControlVC.h"
#import "ControlGroupBGVC.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface ControlVC : UIViewController <UIGestureRecognizerDelegate, SearchDataManagerDelegate,WCSessionDelegate> {
    NSMutableArray *arrPowerControlCommand;
   
}
@property (strong, nonatomic) WCSession *wc_session;
@property (weak, nonatomic) IBOutlet UIButton *btnRightBarButton;
@property (weak, nonatomic) IBOutlet UIButton *btnLeftBarButton;

@property (weak, nonatomic) IBOutlet UIView *vcInputControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightInputControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintInputControlHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintInputControlTopConstant;

@property (weak, nonatomic) IBOutlet UIView *vcSourceControl;

@property (weak, nonatomic) IBOutlet UIView *viewOpaquePower;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewOpaqueTopConstant;

@property (weak, nonatomic) IBOutlet UITableView *tblPowerControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintTblPowerControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPowerControlTopConstant;

- (IBAction)btnRightNavBar_Clicked:(id)sender;

@end
