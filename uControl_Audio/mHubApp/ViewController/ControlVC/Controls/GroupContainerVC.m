//
//  GroupContainerVC.m
//  mHubApp
//
//  Created by Anshul Jain on 23/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
 This is the container view, Child Class of ControlGroupBGVC.
 This is the parent class of ControlNoneVC and DynamicControlGroupVC
 Child container reload according to ControlGroup else ControlNoneVC show if there is no command in ControlGroup or IRPack.
 */

#import "GroupContainerVC.h"
#import "DynamicControlGroupVC.h"

@interface GroupContainerVC ()

@end

@implementation GroupContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

-(void)segueIdentifierReceivedFromParent:(NSString*)button {
    NSInteger intCount = 0;
    
    switch (mHubManagerInstance.controlDeviceTypeSource) {
        case InputSource: {
            InputDevice *objInput = mHubManagerInstance.objSelectedInputDevice;
            if ([button isEqualToString:kControlTypeGesturePad]) {
                intCount = objInput.objCommandType.gesture.count + objInput.objCommandType.gestureKey.count;
            } else if ([button isEqualToString:kControlTypeNumberPad]){
                intCount = objInput.objCommandType.number.count;
            } else if ([button isEqualToString:kControlTypeDirectionPad]){
                intCount = objInput.objCommandType.direction.count;
            } else if ([button isEqualToString:kControlTypePlayheadPad]){
                intCount = objInput.objCommandType.playhead.count;
            }else if ([button isEqualToString:kControlTypeCustomControl]){
                intCount = objInput.objCommandType.custom.count;
            }
            break;
        }
        case OutputScreen: {
            OutputDevice *objOutput = mHubManagerInstance.objSelectedOutputDevice;

            if ([button isEqualToString:kControlTypeGesturePad]) {
                intCount = objOutput.objCommandType.gesture.count + objOutput.objCommandType.gestureKey.count;
            } else if ([button isEqualToString:kControlTypeNumberPad]){
                intCount = objOutput.objCommandType.number.count;
            } else if ([button isEqualToString:kControlTypeDirectionPad]){
                intCount = objOutput.objCommandType.direction.count;
            } else if ([button isEqualToString:kControlTypePlayheadPad]){
                intCount = objOutput.objCommandType.playhead.count;
            }else if ([button isEqualToString:kControlTypeCustomControl]){
                intCount = objOutput.objCommandType.custom.count;
            }
            break;
        }
        case AVRSource: {
            AVRDevice *objAVR = mHubManagerInstance.objSelectedAVRDevice;
            
            if ([button isEqualToString:kControlTypeGesturePad]) {
                intCount = objAVR.objCommandType.gesture.count + objAVR.objCommandType.gestureKey.count;
            } else if ([button isEqualToString:kControlTypeNumberPad]){
                intCount = objAVR.objCommandType.number.count;
            } else if ([button isEqualToString:kControlTypeDirectionPad]){
                intCount = objAVR.objCommandType.direction.count;
            } else if ([button isEqualToString:kControlTypePlayheadPad]){
                intCount = objAVR.objCommandType.playhead.count;
            }else if ([button isEqualToString:kControlTypeCustomControl]){
                intCount = objAVR.objCommandType.custom.count;
            }
            break;
        }
        default: {
            InputDevice *objInput = mHubManagerInstance.objSelectedInputDevice;
            if ([button isEqualToString:kControlTypeGesturePad]) {
                intCount = objInput.objCommandType.gesture.count + objInput.objCommandType.gestureKey.count;
            } else if ([button isEqualToString:kControlTypeNumberPad]){
                intCount = objInput.objCommandType.number.count;
            } else if ([button isEqualToString:kControlTypeDirectionPad]){
                intCount = objInput.objCommandType.direction.count;
            } else if ([button isEqualToString:kControlTypePlayheadPad]){
                intCount = objInput.objCommandType.playhead.count;
            }else if ([button isEqualToString:kControlTypeCustomControl]){
                intCount = objInput.objCommandType.custom.count;
            }
            mHubManagerInstance.controlDeviceTypeSource = InputSource;
            break;
        }
    }

    
    
    
    if (intCount == 0) {
        self.segueIdentifier = kControlTypeNone;
    } else {
        self.segueIdentifier = kDynamicControlGroup;
        if ([button isEqualToString:kControlTypeGesturePad]) {
            self.strControlType = kControlTypeGesturePad;
        } else if ([button isEqualToString:kControlTypeNumberPad]){
            self.strControlType = kControlTypeNumberPad;
        } else if ([button isEqualToString:kControlTypeDirectionPad]){
            self.strControlType = kControlTypeDirectionPad;
        } else if ([button isEqualToString:kControlTypePlayheadPad]){
            self.strControlType = kControlTypePlayheadPad;
        }else if ([button isEqualToString:kControlTypeCustomControl]){
            self.strControlType = kControlTypeCustomControl;
        } else {
            self.strControlType = kControlTypeNone;
        }
    }
    [self performSegueWithIdentifier:self.segueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    __block UIViewController  *lastViewController, *vc;
    //  vc = [[UIViewController alloc]init];
    // Make sure your segue name in storyboard is the same as this line
    
    for (UIViewController *view in self.childViewControllers) {
        lastViewController = view;
    }
    
    if ([[segue identifier] isEqual: self.segueIdentifier]) {
        if(lastViewController != nil){
            [lastViewController.view removeFromSuperview];
        }
        [self.view crossDissolveTransitionWithAnimations:^{
            // Get reference to the destination view controller
            if ([[segue identifier] isEqual: kDynamicControlGroup]) {
                DynamicControlGroupVC *vcd = (DynamicControlGroupVC *)[segue destinationViewController];
                vcd.segueIdentifier = self.strControlType;
                [self addChildViewController:(vcd)];
                vcd.view.frame  = CGRectMake(0,0, self.view.frame.size.width , self.view.frame.size.height);
                [self.view addSubview:vcd.view];
                
            } else {
                vc = (UIViewController *)[segue destinationViewController];
                [self addChildViewController:(vc)];
                vc.view.frame  = CGRectMake(0,0, self.view.frame.size.width , self.view.frame.size.height);
                [self.view addSubview:vc.view];
            }
        } AndCompletion:nil];
    }
}

@end
