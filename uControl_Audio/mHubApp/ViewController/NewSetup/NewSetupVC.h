//
//  NewSetupVC.h
//  mHubApp
//
//  Created by Anshul Jain on 26/02/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"

@interface NewSetupVC : UIViewController
{
    CLLocationManager  *locationManager;
}
@property (weak, nonatomic) IBOutlet UIView *viewLogoBG;
@property (weak, nonatomic) IBOutlet UIImageView *imgHDALogo;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UILabel *lbl_appVersion;

@property (weak, nonatomic) IBOutlet UIView *viewTable;
@property (weak, nonatomic) IBOutlet UITableView *tblSetup;
@property (weak, nonatomic) IBOutlet UITableView *tblSetupManual;
@property (weak, nonatomic) IBOutlet UIImageView *imgDeviceLogo;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightSetupManualConstraint;

@property (nonatomic, retain) NSMutableArray *arrDataSearch;
@property (nonatomic, retain) NSMutableArray *arrDataManual;

- (IBAction)pageControl_ValueChanged:(CustomPageControl *)sender;

@end
