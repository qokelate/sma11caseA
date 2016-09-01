//
//  Config.h
//  sma11case
//
//  Created by sma11case on 15/8/11.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>

// Disable Not Recommanded Method
#ifndef DisableNRM
#define DisableNRM 0UL
#endif

// switch some developer features
#ifndef IS_SMA11CASE_VERSION
#define IS_SMA11CASE_VERSION 0UL
#endif

// enable non-public APIs
#ifndef UsePrivateAPI
#define UsePrivateAPI 0UL
#endif

// enable experimental APIs
#ifndef UseExpeAPI
#define UseExpeAPI 0UL
#endif

#ifndef PLAT_IOS
#if (TARGET_OS_IPHONE && !TARGET_OS_MAC)
#define PLAT_IOS 1UL
#endif
#endif

#ifndef PLAT_OSX
#if (TARGET_OS_MAC && !TARGET_OS_IPHONE)
#define PLAT_OSX 1UL
#endif
#endif

#ifndef PLAT_WATCH
#define PLAT_WATCH 0UL
#endif

#ifdef DEBUG
#undef IS_DEBUG_MODE
#define IS_DEBUG_MODE 1UL
#endif

#ifndef USE_NSLOGGER
#define USE_NSLOGGER 0UL
#endif

#ifndef TARGET_OS_IPHONE
#define TARGET_OS_IPHONE PLAT_IOS
#endif

#ifndef TARGET_OS_IOS
#define TARGET_OS_IOS PLAT_IOS
#endif

#ifndef TARGET_OS_WATCH
#define TARGET_OS_WATCH PLAT_WATCH
#endif

#if PLAT_IOS
#import <UIKit/UIKit.h>

#if (!IS_DEV_MODE && __has_include( <iosFramework/iosFramework.h> ))
#import <iosFramework/iosFramework.h>
#endif
#endif

#if PLAT_OSX
#import <Cocoa/Cocoa.h>

#if (!IS_DEV_MODE && __has_include( <osxFramework/osxFramework.h> ))
#import <osxFramework/osxFramework.h>
#endif
#endif







