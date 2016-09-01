//
//  CPColor.m
//  sma11case
//
//  Created by sma11case on 11/23/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "CPColor.h"
#import "../Category/Category.h"

@implementation CPColor(sma11case_CrossPlatform)
+ (CPColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    color = [color regexpFirstMatch:@"[0-9a-fA-F]{6}"];
    if (6 != color.length) return ClearColor;
    NSUInteger rgbValue = [NSString toUnsignedLongValue:color];
    return [CPColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
}


@end
