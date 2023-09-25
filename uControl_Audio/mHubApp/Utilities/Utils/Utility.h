//
//  Utility.h
//  mHubApp
//
//  Created by rave on 9/18/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import "Command.h"

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface Utility : NSObject

+(id)checkNullForKey:(NSString*)key Dictionary:(NSDictionary*)dict;
+(void)saveUserDefaults:(NSString*)key value:(id)value;
+(id)retrieveUserDefaults:(NSString*)key;
+(void)deleteUserDefaults:(NSString*)key;
+(void)deleteAllUserDefaults;
+(UIImage *)imageWithColor:(UIColor *)color Frame:(CGRect)frame;
+(DeviceType) deviceType;
+(DeviceType) deviceTypeByScreenSize;
+(NSString*) deviceNameByCode;
+(BOOL)getBoolValue:(NSString*)value;
+(NSString*)stringToHex:(NSString*)str;
//+(char)integerToCharacter:(NSInteger)intNum;
+(NSString *)integerToCharacter:(NSInteger)intNum;
+(NSInteger)characterToInteger:(NSString*)string;
+(NSDictionary *)getDictionaryFromJSONFile:(NSString *)strFileName;
+(NSDictionary *)getDictionaryFromXMLFile:(NSString *)strFileName;
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(UIImage *)resizeImage:(UIImage *)image;
+(UIImage *)blurredImageWithImage:(UIImage *)sourceImage;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(NSMutableDictionary *)parseDictionary:(NSDictionary *)inDictionary;
+(void)saveImageInDocumentDirectory:(UIImage *)imgBackground SourceIndex:(NSInteger) intSourceIndex;
+(UIImage*)retrieveImageFromDocumentDirectory:(NSInteger)intSourceIndex;
+(void)removeAllImageFromDocumentDirectory;

+(void)saveImageInDocumentDirectory:(UIImage *)imgBackground ZoneId:(NSString*)strZoneId;
+(UIImage*)retrieveImageFromDocumentDirectory_ZoneId:(NSString*)strZoneId;

+(NSMutableArray *)getCountryName;

+ (NSString *)getIPAddress;
+ (NSString *)getMacAddress;
+ (NSInteger)getRamdomNumber;

+(NSString *)createJSONFor_inputSwitch:(NSString *)outputobj input:(NSString *)inputObj;
+(NSString *)createJSONFor_zoneSwitch:(NSString *)idObj input:(NSString *)inputObj;

+(NSString *)createJSONFor_IRCommand:(NSString *)portObj ID:(NSString *)idObj TouchType:(TouchActivity)objTouchType;
+(NSString *)createJSONFor_CECCommand_port:(NSString *)portObj type:(NSString *)typeObj ID:(NSString *)idObj;

+(NSString *)createJSONFor_VolumeControl:(NSString *)outputIDObj Level:(NSString *)levelObj;
+(NSString *)createJSONFor_VolumeControl_Zone:(NSString *)zoneIDObj Level:(NSString *)levelObj;

+(NSString *)createJSONFor_SyncZone:(NSString *)idObj;
+(NSString *)createJSONFor_ARC:(NSString *)portObj type:(NSString *)typeObj State:(NSString *)stateObj;

+(NSString *)createJSONFor_MuteZone:(NSString *)zoneIdObj State:(NSString *)stateObj;
+(NSString *)createJSONFor_Mute_output:(NSString *)idObj State:(NSString *)stateObj;


@end
