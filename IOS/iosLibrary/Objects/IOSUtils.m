//
//  IOSUtils.m
//  sma11case
//
//  Created by sma11case on 10/15/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "IOSUtils.h"

#undef vScreenWidth
#undef vScreenHeight
#undef vSystemVersion

CGFloat vScreenWidth = 0.0f;
CGFloat vScreenHeight = 0.0f;
double vSystemVersion = 0.0;

const CGFloat kSystemTabBarHeight        = 44.0f;
const CGFloat kSystemNavigationBarHeight = 44.0f;
const CGFloat kSystemStatusBarHeight     = 20.0f;

static __unsafe_unretained CADisplayLink *gs_fpsLink = nil;
static size_t gs_fpsCount = 0;

@interface IOSUtils()
+ (void)fpsTick:(CADisplayLink *)link;
@end

void fpsStart()
{
    if (gs_fpsLink) return;
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:[IOSUtils class] selector:@selector(fpsTick:)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    gs_fpsLink = link;
}

size_t getFpsCount()
{
    return gs_fpsCount;
}

void fpsStop()
{
    [gs_fpsLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    gs_fpsLink = nil;
}

@implementation IOSUtils

+ (void)load
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    vScreenWidth = size.width;
    vScreenHeight = size.height;
    vSystemVersion = [UIDevice currentDevice].systemVersion.doubleValue;
}

+ (void)fpsTick:(CADisplayLink *)link
{
    static size_t _count = 0;
    static NSTimeInterval _lastTime = 0;
    
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    
    _lastTime = link.timestamp;
    double fps = _count / delta;
    _count = 0;
    
    gs_fpsCount = (size_t)round(fps);
}

+ (void)launchMailAppWithReceiver: (NSArray *)recvs subject: (NSString *)subject contentBody: (NSString *)body
{
    NSMutableString *mailUrl = [[NSMutableString alloc] initWithCapacity:64UL];
    
    //添加收件人
    NSArray *toRecipients = recvs;
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    
    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    
    //添加密送
//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
//    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    
    //添加主题
    [mailUrl appendString:subject];
    
    //添加邮件内容
    [mailUrl appendString:body];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}
@end
