//
//  OutputDeviceVC.h
//  mHubApp
//
//  Created by Anshul Jain on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutputDevice.h"
#import "CellOutputCollectionViewCell.h"



@interface OutputDeviceVC : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) UIColor *tintColor;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbl_version;
@property (weak, nonatomic) IBOutlet UILabel *lbl_connectedHub_ProfileName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_zoneTitle;
@property (strong, nonatomic) IBOutlet UIImageView *downArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *downArrow_zoneName;
@property (strong, nonatomic) IBOutlet UIButton *zoneNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnSettings;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSettingButtonHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCons_sequencesHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCons_zoneControlsHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnEditDone;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionOutputDev;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionSequence;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionSequenceFL;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionZoneControls;
- (IBAction)btnSettings_Clicked:(UIButton *)sender;
- (IBAction)btnEditDone_Clicked:(UIButton *)sender;

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

- (void)encodeWithCoder:(nonnull NSCoder *)coder;

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection;

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container;

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize;

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container;

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator;

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator;

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator;

- (void)setNeedsFocusUpdate;

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context;

- (void)updateFocusIfNeeded;

@end
