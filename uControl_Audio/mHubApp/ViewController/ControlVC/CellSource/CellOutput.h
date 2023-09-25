//
//  CellOutput.h
//  mHubApp
//
//  Created by Anshul Jain on 22/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellOutput;

@protocol CellOutputDelegate <NSObject>
@optional
- (void)didReceivedTapOnCellDeleteButton:(CellOutput *)sender;
@end

@interface CellOutput : UITableViewCell {
    id <CellOutputDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
@property (weak, nonatomic) NSIndexPath *indexPathCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgConnected;
@property (weak, nonatomic) IBOutlet UIButton *btnCellDelete;
- (IBAction)btnCellDelete_Clicked:(id)sender;

@end

