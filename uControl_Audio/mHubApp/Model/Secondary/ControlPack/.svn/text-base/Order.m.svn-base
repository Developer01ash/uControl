//
//  Order.m
//  mHubApp
//
//  Created by Anshul Jain on 20/12/16.
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
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
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
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeInteger:self.type forKey:kCPControlType];
        [encoder encodeInteger:self.order forKey:kCPControlOrder];
        [encoder encodeBool:self.selected forKey:kCPControlSelected];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            @try {
                self.type = [decoder decodeIntegerForKey:kCPControlType];
                self.order = [decoder decodeIntegerForKey:kCPControlOrder];
                self.selected = [decoder decodeBoolForKey:kCPControlSelected];
            } @catch(NSException *exception) {
                self.type = [[decoder decodeObjectForKey:kCPControlType] integerValue];
                self.order = [[decoder decodeObjectForKey:kCPControlOrder] integerValue];
                self.selected = [[decoder decodeObjectForKey:kCPControlSelected] boolValue];
            }
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
