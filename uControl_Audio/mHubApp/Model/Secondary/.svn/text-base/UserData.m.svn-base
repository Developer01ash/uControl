//
//  UserData.m
//  mHubApp
//
//  Created by Anshul Jain on 06/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "UserData.h"

@implementation UserData

+(UserData*) initWithValue:(NSString*)strValue Key:(NSString*)strKey Placeholder:(NSString*)strPlaceholder Tag:(UserTag)userTag {
    UserData *objReturn = [[UserData alloc] init];
    @try {
        objReturn.strKey = strKey;
        objReturn.strValue = strValue;
        objReturn.strPlaceholder = strPlaceholder;
        objReturn.userTag = userTag;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(NSMutableArray*) getCloudLoginArray {
    @try {
        
        NSMutableArray *arrData = [[NSMutableArray alloc] init];
        
            //  [arrData addObject:[UserData initWithValue:[self.arrPickerData objectAtIndex:intSelectedAccountType] Key:kAccountType Placeholder:@"" Tag:AccountType]];
        [arrData addObject:[UserData initWithValue:@"" Key:kUsername Placeholder:@"EMAIL ADDRESS" Tag:EmailId]];
        [arrData addObject:[UserData initWithValue:@"" Key:kPassword Placeholder:@"PASSWORD" Tag:Password]];
            //  [arrData addObject:[UserData initWithValue:mHubManagerInstance.objSelectedHub.SerialNo Key:kSerial_Number Placeholder:@"Serial Number" Tag:SerialNo]];
        
        return arrData;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getCloudRegistrationArray {
    @try {
        
        NSMutableArray *arrData = [[NSMutableArray alloc] init];
        
        [arrData addObject:[UserData initWithValue:@"" Key:kUsername Placeholder:@"ADD EMAIL ADDRESS" Tag:EmailId]];
        [arrData addObject:[UserData initWithValue:@"" Key:kPassword Placeholder:@"PASSWORD" Tag:Password]];
        [arrData addObject:[UserData initWithValue:[NSString stringWithFormat:@"%@-XXXXXXXXXXXX", mHubManagerInstance.objSelectedHub.Name] Key:kSerial_Number Placeholder:@"MHUB CHASIS SERIAL NUMBER" Tag:SerialNo]];
        [arrData addObject:[UserData initWithValue:mHubManagerInstance.objSelectedHub.Name Key:kMHubType Placeholder:@"MHUB TYPE" Tag:MHubType]];
        [arrData addObject:[UserData initWithValue:@"" Key:kMhubImage Placeholder:[NSString stringWithFormat:@"%ld", (long)mHubManagerInstance.objSelectedHub.InputCount] Tag:MHubImage]];
        [arrData addObject:[UserData initWithValue:@"" Key:kFirstName Placeholder:@"FIRST NAME" Tag:FirstName]];
        [arrData addObject:[UserData initWithValue:@"" Key:kSecondName Placeholder:@"SECOND NAME" Tag:SecondName]];
        [arrData addObject:[UserData initWithValue:@"" Key:kCalledCountry Placeholder:@"CALLED COUNTRY" Tag:CalledCountry]];
        [arrData addObject:[UserData initWithValue:@"" Key:kTelephone Placeholder:@"TELEPHONE" Tag:Telephone]];
        [arrData addObject:[UserData initWithValue:@"" Key:kDateOfPurchase Placeholder:@"DATE OF PURCHASE" Tag:DateOfPurchase]];
        [arrData addObject:[UserData initWithValue:@"" Key:kWherePurchased Placeholder:@"PURCHASED WHERE" Tag:PurchasedWhere]];

        return arrData;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(NSDictionary*) dictionaryRepresentation {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.strKey forKey:kUserDataKey];
        [dict setValue:self.strValue forKey:kUserDataValue];
        [dict setValue:self.strPlaceholder forKey:kUserDataPlaceholder];
        [dict setValue:[NSNumber numberWithInteger:self.userTag] forKey:kUserDataTag];
        
        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSDictionary*) getRegistrationParameterDictionary:(NSArray *)arrData {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        for (UserData *objData in arrData) {
            switch (objData.userTag) {
                case EmailId: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                case Password: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                case SerialNo: {
                    NSString * strNew = objData.strValue;
                    strNew = [strNew stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    [dict setObject:[strNew uppercaseString] forKey:objData.strKey];
                    break;
                }
                case MHubType: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                case FirstName: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                case SecondName: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                case CalledCountry: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                case Telephone: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                case DateOfPurchase: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                case PurchasedWhere: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                default:
                    break;
            }
        }
        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSDictionary*) getParameterDictionary:(NSArray *)arrData {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        for (UserData *objData in arrData) {
            switch (objData.userTag) {
                case EmailId: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                case Password: {
                    [dict setObject:objData.strValue forKey:objData.strKey];
                    break;
                }
                case SerialNo: {
                    NSString * strNew = objData.strValue;
                    strNew = [strNew stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    [dict setObject:[strNew uppercaseString] forKey:objData.strKey];
                    break;
                }
                default:
                    break;
            }
        }
        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSDictionary*) getParameterDictionaryFromDictionary:(NSDictionary *)dictData {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        NSArray *arrKey = [dictData allKeys];
        for (NSString *key in arrKey) {
            if ([key isEqualToString:kUsername] || [key isEqualToString:kPassword]) {
                [dict setValue:[dictData valueForKey:key] forKey:key];
            }
    }
        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeObject:self.strKey forKey:kUserDataKey];
        [encoder encodeObject:self.strValue forKey:kUserDataValue];
        [encoder encodeObject:self.strPlaceholder forKey:kUserDataPlaceholder];
        [encoder encodeInteger:self.userTag forKey:kUserDataTag];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            self.strKey         = [decoder decodeObjectForKey:kUserDataKey];
            self.strValue       = [decoder decodeObjectForKey:kUserDataValue];
            self.strPlaceholder = [decoder decodeObjectForKey:kUserDataPlaceholder];
            self.userTag        = (UserTag)[decoder decodeIntegerForKey:kUserDataTag];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}
@end

