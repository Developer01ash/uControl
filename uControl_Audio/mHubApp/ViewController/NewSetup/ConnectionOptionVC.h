//
//  ConnectionOptionVC.h
//  mHubApp
//
//  Created by Anshul Jain on 09/03/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionOptionVC : UIViewController
@property(nonatomic, assign) HDASetupType setupType;
@property (strong, nonatomic) NSMutableArray *arrSearchData;

@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UILabel *systemTypeToBuild;

@property (weak, nonatomic) IBOutlet UILabel *typeMsg;

@property (weak, nonatomic) IBOutlet UIView *viewConnectionTypeBG;
@property (weak, nonatomic) IBOutlet CustomButton *btnConnectionType;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITableView *tblConnectionOption;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTblConnectionOption;

- (IBAction)btnConnectionType_Clicked:(CustomButton *)sender;
- (IBAction)pageControl_ValueChanged:(CustomPageControl *)sender;

@end
