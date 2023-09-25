//
//  ContinuityHub.h
//  mHubApp
//
//  Created by Anshul Jain on 28/08/17.
//  Copyright © 2017 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContinuityHub : NSObject
@property(nonatomic) NSInteger OutputCount;
@property(nonatomic) NSInteger InputCount;
@property(nonatomic, retain) NSMutableArray *HubOutputData; // Array of OutputDevice type
@property(nonatomic, retain) NSMutableArray *HubInputData;  // Array of InputDevice type
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *Mac;
@property(nonatomic, retain) NSString *Address;
@property(nonatomic) HubModel Generation;
@property(nonatomic, retain) NSString *modelName;
@property(nonatomic) BOOL BootFlag;
@property(nonatomic, retain) NSString *SerialNo;

@property(nonatomic, assign) float apiVersion;
@property(assign, nonatomic) float mosVersion;
@property(strong, nonatomic) NSString *strMOSVersion;
@property(nonatomic, assign) BOOL AVR_IRPack;
@property(nonatomic, assign) BOOL isPaired;

+(ContinuityHub*) getObjectFromDictionary:(NSDictionary*)dictResp;
-(NSDictionary*) dictionaryRepresentation;
-(BOOL) isAPIV2;
-(BOOL) isDemoMode;
@end
