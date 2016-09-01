//
//  UIView+SC.m
//  sma11case
//
//  Created by sma11case on 9/10/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "UIView+SC.h"
#import "../Config.h"
#import "../Objects/Objects.h"

@implementation UIView(sma11case_IOS)
- (BOOL)isVisible
{
    if (isAppStateValid())
    {
        if (AppStateDidBecomeActiveNotification != getAppState()) return NO;
    }
    return (self.window ? YES : NO);
}

- (UIViewController *)responeViewController
{
    UIResponder *responder = [self nextResponder];
    while (NO == [responder isKindOfClass:[UIViewController class]])
    {
        responder = [responder nextResponder];
    }
    
    return FType(UIViewController *, responder);
}

- (UIViewController *)controller
{
    UIViewController *vc = nil;
    
    Class cls = nil;
    for (UIView* next = self.superview; next; next = next.superview)
    {
        LogAnything(NSStringFromClass([next class]));
        
        cls = NSClassFromString(@"UIViewControllerWrapperView");
        if (IsSameObject(cls, [next class]))
        {
            return [self responeViewController];
        }
        
        cls = NSClassFromString(@"UILayoutContainerView");
        if (IsSameObject(cls, [next class]))
        {
            return [self responeViewController];
        }
    }
    
    return vc;
}

- (UIImage*)saveAsImage
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    //[view.layer drawInContext:currnetContext];
    [self.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
    
}
@end

#if 0
-(UIViewController *)getCurrentRootViewController
{
    
    
    UIViewController *result;
    
    
    // Try to find the root view controller programmically
    
    
    // Find the top window (that is not an alert view or other window)
    
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    
    if (topWindow.windowLevel != UIWindowLevelNormal)
        
        
    {
        
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        
        for(topWindow in windows)
            
            
        {
            
            
            if (topWindow.windowLevel == UIWindowLevelNormal)
                
                
                break;
            
            
        }
        
        
    }
    
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    
    id nextResponder = [rootView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
        
        result = nextResponder;
        
        
        else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
            
            
            result = topWindow.rootViewController;
            
            
            else
                
                
                NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
                
                
                return result;
    
    
}
#endif
