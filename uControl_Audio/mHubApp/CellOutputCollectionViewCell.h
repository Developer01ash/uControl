//
//  CellOutputCollectionViewCell.h
//  mHubApp
//
//  Created by Apple on 16/02/21.
//  Copyright © 2021 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class CellOutputCollectionViewCell;

@protocol CellOutputCollectionViewCellDelegate <NSObject>
@optional
- (void)didReceivedTapOnCellDeleteButton:(CellOutputCollectionViewCell *)sender;
@end

@interface CellOutputCollectionViewCell : UICollectionViewCell {
    id <CellOutputCollectionViewCellDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
@property (weak, nonatomic) NSIndexPath *indexPathCell;
@property (weak, nonatomic) NSTimer *seqTimer;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgConnected;
@property (weak, nonatomic) IBOutlet UIButton *btnCellDelete;
@property (weak, nonatomic) IBOutlet UIProgressView *sequenceProgress_byTime;
- (IBAction)btnCellDelete_Clicked:(id)sender;

@end
NS_ASSUME_NONNULL_END
