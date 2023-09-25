//
//  ControlPackData.h
//  mHubApp
//
//  Created by Anshul Jain on 24/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#ifndef XMLControlPack_h
#define XMLControlPack_h

#define kControlPack        @"controlPack"
#define kCPName             @"name"
#define kCPMeta             @"meta"
#define kCPDownloadTest     @"downloadTest"
#define kCPIRPACK           @"irpack"
#define kCPIR               @"ir"
#define kCPGrid             @"grid"
#define kCPAppUI            @"app_UI"
#define kCPAppUIXML         @"appUI"
#define kCPContinuity       @"continuity"
#define kCPContinuityS      @"continuityS"
#define kCPContinuityM      @"continuityM"
#define kCPContinuityL      @"continuityL"

#define kCPMetaDeviceID     @"deviceID"
#define kCPMetaVersion      @"version"
#define kCPMetaManufacturer @"manufacturer"
#define kCPMetaName         @"name"


#define kCPDTTest           @"test"

#define kCPDTTestId         @"id"
#define kCPDTLabel          @"label"
#define kCPDTDescription    @"description"

#define kIRCommand          @"command"

#define kCommandXMLId       @"id"
#define kCommandXMLLabel    @"label"
#define kCommandXMLCode     @"code"
#define kCommandXMLText     @"text"
#define kCommandXMLRepeat   @"repeat"

#define kCPControlGroup     @"controlGroup"

#define kCPControlType      @"type"
#define kCPControlOrder     @"order"
#define kCPControlSelected  @"selected"

#define kCPControlGroupVisibility   @"visibility"

#define kCPControlLocation  @"location"
#define kCPControlSize      @"size"
#define kCPControlWidth     @"width"
#define kCPControlHeight    @"height"

#define kCPCGGesture        @"gesture"
#define kCPCGNavigation     @"navigation"
#define kCPCGNumerical      @"numerical"
#define kCPCGPlayhead       @"playhead"
#define kCPCGCustom        @"custom"
#define kDeviceTypeMobileSmall  @"mobileSmall"
#define kDeviceTypeMobileLarge  @"mobileLarge"
#define kDeviceTypeTabletSmall  @"tabletSmall"
#define kDeviceTypeTabletLarge  @"tabletLarge"
#define kDeviceTypeTabletLargeLandscape  @"tabletLargeLandscape"

#define kCPControlGroupUI   @"ui"
#define kCPControlUIGesture @"gesture"
#define kCPControlUIButton  @"button"

#define kCommandXMLVisible  @"visible"

#define kCommandXMLLocationX    @"locationX" // X define Row Number
#define kCommandXMLLocationY    @"locationY" // Y define Column Number
#define kCommandXMLLocationXLandscape    @"locationXLandscape" // X define Row Number
#define kCommandXMLLocationYLandscape    @"locationYLandscape" // Y define Column Number
#define kCommandXMLSizeWidth    @"sizeWidth"
#define kCommandXMLSizeHeight   @"sizeHeight"

#define kGridRow        @"row"
#define kGridColumn     @"column"

#import "Order.h"
#import "GridDimension.h"
#import "Grid.h"
#import "SizeUI.h"
#import "ControlSize.h"
#import "Location.h"
#import "ControlLocation.h"
#import "ControlVisibility.h"
#import "UiCommand.h"
#import "ControlGroup.h"
#import "IRCommand.h"
#import "Meta.h"
#import "DownloadTest.h"
#import "ControlPack.h"
#import "ContinuityCommand.h"

#endif /* XMLControlPack_h */
