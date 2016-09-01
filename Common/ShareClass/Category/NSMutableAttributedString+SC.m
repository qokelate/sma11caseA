//
//  NSMutableAttributedString+SC.m
//  sma11case
//
//  Created by sma11case on 11/25/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "NSMutableAttributedString+SC.h"

@implementation NSMutableAttributedString(sma11case_ShareClass)
- (void)setColor: (CPColor *)color ranges: (NSRange)first, ...
{
    va_list ap;
    va_start(ap, first);
    
    while (first.length)
    {
        [self setAttributes:@{NSForegroundColorAttributeName:color} range:first];
        first = va_arg(ap, NSRange);
    }
    
    va_end(ap);
}

- (void)setColor: (CPColor *)color texts: (NSString *)first, ...
{
    va_list ap;
    va_start(ap, first);
    
    while (first.length)
    {
        [self setColor:color text:first];
        first = va_arg(ap, NSString *);
    }
    
    va_end(ap);
}

- (void)setColor: (CPColor *)color range: (NSRange)range
{
    [self setAttributes:@{NSForegroundColorAttributeName:color} range:range];
}

- (void)setColor: (CPColor *)color text: (NSString *)text
{
    if (0 == text.length) return;
    
    NSString *string = self.string;
    NSUInteger mode = NSRegularExpressionCaseInsensitive;
    NSString *exprString = [NSRegularExpression escapedPatternForString:text];
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:exprString options:mode error:NULL];
    NSArray *result = [regexp matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if (0 == result.count) return;
    
    for (NSTextCheckingResult *rs in result)
    {
        [self setAttributes:@{NSForegroundColorAttributeName:color} range:rs.range];
    }
}
@end
