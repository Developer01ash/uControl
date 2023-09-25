//
//  ControlNoneVC.m
//  mHubApp
//
//  Created by Anshul Jain on 23/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

/**
 This is the container view, Child Class of GroupContainerVC.
 This container loads if there is no command in ControlGroup or There is no IRPack download on the selected Input.
 */

#import "ControlNoneVC.h"

@interface ControlNoneVC ()

@end

@implementation ControlNoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    // Do any additional setup after loading the view.
    [self.lblMessage setHidden:true];
    switch ([AppDelegate appDelegate].themeColours.themeType) {
        case Dark:
            self.imgMessage.image = kImageIconNoSourceWhite;
            break;
        case Light:
            self.imgMessage.image = kImageIconNoSourceDarkGray;
            break;
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
