//
//  SizeUI.m
//  mHubApp
//
//  Created by Yashica Agrawal on 03/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "SizeUI.h"

@implementation SizeUI

-(id)init {
    self = [super init];
    @try {
        self.sizeWidth = 0;
        self.sizeHeight = 0;
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}


+(SizeUI*) initWithWidth:(NSString*)strWidth Height:(NSString *)strHeight {
    SizeUI *objReturn=[[SizeUI alloc] init];
    @try {
        if ([strWidth isNotEmpty] && [strWidth isKindOfClass:[NSString class]]) {
            objReturn.sizeWidth = [strWidth integerValue];
        }
        if ([strHeight isNotEmpty] && [strHeight isKindOfClass:[NSString class]]) {
            objReturn.sizeHeight = [strHeight integerValue];
        } else if ([strWidth isNotEmpty] && [strWidth isKindOfClass:[NSString class]]) {
            objReturn.sizeHeight = [strWidth integerValue];
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
        [encoder encodeObject:[NSNumber numberWithInteger:self.sizeWidth] forKey:kCommandXMLSizeWidth];
        [encoder encodeObject:[NSNumber numberWithInteger:self.sizeHeight] forKey:kCommandXMLSizeHeight];
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
                //decode properties, other class vars
            self.sizeWidth = [[decoder decodeObjectForKey:kCommandXMLSizeWidth] integerValue];
            self.sizeHeight = [[decoder decodeObjectForKey:kCommandXMLSizeHeight] integerValue];
        }
    }
    @catch(NSException *exception) {
        DDLogError(EXCEPTIONLOG, __PRETTY_FUNCTION__, [exception description]);
    }
    return self;
}
@end
