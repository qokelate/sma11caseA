//
//  NSMutableAttributedString+SC.h
//  sma11case
//
//  Created by sma11case on 11/25/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../CrossPlatform/CrossPlatform.h"

@interface NSMutableAttributedString(sma11case_ShareClass)
- (void)setColor: (CPColor *)color ranges: (NSRange)first, ...;
- (void)setColor: (CPColor *)color texts: (NSString *)first, ...;
- (void)setColor: (CPColor *)color range: (NSRange)range;
- (void)setColor: (CPColor *)color text: (NSString *)text;
@end
