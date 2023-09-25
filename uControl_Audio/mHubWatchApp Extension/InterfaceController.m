//
//  InterfaceController.m
//  mHubWatchApp Extension
//
//  Created by Apple on 04/05/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import "InterfaceController.h"
//#import <AudioToolbox/AudioToolbox.h>


@interface InterfaceController ()
{
    WCSession *wc_session;
    NSMutableArray *array_colors;
}

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    @try {
    // Configure interface objects here.
    wc_session = WCSession.defaultSession;
    wc_session.delegate = self;
    [wc_session activateSession];
    [self loadDataSource];
    [self loadTableViewData];
    [self setTableViewContent];
        
        array_colors = [[NSMutableArray alloc]init];
        UIColor *color1 = [UIColor colorWithRed:250.0/255.0f green:17.0/255.0f blue:79.0/255.0f alpha:17.0];
        UIColor *color2 = [UIColor colorWithRed:255.0/255.0f green:59.0/255.0f blue:48.0/255.0f alpha:17.0];
        UIColor *color3 = [UIColor colorWithRed:255.0/255.0f green:149.0/255.0f blue:0.0/255.0f alpha:15.0];
        UIColor *color4 = [UIColor colorWithRed:255.0/255.0f green:230.0/255.0f blue:32.0/255.0f alpha:14.0];
        UIColor *color5 = [UIColor colorWithRed:4.0/255.0f green:222.0/255.0f blue:113.0/255.0f alpha:14.0];
        UIColor *color6 = [UIColor colorWithRed:0.0/255.0f green:245.0/255.0f blue:234.0/255.0f alpha:15.0];
        UIColor *color7 = [UIColor colorWithRed:90.0/255.0f green:200.0/255.0f blue:250.0/255.0f alpha:15.0];
        UIColor *color8 = [UIColor colorWithRed:32.0/255.0f green:148.0/255.0f blue:250.0/255.0f alpha:17.0];
        UIColor *color9 = [UIColor colorWithRed:120.0/255.0f green:122.0/255.0f blue:155.0/255.0f alpha:20.0];
        UIColor *color10 = [UIColor colorWithRed:242.0/255.0f green:244.0/255.0f blue:255.0/255.0f alpha:14.0];
        
        [array_colors addObject:color1];
        [array_colors addObject:color2];
        [array_colors addObject:color3];
        [array_colors addObject:color4];
        [array_colors addObject:color5];
        [array_colors addObject:color6];
        [array_colors addObject:color7];
        [array_colors addObject:color8];
        [array_colors addObject:color9];
        [array_colors addObject:color10];
        
       // array_colors = [color1,color2,color3,color4,color5,color6,color7,color8,color9,color10];
    
} @catch (NSException *exception) {
   // [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}

    
    
    
}

- (void)willActivate {
    @try {

    // This method is called when watch view controller is about to be visible to user
    if(_wc_session.isReachable)
    {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"getWatchData" forKey:@"WatchSync"];
    [wc_session sendMessage:dict replyHandler:nil errorHandler:nil];
    }else
    {
        _wc_session = WCSession.defaultSession;
        _wc_session.delegate = self;
        [_wc_session activateSession];
    }
    } @catch (NSException *exception) {
       // [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
        
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message
{
    @try {
   // NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSLog(@"message %@",message);
    if(WCSession.isSupported)
    {
        [self.btn setTitle:[message valueForKey:@"IPAddress"]];
        [self.btn setHidden:YES];
        ipAddressStr = [message valueForKey:@"IPAddress"];
        self.HubSequenceList = [message valueForKey:@"SequenceList"];
       // [self loadDataSource];
        [self loadTableViewData];
        [self setTableViewContent];
        
    }
} @catch (NSException *exception) {
   // [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
    

}
-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext
{
    
}
- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    @try {
    NSLog(@"Hii %@ %ld",session,(long)activationState);
    if(activationState == 2)
    {
        NSLog(@"Hii2 %@",session);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:@"getWatchData" forKey:@"WatchSync"];
        [_wc_session sendMessage:dict replyHandler:nil errorHandler:nil];
    }
    } @catch (NSException *exception) {
       // [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}
-(IBAction)getValue:(id)sender
{
    @try {
    if(_wc_session.isReachable)
    {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"getWatchData" forKey:@"WatchSync"];
    [wc_session sendMessage:dict replyHandler:nil errorHandler:nil];
    }else
    {
        _wc_session = WCSession.defaultSession;
        _wc_session.delegate = self;
        [_wc_session activateSession];
    }
} @catch (NSException *exception) {
   // [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}


- (void)loadDataSource {
    self.dataSource = @[@"English", @"Maths",@"Chemistry", @"Physics", @"Urdu", @"Social Science"];
}

- (void)loadTableViewData {
[self.tbl_list setNumberOfRows:self.HubSequenceList.count withRowType:@"Default"];
}

- (void)setTableViewContent {
    @try {
   
    for (int i =0;i<self.HubSequenceList.count;i++){
        TableViewRowController *controller = [self.tbl_list rowControllerAtIndex:i];
        Sequence *str = [self.HubSequenceList objectAtIndex:i] ;
        [controller.lbl_sequenceName setText:[str valueForKey:kUCONTROLNAME]];
        CGFloat redLevel    = rand() / (float) RAND_MAX;
        CGFloat greenLevel  = rand() / (float) RAND_MAX;
        CGFloat blueLevel   = rand() / (float) RAND_MAX;
        
        [controller.rowGroup setBackgroundColor:[array_colors objectAtIndex:i]];
       
        
     //   [controller.rowGroup setBackgroundColor:[UIColor colorWithRed: redLevel green: greenLevel blue: blueLevel alpha: 1.0]];
        
}
} @catch (NSException *exception) {
   // [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
}
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    @try {
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeSuccess];
        Sequence *str = [self.HubSequenceList objectAtIndex:rowIndex] ;
      //  NSLog(@"getObjectResponseFromService %@ %@",ipAddressStr,[str valueForKey:kMACROID]);
        NSURL *urlS = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", [NSString stringWithFormat: BASEURLIP, ipAddressStr], APIV2_EXECUTESEQUENCE, [str valueForKey:kMACROID]]];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [self getObjectResponseFromService:urlS WithCompletion:^(id objResponse){

                }];    });
        
    } @catch (NSException *exception) {
       // [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
    
    
}
- (void) getObjectResponseFromService:(NSURL *)urlStr WithCompletion:(void (^)(id objResponse)) handler
{
    @try {

    NSError* error = nil;
    NSURLResponse* response;

    NSData* dataResponse = [self sendSynchronousRequest2:urlStr returningResponse:&response error:&error];
  
    // NSLog(@"dataResponse %@",dataResponse);
    NSDictionary* dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:nil];
    NSLog(@"dictResponse %@",dictResponse);
    if (dataResponse) {
        NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:&error];
//        APIV2Response *objResponse = [APIV2Response getObjectFromDictionary:jsonData];
//        //DDLogDebug(@"Response == %@", objResponse.response);
        handler(jsonData);
    }
    } @catch (NSException *exception) {
       // [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
- (NSData *)sendSynchronousRequest2:(NSURL *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    __block NSData *blockData = nil;
    @try {
        
        __block NSURLResponse *blockResponse = nil;
        __block NSError *blockError = nil;
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        session = [NSURLSession sessionWithConfiguration:configuration];
        [[session dataTaskWithURL:request completionHandler:^(NSData * _Nullable subData, NSURLResponse * _Nullable subResponse, NSError * _Nullable subError) {
            blockData = subData;
            blockError = subError;
            blockResponse = subResponse;
            dispatch_group_leave(group);
        }] resume];
        
        dispatch_group_wait(group,  DISPATCH_TIME_FOREVER);
        
        *error = blockError;
        *response = blockResponse;
        
    } @catch (NSException *exception) {
        
        NSLog(@"sendSynchronousRequest2%@", exception.description);
    } @finally {
        return blockData;
    }
}

@end



