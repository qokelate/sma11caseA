//
//  UIView+SC.h
//  sma11case
//
//  Created by sma11case on 9/10/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GetUIViewController(name, view) __weak UIViewController *name = view.controller
#define GetViewController(type, name, view) __weak type name = (type)view.controller

@interface UIView(sma11case_IOS)
- (UIViewController *)controller;
- (UIImage*)saveAsImage;
- (BOOL)isVisible;
@end
