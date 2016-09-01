//
//  NSString+SC.m
//  sma11case
//
//  Created by sma11case on 11/2/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "NSString+SC.h"
#import "../Config.h"

@implementation NSString (sma11case_IOS)
- (CGFloat)calcSingleLineTextWidthWithFont: (UIFont *)font height: (CGFloat)height
{
    return [self calcSizeWithFont:font width:MAXFLOAT height:height].width;
}
@end
