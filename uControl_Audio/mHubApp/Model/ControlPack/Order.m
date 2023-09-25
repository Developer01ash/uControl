//
//  Order.m
//  mHubApp
//
//  Created by Yashica Agrawal on 20/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "Order.h"

@implementation Order
-(id)init {
    self = [super init];
    @try {
        self.type = ControlNone;
        self.order = 0;
        self.selected = false;
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}


+(Order*) initWithType:(ControlGroupType)cgType Order:(NSInteger)intOrder {
    Order *objReturn = [[Order alloc] init];
    @try {
        objReturn.type = cgType;
        objReturn.order = intOrder;
        objReturn.selected = false;
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return objReturn;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:kCPControlType];
        [encoder encodeObject:[NSNumber numberWithInteger:self.order] forKey:kCPControlOrder];
        [encoder encodeObject:[NSNumber numberWithBool:self.selected] forKey:kCPControlSelected];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
            //decode properties, other class vars
            self.type = [[decoder decodeObjectForKey:kCPControlType] integerValue];
            self.order = [[decoder decodeObjectForKey:kCPControlOrder] integerValue];
            self.selected = [[decoder decodeObjectForKey:kCPControlSelected] boolValue];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}

@end
