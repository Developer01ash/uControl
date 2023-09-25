//
//  XMLResponse.m
//  mHubApp
//
//  Created by Anshul Jain on 22/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "XMLResponse.h"

@implementation XMLResponse
+(XMLResponse*) getObjectFromDictionary:(NSDictionary*)dictResp CDeviceType:(ControlDeviceType)type {
    XMLResponse *objReturn=[[XMLResponse alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            switch (type) {
                case InputSource: {
                    objReturn.controlPack = [ControlPack getObjectFromXMLDictionary:[Utility checkNullForKey:kControlPack Dictionary:dictResp]];
                    break;
                }

                case OutputScreen: {
                    //if([mHubManagerInstance.objSelectedHub isZPSetup]){
                    NSMutableDictionary *duplicateCopyOfdictResp = [[NSMutableDictionary alloc]initWithDictionary:dictResp];
                    NSMutableDictionary *fetchControlPackKeyValue = [Utility checkNullForKey:kControlPack Dictionary:dictResp];
                    NSDictionary *dictIR = [Utility checkNullForKey:kCPIR Dictionary:[Utility checkNullForKey:kControlPack Dictionary:dictResp]];
                    NSMutableDictionary *dictIR2 = [[NSMutableDictionary alloc]init];
                    if([[Utility checkNullForKey:kCPIR Dictionary:[Utility checkNullForKey:kControlPack Dictionary:dictResp]] isKindOfClass:[NSDictionary class]]){
                    dictIR2  = [Utility checkNullForKey:kCPIR Dictionary:[Utility checkNullForKey:kControlPack Dictionary:dictResp]];
                    }
                    NSMutableArray *arrayCEC = [Utility checkNullForKey:kCECPACK Dictionary:dictResp];
                    if([arrayCEC isNotEmpty])
                    {
                        [dictIR2 setObject:arrayCEC forKey:@"command"];
                        [fetchControlPackKeyValue setObject:dictIR2 forKey:kCPIR];
                        [duplicateCopyOfdictResp setObject:fetchControlPackKeyValue forKey:kControlPack];
                        dictResp = duplicateCopyOfdictResp;
                        dictIR = dictIR2;
                    }
                    objReturn.controlPack = [ControlPack getObjectFromXMLDictionary:[Utility checkNullForKey:kControlPack Dictionary:dictResp]];
                    if ([dictIR isNotEmpty] && [dictIR isKindOfClass:[NSDictionary class]]) {
                            objReturn.IRCommandPacket = [[NSArray alloc] initWithArray:[Command getXMLObjectArray:[Utility checkNullForKey:kIRCommand Dictionary:dictIR]]];
                    }
//                    }
//                    else
//                    {
//                    NSDictionary *dictIR = [Utility checkNullForKey:kCPIR Dictionary:[Utility checkNullForKey:kControlPack Dictionary:dictResp]];
//                    objReturn.controlPack = [ControlPack getObjectFromXMLDictionary:[Utility checkNullForKey:kControlPack Dictionary:dictResp]];
//                    if ([dictIR isNotEmpty] && [dictIR isKindOfClass:[NSDictionary class]]) {
//                        objReturn.IRCommandPacket = [[NSArray alloc] initWithArray:[Command getXMLObjectArray:[Utility checkNullForKey:kIRCommand Dictionary:dictIR]]];
//                    }
//                    }



                    break;
                }

                case AVRSource: {
                    objReturn.controlPack = [ControlPack getObjectFromXMLDictionary:[Utility checkNullForKey:kControlPack Dictionary:dictResp]];
                    NSDictionary *dictIR = [Utility checkNullForKey:kCPIR Dictionary:[Utility checkNullForKey:kControlPack Dictionary:dictResp]];
                    if ([dictIR isNotEmpty] && [dictIR isKindOfClass:[NSDictionary class]]) {
                        objReturn.IRCommandPacket = [[NSArray alloc] initWithArray:[Command getXMLObjectArray:[Utility checkNullForKey:kIRCommand Dictionary:dictIR]]];
                    }
                    break;
                }
                default:
                    break;
            }

        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}
+(XMLResponse *) getObjectFromDictionaryForMeta:(NSDictionary*)dictResp  {
    XMLResponse *objReturn=[[XMLResponse alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.controlPack = [ControlPack getObjectFromXMLDictionary:[Utility checkNullForKey:kControlPack Dictionary:dictResp]];
            //objReturn.meta = [Meta getObjectFromDictionary:[Utility checkNullForKey:kCPMeta Dictionary:dictResp]];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
     return objReturn;
}
@end
