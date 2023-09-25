//
//  CellGroupAudio.h
//  mHubApp
//
//  Created by Anshul Jain on 29/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellGroupAudio;

@protocol CellGroupAudioDelegate <NSObject>
- (void)didReceivedTapOnCellDeleteButton:(CellGroupAudio *)sender;

@end

@interface CellGroupAudio : UITableViewCell <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet CustomButton *btnCellDelete;
@property (weak, nonatomic) IBOutlet UIView *viewContentBG;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraintViewContentBG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraintViewContentBG;
@property (nonatomic, weak) id <CellGroupAudioDelegate> delegate;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, retain) NSIndexPath *cellIndexPath;

- (void)openCell;
- (IBAction)btnCellDelete_Clicked:(CustomButton *)sender;

@end
