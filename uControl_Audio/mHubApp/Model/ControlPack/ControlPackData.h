//
//  ControlPackData.h
//  mHubApp
//
//  Created by Yashica Agrawal on 24/10/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#ifndef XMLControlPack_h
#define XMLControlPack_h

#define kControlPack        @"controlPack"
#define kCPName             @"name"
#define kCPMeta             @"meta"
#define kCPDownloadTest     @"downloadTest"
#define kCPIR               @"irpack"
#define kCPGrid             @"grid"
#define kCPAppUI            @"app_UI"
#define kCPContinuity       @"continuity"

#define kCPMetaDeviceID     @"deviceID"
#define kCPMetaVersion      @"version"

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
#import "UICommand.h"
#import "ControlGroup.h"
#import "IRCommand.h"
#import "Meta.h"
#import "DownloadTest.h"
#import "ControlPack.h"
#import "ContinuityCommand.h"

#endif /* XMLControlPack_h */
