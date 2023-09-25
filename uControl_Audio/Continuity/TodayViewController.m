//
//  TodayViewController.m
//  Continuity
//
//  Created by Anshul Jain on 18/08/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "WidgetCommand.h"
#import "CellContinuity.h"
#import <KTCenterFlowLayout/KTCenterFlowLayout.h>
#import "ContinuityDevice.h"
#import "APIManager.h"
#import "ContinuityHub.h"

#define isLog 0
#define kServiceTimeOut 50

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewContinuity;
@property (weak, nonatomic) IBOutlet UILabel *lblSubHeader;
@property (nonatomic, retain) NSMutableArray<WidgetCommand*> *arrWidgetCommand;
@property (nonatomic, retain) ContinuityDevice *objContinuityDevice;
@property (nonatomic, retain) ContinuityHub *objContinuityHub;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @try {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
        
        KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
        layout.minimumInteritemSpacing = 5.f;
        layout.minimumLineSpacing = 5.f;
        layout.itemSize = CGSizeMake(60.0f, 40.0f);
        [self.collectionViewContinuity setCollectionViewLayout:layout];
        
        [self updateDataInWidget];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if(isLog) //NSLog(@"\n\n<%s : view.frame == %@>", __FUNCTION__, NSStringFromCGRect(self.view.frame));
    
//    if(isLog) //NSLog (@"<collectionViewContinuity.frame == %@>", NSStringFromCGRect(self.collectionViewContinuity.frame));
//    if(isLog) //NSLog(@"<collectionViewContinuity.contentSize == %@>", NSStringFromCGSize(self.collectionViewContinuity.contentSize));
//    if(isLog) //NSLog(@"<collectionViewContinuity.contentInset == %@>", NSStringFromUIEdgeInsets(self.collectionViewContinuity.contentInset));
    
    self.collectionViewContinuity.contentInset = UIEdgeInsetsMake(MAX((self.collectionViewContinuity.frame.size.height - self.collectionViewContinuity.contentSize.height) / 2, 0), self.collectionViewContinuity.contentInset.left, self.collectionViewContinuity.contentInset.bottom, self.collectionViewContinuity.contentInset.right);
    
//    if(isLog) NSLog (@"<collectionViewContinuity.frame update == %@>", NSStringFromCGRect(self.collectionViewContinuity.frame));
//    if(isLog) NSLog(@"<collectionViewContinuity.contentSize update == %@>", NSStringFromCGSize(self.collectionViewContinuity.contentSize));
//    if(isLog) NSLog(@"<collectionViewContinuity.contentInset update == %@>", NSStringFromUIEdgeInsets(self.collectionViewContinuity.contentInset));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    } else {
        NSInteger intCommandCount = self.arrWidgetCommand.count;
        NSInteger intReminder = intCommandCount%5;
        NSInteger intQuotient = intCommandCount/5;
        CGFloat heightWidget = 0.0f;
        if (intReminder == 0) {
            heightWidget = intQuotient*50.0f + 10.0f;
        } else {
            heightWidget = intQuotient*50.0f + 60.0f;
        }
        if(isLog) //NSLog(@"%f", heightWidget);
        self.preferredContentSize = CGSizeMake(0.0f, heightWidget);
    }
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    [self updateDataInWidget];
}

-(void) updateDataInWidget {
    @try {
#ifdef DEVELOPMENT
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kNotificationBundleIndentifierDev];
#else
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kNotificationBundleIndentifierProd];
#endif
        
        //NSLog(@"updateDataInWidget defaults%@",defaults);
        NSData *encodedContinuityArray = [defaults valueForKey:kSELECTEDCONTINUITYARRAY];
        NSMutableArray *arrContinuity = [[NSMutableArray alloc] init];
        if (!(encodedContinuityArray == nil || [encodedContinuityArray isKindOfClass:[NSNull class]] || ([encodedContinuityArray respondsToSelector:@selector(count)] && [(NSArray *)encodedContinuityArray count] == 0))) {
            arrContinuity = [NSKeyedUnarchiver unarchiveObjectWithData:encodedContinuityArray];
        }
        
        NSData *encodedInputObject = [defaults valueForKey:kSELECTEDINPUTDEVICE];
        NSDictionary *dictInput;
        if (!(encodedInputObject == nil || [encodedInputObject isKindOfClass:[NSNull class]] || ([encodedInputObject respondsToSelector:@selector(count)] && [(NSDictionary *)encodedInputObject count] == 0))) {
            dictInput = [NSKeyedUnarchiver unarchiveObjectWithData:encodedInputObject];
        }
        
        // Tell the NSKeyedUnarchiver that the class has been renamed
        [NSKeyedUnarchiver setClass:[ContinuityHub class] forClassName:@"CommandType"];        
        NSData *encodedHubObject = [defaults objectForKey:kSELECTEDHUBMODEL];
        NSDictionary *dictHub;
        if (!(encodedHubObject == nil || [encodedHubObject isKindOfClass:[NSNull class]] || ([encodedHubObject respondsToSelector:@selector(count)] && [(NSDictionary *)encodedHubObject count] == 0))) {
            dictHub = [NSKeyedUnarchiver unarchiveObjectWithData:encodedHubObject];
        }
//
//        if(isLog) //NSLog(@"%@ == %lu", kSELECTEDCONTINUITYARRAY, (unsigned long)arrContinuity.count);
//        if(isLog) //NSLog(@"%@ == %@", kSELECTEDCONTINUITYARRAY, arrContinuity);
//        if(isLog) //NSLog(@"%@ == %@", kSELECTEDINPUTDEVICE, dictInput);
//        if(isLog) //NSLog(@"%@ == %@", kSELECTEDHUBMODEL, dictHub);
//
#ifdef DEVELOPMENT
        if (arrContinuity.count == 0) {
            [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:kNotificationIndentifierContinuityDev];
        } else {
            [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:kNotificationIndentifierContinuityDev];
            self.arrWidgetCommand = [[NSMutableArray alloc] initWithArray:[WidgetCommand getObjectArray:arrContinuity]];
            // [self.arrWidgetCommand addObjectsFromArray:[WidgetCommand getObjectArray:arrContinuity]];
            self.objContinuityDevice = [ContinuityDevice getObjectFromDictionary:dictInput];
            self.objContinuityHub = [ContinuityHub getObjectFromDictionary:dictHub];
            if (self.arrWidgetCommand.count > 10) {
                [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeExpanded];
            } else {
                [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeCompact];
            }
        }
#else
        if (arrContinuity.count == 0) {
            [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:kNotificationIndentifierContinuityProd];
        } else {
            [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:kNotificationIndentifierContinuityProd];
            self.arrWidgetCommand = [[NSMutableArray alloc] initWithArray:[WidgetCommand getObjectArray:arrContinuity]];
            // [self.arrWidgetCommand addObjectsFromArray:[WidgetCommand getObjectArray:arrContinuity]];
            self.objContinuityDevice = [ContinuityDevice getObjectFromDictionary:dictInput];
            self.objContinuityHub = [ContinuityHub getObjectFromDictionary:dictHub];
            if (self.arrWidgetCommand.count > 10) {
                [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeExpanded];
            } else {
                [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeCompact];
            }
        }
#endif
        [self.lblSubHeader setText:[self.objContinuityDevice.CreatedName uppercaseString]];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);
    }
}

#pragma mark -- CollectionView Datasource and Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    @try {
        return self.arrWidgetCommand.count;
    } @catch (NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    CellContinuity *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CellContinuity" forIndexPath:indexPath];
    WidgetCommand *objCmd = [self.arrWidgetCommand objectAtIndex:indexPath.item];
    cell.imgCellContinuityImage.image = objCmd.image_light;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        WidgetCommand *objCmd = [self.arrWidgetCommand objectAtIndex:indexPath.item];
        
        if(isLog) NSLog(@"<%s: %@>", __PRETTY_FUNCTION__, [objCmd dictionaryRepresentation]);
        
        //[self irEngine_Code:objCmd.code PortId:self.objContinuityDevice.PortNo];
        [self callExecuteCommand_Hub:self.objContinuityHub Command:objCmd PortNo:self.objContinuityDevice.PortNo];
        
    } @catch (NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);
    }
}

#pragma mark - Webservice Call Methods API V1

-(void) irEngine_Code:(NSString *)strCode PortId:(NSInteger)intPortId {
    @try {
        [self getResponseFromCGIBIN:[self irEngineURL_Code:strCode PortId:intPortId] WithCompletion:^(BOOL success, NSError *error, id responseObject) {
            //            [self getResponseFromCGIBIN:[self irEngineURL_Query] WithCompletion:^(BOOL success, NSError *error, id responseObject) {
            //                if(isLog) //NSLog(@"Response == %@", responseObject);
            //            }];
        }];
    } @catch (NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);
    }
}

-(NSString *)getBaseURL_Rest:(BOOL)isRest {
    ////NSLog(@"self.objContinuityHub.Address == %@", self.objContinuityHub.Address);
    if ([self.objContinuityHub.Address isEqualToString:STATICTESTIP_PRO]) {
        if (isRest) {
            return [NSString stringWithFormat:@"%@%@", [NSString stringWithFormat:BASEURLIP, BASEURL_CLOUD_DEMO_PRO], API_REST];
        } else {
            return [NSString stringWithFormat: BASEURLIP, BASEURL_CLOUD_DEMO_PRO];
        }
    } else {
        NSString *strURL = @"";
        if (isRest) {
            strURL = [NSString stringWithFormat:@"%@%@", [NSString stringWithFormat:BASEURLIP, self.objContinuityHub.Address], API_REST];
            return strURL;
        } else {
            strURL = [NSString stringWithFormat: BASEURLIP, self.objContinuityHub.Address];
            return strURL;
        }
    }
}

-(NSURL*) irEngineURL_Code:(NSString *)strCode PortId:(NSInteger)intPortId {
    NSMutableString *strURL = [NSMutableString stringWithFormat:@"%@",[self getBaseURL_Rest:false]];
    
    [strURL appendFormat:@"%@", [NSString stringWithFormat:API_IRENGINE_CGIBIN_CODE, strCode, [[NSDate date] timeIntervalSince1970]]];
    
    return [NSURL URLWithString:strURL];
}

-(NSURL*) irEngineURL_Query {
    NSMutableString *strURL = [NSMutableString stringWithFormat:@"%@",[self getBaseURL_Rest:false]];
    
    [strURL appendFormat:@"%@", [NSString stringWithFormat:API_IRENGINE_CGIBIN_QUERY,[[NSDate date] timeIntervalSince1970]]];
    
    return [NSURL URLWithString:strURL];
}

-(void)getResponseFromCGIBIN:(NSURL *)url WithCompletion:(void(^)(BOOL success, NSError *error, id responseObject))handler {
    @try {
        // Code to call API in NSData formate and serialize here.
        NSError* err = nil;
        id response = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
        if (err) {
            //NSLog(ERRORLOG, __PRETTY_FUNCTION__, __LINE__, err);
            handler(false, err, err.localizedDescription);
        } else {
            ////NSLog(@"Response == %@", response);
            handler(true, nil, response);
        }
    }
    @catch (NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);
        handler(false, nil, nil);
    }
}

#pragma mark - API V2
-(void) callExecuteCommand_Hub:(ContinuityHub*)objHub Command:(WidgetCommand*)objCmd PortNo:(NSInteger)intPort {
    @try {
        if (![objHub isDemoMode]) {
            if (intPort == 0) {
                
            } else {
                if ([objHub isAPIV2]) {
                    DDLogDebug(@"objCmd.command_id == %ld", (long)objCmd.command_id);
                    [self executeCommand_Address:objHub.Address CommandId:objCmd.command_id PortId:intPort];
                } else {
                    [self irEngine_Code:objCmd.code PortId:intPort];
                }
            }
        }
    } @catch (NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);
    }
}

-(void) executeCommand_Address:(NSString*)strAddress CommandId:(NSInteger)intCommandId PortId:(NSInteger)intPortId {
    @try {
        [self getObjectResponseFromService:[self executeCommandURL:strAddress PortId:intPortId CommandId:intCommandId]];
    } @catch (NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);
    }
}

-(NSURL*) executeCommandURL:(NSString*)strAddress PortId:(NSInteger)intPortId CommandId:(NSInteger)intCommandId {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%ld/%ld", [self getBaseURL:strAddress], APIV2_EXECUTECOMMAND, (long)intPortId, (long)intCommandId]]; // [io]/[cy]/       where [io] = IR port ID (1,2,3…..), [cy] = IR command number
}

-(NSString *)getBaseURL:(NSString*)strAddress {
    DDLogDebug(@"<%s> : strAddress == %@", __FUNCTION__, strAddress);
    if ([strAddress isEqualToString:STATICTESTIP_PRO]) {
        return [NSString stringWithFormat: BASEURLIP, BASEURL_CLOUD_DEMO_PRO];
    } else {
        return [NSString stringWithFormat: BASEURLIP, strAddress];
    }
}

-(void) getObjectResponseFromService:(NSURL *)url {
    @try {
        DDLogDebug(URLLOG, __FUNCTION__, [url absoluteString]);
        // Code to call API in NSData formate and serialize here.
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:kServiceTimeOut];
        NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // handle HTTP errors here
            NSHTTPURLResponse *responseHTTP = (NSHTTPURLResponse *)response;
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSInteger statusCode = [responseHTTP statusCode];
                NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                DDLogDebug(@"Status code: %ld",statusCode);
                NSDictionary *dict = [responseHTTP allHeaderFields];
                DDLogDebug(@"Headers:\n %@",dict.description);
                DDLogDebug(@"Error: %@",error.description);
                DDLogDebug(@"Response data: %@",strResponse);
            }
        }];
        [dataTask resume];
    }
    @catch (NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, __LINE__, [exception description]);
    }
}

@end
