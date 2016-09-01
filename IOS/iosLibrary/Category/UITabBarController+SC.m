//
//  UITabBarController+SC.m
//  sma11case
//
//  Created by sma11case on 9/11/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "UITabBarController+SC.h"
#import "../../../Common/ShareClass/ShareClass.h"

@implementation UITabBarController (sma11case_IOS)

- (void)setTabBarHeight: (CGFloat)height
{
    CGRect frame = self.tabBar.frame;
    frame.size.height = height;
    self.tabBar.frame = frame;
    UIView * transitionView = [[self.view subviews] objectAtIndex:0];
    transitionView.height = height;
}

@end
