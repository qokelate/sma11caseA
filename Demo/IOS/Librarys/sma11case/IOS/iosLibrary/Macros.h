//
//  Macros.h
//  sma11case
//
//  Created by sma11case on 10/18/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

// 简写宏
#define NewButton() [UIButton buttonWithType:UIButtonTypeCustom]
#define NewRectButton(x) [UIButton buttonWithRoundedRectWithArc:x]

// 设备类型判断
#define IsIPadDevice()     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IsIPhoneDevice()   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define GetImageWithFile(x) [[UIImage alloc] initWithContentsOfFile:x]
#define GetImageWithName(x) [UIImage imageNamed:x]

// 单例宏
#define AppDelegateShared ((AppDelegate *)([UIApplication sharedApplication].delegate))
#define AppMsgDispatcher (AppDelegateShared.msgDispatcher)

// 尺寸宏
#define ScreenSize ([[UIScreen mainScreen] bounds].size)
#define ScreenWidth (ScreenSize.width)
#define ScreenHeight (ScreenSize.height)
#define ScreenFrame (CGRectMake(0, 0, ScreenWidth, ScreenHeight))
#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define ViewSize(x) x.frame.size
#define ViewWidth(x) x.frame.size.width
#define ViewHeight(x) x.frame.size.height
#define ViewAbsFrame(x) CGRectMake(0, 0, ViewWidth(x), ViewHeight(x))

#define NavigationBarHeight self.navigationController.navigationBar.frame.size.height
#define TabBarHeight self.tabBarController.tabBar.frame.size.height
#define InvalidViewHeight (StatusBarHeight + NavigationBarHeight + TabBarHeight)
#define ValidViewHeight (ScreenHeight - InvalidViewHeight)

