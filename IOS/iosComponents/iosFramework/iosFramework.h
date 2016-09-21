//
//  iosFramework.h
//  iosFramework
//
//  Created by lianlian on 8/18/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for iosFramework.
FOUNDATION_EXPORT double iosFrameworkVersionNumber;

//! Project version string for iosFramework.
FOUNDATION_EXPORT const unsigned char iosFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <iosFramework/PublicHeader.h>

#if (!defined(HaveFMDB) && __has_include( "FMDB.h" ))
#define HaveFMDB 1UL
#import "FMDB.h"
#endif

#if (!defined(HaveMWFeedParser) && __has_include( "MWFeedParser.h" ))
#define HaveMWFeedParser 1UL
#import "MWFeedParser.h"
#endif

