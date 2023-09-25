//
//  GridDimension.m
//  mHubApp
//
//  Created by Anshul Jain on 07/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "GridDimension.h"

@implementation GridDimension
-(id)init {
    self = [super init];
    @try {
        self.row = 0;
        self.column = 0;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}


+(GridDimension*) initWithRows:(NSInteger)intRow Column:(NSInteger)intColumn {
    GridDimension *objReturn=[[GridDimension alloc] init];
    @try {
        objReturn.row = intRow;
        objReturn.column = intColumn;
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
        [encoder encodeInteger:self.row forKey:kGridRow];
        [encoder encodeInteger:self.column forKey:kGridColumn];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.row    = [decoder decodeIntegerForKey:kGridRow];
            self.column = [decoder decodeIntegerForKey:kGridColumn];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}
@end
