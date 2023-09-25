//
//  WSManager.h
//  mHubApp
//
//  Created by Apple on 16/12/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>


NS_ASSUME_NONNULL_BEGIN

@class WSManager;

@protocol WSManagerDelegate <NSObject>
- (void) wsManager_ReloadData:(MDNSManager*)manager;
- (void) wsManager:(WSManager*)manager didFindMHUB:(Hub*)objHub;
- (void) wsManager:(WSManager*)manager didReceiveData:(NSData *)receivedData;
- (void) wsManager:(WSManager*)manager Service:(NSNetService *)service didFindAddress:(NSString*)address;
@end



@interface WSManager : NSObject<SRWebSocketDelegate>
{
    
}
@property (nonatomic,strong) id delegate;
@property (nonatomic,strong) SRWebSocket *webSocket;

@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser;
@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser2;

@property (nonatomic, strong) NSMutableArray *services;

+ (instancetype)sharedInstance;

- (void)connectWebSocket:(NSString *)ipAddress;
-(void)sendData:(NSString *)jsonData;

@end

NS_ASSUME_NONNULL_END
