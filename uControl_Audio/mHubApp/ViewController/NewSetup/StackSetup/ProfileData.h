//
//  ProfileData.h
//  mHubApp
//
//  Created by Rave Digital on 02/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileData : NSObject
{

}
@property(nonatomic, retain) NSString *profileImageName ;
@property(nonatomic, retain)  NSString *name;
@property(nonatomic, retain)NSString *age ;
-(NSMutableArray *)loadTopSampleData;
-(NSMutableArray *)loadTopSampleData2;
@end

NS_ASSUME_NONNULL_END
