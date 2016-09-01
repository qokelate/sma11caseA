//
//  NSButton+SC.m
//  sma11case
//
//  Created by sma11case on 12/2/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "NSButton+SC.h"
#import "../Config.h"

@implementation NSButton(sma11case_OSX)
- (void)setTitleColor:(NSColor *)color
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.title];

    NSUInteger len = string.length;
    NSRange range = NSMakeRange(0, len);
    
    [string setAttributes:@{NSParagraphStyleAttributeName:ps,NSForegroundColorAttributeName:color} range:range];
    
    self.attributedTitle = string;
}
@end
