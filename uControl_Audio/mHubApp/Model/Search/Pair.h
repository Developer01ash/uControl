//
//  Pair.h
//  mHubApp
//
//  Created by Anshul Jain on 06/04/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

/*
 PairDetail Object consist of pairing properties like UnitId, IP Address and SerialNo.

 Pair is another class available in this file which consist of Master and Array of Slave devices whose object type is PairDetail.
 */

#import <Foundation/Foundation.h>

@interface PairDetail : NSObject
@property(nonatomic, retain) NSString *unit_id;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *product_code;

@property(nonatomic, retain) NSString *ip_address;
@property(nonatomic, retain) NSString *serial_number;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) BOOL is_video;
@end

@interface Pair : NSObject
@property(nonatomic, retain) PairDetail *master;
@property(nonatomic, retain) NSMutableArray <PairDetail*>*arrSlave;

-(id)initWithPair:(Pair *)pairData;
+(Pair*) getObjectFromDictionary:(NSDictionary*)dictResp;
-(NSDictionary*) dictionaryRepresentation;
-(NSDictionary*) dictionaryJSONRepresentation;
-(BOOL) isPairEmpty;
+(void) deviceAvailableInPair:(Pair*)objPairingDetail SerialNo:(NSString*)strSerialNo completion:(void (^)(BOOL isMaster, BOOL isSlave))handler;
+(Pair*) getPairObjectFromMHUBObject:(Hub*)objMasterHub SlaveHub:(NSMutableArray*)arrSlaveMHUB;
@end
