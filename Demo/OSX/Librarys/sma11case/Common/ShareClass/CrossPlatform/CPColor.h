//
//  CPColor.h
//  sma11case
//
//  Created by sma11case on 11/23/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Config.h"

#if PLAT_IOS
#define CPColor UIColor
#endif

#if PLAT_OSX
#define CPColor NSColor
#endif

// 颜色宏
#define ClearColor [CPColor clearColor]
#define WhiteColor [CPColor whiteColor]
#define BlackColor [CPColor blackColor]
#define RedColor   [CPColor redColor]
#define BlueColor  [CPColor blueColor]
#define GreenColor [CPColor greenColor]
#define GrayColor  [CPColor grayColor]
#define CyanColor  [CPColor cyanColor]

#define RGB(r, g, b) [CPColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f]
#define RGBA(r, g, b, a) [CPColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a/100.0f)]

#define HexRGBColor(rgbValue) [CPColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HexRGBAColor(rgbValue) [CPColor colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbValue & 0xFF00) >> 8))/255.0 alpha:((float)(rgbValue & 0xFF))/255.0]

#define RandomColor HexRGBColor(RandomNumber(0, 0xFFFFFF))

@interface CPColor(sma11case_CrossPlatform)
+ (CPColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha; // @"0xRRGGBB" @"#RRGGBB" @"RRGGBB"
@end
