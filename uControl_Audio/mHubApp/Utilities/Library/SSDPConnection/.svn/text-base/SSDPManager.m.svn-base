//
//  SSDPManager.m
//  mHubApp
//
//  Created by Anshul Jain on 01/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "SSDPManager.h"
#import "SSDPResponse.h"

@implementation SSDPManager

+ (instancetype)sharedInstance {
    static SSDPManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SSDPManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - SSDP browser delegate methods
-(void) startBrowsingSSDP {
    @try {
        [SSDPManager disconnectSSDPmHub];
        self.ssdpServiceBrowser = [[SSDPServiceBrowser alloc] initWithServiceType:SSDPServiceType_UPnP_TVpicture1];
        self.ssdpServiceBrowser.delegate = self;
        [self.ssdpServiceBrowser startBrowsingForServices];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error {
    DDLogError(@"SSDP Browser got error: %@", error);
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service {
    @try {
        DDLogDebug(@"SSDP Browser found: %@", service);
        [APIManager getSSDPServiceXML_Service:service completion:^(APIResponse *responseObject) {
            if (!responseObject.error) {
                Hub *objHub = (Hub*)responseObject.response;
                if (self.delegate) {
                    [self.delegate ssdpManager:self didFindMHUB:objHub];
                }
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service {
    @try {
        DDLogDebug(@"SSDP Browser removed: %@", service);
        [APIManager getSSDPServiceXML_Service:service completion:^(APIResponse *responseObject) {
            if (!responseObject.error) {
                Hub *objHub = (Hub*)responseObject.response;
                if (self.delegate) {
                    [self.delegate ssdpManager:self didRemoveMHUB:objHub];
                }
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - SSDP Connection Methods
+(void) connectSSDP {
    @try {
        [NetworkController sharedInstance].host = mHubManagerInstance.objSelectedHub.Address;
        [NetworkController sharedInstance].port = 8000;
        [[NetworkController sharedInstance] connect];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) connectSSDPmHub_Completion:(void (^)(APIResponse *objResponse))handler {
    @try {
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            APIResponse *objReturn = [[APIResponse alloc] init];
            objReturn.error = true;
            objReturn.response = @"";
            handler(objReturn);
            return;
        } else {
            [SSDPManager connectSSDP];
            [SSDPManager connectionStatusCheck_Completion:^(APIResponse *objResponse) {
                SSDPResponse *objResp = (SSDPResponse*)objResponse.response;
                //DDLogInfo(@"objResp.status == %lu", (unsigned long)objResp.status);
                if (objResp.status == SSDPOpened || objResp.status == SSDPMessage) {
                    Hub *objHub = [[Hub alloc] init];
                    objHub.Name = mHubManagerInstance.objSelectedHub.Name;
                    objHub.Address = mHubManagerInstance.objSelectedHub.Address;
                    objHub.Generation = mHubManagerInstance.objSelectedHub.Generation;
                    objHub.modelName = [Hub getModelName:mHubManagerInstance.objSelectedHub];
                    objHub.InputCount = mHubManagerInstance.objSelectedHub.InputCount;
                    objHub.OutputCount = mHubManagerInstance.objSelectedHub.OutputCount;
                    objHub.SerialNo = mHubManagerInstance.objSelectedHub.SerialNo;

                    if ([mHubManagerInstance.objSelectedHub.HubOutputData isNotEmpty]) {
                        objHub.HubOutputData = [[NSMutableArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubOutputData];
                    } else {
                        objHub.HubOutputData = [[NSMutableArray alloc] initWithArray:[OutputDevice getOutputObjectArrayFromIndex:objHub.OutputCount]];
                    }
                    
                    if ([mHubManagerInstance.objSelectedHub.HubInputData isNotEmpty]) {
                        objHub.HubInputData = [[NSMutableArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubInputData];
                    } else {
                        objHub.HubInputData = [[NSMutableArray alloc] initWithArray:[InputDevice getInputObjectArrayFromIndex:objHub.InputCount]];
                    }

                    objHub.Name = [Hub getMhubDisplayName:objHub];
                    objHub.BootFlag = true;
                    objHub.Mac = UNKNOWN_MAC;
                    
                    mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objHub];
                    APIResponse *objReturn = [[APIResponse alloc] init];
                    objReturn.error = false;
                    objReturn.response = objHub;
                    handler(objReturn);
                } else {
                    APIResponse *objReturn = [[APIResponse alloc] init];
                    objReturn.error = true;
                    objReturn.response = objResp.response;
                    handler(objReturn);
                }
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            }];
        }
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) disconnectSSDPmHub {
    @try {
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            return;
        } else {
            [[NetworkController sharedInstance] disconnect];
            [SSDPManager connectionStatusCheck_Completion:^(APIResponse *objResponse) {
                SSDPResponse *objResp = (SSDPResponse*)objResponse;
                DDLogError(@"SSDP disconnectSSDPmHub : %@", objResp.response);
            }];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) connectionStatusCheck_Completion:(void (^)(APIResponse *objResponse)) handler {
    SSDPResponse *objReturn = [[SSDPResponse alloc] init];
    @try {
        // Enable input and show keyboard as soon as connection is established.
        [NetworkController sharedInstance].connectionOpenedBlock = ^(NetworkController* connection) {
            DDLogDebug(@">>> Connection opened <<<");
            objReturn.status = SSDPOpened;
            objReturn.response = @"Connection opened";
            // handler(true, objReturn);
        };
        
        // Disable input and hide keyboard when connection is closed.
        [NetworkController sharedInstance].connectionClosedBlock = ^(NetworkController* connection) {
            DDLogDebug(@">>> Connection closed <<<");
            objReturn.status = SSDPClosed;
            objReturn.response = @"";
            APIResponse *objReturn1 = [[APIResponse alloc] init];
            objReturn1.error = false;
            objReturn1.response = objReturn;
            handler(objReturn1);
        };
        
        // Display error message and do nothing if connection fails.
        [NetworkController sharedInstance].connectionFailedBlock = ^(NetworkController* connection) {
            DDLogError(@">>> Connection FAILED <<<");
            objReturn.status = SSDPFailed;
            objReturn.response = HUB_TROUBLECONNECTING;
            APIResponse *objReturn1 = [[APIResponse alloc] init];
            objReturn1.error = false;
            objReturn1.response = objReturn;
            handler(objReturn1);
        };
        
        // Append incoming message to the output text view.
        [NetworkController sharedInstance].messageReceivedBlock = ^(NetworkController* connection, NSString* message) {
            DDLogDebug(@">>> Connection message : %@ <<<", message);
            objReturn.status = SSDPMessage;
            objReturn.response = message;
            APIResponse *objReturn1 = [[APIResponse alloc] init];
            objReturn1.error = false;
            objReturn1.response = objReturn;
            handler(objReturn1);
        };
    }
    @catch(NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) checkSSDPmHubConnection {
    @try {
        mHubManager *objManager = [mHubManagerInstance retrieveCustomObjectWithKey:kMHUBMANAGERINSTANCE];
        mHubManagerInstance.objSelectedOutputDevice = objManager.objSelectedOutputDevice;
        mHubManagerInstance.objSelectedInputDevice = objManager.objSelectedInputDevice;
        mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objManager.objSelectedHub];
        mHubManagerInstance.arrLeftPanelRearranged = [[NSMutableArray alloc] initWithArray:objManager.arrLeftPanelRearranged];
        mHubManagerInstance.arrSourceDeviceManaged = [[NSMutableArray alloc] initWithArray:objManager.arrSourceDeviceManaged];
        
        if (![mHubManagerInstance.objSelectedHub.Address isIPAddressEmpty] && mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            [SSDPManager connectSSDP];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - SSDP Communication Methods

+(void) sendSSDPMessage:(NSString *)strMessage completion:(void (^)(APIResponse *objResponse)) handler {
    @try {
        strMessage = [strMessage stringByAppendingString:@"\n"];
        [[NetworkController sharedInstance] sendMessage:strMessage];
        [SSDPManager connectionStatusCheck_Completion:^(APIResponse *objResponse) {
            SSDPResponse *objResp = (SSDPResponse*)objResponse.response;
            if (objResp.status == SSDPOpened || objResp.status == SSDPMessage) {
                //DDLogDebug(@"objResp == %@", objResp.response);
                APIResponse *objReturn1 = [[APIResponse alloc] init];
                objReturn1.error = objResponse.error ;
                objReturn1.response = objResp.response;
                handler(objReturn1);
            } else {
                APIResponse *objReturn1 = [[APIResponse alloc] init];
                objReturn1.error = true;
                objReturn1.response = objResp.response;
                handler(objReturn1);
            }
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) getSSDPSwitchStatus:(NSInteger)intOutputIndex completion:(void (^)(APIResponse *objResponse)) handler {
    @try {
        [SSDPManager sendSSDPMessage:[NSString stringWithFormat:@"Status%d.", (int)intOutputIndex] completion:^(APIResponse *objResponse) {
            if (objResponse.error) {
                mHubManagerInstance.objSelectedInputDevice = nil;
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];

            } else {
                NSArray *arrResp1 = [objResponse.response componentsSeparatedByString:@":"];
                NSInteger intInputIndex = 0;
                if (arrResp1.count > 1) {
                    NSArray *arrResp2 = [[arrResp1 objectAtIndex:1] componentsSeparatedByString:@"->"];
                    if (arrResp2.count > 0) {
                        intInputIndex = [[arrResp2 objectAtIndex:0] integerValue];
                    }
                }
                for (InputDevice *objInput in mHubManagerInstance.objSelectedHub.HubInputData) {
                    if (objInput.Index == intInputIndex) {
                        mHubManagerInstance.objSelectedInputDevice = objInput;
                        break;
                    }
                }
            }
            APIResponse *objReturn = [[APIResponse alloc] init];
            objReturn.error = objReturn.error;
            objReturn.response = objResponse;
            handler(objReturn);
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) putSSDPSwitchIn_OutputIndex:(NSInteger)intOutputIndex InputIndex:(NSInteger)intInputIndex completion:(void (^)(APIResponse *objResponse)) handler {
    @try {
        [SSDPManager sendSSDPMessage:[NSString stringWithFormat:@"%dB%d.", (int)intInputIndex, (int)intOutputIndex] completion:^(APIResponse *objResponse) {
            if (objResponse.error) {
                mHubManagerInstance.objSelectedInputDevice = nil;
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
            } else {
                NSArray *arrResp1 = [objResponse.response componentsSeparatedByString:@":"];
                NSInteger intInputIndex = 0;
                if (arrResp1.count > 1) {
                    NSArray *arrResp2 = [[arrResp1 objectAtIndex:1] componentsSeparatedByString:@"->"];
                    if (arrResp2.count > 0) {
                        intInputIndex = [[arrResp2 objectAtIndex:0] integerValue];
                    }
                }
                for (InputDevice *objInput in mHubManagerInstance.objSelectedHub.HubInputData) {
                    if (objInput.Index == intInputIndex) {
                        mHubManagerInstance.objSelectedInputDevice = objInput;
                        break;
                    }
                }
            }
            handler(objResponse);
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

@end
