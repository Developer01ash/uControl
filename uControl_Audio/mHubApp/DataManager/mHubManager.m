//
//  mHubManager.m
//  mHubApp
//
//  Created by Yashica Agrawal on 26/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "mHubManager.h"

@implementation mHubManager
@synthesize objSelectedHub, objSelectedOutputDevice, objSelectedInputDevice;

+ (instancetype)sharedInstance {
    static mHubManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[mHubManager alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    self.objSelectedHub = [[Hub alloc]init];
//    self.isForwardCommand = false;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
            //Encode properties, other class variables, etc
        [encoder encodeObject:self.objSelectedHub forKey:kSELECTEDHUBMODEL];
        [encoder encodeObject:self.objSelectedInputDevice forKey:kSELECTEDINPUTDEVICE];
        [encoder encodeObject:self.objSelectedOutputDevice forKey:kSELECTEDOUTPUTDEVICE];
//        [encoder encodeObject:[NSNumber numberWithBool:self.isForwardCommand] forKey:kISFORWARDCOMMAND];
    }
    @catch(NSException *exception) {
        NSLog(@"Exception from encodeWithCoder at mHubManager : %@", [exception description]);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if((self = [super init])) {
                //decode properties, other class vars
            self.objSelectedHub= [decoder decodeObjectForKey:kSELECTEDHUBMODEL];
            self.objSelectedInputDevice = [decoder decodeObjectForKey:kSELECTEDINPUTDEVICE];
            self.objSelectedOutputDevice = [decoder decodeObjectForKey:kSELECTEDOUTPUTDEVICE];
//            self.isForwardCommand = [[decoder decodeObjectForKey:kISFORWARDCOMMAND]boolValue];
        }
    }
    @catch(NSException *exception) {
        NSLog(@"Exception from initWithCoder at mHubManager : %@", [exception description]);
    }
    return self;
}

+ (void)saveCustomObject:(mHubManager *)object key:(NSString *)key {
    @try {
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedObject forKey:key];
        [defaults synchronize];
    }
    @catch(NSException *exception) {
        NSLog(@"Exception from saveCustomObject at mHubManager : %@", [exception description]);
    }
    
}

+ (mHubManager *)loadCustomObjectWithKey:(NSString *)key {
    @try {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedObject = [defaults objectForKey:key];
        mHubManager *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        return object;
    }
    @catch(NSException *exception) {
        NSLog(@"Exception from loadCustomObjectWithKey at mHubManager : %@", [exception description]);
    }
}

@end
