//
//  MDNSManager.h
//  mHubApp
//
//  Created by Anshul Jain on 27/10/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@class MDNSManager;

@protocol MDNSManagerDelegate <NSObject>
- (void) mdnsManager_ReloadData:(MDNSManager*)manager;
- (void) mdnsManager:(MDNSManager*)manager didFindMHUB:(Hub*)objHub;
- (void) mdnsManager:(MDNSManager*)manager didRemoveMHUB:(Hub*)objHub;
- (void) mdnsManager:(MDNSManager*)manager Service:(NSNetService *)service didFindAddress:(NSString*)address;
@end

@interface MDNSManager : NSObject<NSNetServiceDelegate, NSNetServiceBrowserDelegate, GCDAsyncSocketDelegate> {
    id <MDNSManagerDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser;
@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser2;

@property (nonatomic, strong) NSMutableArray *services;

+ (instancetype)sharedInstance;
- (void)startBrowsingMDNS;
- (void)startBrowsingMDNS2;


@end
