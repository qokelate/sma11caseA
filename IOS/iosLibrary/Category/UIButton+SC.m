//
//  UIButton+SC.m
//  sma11case
//
//  Created by sma11case on 10/29/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "UIButton+SC.h"
#import "UIView+SC.h"
#import "../Config.h"

@implementation UIButton(sma11case_IOS)

+ (UIButton *)buttonWithRoundedRectWithArc: (CGFloat)arc
{
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [temp setRoundedRectWithArc:arc];
    return temp;
}

- (void)setTitle:(NSString *)title titleColor:(UIColor *)color forState:(UIControlState)state
{
    [self setTitle:title forState:state];
    [self setTitleColor:color forState:state];
}
@end
