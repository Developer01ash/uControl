//
//  UpdateHubViewController.h
//  mHubApp
//
//  Created by Rave on 04/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateHubViewController : UIViewController
{
    NSMutableArray *mArr_upgradeDetails;
    NSDictionary *dict_upgradeDetails;
}
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblSubHeaderMessage;
@property (weak, nonatomic) IBOutlet UILabel *lbl_checkingHubUpdate;
@property (weak, nonatomic) IBOutlet UIImageView *img_mhub;
@property (weak, nonatomic) IBOutlet CustomButton *updateMhub;
@property (weak, nonatomic) IBOutlet CustomButton *gotoMenu;
@property (weak, nonatomic) IBOutlet UIView *view_checkingUpdates;
@property (strong, nonatomic) NSMutableArray *arrSearchData;
@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property(nonatomic) NSInteger navigateFromType;

@property (strong, nonatomic) Hub *objSelectedMHubDevice_ForSetupConfirmation;
@property (assign, nonatomic) BOOL isSelectedPaired_ForSetupConfirmation;
@property (strong, nonatomic) NSMutableArray <Hub*>*arrSelectedSlaveDevice_ForSetupConfirmation;

@end

NS_ASSUME_NONNULL_END
