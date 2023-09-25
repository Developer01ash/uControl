//
//  ControlPack.m
//  mHubApp
//
//  Created by Yashica Agrawal on 24/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "ControlPack.h"

@implementation ControlPack
+(ControlPack*) getObjectFromDictionary:(NSDictionary*)dictResp {
    ControlPack *objReturn=[[ControlPack alloc] init];
    @try {
        if ([dictResp isKindOfClass:[NSDictionary class]]) {
            objReturn.name = [Utility checkNullForKey:kCPName Dictionary:dictResp];

            objReturn.ir = [[NSMutableArray alloc] initWithArray:[IRCommand getObjectArray:[Utility checkNullForKey:kCPIR Dictionary:dictResp]]];
            
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
                objReturn.continuity = [[NSMutableArray alloc] initWithArray:[ContinuityCommand getObjectArray:[Utility checkNullForKey:kCPContinuity Dictionary:dictResp] IRCommands:objReturn.ir]];
            }
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return objReturn;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:self.name forKey:kCPName];
//        [encoder encodeObject:self.meta forKey:kCPMeta];
//        [encoder encodeObject:self.downloadTest forKey:kCPDownloadTest];
//        [encoder encodeObject:self.grid forKey:kCPGrid];

        [encoder encodeObject:self.ir forKey:kCPIR];
        [encoder encodeObject:self.appUI forKey:kCPAppUI];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
                //decode properties, other class vars
            self.name = [decoder decodeObjectForKey:kCPName];
            
//            self.meta = [decoder decodeObjectForKey:kCPMeta];
//            self.downloadTest = [decoder decodeObjectForKey:kCPDownloadTest];
//            self.grid = [decoder decodeObjectForKey:kCPGrid];

            self.ir= [decoder decodeObjectForKey:kCPIR];
            self.appUI = [decoder decodeObjectForKey:kCPAppUI];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

@end
