//
//  ListOfProfileDevicesVC.h
//  mHubApp
//
//  Created by Apple on 29/01/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListOfProfileDevicesVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) Hub *objSelectedMHubDevice;

@end

NS_ASSUME_NONNULL_END
