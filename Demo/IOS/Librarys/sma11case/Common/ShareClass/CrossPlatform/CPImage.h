//
//  CPImage.h
//  sma11case
//
//  Created by sma11case on 12/2/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Config.h"

#if PLAT_IOS
#define CPImage UIImage
#endif

#if PLAT_OSX
#define CPImage NSImage
#endif
