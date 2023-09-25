//
//  JoinNetworkVC.m
//  mHubApp
//
//  Created by Ashutosh Tiwari on 03/01/20.
//  Copyright © 2020 Rave Infosys. All rights reserved.
//

#import "JoinNetworkVC.h"

@interface JoinNetworkVC ()
{
    NSTimer *a60SecTimer;
    NSInteger timerSeconds_value;
}

@end

@implementation JoinNetworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    timerSeconds_value = 60;
    //self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:Joining_WiFi_Network];
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
   // [self.btn_solid addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
   // [self.btn_flashing addBorder_Color:[UIColor whiteColor] BorderWidth:1.0];
    self.lbl_heading.text = wifiConnectionWithRouter; //[NSString stringWithFormat:CONNECT_BACK_TO_ROUTER_SSID_MESSAGE,[[NSUserDefaults standardUserDefaults] valueForKey:CONNECTED_SSID_NAME_KEY ]];
    self.lbl_subHeading.text = WIFI_Joining_Network; 
    if ([AppDelegate appDelegate].deviceType == mobileSmall)  {
        [self.lbl_heading setFont:textFontBold12];
        [self.lbl_subHeading setFont:textFontRegular12];
    } else {
        [self.lbl_heading setFont:textFontBold16];
        [self.lbl_subHeading setFont:textFontRegular16];
    }
    
    [self callSetSTAModeApi];
    
    a60SecTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
//       CABasicAnimation *rotate;
//        rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//        rotate.fromValue = [NSNumber numberWithFloat:0];
//        rotate.toValue = [NSNumber numberWithFloat:10.0];
//        rotate.duration = 60.0;
//        rotate.repeatCount = 60.0;
//        [self.img_spinner.layer addAnimation:rotate forKey:@"10"];
//        [self performSelector:@selector(stopRotation) withObject:nil afterDelay:60.0];
     
    }

-(void)updateTimer
{
    
    timerSeconds_value = timerSeconds_value - 1;
    if(timerSeconds_value >= 0)
    {
        self.lbl_progress.text = [NSString stringWithFormat:@"%ld seconds",timerSeconds_value];
        if(timerSeconds_value > 31)
        {
            [self.btn_solid setUserInteractionEnabled:false];
            [self.btn_flashing setUserInteractionEnabled:false];
        }
        else
        {
            [self.btn_solid setUserInteractionEnabled:true];
            [self.btn_flashing setUserInteractionEnabled:true];
        }
    }
    else
    {
        [a60SecTimer invalidate];
        a60SecTimer = nil;
    }
    
}

    -(void)stopRotation
    {
       
        [self.img_spinner setHidden:YES];
        [self.lbl_progress setHidden:YES];
        
    }


- (void)callSetSTAModeApi
{
    [[AppDelegate appDelegate] showHudView:ShowIndicator Message:@""];
    [APIManager wifiSetSTAMode:[FGRoute getGatewayIP] ssidString:self.SSIDNameStr passwordString:self.passwordStr encryptionString:self.encryptionNameStr updateData:nil completion:^(NSDictionary *responseObject) {
        [[AppDelegate appDelegate] hideHudView:HideIndicator Message:@""];
        if(responseObject != nil){
            NSLog(@"wifiSetSTAMode Success  %@",responseObject);
        }
        else
            {
            //[self.navigationController popViewControllerAnimated:YES];
                
            NSLog(@"wifiSetSTAMode error  %@",responseObject);
                WiFiErrorVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WiFiErrorVC"];
                objVC.errorType = 3;
                [self.navigationController pushViewController:objVC animated:NO];
            }
    }];
}

- (IBAction)btnLightsSolid_Clicked:(UIButton *)sender {
    WifiConnectedVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"WifiConnectedVC"];
    [self.navigationController pushViewController:objVC animated:NO];
}

- (IBAction)btnLightsFlashing_Clicked:(UIButton *)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    Wifi_Final_ErrorVC *objVC = [wifiSetupStoryboard instantiateViewControllerWithIdentifier:@"Wifi_Final_ErrorVC"];
    [self.navigationController pushViewController:objVC animated:NO];
    
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
