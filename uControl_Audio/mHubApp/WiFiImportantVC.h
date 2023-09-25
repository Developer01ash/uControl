//
//  WiFiImportantVC.h
//  mHubApp
//
//  Created by Rave Digital on 28/01/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WiFiImportantVC : UIViewController
@property(nonatomic,strong)Hub *objSelectedDevice;
@property(nonatomic,weak)IBOutlet UILabel *lbl_heading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading1;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading2;
@property(nonatomic,weak)IBOutlet CustomButton *btn_Start;
@property(nonatomic,weak)IBOutlet CustomButton_NoBorder *btn_Advance;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint *btn_Advance_height;
@property(nonatomic) NSInteger navigateFromType;
@property(nonatomic, assign) HubModel modelType;
@end

NS_ASSUME_NONNULL_END
