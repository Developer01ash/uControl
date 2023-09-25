//
//  CellGroupVolume.h
//  mHubApp
//
//  Created by Anshul Jain on 08/01/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellGroupVolume;

@protocol CellGroupVolumeDelegate <NSObject>
@optional
- (void)didReceivedTapOnCellGroupImageButton:(CellGroupVolume *)sender;
- (void)didReceivedTapOnCellGroupVolumeMuteButton:(CellGroupVolume *)sender;
- (void)didReceivedTapOnCellDeleteButton:(CellGroupVolume *)sender;
@end

@interface CellGroupVolume : UITableViewCell <UIGestureRecognizerDelegate> {
    id <CellGroupVolumeDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

@property (weak, nonatomic) IBOutlet CustomButton *btnCellDelete;
@property (weak, nonatomic) IBOutlet UIView *viewContentBG;
@property (weak, nonatomic) IBOutlet CustomButton *btnGroupAudioImage;
@property (weak, nonatomic) IBOutlet UIView *viewSliderBG;
@property (weak, nonatomic) IBOutlet UILabel *lblGroupOutputName;
@property (weak, nonatomic) IBOutlet SSTTapSlider *sliderGroupVolumeOutput;
@property (weak, nonatomic) IBOutlet CustomButton *btnGroupVolumeMute;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraintGroupVolumeMuteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraintViewContentBG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraintViewContentBG;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, retain) NSIndexPath *cellIndexPath;

- (void)openCell;
- (IBAction)btnGroupAudioImage_Clicked:(CustomButton *)sender;
- (IBAction)btnGroupVolumeMute_Clicked:(CustomButton *)sender;
- (IBAction)btnCellDelete_Clicked:(CustomButton *)sender;

@end
