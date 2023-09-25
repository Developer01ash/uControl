//
//  SectionSetting.m
//  mHubApp
//
//  Created by Anshul Jain on 23/11/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "SectionSetting.h"

@implementation RowSetting

+(RowSetting*) initWithTitle:(NSString*)strTitle Image:(UIImage*)imgRow {
    RowSetting *objReturn = [[RowSetting alloc] init];
    @try {
        objReturn.strTitle = strTitle;
        objReturn.imgRow = imgRow;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

+(RowSetting*) initWithTitle:(NSString*)strTitle Image:(UIImage*)imgRow RowInfo:(id)rowInfo {
    RowSetting *objReturn = [[RowSetting alloc] init];
    @try {
        objReturn.strTitle = strTitle;
        objReturn.imgRow = imgRow;
        objReturn.rowInfo = rowInfo;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

-(NSDictionary*) dictionaryRepresentation {
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.strTitle forKey:kRowTitle];
        [dict setValue:self.imgRow forKey:kRowImage];
        [dict setValue:self.rowInfo forKey:kRowInfo];
        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeObject:self.strTitle forKey:kRowTitle];
        [encoder encodeObject:self.imgRow forKey:kRowImage];
        [encoder encodeObject:self.rowInfo forKey:kRowInfo];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            self.strTitle = [decoder decodeObjectForKey:kRowTitle];
            self.imgRow = [decoder decodeObjectForKey:kRowImage];
            self.rowInfo = [decoder decodeObjectForKey:kRowInfo];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}
@end

@implementation SectionSetting

+(SectionSetting*) initWithTitle:(NSString*)strTitle SectionType:(HDA_Sections)secType RowArray:(NSArray*)arrRows {
    SectionSetting *objReturn=[[SectionSetting alloc] init];
    @try {
        objReturn.Title = strTitle;
        objReturn.sectionType = secType;
        objReturn.arrRow = [[NSMutableArray alloc] initWithArray:arrRows];
        objReturn.exist_PowerCommandId = [objReturn.arrRow firstObject];
        objReturn.isExpand = true;
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return objReturn;
}

//MARK: NEW Setting Options
+(NSMutableArray*) getMHUBSettingsArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Resync UControl to MOS Object
        SectionSetting *objReSyncMOS = [SectionSetting initWithTitle:HUB_RESYNCUCONTROL_MHUBOS SectionType:HDA_Resync_MOS RowArray:[[NSArray alloc] init]];
        
        // Resync UControl to Cloud Object
        SectionSetting *objReSyncCloud = [SectionSetting initWithTitle:HUB_RESYNCUCONTROL_HDACLOUD SectionType:HDA_Resync_Cloud RowArray:[[NSArray alloc] init]];
        
        // HDA CLOUD Settings
        SectionSetting *objCloud = [SectionSetting initWithTitle:HUB_HDACLOUD_HEADER SectionType:HDA_HDACloud RowArray:[[NSArray alloc] init]];
        
        // MHUB System Setting Object
        SectionSetting *objSystem = [SectionSetting initWithTitle:HUB_MHUBSYSTEM SectionType:HDA_MHUBSystem RowArray:[[NSArray alloc] init]];
        
        // UCONTROL Settings Object
        SectionSetting *objUcontrol = [SectionSetting initWithTitle:HUB_UCONTROLSETTINGS SectionType:HDA_UControlSettings RowArray:[[NSArray alloc] init]];
        
        // Group Audio Volume Object
        SectionSetting *objGroupAudio = [SectionSetting initWithTitle:HUB_AUDIOGROUPS SectionType:HDA_GroupAudio RowArray:[[NSArray alloc] init]];
        
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            [arrSettings addObject:objReSyncCloud];
            [arrSettings addObject:objSystem];
            [arrSettings addObject:objCloud];
            [arrSettings addObject:objUcontrol];
        } else {
            [arrSettings addObject:objReSyncMOS];
            [arrSettings addObject:objSystem];
            [arrSettings addObject:objUcontrol];
            
            if ([mHubManagerInstance.objSelectedHub isGroupSupport]) {
                [arrSettings addObject:objGroupAudio];
            }
        }
        return arrSettings;
        
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getMHUBSystemSettingsArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        // Display IP Address
        NSString *strIPAddress = @"";
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            strIPAddress = [NSString stringWithFormat:HUB_NAMEANDIPADDRESS, @"DEMO MODE", @"DEMO ADDRESS",1.0];
        } else {
            strIPAddress = [NSString stringWithFormat:HUB_NAMEANDIPADDRESS, [Hub getMhubDisplayName:mHubManagerInstance.objSelectedHub], mHubManagerInstance.objSelectedHub.Address, mHubManagerInstance.objSelectedHub.mosVersion];
        }
        SectionSetting *objIPAddress = [SectionSetting initWithTitle:strIPAddress SectionType:HDA_NameAndAddress RowArray:[[NSArray alloc] init]];
        
        [arrSettings addObject:objIPAddress];
        
        for (int counter = 0; counter < mHubManagerInstance.arrSlaveAudioDevice.count; counter++) {
            Hub *objAudio = [mHubManagerInstance.arrSlaveAudioDevice objectAtIndex:counter];
            // Paired IP Address
            NSString *strIPPaired = @"";
            if ([objAudio.Address isEqualToString:STATICTESTIP_AUDIO]) {
                strIPPaired = [NSString stringWithFormat:HUB_PAIREDNAMEANDIPADDRESS, @"DEMO MODE", @"DEMO ADDRESS",1.0];
            } else {
                //Here we added If and else condition to show PAIRED should be appear only one time, if there is more then 1 slave devices. so previously it was showing paired text two time if there is 2 slave devices. but due to below if condition it'll only show paired one time. Otherwise older code is same as written in else condition.
                if( mHubManagerInstance.arrSlaveAudioDevice.count > 1){
                    if(counter == 1 || counter == 2)
                    {
                        strIPPaired = [NSString stringWithFormat:HUB_WITHOUT_PAIREDNAMEANDIPADDRESS, [Hub getMhubDisplayName:objAudio], objAudio.Address,objAudio.mosVersion];
                    }
                    else{
                        strIPPaired = [NSString stringWithFormat:HUB_PAIREDNAMEANDIPADDRESS, [Hub getMhubDisplayName:objAudio], objAudio.Address,objAudio.mosVersion];
                    }
                }
                else{
                    strIPPaired = [NSString stringWithFormat:HUB_PAIREDNAMEANDIPADDRESS, [Hub getMhubDisplayName:objAudio], objAudio.Address,objAudio.mosVersion];
                }
            }
            SectionSetting *objIPPaired = [SectionSetting initWithTitle:strIPPaired SectionType:HDA_PairedNameAndAddress RowArray:[[NSArray alloc] init]];
            
            [arrSettings addObject:objIPPaired];
        }
        
        // Access MOS Object
        SectionSetting *objMOS = [SectionSetting initWithTitle:HUB_ACCESSMHUBOS SectionType:HDA_AccessMHUBOS RowArray:[[NSArray alloc] init]];
        
        // MANAGE UCONTROL PACKS Object
        SectionSetting *objUControlPacks = [SectionSetting initWithTitle:HUB_MANAGEUCONTROLPACKS SectionType:HDA_ManageUControlPacks RowArray:[[NSArray alloc] init]];
        
        // MANAGE SEQUENCES Object
        SectionSetting *objSequence = [SectionSetting initWithTitle:HUB_MANAGESEQUENCES SectionType:HDA_ManageMOSSequence RowArray:[[NSArray alloc] init]];
        
        // MANAGE Labels Object
        SectionSetting *objLabels = [SectionSetting initWithTitle:HUB_MANAGEZONESOURCELABELS SectionType:HDA_ManageLabels RowArray:[[NSArray alloc] init]];
        
        // Reset UControl Object
        SectionSetting *objReset = [SectionSetting initWithTitle:HUB_REMOVE_THIS_MHUB SectionType:HDA_RemoveUControl RowArray:[[NSArray alloc] init]];
        
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            [arrSettings addObject:objMOS];
            [arrSettings addObject:objLabels];
        } else if (mHubManagerInstance.objSelectedHub.Generation == mHubMAX) {
            [arrSettings addObject:objMOS];
            [arrSettings addObject:objSequence];
        } else if (mHubManagerInstance.objSelectedHub.Generation == mHubAudio) {
            [arrSettings addObject:objMOS];
            [arrSettings addObject:objSequence];
        } else if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV4) {
            [arrSettings addObject:objMOS];
            [arrSettings addObject:objUControlPacks];
            [arrSettings addObject:objSequence];
        } else {
            if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
                [arrSettings addObject:objMOS];
                [arrSettings addObject:objUControlPacks];
                [arrSettings addObject:objSequence];
            }
        }
        [arrSettings addObject:objReset];
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(NSMutableArray*) getMHUBAccessSystemArray
{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Resync UControl to MOS Object
        // Display Name
        NSString *strDisplayName = @"";
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            strDisplayName = [NSString stringWithFormat:HUB_RESYNCUCONTROL_DEVICE, @"DEMO MODE"];
        } else {
            strDisplayName = [NSString stringWithFormat:HUB_RESYNCUCONTROL_DEVICE, [Hub getMhubDisplayName:mHubManagerInstance.objSelectedHub]];
        }
        
        SectionSetting *objReSyncMOS = [SectionSetting initWithTitle:strDisplayName  SectionType:HDA_Resync_MOS RowArray:[[NSArray alloc] init]];
        
        // Access POWER Object
        SectionSetting *objPower = [SectionSetting initWithTitle:HUB_POWER SectionType:HDA_power RowArray:[[NSArray alloc] init]];
        
        // Access MOS Object
        SectionSetting *objMOS = [SectionSetting initWithTitle:HUB_ACCESSMHUBOS SectionType:HDA_AccessMHUBOS RowArray:[[NSArray alloc] init]];
        
        // MANAGE UCONTROL PACKS Object
        SectionSetting *objUControlPacks = [SectionSetting initWithTitle:HUB_MANAGEUCONTROLPACKS SectionType:HDA_ManageUControlPacks RowArray:[[NSArray alloc] init]];
        
        // MANAGE SEQUENCES Object
        SectionSetting *objSequence = [SectionSetting initWithTitle:HUB_MANAGESEQUENCES SectionType:HDA_ManageMOSSequence RowArray:[[NSArray alloc] init]];
        
        // update system
        SectionSetting *objUpdate = [SectionSetting initWithTitle:HUB_UPDATE SectionType:HDA_update RowArray:[[NSArray alloc] init]];
        
        
        
        // Reset UControl Object
        SectionSetting *objReset = [SectionSetting initWithTitle:HUB_REMOVE_THIS_MHUB SectionType:HDA_RemoveUControl RowArray:[[NSArray alloc] init]];
        
        [arrSettings addObject:objReSyncMOS];
        if (mHubManagerInstance.objSelectedHub.Generation != mHubZP) {
        [arrSettings addObject:objPower];
        }
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            [arrSettings addObject:objMOS];
//            [arrSettings addObject:objLabels];
        } else if (mHubManagerInstance.objSelectedHub.Generation == mHubMAX) {
            [arrSettings addObject:objMOS];
            [arrSettings addObject:objSequence];
        } else if (mHubManagerInstance.objSelectedHub.Generation == mHubAudio) {
            [arrSettings addObject:objMOS];
            [arrSettings addObject:objSequence];
        } else if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV4) {
            [arrSettings addObject:objMOS];
            [arrSettings addObject:objUControlPacks];
            [arrSettings addObject:objSequence];
        } else {
            if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
                [arrSettings addObject:objMOS];
                [arrSettings addObject:objUControlPacks];
                [arrSettings addObject:objSequence];
            }
        }
        //[arrSettings addObject:objUpdate];
       // [arrSettings addObject:objReStore];
        [arrSettings addObject:objReset];
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


+(NSMutableArray*) getManageLabelsSettingsArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Manage Zone labels Object
        SectionSetting *objManageZone = [SectionSetting initWithTitle:HUB_ZONELABELS SectionType:HDA_ManageZonesLabels RowArray:[[NSArray alloc] init]];
        
        // Manage Source labels Object
        SectionSetting *objManageSource = [SectionSetting initWithTitle:HUB_SOURCELABELS SectionType:HDA_ManageSourceLabels RowArray:[[NSArray alloc] init]];
        
        [arrSettings addObject:objManageZone];
        [arrSettings addObject:objManageSource];
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getHDACloudSettingsArray {
    @try {
        
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        //  CREATE ACCOUNT HDA CLOUD™ Object
        SectionSetting *objCreate = [SectionSetting initWithTitle:HUB_CREATEHDACLOUDACCOUNT SectionType:HDA_Create_Cloud RowArray:[[NSArray alloc] init]];
        
        //  RESYNC UCONTROL WITH HDA CLOUD™ Object
        SectionSetting *objReSync = [SectionSetting initWithTitle:HUB_RESYNCUCONTROL_HDACLOUD SectionType:HDA_Resync_Cloud RowArray:[[NSArray alloc] init]];
        
        //  BACKUP UCONTROL TO HDA CLOUD™ Object
        SectionSetting *objBackup = [SectionSetting initWithTitle:HUB_BACKUPUCONTROLTOHDACLOUD SectionType:HDA_Backup_Cloud RowArray:[[NSArray alloc] init]];
        
        [arrSettings addObject:objCreate];
        [arrSettings addObject:objReSync];
        [arrSettings addObject:objBackup];
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getUCONTROLSettingsArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Display Settings Object
        SectionSetting *objDisplay = [SectionSetting initWithTitle:HUB_DISPLAYSETTINGS SectionType:HDA_DisplaySetting RowArray:[[NSArray alloc] init]];
        
        // Additional Customization Object
        SectionSetting *objAddCustomization = [SectionSetting initWithTitle:HUB_ADDITIONALCUSTOMISATION SectionType:HDA_AdditionalCustomization RowArray:[[NSArray alloc] init]];
        
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            [arrSettings addObject:objDisplay];
        } else {
            [arrSettings addObject:objDisplay];
            [arrSettings addObject:objAddCustomization];
        }
        return arrSettings;
        
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(NSMutableArray*) getMHUBModelDevicesArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
       
        SectionSetting *objPro = [SectionSetting initWithTitle:kDEVICE_MHUB_PRO SectionType:HDA_MhubPro RowArray:[[NSArray alloc] init]];
        SectionSetting *objPro2 = [SectionSetting initWithTitle:kDEVICE_MHUB_PRO2 SectionType:HDA_MhubPro2 RowArray:[[NSArray alloc] init]];
        SectionSetting *objS = [SectionSetting initWithTitle:kDEVICE_MHUB_S SectionType:HDA_MhubS RowArray:[[NSArray alloc] init]];
        SectionSetting *objZp = [SectionSetting initWithTitle:kDEVICE_MHUB_ZONEPROCESSOR SectionType:HDA_Mhub_ZP RowArray:[[NSArray alloc] init]];
        SectionSetting *objmax = [SectionSetting initWithTitle:kDEVICE_MHUB_MAX SectionType:HDA_Mhub_Max RowArray:[[NSArray alloc] init]];
        SectionSetting *objAudio = [SectionSetting initWithTitle:kDEVICE_MHUB_AUDIO SectionType:HDA_Mhub_Audio RowArray:[[NSArray alloc] init]];
        SectionSetting *objU = [SectionSetting initWithTitle:kDEVICE_MHUB_U SectionType:HDA_Mhub_U RowArray:[[NSArray alloc] init]];
        
      
        
        [arrSettings addObject:objPro];
        [arrSettings addObject:objPro2];
        [arrSettings addObject:objS];
        [arrSettings addObject:objZp];
        [arrSettings addObject:objmax];
        [arrSettings addObject:objAudio];
        [arrSettings addObject:objU];
        
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(NSMutableArray*) getMHUBPro2DevicesArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
       
        SectionSetting *objPro244 = [SectionSetting initWithTitle:@"MHUB PRO 2.0 (4X4) 40" SectionType:HDA_MhubPro2 RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUBPRO24440, nil]];
        SectionSetting *objPro288 = [SectionSetting initWithTitle:@"MHUB PRO 2.0 (8X8) 100" SectionType:HDA_MhubPro2 RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUBPRO288100, nil]];
      
        [arrSettings addObject:objPro244];
        [arrSettings addObject:objPro288];
        
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getMHUBProDevicesArray{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        SectionSetting *objPro44 = [SectionSetting initWithTitle:@"MHUB PRO (4X4) 40" SectionType:HDA_MhubPro RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUBPRO4440, nil]];
        SectionSetting *objPro88 = [SectionSetting initWithTitle:@"MHUB PRO (8X8) 40" SectionType:HDA_MhubPro RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUBPRO8840, nil]];
        SectionSetting *objPro44_70 = [SectionSetting initWithTitle:@"MHUB PRO (4X4) 70" SectionType:HDA_MhubPro RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUB4K44PRO, nil]];
        SectionSetting *objPro88_70 = [SectionSetting initWithTitle:@"MHUB PRO (8X8) 70" SectionType:HDA_MhubPro RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUB4K88PRO, nil]];
      
        [arrSettings addObject:objPro44];
        [arrSettings addObject:objPro88];
        [arrSettings addObject:objPro44_70];
        [arrSettings addObject:objPro88_70];
        
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getMHUBSDevicesArray
{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
       
        SectionSetting *objS = [SectionSetting initWithTitle:@"MHUB S (8X8) 100" SectionType:HDA_MhubS RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUB_S, nil]];
      
        [arrSettings addObject:objS];
        
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(NSMutableArray*) getMHUBZPDevicesArray
{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
       
        SectionSetting *objZP1 = [SectionSetting initWithTitle:@"UCONTROL ZONE PROCESSOR 1" SectionType:HDA_Mhub_ZP RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUBZPMINI, nil]];
        SectionSetting *objZP5 = [SectionSetting initWithTitle:@"UCONTROL ZONE PROCESSOR 5" SectionType:HDA_Mhub_ZP RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUBZP5, nil]];
      
        [arrSettings addObject:objZP1];
        [arrSettings addObject:objZP5];
        
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getMHUBMaxDevicesArray
{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
       
        SectionSetting *objMax44 = [SectionSetting initWithTitle:@"MHUB MAX (4X4)" SectionType:HDA_MhubPro RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUBMAX44, nil]];
        SectionSetting *objMax88 = [SectionSetting initWithTitle:@"MHUB MAX (8X8)" SectionType:HDA_MhubPro2 RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUBMAX88, nil]];
      
        [arrSettings addObject:objMax44];
        [arrSettings addObject:objMax88];
        
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(NSMutableArray*) getMHUBUDevicesArray
{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
       
        SectionSetting *objU862 = [SectionSetting initWithTitle:@"MHUB U (8X6+2) 40" SectionType:HDA_MhubPro RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUB862U, nil]];
        SectionSetting *objU432 = [SectionSetting initWithTitle:@"MHUB U (4X3+1) 40" SectionType:HDA_Mhub_U RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUB431U, nil]];
        SectionSetting *objU411 = [SectionSetting initWithTitle:@"MHUB U (4X1+1) 40" SectionType:HDA_Mhub_U RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUBU41140, nil]];
        
      
        [arrSettings addObject:objU862];
        [arrSettings addObject:objU432];
        [arrSettings addObject:objU411];
        
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(NSMutableArray*) getMHUBAudioDevicesArray
{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
       
        SectionSetting *objAudio = [SectionSetting initWithTitle:@"MHUB AUDIO (6X4)" SectionType:HDA_MhubPro RowArray:[[NSArray alloc] initWithObjects:kDEVICEMODEL_MHUBAUDIO64, nil]];
      
        [arrSettings addObject:objAudio];
        
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
/*
 +(NSMutableArray*) getDisplaySettingsArray {
 @try {
 NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
 // Background Image Object
 NSMutableArray *arrBGOutputs = [[NSMutableArray alloc] init];
 if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
 NSArray *arrZones = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubZoneData];
 for (int counter = 0; counter < [arrZones count]; counter++) {
 Zone *obj = [arrZones objectAtIndex:counter];
 NSString *strName = obj.zone_label;
 RowSetting *objZone = [RowSetting initWithTitle:strName Image:obj.imgControlGroupBG];
 [arrBGOutputs addObject:objZone];
 }
 } else {
 NSArray *arrOutputs = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubOutputData];
 for (int counter = 0; counter < [arrOutputs count]; counter++) {
 OutputDevice *obj = [arrOutputs objectAtIndex:counter];
 NSString *strName = obj.CreatedName;
 RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.imgControlGroup];
 [arrBGOutputs addObject:objOutput];
 }
 }
 SectionSetting *objBGImage = [SectionSetting initWithTitle:HUB_ZONEBACKGROUNDIMAGE SectionType:HDA_Background RowArray:arrBGOutputs];
 
 // Theme Object
 RowSetting *objDark = [RowSetting initWithTitle:@"CARBONITE (DARK)" Image:kImageCheckMark];
 RowSetting *objLight = [RowSetting initWithTitle:@"SNOW (LIGHT)" Image:kImageCheckMark];
 SectionSetting *objTheme = [SectionSetting initWithTitle:HUB_THEMES SectionType:HDA_Theme RowArray:[[NSArray alloc] initWithObjects:objDark, objLight, nil]];
 
 RowSetting *objYes = [RowSetting initWithTitle:@"YES" Image:kImageCheckMark];
 RowSetting *objNo = [RowSetting initWithTitle:@"NO" Image:kImageCheckMark];
 SectionSetting *objButtonBorder = [SectionSetting initWithTitle:HUB_BUTTONBORDERS SectionType:HDA_ButtonBorder RowArray:[[NSArray alloc] initWithObjects:objYes, objNo, nil]];
 
 [arrSettings addObject:objBGImage];
 [arrSettings addObject:objTheme];
 
 if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
 [arrSettings addObject:objButtonBorder];
 }
 return arrSettings;
 } @catch(NSException *exception) {
 [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
 }
 }
 */

+(NSMutableArray*) getDisplaySettingsArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Background Image Object
        NSMutableArray *arrBGOutputs = [[NSMutableArray alloc] init];
        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            NSArray *arrZones = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubZoneData];
            for (int counter = 0; counter < [arrZones count]; counter++) {
                Zone *obj = [arrZones objectAtIndex:counter];
                NSString *strName = obj.zone_label;
                RowSetting *objZone = [RowSetting initWithTitle:strName Image:obj.imgControlGroupBG];
                [arrBGOutputs addObject:objZone];
            }
        } else {
            NSArray *arrOutputs = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubOutputData];
            for (int counter = 0; counter < [arrOutputs count]; counter++) {
                OutputDevice *obj = [arrOutputs objectAtIndex:counter];
                NSString *strName = obj.CreatedName;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.imgControlGroup];
                [arrBGOutputs addObject:objOutput];
            }
        }
        SectionSetting *objBGImage = [SectionSetting initWithTitle:HUB_ZONEBACKGROUNDIMAGE SectionType:HDA_Background RowArray:arrBGOutputs];
        objBGImage.isExpand = true;
      //  [arrSettings addObject:objBGImage];
        
        
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getAdditionalCustomizationArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Menu Settings Object
        SectionSetting *objMenuSetting = [SectionSetting initWithTitle:HUB_MENUSETTINGS SectionType:HDA_MenuSettings RowArray:[[NSArray alloc] init]];
        
        // set App Quick Actions Object
        SectionSetting *objQuickActions = [SectionSetting initWithTitle:HUB_SETAPPQUICKACTIONS SectionType:HDA_SetAppQuickAction RowArray:[[NSArray alloc] init]];
        
        // Set Button Vibration Object
        SectionSetting *objButtonVibration = [SectionSetting initWithTitle:HUB_BUTTONVIBRATION SectionType:HDA_ButtonVibration RowArray:[[NSArray alloc] init]];
        
        [arrSettings addObject:objMenuSetting];
        
        if (mHubManagerInstance.objSelectedHub.Generation != mHub4KV3) {
            if (mHubManagerInstance.objSelectedHub.HubSequenceList.count > 0) {
                [arrSettings addObject:objQuickActions];
            }
            [arrSettings addObject:objButtonVibration];
        }
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getMenuSettingsArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Manage Zones Object
        NSMutableArray *arrManageZones = [[NSMutableArray alloc] init];
        
        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            NSArray *arrZones = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubZoneData];
            for (int counter = 0; counter < [arrZones count]; counter++) {
                Zone *obj = [arrZones objectAtIndex:counter];
                NSString *strName = obj.zone_label;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
                [arrManageZones addObject:objOutput];
            }
        } else {
            NSArray *arrOutputs = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubOutputData];
            for (int counter = 0; counter < [arrOutputs count]; counter++) {
                OutputDevice *obj = [arrOutputs objectAtIndex:counter];
                NSString *strName = obj.CreatedName;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
                [arrManageZones addObject:objOutput];
            }
        }
        SectionSetting *objManageZones = [SectionSetting initWithTitle:HUB_MANAGEZONES SectionType:HDA_ManageZones RowArray:arrManageZones];
        
        // Manage Sequence Object
        NSArray *arrSequences = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubSequenceList];
        NSMutableArray *arrManageSeq = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrSequences count]; counter++) {
            Sequence *objSeq = [arrSequences objectAtIndex:counter];
            NSString *strName = objSeq.uControl_name;
            RowSetting *objRow = [RowSetting initWithTitle:strName Image:objSeq.isDeleted ? nil : kImageCheckMark RowInfo:objSeq];
            [arrManageSeq addObject:objRow];
        }
        SectionSetting *objManageSequence = [SectionSetting initWithTitle:HUB_MANAGESEQUENCES SectionType:HDA_ManageSequences RowArray:arrManageSeq];
        
        // Manage Source Object
        NSArray *arrSource = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubInputData];
        NSMutableArray *arrManageSource = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrSource count]; counter++) {
            InputDevice *obj = [arrSource objectAtIndex:counter];
            NSString *strName = obj.CreatedName;
            RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
            [arrManageSource addObject:objOutput];
        }
        SectionSetting *objManageSource = [SectionSetting initWithTitle:HUB_MANAGESOURCEDEVICES SectionType:HDA_ManageSource RowArray:arrManageSource];
        
        [arrSettings addObject:objManageZones];
        [arrSettings addObject:objManageSequence];
        [arrSettings addObject:objManageSource];
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getSetAppQuickActionArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        // Manage Sequence Object
        NSArray *arrSequences = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubSequenceList];
        NSMutableArray *arrManageSeq = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrSequences count]; counter++) {
            Sequence *objSeq = [arrSequences objectAtIndex:counter];
            NSString *strName = objSeq.uControl_name;
            BOOL isShortcutAvailable = [mHubManagerInstance searchQuickActionInShortcutItems:objSeq];
            RowSetting *objRow = [RowSetting initWithTitle:strName Image:isShortcutAvailable ? kImageCheckMark : nil RowInfo:objSeq];
            [arrManageSeq addObject:objRow];
        }
        SectionSetting *objManageSequence = [SectionSetting initWithTitle:HUB_MANAGEQUICKACTIONS SectionType:HDA_ManageQuickAction RowArray:arrManageSeq];
        objManageSequence.isExpand = true;
        
        [arrSettings addObject:objManageSequence];
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}



//MARK: NEW Setting Menu
+(NSMutableArray*) getMHUBSettingsArray_2 {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        // Display IP Address
        NSString *strIPAddress = @"";
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            strIPAddress = [NSString stringWithFormat:HUB_NAMEANDIPADDRESS, @"DEMO MODE", @"DEMO ADDRESS",1.0];
        } else {
            if(mHubManagerInstance.arrSlaveAudioDevice.count > 0){
                strIPAddress = [NSString stringWithFormat:HUB_NAMEANDIPADDRESS, [Hub getMhubDisplayName:mHubManagerInstance.objSelectedHub], mHubManagerInstance.objSelectedHub.Address,mHubManagerInstance.objSelectedHub.mosVersion];
            }
            else{
                strIPAddress = [NSString stringWithFormat:HUB_NAMEANDIPADDRESS_STANDALONE, [Hub getMhubDisplayName:mHubManagerInstance.objSelectedHub], mHubManagerInstance.objSelectedHub.Address,mHubManagerInstance.objSelectedHub.mosVersion];
                
            }
        }
        SectionSetting *objIPAddress = [SectionSetting initWithTitle:strIPAddress SectionType:HDA_NameAndAddress RowArray:[[NSArray alloc] init]];
        
        [arrSettings addObject:objIPAddress];
        
        for (int counter = 0; counter < mHubManagerInstance.arrSlaveAudioDevice.count; counter++) {
            Hub *objAudio = (Hub *)[mHubManagerInstance.arrSlaveAudioDevice objectAtIndex:counter];
            [APIManager writeNormalStringWithTimeStamp:[NSString stringWithFormat:@"METHOD:*getMHUBSettingsArray_2*\nobjAudio.strMOSVersion=%@\nobjAudio.mosVersion=%f",objAudio.strMOSVersion,objAudio.mosVersion]];
            // Paired IP Address
            NSString *strIPPaired = @"";
            if ([objAudio.Address isEqualToString:STATICTESTIP_AUDIO]) {
                strIPPaired = [NSString stringWithFormat:HUB_PAIREDNAMEANDIPADDRESS, @"DEMO MODE", @"DEMO ADDRESS",1.0];
            } else {
                //Here we added If and else condition to show PAIRED should be appear only one time, if there is more then 1 slave devices. so previously it was showing paired text two time if there is 2 slave devices. but due to below if condition it'll only show paired one time. Otherwise older code is same as written in else condition.
                if( mHubManagerInstance.arrSlaveAudioDevice.count > 1){
                    if(counter == 1 || counter == 2 || counter == 3 || counter == 4)
                    {
                        strIPPaired = [NSString stringWithFormat:HUB_WITHOUT_PAIREDNAMEANDIPADDRESS, [Hub getMhubDisplayName:objAudio], objAudio.Address,objAudio.mosVersion];
                    }
                    else{
                        strIPPaired = [NSString stringWithFormat:HUB_PAIREDNAMEANDIPADDRESS, [Hub getMhubDisplayName:objAudio], objAudio.Address,objAudio.mosVersion];
                    }
                }
                else{
                    strIPPaired = [NSString stringWithFormat:HUB_PAIREDNAMEANDIPADDRESS, [Hub getMhubDisplayName:objAudio], objAudio.Address,objAudio.mosVersion];
                }
            }
            SectionSetting *objIPPaired = [SectionSetting initWithTitle:strIPPaired SectionType:HDA_PairedNameAndAddress RowArray:[[NSArray alloc] init]];
            
            [arrSettings addObject:objIPPaired];
        }
        
        // Resync UControl to MOS Object
        // Display Name
        NSString *strDisplayName = @"";
        if ([mHubManagerInstance.objSelectedHub isDemoMode]) {
            strDisplayName = [NSString stringWithFormat:HUB_RESYNCUCONTROL_DEVICE, @"DEMO MODE"];
        } else {
            strDisplayName = [NSString stringWithFormat:HUB_RESYNCUCONTROL_DEVICE, [Hub getMhubDisplayName:mHubManagerInstance.objSelectedHub]];
        }
        
        SectionSetting *objReSyncMOS = [SectionSetting initWithTitle:strDisplayName  SectionType:HDA_Resync_MOS RowArray:[[NSArray alloc] init]];
        
        // Resync UControl to Cloud Object
        SectionSetting *objReSyncCloud = [SectionSetting initWithTitle:HUB_RESYNCUCONTROL_HDACLOUD SectionType:HDA_Resync_Cloud RowArray:[[NSArray alloc] init]];
        
        // HDA CLOUD Settings
        SectionSetting *objCloud = [SectionSetting initWithTitle:HUB_HDACLOUD_HEADER SectionType:HDA_HDACloud RowArray:[[NSArray alloc] init]];
        
        // Access MOS Object
        SectionSetting *objMOS = [SectionSetting initWithTitle:HUB_ACCESSMHUBOS SectionType:HDA_AccessMHUBOS RowArray:[[NSArray alloc] init]];
        
        // MANAGE UCONTROL PACKS Object
        SectionSetting *objUControlPacks = [SectionSetting initWithTitle:HUB_MANAGEUCONTROLPACKS SectionType:HDA_ManageUControlPacks RowArray:[[NSArray alloc] init]];
        
        // MANAGE MOS Update
        SectionSetting *advanceOption = [SectionSetting initWithTitle:HUB_ADVANCE_UPDATE_MOS SectionType:HDA_Advanced RowArray:[[NSArray alloc] init]];
        
        // MANAGE SEQUENCES Object
        SectionSetting *objSequence = [SectionSetting initWithTitle:HUB_MANAGESEQUENCES SectionType:HDA_ManageMOSSequence RowArray:[[NSArray alloc] init]];
        
        // MANAGE SEQUENCES Object
        SectionSetting *objLabels = [SectionSetting initWithTitle:HUB_MANAGEZONESOURCELABELS SectionType:HDA_ManageLabels RowArray:[[NSArray alloc] init]];
        
       
        // Reset UControl Object
        SectionSetting *objReset = [SectionSetting initWithTitle:HUB_REMOVE_THIS_MHUB SectionType:HDA_RemoveUControl RowArray:[[NSArray alloc] init]];

        //NSArray *systemItems = [[NSArray alloc]initWithObjects:HUB_RESYNC,HUB_POWER,HUB_DEVICEOS,HUB_UCONTROLPACKS,HUB_SEQUENCES,HUB_UPDATE,HUB_RESET,HUB_REMOVESYSTEM, nil];
        NSArray *systemItems = [[NSArray alloc]initWithObjects:objReSyncCloud,objSequence,objUControlPacks, nil];
        
        // Access System
        SectionSetting *objAccessSystem = [SectionSetting initWithTitle:HUB_ACCESSSYSTEM SectionType:HDA_AccessSystem RowArray:systemItems];

        
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            //[arrSettings addObject:objReSyncCloud];
            //[arrSettings addObject:objCloud];
            [arrSettings addObject:objMOS];
            [arrSettings addObject:objLabels];
            [arrSettings addObject:objReset];
        } else {
           // [arrSettings addObject:objReSyncMOS];
            [arrSettings addObject:objAccessSystem];
            
//            if (![mHubManagerInstance.objSelectedHub isDemoMode]) {
//                if([mHubManagerInstance.objSelectedHub isZPSetup])
//                {
//
//                }
//                else{
//                    [arrSettings addObject:objMOS];
//                    [arrSettings addObject:objSequence];
//                    if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
//                        [arrSettings addObject:objUControlPacks];
//                    }
//                    [arrSettings addObject:advanceOption];
//                }
//            }
        }
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getMHUBSettingsArray_3 {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        // Manage Zones Object
        NSMutableArray *arrManageZones = [[NSMutableArray alloc] init];
        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            NSArray *arrZones = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubZoneData];
            for (int counter = 0; counter < [arrZones count]; counter++) {
                Zone *obj = [arrZones objectAtIndex:counter];
                NSString *strName = obj.zone_label;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
                [arrManageZones addObject:objOutput];
            }
        } else {
            NSArray *arrOutputs = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubOutputData];
            for (int counter = 0; counter < [arrOutputs count]; counter++) {
                OutputDevice *obj = [arrOutputs objectAtIndex:counter];
                NSString *strName = obj.CreatedName;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
                [arrManageZones addObject:objOutput];
            }
        }
        SectionSetting *objManageZones = [SectionSetting initWithTitle:HUB_MANAGEZONES SectionType:HDA_ManageZones RowArray:arrManageZones];
        
        // Manage Sequence Object
        NSArray *arrSequences = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubSequenceList];
        NSMutableArray *arrManageSeq = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrSequences count]; counter++) {
            Sequence *objSeq = [arrSequences objectAtIndex:counter];
            NSString *strName = objSeq.uControl_name;
            RowSetting *objRow = [RowSetting initWithTitle:strName Image:objSeq.isDeleted ? nil : kImageCheckMark RowInfo:objSeq];
            [arrManageSeq addObject:objRow];
        }
        SectionSetting *objManageSequence = [SectionSetting initWithTitle:HUB_MANAGESEQUENCES SectionType:HDA_ManageSequences RowArray:arrManageSeq];
        
        // Manage Source Object
        NSArray *arrSource = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubInputData];
        NSMutableArray *arrManageSource = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrSource count]; counter++) {
            InputDevice *obj = [arrSource objectAtIndex:counter];
            NSString *strName = obj.CreatedName;
            RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
            [arrManageSource addObject:objOutput];
        }
        SectionSetting *objManageSource = [SectionSetting initWithTitle:HUB_MANAGESOURCEDEVICES SectionType:HDA_ManageSource RowArray:arrManageSource];
        
        // Background Image Object
        NSMutableArray *arrBGOutputs = [[NSMutableArray alloc] init];
        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            NSArray *arrZones = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubZoneData];
            for (int counter = 0; counter < [arrZones count]; counter++) {
                Zone *obj = [arrZones objectAtIndex:counter];
                NSString *strName = obj.zone_label;
                RowSetting *objZone = [RowSetting initWithTitle:strName Image:obj.imgControlGroupBG];
                [arrBGOutputs addObject:objZone];
            }
        } else {
            NSArray *arrOutputs = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubOutputData];
            for (int counter = 0; counter < [arrOutputs count]; counter++) {
                OutputDevice *obj = [arrOutputs objectAtIndex:counter];
                NSString *strName = obj.CreatedName;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.imgControlGroup];
                [arrBGOutputs addObject:objOutput];
            }
        }
        SectionSetting *objBGImage = [SectionSetting initWithTitle:HUB_ZONEBACKGROUNDIMAGE SectionType:HDA_Background RowArray:arrBGOutputs];
        
        // Theme Object
        SectionSetting *objTheme = [SectionSetting initWithTitle:HUB_THEMES SectionType:HDA_Theme RowArray:[[NSArray alloc] init]];
        
        // Button Border Object
        SectionSetting *objButtonBorder = [SectionSetting initWithTitle:HUB_BUTTONBORDERS SectionType:HDA_ButtonBorder RowArray:[[NSArray alloc] init]];
        
        // Vibration Object
        SectionSetting *objButtonVibration = [SectionSetting initWithTitle:HUB_BUTTONVIBRATION SectionType:HDA_ButtonVibration RowArray:[[NSArray alloc] init]];
        
        
        
        // set App Quick Actions Object
        SectionSetting *objQuickActions = [SectionSetting initWithTitle:HUB_SETAPPQUICKACTIONS SectionType:HDA_SetAppQuickAction RowArray:[[NSArray alloc] init]];
        
//        //Group Audio Volume Object
//        SectionSetting *objGroupAudio = [SectionSetting initWithTitle:HUB_AUDIOGROUPS SectionType:HDA_GroupAudio RowArray:[[NSArray alloc] init]];
        
        // Send Buglife repot Object
        SectionSetting *objButtonSendBug = [SectionSetting initWithTitle:HUB_BUTTONSENDREPORTORBUG SectionType:HDA_SendBugReport RowArray:[[NSArray alloc] init]];
        
        // CEC show hide in video inputs
        SectionSetting *objCECSetting = [SectionSetting initWithTitle:CEC_SETTINGS SectionType:HDA_CECSettings RowArray:[[NSArray alloc] init]];
        
        // MANAGE Interface Object
        SectionSetting *objInterface = [SectionSetting initWithTitle:HUB_INTERFACE SectionType:HDA_Interface RowArray:[[NSArray alloc] init]];
        
        // MANAGE groups Object
        SectionSetting *objGroupAudio = [SectionSetting initWithTitle:HUB_GROUPS SectionType:HDA_GroupAudio RowArray:[[NSArray alloc] init]];
        
        
        // MANAGE general Object
        SectionSetting *objGeneral = [SectionSetting initWithTitle:HUB_GENERAL SectionType:HDA_general RowArray:[[NSArray alloc] init]];
        
        // MANAGE Utility Object
        SectionSetting *objUtilities = [SectionSetting initWithTitle:HUB_Utilities SectionType:HDA_utility RowArray:[[NSArray alloc] init]];
        
        
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
            //[arrSettings addObject:objBGImage];
            //[arrSettings addObject:objTheme];
            
        } else {
//            [arrSettings addObject:objManageZones];
//            [arrSettings addObject:objManageSource];
//
//            if (mHubManagerInstance.objSelectedHub.HubSequenceList.count > 0) {
//                [arrSettings addObject:objManageSequence];
//            }
//            [arrSettings addObject:objBGImage];
//            [arrSettings addObject:objTheme];
//
//            if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
//                [arrSettings addObject:objButtonBorder];
//            }
//            [arrSettings addObject:objButtonVibration];
//            [arrSettings addObject:objCECSetting];
//            [arrSettings addObject:objButtonSendBug];
//            if (mHubManagerInstance.objSelectedHub.HubSequenceList.count > 0) {
//                [arrSettings addObject:objQuickActions];
//            }
//
//            if ([mHubManagerInstance.objSelectedHub isGroupSupport]) {
//                [arrSettings addObject:objGroupAudio];
//            }
            [arrSettings addObject:objInterface];
            if ([mHubManagerInstance.objSelectedHub isGroupSupport]) {
                [arrSettings addObject:objGroupAudio];
            }
        
           // [arrSettings addObject:objGroups];
            [arrSettings addObject:objUtilities];
            [arrSettings addObject:objGeneral];
            
        }
        return arrSettings;
        
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getMHUBUCONTROLINTERFACESETTINGS
{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        SectionSetting *objApperanceObj = [SectionSetting initWithTitle:HUB_APPERANCE SectionType:HDA_Appearance RowArray:[[NSArray alloc] init]];
        
        SectionSetting *objButtonVibration = [SectionSetting initWithTitle:HUB_SOUNDVIBRATION SectionType:HDA_ButtonVibration RowArray:[[NSArray alloc] init]];
        [arrSettings addObject:objApperanceObj];
        [arrSettings addObject:objButtonVibration];
        
        return arrSettings;
        
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    
}

+(NSMutableArray*) getMHUBUCONTROLAPPEARANCESETTINGS
{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        // Manage Zones Object
        NSMutableArray *arrManageZones = [[NSMutableArray alloc] init];
        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            NSArray *arrZones = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubZoneData];
            for (int counter = 0; counter < [arrZones count]; counter++) {
                Zone *obj = [arrZones objectAtIndex:counter];
                NSString *strName = obj.zone_label;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
                [arrManageZones addObject:objOutput];
            }
        } else {
            NSArray *arrOutputs = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubOutputData];
            for (int counter = 0; counter < [arrOutputs count]; counter++) {
                OutputDevice *obj = [arrOutputs objectAtIndex:counter];
                NSString *strName = obj.CreatedName;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
                [arrManageZones addObject:objOutput];
            }
        }
        SectionSetting *objManageZones = [SectionSetting initWithTitle:HUB_MANAGEZONES SectionType:HDA_ManageZones RowArray:arrManageZones];
        
        // Manage Sequence Object
        NSArray *arrSequences = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubSequenceList];
        NSMutableArray *arrManageSeq = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrSequences count]; counter++) {
            Sequence *objSeq = [arrSequences objectAtIndex:counter];
            NSString *strName = objSeq.uControl_name;
            RowSetting *objRow = [RowSetting initWithTitle:strName Image:objSeq.isDeleted ? nil : kImageCheckMark RowInfo:objSeq];
            [arrManageSeq addObject:objRow];
        }
        SectionSetting *objManageSequence = [SectionSetting initWithTitle:HUB_MANAGESEQUENCES SectionType:HDA_ManageSequences RowArray:arrManageSeq];
        
        // Manage Source Object
        NSArray *arrSource = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubInputData];
        NSMutableArray *arrManageSource = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrSource count]; counter++) {
            InputDevice *obj = [arrSource objectAtIndex:counter];
            NSString *strName = obj.CreatedName;
            RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
            [arrManageSource addObject:objOutput];
        }
        SectionSetting *objManageSource = [SectionSetting initWithTitle:HUB_MANAGESOURCEDEVICES SectionType:HDA_ManageSource RowArray:arrManageSource];
        
        // Background Image Object
        NSMutableArray *arrBGOutputs = [[NSMutableArray alloc] init];
        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            NSArray *arrZones = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubZoneData];
            for (int counter = 0; counter < [arrZones count]; counter++) {
                Zone *obj = [arrZones objectAtIndex:counter];
                NSString *strName = obj.zone_label;
                RowSetting *objZone = [RowSetting initWithTitle:strName Image:obj.imgControlGroupBG];
                [arrBGOutputs addObject:objZone];
            }
        } else {
            NSArray *arrOutputs = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubOutputData];
            for (int counter = 0; counter < [arrOutputs count]; counter++) {
                OutputDevice *obj = [arrOutputs objectAtIndex:counter];
                NSString *strName = obj.CreatedName;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.imgControlGroup];
                [arrBGOutputs addObject:objOutput];
            }
        }
      
        
        // Button Border Object
        SectionSetting *objButtonBorder = [SectionSetting initWithTitle:HUB_BUTTONBORDERS SectionType:HDA_ButtonBorder RowArray:[[NSArray alloc] init]];
        
        // Vibration Object
        SectionSetting *objButtonVibration = [SectionSetting initWithTitle:HUB_BUTTONVIBRATION SectionType:HDA_ButtonVibration RowArray:[[NSArray alloc] init]];
        
        
        
        // set App Quick Actions Object
        SectionSetting *objQuickActions = [SectionSetting initWithTitle:HUB_SETAPPQUICKACTIONS SectionType:HDA_SetAppQuickAction RowArray:[[NSArray alloc] init]];
        
        //Group Audio Volume Object
        SectionSetting *objGroupAudio = [SectionSetting initWithTitle:HUB_AUDIOGROUPS SectionType:HDA_GroupAudio RowArray:[[NSArray alloc] init]];
        
        
        
        // CEC show hide in video inputs
        SectionSetting *objCECSetting = [SectionSetting initWithTitle:CEC_SETTINGS SectionType:HDA_CECSettings RowArray:[[NSArray alloc] init]];
        
       
        
        
        if (mHubManagerInstance.objSelectedHub.Generation == mHub4KV3) {
           // [arrSettings addObject:objBGImage];
            //[arrSettings addObject:objTheme];
            
        } else {
            [arrSettings addObject:objManageZones];
            [arrSettings addObject:objManageSource];

            if (mHubManagerInstance.objSelectedHub.HubSequenceList.count > 0) {
                [arrSettings addObject:objManageSequence];
            }
           // [arrSettings addObject:objBGImage];
           // [arrSettings addObject:objTheme];

            if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
                [arrSettings addObject:objButtonBorder];
            }
           // [arrSettings addObject:objButtonVibration];
            [arrSettings addObject:objCECSetting];
            //[arrSettings addObject:objButtonSendBug];
            if (mHubManagerInstance.objSelectedHub.HubSequenceList.count > 0) {
                [arrSettings addObject:objQuickActions];
            }

//            if ([mHubManagerInstance.objSelectedHub isGroupSupport]) {
//                [arrSettings addObject:objGroupAudio];
//            }
//
        }
        return arrSettings;
        
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(NSMutableArray*) getMHUBUCONTROLGENERALSETTINGS
{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        // Find Devices Object
        SectionSetting *objFindDevices = [SectionSetting initWithTitle:HUB_MANUALLY_CONNECT_FIND_DEVICES SectionType:HDA_FindDevices RowArray:[[NSArray alloc] init]];
        
        // About uControl Object
        SectionSetting *objAboutUControl = [SectionSetting initWithTitle:HUB_ABOUTUCONTROL SectionType:HDA_AboutUCONTROL RowArray:[[NSArray alloc] init]];
        
        // Software Benchmark Object
        SectionSetting *objBenchmark = [SectionSetting initWithTitle:HUB_SOFTWARE_BENCHMARK SectionType:HDA_Benchmark RowArray:[[NSArray alloc] init]];
        
        // Report a Bug Object
        // Send Buglife repot Object
        SectionSetting *objButtonSendBug = [SectionSetting initWithTitle:HUB_BUTTONSENDREPORTORBUG SectionType:HDA_SendBugReport RowArray:[[NSArray alloc] init]];
        
      //  [arrSettings addObject:objFindDevices];
        [arrSettings addObject:objAboutUControl];
        [arrSettings addObject:objBenchmark];
        [arrSettings addObject:objButtonSendBug];
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getMHUBUCONTROLUTILITYSETTINGS
{
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        // update system
        SectionSetting *objUpdate = [SectionSetting initWithTitle:HUB_UPDATE SectionType:HDA_update RowArray:[[NSArray alloc] init]];
        // Find Devices Object
        SectionSetting *objFindDevices = [SectionSetting initWithTitle:HUB_MANUALLY_CONNECT_FIND_DEVICES SectionType:HDA_FindDevices RowArray:[[NSArray alloc] init]];
        // Reset or restore system
        SectionSetting *objReStore = [SectionSetting initWithTitle:HUB_RESET SectionType:HDA_reset RowArray:[[NSArray alloc] init]];
        
        [arrSettings addObject:objUpdate];
        [arrSettings addObject:objFindDevices];
        [arrSettings addObject:objReStore];
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(NSMutableArray*) getMenuSettingsArray_ForManageZone {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Manage Zones Object
        NSMutableArray *arrManageZones = [[NSMutableArray alloc] init];
        
        if ([mHubManagerInstance.objSelectedHub isAPIV2]) {
            NSArray *arrZones = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubZoneData];
            for (int counter = 0; counter < [arrZones count]; counter++) {
                Zone *obj = [arrZones objectAtIndex:counter];
                NSString *strName = obj.zone_label;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
                [arrManageZones addObject:objOutput];
            }
        } else {
            NSArray *arrOutputs = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubOutputData];
            for (int counter = 0; counter < [arrOutputs count]; counter++) {
                OutputDevice *obj = [arrOutputs objectAtIndex:counter];
                NSString *strName = obj.CreatedName;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:obj.isDeleted ? nil : kImageCheckMark];
                [arrManageZones addObject:objOutput];
            }
        }
        SectionSetting *objManageZones = [SectionSetting initWithTitle:HUB_MANAGEZONES SectionType:HDA_ManageZones RowArray:arrManageZones];
        [arrSettings addObject:objManageZones];
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getMenuSettingsArray_ForManageSource {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Manage Source Object
        NSArray *arrSource  = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubInputData];
        NSMutableArray *arrManageSource = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrSource count]; counter++) {
            
            InputDevice *obj = [arrSource objectAtIndex:counter];
            NSString *strName = obj.CreatedName;
            //NSLog(@"label name value and deleted2 %@ %d",strName,obj.isDeleted);
            RowSetting *objOutput = [RowSetting initWithTitle:strName Image:!obj.isDeleted ? nil : kImageCheckMark];
            [arrManageSource addObject:objOutput];
        }
        NSString *masternamewithIP = [NSString stringWithFormat:@"%@:%@",[Hub getMhubDisplayName:mHubManagerInstance.objSelectedHub],mHubManagerInstance.objSelectedHub.Address];
        SectionSetting *objManageSource = [SectionSetting initWithTitle:masternamewithIP SectionType:HDA_ManageSource RowArray:arrManageSource];
        
//        if([mHubManagerInstance.objSelectedHub isZPSetup])
//        {
//          //  NSLog(@"salve inputs %@",[self tempporarySlaveInputslist]);
//            NSArray *newArray = [self tempporarySlaveInputslist];
//            if(newArray.count > 0)
//            {
//                [arrSettings addObjectsFromArray:newArray ];
//            }
//        }
//        else{
            [arrSettings addObject:objManageSource];
       // }
        [arrSettings addObjectsFromArray:[self getMenuSettingsArray_ForManageAudioInputs] ];
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) tempporarySlaveInputslist {
    @try {
        mHubManager *extractedExpr = mHubManagerInstance;
        NSMutableArray *arrSlaveWiseInputs = [[NSMutableArray alloc] init];
        NSArray *arrSource  = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubInputData];
        NSString *strUnitId = extractedExpr.objSelectedHub.UnitId;

        if ([strUnitId isEqualToString:extractedExpr.objSelectedHub.UnitId]) {
            NSMutableArray *arrManageSource = [[NSMutableArray alloc] init];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UnitId == %@", extractedExpr.objSelectedHub.UnitId];
            NSArray *masterHubInputsObj = [arrSource  filteredArrayUsingPredicate:predicate];
            for (int counter = 0; counter < [masterHubInputsObj count]; counter++) {
                InputDevice *obj = [masterHubInputsObj objectAtIndex:counter];
                NSString *strName = obj.CreatedName;
                RowSetting *objOutput = [RowSetting initWithTitle:strName Image:!obj.isDeleted ? nil : kImageCheckMark];
                [arrManageSource addObject:objOutput];
            }
            NSString *masternamewithIP = [NSString stringWithFormat:@"%@:%@",[Hub getMhubDisplayName:extractedExpr.objSelectedHub],extractedExpr.objSelectedHub.Address];
            SectionSetting *tempManageHubInputs_master = [SectionSetting initWithTitle:masternamewithIP SectionType:HDA_ManageSource RowArray:arrManageSource];
            [arrSlaveWiseInputs addObject:tempManageHubInputs_master];
        }
        if (extractedExpr.arrSlaveAudioDevice.count > 0)  {
            for (Hub* objSlave in extractedExpr.arrSlaveAudioDevice) {
                    NSMutableArray *arrManageSource = [[NSMutableArray alloc] init];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UnitId == %@", objSlave.UnitId];
                    NSArray *slaveHubObj = [arrSource  filteredArrayUsingPredicate:predicate];
                    for (int counter = 0; counter < [slaveHubObj count]; counter++) {
                        InputDevice *obj = [slaveHubObj objectAtIndex:counter];
                        NSString *strName = obj.CreatedName;
                        RowSetting *objOutput = [RowSetting initWithTitle:strName Image:!obj.isDeleted ? nil : kImageCheckMark];
                        [arrManageSource addObject:objOutput];
                    }
                    NSString *slavenamewithIP = [NSString stringWithFormat:@"%@:%@",[Hub getMhubDisplayName:objSlave],objSlave.Address];
                    SectionSetting *tempManageHubInputs = [SectionSetting initWithTitle:slavenamewithIP SectionType:HDA_ManageSource RowArray:arrManageSource];
                    [arrSlaveWiseInputs addObject:tempManageHubInputs];
            }
        }
        return arrSlaveWiseInputs;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

//This method will prepare a list of items with master and slave, with their titles and inputs associated with.
+(NSMutableArray*) getMenuSettingsArray_ForManageAudioInputs {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];

        // Manage Source Object
        NSArray *arrSource  = [[NSArray alloc] initWithArray:mHubManagerInstance.arrAudioSourceDeviceManaged];
        //   NSArray *arrSource  = [[NSArray alloc] initWithArray:arrInputs];
        NSMutableArray *arrManageSource = [[NSMutableArray alloc] init];
        NSMutableArray *arrHDMIARCInputs = [[NSMutableArray alloc] init];
        NSMutableArray *arrManageSourceSlave1 = [[NSMutableArray alloc] init];
        NSMutableArray *arrManageSourceSlave2 = [[NSMutableArray alloc] init];
        NSMutableArray *arrManageSourceSlave3 = [[NSMutableArray alloc] init];
        
        NSString *slave1IP;
        NSString *slave2IP;
        NSString *slave3IP;
      
        for (int counter = 0; counter < [arrSource count]; counter++) {
            InputDevice *obj = [arrSource objectAtIndex:counter];
            NSString *strName = obj.CreatedName;
            //NSLog(@"label name value and deleted %@ %d",strName,obj.isDeleted);
            RowSetting *objOutput = [RowSetting initWithTitle:strName Image:!obj.isDeleted ? nil : kImageCheckMark];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UnitId == %@", obj.UnitId];
            
            if([obj.UnitId containsString:@"M1"] || [obj.UnitId containsString:@"H"])
            {
                if([obj.CreatedName.lowercaseString containsString:@"hdbaset"] || [obj.CreatedName.lowercaseString containsString:@"hdmi"]){
                     [arrHDMIARCInputs addObject:objOutput];
                }
                else
                {
                    [arrManageSource addObject:objOutput];
                }
            }
            if([obj.UnitId containsString:@"S1"])
            {
               NSArray *slaveHubObj = [mHubManagerInstance.arrSlaveAudioDevice  filteredArrayUsingPredicate:predicate];
               Hub *objAudio =  [slaveHubObj objectAtIndex:0];
                //Hub *objAudio =  [mHubManagerInstance.arrSlaveAudioDevice objectAtIndex:0];
                slave1IP = [NSString stringWithFormat:@"%@:%@",[Hub getMhubDisplayName:objAudio],objAudio.Address];
                [arrManageSourceSlave1 addObject:objOutput];
            }
            if([obj.UnitId containsString:@"S2"])
            {
                NSArray *slaveHubObj = [mHubManagerInstance.arrSlaveAudioDevice  filteredArrayUsingPredicate:predicate];
                Hub *objAudio =  [slaveHubObj objectAtIndex:0];
                //Hub *objAudio =  [mHubManagerInstance.arrSlaveAudioDevice objectAtIndex:1];
                slave2IP = [NSString stringWithFormat:@"%@:%@",[Hub getMhubDisplayName:objAudio],objAudio.Address];
                [arrManageSourceSlave2 addObject:objOutput];
            }
            if([obj.UnitId containsString:@"S3"])
            {
                NSArray *slaveHubObj = [mHubManagerInstance.arrSlaveAudioDevice  filteredArrayUsingPredicate:predicate];
                Hub *objAudio =  [slaveHubObj objectAtIndex:0];
               // Hub *objAudio =  [mHubManagerInstance.arrSlaveAudioDevice objectAtIndex:2];
                slave3IP = [NSString stringWithFormat:@"%@:%@",[Hub getMhubDisplayName:objAudio],objAudio.Address];
                [arrManageSourceSlave3 addObject:objOutput];
            }
            
            
        }
        // To Remove the duplicate data.
                                    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrManageSource];
                                    arrManageSource = [orderedSet array].mutableCopy;
//                                    NSOrderedSet *orderedSet2 = [NSOrderedSet orderedSetWithArray:hdmiArr];
//                                    hdmiArr = [orderedSet2 array].mutableCopy;
        NSString *masternamewithIP = [NSString stringWithFormat:@"%@:%@",mHubManagerInstance.objSelectedHub.Name,mHubManagerInstance.objSelectedHub.Address];
        //Here we not sending title because, ARC inputs and master is same, so there is no need to show title or ip address two times. SO on display settings screen, if there is no Title then it'll not create header with same name and ip address two times.
        SectionSetting *objManageSource = [SectionSetting initWithTitle:nil SectionType:HDA_ManageSource RowArray:arrManageSource];
        [arrSettings addObject:objManageSource];
        if(arrManageSourceSlave1.count > 0){
            SectionSetting *objManageSource2 = [SectionSetting initWithTitle:slave1IP SectionType:HDA_ManageSource RowArray:arrManageSourceSlave1];
            [arrSettings addObject:objManageSource2];
        }
        if(arrManageSourceSlave2.count > 0){
            
            SectionSetting *objManageSource3 = [SectionSetting initWithTitle:slave2IP SectionType:HDA_ManageSource RowArray:arrManageSourceSlave2];
            [arrSettings addObject:objManageSource3];
        }
        if(arrManageSourceSlave3.count > 0){
            SectionSetting *objManageSource4 = [SectionSetting initWithTitle:slave3IP SectionType:HDA_ManageSource RowArray:arrManageSourceSlave3];
            [arrSettings addObject:objManageSource4];
        }
        if(arrHDMIARCInputs.count > 0){
            SectionSetting *objHDMIARCInputs = [SectionSetting initWithTitle:@"HDBASET / ARC" SectionType:HDA_ManageSource RowArray:arrHDMIARCInputs];
            [arrSettings addObject:objHDMIARCInputs];
        }
        
        
        
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


+(NSMutableArray*) getMenuSettingsArray_ForManageSequences {
    
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        
        // Manage Sequence Object
        NSArray *arrSequences = [[NSArray alloc] initWithArray:mHubManagerInstance.objSelectedHub.HubSequenceList];
        NSMutableArray *arrManageSeq = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < [arrSequences count]; counter++) {
            Sequence *objSeq = [arrSequences objectAtIndex:counter];
            NSString *strName = objSeq.uControl_name;
            RowSetting *objRow = [RowSetting initWithTitle:strName Image:objSeq.isDeleted ? nil : kImageCheckMark RowInfo:objSeq];
            [arrManageSeq addObject:objRow];
        }
        SectionSetting *objManageSequence = [SectionSetting initWithTitle:HUB_MANAGESEQUENCES SectionType:HDA_ManageSequences RowArray:arrManageSeq];
        
        [arrSettings addObject:objManageSequence];
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}
+(NSMutableArray*) getDisplaySettingsArray_ButtonBorder {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        RowSetting *objYes = [RowSetting initWithTitle:@"YES" Image:kImageCheckMark];
        RowSetting *objNo = [RowSetting initWithTitle:@"NO" Image:kImageCheckMark];
        SectionSetting *objButtonBorder = [SectionSetting initWithTitle:HUB_BUTTONBORDERS SectionType:HDA_ButtonBorder RowArray:[[NSArray alloc] initWithObjects:objYes, objNo, nil]];
        objButtonBorder.isExpand = true;
        if ([mHubManagerInstance.objSelectedHub isUControlSupport]) {
            [arrSettings addObject:objButtonBorder];
        }
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getDisplaySettingsArray_Theme {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Theme Object
        RowSetting *objDark = [RowSetting initWithTitle:@"CARBONITE (DARK)" Image:kImageCheckMark];
        RowSetting *objLight = [RowSetting initWithTitle:@"SNOW (LIGHT)" Image:kImageCheckMark];
        SectionSetting *objTheme = [SectionSetting initWithTitle:HUB_THEMES SectionType:HDA_Theme RowArray:[[NSArray alloc] initWithObjects:objDark, objLight, nil]];
        objTheme.isExpand = true;
        [arrSettings addObject:objTheme];
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getCECSettingsArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        // Theme Object
        RowSetting *objEnable = [RowSetting initWithTitle:@"ENABLE" Image:kImageCheckMark];
        RowSetting *objDisable = [RowSetting initWithTitle:@"DISABLE" Image:kImageCheckMark];
        SectionSetting *objCECView = [SectionSetting initWithTitle:CEC_VIEW SectionType:HDA_CECSettings RowArray:[[NSArray alloc] initWithObjects:objEnable, objDisable, nil]];
        SectionSetting *objCECUI = [SectionSetting initWithTitle:CEC_UI SectionType:HDA_CECSettings RowArray:[[NSArray alloc] initWithObjects:objEnable, objDisable, nil]];
        SectionSetting *objCECPower = [SectionSetting initWithTitle:CEC_POWER SectionType:HDA_CECSettings RowArray:[[NSArray alloc] initWithObjects:objEnable, objDisable, nil]];
        SectionSetting *objCECVolume = [SectionSetting initWithTitle:CEC_VOLUME SectionType:HDA_CECSettings RowArray:[[NSArray alloc] initWithObjects:objEnable, objDisable, nil]];
        objCECView.isExpand = true;
        objCECUI.isExpand = true;
        objCECPower.isExpand = true;
        objCECVolume.isExpand = true;
        [arrSettings addObject:objCECView];
        [arrSettings addObject:objCECUI];
        [arrSettings addObject:objCECPower];
        [arrSettings addObject:objCECVolume];
        
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}


+(NSMutableArray*) getVibrationArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        RowSetting *objYes = [RowSetting initWithTitle:@"YES" Image:kImageCheckMark];
        RowSetting *objNo = [RowSetting initWithTitle:@"NO" Image:kImageCheckMark];
        SectionSetting *objButtonVibration = [SectionSetting initWithTitle:HUB_BUTTONVIBRATION SectionType:HDA_ButtonVibration RowArray:[[NSArray alloc] initWithObjects:objYes, objNo, nil]];
        objButtonVibration.isExpand = true;
        [arrSettings addObject:objButtonVibration];
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

+(NSMutableArray*) getPOWERONOFFArray {
    @try {
        NSMutableArray *arrSettings = [[NSMutableArray alloc] init];
        
        RowSetting *objOn = [RowSetting initWithTitle:@"ON" Image:kImageCheckMark];
        RowSetting *objOff = [RowSetting initWithTitle:@"OFF" Image:kImageCheckMark];
        SectionSetting *objButtonVibration = [SectionSetting initWithTitle:HUB_POWER SectionType:HDA_power RowArray:[[NSArray alloc] initWithObjects:objOn, objOff, nil]];
        objButtonVibration.isExpand = true;
        [arrSettings addObject:objButtonVibration];
        return arrSettings;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

//MARK: ENCODE DECODE METHODS
-(NSDictionary*) dictionaryRepresentation
{
    @try {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.Title forKey:kSectionTitle];
        [dict setValue:[NSNumber numberWithInteger:self.sectionType] forKey:kSectionType];
        [dict setValue:self.arrRow forKey:kRowArray];
        [dict setValue:[NSNumber numberWithBool:self.isExpand] forKey:kIsExpand];
        return dict;
    } @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

#pragma mark - ENCODER DECODER METHODS
- (void)encodeWithCoder:(NSCoder *)encoder {
    @try {
        //Encode properties, other class variables, etc
        [encoder encodeObject:self.Title forKey:kSectionTitle];
        [encoder encodeInteger:self.sectionType forKey:kSectionType];
        [encoder encodeObject:self.arrRow forKey:kRowArray];
        [encoder encodeBool:self.isExpand forKey:kIsExpand];
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        if(self = [super init]) {
            //decode properties, other class vars
            self.Title          = [decoder decodeObjectForKey:kSectionTitle];
            self.sectionType    = (HDA_Sections)[decoder decodeIntegerForKey:kSectionType];
            self.arrRow         = [decoder decodeObjectForKey:kRowArray];
            self.isExpand       = [decoder decodeBoolForKey:kIsExpand];
        }
    }
    @catch(NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
    return self;
}

@end
