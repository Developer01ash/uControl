//
//  SourceContainerVC.m
//  mHubApp
//
//  Created by Anshul Jain on 15/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
 This is the  another container view, child Class of ControlVC.
 This is the base class of InputOutputContainerVC. This class contains the Notifier to reload the Source control.
 */

#import "SourceContainerVC.h"

@interface SourceContainerVC ()

@end

@implementation SourceContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadSourceControl object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kNotificationReloadSourceControl
                                               object:nil];
}

- (void) receiveNotification:(NSNotification *) notification {
    DDLogInfo(RECEIVENOTIFICATION, __FUNCTION__, [notification name]);
    [self segueIdentifierReceivedFromParent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segueIdentifierReceivedFromParent {
    self.segueIdentifier = kInputOutputContainerVC;
    [self performSegueWithIdentifier:self.segueIdentifier sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    __block UIViewController  *lastViewController, *vc;
    //  vc = [[UIViewController alloc]init];
    // Make sure your segue name in storyboard is the same as this line
    
    for (UIViewController *view in self.childViewControllers) {
        lastViewController = view;
    }
    // Get reference to the destination view controller
    if ([[segue identifier] isEqual: self.segueIdentifier]) {
        if(lastViewController != nil){
            [lastViewController.view removeFromSuperview];
        }
        // Get reference to the destination view controller
        vc = (UIViewController *)[segue destinationViewController];
        [self addChildViewController:(vc)];
        vc.view.frame  = CGRectMake(0,0, self.view.frame.size.width , self.view.frame.size.height);
        [self.view addSubview:vc.view];
    }
}


@end
