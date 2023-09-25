//
//  BenchMarkData.m
//  mHubApp
//
//  Created by Rave on 06/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "BenchMarkData.h"

@implementation BenchMarkData
#pragma mark - PairDetail Intializer

-(id)init {
    self = [super init];
    self.str_IOSApp_Version        = @"";
    self.str_AndroidApp_Version    = @"";
    self.str_ProductModel_Type     = @"";
    self.str_Mhub_Version          = @"";
    return self;
}

-(id)initWithPair:(BenchMarkData *)pairData {
    self = [super init];
    self.str_IOSApp_Version        = pairData.str_IOSApp_Version;
    self.str_AndroidApp_Version    = pairData.str_AndroidApp_Version;
    self.str_Mhub_Version          = pairData.str_Mhub_Version;
    self.str_ProductModel_Type     = pairData.str_ProductModel_Type;//[pairData.str_ProductModel_Type isNotEmpty] ? pairData.str_ProductModel_Type : UNKNOWN_IP;
    
    return self;
}

@end
//@implementation BenchMarkDetails
//#pragma mark - BenchMarkDetails Intializer
//
//-(id)init {
//    self = [super init];
//    self.str_IOSApp_Version        = @"";
//    self.str_AndroidApp_Version  = @"";
//    self.str_ProductModel_Type     = @"";
//    self.str_Mhub_Version       = @"";
//    return self;
//}
//
//-(id)initWithPair:(BenchMarkData *)pairData {
//    self = [super init];
//    self.str_IOSApp_Version        = pairData.str_IOSApp_Version;
//    self.str_AndroidApp_Version    = pairData.str_AndroidApp_Version;
//    self.str_Mhub_Version          = pairData.str_Mhub_Version;
//    self.str_ProductModel_Type     =  pairData.str_ProductModel_Type;//[pairData.str_ProductModel_Type isNotEmpty] ? pairData.str_ProductModel_Type : UNKNOWN_IP;
//
//    return self;
//}
//
//
//
//+(NSMutableArray*)getDictionaryArray:(NSMutableArray*)arrResp {
//    @try {
//        NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
//        if([arrResp isNotEmpty]) {
//            for (int i = 0; i < [arrResp count]; i++) {
//                PairDetail *objDevice = [arrResp objectAtIndex:i];
//                NSDictionary *dictResp = [objDevice dictionaryRepresentation];
//                [arrReturn addObject:dictResp];
//            }
//        }
//        return arrReturn;
//    } @catch(NSException *exception) {
//        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
//    }
//}


//@end
