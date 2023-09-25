//
//  APIManager.m
//  mHubApp
//
//  Created by Anshul Jain on 20/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "WSManager.h"

#define kDelayInTime 0.02
#define kServiceTimeOut 1000

@implementation APIManager
{

}


#pragma mark - GET API Methods

+(void) getObjectResponseFromAPI_UsingAFN:(NSURL *)url Version:(APIVersion)version WithCompletion:(void (^)(id objResponse)) handler {
    @try {
        DDLogDebug(URLLOG, __FUNCTION__, [url absoluteString]);
        NSURL *demoURL = [NSURL URLWithString:@"http://cloud.hdanywhere.com/mos/demo/rest/index.php/getmHubDetails"];
        if([url isEqual:demoURL]){
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"mhubdetails.txt"]];
            NSData *JSONData = [NSData dataWithContentsOfFile:filePath];
            NSError *error = nil;
            NSDictionary *demoDict = [NSJSONSerialization JSONObjectWithData:JSONData options: NSJSONReadingMutableContainers error:&error];
            NSLog(@"demoDict %@ documentsDirectory%@",demoDict,filePath);
            switch (version) {
                case APIV1: {
                    APIResponse *objResponse = [APIResponse getObjectFromDictionary:demoDict];
                    //DDLogDebug(@"Response == %@", objResponse.response);
                    handler(objResponse);
                    break;
                }
                case APIV2: {
                    APIV2Response *objResponse = [APIV2Response getObjectFromDictionary:demoDict];
                    //DDLogDebug(@"Response == %@", objResponse.response);
                    handler(objResponse);
                    break;
                }
                default:
                    break;
            }
            
        }
        else{
            if ([Reachability sharedReachability].internetConnectionStatus==NotReachable)  {
                switch (version) {
                    case APIV1: {
                        APIResponse *objReturn = [APIResponse getInternetNotAvailableResponse];
                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.response];
                        handler(objReturn);
                        break;
                    }
                    case APIV2: {
                        APIV2Response *objReturn = [APIV2Response getInternetNotAvailableResponse];
                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.error_description];
                        handler(objReturn);
                        break;
                    }
                    default:
                        break;
                }
            } else {
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                ///[request setTimeoutInterval:kServiceTimeOut];
                [self writeAndAppendString:@"" apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:YES requestParameter:@"empty"];
                NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    if (error) {
                        [self writeAndAppendString:[NSString stringWithFormat:@"ERROR %@",error] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"empty"];
                        switch (version) {
                            case APIV1: {
                                APIResponse *objReturn = [APIResponse getErrorResponse:error];
                                handler(objReturn);
                                break;
                            }
                            case APIV2: {
                                APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
                                handler(objReturn);
                                break;
                            }
                            default:
                                break;
                        }
                    } else {
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                        //NSLog(@"getObjectResponseFromAPI_UsingAFN url %@ \n response%@",url,dict);

                        [self writeAndAppendString:[NSString stringWithFormat:@"%@",dict] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"empty"];
                        switch (version) {
                            case APIV1: {
                                APIResponse *objResponse = [APIResponse getObjectFromDictionary:dict];
                                //DDLogDebug(@"Response == %@", objResponse.response);
                                handler(objResponse);
                                break;
                            }
                            case APIV2: {
                                APIV2Response *objResponse = [APIV2Response getObjectFromDictionary:dict];
                                //DDLogDebug(@"Response == %@", objResponse.response);
                                handler(objResponse);
                                break;
                            }
                            default:
                                break;
                        }
                    }
                }];
                [dataTask resume];
            }
        }
    } @catch (NSException *exception) {
        switch (version) {
            case APIV1: {
                APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
                handler(objReturn);
                break;
            }
            case APIV2: {
                APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
                handler(objReturn);
                break;
            }
            default:
                break;
        }
    }
}

+(void) getObjectResponseFromService:(NSURL *)url Version:(APIVersion)version WithCompletion:(void (^)(id objResponse)) handler {
    @try {
        DDLogDebug(URLLOG, __FUNCTION__, [url absoluteString]);
        // Code to check Internet availability
        if ([Reachability sharedReachability].internetConnectionStatus==NotReachable)  {
            switch (version) {
                case APIV1: {
                    APIResponse *objReturn = [APIResponse getInternetNotAvailableResponse];
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.response];
                    handler(objReturn);
                    break;
                }
                case APIV2: {
                    APIV2Response *objReturn = [APIV2Response getInternetNotAvailableResponse];
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.error_description];
                    handler(objReturn);
                    break;
                }
                default:
                    break;
            }
        } else {
            // Code to call API in NSData formate and serialize here.
            NSError* error = nil;
            NSURLResponse* response;
            //NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kServiceTimeOut];
            //[request setTimeoutInterval:kServiceTimeOut];
            //NSData* dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            [self writeAndAppendString:@"" apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:YES requestParameter:@"empty"];
            NSData* dataResponse = [self sendSynchronousRequest2:url returningResponse:&response error:&error];
          
            // NSLog(@"dataResponse %@",dataResponse);
            NSDictionary* dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:nil];
            // NSLog(@"dictResponse 111 %@",dictResponse);
            // NSData *dataResponse = [NSData dataWithContentsOfURL:url];
            if (dataResponse) {
                NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:&error];
                //NSLog(@"API URL %@ \n response%@",url,jsonData);
                [self writeAndAppendString:[NSString stringWithFormat:@"%@",jsonData] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"empty"];
                if (error) {
                    switch (version) {
                        case APIV1: {
                            APIResponse *objReturn = [APIResponse getErrorResponse:error];
                            handler(objReturn);
                            break;
                        }
                        case APIV2: {
                            APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
                            handler(objReturn);
                            break;
                        }
                        default:
                            break;
                    }
                } else {
                    switch (version) {
                        case APIV1: {
                            APIResponse *objResponse = [APIResponse getObjectFromDictionary:jsonData];
                            //DDLogDebug(@"Response == %@", objResponse.response);
                            handler(objResponse);
                            break;
                        }
                        case APIV2: {
                            APIV2Response *objResponse = [APIV2Response getObjectFromDictionary:jsonData];
                            //DDLogDebug(@"Response == %@", objResponse.response);
                            handler(objResponse);
                            break;
                        }
                        default:
                            break;
                    }
                }
            } else {
                switch (version) {
                        [self writeAndAppendString:[NSString stringWithFormat:@"Error %@",error] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"empty"];
                    case APIV1: {
                        APIResponse *objReturn = [APIResponse getErrorResponse:error];
                        //objReturn.error_description = @"Nil data response";
                        objReturn.response = @"Can't speak to MHUB...";
                        handler(objReturn);
                        break;
                    }
                    case APIV2: {
                        APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
                        objReturn.error_description = @"Can't speak to MHUB...";
                        handler(objReturn);
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }
    @catch (NSException *exception) {
        switch (version) {
            case APIV1: {
                APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
                handler(objReturn);
                break;
            }
            case APIV2: {
                APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
                handler(objReturn);
                break;
            }
            default:
                break;
        }
    }
}

+(void) getObjectResponseFromService_FORWS:(NSURL *)url Version:(APIVersion)version WithCompletion:(void (^)(id objResponse)) handler {
    @try {
        DDLogDebug(URLLOG, __FUNCTION__, [url absoluteString]);
        // Code to check Internet availability
        if ([Reachability sharedReachability].internetConnectionStatus==NotReachable)  {
            switch (version) {
                case APIV1: {
                    APIResponse *objReturn = [APIResponse getInternetNotAvailableResponse];
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.response];
                    handler(objReturn);
                    break;
                }
                case APIV2: {
                    APIV2Response *objReturn = [APIV2Response getInternetNotAvailableResponse];
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.error_description];
                    handler(objReturn);
                    break;
                }
                default:
                    break;
            }
        } else {
            // Code to call API in NSData formate and serialize here.
            NSError* error = nil;
            NSURLResponse* response;
            [self writeAndAppendString:@"" apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:YES requestParameter:@"empty"];
            NSData* dataResponse = [self sendSynchronousRequest2:url returningResponse:&response error:&error];
           
            // NSLog(@"dataResponse %@",dataResponse);
            NSDictionary* dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:nil];
            if (dataResponse) {
                NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:&error];
                [self writeAndAppendString:[NSString stringWithFormat:@"%@",jsonData] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"empty"];
                if (error) {
                    
                    switch (version) {
                        case APIV1: {
                            APIResponse *objReturn = [APIResponse getErrorResponse:error];
                            handler(objReturn);
                            break;
                        }
                        case APIV2: {
                            APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
                            handler(objReturn);
                            break;
                        }
                        default:
                            break;
                    }
                } else {
                    switch (version) {
                        case APIV1: {
                            APIResponse *objResponse = [APIResponse getObjectFromDictionary:jsonData];
                            //DDLogDebug(@"Response == %@", objResponse.response);
                            handler(objResponse);
                            break;
                        }
                        case APIV2: {
                            APIV2Response *objResponse = [APIV2Response getObjectFromDictionary:jsonData];
                            //DDLogDebug(@"Response == %@", objResponse.response);
                            handler(objResponse);
                            break;
                        }
                        default:
                            break;
                    }
                }
            } else {
                switch (version) {
                        [self writeAndAppendString:[NSString stringWithFormat:@"Error %@",error] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"empty"];
                    case APIV1: {
                        APIResponse *objReturn = [APIResponse getErrorResponse:error];
                        
                        //objReturn.error_description = @"Nil data response";
                        objReturn.response = @"Can't speak to MHUB...";
                        handler(objReturn);
                        break;
                    }
                    case APIV2: {
                        APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
                        objReturn.error_description = @"Can't speak to MHUB...";
                        handler(objReturn);
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }
    @catch (NSException *exception) {
        switch (version) {
            case APIV1: {
                APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
                handler(objReturn);
                break;
            }
            case APIV2: {
                APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
                handler(objReturn);
                break;
            }
            default:
                break;
        }
    }
}

+(void) receiveNotification:(NSNotification *) notification {
   // DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
    @try {
        if ([[notification name] isEqualToString:kNotificationWebSocketReceivedResponse]) {
            NSDictionary *dictObj = notification.userInfo;
            NSError* error = nil;
            APIV2Response *objresponse;
            NSString *strOBj = [dictObj objectForKey:@"myKey"];
            NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:[strOBj dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
           // NSLog(@"webSocket received data%@",jsonData);
            if (error) {
                objresponse = [APIV2Response getErrorResponse:error];
                [[AppDelegate appDelegate] showHudView:ShowMessage Message:objresponse.error_description];
            }
            else
            {
                objresponse = [APIV2Response getObjectFromDictionary:jsonData];
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            }
            
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) getObjectFromFileAPI:(NSURL *)url Version:(APIVersion)version FileType:(FileType)fileType IsParsed:(BOOL)isParsed WithCompletion:(void(^)(id objResp))handler {
    @try {
        DDLogDebug(URLLOG, __FUNCTION__, [url absoluteString]);
        // Code to check Internet availability
        if ([Reachability sharedReachability].internetConnectionStatus==NotReachable) {
            switch (version) {
                case APIV1: {
                    APIResponse *objReturn = [APIResponse getInternetNotAvailableResponse];
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.response];
                    handler(objReturn);
                    break;
                }
                case APIV2: {
                    APIV2Response *objReturn = [APIV2Response getInternetNotAvailableResponse];
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.error_description];
                    handler(objReturn);
                    break;
                }
                default:
                    break;
            }
        } else {
            NSError* error = nil;
            NSURLResponse* response;
            // NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kServiceTimeOut];
            //[request setTimeoutInterval:kServiceTimeOut];
            // NSData* dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSData* dataResponse = [self sendSynchronousRequest2:url returningResponse:&response error:&error];
            [self writeAndAppendString:@"" apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:YES requestParameter:[NSString stringWithFormat:@"fileType== %u \n\n isParsed== %u",fileType,isParsed]];
            //NSLog(@"dataResponse %@",dataResponse);
            NSDictionary* dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:nil];
            //NSLog(@"dictResponse 222 %@",dictResponse);
            // handle HTTP errors here
            NSHTTPURLResponse *responseHTTP = (NSHTTPURLResponse *)response;
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSInteger statusCode = [responseHTTP statusCode];
                
                if (statusCode == 404) {
                    NSString *strResponse = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
                    [self writeAndAppendString:strResponse apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"EMPTY"];
                    NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithXMLString:strResponse]] ;
                    dictResponse = [[NSDictionary alloc] initWithDictionary:[Utility parseDictionary:dictResponse]] ;
                    NSString *strErrorResponse = @"";
                    if ([dictResponse isNotEmpty]) {
                        strErrorResponse = [Utility checkNullForKey:@"__text" Dictionary:dictResponse];
                    } else {
                        strErrorResponse = strResponse;
                    }
                    
                    switch (version) {
                        case APIV1: {
                            APIResponse *objReturn = [APIResponse getErrorResponse:error];
                            objReturn.response = strErrorResponse;
                            handler(objReturn);
                            break;
                        }
                        case APIV2: {
                            APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
                            objReturn.error_description = strErrorResponse;
                            handler(objReturn);
                            break;
                        }
                        default:
                            break;
                    }
                } else {
                    if (error) {
                        [self writeAndAppendString:[NSString stringWithFormat:@"ERROR %@",error] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"EMPTY"];
                        switch (version) {
                            case APIV1: {
                                APIResponse *objReturn = [APIResponse getErrorResponse:error];
                                handler(objReturn);
                                break;
                            }
                            case APIV2: {
                                APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
                                handler(objReturn);
                                break;
                            }
                            default:
                                break;
                        }
                    } else {
                        switch (fileType) {
                            case XML: {
                                NSString *xmlString = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
                                NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithXMLString:xmlString]] ;
                                if (isParsed) {
                                    dictResponse = [[NSDictionary alloc] initWithDictionary:[Utility parseDictionary:dictResponse]] ;
                                }
                                [self writeAndAppendString:[NSString stringWithFormat:@"dictResponse %@",dictResponse] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"EMPTY"];
                                switch (version) {
                                    case APIV1: {
                                        APIResponse *objReturn = [APIResponse getObjectFromFile:dictResponse];
                                        handler(objReturn);
                                        break;
                                    }
                                    case APIV2: {
                                        APIV2Response *objReturn = [APIV2Response getObjectFromFile:dictResponse];
                                        handler(objReturn);
                                        break;
                                    }
                                    default:
                                        break;
                                }
                                break;
                            }
                            case JSON: {
                                NSDictionary* dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:nil];
                                // NSLog(@"getObjectFromFileAPI %@ \n response%@",url,dictResponse);
                                [self writeAndAppendString:[NSString stringWithFormat:@"dictResponse %@",dictResponse] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"EMPTY"];
                                //NSLog(@"response dictionary %@",dictResponse);
                                if(url  == [API fileMHUBBENCHMARKREADER:@""])
                                    {
                                    //NSLog(@"response dictionary 22 %@",[dictResponse arr]);
                                    handler(dictResponse);
                                    break;
                                    }
                                else
                                    {
                                    
                                    }
                                if (isParsed) {
                                    dictResponse = [[NSDictionary alloc] initWithDictionary:[Utility parseDictionary:dictResponse]] ;
                                }
                                switch (version) {
                                    case APIV1: {
                                        APIResponse *objReturn = [APIResponse getObjectFromFile:dictResponse];
                                        handler(objReturn);
                                        break;
                                    }
                                    case APIV2: {
                                        APIV2Response *objReturn = [APIV2Response getObjectFromFile:dictResponse];
                                        handler(objReturn);
                                        break;
                                    }
                                    default:
                                        break;
                                }
                                break;
                            }
                            default:
                                break;
                        }
                    }
                }
            } else {
                // DDLogDebug(@"Error: %@",error.description);
                if (error) {
                    [self writeAndAppendString:[NSString stringWithFormat:@"ERROR:%@",error] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"EMPTY"];
                    switch (version) {
                        case APIV1: {
                            APIResponse *objReturn = [APIResponse getErrorResponse:error];
                            handler(objReturn);
                            break;
                        }
                        case APIV2: {
                            APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
                            handler(objReturn);
                            break;
                        }
                        default:
                            break;
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        switch (version) {
            case APIV1: {
                APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
                handler(objReturn);
                break;
            }
            case APIV2: {
                APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
                handler(objReturn);
                break;
            }
            default:
                break;
        }
    }
}

+(void) getResponseFromCGIBIN:(NSURL *)url WithCompletion:(void(^)(APIResponse *objResponse))handler {
    @try {
        DDLogDebug(URLLOG, __FUNCTION__, [url absoluteString]);
        // Code to check Internet availability
        if ([Reachability sharedReachability].internetConnectionStatus==NotReachable)  {
            APIResponse *objReturn = [APIResponse getInternetNotAvailableResponse];
            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.response];
            handler(objReturn);
        } else {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            //[request setTimeoutInterval:kServiceTimeOut];
            [self writeAndAppendString:@"" apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:YES requestParameter:@"EMPTY"];
            NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                // handle HTTP errors here
                NSHTTPURLResponse *responseHTTP = (NSHTTPURLResponse *)response;
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSInteger statusCode = [responseHTTP statusCode];
                    NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [self writeAndAppendString:strResponse apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"EMPTY"];
                    
                    if (statusCode == 404) {
                        APIResponse *objReturn = [[APIResponse alloc] init];
                        objReturn.error = true;
                        objReturn.response = strResponse;
                        handler(objReturn);
                    } else {
                        if (error) {
                            APIResponse *objReturn = [APIResponse getErrorResponse:error];
                            handler(objReturn);
                        } else {
                            //DDLogDebug(@"Response == %@", response);
                            APIResponse *objReturn = [[APIResponse alloc] init];
                            objReturn.error = false;
                            objReturn.response = strResponse;
                            handler(objReturn);
                        }
                    }
                } else {
                    // DDLogDebug(@"Error: %@",error.description);
                    if (error) {
                        [self writeAndAppendString:[NSString stringWithFormat:@"ERROR:%@",error] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:@"EMPTY"];
                        APIResponse *objReturn = [APIResponse getErrorResponse:error];
                        handler(objReturn);
                    }
                }
            }];
            [dataTask resume];
        }
    }
    @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - POST API Methods

+(void) postObjectToAPI_UsingAFN:(NSString *)url Parameter:(id)parameter Version:(APIVersion)version WithCompletion:(void (^)(id objResponse)) handler {
    @try {
        DDLogDebug(URLLOG, __FUNCTION__, url);
        if ([Reachability sharedReachability].internetConnectionStatus==NotReachable)  {
            switch (version) {
                case APIV1: {
                    APIResponse *objReturn = [APIResponse getInternetNotAvailableResponse];
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.response];
                    handler(objReturn);
                    break;
                }
                case APIV2: {
                    APIV2Response *objReturn = [APIV2Response getInternetNotAvailableResponse];
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.error_description];
                    handler(objReturn);
                    break;
                }
                default:
                    break;
            }
        } else {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            /*[manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //DDLogDebug(@"responseObject %@", responseObject);
             NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:responseObject];
             APIResponse *objReturn = [APIResponse getObjectFromDictionary:dict];
             //DDLogDebug(@"Response == %@", objResponse.response);
             handler(objReturn);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             APIResponse *objReturn = [APIResponse getErrorResponse:error];
             handler(objReturn);
             }];*/
            //3030008164-001
            [self writeAndAppendString:@"" apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:YES requestParameter:[NSString stringWithFormat:@"parameter %@",parameter]];
            [manager POST:url parameters:parameter headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //[manager POST:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //DDLogDebug(@"responseObject %@", responseObject);
                NSError *error;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                
                [self writeAndAppendString:[NSString stringWithFormat:@"Success dict:%@",dict] apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:[NSString stringWithFormat:@"parameter %@",parameter]];
                
                switch (version) {
                    case APIV1: {
                        if([url containsString:@"benchmark.json"]){
                            handler(dict);
                        }
                        else if([url containsString:@"api/wireless"])
                            {
                            handler(dict);
                            }else{
                                APIResponse *objResponse = [APIResponse getObjectFromDictionary:dict];
                                //DDLogDebug(@"Response == %@", objResponse.response);
                                handler(objResponse);
                            }
                        break;
                    }
                    case APIV2: {
                        APIV2Response *objResponse = [APIV2Response getObjectFromDictionary:dict];
                        //DDLogDebug(@"Response == %@", objResponse.response);
                        handler(objResponse);
                        break;
                    }
                    default:
                        break;
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self writeAndAppendString:[NSString stringWithFormat:@"Failuare error:%@",error]  apiName:[NSString stringWithFormat:@"URL:%@",url] isFlag:NO requestParameter:[NSString stringWithFormat:@"parameter %@",parameter]];
                switch (version) {
                    case APIV1: {
                        if([url containsString:@"benchmark.json"]){
                            handler(nil);
                        }else{
                            APIResponse *objReturn = [APIResponse getErrorResponse:error];
                            handler(objReturn);
                        }
                        break;
                    }
                    case APIV2: {
                        APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
                        handler(objReturn);
                        break;
                    }
                    default:
                        break;
                }
            }];
        }
    } @catch (NSException *exception) {
        switch (version) {
            case APIV1: {
                APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
                handler(objReturn);
                break;
            }
            case APIV2: {
                APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
                handler(objReturn);
                break;
            }
            default:
                break;
        }
    }
}






/*+(void) postObjectToAPI_UsingAFN:(NSString *)url Parameter:(NSDictionary*)dictParameter WithCompletion:(void (^)(APIResponse *objResponse)) handler{
 @try {
 if ([Reachability sharedReachability].internetConnectionStatus==NotReachable)  {
 APIResponse *objReturn = [APIResponse getInternetNotAvailableResponse];
 [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.response];
 handler(objReturn);
 } else {
 AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
 manager.requestSerializer = [AFJSONRequestSerializer serializer];
 [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 
 [manager POST:url parameters:dictParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 //DDLogDebug(@"responseObject %@", responseObject);
 NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:responseObject];
 APIResponse *objReturn = [APIResponse getObjectFromDictionary:dict];
 //DDLogDebug(@"Response == %@", objResponse.response);
 handler(objReturn);
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 APIResponse *objReturn = [APIResponse getErrorResponse:error];
 handler(objReturn);
 }];
 }
 
 } @catch (NSException *exception) {
 APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
 handler(objReturn);
 }
 }*/

/*+(void) postArrayToAPI_UsingAFN:(NSString *)url Parameter:(NSArray*)arrParameter WithCompletion:(void (^)(APIResponse *objResponse))handler {
 @try {
 if ([Reachability sharedReachability].internetConnectionStatus==NotReachable)  {
 APIResponse *objReturn = [APIResponse getInternetNotAvailableResponse];
 [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.response];
 handler(objReturn);
 } else {
 AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
 manager.requestSerializer = [AFJSONRequestSerializer serializer];
 [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 manager.responseSerializer = [AFHTTPResponseSerializer serializer];
 
 [manager POST:url parameters:arrParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 //DDLogDebug(@"responseObject %@", responseObject);
 NSError *error;
 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
 APIResponse *objReturn = [APIResponse getObjectFromDictionary:dict];
 //DDLogDebug(@"Response == %@", objResponse.response);
 handler(objReturn);
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 APIResponse *objReturn = [APIResponse getErrorResponse:error];
 handler(objReturn);
 }];
 }
 
 } @catch (NSException *exception) {
 APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
 handler(objReturn);
 }
 }*/

#pragma mark - API V1 Methods

#pragma mark - MHUB Config
+(void) mHUBConfigXML_Hub:(Hub*)objHub completion:(void (^)(APIResponse *responseObject))handler {
    @try {
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"mhubconfig.txt"]];
            NSData *JSONData = [NSData dataWithContentsOfFile:filePath];
            NSError *error = nil;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:JSONData options: NSJSONReadingMutableContainers error:&error];
            NSLog(@"demoDict %@ ",jsonData);
            NSString *xmlString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
            NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithXMLString:xmlString]] ;
            dictResponse = [[NSDictionary alloc] initWithDictionary:[Utility parseDictionary:dictResponse]] ;
            
            APIResponse *objReturn = [APIResponse getObjectFromFile:dictResponse];
            APIResponse *objResponse = (APIResponse*)objReturn;
            if (objResponse.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                handler(objResponse);
            } else {
                if ([objResponse.response isKindOfClass:[NSDictionary class]]) {
                    // DDLogDebug(@"objResponse.response == %@", objResponse.response);
                    Hub *objHubReturn = [Hub getHubObjectFromConfigXML:objResponse.response SearchHub:objHub];
                    if (objHubReturn.apiVersion > 1.0) {
                        objResponse.error = true;
                        objResponse.response = HUB_APPUPDATE_MESSAGE;
                    } else {
                        objResponse.error = false;
                        // objResponse.response = (objHubReturn.apiVersion == 0 ? [NSNumber numberWithFloat:1.0] : [NSNumber numberWithFloat:objHubReturn.apiVersion]);
                    }
                    objResponse.response = objHubReturn;
                    handler(objResponse);
                }
            }
        }
        else{
            
            [APIManager getObjectFromFileAPI:[API mHUBConfigXMLURL:objHub.Address] Version:APIV1 FileType:XML IsParsed:true WithCompletion:^(id objResp) {
                APIResponse *objResponse = (APIResponse*)objResp;
                if (objResponse.error) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                    handler(objResponse);
                } else {
                    if ([objResponse.response isKindOfClass:[NSDictionary class]]) {
                        // DDLogDebug(@"objResponse.response == %@", objResponse.response);
                        Hub *objHubReturn = [Hub getHubObjectFromConfigXML:objResponse.response SearchHub:objHub];
                        if (objHubReturn.apiVersion > 1.0) {
                            objResponse.error = true;
                            objResponse.response = HUB_APPUPDATE_MESSAGE;
                        } else {
                            objResponse.error = false;
                            // objResponse.response = (objHubReturn.apiVersion == 0 ? [NSNumber numberWithFloat:1.0] : [NSNumber numberWithFloat:objHubReturn.apiVersion]);
                        }
                        objResponse.response = objHubReturn;
                        handler(objResponse);
                    }
                }
            }];
        }
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}


#pragma mark - MHUB UserProfile
+(void) mHUBUserProfileXML_Hub:(Hub*)objHub completion:(void (^)(APIResponse *responseObject))handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        [APIManager getObjectFromFileAPI:[API mHUBUserProfileXMLURL:objHub.Address] Version:APIV1 FileType:XML IsParsed:true WithCompletion:^(id objResp) {
            APIResponse *objResponse = (APIResponse*)objResp;
            if (objResponse.error) {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                handler(objResponse);
            } else {
                if ([objResponse.response isKindOfClass:[NSDictionary class]]) {
                    Hub *objHubReturn = [Hub getHubObjectFromUserProfileXML:objResponse.response SearchHub:objHub];
                    objResponse.response = objHubReturn;
                    handler(objResponse);
                }
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            }
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - mHUB Audio State XML

+(void) mHUBAudioStateXML_Audio:(Hub*)objAudioDevice completion:(void (^)(APIResponse *responseObject))handler {
    @try {
        if ([objAudioDevice.Address isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            [APIManager getObjectFromFileAPI:[API mHubAudioStateXMLURL:objAudioDevice.Address] Version:APIV1 FileType:XML IsParsed:false WithCompletion:^(id objResp) {
                APIResponse *objResponse = (APIResponse*)objResp;
                if (objResponse.error) {
                    // [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                    handler(objResponse);
                } else {
                    if ([objResponse.response isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:objResponse.response];
                        // DDLogDebug(@"objResponse.response == %@", dictResponse);
                        NSDictionary *dictAudio = [dictResponse objectForKey:@"audio"];
                        if([dictAudio isNotEmpty]) {
                            NSMutableArray* result = [NSMutableArray array];
                            for (NSString* key in dictAudio) {
                                if ([key hasPrefix:@"o"]) {
                                    [result addObject:[dictAudio objectForKey:key]];
                                    // write to a dictionary instead of an array
                                    // if you want to keep the keys too.
                                    NSMutableDictionary *dictRespTemp = [[dictAudio objectForKey:key] mutableCopy];
                                    NSRange replaceRange = [key rangeOfString:@"o"];
                                    NSString* result = @"";
                                    if (replaceRange.location != NSNotFound){
                                        result = [key stringByReplacingCharactersInRange:replaceRange withString:@""];
                                    }
                                    NSInteger intIndex = [result integerValue];
                                    for (int counter = 0; counter < objAudioDevice.HubOutputData.count; counter++) {
                                        OutputDevice *objAOP = [objAudioDevice.HubOutputData objectAtIndex:counter];
                                        if (objAOP.Index == intIndex) {
                                            objAOP.Volume = [[dictRespTemp valueForKey:@"volume"] integerValue];
                                            objAOP.isMute = [[dictRespTemp valueForKey:@"mute"] boolValue];
                                            NSString* resultIP = [dictRespTemp valueForKey:@"switch"];
                                            NSRange replaceRange = [resultIP rangeOfString:@"i"];
                                            if (replaceRange.location != NSNotFound) {
                                                resultIP = [resultIP stringByReplacingCharactersInRange:replaceRange withString:@""];
                                            }
                                            objAOP.InputIndex = [resultIP integerValue];
                                            [objAudioDevice.HubOutputData replaceObjectAtIndex:counter withObject:objAOP];
                                            break;
                                        }
                                    }
                                }
                            }
                            objResponse.response = objAudioDevice;
                        } else {
                            objResponse.error = true;
                        }
                    } else {
                        objResponse.error = true;
                    }
                    handler(objResponse);
                }
            }];
        }
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - getmHubDetails
+(void) getmHubDetails_DataSync:(BOOL)isSync completion:(void (^)(APIResponse *responseObject))handler {
    @try {
        [APIManager mHUBConfigXML_Hub:mHubManagerInstance.objSelectedHub completion:^(APIResponse *responseObject) {
            if (responseObject.error) {
                APIResponse *objReturn = [[APIResponse alloc] init];
                objReturn.error = true;
                objReturn.response = responseObject.response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    [[AppDelegate appDelegate] methodToCheckUpdatedVersionOnAppStore];
                });
                handler(objReturn);
            } else {
                // mHubManagerInstance.appApiVersion = [responseObject.response floatValue];
                [APIManager getObjectResponseFromAPI_UsingAFN:[API getmHubDetailsURL: mHubManagerInstance.objSelectedHub.Address] Version:APIV1 WithCompletion:^(id objResponse) {
                    APIResponse *objResp = (APIResponse*)objResponse;
                    if (objResp.error) {
                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResp.response];
                        handler(objResp);
                    } else {
                        Hub *objHub = [Hub getObjectFromDictionary:objResp.response DataSync:isSync];
                        objHub.modelName = [Hub getModelName:mHubManagerInstance.objSelectedHub];
                        
                        if (!isSync) {
                            objHub.HubInputData = mHubManagerInstance.objSelectedHub.HubInputData;
                            objHub.HubOutputData = mHubManagerInstance.objSelectedHub.HubOutputData;
                            objHub.HubSequenceList = mHubManagerInstance.objSelectedHub.HubSequenceList;
                            objHub.HubControlsList = mHubManagerInstance.objSelectedHub.HubControlsList;
                            objHub.HubAVRList = mHubManagerInstance.objSelectedHub.HubAVRList;
                        }
                        mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objHub];
                        [mHubManagerInstance syncGlobalManagerObjectV1];
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        objResp.response = objHub;
                        handler(objResp);
                    }
                }];
            }
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) resyncMHUBProData {
    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
    [APIManager getmHubDetails_DataSync:true completion:^(APIResponse *responseObject) {
        if (responseObject.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([responseObject.response isEqualToString:HUB_APPUPDATE_MESSAGE]) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.response];
                } else {
                    if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
                        [[SearchDataManager sharedInstance] startSearchNetwork];
                        [SearchDataManager sharedInstance].delegate = self;
                    }
                }
            });
        }
        [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
        [APIManager reloadDisplaySubView];
        [APIManager reloadSourceSubView];
    }];
}

#pragma mark - getIREngineStatus
+(void) getInputIREngineStatus:(NSInteger)intSourceIndex completion:(void (^)(APIResponse *responseObject)) handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"input%ld.txt",(long)intSourceIndex]];
            NSData *JSONData = [NSData dataWithContentsOfFile:filePath];
            NSError *error = nil;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:JSONData options: NSJSONReadingMutableContainers error:&error];
            // NSLog(@"demoDict %@ documentsDirectory%@",jsonData,filePath);
            APIResponse *objResp = [APIResponse getObjectFromDictionary:jsonData];
#ifdef kFilenameTempInputIRPack
            objResp = [APIResponse getObjectFromDictionary:[Utility getDictionaryFromJSONFile:kFilenameTempInputIRPack]];
            handler(objResp);
#else
            handler(objResp);
#endif
        }
        else{
            [APIManager getObjectResponseFromService:[API getIREngineStatusURL:intSourceIndex] Version:APIV1 WithCompletion:^(id objResponse) {
                APIResponse *objResp = (APIResponse*)objResponse;
#ifdef kFilenameTempInputIRPack
                objResp = [APIResponse getObjectFromDictionary:[Utility getDictionaryFromJSONFile:kFilenameTempInputIRPack]];
                handler(objResp);
#else
                handler(objResp);
#endif
            }];
        }
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) getOutputIREngineStatus:(NSInteger)intSourceIndex completion:(void (^)(APIResponse *responseObject)) handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"output%ld.txt",(long)intSourceIndex-8]];
            NSData *JSONData = [NSData dataWithContentsOfFile:filePath];
            NSError *error = nil;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:JSONData options: NSJSONReadingMutableContainers error:&error];
            //NSLog(@"demoDict %@ documentsDirectory%@",jsonData,filePath);
            APIResponse *objResp = [APIResponse getObjectFromDictionary:jsonData];
            handler(objResp);
        }
        else{
            [APIManager getObjectResponseFromService:[API getIREngineStatusURL:intSourceIndex] Version:APIV1 WithCompletion:^(id objResponse) {
                APIResponse *objResp = (APIResponse*)objResponse;
                handler(objResp);
            }];
        }
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) getAVRIREngineStatus:(NSInteger)intAVRIndex completion:(void (^)(APIResponse *responseObject)) handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"avr.txt"]];
            NSData *JSONData = [NSData dataWithContentsOfFile:filePath];
            NSError *error = nil;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:JSONData options: NSJSONReadingMutableContainers error:&error];
            //NSLog(@"demoDict %@ documentsDirectory%@",jsonData,filePath);
            APIResponse *objResp = [APIResponse getObjectFromDictionary:jsonData];
#ifdef kFilenameTempInputIRPack
            objResp = [APIResponse getObjectFromDictionary:[Utility getDictionaryFromJSONFile:kFilenameTempInputIRPack]];
            handler(objResp);
#else
            handler(objResp);
#endif
        }
        else
            {
            [APIManager getObjectResponseFromService:[API getIREngineStatusURL:intAVRIndex] Version:APIV1 WithCompletion:^(id objResponse) {
                APIResponse *objResp = (APIResponse*)objResponse;
#ifdef kFilenameTempInputIRPack
                objResp = [APIResponse getObjectFromDictionary:[Utility getDictionaryFromJSONFile:kFilenameTempInputIRPack]];
                handler(objResp);
#else
                handler(objResp);
#endif
            }];
            }
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - getSwitchStatus
+(void) getSwitchStatus:(NSInteger)intOutputIndex completion:(void (^)(APIResponse *responseObject)) handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            NSInteger intInputIndex = intOutputIndex;
            for (InputDevice *objInput in mHubManagerInstance.objSelectedHub.HubInputData) {
                if (objInput.Index == intInputIndex) {
                    id cacheCommandData = [CommandType retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objInput.PortNo]];
                    if ([cacheCommandData isNotEmpty]) {
                        if ([cacheCommandData isKindOfClass:[CommandType class]]) {
                            objInput.objCommandType = cacheCommandData;
                        } else {
                            objInput.objCommandType = [[CommandType alloc]init];
                        }
                        id cacheContinuityData = [ContinuityCommand retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objInput.PortNo]];
                        if ([cacheContinuityData isNotEmpty] && [cacheContinuityData isKindOfClass:[NSMutableArray class]]) {
                            objInput.arrContinuity = cacheContinuityData;
                        } else {
                            objInput.arrContinuity = [[NSMutableArray alloc] init];
                        }
                    } else {
                        [APIManager getInputIREngineStatus:objInput.PortNo completion:^(APIResponse *responseObject) {
                            if (responseObject.error) {
                                objInput.sourceType = Uncontrollable;
                                objInput.objCommandType = [[CommandType alloc]init];
                                objInput.arrContinuity = [[NSMutableArray alloc] init];
                            } else {
                                ControlPack *objControlPack = [ControlPack getObjectFromDictionary:responseObject.response];
                                objInput.sourceType = InputSource;
                                objInput.objCommandType = [CommandType getObjectForInput_fromArray:objControlPack.appUI];
                                objInput.arrContinuity = [[NSMutableArray alloc] initWithArray:objControlPack.continuity];
                            }
                            [CommandType saveCustomObject:objInput.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objInput.PortNo]];
                            [ContinuityCommand saveCustomObject:objInput.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objInput.PortNo]];
                        }];
                    }
                    mHubManagerInstance.objSelectedInputDevice = objInput;
                    [ContinuityCommand saveCustomObject:[ContinuityCommand getDictionaryArray:objInput.arrContinuity] key:kSELECTEDCONTINUITYARRAY];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        APIResponse *objReturn = [[APIResponse alloc] init];
                        objReturn.error = false;
                        objReturn.response = objInput;
                        handler(objReturn);
                    });
                    break;
                } else {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                }
            }
        } else {
            [APIManager getResponseFromCGIBIN:[API getSwitchStatusURL:intOutputIndex] WithCompletion:^(APIResponse *objResponse) {
                if (objResponse.error) {
                    mHubManagerInstance.objSelectedInputDevice = nil;
                    [ContinuityCommand saveCustomObject:@[] key:kSELECTEDCONTINUITYARRAY];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                        handler(objResponse);
                    });
                } else {
                    [NSThread sleepForTimeInterval:kDelayInTime];
                    [APIManager getResponseFromCGIBIN:[API irEngineURL_Query] WithCompletion:^(APIResponse *objResponse) {
                        if (objResponse.error) {
                            mHubManagerInstance.objSelectedInputDevice = nil;
                            [ContinuityCommand saveCustomObject:@[] key:kSELECTEDCONTINUITYARRAY];
                            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                            handler(objResponse);
                        } else {
                            NSArray *arrResp = [objResponse.response componentsSeparatedByString:@" "];
                            NSInteger intInputIndex = 0;
                            if (arrResp.count > 1) {
                                intInputIndex = [[arrResp objectAtIndex:1] integerValue];
                            }
                            for (InputDevice *objInput in mHubManagerInstance.objSelectedHub.HubInputData) {
                                if (objInput.Index == intInputIndex) {
                                    id cacheCommandData = [CommandType retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objInput.PortNo]];
                                    if ([cacheCommandData isNotEmpty]) {
                                        if ([cacheCommandData isKindOfClass:[CommandType class]]) {
                                            objInput.objCommandType = cacheCommandData;
                                        } else {
                                            objInput.objCommandType = [[CommandType alloc]init];
                                        }
                                        
                                        id cacheContinuityData = [ContinuityCommand retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objInput.PortNo]];
                                        if ([cacheContinuityData isNotEmpty] && [cacheContinuityData isKindOfClass:[NSMutableArray class]]) {
                                            objInput.arrContinuity = cacheContinuityData;
                                        } else {
                                            objInput.arrContinuity = [[NSMutableArray alloc] init];
                                        }
                                    } else {
                                        [APIManager getInputIREngineStatus:objInput.PortNo completion:^(APIResponse *responseObject) {
                                            if (responseObject.error) {
                                                objInput.sourceType = Uncontrollable;
                                                objInput.objCommandType = [[CommandType alloc]init];
                                                objInput.arrContinuity = [[NSMutableArray alloc] init];
                                            } else {
                                                ControlPack *objControlPack = [ControlPack getObjectFromDictionary:responseObject.response];
                                                objInput.sourceType = InputSource;
                                                objInput.objCommandType = [CommandType getObjectForInput_fromArray:objControlPack.appUI];
                                                objInput.arrContinuity = [[NSMutableArray alloc] initWithArray:objControlPack.continuity];
                                            }
                                            [CommandType saveCustomObject:objInput.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objInput.PortNo]];
                                            [ContinuityCommand saveCustomObject:objInput.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objInput.PortNo]];
                                        }];
                                    }
                                    mHubManagerInstance.objSelectedInputDevice = objInput;
                                    // [mHubManager saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                                    [ContinuityCommand saveCustomObject:[ContinuityCommand getDictionaryArray:objInput.arrContinuity] key:kSELECTEDCONTINUITYARRAY];
                                    break;
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                                handler(objResponse);
                            });
                        }
                    }];
                }
            }];
        }
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - putSwitchIn
+(void) putSwitchIn_OutputIndex:(NSInteger)intOutputIndex InputIndex:(NSInteger)intInputIndex completion:(void (^)(APIResponse *responseObject)) handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            for (InputDevice *objInput in mHubManagerInstance.objSelectedHub.HubInputData) {
                if (objInput.Index == intInputIndex) {
                    id cacheCommandData = [CommandType retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objInput.PortNo]];
                    if ([cacheCommandData isNotEmpty]) {
                        if ([cacheCommandData isKindOfClass:[CommandType class]]) {
                            objInput.objCommandType = cacheCommandData;
                        } else {
                            objInput.objCommandType = [[CommandType alloc]init];
                        }
                        
                        id cacheContinuityData = [ContinuityCommand retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objInput.PortNo]];
                        if ([cacheContinuityData isNotEmpty] && [cacheContinuityData isKindOfClass:[NSMutableArray class]]) {
                            objInput.arrContinuity = cacheContinuityData;
                        } else {
                            objInput.arrContinuity = [[NSMutableArray alloc] init];
                        }
                    } else {
                        [APIManager getInputIREngineStatus:objInput.PortNo completion:^(APIResponse *responseObject) {
                            if (responseObject.error) {
                                objInput.sourceType = Uncontrollable;
                                objInput.objCommandType = [[CommandType alloc]init];
                                objInput.arrContinuity = [[NSMutableArray alloc] init];
                            } else {
                                ControlPack *objControlPack = [ControlPack getObjectFromDictionary:responseObject.response];
                                objInput.sourceType = InputSource;
                                objInput.objCommandType = [CommandType getObjectForInput_fromArray:objControlPack.appUI];
                                objInput.arrContinuity = [[NSMutableArray alloc] initWithArray:objControlPack.continuity];
                            }
                            [CommandType saveCustomObject:objInput.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objInput.PortNo]];
                            [ContinuityCommand saveCustomObject:objInput.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objInput.PortNo]];
                        }];
                    }
                    mHubManagerInstance.objSelectedInputDevice = objInput;
                    [ContinuityCommand saveCustomObject:[ContinuityCommand getDictionaryArray:objInput.arrContinuity] key:kSELECTEDCONTINUITYARRAY];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        APIResponse *objReturn = [[APIResponse alloc] init];
                        objReturn.error = false;
                        objReturn.response = objInput;
                        handler(objReturn);
                    });
                    break;
                }
            }
        } else {
            [APIManager getResponseFromCGIBIN:[API switchInURL_OutputIndex:intOutputIndex InputIndex:intInputIndex] WithCompletion:^(APIResponse *objResponse) {
                for (InputDevice *objInput in mHubManagerInstance.objSelectedHub.HubInputData) {
                    if (objInput.Index == intInputIndex) {
                        id cacheCommandData = [CommandType retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objInput.PortNo]];
                        if ([cacheCommandData isNotEmpty]) {
                            if ([cacheCommandData isKindOfClass:[CommandType class]]) {
                                objInput.objCommandType = cacheCommandData;
                            } else {
                                objInput.objCommandType = [[CommandType alloc]init];
                            }
                            
                            id cacheContinuityData = [ContinuityCommand retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objInput.PortNo]];
                            if ([cacheContinuityData isNotEmpty] && [cacheContinuityData isKindOfClass:[NSMutableArray class]]) {
                                objInput.arrContinuity = cacheContinuityData;
                            } else {
                                objInput.arrContinuity = [[NSMutableArray alloc] init];
                            }
                        } else {
                            [APIManager getInputIREngineStatus:objInput.PortNo completion:^(APIResponse *responseObject) {
                                if (responseObject.error) {
                                    objInput.sourceType = Uncontrollable;
                                    objInput.objCommandType = [[CommandType alloc]init];
                                    objInput.arrContinuity = [[NSMutableArray alloc] init];
                                } else {
                                    ControlPack *objControlPack = [ControlPack getObjectFromDictionary:responseObject.response];
                                    objInput.sourceType = InputSource;
                                    objInput.objCommandType = [CommandType getObjectForInput_fromArray:objControlPack.appUI];
                                    objInput.arrContinuity = [[NSMutableArray alloc] initWithArray:objControlPack.continuity];
                                }
                                [CommandType saveCustomObject:objInput.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objInput.PortNo]];
                                [ContinuityCommand saveCustomObject:objInput.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objInput.PortNo]];
                            }];
                        }
                        mHubManagerInstance.objSelectedInputDevice = objInput;
                        // [mHubManager saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                        [ContinuityCommand saveCustomObject:[ContinuityCommand getDictionaryArray:objInput.arrContinuity] key:kSELECTEDCONTINUITYARRAY];
                        break;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    handler(objResponse);
                });
            }];
        }
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - IREngine Commands/Code
+(void) irEngine_CommandId:(NSInteger)intCommandId PortId:(NSInteger)intPortId {
    @try {
        [APIManager getObjectResponseFromService:[API irEngineURL_CommandId:intCommandId PortId:intPortId] Version:APIV1 WithCompletion:^(id objResponse) {
            APIResponse *objResp = (APIResponse*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.response];
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) irEngine_Code:(NSString *)strCode PortId:(NSInteger)intPortId {
    @try {
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            //DDLogDebug(@"<%s> Code = %@, PortId = %ld", __PRETTY_FUNCTION__, strCode, (long)intPortId);
        } else {
            [APIManager getResponseFromCGIBIN:[API irEngineURL_Code:strCode PortId:intPortId] WithCompletion:^(APIResponse *objResponse) {
                //  [APIManager getResponseFromCGIBIN:[API irEngineURL_Query] WithCompletion:^(APIResponse *objResponse) {
                //      DDLogDebug(@"Response == %@", responseObject);
                //  }];
            }];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


+(void) callIRCommand:(Command*)objCmd PortNo:(NSInteger)intPort {
    @try {
        if (intPort == 0) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:HUB_SELECTEDDEVICE];
        } else {
            //DDLogDebug(@"objCmd.command_id == %d", objCmd.command_id);
            //[APIManager irEngine_CommandId:objCmd.command_id PortId:intPort];
            [APIManager irEngine_Code:objCmd.code PortId:intPort];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - getSequenceList
+(void) getSequenceList:(NSString*)strMOSVersion completion:(void (^)(APIResponse *responseObject))handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"getSequenceList.txt"]];
            NSData *JSONData = [NSData dataWithContentsOfFile:filePath];
            NSError *error = nil;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:JSONData options: NSJSONReadingMutableContainers error:&error];
            APIResponse *objResponse = [APIResponse getObjectFromDictionary:jsonData];
            APIResponse *objResp = (APIResponse*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                handler(objResp);
            } else {
                NSMutableArray *arrSequence = [[NSMutableArray alloc] initWithArray:[Sequence getObjectArray:objResp.response]];
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                objResp.response = arrSequence;
                handler(objResp);
            }
    
        }
        else{
            NSString *strMOSVersion = strMOSVersion;
            if ([strMOSVersion isEqualToString:@"7.01"]) {
                // if (mHubManagerInstance.mosVersion >= 7.02) {
                [APIManager getObjectFromFileAPI:[API mHUBMacrosXMLURL: mHubManagerInstance.objSelectedHub.Address] Version:APIV1 FileType:XML IsParsed:false WithCompletion:^(id objResp) {
                    APIResponse *objResponse = (APIResponse*)objResp;
                    if (objResponse.error) {
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        handler(objResponse);
                    } else {
                        NSMutableArray *arrSequence = [[NSMutableArray alloc] initWithArray:[Sequence getObjectXMLArray:objResponse.response]];
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        objResponse.response = arrSequence;
                        handler(objResponse);
                    }
                }];
            } else {
                [APIManager getObjectResponseFromService:[API getSequenceListURL] Version:APIV1 WithCompletion:^(id objResponse) {
                    APIResponse *objResp = (APIResponse*)objResponse;
                    if (objResp.error) {
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        handler(objResp);
                    } else {
                        NSMutableArray *arrSequence = [[NSMutableArray alloc] initWithArray:[Sequence getObjectArray:objResp.response]];
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        objResp.response = arrSequence;
                        handler(objResp);
                    }
                }];
            }
        }
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - playMacro
+(void) playMacro_AlexaName:(NSString*)strAlexaName completion:(void (^)(APIResponse *responseObject)) handler {
    @try {
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            //DDLogDebug(@"<%s> AlexaName = %@", __PRETTY_FUNCTION__, strAlexaName);
            APIResponse *objReturn = [[APIResponse alloc] init];
            objReturn.error = false;
            objReturn.response = strAlexaName;
            handler(objReturn);
        } else {
            [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
            [APIManager getObjectResponseFromAPI_UsingAFN:[API playMacro:strAlexaName] Version:APIV1 WithCompletion:^(id objResponse) {
                APIResponse *objResp = (APIResponse*)objResponse;
                //DDLogDebug(@"<%s:\n %@>", __PRETTY_FUNCTION__, objResponse.response);
                if (objResp.error) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResp.response];
                    handler(objResp);
                } else {
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.response];
                    handler(objResp);
                }
            }];
        }
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - Reload SubViews
+(void) reloadSourceSubView {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadInput object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadSourceControl object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadControlVC_ViewWillAppear object:self];
}

+(void) reloadDisplaySubView {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadOutput object:self];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadOutputControl object:self];
}

#pragma mark - MHUB V3 XML
+(void) getSSDPServiceXML_Service:(SSDPService *)service completion:(void (^)(APIResponse *responseObject))handler {
    @try {
        [APIManager getObjectFromFileAPI:service.location Version:APIV1 FileType:XML IsParsed:true WithCompletion:^(id objResp) {
            APIResponse *objResponse = (APIResponse*)objResp;
            if ([objResponse.response isKindOfClass:[NSDictionary class]]) {
                Hub *objHub = [Hub getObjectFromSSDPXMLDictionary:objResponse.response];
                for(NSString * toContain in [NSArray arrayWithObjects:@"mhub", @"hda", @"hdanywhere", @"hd", nil]){
                    if ([[objHub.Name lowercaseString] containsString:toContain] || [[objHub.modelName lowercaseString] containsString:toContain]) {
                        objResponse.response = objHub;
                        handler(objResponse);
                    }
                }
            } else {
                objResponse.error = true;
                handler(objResponse);
            }
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - Cloud API Methods
+(void) postCloudRegistration:(NSDictionary *)dictParameter completion:(void (^)(APIResponse *objResponse)) handler {
    @try {
        [APIManager postObjectToAPI_UsingAFN:[API cloudRegistrationURL] Parameter:dictParameter Version:APIV1 WithCompletion:^(id objResponse) {
            APIResponse *objResp = (APIResponse*)objResponse;
            handler(objResp);
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) postCloudLogin:(NSDictionary *)dictParameter completion:(void (^)(APIResponse *objResponse)) handler {
    @try {
        [APIManager postObjectToAPI_UsingAFN:[API cloudLoginURL] Parameter:dictParameter Version:APIV1 WithCompletion:^(id objResponse) {
            APIResponse *objResp = (APIResponse*)objResponse;
            if (objResp.error) {
                handler(objResp);
            } else {
                objResp.data = [CloudData getObjectArray:objResp.data];
                handler(objResp);
            }
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) postCloudBackup:(NSDictionary *)dictParameter completion:(void (^)(APIResponse *objResponse)) handler {
    @try {
        [APIManager postObjectToAPI_UsingAFN:[API cloudBackupURL] Parameter:dictParameter Version:APIV1 WithCompletion:^(id objResponse) {
            APIResponse *objResp = (APIResponse*)objResponse;
            handler(objResp);
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) fetchCloudBackup:(NSDictionary *)dictParameter completion:(void (^)(APIResponse *objResponse)) handler {
    @try {
        [APIManager postObjectToAPI_UsingAFN:[API cloudFetchBackupURL] Parameter:dictParameter Version:APIV1 WithCompletion:^(id objResponse) {
            APIResponse *objResp = (APIResponse*)objResponse;
            if (objResp.error) {
                handler(objResp);
            } else {
                Hub *objHub = [Hub getObjectFromDictionary:objResp.response DataSync:true];
                if (![objHub.Address isIPAddressEmpty] && objHub.InputCount > 0 && objHub.OutputCount > 0 && [objHub.HubInputData isNotEmpty] && [objHub.HubOutputData isNotEmpty]) {
                    objHub.Generation = mHub4KV3;
                    objHub.modelName = [Hub getModelName:objHub];
                    objHub.Address = mHubManagerInstance.objSelectedHub.Address;
                    mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objHub];
                    objResp.response = objHub;
                    handler(objResp);
                } else {
                    objResp.response = mHubManagerInstance.objSelectedHub;
                    handler(objResp);
                }
            }
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - Method to check for updated version on App Store
+(void) methodToCheckUpdatedVersionOnAppStore_WithCompletion:(void(^)(BOOL isUpdate))handler {
    @try {
        if ([Reachability sharedReachability].internetConnectionStatus==NotReachable)  {
            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:ALERT_MESSAGE_INTERNETNOTAVAILABEL];
            return;
        }
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString* appID = infoDictionary[@"CFBundleIdentifier"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"data %@ %@ %@",data,response,error);
            if(error)
            {
                return;
            }
            NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
            if (handler) {
                if ([lookup[@"resultCount"] integerValue] == 1){
                    NSString *strAppStoreVer = lookup[@"results"][0][@"version"];
                    NSString *strCurrentVer = infoDictionary[@"CFBundleShortVersionString"];
                    NSArray *appStoreVer = [strAppStoreVer componentsSeparatedByString:@"."];
                    NSArray *currentVer = [strCurrentVer componentsSeparatedByString:@"."];
                    // *** Testing Version Check Array In Reverse Case *** //
                    // NSArray *currentVer = [strAppStoreVer componentsSeparatedByString:@"."];
                    // NSArray *appStoreVer = [strCurrentVer componentsSeparatedByString:@"."];
                    
                    DDLogDebug(@"\nAppStoreVer == %@ \nCurrentVer == %@", strAppStoreVer, strCurrentVer);
                    
                    BOOL isLower = NO;
                    if(appStoreVer.count <= currentVer.count) {
                        for(int i=0;i<appStoreVer.count;i++) {
                            if([[appStoreVer objectAtIndex:i]intValue] > [[currentVer objectAtIndex:i]intValue]) {
                                if (i>0) {
                                    if ([[appStoreVer objectAtIndex:i-1]intValue] == [[currentVer objectAtIndex:i-1]intValue]) {
                                        isLower = YES;
                                        break;
                                    }
                                } else {
                                    isLower = YES;
                                    break;
                                }
                            }
                        }
                    } else if (appStoreVer.count > currentVer.count) {
                        for(int i=0;i<currentVer.count;i++) {
                            if([[appStoreVer objectAtIndex:i]intValue] > [[currentVer objectAtIndex:i]intValue]) {
                                isLower = YES;
                                break;
                            }
                        }
                    }
                    handler(isLower);
                }
            }
        }];
        [task resume];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - API V2 Methods

#pragma mark - MHUB Config
+(void) fileMHUBConfigJSON_Hub:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
//        if([objHub.Address isEqual:@"192.168.1.9"] || [objHub.Address isEqual:@"192.168.1.99"])
//        {
//            return;
//        }
        [APIManager getObjectFromFileAPI:[API fileMHUBConfigJSONURL:objHub.Address] Version:APIV2 FileType:JSON IsParsed:true WithCompletion:^(id objResp) {
            APIV2Response *objResponse = (APIV2Response*)objResp;
            if (objResponse.error) {
                handler(objResponse);
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
            } else {
                if ([objResponse.data_description isKindOfClass:[NSDictionary class]]) {
                    // DDLogDebug(@"objResponse.response == %@", objResponse.response);
                    //NSLog(@"objHub.Address1117 %@ serial no %@",objHub.Address,objHub.SerialNo);
                    Hub *objHubReturn = [Hub getHubObjectFromConfigJSON:objResponse.data_description SearchHub:objHub];
                    //NSLog(@"objHub.Address1118 %@ serial no %@",objHub.Address,objHub.SerialNo);
                    objResponse.data_description = objHubReturn;
                    NSLog(@"objHub.Address1118 %@ serial no %f",objHub.Address,objHub.mosVersion);

                    handler(objResponse);
                }
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - MHUB Benchmark details
+(void) fileMHUBBenchmark_details:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        
        //[APIMana]
        [APIManager getObjectFromFileAPI:[API fileMHUBBENCHMARKREADER:objHub.Address] Version:APIV2 FileType:JSON IsParsed:true WithCompletion:^(id objResp) {
            APIV2Response *objResponse = (APIV2Response*)objResp;
            if (objResponse.error) {
                handler(objResponse);
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
            } else {
                DDLogDebug(@"fileMHUBBenchmark_details == %@", objResponse);
                handler(objResponse);
                //                if ([objResponse.data_description isKindOfClass:[NSDictionary class]]) {
                //                    // DDLogDebug(@"objResponse.response == %@", objResponse.response);
                //                    Hub *objHubReturn = [Hub getHubObjectFromConfigJSON:objResponse.data_description SearchHub:objHub];
                //                    objResponse.data_description = objHubReturn;
                //
                //                }
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - MHUB UserProfile
+(void) fileMHUBUserProfileJSON_Hub:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectFromFileAPI:[API fileMHUBUserProfileJSONURL:objHub.Address] Version:APIV2 FileType:JSON IsParsed:false WithCompletion:^(id objResp) {
            APIV2Response *objResponse = (APIV2Response*)objResp;
            if (objResponse.error) {
                handler(objResponse);
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
            } else {
                if ([objResponse.data_description isKindOfClass:[NSDictionary class]]) {
                    // DDLogDebug(@"objResponse.response == %@", objResponse.response);
                    
                    Hub *objHubReturn = [Hub getHubObjectFromUserProfileJSON:objResponse.data_description SearchHub:objHub];
                    objResponse.data_description = objHubReturn;
                    handler(objResponse);
                }
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - mHUB Pair JSON

+(void) filePairJSON_Hub:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectFromFileAPI:[API filePairJSONURL:objHub.Address] Version:APIV2 FileType:JSON IsParsed:false WithCompletion:^(id objResp) {
            APIV2Response *objResponse = (APIV2Response*)objResp;
            if (objResponse.error) {
                [APIManager fileMasterJSON_Hub:objHub completion:^(APIV2Response *responseObject) {
                    // [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                    handler(responseObject);
                }];
            } else {
                if ([objResponse.data_description isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:objResponse.data_description];
                    // DDLogDebug(@"objResponse.response == %@", dictResponse);
                    Pair *objPair = [Pair getObjectFromDictionary:dictResponse];
                    objResponse.data_description = objPair;
                } else {
                    objResponse.error = true;
                }
                handler(objResponse);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - mHUB Master JSON

+(void) fileMasterJSON_Hub:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectFromFileAPI:[API fileMasterJSONURL:objHub.Address] Version:APIV2 FileType:JSON IsParsed:false WithCompletion:^(id objResp) {
            APIV2Response *objResponse = (APIV2Response*)objResp;
            if (objResponse.error) {
                // [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                handler(objResponse);
            } else {
                if ([objResponse.data_description isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:objResponse.data_description];
                    // DDLogDebug(@"objResponse.response == %@", dictResponse);
                    Pair *objPair = [Pair getObjectFromDictionary:dictResponse];
                    objResponse.data_description = objPair;
                } else {
                    objResponse.error = true;
                }
                handler(objResponse);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - mHUB IO JSON
+(void) fileIOJSON_Hub:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectFromFileAPI:[API fileIOJSONURL:objHub.Address] Version:APIV2 FileType:JSON IsParsed:false WithCompletion:^(id objResp) {
            APIV2Response *objResponse = (APIV2Response*)objResp;
            if (objResponse.error) {
                // [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                handler(objResponse);
            } else {
                if ([objResponse.data_description isKindOfClass:[NSDictionary class]]) {
                    // NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:objResponse.data_description];
                    // DDLogDebug(@"objResponse.response == %@", dictResponse);
                } else {
                    objResponse.error = true;
                }
                handler(objResponse);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - mHUB State JSON
+(void) fileStateJSON_Hub:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectFromFileAPI:[API fileStateJSONURL:objHub.Address] Version:APIV2 FileType:JSON IsParsed:false WithCompletion:^(id objResp) {
            APIV2Response *objResponse = (APIV2Response*)objResp;
            if (objResponse.error) {
                // [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                handler(objResponse);
            } else {
                if ([objResponse.data_description isKindOfClass:[NSDictionary class]]) {
                    //NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:objResponse.data_description];
                    // DDLogDebug(@"objResponse.response == %@", dictResponse);
                } else {
                    objResponse.error = true;
                }
                handler(objResponse);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - mHUB IRPack XML
+(void) fileIRPackXML_Hub:(Hub*)objHub PortId:(NSInteger)intPortId completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectFromFileAPI:[API fileIRPackXMLURL:objHub.Address PortId:intPortId] Version:APIV2 FileType:XML IsParsed:false WithCompletion:^(id objResp) {
            APIV2Response *objResponse = (APIV2Response*)objResp;
            if (objResponse.error) {
                // [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResponse.response];
                handler(objResponse);
            } else {
                if ([objResponse.data_description isKindOfClass:[NSDictionary class]]) {
                    // NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:objResponse.data_description];
                    // DDLogDebug(@"objResponse.response == %@", dictResponse);
                } else {
                    objResponse.error = true;
                }
                handler(objResponse);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark -
+(void) fileAllJSONDetails:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        // NSLog(@"objHub.Address1117 %@ serial no %@",objHub.Address,objHub.SerialNo);
        
        [APIManager fileMHUBConfigJSON_Hub:objHub completion:^(APIV2Response *responseObject) {
            if (responseObject.error) {
                handler(responseObject);
            } else {
              //  NSLog(@"response %@ ",(Hub *)responseObject.data_description);
                Hub *objHubAPI = (Hub *)responseObject.data_description;
               // NSLog(@"objHub.Address1118 %@ serial no %@",objHubAPI.Address,objHubAPI.SerialNo);

                if ([objHubAPI.Name isNotEmpty]) {
                    objHub.Name = objHubAPI.Name;
                }
                
                if ([objHubAPI.modelName isNotEmpty]) {
                    objHub.modelName = objHubAPI.modelName;
                }
                
                if ([objHubAPI.Official_Name isNotEmpty]) {
                    objHub.Official_Name = objHubAPI.Official_Name;
                }
                if (![objHubAPI.Address isIPAddressEmpty]) {
                    objHub.Address = objHubAPI.Address;
                }
                
                if ([objHubAPI.SerialNo isNotEmpty]) {
                    objHub.SerialNo = objHubAPI.SerialNo;
                }
                objHub.Address = objHubAPI.Address;
                if (objHubAPI.apiVersion != 0) {
                    objHub.apiVersion = objHubAPI.apiVersion;
                }
                
                if (objHubAPI.mosVersion != 0) {
                    objHub.mosVersion = objHubAPI.mosVersion;
                }
                
                if ([objHubAPI.strMOSVersion isNotEmpty]) {
                    objHub.strMOSVersion = objHubAPI.strMOSVersion;
                }
                
                [APIManager fileMHUBUserProfileJSON_Hub:objHub completion:^(APIV2Response *responseObject) {
                    if (!responseObject.error) {
                        Hub *objHubAPI1 = (Hub *)responseObject.data_description;
                        //NSLog(@"objHub.Address1119 %@ serial no %@",objHubAPI.Address,objHubAPI.SerialNo);
                        if (objHubAPI1.BootFlag == true) {
                            objHub.BootFlag = objHubAPI1.BootFlag;
                        }
                        
                        if ([objHubAPI1.HubInputData isNotEmpty]) {
                            objHub.HubInputData = objHubAPI1.HubInputData;
                        }
                        
                        if ([objHubAPI1.HubOutputData isNotEmpty]) {
                            objHub.HubOutputData = objHubAPI1.HubOutputData;
                        }
                        
                        if ([objHubAPI1.HubZoneData isNotEmpty]) {
                            objHub.HubZoneData = objHubAPI1.HubZoneData;
                        }
                    }
                }];
                
                [APIManager filePairJSON_Hub:objHub completion:^(APIV2Response *responseObject) {
                   // NSLog(@"objHub.Address111 10 %@ serial no %@",objHub.Address,objHub.SerialNo);

                    if (!responseObject.error) {
                        if ([responseObject.data_description isKindOfClass:[Pair class]]) {
                            objHub.PairingDetails = (Pair*)responseObject.data_description;
                            objHub.isPaired = true;
                        } else {
                            objHub.isPaired = false;
                            objHub.PairingDetails = [[Pair alloc] init];
                        }
                    }
                }];
                //NSLog(@"objHub.Address111 11 %@ serial no %@",objHub.Address,objHub.SerialNo);
                NSLog(@"---------------");
                  NSLog(@"APIMANAGER Single Data objHubAPI %@ NAD %@ serial no%@",objHubAPI.modelName, objHubAPI.Address,objHubAPI.SerialNo);
                  NSLog(@"---------------");
                  NSLog(@"APIMANAGER Single Data objHub %@ NAD %@ serial no%@",objHub.modelName, objHub.Address,objHub.SerialNo);
                NSLog(@"---------------");
                
                responseObject.data_description = objHub;
                handler(responseObject);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) fileAllXMLDetails:(Hub*)objHub completion:(void (^)(APIResponse *responseObject))handler {
    @try {
        [APIManager mHUBConfigXML_Hub:objHub completion:^(APIResponse *responseObject) {
            if (!responseObject.error) {
                Hub *objHubAPI = (Hub *)responseObject.response;
                
                if ([objHubAPI.Name isNotEmpty]) {
                    objHub.Name = objHubAPI.Name;
                }
                
                if (objHubAPI.apiVersion != 0) {
                    objHub.apiVersion = objHubAPI.apiVersion;
                }
                
                if (objHubAPI.mosVersion != 0) {
                    objHub.mosVersion = objHubAPI.mosVersion;
                }
                
                if ([objHubAPI.strMOSVersion isNotEmpty]) {
                    objHub.strMOSVersion = objHubAPI.strMOSVersion;
                }
                
                [APIManager mHUBUserProfileXML_Hub:objHub completion:^(APIResponse *responseObject) {
                    if (!responseObject.error) {
                        Hub *objHubAPI1 = (Hub *)responseObject.response;
                        
                        if ([objHubAPI1.Mac isNotEmpty]) {
                            objHub.Mac = objHubAPI1.Mac;
                        }
                        
                        if (objHubAPI1.BootFlag == true) {
                            objHub.BootFlag = objHubAPI1.BootFlag;
                        }
                        
                        if ([objHubAPI1.SerialNo isNotEmpty]) {
                            objHub.SerialNo = objHubAPI1.SerialNo;
                        }
                    }
                }];
                
                responseObject.response = objHub;
                handler(responseObject);
            }
        }];
    } @catch (NSException *exception) {
        APIResponse *objReturn = [APIResponse getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) fileAllDetails:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        //NSLog(@"objHub.Address1116 %@ serial no %@",objHub.Address,objHub.SerialNo);
        [APIManager fileAllJSONDetails:objHub completion:^(APIV2Response *responseObject) {
            if (responseObject.error) {
                [APIManager fileAllXMLDetails:objHub completion:^(APIResponse *responseObject) {
                    APIV2Response *objReturn = [APIV2Response getObjectFromAPIResponse:responseObject];
                    handler(objReturn);
                }];
            } else {
                //NSLog(@"objHub.Address111 12 %@ serial no %@",objHub.Address,objHub.SerialNo);

                responseObject.data_description = objHub;
                handler(responseObject);
                //To Delete the XML file, In case JSON found, after mos update from xml to json.
                // [self updateDataFileInCaseJsonFound:objHub];
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void)updateDataFileInCaseJsonFound:(Hub*)objHub{
    @try {
        //  [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        
        [APIManager getObjectResponseFromService:[API fileMHUBUpdateXMLDataFile:objHub.Address] Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            //NSLog(@"updateDataFileInCaseJsonFound objResponse %@",objResponse);
            if (objResp.error) {
                // [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
            } else {
                //  [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            }
            //handler(objResp);
        }];
        
    }
    @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - GET DETAILS APIs
+(void) getSystemInformationStandalone:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectResponseFromAPI_UsingAFN:[API getSystemInformationStandaloneURL:objHub.Address] Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
                handler(objResp);
            } else {
                Hub *objHubReturn = [Hub getObjectFromSystemInfoStandaloneDictionary:objResp.data_description ToHub:objHub];
                objResp.data_description = objHubReturn;
                handler(objResp);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) getSystemInformationStacked:(Hub*)objHub Slave:(NSMutableArray*)arrSlaveDevice completion:(void (^)(APIV2Response *responseObject, NSMutableArray* arrReturnSlaves))handler {
    @try {
        [APIManager getObjectResponseFromAPI_UsingAFN:[API getSystemInformationStackedURL:objHub.Address] Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
                handler(objResp, arrSlaveDevice);
            } else {
                [Hub getObjectFromSystemInfoStackedDictionary:objResp.data_description ToHub:objHub Slave:arrSlaveDevice completion:^(Hub *objReturnMaster, NSMutableArray *arrReturnSlaveDevice) {
                    objResp.data_description = objReturnMaster;
                    handler(objResp, arrReturnSlaveDevice);
                }];
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn, nil);
    }
}

+(void) getMHUBZones:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectResponseFromService:[API getMHUBZonesURL:objHub.Address] Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
                handler(objResp);
            } else {
                if ([objResp.data_description isKindOfClass:[NSArray class]]) {
                    objHub.HubZoneData = [Zone getObjectArray:objResp.data_description Hub:objHub];
                    objResp.data_description = objHub;
                } else {
                    objResp.error = true;
                }
                handler(objResp);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) getMHUBStatus:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        NSURL *tempURL;
        //If MHub is paired or in stack, it'll call 203 otherwise/else 200
        if(objHub.isPaired){
            
            tempURL = [API getMHUBStatusURL:objHub.Address];
        }
        else
            {
            tempURL = [API getMHUBStatusURL_STANDALONE:objHub.Address];
            }
        [APIManager getObjectResponseFromService:tempURL Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
                handler(objResp);
            } else {
                id arrZones = [Utility checkNullForKey:kZONES Dictionary:objResp.data_description];
                objHub.HubZoneData = [Zone getObjectVolumeArray:arrZones Hub:objHub];
                objResp.data_description = objHub;
                handler(objResp);
            }
            handler(objResp);
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) getMHUBZoneStatus:(Hub*)objHub Zone:(Zone*)objZone completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        NSURL *tempURL;
        //If MHub is paired or in stack, it'll call 203 otherwise/else 200
        if(objHub.isPaired)
            {
            tempURL =  [API getMHUBZoneStatusURL:objHub.Address ZoneId:objZone.zone_id];
            }
        else
            {
            tempURL =  [API getMHUBZoneStatusURL_STANDALONE:objHub.Address ZoneId:objZone.zone_id];
            }
        
        [APIManager getObjectResponseFromService:tempURL Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (!objResp.error) {
                NSDictionary *dictZone;
                if ([objResp.data_description isKindOfClass:[NSDictionary class]]) {
                    dictZone = [objResp.data_description objectForKey:kZONE];
                } else if ([objResp.data_description isKindOfClass:[NSArray class]]) {
                    dictZone = [objResp.data_description firstObject];
                }
                Zone *objZoneResp = [Zone getZoneObject_From:[Zone getZoneStatusObjectFromDictionary:dictZone] To:objZone];
                objResp.data_description = objZoneResp;
            }
            handler(objResp);
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) getMHUBGroups:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectResponseFromService:[API getMHUBGroupsURL:objHub.Address] Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
                handler(objResp);
            } else {
                id arrGroups = [Utility checkNullForKey:kGROUPS Dictionary:objResp.data_description];
                if ([arrGroups isKindOfClass:[NSArray class]]) {
                    objHub.HubGroupData = [Group getObjectArray:arrGroups];
                }
                objResp.data_description = objHub;
                handler(objResp);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}
+(void)getCECPACK_204API:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectResponseFromService:[API getZPCECPACKURL:objHub.Address] Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResp.error_description];
                handler(objResp);
            } else {
                handler(objResp);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
    
}

+(void)getCECPACKJSON:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectResponseFromService:[API getCECJSONPACKURL:objHub.Address] Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResp.error_description];
                handler(objResp);
            } else {
                handler(objResp);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }

}

+(void) getUControlPackSummary:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
       
            NSLog(@"values of ZP %d %d",objHub.isZPSetup ,objHub.isPaired);
        NSURL *urlObj;
        if([objHub  isZPSetup] && [objHub isPairedSetup] )
        {
            urlObj = [API getGlobalAVRIRDetails205:objHub.Address];
        }
        else
        {
            
            urlObj = [API getUControlPackSummaryURL:objHub.Address];
        }
        [APIManager getObjectResponseFromService:urlObj Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResp.error_description];
                handler(objResp);
            } else {
                if ([objResp.data_description isKindOfClass:[NSArray class]]) {
                    //for (int i = 0; i < objResp.data_description.count; i++) {
                        for (NSDictionary *dictOPA in objResp.data_description) {
                            objResp.data_description = dictOPA;
                            NSString *strUnitId = [Utility checkNullForKey:kUNIT_ID Dictionary:objResp.data_description];
                            ////NSLog(@"strUnitId %@ and dictIPA %@",strUnitId, dictIPA);
                          //  if ([strUnitId isEqualToString:objHub.UnitId]) {
                                NSArray *array1 =  [Utility checkNullForKey:kIRPACKSTATUSINPUT Dictionary:objResp.data_description];
                                if([array1 isNotEmpty]){
                                    NSMutableArray *arrInput = [[NSMutableArray alloc] initWithArray:array1];
                                    objHub.HubInputData = [InputDevice getIRPackStatusArray:arrInput InputArray:objHub.HubInputData];
                                }
                                NSArray *arrayOutput1 =  [Utility checkNullForKey:kIRPACKSTATUSOUTPUT Dictionary:objResp.data_description];
                                if([arrayOutput1 isNotEmpty]){
                                    NSMutableArray *arrOutput = [[NSMutableArray alloc] initWithArray:arrayOutput1];
                                    objHub.HubOutputData = [OutputDevice getIRPackStatusArray:arrOutput OutputArray:objHub.HubOutputData];
                                }
                                //NSArray *arrayAVR =  [Utility checkNullForKey:kIRPACKSTATUSAVRDATA Dictionary:objResp.data_description];
                                NSArray *arrayAVR =  [Utility checkNullForKey:kIRPACKSTATUSAVR Dictionary:objResp.data_description];
                                if([arrayAVR isNotEmpty]){
                                    NSMutableArray *avrData = [[NSMutableArray alloc] initWithArray:arrayAVR];
                                    NSLog(@"avrData %@",avrData);
                                    objHub.HubAVRList = [AVRDevice getIRPackStatusArray:avrData AVRArray:objHub.HubAVRList];

                                   // objHub.HubAVRList = [AVRDevice getObjectArray:avrData Hub:objHub];
                                }
//                            BOOL isAVRIRPack = [[Utility checkNullForKey:kIRPACKSTATUSAVR Dictionary:objResp.data_description] boolValue];
//                            objHub.AVR_IRPack = isAVRIRPack;
                         //   objHub.HubAVRList = [[NSMutableArray alloc] initWithArray:[AVRDevice getIRPackStatusArray:objHub]];
                                
//                            } else {
//                                for (Hub* objSlave in arrSlaveDevice) {
//                                    if ([strUnitId isEqualToString:objSlave.UnitId]) {
//                                        NSArray *array1 =  [Utility checkNullForKey:kIRPACKSTATUSINPUT Dictionary:objResp.data_description];
//                                        if([array1 isNotEmpty]){
//                                            NSMutableArray *arrInput = [[NSMutableArray alloc] initWithArray:array1];
//                                            objSlave.HubInputData = [InputDevice getIRPackStatusArray:arrInput InputArray:objSlave.HubInputData];
//                                        }
//                                        NSArray *arrayOutput1 =  [Utility checkNullForKey:kIRPACKSTATUSOUTPUT Dictionary:objResp.data_description];
//                                        if([arrayOutput1 isNotEmpty]){
//                                            NSMutableArray *arrOutput = [[NSMutableArray alloc] initWithArray:arrayOutput1];
//                                            objSlave.HubOutputData = [OutputDevice getIRPackStatusArray:arrOutput OutputArray:objSlave.HubOutputData];
//                                        }
//                                        NSArray *arrayAVR =  [Utility checkNullForKey:kIRPACKSTATUSAVRDATA Dictionary:objResp.data_description];
//                                        if([arrayAVR isNotEmpty]){
//                                            NSMutableArray *avrData = [[NSMutableArray alloc] initWithArray:arrayAVR];
//                                            NSLog(@"avrData %@",avrData);
//                                            //objHub.HubAVRList = [AVRDevice getIRPackStatusArray:avrData OutputArray:objHub.HubOutputData];
//                                        }
//                                        break;
//                                    }
//                                }
//                            }
                            
//                            BOOL isAVRIRPack = [[Utility checkNullForKey:kIRPACKSTATUSAVR Dictionary:objResp.data_description] boolValue];
//                            objHub.AVR_IRPack = isAVRIRPack;
//                            objHub.HubAVRList = [[NSMutableArray alloc] initWithArray:[AVRDevice getIRPackStatusArray:objHub]];
                            
                            
                        }
                    objResp.data_description = objHub;
                }
                else if ([objResp.data_description isKindOfClass:[NSDictionary class]]) {
                    
                    
                    
                    NSArray *array1 =  [Utility checkNullForKey:kIRPACKSTATUSINPUT Dictionary:objResp.data_description];
                    if([array1 isNotEmpty]){
                        NSMutableArray *arrInput = [[NSMutableArray alloc] initWithArray:array1];
                        objHub.HubInputData = [InputDevice getIRPackStatusArray:arrInput InputArray:objHub.HubInputData];
                    }
                    NSArray *arrayOutput1 =  [Utility checkNullForKey:kIRPACKSTATUSOUTPUT Dictionary:objResp.data_description];
                    
                    if([arrayOutput1 isNotEmpty]){
                        NSMutableArray *arrOutput = [[NSMutableArray alloc] initWithArray:arrayOutput1];
                        objHub.HubOutputData = [OutputDevice getIRPackStatusArray:arrOutput OutputArray:objHub.HubOutputData];
                    }
                    NSArray *arrayAVR =  [Utility checkNullForKey:kIRPACKSTATUSAVRDATA Dictionary:objResp.data_description];
                    if([arrayAVR isNotEmpty]){
                        NSMutableArray *avrData = [[NSMutableArray alloc] initWithArray:arrayAVR];
                        NSLog(@"avrData %@",avrData);
                        //objHub.HubAVRList = [AVRDevice getIRPackStatusArray:avrData OutputArray:objHub.HubOutputData];
                    }
                    BOOL isAVRIRPack = [[Utility checkNullForKey:kIRPACKSTATUSAVR Dictionary:objResp.data_description] boolValue];
                    objHub.AVR_IRPack = isAVRIRPack;
                    objHub.HubAVRList = [[NSMutableArray alloc] initWithArray:[AVRDevice getIRPackStatusArray:objHub]];
                    
                    
                    NSArray *arrayOnGlobalKey =  [Utility checkNullForKey:kZPGLOBAL Dictionary:objResp.data_description];
                    if([arrayOnGlobalKey isNotEmpty]){
                        NSMutableArray *globalData = [[NSMutableArray alloc] initWithArray:arrayOnGlobalKey];
                        NSMutableArray *arrInputs = [[NSMutableArray alloc]init];
                        NSMutableArray *arrOutputs = [[NSMutableArray alloc]init];
                        NSMutableArray *arrAVRs = [[NSMutableArray alloc]init];
                        if([globalData isNotEmpty]) {
                            NSArray *arraySource=[[NSArray alloc]initWithObjects:@"STB/Cable",@"Media Player",@"Bluray/DVD",@"Games Console",@"CCTV", nil ];
                            NSArray *arrayTV = [[NSArray alloc]initWithObjects:@"Projector",@"Displays",@"Projectors", nil ];
                            NSArray *arrayAVR = [[NSArray alloc]initWithObjects:@"AVRs",@"AVR",@"avr", nil ];
                            
                            for (int i = 0; i < [globalData count]; i++) {
                                NSMutableDictionary *dictResp = [[globalData objectAtIndex:i] mutableCopy];
                                if ([dictResp isKindOfClass:[NSDictionary class]]) {
                                    NSInteger intID = [[Utility checkNullForKey:kLABELID Dictionary:dictResp] integerValue];
                                    [APIManager fileIRPackXML_Hub:objHub PortId:intID completion:^(APIV2Response *responseObject) {
                                        if (responseObject.error) {
                                            //                                                       objIP.sourceType = Uncontrollable;
                                            //                                                       objIP.objCommandType = [[CommandType alloc]init];
                                            //                                                       objIP.arrContinuity = [[NSMutableArray alloc] init];
                                        } else {
                                            
                                            //204
//                                            [APIManager getCECPACK_204API:objHub completion:^(APIV2Response *responseObjectNew) {
//                                                APIV2Response *objRespCEC = (APIV2Response*)responseObjectNew;
//                                                if (!responseObjectNew.error) {
//                                                    NSDictionary *cecPackDict  = [Utility checkNullForKey:kCECPACK Dictionary:objRespCEC.data_description];
//
//                                                    NSLog(@"dictResp %@ ",cecPackDict);
                                                    XMLResponse *objXML1 = [XMLResponse getObjectFromDictionaryForMeta:responseObject.data_description];
                                                    if([arraySource containsObject:objXML1.controlPack.meta.type])
                                                        {
                                                        InputDevice *objInputDev =  [[InputDevice alloc] init];
                                                        objInputDev.PortNo = intID;
                                                        objInputDev.CreatedName = objXML1.controlPack.meta.name;
                                                        objInputDev.Name = objXML1.controlPack.meta.name;
                                                        objInputDev.isIRPack = true;
                                                        objInputDev.sourceType = InputSource;
                                                        objInputDev.Index =  intID;
                                                        
                                                        
                                                        XMLResponse *objXML = [XMLResponse getObjectFromDictionary:responseObject.data_description CDeviceType:InputSource];
                                                        objInputDev.sourceType = InputSource;
                                                        objInputDev.objCommandType = [CommandType getObjectForInput_fromArray:objXML.controlPack.appUI];
                                                        objInputDev.arrContinuity = [[NSMutableArray alloc] initWithArray:objXML.controlPack.continuity];
                                                        [arrInputs addObject:objInputDev];
                                                        
                                                        
                                                        
                                                        }
                                                    else if([arrayTV containsObject:objXML1.controlPack.meta.type])
                                                        {
                                                        //  XMLResponse *objXML = [XMLResponse getObjectFromDictionary:responseObject.data_description CDeviceType:OutputScreen];
                                                        OutputDevice *objOP =  [[OutputDevice alloc] init];
                                                        objOP.PortNo = intID;
                                                        objOP.CreatedName = objXML1.controlPack.meta.name;
                                                        objOP.Name = objXML1.controlPack.meta.name;
                                                        objOP.isIRPack = true;
                                                        objOP.sourceType = OutputScreen;
                                                        objOP.Index =  intID;
                                                        if ([responseObject.data_description isKindOfClass:[NSDictionary class]]) {
                                                            objOP.sourceType = OutputScreen;
                                                            NSString *filepath = [[NSBundle mainBundle] pathForResource:@"video_output_ui_xml" ofType:@"xml"];
                                                            NSError *error;
                                                            NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
                                                            if (error)
                                                                NSLog(@"Error reading file: %@", error.localizedDescription);
                                                            NSDictionary *tempDict = [[XMLDictionaryParser sharedInstance]dictionaryWithString:fileContents];
                                                            NSMutableDictionary *myDict = [[NSMutableDictionary alloc]init];
                                                            [myDict addEntriesFromDictionary:responseObject.data_description];
                                                            NSMutableDictionary *appUIDict = [[myDict objectForKey:kControlPack] objectForKey:kCPAppUIXML];
                                                            if([appUIDict isNotEmpty]){
                                                                XMLResponse *objXML = [XMLResponse getObjectFromDictionary:responseObject.data_description CDeviceType:OutputScreen];
                                                                objOP.objCommandType = [CommandType getObjectForAVR_fromArray:objXML.controlPack.appUI IRCommandArray:objXML.IRCommandPacket];
                                                            }
                                                            else{
                                                            NSMutableDictionary *mergedDictForKey_ControlPack = [[NSMutableDictionary alloc]initWithDictionary:responseObject.data_description];
                                                            NSArray *arrControlPackAppUIValue = [tempDict allValues] ;
                                                            NSMutableDictionary *toMergeKeyValueINControlPackKey = [myDict objectForKey:@"controlPack"];
                                                            [toMergeKeyValueINControlPackKey addEntriesFromDictionary:[arrControlPackAppUIValue objectAtIndex:1]];
                                                            [mergedDictForKey_ControlPack setValue:toMergeKeyValueINControlPackKey forKey:@"controlPack"];
                                                           // [mergedDictForKey_ControlPack setValue:cecPackDict forKey:kCECPACK];
                                                            XMLResponse *objXML = [XMLResponse getObjectFromDictionary:mergedDictForKey_ControlPack CDeviceType:OutputScreen];
                                                            objOP.objCommandType = [CommandType getObjectForAVR_fromArray:objXML.controlPack.appUI IRCommandArray:objXML.IRCommandPacket];
                                                            }
                                                        } else {
                                                            objOP.sourceType = Uncontrollable;
                                                            objOP.objCommandType = [[CommandType alloc] init];
                                                        }
                                                        [CommandType saveCustomObject:objOP.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objOP.PortNo]];
                                                        [arrOutputs addObject:objOP];
                                                        }
                                                    else
                                                        {
                                                            
                                                        //XMLResponse *objXML = [XMLResponse getObjectFromDictionary:responseObject.data_description CDeviceType:AVRSource];
                                                        AVRDevice *objAVRDev =  [[AVRDevice alloc] init];
                                                        objAVRDev.PortNo = intID;
                                                        objAVRDev.CreatedName = objXML1.controlPack.meta.name;
                                                        objAVRDev.Name = objXML1.controlPack.meta.name;
                                                        objAVRDev.isIRPack = true;
                                                        //objAVRDev.sourceType = InputSource;
                                                        objAVRDev.Index =  intID;
                                                        objAVRDev.sourceType = AVRSource;
                                                        XMLResponse *objXML = [XMLResponse getObjectFromDictionary:responseObject.data_description CDeviceType:AVRSource];
                                                            
                                                            NSString *strDeviceName = objXML.controlPack.name;
                                                            objAVRDev.Name = strDeviceName;
                                                            objAVRDev.CreatedName = strDeviceName;
                                                            if ([objAVRDev.Name isEqualToString:@""]) {
                                                                objAVRDev.Name = [NSString stringWithFormat:@"AVR"];
                                                            }
                                                            if (![objAVRDev.CreatedName isNotEmpty]) {
                                                                objAVRDev.CreatedName = objAVRDev.Name;
                                                            }
                                                            
                                                            objAVRDev.objCommandType = [CommandType getObjectForAVR_fromArray:objXML.controlPack.appUI IRCommandArray:objXML.IRCommandPacket];
                                                            objAVRDev.arrContinuity = [[NSMutableArray alloc] initWithArray:objXML.controlPack.continuity];
                                                            [CommandType saveCustomObject:objAVRDev.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objAVRDev.PortNo]];
//                                                            [ContinuityCommand saveCustomObject:objAVR.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objAVR.PortNo]];
                                                            if([arrayAVR containsObject:objXML1.controlPack.meta.type]){
                                                                [objHub.HubAVRList addObject:objAVRDev];
                                                                }
                                                        [arrAVRs addObject:objAVRDev];
                                                        }
                                               // }
                                         //   }];
                                        }
                                        
                                    }];
                                    NSLog(@"arrInputs %@ \n arrOutputs %@\n  arrAVRs %@",arrInputs,arrOutputs,arrAVRs );
                                    
                                }
                            }
                            [mHubManagerInstance saveZPAVRArray:arrAVRs];
                            [mHubManagerInstance saveZPInputArray:arrInputs];
                            [mHubManagerInstance saveZPOutputArray:arrOutputs];
                            //                        mHubManagerInstance.arrayInput = arrInputs;
                            //                        mHubManagerInstance.arrayOutPut = arrOutputs;
                            //                        mHubManagerInstance.arrayAVR = arrAVRs;
                            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                            
                        }
                    }
                    
                    objResp.data_description = objHub;
                
                } else {
                    objResp.error = true;
                }
                handler(objResp);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) getUControlPack:(Hub*)objHub PortId:(NSInteger)intPortId completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectResponseFromService:[API getUControlPackURL:objHub.Address PortId:intPortId] Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objResp.error_description];
                handler(objResp);
            } else {
                handler(objResp);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

/*+(Hub*) getIRPackArray:(Hub *)objHub {
 @try {
 if([objHub isNotEmpty]) {
 // Input Device IRPack
 for (InputDevice *objIP in objHub.HubInputData) {
 if (objIP.isIRPack == true) {
 [APIManager getUControlPack:objHub PortId:objIP.PortNo completion:^(APIV2Response *responseObject) {
 if (responseObject.error) {
 objIP.sourceType = Uncontrollable;
 objIP.objCommandType = [[CommandType alloc]init];
 objIP.arrContinuity = [[NSMutableArray alloc] init];
 } else {
 objIP.sourceType = InputSource;
 ControlPack *objControlPack = [ControlPack getObjectFromDictionary:responseObject.data_description];
 objIP.objCommandType = [CommandType getObjectForInput_fromArray:objControlPack.appUI];
 objIP.arrContinuity = [[NSMutableArray alloc] initWithArray:objControlPack.continuity];
 }
 [CommandType saveCustomObject:objIP.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objIP.PortNo]];
 [ContinuityCommand saveCustomObject:objIP.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objIP.PortNo]];
 }];
 }
 }
 
 // Output Device IRPack
 for (OutputDevice *objOP in objHub.HubOutputData) {
 if (objOP.isIRPack == true) {
 [APIManager getUControlPack:objHub PortId:objOP.PortNo completion:^(APIV2Response *responseObject) {
 if ([responseObject.data_description isKindOfClass:[NSDictionary class]]) {
 objOP.sourceType = OutputScreen;
 NSArray *IRCommandPacket = [[NSArray alloc] initWithArray:[Command getObjectArray:[Utility checkNullForKey:kIRPACK Dictionary:responseObject.data_description]]];
 objOP.objCommandType = [CommandType getObjectForOutput_fromArray:IRCommandPacket];
 } else {
 objOP.sourceType = Uncontrollable;
 objOP.objCommandType = [[CommandType alloc] init];
 }
 [CommandType saveCustomObject:objOP.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objOP.PortNo]];
 }];
 }
 }
 
 // AVR Device IRpack
 for (AVRDevice *objAVR in objHub.HubAVRList) {
 if (objAVR.isIRPack == true) {
 [APIManager getUControlPack:objHub PortId:objAVR.PortNo completion:^(APIV2Response *responseObject) {
 if (responseObject.error) {
 objAVR.sourceType = Uncontrollable;
 objAVR.objCommandType = [[CommandType alloc]init];
 objAVR.arrContinuity = [[NSMutableArray alloc] init];
 } else {
 objAVR.sourceType = AVRSource;
 ControlPack *objControlPack = [ControlPack getObjectFromDictionary:responseObject.data_description];
 NSArray *IRCommandPacket = [[NSArray alloc] initWithArray:[Command getObjectArray:[Utility checkNullForKey:kIRPACK Dictionary:responseObject.data_description]]];
 objAVR.objCommandType = [CommandType getObjectForAVR_fromArray:objControlPack.appUI IRCommandArray:IRCommandPacket];
 objAVR.arrContinuity = [[NSMutableArray alloc] initWithArray:objControlPack.continuity];
 }
 [CommandType saveCustomObject:objAVR.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objAVR.PortNo]];
 [ContinuityCommand saveCustomObject:objAVR.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objAVR.PortNo]];
 }];
 }
 }
 }
 return objHub;
 } @catch(NSException *exception) {
 [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
 }
 }*/

+(Hub*) getIRPackArrayFromXML:(Hub *)objHub {
    @try {
        if([objHub isNotEmpty]) {
            // Input Device IRPack
            for (InputDevice *objIP in objHub.HubInputData) {
                if (objIP.isIRPack == true) {
                    NSInteger portIDObj;
                    if([objHub isZPSetup]){
                        portIDObj  = objIP.irmapId;
                    }else{
                        portIDObj = objIP.PortNo;
                    }
                    [APIManager fileIRPackXML_Hub:objHub PortId:portIDObj completion:^(APIV2Response *responseObject) {
                        if (responseObject.error) {
                            objIP.sourceType = Uncontrollable;
                            objIP.objCommandType = [[CommandType alloc]init];
                            objIP.arrContinuity = [[NSMutableArray alloc] init];
                        } else {
                            XMLResponse *objXML = [XMLResponse getObjectFromDictionary:responseObject.data_description CDeviceType:InputSource];
                            objIP.sourceType = InputSource;
                            objIP.objCommandType = [CommandType getObjectForInput_fromArray:objXML.controlPack.appUI];
                            objIP.arrContinuity = [[NSMutableArray alloc] initWithArray:objXML.controlPack.continuity];
                        }
                        [CommandType saveCustomObject:objIP.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objIP.PortNo]];
                        [ContinuityCommand saveCustomObject:objIP.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objIP.PortNo]];
                    }];
                }
            }
            
            // Output Device IRPack
            for (OutputDevice *objOP in objHub.HubOutputData) {
                if (objOP.isIRPack == true) {
                    if([objOP.Name containsString:@"CEC"]){

                                                  NSString *filepath = [[NSBundle mainBundle] pathForResource:@"video_cec_ui_xml_new" ofType:@"xml"];
                                                  NSError *error;
                                                  NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
                                                  if (error)
                                                      NSLog(@"Error reading file: %@", error.localizedDescription);
                                                  NSDictionary *tempDict = [[XMLDictionaryParser sharedInstance]dictionaryWithString:fileContents];

                        [APIManager getObjectFromFileAPI:[API getCECJSONPACKURL:objHub.Address] Version:APIV2 FileType:JSON IsParsed:false WithCompletion:^(id objResp) {
                            APIV2Response *objResponse = (APIV2Response*)objResp;
                            if (objResponse.error) {
                                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
                            } else {
                                DDLogDebug(@"fileMHUBBenchmark_details == %@", objResponse);
                                NSDictionary *cecPackDict  = [Utility checkNullForKey:kLIBCEC Dictionary:objResponse.data_description];
                                NSDictionary *cecPackDictKeyCodes  = [Utility checkNullForKey:@"codes" Dictionary:cecPackDict];
                                NSLog(@"cecPackDictKeyCodes %@ ",cecPackDictKeyCodes);
                                objOP.sourceType = OutputScreen;
                                NSMutableDictionary *mergedDictForKey_ControlPack = [[NSMutableDictionary alloc]initWithDictionary:tempDict];
                                [mergedDictForKey_ControlPack setValue:cecPackDictKeyCodes forKey:kCECPACK];
                                XMLResponse *objXML = [XMLResponse getObjectFromDictionary:mergedDictForKey_ControlPack CDeviceType:OutputScreen];
                                objOP.objCommandType = [CommandType getObjectForAVR_fromArray:objXML.controlPack.appUI IRCommandArray:objXML.IRCommandPacket];
                            }
                        }];
                    }
                    else{
                        NSInteger portIDObj;
                        if([objHub isZPSetup]){
                            portIDObj  = objOP.irmapId;
                        }else{
                            portIDObj = objOP.PortNo;
                        }
                    [APIManager fileIRPackXML_Hub:objHub PortId:portIDObj completion:^(APIV2Response *responseObject) {
                        if ([responseObject.data_description isKindOfClass:[NSDictionary class]]) {
                            objOP.sourceType = OutputScreen;

                            NSString *filepath = [[NSBundle mainBundle] pathForResource:@"video_output_ui_xml" ofType:@"xml"];
                            NSError *error;
                            NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
                            if (error)
                                NSLog(@"Error reading file: %@", error.localizedDescription);
                            NSDictionary *tempDict = [[XMLDictionaryParser sharedInstance]dictionaryWithString:fileContents];
                            NSMutableDictionary *myDict = [[NSMutableDictionary alloc]init];
                            [myDict addEntriesFromDictionary:responseObject.data_description];
                            NSMutableDictionary *appUIDict = [[myDict objectForKey:kControlPack] objectForKey:kCPAppUIXML];
                            if([appUIDict isNotEmpty]){
                                XMLResponse *objXML = [XMLResponse getObjectFromDictionary:responseObject.data_description CDeviceType:OutputScreen];
                                objOP.objCommandType = [CommandType getObjectForAVR_fromArray:objXML.controlPack.appUI IRCommandArray:objXML.IRCommandPacket];

                            }
                            else{
                            NSMutableDictionary *mergedDictForKey_ControlPack = [[NSMutableDictionary alloc]initWithDictionary:responseObject.data_description];

                            NSArray *arrControlPackAppUIValue = [tempDict allValues] ;
                            NSMutableDictionary *toMergeKeyValueINControlPackKey = [myDict objectForKey:kControlPack];
                            [toMergeKeyValueINControlPackKey addEntriesFromDictionary:[arrControlPackAppUIValue objectAtIndex:1]];
                            [mergedDictForKey_ControlPack setValue:toMergeKeyValueINControlPackKey forKey:kControlPack];

                            XMLResponse *objXML = [XMLResponse getObjectFromDictionary:mergedDictForKey_ControlPack CDeviceType:OutputScreen];
                            objOP.objCommandType = [CommandType getObjectForAVR_fromArray:objXML.controlPack.appUI IRCommandArray:objXML.IRCommandPacket];
                            }
                            }

                            
                            
                         else {
                            objOP.sourceType = Uncontrollable;
                            objOP.objCommandType = [[CommandType alloc] init];
                        }
                        [CommandType saveCustomObject:objOP.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)portIDObj]];
                    }];
                    }
                }
                else
                {
                    // August 2020: This else condition was not written here. but i added it because if user resync from the settings and someone removed IR pack from the selected output (objOP) then changes on no IR pack in zone should be seen on display screen. so added below code which will decalre there is no commands in IR pack hence no ir icon should appear on left menu with zone and also TV control should not be seen.
                    objOP.sourceType = Uncontrollable;
                    objOP.objCommandType = [[CommandType alloc] init];
                    [CommandType saveCustomObject:objOP.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objOP.PortNo]];
                    //[Utility deleteUserDefaults:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objOP.PortNo]];
                }
            }
            
            // AVR Device IRpack
            for (AVRDevice *objAVR in objHub.HubAVRList) {
                if (objAVR.isIRPack == true) {
                    [APIManager fileIRPackXML_Hub:objHub PortId:objAVR.PortNo completion:^(APIV2Response *responseObject) {
                        if (responseObject.error) {
                            objAVR.sourceType = Uncontrollable;
                            objAVR.objCommandType = [[CommandType alloc]init];
                            objAVR.arrContinuity = [[NSMutableArray alloc] init];
                        } else {
                            objAVR.sourceType = AVRSource;
                            XMLResponse *objXML = [XMLResponse getObjectFromDictionary:responseObject.data_description CDeviceType:AVRSource];
                            
                            NSString *strDeviceName = objXML.controlPack.name;
                            objAVR.Name = strDeviceName;
                            objAVR.CreatedName = strDeviceName;
                            if ([objAVR.Name isEqualToString:@""]) {
                                objAVR.Name = [NSString stringWithFormat:@"AVR"];
                            }
                            if (![objAVR.CreatedName isNotEmpty]) {
                                objAVR.CreatedName = objAVR.Name;
                            }
                            
                            objAVR.objCommandType = [CommandType getObjectForAVR_fromArray:objXML.controlPack.appUI IRCommandArray:objXML.IRCommandPacket];
                            objAVR.arrContinuity = [[NSMutableArray alloc] initWithArray:objXML.controlPack.continuity];
                        }
                        [CommandType saveCustomObject:objAVR.objCommandType key:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objAVR.PortNo]];
                        [ContinuityCommand saveCustomObject:objAVR.arrContinuity key:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objAVR.PortNo]];
                    }];
                }
            }
        }
        return objHub;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) getSequences:(Hub*)objHub completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectResponseFromService:[API getSequencesURL:objHub.Address] Version:APIV2 WithCompletion:^(id objResponse) {
            DDLogDebug(@"getSequences %@",objResponse);
            APIV2Response *objResp = (APIV2Response*)objResponse;
            if (objResp.error) {
                [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:@""];
                handler(objResp);
            } else {
                objHub.HubSequenceList = [Sequence getObjectV2Array:[Utility checkNullForKey:kSEQUENCES Dictionary:objResp.data_description]];
                objHub.HubControlsList = [Controls getObjectV2Array:[Utility checkNullForKey:kFUNCTIONS Dictionary:objResp.data_description]];
                //NSLog(@"controls%@", [Controls getObjectV2Array:[Utility checkNullForKey:kFUNCTIONS Dictionary:objResp.data_description]]);
                objResp.data_description = objHub;
                handler(objResp);
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) getPairDetail:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice completion:(void (^)(Hub *responseHub, NSMutableArray* responseSlaveArray))handler {
    @try {
        if (arrSlaveDevice.count == 0) {
            if (![objHub.PairingDetails isPairEmpty]) {
                [arrSlaveDevice addObjectsFromArray:[Hub getObjectArrayFromPairJSON:objHub.PairingDetails]];
                for (int counter = 0; counter < arrSlaveDevice.count; counter++) {
                    Hub *objSlave = [arrSlaveDevice objectAtIndex:counter];
                    [APIManager fileAllDetails:objSlave completion:^(APIV2Response *responseObject) {
                        if (!responseObject.error) {
                            Hub *objHubResp = (Hub*)responseObject.data_description;
                            [arrSlaveDevice replaceObjectAtIndex:counter withObject:objHubResp];
                        }
                    }];
                }
                handler (objHub, arrSlaveDevice);
            } else {
                [APIManager filePairJSON_Hub:objHub completion:^(APIV2Response *responseObject) {
                    if (!responseObject.error) {
                        if ([responseObject.data_description isKindOfClass:[Pair class]]) {
                            objHub.PairingDetails = (Pair*)responseObject.data_description;
                            objHub.isPaired = true;
                            [arrSlaveDevice addObjectsFromArray:[Hub getObjectArrayFromPairJSON:objHub.PairingDetails]];
                            for (int counter = 0; counter < arrSlaveDevice.count; counter++) {
                                Hub *objSlave = [arrSlaveDevice objectAtIndex:counter];
                                [APIManager fileAllDetails:objSlave completion:^(APIV2Response *responseObject) {
                                    if (!responseObject.error) {
                                        Hub *objHubResp = (Hub*)responseObject.data_description;
                                        [arrSlaveDevice replaceObjectAtIndex:counter withObject:objHubResp];
                                    }
                                }];
                            }
                        } else {
                            objHub.isPaired = false;
                            objHub.PairingDetails = [[Pair alloc] init];
                        }
                        
                        handler (objHub, arrSlaveDevice);
                    }
                }];
            }
        } else {
            objHub.UnitId = objHub.PairingDetails.master.unit_id;
            for (Hub *objSlave in arrSlaveDevice) {
                for (PairDetail *objPairing in objHub.PairingDetails.arrSlave) {
                    if ([objSlave.SerialNo isEqualToString:objPairing.serial_number]) {
                        objSlave.UnitId = objPairing.unit_id;
                        break;
                    }
                }
            }
            handler (objHub, arrSlaveDevice);
        }
        
        
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark -
+(void) getFORCEMOSUpdate:(Hub*)hubObj updateData:(NSString *)dictParameter completion:(void (^)(APIResponse *responseObject))handler{
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[API Mhub_AdvanceForceUpdate:hubObj.Address mosVersion:hubObj.mosVersion]]];
    [req setHTTPMethod:@"POST"];
    NSData *postData = [dictParameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [req addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Do something with response data here - convert to JSON, check if error exists, etc....
        // NSLog(@"apiMethod response %@",response);
        APIResponse *objResp = (APIResponse*)response;
        handler(objResp);
    }];
    
    [task resume];
    
}

+ (BOOL)pinghosttoCheckNetworkStatus
{
    bool success = false;
    const char *host_name = [BASEURLHUBBENCHMARK
                             cStringUsingEncoding:NSASCIIStringEncoding];
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,host_name);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    bool isAvailable = success && (flags & kSCNetworkFlagsReachable) &&
    !(flags & kSCNetworkFlagsConnectionRequired);
    if (isAvailable)
        {
        return YES;
        }else{
            return NO;
        }
}
+(void) getBenchMarkDetails2:(NSString*)strAddress updateData:(NSString *)dictParameter completion:(void (^)(NSDictionary *responseObject))handler{
    // application/json
    return;
    @try {
        if ([Reachability sharedReachability].internetConnectionStatus==NotReachable)  {
            APIV2Response *objReturn = [APIV2Response getInternetNotAvailableResponse];
            //[[AppDelegate appDelegate] hideHudView:ErrorMessage Message:objReturn.error_description];
            //handler(objReturn);
        }
        else
            {
            NSError* error = nil;
            NSURLResponse* response;
            [self pingToTheHubExistOrNot:BASEURLHUBBENCHMARK];
            
            
            NSData* dataResponse2 = [self sendSynchronousRequest2:[API fileMHUBBENCHMARKREADER:@""] returningResponse:&response error:&error];
            //NSLog(@"dataResponse2 %@",dataResponse2);
            NSDictionary* dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse2                                                                          options:kNilOptions error:nil];
            //NSLog(@"dictResponse %@",dictResponse);
            handler(dictResponse);
            
            NSHTTPURLResponse *responseHTTP = (NSHTTPURLResponse *)response;
            NSInteger statusCode = [responseHTTP statusCode];
            
            if (statusCode == 404 || statusCode == 503  ) {
                
            }
            else
                {
                if(dataResponse2 != nil){
                    NSDictionary* dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse2                                                                     options:kNilOptions error:nil];
                    handler(dictResponse);
                    
                }
                }
            }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


+(void) getBenchMarkDetails:(NSString*)strAddress updateData:(NSString *)dictParameter completion:(void (^)(NSDictionary *responseObject))handler{
    @try {
        [APIManager postObjectToAPI_UsingAFN:BASEURLHUBBENCHMARK Parameter:dictParameter Version:APIV1 WithCompletion:^(id objResponse) {
            //APIResponse *objResp = (APIResponse*)objResponse;
            handler(objResponse);
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
    
}

+(void) getWifiModeDetails:(NSString*)strAddress updateData:(NSString *)dictParameter completion:(void (^)(NSDictionary *responseObject))handler{
    @try {
        [APIManager postObjectToAPI_UsingAFN:[API getWifiMode:strAddress] Parameter:dictParameter Version:APIV1 WithCompletion:^(id objResponse) {
            //APIResponse *objResp = (APIResponse*)objResponse;
            handler(objResponse);
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
    
}

+(void) wifiNetworkScan:(NSString*)strAddress updateData:(NSString *)dictParameter completion:(void (^)(NSDictionary *responseObject))handler{
    @try {
        [APIManager postObjectToAPI_UsingAFN:[API networkScan:strAddress] Parameter:dictParameter Version:APIV1 WithCompletion:^(id objResponse) {
            //APIResponse *objResp = (APIResponse*)objResponse;
            handler(objResponse);
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
    
}

+(void) wifiSetSTAMode:(NSString*)strAddress ssidString:(NSString *)ssidStr passwordString:(NSString *)passwordStr  encryptionString:(NSString *)encryptionStr updateData:(NSString *)dictParameter completion:(void (^)(NSDictionary *responseObject))handler{
    @try {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[API setSTAModeURL:strAddress],ssidStr,passwordStr,encryptionStr];
         NSLog(@"urlString Success  %@",urlString);
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSLog(@"urlString after  %@",urlString);
        [APIManager postObjectToAPI_UsingAFN:urlString Parameter:dictParameter Version:APIV1 WithCompletion:^(id objResponse) {
            //APIResponse *objResp = (APIResponse*)objResponse;
            handler(objResponse);
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) wifiSetAPMode:(NSString*)strAddress updateData:(NSString *)dictParameter completion:(void (^)(NSDictionary *responseObject))handler{
    @try {
       //NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[API setAPMode:strAddress],ssidStr,passwordStr,encryptionStr];
        [APIManager postObjectToAPI_UsingAFN:[API setAPMode:strAddress] Parameter:dictParameter Version:APIV1 WithCompletion:^(id objResponse) {
            //APIResponse *objResp = (APIResponse*)objResponse;
            handler(objResponse);
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    __block NSData *blockData = nil;
    @try {
        
        __block NSURLResponse *blockResponse = nil;
        __block NSError *blockError = nil;
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable subData, NSURLResponse * _Nullable subResponse, NSError * _Nullable subError) {
            
            blockData = subData;
            blockError = subError;
            blockResponse = subResponse;
            
            dispatch_group_leave(group);
        }] resume];
        
        dispatch_group_wait(group,  DISPATCH_TIME_FOREVER);
        
        *error = blockError;
        *response = blockResponse;
        
    } @catch (NSException *exception) {
        
        NSLog(@"sendSynchronousRequest%@", exception.description);
    } @finally {
        return blockData;
    }
}

+ (NSData *)sendSynchronousRequest2:(NSURL *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    __block NSData *blockData = nil;
    @try {
        
        __block NSURLResponse *blockResponse = nil;
        __block NSError *blockError = nil;
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        NSLog(@"sendSynchronousRequest2 %@",request);

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
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


#pragma mark - get Dash upgrade update details
+(void) getDashUpgrade_CGI:(Hub*)hubObj updateData:(NSString *)dictParameter completion:(void(^)(APIV2Response *objResponse))handler {
    @try {
    
    NSError* error = nil;
    NSURLResponse* response;
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[API Mhub_DashUpgrade:hubObj.Address mosVersion:hubObj.mosVersion]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kServiceTimeOut];
       [request setTimeoutInterval:kServiceTimeOut];
       NSData* dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSData* dataResponse = [self sendSynchronousRequest:[NSURL URLWithString:[API Mhub_DashUpgrade:hubObj.Address mosVersion:hubObj.mosVersion]] returningResponse:&response error:&error];
    NSDictionary* dictResponse;
    // handle HTTP errors here
    NSHTTPURLResponse *responseHTTP = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [responseHTTP statusCode];
    
    if (statusCode == 404) {
        NSString *strResponse = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
        NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithXMLString:strResponse]] ;
        dictResponse = [[NSDictionary alloc] initWithDictionary:[Utility parseDictionary:dictResponse]] ;
        NSString *strErrorResponse = @"";
        if ([dictResponse isNotEmpty]) {
            strErrorResponse = [Utility checkNullForKey:@"__text" Dictionary:dictResponse];
        } else {
            strErrorResponse = strResponse;
        }
        APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
        objReturn.error_description = strErrorResponse;
        handler(objReturn);
    } else if (error) {
        APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
        handler(objReturn);
        }
    else{
        if(hubObj.mosVersion <  8){
            NSString *strResponse = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
            NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithXMLString:strResponse]] ;
            APIV2Response *objReturn = [APIV2Response getObjectFromDictionary:dictResponse];
            handler(objReturn);
            }
        else
            {
            dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:nil];
            APIV2Response *objReturn = [APIV2Response getObjectFromDictionary:dictResponse];
            handler(objReturn);
            }
        }
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}


#pragma mark - get Dash upgrade update details
+(void) getDashUpgrade_JSON:(Hub*)hubObj updateData:(NSString *)dictParameter completion:(void(^)(APIV2Response *objResponse))handler {
    @try {
    
    NSError* error = nil;
    NSURLResponse* response;
         NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[API Mhub_DashUpgrade_JSON:hubObj.Address]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kServiceTimeOut];
        [request setTimeoutInterval:kServiceTimeOut];
        NSData* dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

//    NSData* dataResponse = [self sendSynchronousRequest:[NSURL URLWithString:[API Mhub_DashUpgrade_JSON:hubObj.Address]] returningResponse:&response error:&error];
    NSDictionary* dictResponse;
    // handle HTTP errors here
    NSHTTPURLResponse *responseHTTP = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [responseHTTP statusCode];
    
    if (statusCode == 404) {
        NSString *strResponse = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
        NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithXMLString:strResponse]] ;
        dictResponse = [[NSDictionary alloc] initWithDictionary:[Utility parseDictionary:dictResponse]] ;
        NSString *strErrorResponse = @"";
        if ([dictResponse isNotEmpty]) {
            strErrorResponse = [Utility checkNullForKey:@"__text" Dictionary:dictResponse];
        } else {
            strErrorResponse = strResponse;
        }
        APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
        objReturn.error_description = strErrorResponse;
        handler(objReturn);
    } else if (error) {
        APIV2Response *objReturn = [APIV2Response getErrorResponse:error];
        handler(objReturn);
        }
    else{
        if(hubObj.mosVersion <  8){
            NSString *strResponse = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
            NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithXMLString:strResponse]] ;
            APIV2Response *objReturn = [APIV2Response getObjectFromDictionary:dictResponse];
            handler(objReturn);
            }
        else
            {
            dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:nil];
            //APIV2Response *objReturn = [APIV2Response getObjectFromDictionary:dictResponse];
                APIV2Response *objReturn = [APIV2Response getObjectFromFile:dictResponse];
                
            handler(objReturn);
            }
        }
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - get Connectivity.JSON details
+(void) fileConnectivityJSON:(Hub*)hubObj completion:(void (^)(NSDictionary *responseObject))handler{
    
    @try {
    NSError* error = nil;
    NSURLResponse* response;
    NSData* dataResponse = [self sendSynchronousRequest2:[NSURL URLWithString:[API Mhub_ConnectivityJSON:hubObj.Address]] returningResponse:&response error:&error];
    // NSLog(@"dataResponse %@",dataResponse);
    
    NSDictionary* dictResponse;
    // handle HTTP errors here
    NSHTTPURLResponse *responseHTTP = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [responseHTTP statusCode];
    
    if (statusCode == 404) {
        [[AppDelegate appDelegate]hideHudView:HideIndicator Message:@""];
    }
    else
        {
        if(hubObj.mosVersion <  8){
            NSString *strResponse = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
            NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithXMLString:strResponse]] ;
            NSLog(@"dictResponse XML%@",dictResponse);
            handler(dictResponse);
            }
        else
            {
            dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse                                                                          options:kNilOptions error:nil];
            //NSLog(@"dictResponse JSON%@",dictResponse);
            handler(dictResponse);
            }
        
        }
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - checkMhubIdentity
+(void) checkMhubIdentity:(NSString*)strAddress updateData:(NSString *)dictParameter completion:(void (^)(APIV2Response *responseObject))handler{
    @try {
        [APIManager getObjectResponseFromAPI_UsingAFN:[API mHUBCheckAudioDeviceIdentity:strAddress] Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            handler(objResp);
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark -
+(void) getAllMHUBDetails:(Hub*)objHub Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice Sync:(BOOL)isSync completion:(void (^)(APIV2Response *responseObject))handler {
    /* Method to call Data API for particular order and condition */
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWebSocketReceivedResponse object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationWebSocketReceivedResponse
                                                   object:nil];
        if (![arrSlaveDevice isNotEmpty]) {
            arrSlaveDevice = [[NSMutableArray alloc] init];
        }
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:HUB_CONNECTING];
        /* DataAPI: data/100 for MHUB basic details. */
        
        [APIManager getSystemInformationStandalone:objHub completion:^(APIV2Response *responseObject) {
            
            if (responseObject.error) {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                handler(responseObject);
            } else {
                Hub *objHubAPI1 = (Hub *)responseObject.data_description;
                
                if ([objHubAPI1.UnitId isNotEmpty]) {
                    objHub.UnitId = objHubAPI1.UnitId;
                }
                
                if ([objHubAPI1.Name isNotEmpty]) {
                    objHub.Name = objHubAPI1.Name;
                }
                
                if ([objHubAPI1.Official_Name isNotEmpty]) {
                    objHub.Official_Name = objHubAPI1.Official_Name;
                }
                
                if (![objHubAPI1.Address isIPAddressEmpty]) {
                    objHub.Address = objHubAPI1.Address;
                }
                
                if (objHubAPI1.BootFlag == true) {
                    objHub.BootFlag = objHubAPI1.BootFlag;
                }
                
                if ([objHubAPI1.SerialNo isNotEmpty]) {
                    objHub.SerialNo = objHubAPI1.SerialNo;
                }
                
                if (objHubAPI1.apiVersion != 0) {
                    objHub.apiVersion = objHubAPI1.apiVersion;
                }
                
                if (objHubAPI1.mosVersion != 0) {
                    objHub.mosVersion = objHubAPI1.mosVersion;
                }
                
                if ([objHubAPI1.strMOSVersion isNotEmpty]) {
                    objHub.strMOSVersion = objHubAPI1.strMOSVersion;
                }
                
                if (objHubAPI1.isPaired == true) {
                    objHub.isPaired = objHubAPI1.isPaired;
                }
                if (objHubAPI1.webSocketFlag == true)
                {
                [[WSManager sharedInstance] connectWebSocket:objHubAPI1.Address];
                [WSManager sharedInstance].delegate = self;
                }
                
                /* Condition for All data API needs to call else basic only. */
                if (isSync == true) {
                    /* Condition to check System is Paired else Standalone. */
                    if ([objHub isPairedSetup]) {
                        /* Method call to check PairDetails object detail. */
                        [APIManager getPairDetail:objHub Stacked:isStacked Slave:arrSlaveDevice completion:^(Hub *responseHub, NSMutableArray *responseSlaveArray) {
                            if (arrSlaveDevice.count > 0) {
                                /* If system is paired then call DataAPI: data/101 for Stack details. */
                                [APIManager getSystemInformationStacked:objHub Slave:arrSlaveDevice completion:^(APIV2Response *responseObject, NSMutableArray *arrReturnSlaves) {
                                    
                                    if (!responseObject.error) {
                                        Hub *objHubAPI01 = (Hub *)responseObject.data_description;
                                        if (objHubAPI01.OutputCount != 0) {
                                            objHub.OutputCount = objHubAPI01.OutputCount;
                                        }
                                        
                                        if (objHubAPI01.InputCount != 0) {
                                            objHub.InputCount = objHubAPI01.InputCount;
                                        }
                                        
                                        if ([objHubAPI01.HubInputData isNotEmpty]) {
                                            objHub.HubInputData = objHubAPI01.HubInputData;
                                        }
                                        for (int j = 0; j < mHubManagerInstance.objSelectedHub.HubInputData.count; j++) {
                                            InputDevice *objFrom = (InputDevice *)mHubManagerInstance.objSelectedHub.HubInputData[j];
                                            InputDevice *objTo = (InputDevice *)objHub.HubInputData[j];
                                            [InputDevice updateNamesOfInputs:objFrom To:objTo];
                                        }
                                        
                                        if ([objHubAPI01.HubOutputData isNotEmpty]) {
                                            objHub.HubOutputData = objHubAPI01.HubOutputData;
                                        }
                                        
//                                        if ([arrReturnSlaves isNotEmpty] && arrReturnSlaves.count > 0) {
//                                            [arrSlaveDevice removeAllObjects];
//                                            [arrSlaveDevice initWithArray:arrReturnSlaves];
//                                            
//                                            //[arrSlaveDevice addObjectsFromArray:arrReturnSlaves];
//                                        }
                                    }
                                    if([objHub  isZPSetup] && [objHub isPairedSetup] ){
                                    [APIManager getUControlPackSummary:objHub Stacked:isStacked Slave:arrSlaveDevice completion:^(APIV2Response *responseObject) {

                                        if (!responseObject.error) {
                                            Hub *objHubAPI5 = (Hub *)responseObject.data_description;
                                            if ([objHubAPI5.HubInputData isNotEmpty]) {
                                                objHub.HubInputData = objHubAPI5.HubInputData;
                                            }

                                            if ([objHubAPI5.HubOutputData isNotEmpty]) {
                                                objHub.HubOutputData = objHubAPI5.HubOutputData;
                                            }

                                            if ([objHubAPI5.HubAVRList isNotEmpty]) {
                                                objHub.HubAVRList = objHubAPI5.HubAVRList;
                                            }

                                            if (objHubAPI5.AVR_IRPack == true) {
                                                objHub.AVR_IRPack = objHubAPI5.AVR_IRPack;
                                            }

                                            Hub *objHubAPIXML = [[Hub alloc] initWithHub:[APIManager getIRPackArrayFromXML:objHub]];

                                            if ([objHubAPIXML.HubInputData isNotEmpty]) {
                                                objHub.HubInputData = objHubAPIXML.HubInputData;
                                            }

                                            if ([objHubAPIXML.HubOutputData isNotEmpty]) {
                                                objHub.HubOutputData = objHubAPIXML.HubOutputData;
                                            }

                                            if ([objHubAPIXML.HubAVRList isNotEmpty]) {
                                                objHub.HubAVRList = objHubAPIXML.HubAVRList;
                                            }
                                        }
                                        // Sync With uControl Case
                                        /* ========= Data Management ======== */
                                        // [APIManager saveAllMHUBDetailsToManager:objHub Slave:arrSlaveDevice Sync:isSync];
                                        [[AppDelegate appDelegate] showHudView:ShowIndicatorTemparory Message:@""];
                                        @try {
                                            mHubManagerInstance.objSelectedAVRDevice = [AVRDevice getIRPackStatusFromObject:objHub];
                                            mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objHub];
                                            //NSLog(@"objHubAPI2.HubZoneData %@",mHubManagerInstance.objSelectedHub.HubZoneData);

                                            mHubManagerInstance.masterHubModel = mHubManagerInstance.objSelectedHub.Generation;
                                            mHubManagerInstance.isPairedDevice = objHub.isPaired;
                                            mHubManagerInstance.arrSlaveAudioDevice = [[NSMutableArray alloc] initWithArray:arrSlaveDevice];


                                            if (isSync) {
                                                if (objHub.isPaired) {
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                                                                   {
                                                    [mHubManagerInstance syncGlobalManagerObjectV2];
                                                    [[AppDelegate appDelegate] hideHudView:HideIndicatorTemparory Message:@""];

                                                    handler(responseObject);
                                                    });
                                                }
                                                else
                                                    {
                                                    [mHubManagerInstance syncGlobalManagerObjectV2];
                                                    [[AppDelegate appDelegate] hideHudView:HideIndicatorTemparory Message:@""];

                                                    handler(responseObject);
                                                    }
                                            }
                                            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                                        } @catch (NSException *exception) {
                                            [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
                                        }
                                    }];}
                                }];
                            }
                        }];
                    } else {
                        /* System is Standalone */
                        if (objHubAPI1.OutputCount != 0) {
                            objHub.OutputCount = objHubAPI1.OutputCount;
                        }
                        
                        if (objHubAPI1.InputCount != 0) {
                            objHub.InputCount = objHubAPI1.InputCount;
                        }
                        
                        if ([objHubAPI1.HubInputData isNotEmpty]) {
                            objHub.HubInputData = objHubAPI1.HubInputData;
                        }
                        
                        if ([objHubAPI1.HubOutputData isNotEmpty]) {
                            objHub.HubOutputData = objHubAPI1.HubOutputData;
                        }
                    }
                    
                    /* DataAPI: data/102 for MHUB Zones details. */
                    [APIManager getMHUBZones:objHub completion:^(APIV2Response *responseObject) {
                        
                        if (!responseObject.error) {
                            Hub *objHubAPI2 = (Hub *)responseObject.data_description;
                            
                            //NSLog(@"objHubAPI2.HubZoneData %@ ND %@",objHubAPI2.HubZoneData,objHub.HubZoneData);
                            if ([objHubAPI2.HubZoneData isNotEmpty]) {
                                objHub.HubZoneData = objHubAPI2.HubZoneData;
                                for (int j = 0; j < objHub.HubZoneData.count; j++) {
                                    Zone *zoneObj = [objHub.HubZoneData objectAtIndex:j];
                                    for (int i = 0; i < zoneObj.arrOutputs.count; i++) {
                                        OutputDevice *obj = [zoneObj.arrOutputs objectAtIndex:i];
                                        NSLog(@" obj name %@ and Cname %ld   %@",obj.Name,(long)obj.Index,zoneObj.zone_label);
                                    }
                                }
                                
                            }
                            
                            /* DataAPI: data/203 for MHUB All Zone Status. */
                            [APIManager getMHUBStatus:objHub completion:^(APIV2Response *responseObject) {
                                
                                if (!responseObject.error) {
                                    Hub *objHubAPI3 = (Hub *)responseObject.data_description;
                                    if ([objHubAPI3.HubZoneData isNotEmpty]) {
                                        objHub.HubZoneData = objHubAPI3.HubZoneData;
                                    }
                                }
                            }];
                        }
                        
                        /* DataAPI: data/202 for MHUB Sequence details. */
                        [APIManager getSequences:objHub completion:^(APIV2Response *responseObject) {
                            if (!responseObject.error) {
                                Hub *objHubAPI6 = (Hub *)responseObject.data_description;
                                if ([objHubAPI6.HubSequenceList isNotEmpty]) {
                                    objHub.HubSequenceList = objHubAPI6.HubSequenceList;
                                }
                                if ([objHubAPI6.HubControlsList isNotEmpty]) {
                                    objHub.HubControlsList = objHubAPI6.HubControlsList;
                                }
                                responseObject.data_description = objHub;
                            }
                            
                            /* If group is supportted by System then call Group API. */
                            if ([objHub isGroupSupport]) {
                                /* DataAPI: data/103 for MHUB Group details. */
                                [APIManager getMHUBGroups:objHub completion:^(APIV2Response *responseObject) {
                                    if (!responseObject.error) {
                                        Hub *objHubAPI4 = (Hub *)responseObject.data_description;
                                        if ([objHubAPI4.HubGroupData isNotEmpty]) {
                                            objHub.HubGroupData = objHubAPI4.HubGroupData;
                                        }
                                    }
                                }];
                            }
                        }];
                        
                        /* If uControl IRPack Supported by System i.e. by Video Device like MHUBPro and MHUBV4. */
                        if ([objHub isUControlSupport]) {
                            /* DataAPI: data/201 for MHUB UControl Summary which gives you boolean details of IRpack downloaded according to PortNo. */
                            if([objHub  isZPSetup] && [objHub isPairedSetup] ){
                                return;
                            }
                            [APIManager getUControlPackSummary:objHub Stacked:isStacked Slave:arrSlaveDevice completion:^(APIV2Response *responseObject) {

                                if (!responseObject.error) {
                                    Hub *objHubAPI5 = (Hub *)responseObject.data_description;
                                    if ([objHubAPI5.HubInputData isNotEmpty]) {
                                        objHub.HubInputData = objHubAPI5.HubInputData;
                                    }

                                    if ([objHubAPI5.HubOutputData isNotEmpty]) {
                                        objHub.HubOutputData = objHubAPI5.HubOutputData;
                                    }

                                    if ([objHubAPI5.HubAVRList isNotEmpty]) {
                                        objHub.HubAVRList = objHubAPI5.HubAVRList;
                                    }

                                    if (objHubAPI5.AVR_IRPack == true) {
                                        objHub.AVR_IRPack = objHubAPI5.AVR_IRPack;
                                    }

                                    Hub *objHubAPIXML = [[Hub alloc] initWithHub:[APIManager getIRPackArrayFromXML:objHub]];

                                    if ([objHubAPIXML.HubInputData isNotEmpty]) {
                                        objHub.HubInputData = objHubAPIXML.HubInputData;
                                    }

                                    if ([objHubAPIXML.HubOutputData isNotEmpty]) {
                                        objHub.HubOutputData = objHubAPIXML.HubOutputData;
                                    }

                                    if ([objHubAPIXML.HubAVRList isNotEmpty]) {
                                        objHub.HubAVRList = objHubAPIXML.HubAVRList;
                                    }
                                }
                                // Sync With uControl Case
                                /* ========= Data Management ======== */
                                // [APIManager saveAllMHUBDetailsToManager:objHub Slave:arrSlaveDevice Sync:isSync];
                                [[AppDelegate appDelegate] showHudView:ShowIndicatorTemparory Message:@""];
                                @try {
                                    mHubManagerInstance.objSelectedAVRDevice = [AVRDevice getIRPackStatusFromObject:objHub];
                                    mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objHub];
                                    //NSLog(@"objHubAPI2.HubZoneData %@",mHubManagerInstance.objSelectedHub.HubZoneData);

                                    mHubManagerInstance.masterHubModel = mHubManagerInstance.objSelectedHub.Generation;
                                    mHubManagerInstance.isPairedDevice = objHub.isPaired;
                                    mHubManagerInstance.arrSlaveAudioDevice = [[NSMutableArray alloc] initWithArray:arrSlaveDevice];


                                    if (isSync) {
                                        if (objHub.isPaired) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                                                           {
                                            [mHubManagerInstance syncGlobalManagerObjectV2];
                                            [[AppDelegate appDelegate] hideHudView:HideIndicatorTemparory Message:@""];

                                            handler(responseObject);
                                            });
                                        }
                                        else
                                            {
                                            [mHubManagerInstance syncGlobalManagerObjectV2];
                                            [[AppDelegate appDelegate] hideHudView:HideIndicatorTemparory Message:@""];

                                            handler(responseObject);
                                            }
                                    }
                                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                                } @catch (NSException *exception) {
                                    [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
                                }
                            }];
                           // }
                        } else {
                            // Sync Without uControl Case
                            /* ========= Data Management ======== */
                            [APIManager saveAllMHUBDetailsToManager:objHub Slave:arrSlaveDevice Sync:isSync];
                            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                            // responseObject.error = false;
                            handler(responseObject);
                        }
                    }];
                } else {
                    // Non Sync Case
                    /* ========= Data Management ======== */
                    [APIManager saveAllMHUBDetailsToManager:objHub Slave:arrSlaveDevice Sync:isSync];
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    handler(responseObject);
                }
            }
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) saveAllMHUBDetailsToManager:(Hub*)objHub Slave:(NSMutableArray*)arrSlaves Sync:(BOOL)isSync {
    @try {
        mHubManagerInstance.objSelectedHub = [[Hub alloc] initWithHub:objHub];
        mHubManagerInstance.masterHubModel = mHubManagerInstance.objSelectedHub.Generation;
        mHubManagerInstance.isPairedDevice = objHub.isPaired;
        mHubManagerInstance.arrSlaveAudioDevice = [[NSMutableArray alloc] initWithArray:arrSlaves];
        if (isSync) {
            
            [mHubManagerInstance syncGlobalManagerObjectV2];
            
        }
        // [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void)pingToTheHubExistOrNot:(NSString *)objDevice
{
    bool success = false;
    const char *host_name = [objDevice
                             cStringUsingEncoding:NSASCIIStringEncoding];
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,
                                                                                host_name);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    
    //prevents memory leak per Carlos Guzman's comment
    CFRelease(reachability);
    
    bool isAvailable = success && (flags & kSCNetworkFlagsReachable) &&
    !(flags & kSCNetworkFlagsConnectionRequired);
    if (isAvailable) {
        // NSLog(@"Host is reachable: %d", flags);
    }else{
        //NSLog(@"Host is unreachable");
    }
}
+(void) getSystemDetails:(Hub*)objDevice Stacked:(BOOL)isStacked Slave:(NSMutableArray*)arrSlaveDevice {
    @try {
        /* This method call from Appdelegate to resync All Data. */
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:HUB_CONNECTING];
        [APIManager getAllMHUBDetails:objDevice Stacked:isStacked Slave:arrSlaveDevice Sync:true completion:^(APIV2Response *responseObject) {
            if (responseObject.error) {
                if ([responseObject.error_description isEqualToString:HUB_APPUPDATE_MESSAGE]) {
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                } else {
                    if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
                        [[SearchDataManager sharedInstance] startSearchNetwork];
                        [SearchDataManager sharedInstance].delegate = self;
                    }
                }
            } else {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                [APIManager reloadDisplaySubView];
                [APIManager reloadSourceSubView];
            }
        }];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Zone Switch Status With IRPack
+(void) zoneSwitchStatus:(Hub*)objHub Zone:(Zone*)objInfo completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            
        } else {
            [APIManager getMHUBZoneStatus:objHub Zone:objInfo completion:^(APIV2Response *responseObject) {
                if (responseObject.error) {
                    mHubManagerInstance.objSelectedInputDevice = nil;
                    [ContinuityCommand saveCustomObject:@[] key:kSELECTEDCONTINUITYARRAY];
                    [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
                    handler(responseObject);
                } else {
                    Zone *objZoneStatus = (Zone*)responseObject.data_description;
                    mHubManagerInstance.objSelectedZone = objZoneStatus;
                    
                    OutputDevice *objOPZone = [mHubManagerInstance getOutputFromZone:objZoneStatus];
                    
                    if ([objOPZone isNotEmpty]) {
                        objOPZone = [OutputDevice getOutputObject_From:objOPZone To:[OutputDevice getFilteredOutputDeviceData:objOPZone.Index OutputData:objHub.HubOutputData]];
                    }
                    
                    /* If group is supportted by System then call Group API. */
                    if ([objHub isGroupSupport]) {
                        /* DataAPI: data/103 for MHUB Group details. */
                        [APIManager getMHUBGroups:objHub completion:^(APIV2Response *responseObject) {
                            if (!responseObject.error) {
                                Hub *objHubAPI4 = (Hub *)responseObject.data_description;
                                if ([objHubAPI4.HubGroupData isNotEmpty]) {
                                    objHub.HubGroupData = objHubAPI4.HubGroupData;
                                }
                                // Get Group from Group list which contains current selected Zone
                                [mHubManagerInstance getGroupFromZone:mHubManagerInstance.objSelectedZone GroupData:mHubManagerInstance.objSelectedHub.HubGroupData AllZoneData:mHubManagerInstance.objSelectedHub.HubZoneData completion:^(Group *objGroup, NSMutableArray<Zone *> *arrGroupZoneData) {
                                    if ([objGroup isNotEmpty]) {
                                        mHubManagerInstance.objSelectedGroup = [[Group alloc] initWithGroup:objGroup];
                                    } else {
                                        mHubManagerInstance.objSelectedGroup = nil;
                                    }
                                    if ([arrGroupZoneData isNotEmpty]) {
                                        // assigning Zone value to array from string value.
                                        mHubManagerInstance.arrSelectedGroupZoneList = [[NSMutableArray alloc] initWithArray:arrGroupZoneData];
                                    } else {
                                        mHubManagerInstance.arrSelectedGroupZoneList = [[NSMutableArray alloc] init];
                                    }
                                }];
                            }
                            else
                                {
                                // "description": "There is no group available for this MHUB."
                                
                                if ([responseObject.error_description isEqualToString:APP_NO_GROUP_MESSAGE]) {
                                    {
                                    mHubManagerInstance.objSelectedHub.HubGroupData = [[NSMutableArray alloc] init];
                                    
                                    mHubManagerInstance.objSelectedGroup = nil;
                                    [mHubManagerInstance.arrSelectedGroupZoneList removeAllObjects];
                                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                                    }
                                    // Get Group from Group list which contains current selected Zone
                                    [mHubManagerInstance getGroupFromZone:mHubManagerInstance.objSelectedZone GroupData:mHubManagerInstance.objSelectedHub.HubGroupData AllZoneData:mHubManagerInstance.objSelectedHub.HubZoneData completion:^(Group *objGroup, NSMutableArray<Zone *> *arrGroupZoneData) {
                                        if ([objGroup isNotEmpty]) {
                                            mHubManagerInstance.objSelectedGroup = [[Group alloc] initWithGroup:objGroup];
                                        } else {
                                            mHubManagerInstance.objSelectedGroup = nil;
                                        }
                                        if ([arrGroupZoneData isNotEmpty]) {
                                            // assigning Zone value to array from string value.
                                            mHubManagerInstance.arrSelectedGroupZoneList = [[NSMutableArray alloc] initWithArray:arrGroupZoneData];
                                        } else {
                                            mHubManagerInstance.arrSelectedGroupZoneList = [[NSMutableArray alloc] init];
                                        }
                                    }];
                                    
                                }
                                }
                        }];
                    }
                    
                    
                    
                    if ([objOPZone isNotEmpty]) {
                        mHubManagerInstance.objSelectedOutputDevice = objOPZone;
                        if (objZoneStatus.video_input > 0) {
                            InputDevice *objIPTemp = [InputDevice getFilteredInputDeviceData:objZoneStatus.video_input InputData:objHub.HubInputData];
                            if ([objIPTemp isNotEmpty] && objIPTemp.Index > 0) {
                                // Get casheIRPack from UserDefaults.
                                id cacheCommandData = [CommandType retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objIPTemp.PortNo]];
                                if ([cacheCommandData isNotEmpty]) {
                                    if ([cacheCommandData isKindOfClass:[CommandType class]]) {
                                        objIPTemp.objCommandType = cacheCommandData;
                                    } else {
                                        objIPTemp.objCommandType = [[CommandType alloc]init];
                                    }
                                    id cacheContinuityData = [ContinuityCommand retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objIPTemp.PortNo]];
                                    if ([cacheContinuityData isNotEmpty] && [cacheContinuityData isKindOfClass:[NSMutableArray class]]) {
                                        objIPTemp.arrContinuity = cacheContinuityData;
                                    } else {
                                        objIPTemp.arrContinuity = [[NSMutableArray alloc] init];
                                    }
                                }
                                mHubManagerInstance.objSelectedInputDevice = objIPTemp;
                                [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                                [ContinuityCommand saveCustomObject:[ContinuityCommand getDictionaryArray:objIPTemp.arrContinuity] key:kSELECTEDCONTINUITYARRAY];
                            } else {
                                mHubManagerInstance.objSelectedInputDevice = nil;
                                [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                                [ContinuityCommand saveCustomObject:@[] key:kSELECTEDCONTINUITYARRAY];
                            }
                        } else {
                            mHubManagerInstance.objSelectedInputDevice = nil;
                            [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                            [ContinuityCommand saveCustomObject:@[] key:kSELECTEDCONTINUITYARRAY];
                        }
                    } else {
                        mHubManagerInstance.objSelectedOutputDevice = objOPZone;
                    }
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    handler(responseObject);
                }
            }];
        }
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

+(void) switchInZoneOutputToInput:(Hub*)objHub Zone:(Zone*)objZone InputDevice:(InputDevice*)objIP completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            
        } else {
            mHubManagerInstance.objSelectedZone = objZone;
            OutputDevice *objOPZone = [mHubManagerInstance getOutputFromZone:objZone];
            
            if ([objOPZone isNotEmpty]) {
                objOPZone = [OutputDevice getOutputObject_From:objOPZone To:[OutputDevice getFilteredOutputDeviceData:objOPZone.Index OutputData:objHub.HubOutputData]];
            }
            mHubManagerInstance.objSelectedOutputDevice = objOPZone;
            
            //With completion block
            //            if ([objOPZone isNotEmpty]) {
            //                // SwitchIn API calling
            //                [APIManager switchIn_Address:objHub.Address OutputIndex:objOPZone.Index InputIndex:objIP.Index completion:^(APIV2Response *responseObject)
            //                 {
            //                     if (responseObject.error) {
            //
            //                         handler(responseObject);
            //                     } else {
            //
            //                     }
            //                 }];
            //            }
            //Without completion block
            if ([objOPZone isNotEmpty]) {
                // SwitchIn API calling
                if([objHub isZPSetup]){
                    [APIManager switchIn_Address:objHub.Address OutputIndex:objOPZone.Index InputIndex:objIP.Index];
                }
                else{
                [APIManager switchIn_Address:objHub.Address OutputIndex:objOPZone.Index InputIndex:objIP.PortNo];
                }
            }
            
            if (objIP.Index > 0) {
                InputDevice *objIPTemp;
//                if([objHub isZPSetup]){
//                    objIPTemp  = [InputDevice getFilteredInputDeviceData:objIP.PortNo InputData:objHub.HubInputData];
//                }
//                else{
                    objIPTemp = [InputDevice getFilteredInputDeviceData:objIP.Index InputData:objHub.HubInputData];
               // }
                
                if ([objIPTemp isNotEmpty] && objIPTemp.Index > 0) {
                    // Get casheIRPack from UserDefaults.
                    id cacheCommandData = [CommandType retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceIRPackDefaults, (long)objIPTemp.PortNo]];
                    if ([cacheCommandData isNotEmpty]) {
                        if ([cacheCommandData isKindOfClass:[CommandType class]]) {
                            objIPTemp.objCommandType = cacheCommandData;
                        } else {
                            objIPTemp.objCommandType = [[CommandType alloc]init];
                        }
                        id cacheContinuityData = [ContinuityCommand retrieveCustomObjectWithKey:[NSString stringWithFormat:kDeviceContinuityDefaults, (long)objIPTemp.PortNo]];
                        if ([cacheContinuityData isNotEmpty] && [cacheContinuityData isKindOfClass:[NSMutableArray class]]) {
                            objIPTemp.arrContinuity = cacheContinuityData;
                        } else {
                            objIPTemp.arrContinuity = [[NSMutableArray alloc] init];
                        }
                    }
                    mHubManagerInstance.objSelectedInputDevice = objIPTemp;
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    [ContinuityCommand saveCustomObject:[ContinuityCommand getDictionaryArray:objIPTemp.arrContinuity] key:kSELECTEDCONTINUITYARRAY];
                } else {
                    mHubManagerInstance.objSelectedInputDevice = nil;
                    [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                    [ContinuityCommand saveCustomObject:@[] key:kSELECTEDCONTINUITYARRAY];
                }
                
                APIV2Response *objReturn = [[APIV2Response alloc] init];
                objReturn.error = false;
                objReturn.data_description = objIPTemp;
                handler(objReturn);
            } else {
                mHubManagerInstance.objSelectedInputDevice = nil;
                [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                [ContinuityCommand saveCustomObject:@[] key:kSELECTEDCONTINUITYARRAY];
                
                APIV2Response *objReturn = [[APIV2Response alloc] init];
                objReturn.error = true;
                objReturn.error_description = ALERT_MESSAGE_SELECT_DEVICE;
                handler(objReturn);
            }
            
            [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
        }
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - MHUB Audio Volume APIV2
+(void) switchInAudioZone_Address:(NSString*)strAddress ZoneId:(NSString*)strZoneId InputIndex:(NSInteger)intInputIndex{
    //+(void) switchInAudioZone_Address:(NSString*)strAddress ZoneId:(NSString*)strZoneId InputIndex:(NSInteger)intInputIndex completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            if (![strZoneId isNotEmpty]) {
                [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_SELECT_ZONE];
            } else {
                if(mHubManagerInstance.objSelectedHub.webSocketFlag){
                    NSString *requestString= [Utility createJSONFor_zoneSwitch:strZoneId input:[NSString stringWithFormat:@"%ld",(long)intInputIndex]];
                    [[WSManager sharedInstance]sendData:requestString];
                }
                else{
                [APIManager getObjectResponseFromService:[API switchInAudioZoneURL:strAddress ZoneId:strZoneId InputIndex:intInputIndex] Version:APIV2 WithCompletion:^(id objResponse) {
                    APIV2Response *objResp = (APIV2Response*)objResponse;
                    if (objResp.error) {
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                    } else {
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    }
                    //handler(objResp);
                }];
                }
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - MHUB 411 ARC Command
+(void) switchInAudio411ARC_Address:(NSString*)strAddress flagOutputIndex:(NSString *)boolOutputIndex flagInputIndex:(NSString *)boolInputIndex{
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
                
            if(mHubManagerInstance.objSelectedHub.webSocketFlag){
                NSString *requestString= [Utility createJSONFor_ARC:boolOutputIndex type:@"0" State:boolInputIndex];
                [[WSManager sharedInstance]sendData:requestString];
            }
            else{
                [APIManager getObjectResponseFromService:[API switchInAudio411ARCURL:strAddress outputFlag:boolOutputIndex InputFlag:boolInputIndex] Version:APIV2 WithCompletion:^(id objResponse) {
                    APIV2Response *objResp = (APIV2Response*)objResponse;
                    if (objResp.error) {
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                    } else {
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    }
                    //handler(objResp);
                }];
            }
            
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) controlVolumeAudioZone_Address:(NSString*)strAddress ZoneId:(NSString*)strZoneId Volume:(NSInteger)intVolume {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            if (![strZoneId isNotEmpty]) {
                [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_SELECT_ZONE];
            } else {
                if(mHubManagerInstance.objSelectedHub.webSocketFlag){
                    NSString *requestString= [Utility createJSONFor_VolumeControl_Zone:strZoneId Level:[NSString stringWithFormat:@"%ld",(long)intVolume]];
                    [[WSManager sharedInstance]sendData:requestString];
                }
                else{
                [APIManager getObjectResponseFromService:[API controlVolumeAudioZoneURL:strAddress ZoneId:strZoneId Volume:intVolume] Version:APIV2 WithCompletion:^(id objResponse) {
                    APIV2Response *objResp = (APIV2Response*)objResponse;
                    if (objResp.error) {
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                    } else {
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    }
                }];
                }
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) controlMuteAudioZone_Address:(NSString*)strAddress ZoneId:(NSString*)strZoneId Mute:(BOOL)isMuted {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            if (![strZoneId isNotEmpty]) {
                [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_SELECT_ZONE];
            } else {
                if(mHubManagerInstance.objSelectedHub.webSocketFlag){
                    NSString *requestString= [Utility createJSONFor_MuteZone:strZoneId State:isMuted ? @"true" : @"false"];
                    [[WSManager sharedInstance]sendData:requestString];
                }
                else{
                
                [APIManager getObjectResponseFromService:[API controlMuteAudioZoneURL:strAddress ZoneId:strZoneId Mute:isMuted] Version:APIV2 WithCompletion:^(id objResponse) {
                    APIV2Response *objResp = (APIV2Response*)objResponse;
                    if (objResp.error) {
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                    } else {
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    }
                }];
                }
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark -
//With completion block

//+(void) switchIn_Address:(NSString*)strAddress OutputIndex:(NSInteger)intOutputIndex InputIndex:(NSInteger)intInputIndex completion:(void (^)(APIV2Response *responseObject))handler{
//Without completion block
+(void) switchIn_Address:(NSString*)strAddress OutputIndex:(NSInteger)intOutputIndex InputIndex:(NSInteger)intInputIndex {

    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
             
            if(mHubManagerInstance.objSelectedHub.webSocketFlag){
                NSString *requestString= [Utility createJSONFor_inputSwitch:[Utility integerToCharacter:intOutputIndex] input:[NSString stringWithFormat:@"%ld",(long)intInputIndex]];
                [[WSManager sharedInstance]sendData:requestString];
            }
            else{
           
            [APIManager getObjectResponseFromService:[API switchInURL:strAddress OutputIndex:intOutputIndex InputIndex:intInputIndex] Version:APIV2 WithCompletion:^(id objResponse) {
                APIV2Response *objResp = (APIV2Response*)objResponse;
                if (objResp.error) {
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                } else {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                }
                //handler(objResp);
            }];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) controlVolume_Address:(NSString*)strAddress OutputIndex:(NSInteger)intOutputIndex Volume:(NSInteger)intVolume {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            if(mHubManagerInstance.objSelectedHub.webSocketFlag){
                NSString *requestString= [Utility createJSONFor_VolumeControl:[Utility integerToCharacter:intOutputIndex] Level:[NSString stringWithFormat:@"%ld",(long)intVolume]];
                [[WSManager sharedInstance]sendData:requestString];
            }
            else{
            [APIManager getObjectResponseFromService:[API controlVolumeURL: strAddress OutputIndex:intOutputIndex Volume:intVolume] Version:APIV2 WithCompletion:^(id objResponse) {
                APIV2Response *objResp = (APIV2Response*)objResponse;
                if (objResp.error) {
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                } else {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                }
            }];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) controlMute_Address:(NSString*)strAddress OutputIndex:(NSInteger)intOutputIndex Mute:(BOOL)isMuted {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            if(mHubManagerInstance.objSelectedHub.webSocketFlag){
                NSString *requestString= [Utility createJSONFor_Mute_output:[NSString stringWithFormat:@"%ld",(long)intOutputIndex] State:isMuted ? @"true" : @"false"];
                [[WSManager sharedInstance]sendData:requestString];
            }
            else{
            [APIManager getObjectResponseFromService:[API controlMuteURL: strAddress OutputIndex:intOutputIndex Mute:isMuted] Version:APIV2 WithCompletion:^(id objResponse) {
                APIV2Response *objResp = (APIV2Response*)objResponse;
                if (objResp.error) {
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                } else {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                }
            }];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark -

+(void) executeCommand_Address:(NSString*)strAddress CommandId:(NSInteger)intCommandId PortId:(NSInteger)intPortId TouchType:(TouchActivity)objTouchType{
    @try {
        if(mHubManagerInstance.objSelectedHub.webSocketFlag){
            NSString *requestString= [Utility createJSONFor_IRCommand:[NSString stringWithFormat:@"%ld",(long)intPortId] ID:[NSString stringWithFormat:@"%ld",(long)intCommandId] TouchType:objTouchType];
            [[WSManager sharedInstance]sendData:requestString];
        }
        else{
        [APIManager getObjectResponseFromService:[API executeCommandURL:strAddress PortId:intPortId CommandId:intCommandId TouchType:objTouchType] Version:APIV2 WithCompletion:^(id objResponse) {
            DDLogDebug(@"Response == %@", objResponse);
        }];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(void) executeCommand_Address_AcceptString:(NSString*)strAddress CommandId:(NSInteger )intCommandId PortId:(NSString *)intPortId {
    @try {
        if(mHubManagerInstance.objSelectedHub.webSocketFlag){
            NSArray *arrayObj = [intPortId componentsSeparatedByString:@"/"];
            NSString *requestString= [Utility createJSONFor_CECCommand_port:[arrayObj objectAtIndex:0] type:[arrayObj objectAtIndex:1] ID:[NSString stringWithFormat:@"%ld",(long)intCommandId]];
            [[WSManager sharedInstance]sendData:requestString];
        }
        else{
        [APIManager getObjectResponseFromService:[API executeCommandURL_AcceptString:strAddress PortId:intPortId CommandId:intCommandId] Version:APIV2 WithCompletion:^(id objResponse) {
            DDLogDebug(@"Response == %@", objResponse);
        }];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


+(void) callExecuteCommand_Hub:(Hub*)objHub Command:(Command*)objCmd PortNo:(NSInteger)intPort TouchType:(TouchActivity)objTouchType{
    @try {
        if (![objHub isDemoMode] && [objCmd isNotEmpty]) {
            if (intPort == 0) {
                [[AppDelegate appDelegate] showHudView:ShowMessage Message:HUB_SELECTEDDEVICE];
            } else {
                if ([objHub isAPIV2]) {
                    //DDLogDebug(@"objCmd.command_id == %ld", (long)objCmd.command_id);
                    if(objHub.Generation == mHub411 && [[NSUserDefaults standardUserDefaults]boolForKey:@"CEC_COMMAND"])
                    {
                        NSString *newPortIdStr =  [NSString stringWithFormat:@"%@/0",[Utility integerToCharacter:intPort]];
                        NSLog(@"device mHub411 and port id %@",newPortIdStr);
                        [self executeCommand_Address_AcceptString:objHub.Address CommandId:objCmd.command_id PortId:@"a/0"];
                    }
                    else if(objHub.Generation == mHubZP && [[NSUserDefaults standardUserDefaults]boolForKey:@"CEC_COMMAND"])
                    {
                        [self executeCommand_Address_AcceptString:objHub.Address CommandId:objCmd.command_id PortId:@"a/0"];
                    }
                    else if(objHub.Generation == mHubPro2 && [[NSUserDefaults standardUserDefaults]boolForKey:@"CEC_COMMAND"])
                    {
                        NSString *newPortIdStr =  [NSString stringWithFormat:@"%@/1",[Utility integerToCharacter:intPort]];
                         NSLog(@"device mHubPro2 and port id %@",newPortIdStr);
                        [self executeCommand_Address_AcceptString:objHub.Address CommandId:objCmd.command_id PortId:newPortIdStr];
                    }
                    else
                    {
                         [self executeCommand_Address:objHub.Address CommandId:objCmd.command_id PortId:intPort TouchType:objTouchType];
                    }

                } else {
                    [self irEngine_Code:objCmd.code PortId:intPort];
                }
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


#pragma mark -
+(void) executeSequence:(NSString*)strAddress SequenceId:(NSString*)strSequenceId isSuperSeq:(BOOL)isSuperSeqFlag completion:(void (^)(APIV2Response *responseObject)) handler {
    @try {
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            //DDLogDebug(@"<%s> AlexaName = %@", __PRETTY_FUNCTION__, strAlexaName);
            APIV2Response *objReturn = [[APIV2Response alloc] init];
            objReturn.error = false;
            objReturn.data_description = strSequenceId;
            handler(objReturn);
        } else {
            [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
            [APIManager getObjectResponseFromService:[API executeSequenceURL:strAddress SequenceId:strSequenceId] Version:APIV2 WithCompletion:^(id objResponse) {
                APIV2Response *objResp = (APIV2Response*)objResponse;
                if (objResp.error) {
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                    handler(objResp);
                } else {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    handler(objResp);
                }
            }];
        }
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - Super sequence
+(void) executeSuperSequence:(NSString*)strAddress SequenceId:(NSString*)strSequenceId isSuperSeq:(BOOL)isSuperSeqFlag completion:(void (^)(APIV2Response *responseObject)) handler {
    @try {
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            //DDLogDebug(@"<%s> AlexaName = %@", __PRETTY_FUNCTION__, strAlexaName);
            APIV2Response *objReturn = [[APIV2Response alloc] init];
            objReturn.error = false;
            objReturn.data_description = strSequenceId;
            handler(objReturn);
        } else {
            [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
            [APIManager getObjectResponseFromService:[API executeSuperSequenceURL:strAddress SequenceId:strSequenceId superSeqFlag:isSuperSeqFlag] Version:APIV2 WithCompletion:^(id objResponse) {
                APIV2Response *objResp = (APIV2Response*)objResponse;
                if (objResp.error) {
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                    handler(objResp);
                } else {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    handler(objResp);
                }
            }];
        }
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - Function
+(void) executeFunction:(NSString*)strAddress functionId:(NSString*)strFunctionId isFlag:(BOOL)isFlag completion:(void (^)(APIV2Response *responseObject)) handler {
    @try {
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            //DDLogDebug(@"<%s> AlexaName = %@", __PRETTY_FUNCTION__, strAlexaName);
            APIV2Response *objReturn = [[APIV2Response alloc] init];
            objReturn.error = false;
            objReturn.data_description = strFunctionId;
            handler(objReturn);
        } else {
            [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
            [APIManager getObjectResponseFromService:[API executeFunctionURL:strAddress functionId:strFunctionId Flag:isFlag] Version:APIV2 WithCompletion:^(id objResponse) {
                APIV2Response *objResp = (APIV2Response*)objResponse;
                if (objResp.error) {
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                    handler(objResp);
                } else {
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    handler(objResp);
                }
            }];
        }
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - Group Manage
+(void) groupCreate_Address:(NSString*)strAddress GroupName:(NSString*)strGroupName completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            DDLogDebug(@"[API groupCreateURL:strAddress GroupName:strGroupName] == %@", [API groupCreateURL:strAddress GroupName:strGroupName]);
            [APIManager getObjectResponseFromService:[API groupCreateURL:strAddress GroupName:strGroupName] Version:APIV2 WithCompletion:^(id objResponse) {
                APIV2Response *objResp = (APIV2Response*)objResponse;
                if (objResp.error) {
                    [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                    handler(objResp);
                } else {
                    NSDictionary *dictResp = [Utility checkNullForKey:kGROUP_CREATED Dictionary:objResp.data_description];
                    Group *objGroup = [Group getObjectFromDictionary:dictResp];
                    objResp.data_description = objGroup;
                    [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                    handler(objResp);
                }
            }];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) groupDelete_Address:(NSString*)strAddress GroupId:(NSString*)strGroupId completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            if ([strGroupId isNotEmpty]) {
                [APIManager getObjectResponseFromService:[API groupDeleteURL:strAddress GroupId:strGroupId] Version:APIV2 WithCompletion:^(id objResponse) {
                    APIV2Response *objResp = (APIV2Response*)objResponse;
                    if (objResp.error) {
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                        handler(objResp);
                    } else {
                        NSDictionary *dictResp = [Utility checkNullForKey:kGROUP_DELETED Dictionary:objResp.data_description];
                        Group *objGroup = [Group getObjectFromDictionary:dictResp];
                        objResp.data_description = objGroup;
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        handler(objResp);
                    }
                }];
            } else {
                APIV2Response *objReturn = [APIV2Response getErrorResponse:nil];
                objReturn.error_description = HUB_TROUBLECONNECTING;
                handler(objReturn);
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) groupOperation_Address:(NSString*)strAddress Group:(Group*)objGroup Operation:(GroupOperation)operation completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            if ([objGroup.GroupId isNotEmpty]) {
                // NSArray *arrZoneId = [objGroup.arrGroupedZones valueForKey:@"zone_id"];
                // DDLogDebug(@"arrZoneId == %@", arrZoneId);
                NSDictionary *dictZones = [[NSDictionary alloc] initWithObjectsAndKeys: objGroup.arrGroupedZones, kZONES, nil];
                [APIManager postObjectToAPI_UsingAFN:[API groupOperationURL:strAddress GroupId:objGroup.GroupId Operation:operation] Parameter:dictZones Version:APIV2 WithCompletion:^(id objResponse) {
                    APIV2Response *objResp = (APIV2Response*)objResponse;
                    if (objResp.error) {
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                        handler(objResp);
                    } else {
                        // DDLogDebug(@"objResp.data_description == %@", objResp.data_description);
                        NSDictionary *dictResp = [Utility checkNullForKey:kGROUP Dictionary:objResp.data_description];
                        Group *objGroup = [Group getObjectFromDictionary:dictResp];
                        NSDictionary *dictZones = [Utility checkNullForKey:kZONES Dictionary:objResp.data_description];
                        NSMutableArray *arrZonesAdded = [[NSMutableArray alloc] initWithArray:[Utility checkNullForKey:kZONES Dictionary:[Utility checkNullForKey:kADDED Dictionary:dictZones]]];
                        // NSArray *arrZonesRemoved = [Utility checkNullForKey:kZONES Dictionary:[Utility checkNullForKey:kREMOVED Dictionary:dictZones]];
                        objGroup.arrGroupedZones = arrZonesAdded;
                        
                        objResp.data_description = objGroup;
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        handler(objResp);
                    }
                }];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) groupVolume_Address:(NSString*)strAddress GroupId:(NSString*)strGroupId Volume:(NSInteger)intVolume completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            if ([strGroupId isNotEmpty]) {
                [APIManager getObjectResponseFromService:[API groupAdjustVolumeURL:strAddress GroupId:strGroupId Volume:intVolume] Version:APIV2 WithCompletion:^(id objResponse) {
                    APIV2Response *objResp = (APIV2Response*)objResponse;
                    if (objResp.error) {
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                        handler(objResp);
                    } else {
                        NSDictionary *dictResp = [Utility checkNullForKey:kGROUP Dictionary:objResp.data_description];
                        Group *objGroup = [Group getObjectFromDictionary:dictResp];
                        
                        objGroup.GroupVolume = [[Utility checkNullForKey:kGROUPVOLUME Dictionary:objResp.data_description] integerValue];
                        
                        objResp.data_description = objGroup;
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        handler(objResp);
                    }
                }];
            } else {
                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(void) groupMute_Address:(NSString*)strAddress GroupId:(NSString*)strGroupId Mute:(BOOL)isMuted completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
        if ([strAddress isIPAddressEmpty]) {
            [[AppDelegate appDelegate] showHudView:ShowMessage Message:ALERT_MESSAGE_ENTER_AUDIOIPADDRESS];
        } else {
            if ([strGroupId isNotEmpty]) {
                [APIManager getObjectResponseFromService:[API groupMuteValueURL:strAddress GroupId:strGroupId Mute:isMuted] Version:APIV2 WithCompletion:^(id objResponse) {
                    APIV2Response *objResp = (APIV2Response*)objResponse;
                    if (objResp.error) {
                        [[AppDelegate appDelegate] showHudView:ShowMessage Message:objResp.error_description];
                        handler(objResp);
                    } else {
                        NSDictionary *dictResp = [Utility checkNullForKey:kGROUP Dictionary:objResp.data_description];
                        Group *objGroup = [Group getObjectFromDictionary:dictResp];
                        
                        objGroup.GroupMute = [[Utility checkNullForKey:kGROUPMUTE Dictionary:objResp.data_description] boolValue];
                        
                        objResp.data_description = objGroup;
                        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
                        handler(objResp);
                    }
                }];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark -
+(void) groupManager_Address:(NSString*)strAddress Group:(Group*)objGroup Operation:(GroupOperation)operation completion:(void (^)(APIV2Response *responseObject))handler {
    /* Execute Group Operation according to conditions. */
    switch (operation) {
        case GRPO_Add: {
            if ([objGroup.GroupId isNotEmpty]) {
                [APIManager groupOperation_Address:strAddress Group:objGroup Operation:operation completion:^(APIV2Response *responseObject) {
                    handler (responseObject);
                }];
            } else {
                [APIManager groupCreate_Address:strAddress GroupName:objGroup.GroupName completion:^(APIV2Response *responseObject) {
                    if (!responseObject.error) {
                        Group *objGroupResp = [Group getGroupObject_From:responseObject.data_description To:objGroup];
                        [APIManager groupOperation_Address:strAddress Group:objGroupResp Operation:operation completion:^(APIV2Response *responseObject) {
                            handler (responseObject);
                        }];
                    } else {
                        handler (responseObject);
                    }
                }];
            }
            break;
        }
            
        case GRPO_Delete: {
            [APIManager groupDelete_Address:strAddress GroupId:objGroup.GroupId completion:^(APIV2Response *responseObject) {
                handler (responseObject);
            }];
            break;
        }
            
        case GRPO_Volume: {
            [APIManager groupVolume_Address:strAddress GroupId:objGroup.GroupId Volume:objGroup.GroupVolume completion:^(APIV2Response *responseObject) {
                handler (responseObject);
            }];
            break;
        }
            
        case GRPO_Mute: {
            [APIManager groupMute_Address:strAddress GroupId:objGroup.GroupId Mute:objGroup.GroupMute completion:^(APIV2Response *responseObject) {
                handler (responseObject);
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - RESET MHUB

+(void) resetMhubSetting:(NSString*)strAddress completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager getObjectResponseFromAPI_UsingAFN:[API resetMhubSettingURL:strAddress] Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            handler(objResp);
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}

#pragma mark - RESET MHUB
+(void) setPairJSON:(Hub*)objHub PairData:(NSDictionary *)dictParameter completion:(void (^)(APIV2Response *responseObject))handler {
    @try {
        [APIManager postObjectToAPI_UsingAFN:[API setPairJSONURL:objHub.Address] Parameter:dictParameter Version:APIV2 WithCompletion:^(id objResponse) {
            APIV2Response *objResp = (APIV2Response*)objResponse;
            // DDLogDebug(@"objResp.data_description == %@", objResp.data_description);
            handler(objResp);
        }];
    } @catch (NSException *exception) {
        APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
        handler(objReturn);
    }
}




+ (void)writeAndAppendString:(NSString *)strRequestResponse apiName:(NSString *)apiNameObj isFlag:(BOOL)isRequest requestParameter:(NSString *)requestParams{
    //Adding return statement to make the version live and it should not log text in Live version
    return;
    
    NSString *filename =  @"textLog.txt";
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    // Adding your dateString to your content string
    NSString *content;
    if(isRequest){
        content = [NSString stringWithFormat:@"START************************ \n\nAPI-NAME %@ \n\nTIME STAMP %@\n\nREQUEST or PARAMETER %@ \n ************************END\n\n",apiNameObj,dateString,requestParams];
        
    }
    else
        {
        content = [NSString stringWithFormat:@"START************************ \n\nAPI-NAME %@ \n\nTIME STAMP %@\n\nRESPONSE %@  \n ************************END\n\n",apiNameObj,dateString, strRequestResponse];
        }
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (0 < [paths count]) {
        NSString *documentsDirPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirPath stringByAppendingPathComponent:filename];
        NSLog(@"filePath%@",filePath);
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            // Add the text at the end of the file.
            NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
            [fileHandler seekToEndOfFile];
            [fileHandler writeData:data];
            [fileHandler closeFile];
            unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
            NSLog(@"Current file size %llu",fileSize);
            //            if(fileSize >  100000){
            //                [[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSData data] attributes:nil];
            //            }
            
        } else {
            // Create the file and write text to it.
            [data writeToFile:filePath atomically:YES];
        }
    }
}

+ (void)writeNormalStringWithTimeStamp:(NSString *)strToLog
{
    //Adding return statement to make the version live and it should not log text in Live version
    return;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *content;
    content = [NSString stringWithFormat:@"START ************ \n%@ TIMESTAMP== \n%@ ****** END\n",strToLog,dateString];
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (0 < [paths count]) {
        NSString *documentsDirPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirPath stringByAppendingPathComponent:@"textLog.txt"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            // Add the text at the end of the file.
            NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
            [fileHandler seekToEndOfFile];
            [fileHandler writeData:data];
            [fileHandler closeFile];
            // unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
            //NSLog(@"Current file size %llu",fileSize);
            //            if(fileSize >  100000){
            //                [[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSData data] attributes:nil];
            //            }
            
        } else {
            // Create the file and write text to it.
            [data writeToFile:filePath atomically:YES];
        }
    }
}

#pragma mark - get mhub power state
+(void) getmHubPowerState:(NSString *)address completion:(void (^)(NSDictionary *responseObject))handler{
    @try {
        
        [APIManager getObjectResponseFromAPI_UsingAFN:[API getMHUBPowerState: mHubManagerInstance.objSelectedHub.Address] Version:APIV1 WithCompletion:^(id objResponse) {
       // [APIManager getObjectResponseFromService:[API getMHUBPowerState: mHubManagerInstance.objSelectedHub.Address] Version:APIV1 WithCompletion:^(id objResponse){
       // [APIManager getObjectResponseFromAPI_UsingAFN:[API getMHUBPowerState: mHubManagerInstance.objSelectedHub.Address] Version:APIV2 WithCompletion:^(id objResponse){
            NSLog(@"response %@",objResponse);
            APIResponse *objResp = (APIResponse*)objResponse;
            if ([objResp.data isKindOfClass:[NSDictionary class]]) {
                               handler(objResp.data);
            }
            
           // APIV2Response *objResp = (APIV2Response*)objResponse;
//            if (objResp.error) {
//                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
//                handler(objResp);
//            } else {
//                NSLog(@"response %@",objResp.data_description);
//                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
//                if ([objResponse.data_description isKindOfClass:[NSDictionary class]]) {
//
//                    objResponse.data_description = objHubReturn;
//                    handler(objResponse);
//                }
//                handler(objResp);
//            }
        }];
    }
 @catch (NSException *exception) {
    APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
    handler(objReturn);
}

}

#pragma mark - set mhub power state
+(void) setmHubPowerState:(NSString *)address powerSt:(NSString *)state completion:(void (^)(NSDictionary *responseObject))handler{
    @try {
        
        [APIManager getObjectResponseFromAPI_UsingAFN:[API setMHUBPowerState:address flag:state] Version:APIV1 WithCompletion:^(id objResponse) {
       // [APIManager getObjectResponseFromService:[API getMHUBPowerState: mHubManagerInstance.objSelectedHub.Address] Version:APIV1 WithCompletion:^(id objResponse){
       // [APIManager getObjectResponseFromAPI_UsingAFN:[API getMHUBPowerState: mHubManagerInstance.objSelectedHub.Address] Version:APIV2 WithCompletion:^(id objResponse){
            NSLog(@"response %@",objResponse);
            APIResponse *objResp = (APIResponse*)objResponse;
            if ([objResp.data isKindOfClass:[NSDictionary class]]) {
                               handler(objResp.data);
            }
            
           // APIV2Response *objResp = (APIV2Response*)objResponse;
//            if (objResp.error) {
//                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
//                handler(objResp);
//            } else {
//                NSLog(@"response %@",objResp.data_description);
//                [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
//                if ([objResponse.data_description isKindOfClass:[NSDictionary class]]) {
//
//                    objResponse.data_description = objHubReturn;
//                    handler(objResponse);
//                }
//                handler(objResp);
//            }
        }];
    }
 @catch (NSException *exception) {
    APIV2Response *objReturn = [APIV2Response getExceptionalResponse:exception];
    handler(objReturn);
}

}


@end
