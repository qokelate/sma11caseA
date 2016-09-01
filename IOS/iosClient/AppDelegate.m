//
//  AppDelegate.m
//  sma11case
//
//  Created by sma11case on 15/8/17.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *rvc = [[UIViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:rvc];
    
    self.window.rootViewController = nvc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
