//
//  CustomAVPlayer.m
//  mHubApp
//
//  Created by Anshul Jain on 21/11/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "CustomAVPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

static NSString *const sessionVolumeKeyPath = @"outputVolume";
static void *sessionContext                 = &sessionContext;

@implementation CustomAVPlayer

+(instancetype) sharedInstance {
    static CustomAVPlayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CustomAVPlayer alloc] init];
    });
    return sharedInstance;
}

-(void) soundPlay:(SoundType)type {
    @try {
        AudioServicesPlaySystemSound(1104);
        if ([AppDelegate appDelegate].themeColours.isButtonVibration) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) vibrate {
    if ([AppDelegate appDelegate].themeColours.isButtonVibration) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark - Hardware Volume Control
-(void) setHardwareVolumeControl {
    @try {
        NSError *error = nil;
        self.session = [AVAudioSession sharedInstance];
        
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
       

//        MPRemoteCommandCenter *remoteCommandCenter = [MPRemoteCommandCenter
//                                                      sharedCommandCenter];
//        
//        [[remoteCommandCenter changePlaybackRateCommand]setEnabled:true];
        
        
        

        [self.session setCategory:AVAudioSessionCategoryPlayback
                      withOptions:AVAudioSessionCategoryOptionMixWithOthers
                            error:&error];
        if (error) {
            DDLogDebug(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, error);
            return;
        }
        [self.session setActive:YES error:&error];
        if (error) {
            DDLogDebug(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, error);
            return;
        }
        
        // remove observer if already found
        @try {
            [self.session removeObserver:self forKeyPath:sessionVolumeKeyPath context:sessionContext];
        } @catch (NSException *exception) {
            [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
        }
        // Observe outputVolume
        [self.session addObserver:self
                       forKeyPath:sessionVolumeKeyPath
                          options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                          context:sessionContext];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    @try {
        CGFloat newVolume = [change[NSKeyValueChangeNewKey] floatValue];
        CGFloat oldVolume = [change[NSKeyValueChangeOldKey] floatValue];
        // DDLogDebug(@"newVolume %f oldVolume %f ", newVolume, oldVolume);
        NSInteger newVolume100 = newVolume*100;
        NSInteger oldVolume100 = oldVolume*100;
        // DDLogDebug(@"newVolume100 %ld oldVolume100 %ld ", newVolume100, oldVolume100);

        if (newVolume100 != oldVolume100) {
            if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
                if (self.delegate) {
                    [self.delegate didReceivedHardwareVolumeVideo_OldValue:oldVolume100 NewValue:newVolume100];
                }
            } else if (mHubManagerInstance.objSelectedHub.Generation == mHubAudio) {
                if (self.delegate) {
                    [self.delegate didReceivedHardwareVolumeAudio_OldValue:oldVolume100 NewValue:newVolume100];
                }
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
