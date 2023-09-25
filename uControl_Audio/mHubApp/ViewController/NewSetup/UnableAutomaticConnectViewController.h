//
//  UnableAutomaticConnectViewController.h
//  mHubApp
//
//  Created by Rave on 20/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnableAutomaticConnectViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *arrSearchData;
@property (weak, nonatomic) IBOutlet CustomButton *btn_ConnectManually;
@property (weak, nonatomic) IBOutlet UILabel  *lbl_instructionToConnect;
@property (weak, nonatomic) IBOutlet CustomButton *btn_searchAgain;
@property (strong, nonatomic) Hub *objSelectedMHubDevice;
@property (weak, nonatomic) IBOutlet UIView *view_roundView;
@property (weak, nonatomic) IBOutlet UIImageView *img_questionMark;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_heightCenterUIView;
@end

NS_ASSUME_NONNULL_END
