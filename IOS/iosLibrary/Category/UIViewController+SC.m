/*
 *
 *  UINavigationController+SC.m
 *  sma11case
 *
 *  Created by sma11case on 9/11/15.
 *  Copyright © 2015 sma11case. All rights reserved.
 *
 */

#import <objc/runtime.h>
#import "UIViewController+SC.h"
#import "UIImage+SC.h"
#import "../../../Common/ShareClass/ShareClass.h"
#import "../Category/Category.h"

@implementation UIViewController (sma11case_IOS)
- (BOOL)isVisible
{
    return (self.isViewLoaded && self.view.isVisible);
}

#if USE_SYS_NVC
- (void)sysnvc_setBackgroudImageWithColor: (UIColor *)color
{
    CGSize	size	= self.navigationController.navigationBar.frame.size;
    UIImage *temp	= [UIImage generateImageWithColor:color size:size];
    [[UINavigationBar appearance] setBackgroundImage:temp forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].translucent = NO;
}


- (void)sysnvc_setNavigationBarHidden:(BOOL)hidden
{
    [self sysnvc_setNavigationBarHidden:hidden animated:NO];
}


- (void)sysnvc_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    CGFloat alpha	= (hidden ? 0.0f : 1.0f);
    CGFloat y	= (hidden ? -44.0f : 0.0f);
    
    CopyAsWeak(self, ws);
    if ( NO == animated )
    {
        ws.navigationController.navigationBar.y = y;
        for ( UIView * view in ws.navigationController.navigationBar.subviews )
        {
            view.alpha = alpha;
        }
        ws.navigationController.navigationBarHidden = hidden;
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        ws.navigationController.navigationBar.y = y;
        for ( UIView * view in ws.navigationController.navigationBar.subviews )
        {
            view.alpha = alpha;
        }
    } completion:^(BOOL finished) {
        ws.navigationController.navigationBarHidden = hidden;
    }];
}
#endif
@end

