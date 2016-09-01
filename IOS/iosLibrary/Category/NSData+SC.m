//
//  NSData+SC.m
//  sma11case
//
//  Created by sma11case on 11/7/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "NSData+SC.h"

@implementation NSData(sma11case_IOS)
- (UIImage *)toImage
{
    return [UIImage imageWithData:self];
}
@end
