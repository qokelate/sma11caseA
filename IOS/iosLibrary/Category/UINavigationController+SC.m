//
//  UINavigationController+SC.m
//  sma11case
//
//  Created by sma11case on 11/10/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "UINavigationController+SC.h"

@implementation UINavigationController(sma11case_IOS)
- (void)pushViewController:(UIViewController *)vc animation:(CATransition *)animation
{
    [self.view.layer addAnimation:animation forKey:nil];
    [self pushViewController:vc animated:NO];
}

@end
