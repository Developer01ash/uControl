//
//  CellEnterIPAddressContainer.h
//  mHubApp
//
//  Created by Anshul Jain on 20/06/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManuallyIPAddressContainerVC.h"
@class CellEnterIPAddressContainer;

NS_ASSUME_NONNULL_BEGIN

@protocol CellEnterIPAddressContainerDelegate <NSObject>
@optional
- (void) animateView:(BOOL)isUp;
- (void) setIPAddress:(CellEnterIPAddressContainer*)sender Address:(NSString*)strAddress;
@end

@interface CellEnterIPAddressContainer : UITableViewCell <UITextFieldDelegate> {
    id <CellEnterIPAddressContainerDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
@property (nonatomic, retain) NSIndexPath *cellIndexPath;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UITextField *cellTxtIPPart1;
@property (weak, nonatomic) IBOutlet UITextField *cellTxtIPPart2;
@property (weak, nonatomic) IBOutlet UITextField *cellTxtIPPart3;
@property (weak, nonatomic) IBOutlet UITextField *cellTxtIPPart4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCellView;

@end

NS_ASSUME_NONNULL_END
