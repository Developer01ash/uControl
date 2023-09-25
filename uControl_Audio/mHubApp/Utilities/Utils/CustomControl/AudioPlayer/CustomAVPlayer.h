//
//  CustomAVPlayer.h
//  mHubApp
//
//  Created by Anshul Jain on 21/11/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSUInteger, SoundType)
{
    Click   = 0,
    Swipe   = 1,
    Beep    = 2,
};

@protocol CustomAVPlayerDelegate <NSObject>
@optional
- (void)didReceivedHardwareVolumeVideo_OldValue:(NSInteger)intOldValue NewValue:(NSInteger)intNewValue;
- (void)didReceivedHardwareVolumeAudio_OldValue:(NSInteger)intOldValue NewValue:(NSInteger)intNewValue;
@end

@interface CustomAVPlayer : NSObject {
    id <CustomAVPlayerDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
@property (nonatomic, assign) CGFloat initialVolume;
@property (nonatomic, strong) AVAudioSession * session;

//@property (strong, nonatomic) AVAudioPlayer *player;
+(instancetype) sharedInstance;
-(void) soundPlay:(SoundType)type;
//+(void)vibrate;
-(void) setHardwareVolumeControl;

@end
