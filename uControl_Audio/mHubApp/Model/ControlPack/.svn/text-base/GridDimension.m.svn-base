//
//  GridDimension.m
//  mHubApp
//
//  Created by Yashica Agrawal on 07/11/16.
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
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
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
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return objReturn;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:[NSNumber numberWithInteger:self.row] forKey:kGridRow];
        [encoder encodeObject:[NSNumber numberWithInteger:self.column] forKey:kGridColumn];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
                //decode properties, other class vars
            self.row = [[decoder decodeObjectForKey:kGridRow] integerValue];
            self.column = [[decoder decodeObjectForKey:kGridColumn] integerValue];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}
@end
