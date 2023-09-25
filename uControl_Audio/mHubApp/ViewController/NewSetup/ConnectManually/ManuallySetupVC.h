//
//  ManuallySetupVC.h
//  mHubApp
//
//  Created by Anshul Jain on 27/03/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WifiSubMenuVC.h"

@interface ManuallySetupVC : UIViewController<UINavigationBarDelegate,WKNavigationDelegate,WKUIDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblManuallySetup;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblManuallySetup;
@property (strong, nonatomic) IBOutlet CustomButton *btn_footer;
@property (strong, nonatomic) IBOutlet UIButton *btn_ConnectManually;
@property ( nonatomic) bool isOpeningFromInsideTheMainUI;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_heightFooterBtn_EnterDemo;

@end
