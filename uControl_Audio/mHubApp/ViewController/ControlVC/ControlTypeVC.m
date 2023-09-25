//
//  ControlTypeVC.m
//  mHubApp
//
//  Created by Anshul Jain on 22/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
 This is the container view, Child Class of ControlGroupBGVC.
 This class contains CollectionView which show ControlGroup** available in the Input uControl IRPack.
    ** ControlGroup means Gesture, Navigation, Numerical, Playhead.
 ControlGroup can be change on Click or Swipe.
 */

#import "ControlTypeVC.h"
#import "CellControl.h"

@interface ControlTypeVC ()<UIGestureRecognizerDelegate> {
    NSIndexPath *selectedIndexPath;
}
@property (weak, nonatomic) IBOutlet UICollectionView *cvControlType;

@property (nonatomic, retain) NSMutableArray *arrControlCommand;

@property (nonatomic) ControlGroupType selectedControlType;
@end

@implementation ControlTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeGesture:)];
    [swipeLeft setDelegate:self];
    [swipeLeft setNumberOfTouchesRequired:1];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGesture:)];
    [swipeRight setDelegate:self];
    [swipeRight setNumberOfTouchesRequired:1];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    switch (mHubManagerInstance.controlDeviceTypeSource) {
        case InputSource: {
            InputDevice *objInput = mHubManagerInstance.objSelectedInputDevice;
            self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.arrCGOrder];
            break;
        }
        case AVRSource: {
            AVRDevice *objAVR = mHubManagerInstance.objSelectedAVRDevice;
            self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objAVR.objCommandType.arrCGOrder];
            break;
        }
        case OutputScreen: {
            OutputDevice *objOutput = mHubManagerInstance.objSelectedOutputDevice;
            self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objOutput.objCommandType.arrCGOrder];
            break;
        }
        default: {
            InputDevice *objInput = mHubManagerInstance.objSelectedInputDevice;
            self.arrControlCommand = [[NSMutableArray alloc] initWithArray:objInput.objCommandType.arrCGOrder];
            mHubManagerInstance.controlDeviceTypeSource = InputSource;
            break;
        }
    }
    
    if (self.arrControlCommand.count > 0) {
        Order *objOrder = [self.arrControlCommand firstObject];
        objOrder.selected = true;
        [self.arrControlCommand replaceObjectAtIndex:0 withObject:objOrder];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
        // scroll to the cell
        [self.cvControlType scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        // call delegate method
        [self collectionView:self.cvControlType didSelectItemAtIndexPath:indexPath];
    } else {
        if(self.delegate) {
            [self.delegate didReceivedTapOnControlTypeButton:kControlTypeNone];
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.cvControlType reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- CollectionView Datasource and Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    @try {
        return self.arrControlCommand.count;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    CellControl *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CellControlGroup" forIndexPath:indexPath];
    Order *objOrder = [self.arrControlCommand objectAtIndex:indexPath.item];
    ThemeColor *objTheme = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColours];
    cell.imgControlImage.image = [self getImageForGroupControlIcon:objOrder.type Theme:objTheme.themeType Selected:objOrder.selected];
    cell.backgroundColor = objOrder.selected ? objTheme.colorCGroupSelectedBackground : objTheme.colorCGroupBackground;
   
    cell.layer.borderWidth = 1.0f;
    cell.layer.cornerRadius = cell.frame.size.width/2;
    cell.layer.masksToBounds = NO;
//    cell.clipsToBounds = YES;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        [[CustomAVPlayer sharedInstance] soundPlay:Click];
        Order *objOrderSelected = [self.arrControlCommand objectAtIndex:indexPath.item];
        selectedIndexPath = indexPath;
        for (Order *objOrder in self.arrControlCommand) {
            if (objOrder.type == objOrderSelected.type) {
                objOrder.selected = true;
            } else {
                objOrder.selected = false;
            }
        }
        if(self.delegate) {
            switch (objOrderSelected.type) {
                case GesturePad:
                    [self.delegate didReceivedTapOnControlTypeButton:kControlTypeGesturePad];
                    break;
                case NumberPad:
                    [self.delegate didReceivedTapOnControlTypeButton:kControlTypeNumberPad];
                    break;
                case DirectionPad:
                    [self.delegate didReceivedTapOnControlTypeButton:kControlTypeDirectionPad];
                    break;
                case PlayheadPad:
                    [self.delegate didReceivedTapOnControlTypeButton:kControlTypePlayheadPad];
                    break;
                case CustomPad:
                    [self.delegate didReceivedTapOnControlTypeButton:kControlTypeCustomControl];
                    break;
                default:
                    [self.delegate didReceivedTapOnControlTypeButton:kControlTypeNone];
                    break;
            }
        }
        
        [self.cvControlType reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = 0.0;
    cellWidth = self.cvControlType.frame.size.height;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // Add inset to the collection view if there are not enough cells to fill the width.
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = 0.0;
    cellWidth = self.cvControlType.frame.size.height;
    float cellCount = [collectionView numberOfItemsInSection:section] - 0.5;
    CGFloat inset = (collectionView.bounds.size.width - ((cellCount) * (cellWidth + cellSpacing))) * 0.5;
    CGFloat insetLeft = ((UICollectionViewFlowLayout *) collectionViewLayout).sectionInset.left;
    inset = MAX(inset, insetLeft);
    return UIEdgeInsetsMake(10.0, inset, 10.0, inset);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.cvControlType.collectionViewLayout invalidateLayout];
}

-(UIImage *) getImageForGroupControlIcon:(ControlGroupType)cgType Theme:(ThemeType)themeType Selected:(BOOL)isSelected {
    UIImage *imgReturn = nil;
    switch (cgType) {
        case GesturePad: {
            if (isSelected) {
                imgReturn = kImageIconGestureWhite;
            } else {
                imgReturn = kImageIconGestureLightGray;
            }
            break;
        }
            
        case NumberPad: {
            if (isSelected) {
                imgReturn = kImageIconNumericWhite;
            } else {
                imgReturn = kImageIconNumericLightGray;
            }
            break;
        }
            
        case DirectionPad: {
            if (isSelected) {
                imgReturn = kImageIconNavigationWhite;
            } else {
                imgReturn = kImageIconNavigationLightGray;
            }
            break;
        }
            
        case PlayheadPad: {
            if (isSelected) {
                imgReturn = kImageIconPlayheadWhite;
            } else {
                imgReturn = kImageIconPlayheadLightGray;
            }
            break;
        }
        case CustomPad: {
            if (isSelected) {
                imgReturn = kImageIconCustomWhite;
            } else {
                imgReturn = kImageIconCustomLightGray;
            }
            break;
        }
        default:
            break;
    }
    return imgReturn;
}

- (void)leftSwipeGesture:(id)sender {
    @try {
        NSInteger intLeftSwipeIndex = selectedIndexPath.row+1;
        if (intLeftSwipeIndex < self.arrControlCommand.count) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:intLeftSwipeIndex inSection:selectedIndexPath.section];
            // call delegate method
            [self collectionView:self.cvControlType didSelectItemAtIndexPath:indexPath];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)rightSwipeGesture:(id)sender {
    @try {
        NSInteger intRightSwipeIndex = selectedIndexPath.row-1;
        if (intRightSwipeIndex >= 0) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:intRightSwipeIndex inSection:selectedIndexPath.section];
            // call delegate method
            [self collectionView:self.cvControlType didSelectItemAtIndexPath:indexPath];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
