//
//  TableViewRowController.h
//  mHubApp
//
//  Created by Apple on 04/05/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//
#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewRowController : NSObject

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *lbl_sequenceName;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *rowGroup;


- (void)setContent:(id)object;


@end

NS_ASSUME_NONNULL_END
