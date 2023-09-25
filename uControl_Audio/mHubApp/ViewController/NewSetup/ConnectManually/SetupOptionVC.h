//
//  SetupOptionVC.h
//  mHubApp
//
//  Created by Apple on 13/04/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetupOptionVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblManuallySetup;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblManuallySetup;
@property ( nonatomic) bool isOpeningFromInsideTheMainUI;
@property(nonatomic) NSInteger navigateFromType;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_heightFooterBtn_EnterDemo;
@end

NS_ASSUME_NONNULL_END
