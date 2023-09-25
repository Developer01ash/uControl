//
//  NSObject+Validation.m
//  mHubApp
//
//  Created by Anshul Jain on 22/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "NSObject+Validation.h"

@implementation NSObject (Validation)

-(BOOL) isNotEmpty {
    /*----------*/
    /*Created By : Anshul Jain*/
    /*Date : 24-11-2014 */
    /*description : Method for Check Empty Object. */
    /*Update by :  */
    /*Reason : */
    /*----------*/
    
    return !(self == nil
             || [self isKindOfClass:[NSNull class]]
             || ([self respondsToSelector:@selector(length)]
                 && [(NSString *)self length] == 0)
             || ([self respondsToSelector:@selector(length)]
                 && [(NSData *)self length] == 0)
             || ([self respondsToSelector:@selector(count)]
                 && [(NSArray *)self count] == 0));
}

-(BOOL) isIPAddressEmpty {
    /*----------*/
    /*Created By : Anshul Jain*/
    /*Date : 24-11-2014 */
    /*description : Method for Check Empty Object. */
    /*Update by :  */
    /*Reason : */
    /*----------*/
    
    return (![(NSString*)self isNotEmpty] || [(NSString*)self isKindOfClass:[NSNull class]] || (NSString*)self == nil || (NSString*)self == NULL || [(NSString*)self isEqualToString:@"(null)"] || [(NSString*)self isEqualToString:UNKNOWN_IP] || [(NSString*)self isEqualToString:@""]);
}

-(BOOL) isValidNumeric {
    /*----------*/
    /*Created By : Anshul Jain*/
    /*Date : 31-12-2014 */
    /*description : Method for Check valid Numeric Value. */
    /*Update by :  */
    /*Reason : */
    /*----------*/
    
    //1. Empty
    if (![self isNotEmpty])
        return NO;
    
    //2. White Space and Line Changes
    if ([[(NSString*)self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] count] > 1)
        return NO;
    
    NSInteger holder;
    NSScanner *scanner = [NSScanner scannerWithString:(NSString*)self];
    return [scanner scanInteger:&holder] && [scanner isAtEnd];
}

// Referrence : https://github.com/SelfControlApp/selfcontrol/blob/master/NSString%2BIPAddress.m

- (BOOL)isValidIPv4Address {
    struct in_addr throwaway;
    int success = inet_pton(AF_INET, [(NSString*)self UTF8String], &throwaway);
    
    return (success == 1);
}

- (BOOL)isValidIPv6Address {
    struct in6_addr throwaway;
    int success = inet_pton(AF_INET6, [(NSString*)self UTF8String], &throwaway);
    
    return (success == 1);
}

- (BOOL)isValidIPAddress {
    return ([self isValidIPv4Address] || [self isValidIPv6Address]);
}

-(BOOL) isValidEmail{
    /*----------*/
    /*Created By : Anshul Jain*/
    /*Date : 24-11-2014 */
    /*description : Method for Check valid Email. */
    /*Update by :  */
    /*Reason : */
    /*----------*/
    
    //1. Empty
    if (![self isNotEmpty])
        return NO;
    
    //2. White Space and Line Changes
    if ([[(NSString*)self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] count] > 1)
        return NO;
    
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailText evaluateWithObject:self];
}

-(BOOL) isValidPassword {
    
    /*----------*/
    /*Created By : Anshul Jain*/
    /*Date : 24-11-2014 */
    /*description : Method for Check valid password. */
    /*Update by :  */
    /*Reason : */
    /*----------*/
    
    // 1. Empty
    if (![self isNotEmpty])
        return NO;
    
    // 2. Upper case.
    //    if (![[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[(NSString*)self characterAtIndex:0]])
    //        return NO;
    
//    // 3. Length.
//    if ([(NSString*)self length] < 6)
//        return NO;
    
    // 4. Special characters.
    // Change the specialCharacters string to whatever matches your requirements.
    //    NSString *specialCharacters = @"!#€%&/()[]=?$§*'";
    //    if ([[(NSString*)self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:specialCharacters]] count] < 2)
    //        return NO;
    
    // 5. Numbers.
    //    if ([[(NSString*)self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]] count] < 2)
    //        return NO;
    
    // 6. White Space and Line Changes
    if ([[(NSString*)self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] count] > 1)
        return NO;
    
    return YES;
}

-(BOOL) isMatchConfirmPassword:(NSString*)password {
    /*----------*/
    /*Created By : Anshul Jain*/
    /*Date : 31-12-2014 */
    /*description : Method for Check matching passwords +. */
    /*Update by :  */
    /*Reason : */
    /*----------*/
    
    //1. Empty
    if (![self isNotEmpty])
        return NO;
    
    //2. White Space and Line Changes
    if ([[(NSString*)self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] count] > 1)
        return NO;
    
    return [password isEqualToString:(NSString*)self];
}

-(NSString *) getTrimmedString {
    return [(NSString*)self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(BOOL) isValidPhoneNumber {
    /*----------*/
    /*Created By : Anshul Jain*/
    /*Date : 31-12-2014 */
    /*description : Method for Check valid Phone number starts with +. */
    /*Update by :  */
    /*Reason : */
    /*----------*/
    
        //1. Empty
    if (![self isNotEmpty])
        return NO;
    
        //2. White Space and Line Changes
    if ([[(NSString*)self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] count] > 1)
        return NO;
    
    if ([(NSString*)self length] < 10)
        return NO;
    
        //NSString *phoneRegex = @"^\\+[1-9]{1}[0-9]{7,11}$";
    NSString *phoneRegex = @"^+(?:[0-9] ?){6,14}[0-9]$";
    NSPredicate *phoneText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneText evaluateWithObject:self];
}

-(BOOL) isContainString:(NSString*)string {
    /*----------*/
    /*Created By : Anshul Jain*/
    /*Date : 31-12-2014 */
    /*description : Method for Check matching passwords +. */
    /*Update by :  */
    /*Reason : */
    /*----------*/
    
    //1. Empty
    if (![self isNotEmpty])
        return NO;
    
    NSString *strToMatch = [(NSString*)self uppercaseString];
    NSString *strFromMatch = [string uppercaseString];
    return ([strFromMatch isEqualToString:strToMatch]
            || [strToMatch isEqualToString:strFromMatch]
            || [strFromMatch containsString:strToMatch]
            || [strToMatch containsString:strFromMatch]);
}

@end
