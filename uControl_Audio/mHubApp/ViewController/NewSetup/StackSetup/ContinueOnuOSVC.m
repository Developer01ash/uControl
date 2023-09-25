//
//  ContinueOnuOSVC.m
//  mHubApp
//
//  Created by Rave Digital on 23/03/22.
//  Copyright © 2022 Rave Infosys. All rights reserved.
//

#import "ContinueOnuOSVC.h"

@interface ContinueOnuOSVC ()

@end

@implementation ContinueOnuOSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    //self.navigationController.navigationBarHidden = true;
        
    ThemeColor *themeColor = [AppDelegate appDelegate].themeColoursSetup;
    self.view.backgroundColor = themeColor.colorBackground;
    
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:CONTINUE_UOS];
    
    self.lblHeader.text = CONTINUE_UOS_HEADER;
    self.lblSubHeader.text = CONTINUE_UOS_SUBHEADER_Message;
    
    self.masterDevice.PairingDetails = [[Pair alloc] initWithPair:[Pair getPairObjectFromMHUBObject:self.masterDevice SlaveHub:self.arr_devices]];
    NSDictionary *dictPairing = [[NSDictionary alloc] initWithDictionary:[self.masterDevice.PairingDetails dictionaryJSONRepresentation]];
    DDLogDebug(@"Pair Dictionary == %@", dictPairing);
    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:HUB_CONNECTING];
    [APIManager setPairJSON:self.masterDevice PairData:dictPairing completion:^(APIV2Response *responseObject) {
        if (responseObject.error) {
            [[AppDelegate appDelegate] hideHudView:ErrorMessage Message:responseObject.error_description];
            [self.navigationController popViewControllerAnimated:NO];
        } else {
            self.masterDevice.UnitId = self.masterDevice.PairingDetails.master.unit_id;
            for (Hub *objSlave in self.arr_devices) {
                for (PairDetail *objPairing in self.masterDevice.PairingDetails.arrSlave) {
                    if ([objSlave.SerialNo isEqualToString:objPairing.serial_number]) {
                        objSlave.UnitId = objPairing.unit_id;
                        break;
                    }
                }
            }

            
            // [self fileAllDetails];
        }
    }];
}


- (IBAction)btnContinue:(CustomButton *)sender {
    
   
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
