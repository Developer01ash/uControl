//
//  SizeUI.m
//  mHubApp
//
//  Created by Anshul Jain on 03/11/16.
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
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
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
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeInteger:self.sizeWidth forKey:kCommandXMLSizeWidth];
        [encoder encodeInteger:self.sizeHeight forKey:kCommandXMLSizeHeight];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
                //decode properties, other class vars
            self.sizeWidth  = [decoder decodeIntegerForKey:kCommandXMLSizeWidth];
            self.sizeHeight = [decoder decodeIntegerForKey:kCommandXMLSizeHeight];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}
@end
