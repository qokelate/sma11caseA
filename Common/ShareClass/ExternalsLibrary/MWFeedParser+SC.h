//
//  MWFeedParser+SC.h
//  sma11case
//
//  Created by sma11case on 8/19/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Config.h"

#ifndef HaveMWFeedParser
#if __has_include( "MWFeedParser.h" )
#define HaveMWFeedParser 1UL
#import "MWFeedParser.h"
#endif
#endif

#if IS_DEV_MODE
#if (!defined(HaveMWFeedParser) && defined(PLAT_IOS))
#if __has_include( "../../../IOS/iosComponents/build/Headers/MWFeedParser.h" )
#define HaveMWFeedParser 1UL
#import "../../../IOS/iosComponents/build/Headers/MWFeedParser.h"
#endif
#endif

#if (!defined(HaveMWFeedParser) && defined(PLAT_OSX))
#if __has_include( "../../../OSX/osxComponents/build/Headers/MWFeedParser.h" )
#define HaveMWFeedParser 1UL
#import "../../../OSX/osxComponents/build/Headers/MWFeedParser.h"
#endif
#endif
#endif

#if HaveMWFeedParser
#define UseMWFeedParser 1UL
#endif

#if UseMWFeedParser
@interface MWFeedParser(sma11case_ShareClass)
+ (void)parseWithData: (NSData *)data delegate:(id<MWFeedParserDelegate>)delegate;
+ (void)parseWithURL: (NSURL *)url delegate:(id<MWFeedParserDelegate>)delegate;
@end
#endif

