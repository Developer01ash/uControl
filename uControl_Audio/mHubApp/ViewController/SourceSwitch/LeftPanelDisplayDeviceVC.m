//
//  LeftPanelDisplayDeviceVC.m
//  mHubApp
//
//  Created by Anshul Jain on 19/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
VC to show Leftpanel data i.e. List of Output/Zone and Sequence when SourceSwitchVC shown as main screen. In this file we can rearrange Output/Zone and Sequence by long press and move and we can also delete or remove Output/Zone and Sequence temporarily.
 */
#import "LeftPanelDisplayDeviceVC.h"
#import "CellOutput.h"
#import "CellFooter.h"
#import "UIViewController+LGSideMenuController.h"
#import "Utility.h"
#import "SettingsVC.h"

#define kPortraitContraintConstantiPhone4 10
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@interface LeftPanelDisplayDeviceVC ()<CellOutputDelegate>
@property (strong, nonatomic) NSMutableArray *arrTableData;
@property (nonatomic, assign) BOOL isEdit;
@end

@implementation LeftPanelDisplayDeviceVC {
//    __weak UIView *_staticView;
}

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.navigationItem.backBarButtonItem = customBackBarButton;
        // Do any additional setup after loading the view.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadOutput object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:kNotificationReloadOutput
                                                   object:nil];

        if (mHubManagerInstance.objSelectedHub.Generation != mHub4KV3) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(longPressRecognizerHandler_ReorderTableview:)];
            [self.tableView addGestureRecognizer:longPress];
            self.isEdit = false;
            [self.btnEditDone setHidden:true];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        ThemeColor *objTheme = [AppDelegate appDelegate].themeColours;
        [self.tableView setBackgroundColor:objTheme.colorOutputBackground];
        [self.btnSettings setBackgroundColor:objTheme.colorOutputBackground];
        [self.btnSettings.imageView setTintColor:objTheme.colorOutputText];
        
        UIImage *image = [kImageIconSettings imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        [self.btnSettings.imageView setImage:image];
        [self.btnSettings addBorder_Color:objTheme.colorSettingControlBorder BorderWidth:1.0];
        
//    UIImage * landscapeImage = kImageHDALogo;
//    UIImage * portraitImage = [[UIImage alloc] initWithCGImage: landscapeImage.CGImage
//                                                         scale: 1.0
//                                                   orientation: UIImageOrientationLeft];
        
//    [self.imgHeader setImage:portraitImage];
        [self outputDataRearrangement];
        NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString * versionBuildString = [NSString stringWithFormat:@"v.%@", appVersionString];
        [self.lbl_version setText:versionBuildString];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) outputDataRearrangement {
    @try {
        self.arrTableData = [[NSMutableArray alloc] initWithArray:mHubManagerInstance.arrLeftPanelRearranged];
        [self.tableView reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)viewWillLayoutSubviews {
    @try {
        [super viewWillLayoutSubviews];
        if ([AppDelegate appDelegate].deviceType == tabletLarge) {
            [[AppDelegate appDelegate] setShouldRotate:YES];
        }
        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            self.constraintSettingButtonHeightConstant.constant = heightFooterView_SmallMobile;
        } else {
            self.constraintSettingButtonHeightConstant.constant = heightFooterView;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) receiveNotification:(NSNotification *) notification {
    @try {
        DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
        [self viewWillAppear:false];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnSettings_Clicked:(UIButton *)sender {
    @try {
        SettingsVC *objSettings = [settingsStoryboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
        [(UINavigationController *)[self sideMenuController].rootViewController pushViewController:objSettings animated:YES];
        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (IBAction)btnEditDone_Clicked:(UIButton *)sender {
    @try {
        [self longPressViewHandler_HeaderView:sender];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)longPressRecognizerHandler_ReorderTableview:(id)sender {
    @try {
        //    if (self.isEdit) {
        self.isEdit = true;
        [self.btnEditDone setHidden:false];
        [self.tableView reloadData];

        UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
        UIGestureRecognizerState state = longPress.state;
        
        CGPoint location = [longPress locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        
        static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
        static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
        
        switch (state) {
            case UIGestureRecognizerStateBegan: {
                if (indexPath) {
                    sourceIndexPath = indexPath;
                    
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    // Take a snapshot of the selected row using helper method.
                    snapshot = [self customSnapshoFromView:cell];
                    // Add the snapshot as subview, centered at cell's center...
                    __block CGPoint center = cell.center;
                    snapshot.center = center;
                    snapshot.alpha = 0.0;
                    [self.tableView addSubview:snapshot];
                    [UIView animateWithDuration:ANIMATION_DURATION_MOVE animations:^{
                        // Offset for gesture location.
                        center.y = location.y;
                        snapshot.center = center;
                        snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                        snapshot.alpha = 0.98;
                        cell.alpha = 0.0;
                        cell.hidden = YES;
                    }];
                }
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGPoint center = snapshot.center;
                center.y = location.y;
                snapshot.center = center;
                // Is destination valid and is it different from source?
                if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                    // ... update data source.
                    [self.arrTableData exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    // ... move the rows.
                    [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    // ... and update source so it is in sync with UI changes.
                    sourceIndexPath = indexPath;
                    // mHubManagerInstance.arrLeftPanelRearranged = [[NSMutableArray alloc] initWithArray:self.arrTableData];
                    // [mHubManager saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
                }
                break;
            }
            default: {
                // Clean up.
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
                cell.alpha = 0.0;
                [UIView animateWithDuration:ANIMATION_DURATION_MOVE animations:^{
                    snapshot.center = cell.center;
                    snapshot.transform = CGAffineTransformIdentity;
                    snapshot.alpha = 0.0;
                    cell.alpha = 1.0;
                } completion:^(BOOL finished) {
                    cell.hidden = NO;
                    sourceIndexPath = nil;
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                }];
                break;
            }
        }
        //    } else {
        //        self.isEdit = true;
        //        [self.btnEditDone setHidden:false];
        //        [self.tableView reloadData];
        //    }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)longPressViewHandler_HeaderView:(id)sender {
    @try {
        self.isEdit = false;
        [self.btnEditDone setHidden:true];
        [self.tableView reloadData];

        mHubManagerInstance.arrLeftPanelRearranged = [[NSMutableArray alloc] initWithArray:self.arrTableData];
        [mHubManagerInstance saveCustomObject:mHubManagerInstance key:kMHUBMANAGERINSTANCE];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrTableData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectZero];
    return viewHeader;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        return heightTableViewRowWithPadding_SmallMobile;
    } else {
        return heightTableViewRowWithPadding;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        CellOutput *cell = [tableView dequeueReusableCellWithIdentifier:@"CellOutput"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellOutput"];
        }
        cell.delegate = self;
        cell.indexPathCell = indexPath;
        cell.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputBackground;
        cell.selectedBackgroundView.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputSelectedBackground;
        [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorOutputText];

        if ([self.arrTableData[indexPath.row] isKindOfClass:[OutputDevice class]]) {
            OutputDevice *obj = self.arrTableData[indexPath.row];
            NSString *strName = obj.CreatedName;
            cell.lblName.text = [strName uppercaseString];

            if (obj.objCommandType.volume.count > 0) {
                cell.imgConnected.hidden = false;
                cell.imgConnected.image = kImageIconIREnabled;
            } else {
                cell.imgConnected.hidden = true;
                cell.imgConnected.image = nil;
            }
            if (obj.Index == mHubManagerInstance.objSelectedOutputDevice.Index) {
                cell.imgBackground.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputSelectedBackground;
                cell.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorOutputSelectedBackground Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorOutputSelectedText];
                [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorOutputSelectedBorder BorderWidth:1.0];
            } else {
                cell.imgBackground.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputBackground;
                cell.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorOutputBackground Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorOutputText];
                [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorOutputBorder BorderWidth:1.0];
            }
        } else if ([self.arrTableData[indexPath.row] isKindOfClass:[Sequence class]]) {
            Sequence *obj = self.arrTableData[indexPath.row];
            NSString *strName = obj.uControl_name;
            cell.lblName.text = [strName uppercaseString];

            cell.imgConnected.hidden = false;
            cell.imgConnected.image = kImageIconSequence;

            cell.imgBackground.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputBackground;
            cell.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorOutputBackground Frame:cell.imgBackground.frame];
            [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorOutputText];
            [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorOutputBorder BorderWidth:1.0];
        } else if ([self.arrTableData[indexPath.row] isKindOfClass:[Zone class]]) {
            Zone *obj = self.arrTableData[indexPath.row];
            NSString *strName = obj.zone_label;
            cell.lblName.text = [strName uppercaseString];

            if ([obj.zone_id isEqualToString:mHubManagerInstance.objSelectedZone.zone_id]) {
                cell.imgBackground.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputSelectedBackground;
                cell.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorOutputSelectedBackground Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorOutputSelectedText];
                [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorOutputSelectedBorder BorderWidth:1.0];
            } else {
                cell.imgBackground.backgroundColor = [AppDelegate appDelegate].themeColours.colorOutputBackground;
                cell.imgBackground.image = [Utility imageWithColor:[AppDelegate appDelegate].themeColours.colorOutputBackground Frame:cell.imgBackground.frame];
                [cell.lblName setTextColor:[AppDelegate appDelegate].themeColours.colorOutputText];
                [cell.imgBackground addBorder_Color:[AppDelegate appDelegate].themeColours.colorOutputBorder BorderWidth:1.0];
            }
        }

        if (self.isEdit) {
            [cell.btnCellDelete setHidden:false];
            CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-1.0));
            CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(1.0));
            cell.contentView.transform = leftWobble;  // starting point
            [UIView beginAnimations:@"wobble" context:(__bridge void * _Nullable)(cell.contentView)];
            [UIView setAnimationRepeatAutoreverses:YES]; // important
            [UIView setAnimationRepeatCount:HUGE_VALF];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
            cell.contentView.transform = rightWobble; // end here & auto-reverse
            [UIView commitAnimations];
        } else {
            [cell.btnCellDelete setHidden:true];
            CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
            CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
            cell.contentView.transform = leftWobble;  // starting point
            [UIView beginAnimations:@"wobble" context:(__bridge void * _Nullable)(cell.contentView)];
            [UIView setAnimationRepeatAutoreverses:YES]; // important
            [UIView setAnimationRepeatCount:1];
            [UIView setAnimationDuration:0.125];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
            cell.contentView.transform = rightWobble; // end here & auto-reverse
            [UIView commitAnimations];
        }

        return cell;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void) wobbleEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    @try {
        if ([finished boolValue]) {
            UIView* item = (__bridge UIView *)context;
            item.transform = CGAffineTransformIdentity;
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

-(void) didReceivedTapOnCellDeleteButton:(CellOutput *)sender {
    @try {
        DDLogDebug(@"<%s> sender == %@", __FUNCTION__, sender);
        if ([self.arrTableData[sender.indexPathCell.row] isKindOfClass:[OutputDevice class]]) {
            OutputDevice *objOP = self.arrTableData[sender.indexPathCell.row];
            for (int counter = 0; counter < mHubManagerInstance.objSelectedHub.HubOutputData.count; counter++) {
                OutputDevice *objOPList = mHubManagerInstance.objSelectedHub.HubOutputData[counter];
                if (objOPList.Index == objOP.Index) {
                    objOPList.isDeleted = true;
                    [mHubManagerInstance.objSelectedHub.HubOutputData replaceObjectAtIndex:counter withObject:objOPList];
                    break;
                }
            }
        } else if ([self.arrTableData[sender.indexPathCell.row] isKindOfClass:[Sequence class]]) {
            Sequence *objSeq = self.arrTableData[sender.indexPathCell.row];

            for (int counter = 0; counter < mHubManagerInstance.objSelectedHub.HubSequenceList.count; counter++) {
                Sequence *objSeqList = mHubManagerInstance.objSelectedHub.HubSequenceList[counter];
                if ([objSeqList.macro_id isEqualToString:objSeq.macro_id]) {
                    objSeqList.isDeleted = true;
                    [mHubManagerInstance.objSelectedHub.HubSequenceList replaceObjectAtIndex:counter withObject:objSeqList];
                    break;
                }
            }
        } else if ([self.arrTableData[sender.indexPathCell.row] isKindOfClass:[Zone class]]) {
            Zone *objZone = self.arrTableData[sender.indexPathCell.row];
            for (int counter = 0; counter < mHubManagerInstance.objSelectedHub.HubZoneData.count; counter++) {
                Zone *objZoneList = mHubManagerInstance.objSelectedHub.HubZoneData[counter];
                if ([objZoneList.zone_id isEqualToString:objZone.zone_id]) {
                    objZoneList.isDeleted = true;
                    [mHubManagerInstance.objSelectedHub.HubZoneData replaceObjectAtIndex:counter withObject:objZoneList];
                    break;
                }
            }
        }
        [self.arrTableData removeObjectAtIndex:sender.indexPathCell.row];
        [self.tableView reloadData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if (!self.isEdit) {
            if ([self.arrTableData[indexPath.row] isKindOfClass:[OutputDevice class]]) {
                OutputDevice *objOP = self.arrTableData[indexPath.row];
                // selectedIndexPath = indexPath;
                [self.tableView reloadData];
                mHubManagerInstance.objSelectedOutputDevice = objOP;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadSourceSwitch object:self userInfo:[objOP dictionaryRepresentation]];
                [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
            } else if ([self.arrTableData[indexPath.row] isKindOfClass:[Sequence class]]) {
                Sequence *obj = self.arrTableData[indexPath.row];
                [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
                if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
                    [APIManager executeSequence:mHubManagerInstance.objSelectedHub.Address SequenceId:obj.macro_id isSuperSeq:obj.isFunction completion:^(APIV2Response *responseObject) {
                        if (!responseObject.error) {
                            [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                        }
                    }];
                } else {
                    [APIManager playMacro_AlexaName:obj.alexa_name completion:^(APIResponse *responseObject) {
                        if (!responseObject.error) {
                            [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
                        }
                    }];
                }
                
            } else if ([self.arrTableData[indexPath.row] isKindOfClass:[Zone class]]) {
                Zone *obj = self.arrTableData[indexPath.row];
                mHubManagerInstance.objSelectedZone = obj;
                NSDictionary *dict = [obj dictionaryRepresentation];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadZoneSourceSwitch object:self userInfo:dict];
                // DDLogDebug(@"dictZone == %@", dict);
                [self.tableView reloadData];
                [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    @try {
        // Make an image from the input view.
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
        [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        // Create an image view.
        UIView *snapshot = [[UIImageView alloc] initWithImage:image];
        snapshot.layer.masksToBounds = NO;
        snapshot.layer.cornerRadius = 0.0;
        snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
        snapshot.layer.shadowRadius = 5.0;
        snapshot.layer.shadowOpacity = 0.4;

        return snapshot;
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
