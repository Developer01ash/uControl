//
//  InterfaceController.h
//  mHubWatchApp Extension
//
//  Created by Apple on 04/05/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <Foundation/Foundation.h>
#import "TableViewRowController.h"
#import "API.h"
#import "Sequence.h"
#import <AVFoundation/AVFoundation.h>

//#import "AppDelegate.h"

//#import "APIResponse.h"
//#import "APIManager.h"
//#import "AFNetworking.h"
//#import "APIResponse.h"
//#import "SSDPManager.h"

@interface InterfaceController : WKInterfaceController<WCSessionDelegate>
{
    NSString *ipAddressStr;
}
@property(nonatomic, retain) NSMutableArray <Sequence*>*HubSequenceList;    // Array of Sequence type

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *headingLbl;
@property (nonatomic, weak) IBOutlet WKInterfaceTable *tbl_list;
@property (nonatomic, weak) IBOutlet WKInterfaceButton *btn;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) WCSession *wc_session;
@end
