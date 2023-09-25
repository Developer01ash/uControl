//
//  InputDeviceVC.h
//  mHubApp
//
//  Created by Anshul Jain on 23/09/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputDeviceVC : UIViewController<SearchDataManagerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollInputDevice;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionInputDevice;
@end
