//
//  UITextField+SC.m
//  sma11case
//
//  Created by sma11case on 10/29/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "UITextField+SC.h"

@implementation UITextField(sma11case_IOS)
- (UILabel *)placeholderLabel
{
    return [self valueForKey:@"_placeholderLabel"];
}

- (void)setPlaceholderColor:(UIColor *)color
{
    if (self.placeholder.length) [self setPlaceholder:self.placeholder color:color];
}

- (void)setPlaceholder: (NSString *)text color:(UIColor *)color
{
    NSDictionary *temp = [self.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];
    if (nil == temp)
    {
        temp = @{NSForegroundColorAttributeName:color};
    }
    else
    {
        NSMutableDictionary *attributes = [temp mutableCopy];
        attributes[NSForegroundColorAttributeName] = color;
        temp = attributes;
    }
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:temp];
}

@end
