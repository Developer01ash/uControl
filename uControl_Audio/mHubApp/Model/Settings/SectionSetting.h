//
//  SectionSetting.h
//  mHubApp
//
//  Created by Anshul Jain on 23/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSectionTitle   @"sectionTitle"
#define kRowArray       @"rowArray"
#define kRowTitle       @"rowTitle"
#define kRowImage       @"rowImage"
#define kRowInfo        @"rowInfo"
#define kSectionType    @"sectionType"
#define kIsExpand       @"isExpand"

typedef NS_OPTIONS(NSInteger, HDA_Sections) {
    HDA_Resync_MOS      = 0,
    HDA_Resync_Cloud    ,
    
    HDA_MHUBSystem      ,
    HDA_NameAndAddress  ,
    HDA_PairedNameAndAddress,
    HDA_AccessMHUBOS          ,
    HDA_ManageUControlPacks,
    HDA_ManageMOSSequence   ,
    HDA_RemoveUControl  ,
    HDA_Advanced  ,

    HDA_ManageLabels    ,
    HDA_ManageZonesLabels   ,
    HDA_ManageSourceLabels  ,

    HDA_HDACloud        ,
    HDA_Create_Cloud    ,
    HDA_Backup_Cloud    ,

    HDA_UControlSettings,
    HDA_DisplaySetting  ,
    HDA_Background      ,
    HDA_Theme           ,
    HDA_ButtonBorder    ,

    HDA_AdditionalCustomization,
    HDA_MenuSettings    ,
    HDA_ManageZones     ,
    HDA_ManageAudioInputs     ,
    HDA_ManageSequences ,
    HDA_ManageSource    ,
    HDA_SetAppQuickAction,
    HDA_ManageQuickAction,
    HDA_ButtonVibration ,
    HDA_CECSettings     ,
    HDA_SendBugReport     ,
    HDA_GroupAudio     ,

    HDA_DisplayPower    ,
    HDA_SourcePower     ,
    HDA_AVRPower        ,
    
    HDA_AudioDevice     ,
    HDA_AccessSystem     ,
    HDA_Interface     ,
    HDA_groups     ,
    HDA_general     ,
    HDA_power     ,
    HDA_update     ,
    HDA_reset     ,
    HDA_Appearance     ,
    HDA_FindDevices     ,
    HDA_Benchmark     ,
    HDA_AboutUCONTROL     ,
    HDA_MhubPro     ,
    HDA_MhubPro2     ,
    HDA_MhubS     ,
    HDA_Mhub_ZP     ,
    HDA_Mhub_Max     ,
    HDA_Mhub_Audio     ,
    HDA_Mhub_U     ,
    HDA_utility     ,
};

@interface RowSetting : NSObject
@property(nonatomic, retain) NSString *strTitle;
@property(nonatomic, retain) UIImage *imgRow;
@property(nonatomic, retain) id rowInfo;
@property(nonatomic, retain) NSMutableArray *arrInputs;

+(RowSetting*) initWithTitle:(NSString*)strTitle Image:(UIImage*)imgRow;
+(RowSetting*) initWithTitle:(NSString*)strTitle Image:(UIImage*)imgRow RowInfo:(id)rowInfo;
-(NSDictionary*) dictionaryRepresentation;
@end

@interface SectionSetting : NSObject
@property(nonatomic, retain) NSString *Title;
@property(nonatomic, retain) NSMutableArray *arrRow;
@property(nonatomic, retain) NSMutableArray *arrSectionRows;

@property(nonatomic) HDA_Sections sectionType ;
@property(nonatomic) BOOL isExpand;
@property(nonatomic) Command *exist_PowerCommandId;

+(SectionSetting*) initWithTitle:(NSString*)strTitle SectionType:(HDA_Sections)secType RowArray:(NSArray*)arrRows;
-(NSDictionary*) dictionaryRepresentation;

+(NSMutableArray*) getMHUBSettingsArray;
+(NSMutableArray*) getMHUBSystemSettingsArray;
+(NSMutableArray*) getManageLabelsSettingsArray;
+(NSMutableArray*) getHDACloudSettingsArray;
+(NSMutableArray*) getUCONTROLSettingsArray;
+(NSMutableArray*) getDisplaySettingsArray;
+(NSMutableArray*) getAdditionalCustomizationArray;
+(NSMutableArray*) getMenuSettingsArray;
+(NSMutableArray*) getSetAppQuickActionArray;
+(NSMutableArray*) getVibrationArray;
//+(SectionSetting*) getGroupAudioVolumeArray:(NSArray*)arrOutputData GroupData:(NSArray*)arrGroupAudio;

+(NSMutableArray*) getMHUBSettingsArray_2;
+(NSMutableArray*) getMHUBSettingsArray_3;
+(NSMutableArray*) getDisplaySettingsArray_Theme;
+(NSMutableArray*) getDisplaySettingsArray_ButtonBorder;
+(NSMutableArray*) getMenuSettingsArray_ForManageZone;
+(NSMutableArray*) getMenuSettingsArray_ForManageSource;
+(NSMutableArray*) getMenuSettingsArray_ForManageSequences;
+(NSMutableArray*) getCECSettingsArray;
+(NSMutableArray*) getMenuSettingsArray_ForManageAudioInputs;
+(NSMutableArray *)manage_audioInputs;
+(NSMutableArray*) getMHUBAccessSystemArray;
+(NSMutableArray*) getMHUBUCONTROLINTERFACESETTINGS;
+(NSMutableArray*)getMHUBUCONTROLAPPEARANCESETTINGS;
+(NSMutableArray*) getMHUBUCONTROLGENERALSETTINGS;
+(NSMutableArray*) getPOWERONOFFArray;
+(NSMutableArray*) getMHUBModelDevicesArray;
+(NSMutableArray*) getMHUBPro2DevicesArray;
+(NSMutableArray*) getMHUBProDevicesArray;
+(NSMutableArray*) getMHUBSDevicesArray;
+(NSMutableArray*) getMHUBMaxDevicesArray;
+(NSMutableArray*) getMHUBUDevicesArray;
+(NSMutableArray*) getMHUBAudioDevicesArray;
+(NSMutableArray*) getMHUBZPDevicesArray;

+(NSMutableArray*) getMHUBUCONTROLUTILITYSETTINGS;
@end
