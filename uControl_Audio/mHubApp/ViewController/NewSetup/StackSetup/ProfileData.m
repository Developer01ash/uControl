//
//  ProfileData.m
//  mHubApp
//
//  Created by Rave Digital on 02/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "ProfileData.h"

@implementation ProfileData


-(NSMutableArray *)loadTopSampleData
{
    
    //ProfileData *arrayProfileData;
   NSMutableArray <ProfileData*>*arrayProfileData;

    NSMutableArray *arrayName =     [NSMutableArray arrayWithObjects:@"Hub1", @"Hub2", @"Hub3", @"Hub4", @"Hub5", @"Hub6", @"Hub7", @"Hub8", nil];
    NSMutableArray *arrayAge = [NSMutableArray arrayWithObjects:@"192.168.0.1", @"192.168.0.2", @"192.168.0.3", @"192.168.0.4", @"192.168.0.5", @"192.168.0.6", @"192.168.0.7", @"192.168.0.8", nil];
    NSMutableArray *arrayProfileImage = [NSMutableArray arrayWithObjects:@"icon_1.png", @"icon_2.png", @"icon_3.png", @"icon_4.png", @"icon_5.png", @"icon_6.png", @"icon_7.png", @"icon_8.png",nil];
    arrayProfileData = [[NSMutableArray alloc]init];
    for(int index = 0; index < arrayName.count; index++) {
        ProfileData *objN = [[ProfileData alloc]init];
        objN.name = [arrayName objectAtIndex:index];
        objN.age = [arrayAge objectAtIndex:index];
        objN.profileImageName = [arrayProfileImage objectAtIndex:index];
        [arrayProfileData addObject:objN];
    }
    
    return arrayProfileData;
}

-(NSMutableArray *)loadTopSampleData2
{
    
    //ProfileData *arrayProfileData;
   NSMutableArray <ProfileData*>*arrayProfileData;

    NSMutableArray *arrayName =     [NSMutableArray arrayWithObjects:@"Profile1", @"Profile2", @"Profile3", @"Profile4", @"Profile5", @"Profile6", @"Profile7", @"Profile8", nil];
    NSMutableArray *arrayAge = [NSMutableArray arrayWithObjects:@"age1", @"age2", @"age3", @"age4", @"age5", @"age6", @"age7", @"age8", nil];
    NSMutableArray *arrayProfileImage = [NSMutableArray arrayWithObjects:@"icon_1.png", @"icon_2.png", @"icon_3.png", @"icon_4.png", @"icon_5.png", @"icon_6.png", @"icon_7.png", @"icon_8.png",nil];
    arrayProfileData = [[NSMutableArray alloc]init];
    for(int index = 0; index < arrayName.count; index++) {
        ProfileData *objN = [[ProfileData alloc]init];
        objN.name = [arrayName objectAtIndex:index];
        objN.age = [arrayAge objectAtIndex:index];
        objN.profileImageName = [arrayProfileImage objectAtIndex:index];
        [arrayProfileData addObject:objN];
    }
    
    return arrayProfileData;
}

@end
