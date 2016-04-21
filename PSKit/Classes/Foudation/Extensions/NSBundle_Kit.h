//
//  NSBundle+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/12/25.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PSKit/PSKitDefines.h>

PSKIT_EXTERN_STRING(PSBundleIdentifier, "Bundle Identifier")
PSKIT_EXTERN_STRING(PSBundleShortVersionString, "Bundle Version")
PSKIT_EXTERN_STRING(PSBundleVersion, "Bundle Build")
PSKIT_EXTERN_STRING(PSBundleName, "Bundle Name")
PSKIT_EXTERN_STRING(PSBundlePlatformName, "Platform Name")
PSKIT_EXTERN_STRING(PSBundleSDKName, "SDK Name")
PSKIT_EXTERN_STRING(PSBundleMinimumOSVersion, "Minimum OS Version")
PSKIT_EXTERN_STRING(PSBundleLaunchStoryboardName, "Launch Storyboard Name")
PSKIT_EXTERN_STRING(PSBundleMainStoryboardFile, "Main Storyboard File")
PSKIT_EXTERN_STRING(PSBundleSupportedInterfaceOrientations, "Supported Interface Orientations")

@interface NSBundle (Kit)
@end
