//
//  Constant.h
//  mHubApp
//
//  Created by rave on 9/17/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#ifdef DEBUG
#   define DLog(fmt, ...) //NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) //NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

static const float ALPHA_MIN = 0.9f;
static const float ALPHA_MAX = 1.0f;
static const float ALPHA_DISABLE = 0.3f;
static const float ALPHA_ENABLE = 1.0f;
static const float ANIMATION_DURATION_MOVE = 0.25f;

#define mainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
#define controlStoryboard [UIStoryboard storyboardWithName:@"Control" bundle:[NSBundle mainBundle]]
#define settingsStoryboard [UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]]
#define wifiSetupStoryboard [UIStoryboard storyboardWithName:@"WifiSetup" bundle:[NSBundle mainBundle]]

#define kSSDPServiceType_UPnP_TVpicture1 @"urn:schemas-upnp-org:service:tvpicture:1"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

    //MARK: IPHONE SCREEN WIDTH AND HEIGHT BOUND CONDITION
#define IS_IPHONE_4_OR_5_WIDTH (fabs((double)[[UIScreen mainScreen]bounds].size.width-(double)320) < DBL_EPSILON)
#define IS_IPHONE_4_HEIGHT (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)480) < DBL_EPSILON)
#define IS_IPHONE_5_HEIGHT (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568) < DBL_EPSILON)
#define IS_IPHONE_6_WIDTH (fabs((double)[[UIScreen mainScreen]bounds].size.width-(double)375) < DBL_EPSILON)
#define IS_IPHONE_6_HEIGHT (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS_WIDTH (fabs((double)[[UIScreen mainScreen]bounds].size.width-(double)414) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS_HEIGHT (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)736) < DBL_EPSILON)
#define IS_IPHONE_X_WIDTH (fabs((double)[[UIScreen mainScreen]bounds].size.width-(double)375) < DBL_EPSILON)
#define IS_IPHONE_X_HEIGHT (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)812) < DBL_EPSILON)
#define IS_IPHONE_XR_HEIGHT (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)896) < DBL_EPSILON)
#define IS_IPHONE_small_PHONE (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)667) < DBL_EPSILON)

#define IS_IPHONE_large_PHONE (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)844) < DBL_EPSILON)


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPAD_PRO_1366 (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1366.0)
#define IS_IPAD_PRO_1024 (IS_IPAD && MIN(SCREEN_WIDTH,SCREEN_HEIGHT) == 1024.0)



#define heightBiggerCellView                120.0f
#define heightBiggerCellView_SmallMobile    90.0f

#define heightFooterView                67.0f
#define heightFooterView_SmallMobile    54.4f

#define heightTableViewRow              50.0f
#define heightTableViewRow_SmallMobile  40.0f

#define heightTableViewRowWithPadding               heightTableViewRow+15.0f
#define heightTableViewRowWithPadding_SmallMobile   heightTableViewRow_SmallMobile+15.0f

#define heightTableViewHeaderWithPadding               heightTableViewRow*2
#define heightTableViewHeaderWithPadding_SmallMobile   heightTableViewRow_SmallMobile*2

#define heightTableViewRowWithPaddingWithLabel              heightTableViewRow+35.0f
#define heightTableViewRowWithPaddingWithLabel_SmallMobile  heightTableViewRow_SmallMobile+35.0f

#define MOSUPDATEVERSIONTOCHECK                8.00f

#define PRESS_TIME_VALUE               4
#define HOLD_TIME_VALUE                7

//#define tableViewHeaderHeight SCREEN_HEIGHT*0.06
//#define tableViewRowHeight SCREEN_HEIGHT*0.06+15.0f
//#define tableViewRowHeightForAddLabel SCREEN_HEIGHT*0.06+45.0f

#define RECEIVENOTIFICATION @"<%s: Notification received %@!>"
#define EXCEPTIONLOG        @"<Exception from %s: [Line %d] \n %@\n\n>"
#define ERRORLOG            @"<Error from %s: [Line %d] \n %@\n\n>"
#define URLLOG              @"<%s> \n\nURL == %@\n\n"
#define TRACKINGLOG         @"DEVICE %@ FROM %@"

#define kIPADMINI @"MINI"


#define kCOLORTHEMEOBJECT   @"colorThemeObject"
#define kAppLaunchFirstTime @"AppLaunchedFirstTime"
#define kAppSavedVersion    @"currentAppVersionString"
#define kLogoutOnUpdate     @"LOGGEDOUTONAPPUPDATE"
#define KUSERWASLOGGEDIN     @"USERWASLOGGEDIN"

//MARK: PRODUCTION BUNDLE ID AND GROUP ID
#define kNotificationBundleIndentifierProd              @"group.com.hdanywhere.ucontrol"
#define kNotificationIndentifierContinuityProd          @"com.hdanywhere.ucontrol.Continuity"

//MARK: DEVELOPMENT BUNDLE ID AND GROUP ID
#define kNotificationBundleIndentifierDev               @"group.com.hdanywhere.ucontroldev"
#define kNotificationIndentifierContinuityDev           @"com.hdanywhere.ucontroldev.Continuity"

#define kNotificationCloseSafari                        @"CloseSafari"
#define kNotificationReloadControlVC                    @"ReloadControlVC"
#define kNotificationLoadLeftMenu                    @"LoadLeftMenu"

#define kNotificationReloadZoneControlVC                @"ReloadZoneControlVC"
#define kNotificationReloadControlVC_ViewWillAppear     @"ReloadControlVC_ViewWillAppear"

#define kNotificationReloadControlGroupBGVC_AudioDevice @"ReloadControlGroupBGVC_AudioDevice"
#define kNotificationReloadInput                        @"SelectedInput"
#define kNotificationReloadOutput                       @"ReloadOutput"
#define kNotificationReloadSourceControl                @"ReloadSourceControl"
#define kNotificationReloadSourceSwitch                 @"ReloadSourceSwitch"
#define kNotificationReloadZoneSourceSwitch             @"ReloadZoneSourceSwitch"
#define kNotificationReloadSourceSwitch_ViewWillAppear  @"ReloadSourceSwitch_ViewWillAppear"
#define kNotificationReloadInputOutputContainer                       @"ReloadInputOutputContainer"
#define kNotificationShowHideInputOutputContainer                       @"ShowHideInputOutputContainer"


#define kNotificationReloadOutputControl                @"ReloadOutputControl"
#define kNotificationReloadOutputControlSlider          @"ReloadOutputControlSlider"
#define kNotificationReloadOutputControlLabel           @"ReloadOutputControlLabel"
#define kNotificationMuteStateChanged                   @"MuteStateChanged"

#define kNotificationWebSocketReceivedResponse                   @"WebSocketReceivedResponse"
#define kNotificationHideZoneMenu                   @"HideZoneMenu"

#define kControlGroupBGVC       @"ControlGroupBG"
#define kOutputControlVC        @"OutputControlVC"
#define kInputOutputContainerVC @"InputOutputContainerVC"
#define kControlDeviceType      @"ControlDeviceType"

    //MARK: IR Control Section Contants
#define kControlTypeNone            @"ControlNoneVC"
#define kControlTypeGesturePad      @"GestureVC"
#define kControlTypeNumberPad       @"NumberKeypadVC"
#define kControlTypeDirectionPad    @"DirectionKeypadVC"
#define kControlTypePlayheadPad     @"PlayheadKeypadVC"
#define kControlTypeCustomControl     @"CustomControlVC"
#define kDynamicControlGroup        @"DynamicControlGroupVC"

    //MARK: AlertView Title and Message Constants
#define ALERT_TITLE @"Alert"
#define ALERT_ERROR @"Error"
#define ALERT_TITLE_UPDATE_AVAILABLE @"There is an update available"
#define ALERT_DELETEGROUP @"Delete Group"
#define ALERT_TROUBLECONNECTING @"uControl is having trouble connecting to your system."
#define ALERT_ENTER_AUDIOIPADDRESS  @"Device AUDIO IP address."
#define ALERT_TITLE_START_UPDATE @"Start Update?"
#define ALERT_TITLE_Restore_MHUB @"Restore System?"


#define ALERT_MESSAGE_SELECT_HUBMODEL       @"\nSelect Device."
#define ALERT_MESSAGE_SELECT_MHUB4KV3TYPE   @"\nSelect %@ type."
#define ALERT_MESSAGE_ENTER_IPADDRESS       @"\nEnter IP address."
#define ALERT_MESSAGE_ENTER_DEVICE_IPADDRESS    @"\nEnter \"%@\" IP address."
#define ALERT_MESSAGE_SELECT_DEVICE         @"Select system."
#define ALERT_MESSAGE_SELECT_ZONE           @"Select Zone."
#define ALERT_MESSAGE_INTERNETNOTAVAILABEL  @"\nuControl is unable to detect an active Internet connection.\n"
#define ALERT_MESSAGE_ENTER_EMAILID         @"\nEnter email address."
#define ALERT_MESSAGE_ENTER_PASSWORD        @"\nEnter password."
#define ALERT_MESSAGE_ENTER_SERIALNO        @"\nEnter device serial number."
#define ALERT_MESSAGE_ENTER_MHUBTYPE        @"\nEnter system."
#define ALERT_MESSAGE_ENTER_FIRSTNAME       @"\nEnter first name."
#define ALERT_MESSAGE_ENTER_SECONDNAME      @"\nEnter second name."
#define ALERT_MESSAGE_SELECT_CALLEDCOUNTRY  @"\nSelect country."
#define ALERT_MESSAGE_ENTER_TELEPHONE       @"\nEnter telephone number."
#define ALERT_MESSAGE_ENTER_DATEOFPURCHASE  @"\nEnter purchase date."
#define ALERT_MESSAGE_ENTER_PURCHASEDWHERE  @"\nEnter purchase location."
#define ALERT_MESSAGE_ALREADYLOGIN          @"HDA Cloud has detected that your account already exists."
#define ALERT_MESSAGE_TROUBLECONNECTING     @"Rescan for device?"
#define ALERT_MESSAGE_ENTER_AUDIOIPADDRESS  @"\nDevice AUDIO IP address.\n"
#define ALERT_MESSAGE_ENTER_GROUPNAME       @"\nEnter audio group name."
#define ALERT_MESSAGE_SELECT_GROUPDEVICE    @"\nYou must select at least 2 devices."
#define ALERT_MESSAGE_FILENOTFOUND          @"\nuControl is having trouble getting the correct data from your system.\n"
#define ALERT_MESSAGE_APINOTFOUND           @"\nuControl is sending commands to your device which are not being understood. Please make sure that Device-OS is version 8 or higher or contact support@hdanywhere.com for assistance.\n"

#define ALERT_BTN_TITLE_OK          @"OK"
#define ALERT_BTN_TITLE_CANCEL      @"Cancel"
#define ALERT_BTN_TITLE_YES         @"Yes"
#define ALERT_BTN_TITLE_NO          @"No"
#define ALERT_BTN_TITLE_UPDATE      @"Update"
#define ALERT_BTN_TITLE_RETRY       @"Retry"
#define ALERT_BTN_TITLE_CONTINUE    @"Continue"
#define ALERT_BTN_TITLE_GOBACK      @"Go Back"
#define ALERT_BTN_TITLE_RESTORE @"RESTORE"
#define ALERT_BTN_TITLE_EXIT          @"EXIT"

    //MARK: Hub messages while connection
#define HUB_CONNECTING                  @"Connecting..."
#define HUB_SUCCESS                     @"uControl has successfully connected to your system."
#define HUB_REMOVEUCONTROL_CONFIRMATION @"Remove this device from uControl?"
#define HUB_RESYNCUCONTROL_CONFIRMATION @"Resync uControl with your system?"
#define HUB_RESTART_MHUBSYSTEM 			@"Restart process?"

#define HUB_LOADING                     @"Loading..."
#define HUB_TROUBLECONNECTING           @"uControl is having trouble connecting to your system, please check your network settings or try again later."

#define HUB_SELECTEDDEVICE                  @"Please select a device."
#define HUB_NOSLAVEDEVICES                  @"Unable to connect, there is no slave or secondary device connected."
#define HUB_FIRSTTIMESETUP_HEADER           @"Initial setup."
#define HUB_FIRSTTIMESETUP_MESSAGE          @""
#define HUB_LANDINGPAGE_MESSAGE             @"Seamless Entertainment Discreet Technology"

#define HUB_MHUBFOUND_HEADER                @"Device(s) found."
#define HUB_MHUBFOUND_MESSAGE               @"uControl has found the following devices(s) on your network..."
#define HUB_NOTSETUP_HEADER                 @"uControl has detected that your system has not been setup."
#define HUB_NOTSETUP_MESSAGE                @"uControl has detected that your system has not gone through its first boot process. Your system must be configured before you can use uControl."
#define HUB_NOTSETUP_BUTTON                 @"Setup Device."

#define HUB_UNABLETOFIND_HEADER             @"Unable to establish a connection."
#define HUB_UNABLETOFIND_MESSAGE            @"uControl was unable to connect to your device. Please check your network settings and ensure that your device is wired to your network. uControl must be on the same network as your device in order to connect to it."
#define CONNECT_TO_HDA_DEVICE            @"Connect to HDANYWHERE Device"
#define HUB_ATTEMPTINGTOPAIRWITHMHUB_HEADER     @"Attempting to pair with your device."
#define HUB_ATTEMPTINGTOPAIRWITHMHUB_MESSAGE    @"uControl is attempting to connect to your device to sync all data and settings.\nPlease be patient as this process can take up to 1 minute to complete."

#define HUB_UNABLETOCONNECT_MESSAGE             @"uControl is having difficulty connecting to your device. The last known address was %@.\n\n Would you like uControl to rescan for your device?"

#define APP_UPDATE_MESSAGE             @"uControl has been updated with the latest features from HDANYWHERE. You will need to reconnect to your device system to complete setup."
#define APP_NO_GROUP_MESSAGE  @"There is no group available for this device."
#define HUB_ADVANCEMOSUPDATE_HEADER @"Advance Device Options"
#define HUB_UPDATING_HEADER @"Device is Updating"
#define HUB_UPDATED_HEADER @"Device is updated"
#define HUB_UPDATE_COMPLETED @"Update Completed"

#define HUB_ADVANCEMOSUPDATE_MESSAGE @"Advance options for device can be found here."
#define HUB_ADVANCEMOSUPDATE_MESSAGE_WARNING_MERGED @"Advance options for device can be found here.\n\nWARNING: Proceed only\n if you know what you are doing or have been instructed by HDANYWHERE staff as you can damage your system."
#define HUB_ADVANCEMOSUPDATE_WARNING @"WARNING: Proceed only\n if you know what you are doing or have been instructed by HDANYWHERE staff as you can damage your system."
#define HUB_UPDATING_MESSAGE @"Please do not touch or power down\nyour device as it is performing an update."
#define HUB_RETURNTOUCONTROL_BUTTON @"RETURN TO UCONTROL"
#define HUB_IS_UPDATING @"Your update is installing. Please hold until the update is complete.\nPlease do not power down or interact with device whilst the update installs."

#define HUB_UNABLETOCONNECT_SHORT_MESSAGE       @"uControl is having difficulty connecting to your device. The last known address was %@."

#define HUB_CONNECTED_HEADER                    @"Connected."
#define HUB_CONNECTED_MESSAGE                   @"uControl is now paired to your system."
#define HUB_CONNECTED_BUTTON                    @"Complete setup."
#define HUB_ADDMANUALLY_HEADER                  @"Connect Manually"
#define HUB_ADDMANUALLY_MESSAGE                 @"If you know the correct IP address for your device then you can connect to it manually.\n\nSelect which type of system you want to connect to..."

#define HUB_CLOUDREGISTRATION_MESSAGE   		@"Register this device within 30 days of purchase and extend your warranty by 1 year."

#define HUB_MULTIPLESERIALNO_MESSAGE    		@"There are %ld device system(s) registered to this account. Which system would you like to download data for?"
#define HUB_APPUPDATE_MESSAGE           		@"Please update to the latest version of uControl."
#define HUB_MOSUPDATE_MESSAGE           		@"Please update your %@ with the latest version of Device-OS."
#define HUB_MOSUPDATE_WARNING_TERMSANDCONDITION                   @"WARNING: You can not exit this process after it has started.\nDO NOT power down your device during this process and ensure that no one is interacting with device."
#define HUB_MOSUPDATE_MESSAGE_Without_Model  @"To continue using uControl with device, please update Device-OS to the latest version.\n\nThis update can take up to 5 minutes to complete. Once started, you can not exit this process."
#define HUB_MOSUPDATE_MESSAGE_Without_Model_With_NoticeTitle_Bold  @"Notice\nTo continue using uControl with device, please update Device-OS to the latest version."
#define HUB_REMOVEGROUPMESSAGE  @"Are you sure you want to delete this group?"
#define HUB_NO_ZONE_CREATE_GROUP  @"All zones belong to other audio groups. You can not create a new group at this time."
#define HUB_RESTORE_HUB_WARNING                   @"WARNING: You can not undo this process."
#define HUB_RESTORE_HUB_WARNING_Message_Header                   @"You are about to restore your device back to factory settings.This will remove all user data, all HDA cloud information and any configuration settings."

#define CONNECT_BACK_TO_ROUTER_SSID_MESSAGE                   @"If everything has gone well then you should move automatically back to %@ [it should be router ssid]"
#define CONNECTED_SSID_NAME_KEY  @"CONNECTEDSSID"

#define ALERTMESSAGE_INPUTSHIDDEN @"It looks like all your device inputs are hidden from uControl. Access your HDA device and enable the input(s) you want to show by checking the box."
#define ALERTMESSAGE_SOMETHINGWENTWRONG @"Your system is now rebooting. Do not interact or power down the system for 2 minutes."
#define HUB_RESTORE_HUB_Success_Message                   @"Your device has been restored back to manufacturer defaults."

#define HUB_Notice                          @"Notice"
#define HUB_RESYNCUCONTROL_MHUBOS           @"Resync uControl with device."
#define HUB_RESYNCUCONTROL_HDACLOUD         @"RESYNC uControl with HDA Cloud."
#define HUB_RESYNCUCONTROL_DEVICE           @"RESYNC uControl with \"%@\""
#define HUB_RESYNC_SYSTEM                   @"RESYNC SYSTEM"


#define HUB_MHUBSYSTEM                      @"Device"
#define HUB_NAMEANDIPADDRESS                @"Master\n%@: %@ [%.2f]" // [NAME] [IP ADDRESS]
#define HUB_PAIREDNAMEANDIPADDRESS          @"Paired\n%@: %@ [%.2f]" // [NAME] [IP ADDRESS] (UP TO X2 MAXIMUM CHILD MHUB)
#define HUB_WITHOUT_PAIREDNAMEANDIPADDRESS          @"%@: %@ [%.2f]" // [NAME] [IP ADDRESS] (UP TO X2 MAXIMUM CHILD MHUB)
#define HUB_NAMEANDIPADDRESS_STANDALONE                @"%@: %@ [%.2f]" // [NAME] [IP ADDRESS]
#define HUB_PAIREDNAMEANDIPADDRESS_STANDALONE          @"%@: %@ [%.2f]" // [NAME] [IP ADDRESS] (UP TO X2 MAXIMUM CHILD MHUB)
#define HUB_ACCESSMHUBOS                    @"System Settings"
#define HUB_ACCESSSYSTEM                    @"Access System"
#define HUB_MANAGEUCONTROLPACKS             @"Manage uControl Packs"
#define HUB_MANAGESEQUENCES                 @"Manage Sequences"
#define HUB_MANAGEAUDIOINPUTS                 @"Manage Device Audio Inputs"
#define HUB_MANAGEZONESOURCELABELS          @"Manage zone / source labels"
#define HUB_ZONELABELS                      @"Zone labels"
#define HUB_SOURCELABELS                    @"Source labels"
#define HUB_REMOVE_THIS_MHUB                @"Remove System"
#define HUB_ADVANCE_UPDATE_MOS              @"ADVANCED"
#define HUB_SETUP_MISMATCH                  @"Setup Mismatch"
#define HUB_SOFTWARE_MISMATCH               @"Software Mismatch"
#define HUB_SYSTEM_CONFIGURED               @"System Configured"
#define HUB_HDACLOUD_HEADER                 @"HDA Cloud"
#define HUB_CREATEHDACLOUDACCOUNT           @"Create a HDA Cloud account"
#define HUB_BACKUPUCONTROLTOHDACLOUD        @"Backup uControl"
#define HUB_BACK                            @"Back"
#define HUB_INTERFACE                       @"Interface"
#define HUB_GENERAL                         @"General"
#define HUB_GROUPS                          @"Groups"
#define HUB_Utilities                         @"Utilities"

#define HUB_RESYNC                          @"Resync"
#define HUB_POWER                           @"Power"
#define HUB_DEVICEOS                        @"Access Device OS"
#define HUB_UCONTROLPACKS                   @"uControl Packs"
#define HUB_SEQUENCES                       @"Sequences"
#define HUB_UPDATE                          @"Update"
#define HUB_RESET                           @"Reset"
#define HUB_REMOVESYSTEM                           @"Remove System"

#define HUB_APPERANCE                           @"Appearance"
#define HUB_SOUNDVIBRATION                           @"Sounds & Vibration"
#define HUB_ABOUTUCONTROL                           @"About uControl"







#define HUB_UCONTROLSETTINGS                @"uControl settings"
#define HUB_UCONTROL                        @"uControl"
#define HUB_DISPLAYSETTINGS                 @"Display settings"
#define HUB_ZONEBACKGROUNDIMAGE             @"Zone background image"
#define HUB_THEMES                          @"Themes"
#define HUB_ADDITIONALCUSTOMISATION         @"Additional customisation"
#define HUB_MENUSETTINGS                    @"Menu settings"
//#define HUB_MANAGEZONES                     @"zones(Show/Hide)"
#define HUB_MANAGEZONES                     @"Manage Zones"
#define HUB_SETAPPQUICKACTIONS              @"Setup Quick Actions"
#define HUB_MANAGEQUICKACTIONS              @"Manage Quick Actions"
//#define HUB_MANAGESOURCEDEVICES             @"source devices(Show/Hide)"
#define HUB_MANAGESOURCEDEVICES             @"Show/Hide Device Inputs"
#define HUB_BUTTONBORDERS                   @"Borders and appearance" // [TOGGLE Y/N]
#define HUB_BUTTONVIBRATION                 @"Vibration settings" // [TOGGLE Y/N]
#define HUB_AUDIOGROUPS                     @"Audio groups"
#define HUB_BUTTONSENDREPORTORBUG           @"Report a bug or problem" // [TOGGLE Y/N]
#define HUB_CONNECTINGTOMHUBOS              @"Connecting to Device-OS, this can take up to 30 seconds"
#define CEC_SETTINGS           @"Cec Settings" // [TOGGLE Y/N]
#define CEC_VIEW                            @"CEC View"
#define CEC_UI                              @"CEC UI"
#define CEC_POWER                           @"CEC Power"
#define CEC_VOLUME                          @"CEC Volume"
//MARK: New
#define HUB_SEARCHING_NETWORK_HEADER        @"Searching Network"
#define HUB_MULTIPLE_MHUB_FOUND_HEADER      @"Multiple Devices Discovered"
#define HUB_BUILDING_A_STACKED_SYSTEM      @"Building a Stacked System"
#define HUB_CONNECTION_OPTIONS_HEADER       @"Connection Options"
#define HUB_SELECT_SYSTEM_HEADER            @"Select System"
#define HUB_SELECT_DEVICE_HEADER            @"Select Device"
#define HUB_SELECT_PRIMARY_SYSTEM_HEADER    @"Select Primary Controlling Device"
#define HUB_SELECT_SECONDARY_SYSTEM_HEADER  @"Select Secondary Device(s)"
#define HUB_SETUP_COMPLETE_HEADER           @"Setup Complete"
#define HUB_START_SETUP    @"Start Setup"
#define HUB_MHUB_ALREADY_CONFIGURED_HEADER  @"Your device is already configured"
#define HUB_MHUB_ALREADY_PAIRED_HEADER      @"uControl is already paired to your device."
#define HUB_UPDATE_REQUIRED                 @"Update Required"
#define HUB_UPDATE_IS_AVAILABLE             @"Update is Available"
#define HUB_CHECKING_FOR_UPDATES            @"Checking For Updates"
#define BUILDING_A_STACKED_SYSTEM           @"Building a stacked system"
#define SELECT_MASTER_CONTROLLER           @"Select Master Controller"
#define ARRANGE_YOUR_VIDEO_DEVICES           @"Arrange your video devices"
#define CONFIRM_DEVICE_ORDER           @"Confirm device order"
#define NAME_EACH_DEVICE           @"Name each device"
#define CONTINUE_UOS           @"Continue on uOS"
#define REBOOT_MASTER_CONTROLLER           @"Reboot your Master Controller"

#define SELECT_MASTER_CONTROLLER_HEADER_Message           @"The Master Controller manages your system."
#define OTHER_DEVICES @"Other devices"

#define COMBINE_MULTIPLE_DEVICES                     @"Combine multiple devices to create one larger system."
#define ARRANGE_YOUR_VIDEO_DEVICES_HEADER_Message           @"Add your video devices to your stack."
#define ARRANGE_YOUR_VIDEO_DEVICES_SUBHEADER_Message           @"Tap on the empty slot(s) below to assign a HDA video device to them. Start by assigning the Foundation Layer. This is the HDA device which is typically connected to your video sources.\n\nIf you make a mistake then swipe the slot from right to left to remove it."
#define ARRANGE_YOUR_AUDIO_DEVICES_HEADER_Message           @"Add the other devices found in your scan."
#define ARRANGE_YOUR_AUDIO_DEVICES_SUBHEADER_Message           @"Tap on the empty slot(s) below to assign a device to them. These devices do not need any specific ordering but do need to be added below if they are to be included in your Stacked System.\n\nIf you make a mistake then swipe the slot from right to left to remove it."
#define CONFIRM_DEVICE_ORDER_HEADER @"Your system is almost ready for configuring."
#define CONFIRM_DEVICE_ORDER_HEADER @"Your system is almost ready for configuring."
#define NAME_EACH_DEVICE_HEADER @"Give each device in your system a name to identify it easily."
#define CONTINUE_UOS_HEADER           @"Your Stacked System is ready for configuring."
#define CONTINUE_UOS_SUBHEADER_Message           @"uControl will take you to uOS on your Master Controller to complete the setup process and finish configuring your system."
#define SELECT_MASTER_CONTROLLER_SUBHEADER_Message           @"uControl has detected multiple devices which can act as your Master Controller. Start the stacking process by selecting your Master Controller."


#define HUB_SELECT_STACKED_SYSTEM           @"Select Stacked System"
#define HUB_UPDATE_IS_UPTODATE              @"Device is Up to Date"
#define HUB_UPDATE_TERMSNCONDITION          @"Legal Terms"
#define HUB_SOFTWARE_BENCHMARK              @"Software Benchmark"
#define HUB_RESTORE_MHUB                    @"Restore Device"
#define HUB_MHUB_RESET_SUCCESSFUL           @"Device Reset Successful"
#define HUB_UNABLE_TO_AUTOMATICALLY_CONNECT @"Unable to Automatically Connect"
#define HUB_AVAILABLE_SYSTEMS               @"Available System(s)"
#define HUB_UPDATE_SYSTEM               @"Update System"
#define HUB_RESET_SYSTEM               @"Reset System"
#define HUB_SOFTWARE_BENCHMARK_PLACEHOLDER_TEXT               @"Software benchmark details will be shown when you'll have a active internet connection"



#define HUB_SETUP_COMPLETE_BUTTON           @"Access uControl"
#define HUB_SETUP_COMPLETE_BUTTON_New           @"COMPLETE"
#define HUB_CONTINUE_SETUP_ON_Device    @"Continue Setup on Device"
#define HUB_MULTIPLE_MHUB_SETUP_HEADER      @"Your system has already been configured"

//#define HUB_CONNECT_MANUALLY_HEADER                 @"Connect manually"

#define HUB_CONNECT_MANUALLY_HEADER                   @"Manually Connect"
#define HUB_CONNECT_ADVANCE_OPTIONS                   @"Advance Options"
#define ADVANCED                                        @"Advanced"
#define HUB_CONNECT_MANUALLY_WARNING_HEADER           @"WARNING - PLEASE READ!"
#define HUB_CONNECT_MANUALLY_PAGE_DESCRIPTION         @"Menu for direct connection and advanced management of systems."



//#define HUB_MULTIPLE_MHUB_FOUND_MESSAGE @"We have detected a number of different MHUB devices on your network.What type of MHUB system do you wish to create?"

//#define HUB_MULTIPLE_MHUB_FOUND_MESSAGE             @"Select the type of MHUB system you would like to create?"
#define HUB_MULTIPLE_MHUB_FOUND_MESSAGE             @"uControl has detected multiple devices on this network which can be setup in multiple ways."

#define HUB_CONNECTION_OPTIONS_VIDEO_MESSAGE        @"Video distribution"
#define HUB_CONNECTION_OPTIONS_AUDIO_MESSAGE        @"Audio distribution"
#define HUB_CONNECTION_OPTIONS_VIDEOAUDIO_MESSAGE   @"Video + Audio distribution"
#define HUB_UPDATE_MESSAGE                          @"Your device will require an update to work with this version of uControl."
#define HUB_UPDATE_MESSAG_SubHeading                          @"You will not be able  to use uControl until your device has been updated."
#define HUB_UPDATE_AVAILABLE_MESSAGE                @"There is an update available for your device."
#define HUB_UPDATE_AVAILABLE__SUBHEADING                @"Your device will update from  %.02f to %@"
#define HUB_MHUB_ALREADY_CONFIGURED_MESSAGE         @"The primary device you have selected has already been configured. If you proceed all existing data will be removed from device."
#define HUB_MHUB_ALREADY_PAIRED_MESSAGE             @"The device(s) in the list below are reporting that they belong to a previously configured system. If you proceed all existing data will be removed from all devicess)."
#define HUB_CONNECT_MANUALLY_SETUP_MESSAGE          @"If you know the correct IP address for your device then you can connect to it manually.\n\nBefore proceeding, are you connecting to an existing system or creating a new system?"
#define HUB_CONNECT_MANUALLY_WARNING_MESSAGE        @"This process will remove any pre-configured data and will reset your device. Are you sure you want to proceed?"
#define HUB_UP_TO_DATE_MESSAGE @"There are no updates for your system. You are up to date."
#define HUB_HOLD_MESSAGE_FOR_CHECKING_UPDATE @"Please hold whilst we check with device & HDA Cloud for any updates."
#define HUB_SETUP_MISMATCH_MSG @"uControl has detected multiple devices on your network. One or more of these devices have not been through their first boot proccess.\n\nAs a result, uControl can not determine which device it should automatically connect to.\n\nIf you want to configure your systems in to a stack then you will need to reset one or more of your devices before proceeding. This can be done from the “Connect Manually” option in the main menu."
#define HUB_SOFTWARE_MISMATCH_MSG @"uControl has detected multiple devices on your network. One or more of these devices do not meet the minimum software requirement to work with uControl.\n\nTo connect to a single device you will need to return to the main menu and connect manually.\n\nTo connect automatically to any device, all systems must be updated to Device-OS 8 or higher.This can be achieved by accessing the main menu and forcing Device to update."
#define HUB_UNABLE_TO_AUTO_CONNECT_MESSAGE @"uControl is unable to detect or determine how to connect to your system.\n\nPlease ensure that all devices are powered on and are connected to your local network.\n\nIf you keep seeing this page then try connecting directly manually to device to diagnose any issues."
#define HUB_CONNECT_MANUALLY_DEVICE_TYPE_MESSAGE        @"What device type are you connecting to?"
#define HUB_CONNECT_MANUALLY_IPADDRESS_MESSAGE          @"Enter the IP address."
#define HUB_CONNECT_MANUALLY_IPADDRESS_MESSAGE_update          @"Enter the IP address of your device."
#define HUB_TERMS_CONDITION_Heading          @"You must agree to proceed with update."
#define HUB_TERMS_CONDITION_SubHeading          @"This update requires that you agree to the terms in the following documents. You can not proceed with the update unless you agree to the terms in this documents."
#define COMBINE_MULTIPLE_DEVICES_Message                     @"uControl has the ability to combine your HDA devices into one larger system. This process is called Stacking.\n\nuControl can walk you through the setup process but it will not tell you how to physically connect your devices together. If you have not set up a Stacked System before then it is recommended that you read our Stacking Guide by tapping on the HELP option below.\n\nSetting up a Stacked System can not be undone. If your configuration is incorrect then you will need to restart this process by restoring each device back to its factory settings."



#define HUB_CONNECT_MANUALLY_PRIMARY_DEVICE_MESSAGE     @"Select a master (primary) device."
#define HUB_CONNECT_MANUALLY_SECONDARY_DEVICE_MESSAGE   @"Select slave (secondary) device(s)."

#define HUB_SETUP_A_NEW_MHUB_SYSTEM                 @"Setup a new system"
//#define HUB_CONNECT_TO_AN_EXISTING_MHUB_SYSTEM    @"Connect to an existing MHUB system"
//#define HUB_CONNECT_TO_AN_EXISTING_MHUB_SYSTEM      @"Connect to MHUB system"
#define HUB_CONNECT_TO_AN_EXISTING_MHUB_SYSTEM      @"Connect to System"

#define HUB_MANUALLY_CONNECT_FIND_DEVICES           @"FIND DEVICES"
#define HUB_CONNECT_REQUEST_SOFTWARE_BENCHMARK      @"REQUEST HDA SOFTWARE BENCHMARK"
#define HUB_FORCE_MHUB_UPDATE                       @"UPDATE"
#define HUB_CONNECT_NEW_SYSTEM                      @"Setup Device"
#define SETUP_MHUB                                  @"Setup Device"

#define HUB_CONNECT_RESET_MHUB                      @"RESET SYSTEM"
#define HUB_CONFIGURE_WIFI_DEVICE                   @"CONFIGURE WIFI DEVICE"
#define HUB_CONFIGURE_WIFI_SETUP                    @"WiFi Setup"
#define HUB_NO_MHUB_WIFI_FOUND                      @"No wifi device found. please try again later."
#define HUB_SET_AP_MODE_SCREEN_MESSAGE1             @"Please hold whilst we set your HDANYWHERE device in AP mode.\n\nIf everything has gone well then device %@ will be set to AP mode"
#define HUB_SET_AP_MODE_SCREEN_MESSAGE2             @"Please check that Discovery Mode indicator light on your device has started flashing."
#define WIFI_Settings_Instruction @"Go to the WiFi settings on your iOS device and select the HDANYWHERE system you wish to connect to.\nThe SSID/Wifi name will be in the following format -\nHDA-XXXXXXX-XXXX\nWiFi password is\nhdanywhere"
#define Joining_WiFi_Network @"Joining WiFi Network"
#define wifiConnectionWithRouter @"Your device is attempting to connect to your WiFi."
#define WIFI_Joining_Network @"Please wait whilst your HDA device connects to your WiFi. This process can take several minutes. During this time the power LED will stop flashing and become solid."
#define Connect_to_wifi @"Select WiFi to Join"
#define WIFI_DETECTED @"Your HDANYWHERE system can be connected to the following WiFi networks.\nPlease choose which you want it connected to"
#define Connected_WIFI @"You are now connected to the following device."
#define configure_wifi @"Configure WiFi Device"
#define enable_discovery_mode @"Enable Discovery Mode."
#define WIFI_ETHERNET_CABLE_CONNECTED @"Ensure the Ethernet cable is connected."
#define WIFI_ENABLE_DISCOVERY_MODE @"Discovery Mode can only be enabled on this device when it is connected via an Ethernet cable."
#define WIFI_Discovery_Mode_Msg @"Please check your user manual for instructions to enable Discovery Mode. uControl is detecting that your device is not in Discovery Mode."
#define IMPORTANT @"Important!"
#define DISCOVERY_MODE @"Discovery Mode"
#define WIFI_POWER_LED_SHOULD_FLASHING @"The power LED should be flashing."
#define WIFI_POWER_LED_SHOULD_FLASHING_msg @"The power LED on your device should now be flashing. This indicates that your device is now in Discovery Mode and ready for WiFi configuration."
#define REMOVE_ETHERNET_CABLE @"Remove the Ethernet Cable"
#define REMOVE_ETHERNET_CABLE_FROM_DEVICE @"Remove the Ethernet cable from your device."
#define REMOVE_ETHERNET_CABLE_FROM_DEVICE_MSG @"Your device is able to get network information from WiFi and Ethernet. To ensure that this doesn't happen it is recommended that the Ethernet cable is removed."

#define Scan_Network_heading @"Connect device to your WiFi network."
#define Scan_Network_subHeading @"Select the WiFi network that you would like to join from the list below."

#define PERFORMING_CHECKS @"Performing checks"
#define PERFORMING_CHECKS_WIFI_CONNECTED_heading @"Important! Before proceeding, check to see if your mobile phone or tablet has returned back to your normal WiFi network."
#define PERFORMING_CHECKS_WIFI_CONNECTED_subHeading @"Your mobile phone or tablet will have disconnected from the HDA WiFi network and should have returned back to your normal WiFi network."
#define PERFORMING_CHECKS_WIFI_CONNECTED_subHeading2 @"If you are still connected to the HDA WiFi hotspot at this stage then it may suggest that something went wrong."

#define SWITCH_TO_WIFI_HOTSPOT @"HDA WiFi Network"
#define SWITCH_TO_WIFI_HOTSPOT_heading @"Connect your mobile or tablet to the HDA WiFi network."
#define SWITCH_TO_WIFI_HOTSPOT_MSG @"Browse the available WiFi networks on your mobile phone or tablet and look for a WiFi network starting with \"HDA\".When prompted enter the following password:"

#define WIFI_DEVICE_CONNECTED @"Device Connected"
#define WIFI_DEVICE_CONNECTED_heading @"Your device is now connected to your WiFi network."
#define WIFI_DEVICE_CONNECTED_subHeading @"You can connect to this system in uControl as normal."
#define WIFI_Discovery_Mode_Msg2 @"Please check your user manual for instructions to enable Discovery Mode. This could be a button press or something that you have to enable from the device's OS."
#define WIFI_Discovery_Mode_Msg3 @"The power LED should be flashing."
#define Wifi_select_the_device @"Select the device to join your network."
#define Wifi_find_the_device @"uControl found the following device(s):"

#define Wifi_Error_E1 @"Discovery Mode Error"
#define Wifi_Error_E1_Heading @"There was an error enabling Discovery Mode."
#define Wifi_Error_E1_subHeading @"Make sure that your HDA device is connected to the network and has an IP address which can be reached."
#define Wifi_Error_E2 @"Unable to Reach Device"
#define Wifi_Error_E2_Heading @"Ensure that you're connected to the device hotspot."
#define Wifi_Error_E2_subHeading @"uControl attempted to connect to your device but didn't get an expected response. Please double check that your phone or tablet is connected to the HDA WiFi hotspot and try again."
#define Wifi_Error_E3 @"Error Contacting Device"
#define Wifi_Error_E3_Heading @"uControl encountered an error."
#define Wifi_Error_E3_subHeading @"Your WiFi netwrok details were not sent to your device. If your power LEDs are still flashing then your device remains in Discovery Mode. Ensure that your password is correct and try again."

#define Wifi_Error_Final @"There was an Error"
#define Wifi_Error_Final_Heading1 @"Check that you're connected to the device hotspot."
#define Wifi_Error_Final_subHeading1 @"Ensure that you are connected to the HDA device WiFi hotspot."

#define Wifi_Error_Final_Heading2 @"Double check that your SSID password is correct."
#define Wifi_Error_Final_subHeading2 @"Ensure that the password for your WiFi network is correct."

#define Wifi_Error_Final_Heading3 @"You will have to wait several minutes."
#define Wifi_Error_Final_subHeading3 @"Your device will revert back to Ethernet mode and your power LED will stop flashing. This will take several minutes. Once that has reverted you can restart the WiFi connection process again."


#define HUB_ENTER_DEMO_MODE_old                     @"Access uControl in demo mode"
#define HUB_ENTER_DEMO_MODE                         @"ENTER DEMO MODE"
#define HUB_ADD_ANOTHER_SLAVE                       @"Add another device"

#define HUB_RETURN_TO_CONNECTION_OPTIONS            @"Return to connection options"
#define HUB_CONTINUE_WITH_SETUP                     @"Continue with setup"
#define HUB_RETURN_TO_MANUAL_CONNECTION             @"Return to manual setup"

#define HUB_DEVICE_IS_READY_TO_USE              @"Device is now ready to use in uControl"
#define HUB_DEVICE_IS_READY_TO_USE_WITH_MODELNAME @"%@ device is now ready to use in uControl"



//MARK: OLD SETTING MENU
#define HUB_ACCESSMHUBDASH          @"ACCESS Device"
#define HUB_ACCESSMHUBDASHUCONTROL  @"DOWNLOAD UCONTROL PACKS"
#define HUB_BACKUPHDACLOUD          @"BACKUP DATA TO HDA CLOUD™"
#define HUB_CONNECTHDACLOUD         @"CONNECT TO HDA CLOUD™"
#define HUB_QUICKSYNCHDACLOUD       @"QUICK SYNC WITH HDA CLOUD™"
#define HUB_CREATEHDACLOUDACCOUNT   @"CREATE HDA CLOUD™ ACCOUNT"

#define HUB_LABELS_HEADER           @"SOURCE/ROOM/DISPLAY LABELS"
#define HUB_DISPLAYLABELS           @"DISPLAY/ROOM LABELS"
#define HUB_SOURCELABELS            @"SOURCE LABELS"

#define HUB_HDACLOUD_HEADER         @"HDA CLOUD™"
#define HUB_REGISTERCLOUD           @"REGISTER CLOUD™"
#define HUB_LOGINCLOUD              @"LOGIN CLOUD™"
#define HUB_BACKUPTOCLOUD           @"BACKUP TO CLOUD™"
#define HUB_SYNCWITHCLOUD           @"SYNC WITH CLOUD™"
#define HUB_VALIDATESERIALNUMBER    @"VALIDATE SERIAL NUMBER"

#define HUB_SelectDifferentProfile    @"You are connected with same device,Please select a different device to connect with."


//MARK: Image
#define kImageIconNO                 [UIImage imageNamed:@"icon_no"]
#define kImageIconYES                 [UIImage imageNamed:@"icon_yes"]
#define kImageIconWarning                 [UIImage imageNamed:@"icon-warning"]
#define kImageCheckMark                 [UIImage imageNamed:@"HDA_icon_checkmark"]
#define kImageShadowThemeBlack          [UIImage imageNamed:@"HDA_shadow_theme_black"]
#define kImageShadowThemeWhite          [UIImage imageNamed:@"HDA_shadow_theme_white"]
#define kImage_HDA_icon_setup_done_small  [UIImage imageNamed:@"HDA_icon_setup_done_small"]
#define kImageHDALogo                   [UIImage imageNamed:@"HDA_logo"]
#define kImageIconNavBack               [UIImage imageNamed:@"HDA_icon_nav_back"]
#define kImageIconBackArrow               [UIImage imageNamed:@"backArrow1"]
#define kImageIconDownArrow               [UIImage imageNamed:@"down-arrow-white"]
#define kImageIconNextArrow               [UIImage imageNamed:@"next-arrow-white"]


 
#define kImageIconPowerMain             [UIImage imageNamed:@"HDA_icon_power_main"]
#define kImageIconPowerExplicitBlue     [UIImage imageNamed:@"icon-power-explicit-method"]

//#define kImageIconPowerClearColor             [UIImage imageNamed:@"icon_color_powertoggle"]
#define kImageIconPowerClearColor       [UIImage imageNamed:@"power_toggle_new"]
#define kImageIconPowerClearColor_New   [UIImage imageNamed:@"power_toggle_new2"]
#define kImageIconSettings              [UIImage imageNamed:@"HDA_icon_setting_gray"]
#define kImageIconIREnabled             [UIImage imageNamed:@"HDA_icon_ir_enabled"]
#define kImageIconSequence              [UIImage imageNamed:@"HDA_icon_sequence"]
#define kImageIconNoSourceWhite         [UIImage imageNamed:@"HDA_icon_no_source"]
#define kImageIconNoSourceDarkGray      [UIImage imageNamed:@"HDA_icon_no_source_darkgray"]

#define kImageIconGestureWhite          [UIImage imageNamed:@"gesture_white"]
#define kImageIconNumericWhite          [UIImage imageNamed:@"numeric_white"]
#define kImageIconNavigationWhite       [UIImage imageNamed:@"navigation_white"]
#define kImageIconPlayheadWhite         [UIImage imageNamed:@"playhead_white"]
#define kImageIconCustomWhite           [UIImage imageNamed:@"custom_white"]

#define kImageIconGestureLightGray      [UIImage imageNamed:@"gesture_lightgray"]
#define kImageIconNumericLightGray      [UIImage imageNamed:@"numeric_lightgray"]
#define kImageIconNavigationLightGray   [UIImage imageNamed:@"navigation_lightgray"]
#define kImageIconPlayheadLightGray     [UIImage imageNamed:@"playhead_lightgray"]
#define kImageIconCustomLightGray       [UIImage imageNamed:@"custom_lightgray"]


#define kImageIconTVWrapper             [UIImage imageNamed:@"icon_tv_wrapper"]
#define kImageIconTVDisplay             [UIImage imageNamed:@"icon_tv_display"]
#define kImageIconTVSpeakerDisplay      [UIImage imageNamed:@"icon_tv_speaker_display"]

#define kImageIconTVAVR                 [UIImage imageNamed:@"icon_tv_avr"]
#define kImageIconTVMute                [UIImage imageNamed:@"icon_tv_mute"]

#define kImageIconTVAUDIO               [UIImage imageNamed:@"icon_tv_audio"]
#define kImageIconAudioSlider           [UIImage imageNamed:@"icon_tv_slider"]
#define kImageIconAudioSliderEnd        [UIImage imageNamed:@"icon_tv_slider_end"]
#define kImageIconAudioSliderEndGray    [UIImage imageNamed:@"icon_tv_slider_end_gray"]

#define kImageIconAudioSonos            [UIImage imageNamed:@"icon_tv_sonos"]

#define kImageIconAudioMuteActive       [UIImage imageNamed:@"icon_audio_mute_active"]
#define kImageIconAudioMuteInActive     [UIImage imageNamed:@"icon_audio_mute_inactive"]
#define kImageIconAudioPaired           [UIImage imageNamed:@"icon_audio_paired"] 

#define kImageIconAudioMuteActiveGray   [UIImage imageNamed:@"icon_light_audio_mute_active"]
#define kImageIconAudioMuteInActiveGray [UIImage imageNamed:@"icon_light_audio_mute_inactive"]
#define kImageIconAudioPairedGray       [UIImage imageNamed:@"icon_light_audio_paired"]

//MARK: NEW
#define kImageIconSetupVideoCarbonite           [UIImage imageNamed:@"HDA_icon_setup_video_carbonite"]
#define kImageIconSetupAudioCarbonite           [UIImage imageNamed:@"HDA_icon_setup_audio_carbonite"]
#define kImageIconSetupVideoAudioCarbonite      [UIImage imageNamed:@"HDA_icon_setup_video_audio_carbonite"]
#define kImageIconSetupVideoSmallCarbonite      [UIImage imageNamed:@"HDA_icon_setup_video_small_carbonite"]
#define kImageIconSetupAudioSmallCarbonite      [UIImage imageNamed:@"HDA_icon_setup_audio_small_carbonite"]
#define kImageIconSetupVideoAudioSmallCarbonite [UIImage imageNamed:@"HDA_icon_setup_video_audio_small_carbonite"]
#define kImageIconSetupVideoLargeCarbonite      [UIImage imageNamed:@"HDA_icon_setup_video_large_carbonite"]
#define kImageIconSetupAudioLargeCarbonite      [UIImage imageNamed:@"HDA_icon_setup_audio_large_carbonite"]
#define kImageIconSetupVideoAudioLargeCarbonite [UIImage imageNamed:@"HDA_icon_setup_video_audio_large_carbonite"]

#define kImageIconSetupVideoSnow                [UIImage imageNamed:@"HDA_icon_setup_video_snow"]
#define kImageIconSetupAudioSnow                [UIImage imageNamed:@"HDA_icon_setup_audio_snow"]
#define kImageIconSetupVideoAudioSnow           [UIImage imageNamed:@"HDA_icon_setup_video_audio_snow"]
#define kImageIconSetupVideoSmallSnow           [UIImage imageNamed:@"HDA_icon_setup_video_small_snow"]
#define kImageIconSetupAudioSmallSnow           [UIImage imageNamed:@"HDA_icon_setup_audio_small_snow"]
#define kImageIconSetupVideoAudioSmallSnow      [UIImage imageNamed:@"HDA_icon_setup_video_audio_small_snow"]
#define kImageIconSetupVideoLargeSnow           [UIImage imageNamed:@"HDA_icon_setup_video_large_snow"]
#define kImageIconSetupAudioLargeSnow           [UIImage imageNamed:@"HDA_icon_setup_audio_large_snow"]
#define kImageIconSetupVideoAudioLargeSnow      [UIImage imageNamed:@"HDA_icon_setup_video_audio_large_snow"]

//#define kImageIconSetupMHUBOSLarge              [UIImage imageNamed:@"HDA_icon_mhub_os_large"]
//#define kImageIconSetupDoneLarge                [UIImage imageNamed:@"HDA_icon_setup_done_large"]
//#define kImageIconSetupMHUBOSLarge              [UIImage imageNamed:@"icon-setup-mos"]
//#define kImageIconSetupDoneLarge                [UIImage imageNamed:@"icon-setup-complete"]

#define kImageIconSetupMHUBOSLarge              [UIImage imageNamed:@"icon-SETUP-INCOMPLETE"]
#define kImageIconSetupDoneLarge                [UIImage imageNamed:@"icon-SETUP-COMPLETE"]
#define kImageCECIcon                           [UIImage imageNamed:@"TVCEC"]


//MARK: Custom
//#define customBackBarButton   [[UIBarButtonItem alloc]initWithCustomView:[[UIImageView alloc]initWithImage:kImageIconNavBack]]
#define customBackBarButton nil





#endif /* Constant_h */
