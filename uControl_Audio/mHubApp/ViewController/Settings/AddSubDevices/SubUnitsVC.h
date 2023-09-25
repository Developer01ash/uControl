//
//  SubUnitsVC.h
//  mHubApp
//
//  Created by Apple on 28/01/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubUnitsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, retain) SectionSetting *selectedSetting;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;
@end

NS_ASSUME_NONNULL_END
