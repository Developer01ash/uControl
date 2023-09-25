//
//  BenchMarkData.h
//  mHubApp
//
//  Created by Rave on 06/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN






@interface BenchMarkData : NSObject

    @property(nonatomic, retain) NSString *str_IOSApp_Version;
    @property(nonatomic, retain) NSString *str_AndroidApp_Version;
    @property(nonatomic, retain) NSString *str_ProductModel_Type;
    @property(nonatomic, retain) NSString *str_Mhub_Version;
    //@property(nonatomic, assign) CGFloat sectionHeight;



@end

@interface BenchMarkDetails : NSObject
@property(nonatomic, retain) BenchMarkData *master;
@property(nonatomic, retain) NSMutableArray <BenchMarkData*>*arrSlave;
@end

NS_ASSUME_NONNULL_END
