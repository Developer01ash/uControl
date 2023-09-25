//
//  BuildAStackVC.h
//  mHubApp
//
//  Created by Rave Digital on 01/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SafariServices;

NS_ASSUME_NONNULL_BEGIN

@interface BuildAStackVC : UIViewController<SFSafariViewControllerDelegate,SFSafariViewControllerDelegate>
{
    SFSafariViewController *safariVC;
}
@property (weak, nonatomic) IBOutlet LabelHeader *lblHeader;
@property (weak, nonatomic) IBOutlet LabelSubHeader *lblSubHeader;
@property (weak, nonatomic) IBOutlet CustomButton *btnStart;
@property (weak, nonatomic) IBOutlet CustomButton_NoBorder *btnHelp;
@property (strong, nonatomic) NSMutableArray <SearchData*>*arrSearchData;


@end

NS_ASSUME_NONNULL_END
