//
//  CellGroupVolume.m
//  mHubApp
//
//  Created by Anshul Jain on 08/01/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "CellGroupVolume.h"

static CGFloat const kBounceValue = 20.0f;

@implementation CellGroupVolume

- (void)awakeFromNib {
    [super awakeFromNib];
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    [self.btnGroupVolumeMute addGestureRecognizer:self.panRecognizer];

    self.backgroundColor = [AppDelegate appDelegate].themeColours.colorPowerControlBG;
    [self.viewContentBG setBackgroundColor:[AppDelegate appDelegate].themeColours.colorPowerControlBG];
    [self.lblGroupOutputName setTextColor:[AppDelegate appDelegate].themeColours.colorSettingControlBorder];
    [self.lblGroupOutputName setFont:textFontLight10];
    
    if (self.sliderGroupVolumeOutput.value == self.sliderGroupVolumeOutput.minimumValue) {
        [self.sliderGroupVolumeOutput setMinimumTrackTintColor:colorDarkGray_202020];
        [self.sliderGroupVolumeOutput setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
        if ([AppDelegate appDelegate].themeColours.themeType == Light) {
            [self.sliderGroupVolumeOutput setMinimumTrackTintColor:colorLightGray_230230230];
            [self.sliderGroupVolumeOutput setMaximumTrackTintColor:colorWhite_254254254];
        } else {
            [self.sliderGroupVolumeOutput setMinimumTrackTintColor:colorDarkGray_202020];
            [self.sliderGroupVolumeOutput setMaximumTrackTintColor:colorDarkGray_202020];
        }
    } else if (self.sliderGroupVolumeOutput.value == self.sliderGroupVolumeOutput.maximumValue) {
        [self.sliderGroupVolumeOutput setThumbImage:kImageIconAudioSliderEnd forState:UIControlStateNormal];
        if ([AppDelegate appDelegate].themeColours.themeType == Light) {
            [self.sliderGroupVolumeOutput setMinimumTrackTintColor:colorGray_646464];
            [self.sliderGroupVolumeOutput setMaximumTrackTintColor:colorLightGray_230230230];
        } else {
            [self.sliderGroupVolumeOutput setMinimumTrackTintColor:colorWhite_254254254];
            [self.sliderGroupVolumeOutput setMaximumTrackTintColor:colorDarkGray_202020];
        }
    } else {
        [self.sliderGroupVolumeOutput setThumbImage:kImageIconAudioSlider forState:UIControlStateNormal];
        if ([AppDelegate appDelegate].themeColours.themeType == Light) {
            [self.sliderGroupVolumeOutput setMinimumTrackTintColor:colorGray_646464];
            [self.sliderGroupVolumeOutput setMaximumTrackTintColor:colorWhite_254254254];
        } else {
            [self.sliderGroupVolumeOutput setMinimumTrackTintColor:colorWhite_254254254];
            [self.sliderGroupVolumeOutput setMaximumTrackTintColor:colorDarkGray_202020];
        }
    }
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        self.widthConstraintGroupVolumeMuteButton.constant = heightFooterView_SmallMobile;
    } else {
        self.widthConstraintGroupVolumeMuteButton.constant = heightFooterView;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self resetConstraintContstantsToZero:NO notifyDelegateDidClose:NO];
}

- (void)openCell {
    [self setConstraintsToShowAllButtons:NO notifyDelegateDidOpen:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)btnGroupAudioImage_Clicked:(CustomButton *)sender {
    if (self.delegate) {
        [self.delegate didReceivedTapOnCellGroupImageButton:self];
    }
}

- (IBAction)btnGroupVolumeMute_Clicked:(CustomButton *)sender {
    if (self.delegate) {
        [self.delegate didReceivedTapOnCellGroupVolumeMuteButton:self];
    }
}

- (IBAction)btnCellDelete_Clicked:(CustomButton *)sender {
    if (self.delegate) {
        [self.delegate didReceivedTapOnCellDeleteButton:self];
    }
}

- (CGFloat)buttonTotalWidth {
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.btnCellDelete.frame);
}

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.panStartPoint = [recognizer translationInView:self.viewContentBG];
            self.startingRightLayoutConstraintConstant = self.trailingConstraintViewContentBG.constant;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.viewContentBG];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {  //1
                panningLeft = YES;
            }
            
            if (self.startingRightLayoutConstraintConstant == 0) { //2
                                                                   //The cell was closed and is now opening
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0); //3
                    if (constant == 0) { //4
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO]; //5
                    } else {
                        self.trailingConstraintViewContentBG.constant = constant; //6
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]); //7
                    if (constant == [self buttonTotalWidth]) { //8
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO]; //9
                    } else {
                        self.trailingConstraintViewContentBG.constant = constant; //10
                    }
                }
            }else {
                //The cell was at least partially open.
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX; //11
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0); //12
                    if (constant == 0) { //13
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO]; //14
                    } else {
                        self.trailingConstraintViewContentBG.constant = constant; //15
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]); //16
                    if (constant == [self buttonTotalWidth]) { //17
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO]; //18
                    } else {
                        self.trailingConstraintViewContentBG.constant = constant;//19
                    }
                }
            }
            
            self.leadingConstraintViewContentBG.constant = -self.trailingConstraintViewContentBG.constant; //20
            break;
        }

        case UIGestureRecognizerStateEnded: {
            if (self.startingRightLayoutConstraintConstant == 0) { //1
                                                                   //We were opening
                CGFloat halfOfButtonOne = CGRectGetWidth(self.btnCellDelete.frame) / 2; //2
                if (self.trailingConstraintViewContentBG.constant >= halfOfButtonOne) { //3
                                                                                        //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
                
            } else {
                //We were closing
                CGFloat buttonOnePlusHalfOfButton2 = CGRectGetWidth(self.btnCellDelete.frame); //4 //  + (CGRectGetWidth(self.button2.frame) / 2)
                if (self.trailingConstraintViewContentBG.constant >= buttonOnePlusHalfOfButton2) { //5
                                                                                                   //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            if (self.startingRightLayoutConstraintConstant == 0) {
                //We were closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //We were open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
        }
        default:
            break;
    }
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        //NSLog(@"Animated!");
        duration = 0.1;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}


- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate {
    //    if (notifyDelegate) {
    //        [self.delegate cellDidClose:self];
    //    }
    
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.trailingConstraintViewContentBG.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.trailingConstraintViewContentBG.constant = -kBounceValue;
    self.leadingConstraintViewContentBG.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.trailingConstraintViewContentBG.constant = 0;
        self.leadingConstraintViewContentBG.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.trailingConstraintViewContentBG.constant;
        }];
    }];
}


- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {
    //    if (notifyDelegate) {
    //        [self.delegate cellDidOpen:self];
    //    }
    
    //1
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
        self.trailingConstraintViewContentBG.constant == [self buttonTotalWidth]) {
        return;
    }
    //2
    self.leadingConstraintViewContentBG.constant = -[self buttonTotalWidth] - kBounceValue;
    self.trailingConstraintViewContentBG.constant = [self buttonTotalWidth] + kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        //3
        self.leadingConstraintViewContentBG.constant = -[self buttonTotalWidth];
        self.trailingConstraintViewContentBG.constant = [self buttonTotalWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            //4
            self.startingRightLayoutConstraintConstant = self.trailingConstraintViewContentBG.constant;
        }];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
