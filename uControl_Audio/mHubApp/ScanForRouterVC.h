//
//  ScanForRouterVC.h
//  mHubApp
//
//  Created by Ashutosh Tiwari on 20/12/19.
//  Copyright © 2019 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanForRouterVC : UIViewController
{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tblRouterWifiList;
@property(nonatomic,weak)IBOutlet CustomButton *btn_cancelScan;
@property(nonatomic,weak)IBOutlet UILabel *lbl_heading;
@property(nonatomic,weak)IBOutlet UILabel *lbl_subHeading;


@end

NS_ASSUME_NONNULL_END
