//
//  ContinueOnuOSVC.h
//  mHubApp
//
//  Created by Rave Digital on 23/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContinueOnuOSVC : UIViewController
@property (weak, nonatomic) IBOutlet LabelHeader *lblHeader;
@property (weak, nonatomic) IBOutlet LabelSubHeader *lblSubHeader;
@property (weak, nonatomic) IBOutlet CustomButton *btnContinue;
@property (strong, nonatomic) Hub *masterDevice;
@property (strong, nonatomic) NSMutableArray <Hub*>*arr_devices;
@end

NS_ASSUME_NONNULL_END
