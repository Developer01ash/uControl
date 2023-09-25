//
//  ControlPack.m
//  mHubApp
//
//  Created by Anshul Jain on 24/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ControlPack.h"

@implementation ControlPack
+(ControlPack*) getObjectFromDictionary:(NSDictionary*)dictResp {
    ControlPack *objReturn=[[ControlPack alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.name = [Utility checkNullForKey:kCPName Dictionary:dictResp];

            objReturn.ir = [[NSMutableArray alloc] initWithArray:[IRCommand getObjectArray:[Utility checkNullForKey:kCPIRPACK Dictionary:dictResp]]];
            
            if ([[Utility checkNullForKey:kCPAppUI Dictionary:dictResp] isNotEmpty]) {
                objReturn.appUI = [[NSMutableArray alloc] initWithArray:[ControlGroup getObjectArray:[Utility checkNullForKey:kCPControlGroup Dictionary:[Utility checkNullForKey:kCPAppUI Dictionary:dictResp]] IRCommands:objReturn.ir]];
            } else {
                objReturn.appUI = [[NSMutableArray alloc] init];
            }
            
            for (ControlGroup *objCP in objReturn.appUI) {
                if (objCP.type == GestureKey) {
                    BOOL isVisible = false;
                    switch ([AppDelegate appDelegate].deviceType) {
                        case mobileSmall:   isVisible = objCP.visibility.mobileSmall;   break;
                        case mobileLarge:   isVisible = objCP.visibility.mobileLarge;   break;
                        case tabletSmall:   isVisible = objCP.visibility.tabletSmall;   break;
                        case tabletLarge:   isVisible = objCP.visibility.tabletLarge;   break;
                        default:    break;
                    }
                    if (isVisible == true) {
                        [objReturn.appUI addObject:[ControlGroup getObjectForGestureView_IRCommands:objReturn.ir]];
                    }
                    break;
                }
            }
            
            ControlGroup *objPower = [ControlGroup getObjectForPowerButton_IRCommands:objReturn.ir];
            if (objPower.arrUIElements.count > 0 && objReturn.appUI.count > 0) {
                [objReturn.appUI addObject:objPower];
            }
            
            if ([[Utility checkNullForKey:kCPContinuity Dictionary:dictResp] isNotEmpty]) {
                id continuity = [Utility checkNullForKey:kCPContinuity Dictionary:dictResp];
                if ([continuity isKindOfClass:[NSString class]]) {
                    objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuity Dictionary:dictResp] IRCommands:objReturn.ir]];
                } else if ([continuity isKindOfClass:[NSDictionary class]]) {
                    switch ([AppDelegate appDelegate].deviceType) {
                        case mobileSmall:   {
                            objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuityS Dictionary:continuity] IRCommands:objReturn.ir]];
                           break;
                        }
                        case mobileLarge: {
                            objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuityM Dictionary:continuity] IRCommands:objReturn.ir]];
                            break;
                    }
                        case tabletSmall: {
                            objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuityM Dictionary:continuity] IRCommands:objReturn.ir]];
                            break;
                        }
                        case tabletLarge:   {
                            objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuityL Dictionary:continuity] IRCommands:objReturn.ir]];
                            break;
                        }
                        default:    break;
                    }

                }
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(ControlPack*) getObjectFromXMLDictionary:(NSDictionary*)dictResp {
    ControlPack *objReturn=[[ControlPack alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.meta = [Meta getObjectFromDictionary:[Utility checkNullForKey:kCPMeta Dictionary:dictResp]];
            objReturn.name = objReturn.meta.name;

            NSDictionary *dictIR = [Utility checkNullForKey:kCPIR Dictionary:dictResp];

            if ([dictIR isNotEmpty] && [dictIR isKindOfClass:[NSDictionary class]]) {
                objReturn.ir = [[NSMutableArray alloc] initWithArray:[IRCommand getXMLObjectArray:[Utility checkNullForKey:kIRCommand Dictionary:dictIR]]];
            } else {
                objReturn.ir = [[NSMutableArray alloc] init];
            }

            if ([[Utility checkNullForKey:kCPAppUIXML Dictionary:dictResp] isNotEmpty]) {
                objReturn.appUI = [[NSMutableArray alloc] initWithArray:[ControlGroup getObjectArray:[Utility checkNullForKey:kCPControlGroup Dictionary:[Utility checkNullForKey:kCPAppUIXML Dictionary:dictResp]] IRCommands:objReturn.ir]];
            } else {
                objReturn.appUI = [[NSMutableArray alloc] init];
            }

            for (ControlGroup *objCP in objReturn.appUI) {
                if (objCP.type == GestureKey) {
                    BOOL isVisible = false;
                    switch ([AppDelegate appDelegate].deviceType) {
                        case mobileSmall:   isVisible = objCP.visibility.mobileSmall;   break;
                        case mobileLarge:   isVisible = objCP.visibility.mobileLarge;   break;
                        case tabletSmall:   isVisible = objCP.visibility.tabletSmall;   break;
                        case tabletLarge:   isVisible = objCP.visibility.tabletLarge;   break;
                        default:    break;
                    }
                    if (isVisible == true) {
                        [objReturn.appUI addObject:[ControlGroup getObjectForGestureView_IRCommands:objReturn.ir]];
                    }
                    break;
                }
            }

            ControlGroup *objPower = [ControlGroup getObjectForPowerButton_IRCommands:objReturn.ir];
            if (objPower.arrUIElements.count > 0 && objReturn.appUI.count > 0) {
                [objReturn.appUI addObject:objPower];
            }

            if ([[Utility checkNullForKey:kCPContinuity Dictionary:dictResp] isNotEmpty]) {
                id continuity = [Utility checkNullForKey:kCPContinuity Dictionary:dictResp];
                if ([continuity isKindOfClass:[NSString class]]) {
                    objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuity Dictionary:dictResp] IRCommands:objReturn.ir]];
                } else if ([continuity isKindOfClass:[NSDictionary class]]) {
                    switch ([AppDelegate appDelegate].deviceType) {
                        case mobileSmall:   {
                            objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuityS Dictionary:continuity] IRCommands:objReturn.ir]];
                            break;
                        }
                        case mobileLarge: {
                            objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuityM Dictionary:continuity] IRCommands:objReturn.ir]];
                            break;
                        }
                        case tabletSmall: {
                            objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuityM Dictionary:continuity] IRCommands:objReturn.ir]];
                            break;
                        }
                        case tabletLarge:   {
                            objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuityL Dictionary:continuity] IRCommands:objReturn.ir]];
                            break;
                        }
                        default:    break;
                    }

                }
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:self.name forKey:kCPName];
        [encoder encodeObject:self.meta forKey:kCPMeta];
//        [encoder encodeObject:self.downloadTest forKey:kCPDownloadTest];
//        [encoder encodeObject:self.grid forKey:kCPGrid];

        [encoder encodeObject:self.ir forKey:kCPIRPACK];
        [encoder encodeObject:self.appUI forKey:kCPAppUI];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.name = [decoder decodeObjectForKey:kCPName];
            self.meta = [decoder decodeObjectForKey:kCPMeta];
//            self.downloadTest = [decoder decodeObjectForKey:kCPDownloadTest];
//            self.grid = [decoder decodeObjectForKey:kCPGrid];
            self.ir= [decoder decodeObjectForKey:kCPIRPACK];
            self.appUI = [decoder decodeObjectForKey:kCPAppUI];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
