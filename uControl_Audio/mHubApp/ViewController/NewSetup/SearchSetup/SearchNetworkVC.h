//
//  SearchNetworkVC.h
//  mHubApp
//
//  Created by Anshul Jain on 12/03/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//


#define kDEVICEMODEL_MHUB4K44PRO    @"MHUB4K44PRO"
#define kDEVICEMODEL_MHUB4K88PRO    @"MHUB4K88PRO"
#define kDEVICEMODEL_MHUB4K431      @"MHUB4K431"
#define kDEVICEMODEL_MHUB4K862      @"MHUB4K862"

#define kDEVICEMODEL_MHUB431U       @"MHUB431U"
#define kDEVICEMODEL_MHUB862U       @"MHUB862U"
#define kDEVICEMODEL_MHUBPRO4440    @"MHUBPRO4440"
#define kDEVICEMODEL_MHUBPRO8840    @"MHUBPRO8840"
#define kDEVICEMODEL_MHUBMAX44      @"MHUBMAX44"
#define kDEVICEMODEL_MHUBAUDIO64    @"MHUBAUDIO64"
#define kDEVICEMODEL_MHUB431U40      @"MHUBU43140"
#define kDEVICEMODEL_MHUB862U40      @"MHUBU86240"
#define kDEVICEMODEL_MHUBS       @"MHUBS"



#import <UIKit/UIKit.h>
typedef enum {
    menu_Wifi    = 0,
    menu_findDevices = 1,
    menu_BenchMark = 2,
    menu_update     = 3,
    menu_setMhub   = 4,
    menu_reset = 5,
    menu_autoConnect     = 6,
    menu_autoConnect_gotoSetupConfirmation     = 7,
    menu_profileConnect     = 8,
    menu_comingFromSettings   = 9,
    menu_update_inside     = 10,
    menu_wifi_device_connected     = 11,
    menuOptionCount
} MenuOption;

@interface SearchNetworkVC : UIViewController
{
    
}
@property ( nonatomic) bool isManuallyConnectNavigation;
@property ( nonatomic) bool isOpenFromSettingsScreen;

@property(nonatomic) NSInteger navigateFromType;
@property(nonatomic, strong) NSString *searchSpecificDevice;

@end
