//
//  ZoneMenuCollectionReusableView.h
//  mHubApp
//
//  Created by Apple on 24/06/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZoneMenuCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *viewBorder;
@property (weak, nonatomic) IBOutlet CustomButton *btn_footer;
@end

NS_ASSUME_NONNULL_END
