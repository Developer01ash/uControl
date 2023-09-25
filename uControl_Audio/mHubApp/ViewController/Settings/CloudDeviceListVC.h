//
//  CloudDeviceListVC.h
//  mHubApp
//
//  Created by Anshul Jain on 26/04/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloudDeviceListVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblCloudData;
@property (nonatomic, retain) NSMutableArray *arrData;
@property (nonatomic, retain) NSMutableDictionary *dictParameter;

@end
