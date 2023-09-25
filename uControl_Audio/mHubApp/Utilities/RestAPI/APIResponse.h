//
//  APIResponse.h
//  mHubApp
//
//  Created by Anshul Jain on 21/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kERROR      @"error"
#define kRESPONSE   @"response"
#define kDATA       @"data"

#define kHEADER     @"header"
#define kVERSION    @"version"
#define kDATA_DESCRIPTION   @"description"
#define kERROR_DESCRIPTION  @"description"

@interface APIResponse : NSObject

@property (nonatomic, assign) BOOL error;
@property (nonatomic, retain) id response;
@property (nonatomic, retain) id data;
+(APIResponse*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(APIResponse*) getObjectFromFile:(NSDictionary*)dictResp;
+(APIResponse*) getExceptionalResponse:(NSException*)exception;
+(APIResponse*) getErrorResponse:(NSError*)error;
+(APIResponse*) getInternetNotAvailableResponse;
+(APIResponse*) getFileNotFoundResponse;
+(APIResponse*) getAPINotFoundResponse;

@end

@interface APIV2Response : NSObject
@property (nonatomic, assign) float version;
@property (nonatomic, assign) BOOL error;
@property (nonatomic, retain) id data_description;
@property (nonatomic, retain) id error_description;

+(APIV2Response*) getObjectFromDictionary:(NSDictionary*)dictResp;
+(APIV2Response*) getObjectFromFile:(NSDictionary*)dictResp;
+(APIV2Response*) getExceptionalResponse:(NSException*)exception;
+(APIV2Response*) getErrorResponse:(NSError*)error;
+(APIV2Response*) getInternetNotAvailableResponse;
+(APIV2Response*) getFileNotFoundResponse;
+(APIV2Response*) getAPINotFoundResponse;
+(APIV2Response*) getObjectFromAPIResponse:(APIResponse*)objResponse;
@end
