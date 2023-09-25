//
//  SetupTypeVC.h
//  mHubApp
//
//  Created by Anshul Jain on 09/03/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupTypeVC : UIViewController
@property(nonatomic, assign) HDASetupType setupType;
@property (strong, nonatomic) NSMutableArray *arrSearchData;

@property (weak, nonatomic) IBOutlet UILabel *lblHeaderMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *viewSetupTypeBG;
@property (weak, nonatomic) IBOutlet CustomButton *btnSetupTypeVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblSetupTypeVideo;
@property (weak, nonatomic) IBOutlet CustomButton *btnSetupTypeAudio;
@property (weak, nonatomic) IBOutlet UILabel *lblSetupTypeAudio;
@property (weak, nonatomic) IBOutlet CustomButton *btnSetupTypeVideoAudio;
@property (weak, nonatomic) IBOutlet UILabel *lblSetupTypeVideoAudio;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl;

- (IBAction)btnSetupTypeVideo_Clicked:(CustomButton *)sender;
- (IBAction)btnSetupTypeAudio_Clicked:(CustomButton *)sender;
- (IBAction)btnSetupTypeVideoAudio_Clicked:(CustomButton *)sender;
- (IBAction)pageControl_ValueChanged:(CustomPageControl *)sender;
@end
