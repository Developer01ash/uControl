//
//  OutputControlVC.h
//  mHubApp
//
//  Created by Anshul Jain on 22/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OutputControlDelegate <NSObject>
@optional
- (void)didReceivedReloadAudioDevice:(ControlDeviceType)deviceType;
- (void)didReceivedReloadGroupVolume:(ControlDeviceType)deviceType;
- (void)didReceivedTapOnGroupVolumeMuteButton:(BOOL)sender;
- (void)didReceivedSliderAudioVolumeValueChanged_Previous:(NSInteger)intPValue New:(NSInteger)intNValue;
@end



@interface OutputControlVC : UIViewController<UIGestureRecognizerDelegate> {
    id <OutputControlDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

@end
