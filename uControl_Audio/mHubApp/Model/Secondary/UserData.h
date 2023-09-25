//
//  UserData.h
//  mHubApp
//
//  Created by Anshul Jain on 06/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserDataValue  @"strValue"
#define kUserDataKey    @"strKey"
#define kUserDataPlaceholder    @"strPlaceholder"
#define kUserDataTag    @"userTag"

#define kAccountType    @"account_type"
#define kUsername       @"user_name"
#define kPassword       @"password"
#define kSerial_Number  @"serial_no"
#define kMHubType       @"mhubType"
#define kMhubImage      @"mhubImage"
#define kFirstName      @"firstName"
#define kSecondName     @"secondName"
#define kCalledCountry  @"calledCountry"
#define kTelephone      @"telephone"
#define kDateOfPurchase @"dateOfPurchase"
#define kWherePurchased @"wherePurchased"

#define kUserData       @"user_data"
#define kData           @"data"

typedef NS_ENUM(NSUInteger, UserTag)
{
    EmailId         = 0,
    Password        ,
    SerialNo        ,
    MHubType        ,
    MHubImage       ,
    FirstName       ,
    SecondName      ,
    CalledCountry   ,
    Telephone       ,
    DateOfPurchase  ,
    PurchasedWhere  ,
};

@interface UserData : NSObject
@property(nonatomic, retain) NSString *strKey;
@property(nonatomic, retain) NSString *strValue;
@property(nonatomic, retain) NSString *strPlaceholder;
@property(nonatomic) UserTag userTag;

+(UserData*) initWithValue:(NSString*)strValue Key:(NSString*)strKey Placeholder:(NSString*)strPlaceholder Tag:(UserTag)userTag;
-(NSDictionary*) dictionaryRepresentation;
+(NSMutableArray*) getCloudLoginArray;
+(NSMutableArray*) getCloudRegistrationArray;
+(NSDictionary*) getRegistrationParameterDictionary:(NSArray *)arrData;
+(NSDictionary*) getParameterDictionary:(NSArray *)arrData;
+(NSDictionary*) getParameterDictionaryFromDictionary:(NSDictionary *)dictData;

@end
