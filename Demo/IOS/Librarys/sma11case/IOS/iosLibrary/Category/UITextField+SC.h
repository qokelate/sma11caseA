//
//  UITextField+SC.h
//  sma11case
//
//  Created by sma11case on 10/29/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField(sma11case_IOS)
- (UILabel *)placeholderLabel;
- (void)setPlaceholderColor:(UIColor *)color;
- (void)setPlaceholder: (NSString *)text color:(UIColor *)color;
@end
