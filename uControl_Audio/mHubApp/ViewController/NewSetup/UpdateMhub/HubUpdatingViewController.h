//
//  HubUpdatingViewController.h
//  mHubApp
//
//  Created by Rave on 12/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HubUpdatingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgHubDevice;
@property (weak, nonatomic) IBOutlet UILabel *lbl_HubVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblSubHeaderMessage;
@property (weak, nonatomic) IBOutlet UIView *view_roundView;
@property (weak, nonatomic) IBOutlet UIImageView *img_loadingProgress;
@property (weak, nonatomic) IBOutlet CustomButton *btn_finished;
@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property (strong, nonatomic) NSMutableArray *arr_allAvailableHubsForUpdate;
@property(nonatomic) NSInteger navigateFromType;
@property (strong, nonatomic) NSString *latestOSVersion;


@property (strong, nonatomic) Hub *objSelectedMHubDevice_ForSetupConfirmation;
@property (assign, nonatomic) BOOL isSelectedPaired_ForSetupConfirmation;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrSelectedSlaveDevice_ForSetupConfirmation;

@property ( nonatomic) bool isSingleUnit;
@end

NS_ASSUME_NONNULL_END
