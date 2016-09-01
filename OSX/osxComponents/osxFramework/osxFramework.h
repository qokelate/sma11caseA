//
//  osxFramework.h
//  osxFramework
//
//  Created by lianlian on 8/18/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for osxFramework.
FOUNDATION_EXPORT double osxFrameworkVersionNumber;

//! Project version string for osxFramework.
FOUNDATION_EXPORT const unsigned char osxFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <osxFramework/PublicHeader.h>

#if __has_include( "FMDB.h" )
#define HaveFMDB 1UL
#import "FMDB.h"
#endif

#if __has_include( "MWFeedParser.h" )
#define HaveMWFeedParser 1UL
#import "MWFeedParser.h"
#endif


