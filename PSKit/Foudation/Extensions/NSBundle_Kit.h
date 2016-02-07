//
//  NSBundle+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/12/25.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PSKit/convenientmacros.h>

PSExternString(PSBundleIdentifier, "Bundle Identifier")
PSExternString(PSBundleShortVersionString, "Bundle Version")
PSExternString(PSBundleVersion, "Bundle Build")
PSExternString(PSBundleName, "Bundle Name")
PSExternString(PSBundlePlatformName, "Platform Name")
PSExternString(PSBundleSDKName, "SDK Name")
PSExternString(PSBundleMinimumOSVersion, "Minimum OS Version")
PSExternString(PSBundleLaunchStoryboardName, "Launch Storyboard Name")
PSExternString(PSBundleMainStoryboardFile, "Main Storyboard File")
PSExternString(PSBundleSupportedInterfaceOrientations, "Supported Interface Orientations")

@interface NSBundle (Kit)
@end
