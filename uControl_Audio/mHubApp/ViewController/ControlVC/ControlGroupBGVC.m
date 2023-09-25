//
//  ControlGroupBGVC.m
//  mHubApp
//
//  Created by Anshul Jain on 06/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
 This is the container view, Child Class of InputOutputConatinerVC.
 This is the parents class for Container like ControlTypeVC and GroupContainerVC.
 This class also dedicated to set Display/Zone background if available.
 */

#import "ControlGroupBGVC.h"

@interface ControlGroupBGVC ()<ControlTypeDelegate> {
    UIVisualEffectView *effectView;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlGroupContainerHeight;

@end

@implementation ControlGroupBGVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.imgBackground.backgroundColor = [AppDelegate appDelegate].themeColours.colorBackground;
    // Do any additional setup after loading the view.

    if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
        Zone *objZone = mHubManagerInstance.objSelectedZone;
        if ([objZone.imgControlGroupBG isNotEmpty]) {
            self.imgBackground.image = objZone.imgControlGroupBG;
            switch ([AppDelegate appDelegate].themeColours.themeType) {
                case Dark:
                    self.imgBackground.alpha = 0.2f;
                    break;
                case Light:
                    self.imgBackground.alpha = 0.5f;
                    break;
                default:
                    break;
            }
        } else {
            self.imgBackground.image = nil;
        }
    } else {
        OutputDevice *objOutput = mHubManagerInstance.objSelectedOutputDevice;
        if ([objOutput.imgControlGroup isNotEmpty]) {
            self.imgBackground.image = objOutput.imgControlGroup;
            switch ([AppDelegate appDelegate].themeColours.themeType) {
                case Dark:
                    self.imgBackground.alpha = 0.2f;
                    break;
                case Light:
                    self.imgBackground.alpha = 0.5f;
                    break;
                default:
                    break;
            }
        } else {
            self.imgBackground.image = nil;
        }
    }
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    effectView.frame = self.view.bounds;
    switch ([AppDelegate appDelegate].themeColours.themeType) {
        case Dark: {
            [self.imgSeperatorShadow setImage:kImageShadowThemeBlack];
            break;
        }
        case Light: {
            [self.imgSeperatorShadow setImage:kImageShadowThemeWhite];
            break;
        }
        default:
            break;
    }
    
    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        self.controlGroupContainerHeight.constant = 36.0f;
    } else {
        self.controlGroupContainerHeight.constant = 39.0f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqual: @"ControlType"]) {
        self.objCtrlType = (ControlTypeVC *)[segue destinationViewController];
        self.objCtrlType.delegate = self;
    } else if ([[segue identifier] isEqual: @"CustomContainer"]){
        self.container = (GroupContainerVC *)[segue destinationViewController];
    }
}

#pragma mark -- ControlTypeVC Delegate --

-(void)didReceivedTapOnControlTypeButton:(NSString *)strButtonInfo {
    @try {
        [self.container segueIdentifierReceivedFromParent:strButtonInfo];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
@end
