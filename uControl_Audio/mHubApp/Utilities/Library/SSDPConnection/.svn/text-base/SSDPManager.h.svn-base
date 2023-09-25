//
//  SSDPManager.h
//  mHubApp
//
//  Created by Anshul Jain on 01/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaSSDP/SSDPServiceBrowser.h>
#import <CocoaSSDP/SSDPServiceTypes.h>
#import <CocoaSSDP/SSDPService.h>
@class SSDPManager;

// UPnP HDAnywhere V3
#define SSDPServiceType_UPnP_TVpicture1 @"urn:schemas-upnp-org:service:tvpicture:1"

typedef NS_ENUM(NSUInteger, SSDPConnectionStatus) {
    SSDPFailed  = 0,
    SSDPOpened  = 1,
    SSDPClosed  = 2,
    SSDPMessage = 3
};

@protocol SSDPManagerDelegate <NSObject>
- (void) ssdpManager:(SSDPManager*)manager didFindMHUB:(Hub*)objHub;
- (void) ssdpManager:(SSDPManager*)manager didRemoveMHUB:(Hub*)objHub;
@end

@interface SSDPManager : NSObject <SSDPServiceBrowserDelegate> {
    id <SSDPManagerDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
@property (strong, nonatomic) SSDPServiceBrowser *ssdpServiceBrowser;

+ (instancetype)sharedInstance;
-(void) startBrowsingSSDP;

+(void) connectSSDP;
+(void) connectSSDPmHub_Completion:(void (^)(APIResponse *objResponse))handler;
+(void) disconnectSSDPmHub;
+(void) checkSSDPmHubConnection;

+(void) getSSDPSwitchStatus:(NSInteger)intOutputIndex completion:(void (^)(APIResponse *objResponse)) handler;
+(void) putSSDPSwitchIn_OutputIndex:(NSInteger)intOutputIndex InputIndex:(NSInteger)intInputIndex completion:(void (^)(APIResponse *objResponse)) handler;

@end
