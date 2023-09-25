//
//  Grid.h
//  mHubApp
//
//  Created by Yashica Agrawal on 07/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject
@property(nonatomic, retain) GridDimension *mobileSmall;
@property(nonatomic, retain) GridDimension *mobileLarge;
@property(nonatomic, retain) GridDimension *tabletSmall;
@property(nonatomic, retain) GridDimension *tabletLarge;
@property(nonatomic, retain) GridDimension *tabletLargeLandscape;

+(Grid*) initWithGrid;

@end
