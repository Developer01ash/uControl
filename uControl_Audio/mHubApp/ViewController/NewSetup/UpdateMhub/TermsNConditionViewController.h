//
//  TermsNConditionViewController.h
//  mHubApp
//
//  Created by Rave on 06/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TermsNConditionViewController : UIViewController<UINavigationControllerDelegate, SFSafariViewControllerDelegate>
@property (strong, nonatomic) NSMutableArray *arrSearchData;
@property (weak, nonatomic) IBOutlet CustomButton *btn_Iagree;
@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property (nonatomic,weak)IBOutlet UIView *viewLegal;
@property (nonatomic,weak)IBOutlet UIView *viewPolicy;
@property (nonatomic,weak)IBOutlet UIView *viewLog;
@property (nonatomic,weak)IBOutlet UILabel *heading;
@property (nonatomic,weak)IBOutlet UILabel *subHeading;
@property(nonatomic) NSInteger navigateFromType;
@property (strong, nonatomic) NSString *latestOSVersion;
@property ( nonatomic) bool isSingleUnit;

@property (strong, nonatomic) Hub *objSelectedMHubDevice_ForSetupConfirmation;
@property (assign, nonatomic) BOOL isSelectedPaired_ForSetupConfirmation;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrSelectedSlaveDevice_ForSetupConfirmation;


@end

NS_ASSUME_NONNULL_END
