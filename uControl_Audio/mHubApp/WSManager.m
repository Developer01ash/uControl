//
//  WSManager.m
//  mHubApp
//
//  Created by Apple on 16/12/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import "WSManager.h"

@implementation WSManager
{
    //SRWebSocket *webSocket;
}

+ (instancetype)sharedInstance {
    static WSManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WSManager alloc] init];
    });
    return sharedInstance;
}


- (void)connectWebSocket:(NSString *)ipAddress{
    @try {
    if(_webSocket.readyState == SR_OPEN){
    _webSocket.delegate = nil;
    _webSocket = nil;
    [_webSocket close];
    }
    NSString *urlString = [NSString stringWithFormat:@"ws://%@:9000",ipAddress];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    _webSocket =  [[SRWebSocket alloc] initWithURLRequest:request];
    _webSocket.delegate = self;
    [_webSocket open];
} @catch (NSException *exception) {
[[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}

-(void)sendData:(NSString *)jsonData 
{
@try {
    if(_webSocket.readyState != SR_OPEN)
    {
        [self connectWebSocket:mHubManagerInstance.objSelectedHub.Address];
    }
    if(_webSocket.readyState == SR_OPEN)
    {
        [_webSocket send:jsonData];
    }
} @catch (NSException *exception) {
[[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}

#pragma mark - SRWebSocket delegate

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    NSLog(@"connected%@",newWebSocket);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"webSocket didFailWithError data%@",error.description);
    //[self connectWebSocket:mHubManagerInstance.objSelectedHub.Address];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    @try {
    NSLog(@"webSocket didCloseWithCode data %ld %@",(long)code,reason);
    [self connectWebSocket:mHubManagerInstance.objSelectedHub.Address];
    } @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    @try {
    //NSLog(@"webSocket received data%@",message);
    NSDictionary *aDict = [@{@"myKey":message}mutableCopy];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWebSocketReceivedResponse object:self userInfo:aDict];
} @catch (NSException *exception) {
    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}

}
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    //NSLog(@"webSocket didReceivePong%@",pongPayload);
}
@end
