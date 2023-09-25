//
//  SetupConfirmationVC.h
//  mHubApp
//
//  Created by Anshul Jain on 20/03/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SafariServices;

@interface SetupConfirmationVC : UIViewController<SFSafariViewControllerDelegate> {
    SFSafariViewController *safariVC;
    NSMutableArray *arrConfirmationData;
}

@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property (assign, nonatomic) BOOL isSelectedPaired;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrSelectedSlaveDevice;

@property (weak, nonatomic) IBOutlet UIView *viewConfirmationStatusBG;
@property (weak, nonatomic) IBOutlet CustomButton *btnConfirmationStatus;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITableView *tblConfirmationOption;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblConfirmationOption;
@property (weak, nonatomic) IBOutlet UIView *viewRebootMasterController;
@property (weak, nonatomic) IBOutlet LabelHeader *lblHeader;
@property (weak, nonatomic) IBOutlet LabelSubHeader *lblSubHeader;
@property (weak, nonatomic) IBOutlet CustomButton *btnContinueAfterReboot;
- (IBAction)btnConfirmationStatus_Clicked:(CustomButton *)sender;
- (IBAction)pageControl_ValueChanged:(CustomPageControl *)sender;
@end
