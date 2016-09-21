//
//  IOSUtils.h
//  sma11case
//
//  Created by sma11case on 10/15/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../Config.h"

extern CGFloat vScreenWidth;
extern CGFloat vScreenHeight;
extern double vSystemVersion;

#if IS_DEBUG_MODE
#define vScreenWidth (vScreenWidth+0.0f)
#define vScreenHeight (vScreenHeight+0.0f)
#define vSystemVersion (vSystemVersion+0.0f)
#endif

#define kScreenWidth  vScreenWidth
#define kScreenHeight vScreenHeight
#define kSystemVersion vSystemVersion

extern const CGFloat kSystemTabBarHeight        ;
extern const CGFloat kSystemNavigationBarHeight ;
extern const CGFloat kSystemStatusBarHeight     ;

void fpsStart();
size_t getFpsCount();
void fpsStop();

@interface IOSUtils : NSObject
+ (void)launchMailAppWithReceiver: (NSArray *)recvs subject: (NSString *)subject contentBody: (NSString *)body;
@end
