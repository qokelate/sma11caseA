//
//  UINavigationController+SC.h
//  sma11case
//
//  Created by sma11case on 9/11/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Config.h"

typedef NS_ENUM(NSUInteger, KeyboardEvent)
{
    KeyboardEventUnknow = 0,
    KeyboardEventWillShow = 1,
    KeyboardEventDidShow = 2,
    KeyboardEventWillHide = 4,
    KeyboardEventDidHide = 8,
    KeyboardEventWillChangeFrame = 16,
    KeyboardEventAll = -1,
};

@interface UIViewController(sma11case_IOS)
- (BOOL)isVisible;

#if USE_SYS_NVC
- (void)sysnvc_setBackgroudImageWithColor: (UIColor *)color;
- (void)sysnvc_setNavigationBarHidden:(BOOL)hidden;
- (void)sysnvc_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
#endif
@end
