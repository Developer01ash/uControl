//
//  BenchmarkDetailsViewController.m
//  mHubApp
//
//  Created by Rave on 17/12/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "BenchmarkDetailsViewController.h"

@interface BenchmarkDetailsViewController ()
@property (strong, nonatomic) NSMutableArray *arrBenchmarkData;

@end

@implementation BenchmarkDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = customBackBarButton;
    self.navigationItem.hidesBackButton = true;
    self.view.backgroundColor = [AppDelegate appDelegate].themeColoursSetup.colorBackground;
    self.navigationItem.titleView = [CustomNavigationBar customNavigationLabel:HUB_SOFTWARE_BENCHMARK];
    self.lblBenchmarkDetails.text = HUB_SOFTWARE_BENCHMARK_PLACEHOLDER_TEXT;
    
    [self getBenchMarkFile];
}

- (IBAction)btn_gotoMenu_clicked:(CustomButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)getBenchMarkFile {


    [APIManager getBenchMarkDetails:nil updateData:nil completion:^(NSDictionary *responseObject) {
         if(responseObject != nil){
            //NSLog(@"BenchmarkDetailsViewController Success  1%@ and %@",responseObject,responseObject);
            self.arrBenchmarkData  =  (NSMutableArray *)responseObject;
         //   //NSLog(@"BenchmarkDetailsViewController Success  1%@",self.arrBenchmarkData);
            NSString *stringObj = @"Benchmark Details";
            for(int i = 0 ;i < [self.arrBenchmarkData count];i++)
                {
                stringObj = [stringObj stringByAppendingString:[NSString stringWithFormat:@"%@",[self.arrBenchmarkData objectAtIndex:i]]];
                }
            self.lblBenchmarkDetails.text = stringObj;
        }
        else
            {
            //NSLog(@"BenchmarkDetailsViewController error  2 %@ a",responseObject);
            }
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppDelegate appDelegate].isSearchNetworkPopVC = true;
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
