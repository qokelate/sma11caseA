//
//  UIButton+SC.h
//  sma11case
//
//  Created by sma11case on 10/29/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(sma11case_IOS)
+ (UIButton *)buttonWithRoundedRectWithArc: (CGFloat)arc;
- (void)setTitle:(NSString *)title titleColor:(UIColor *)color forState:(UIControlState)state;
@end
