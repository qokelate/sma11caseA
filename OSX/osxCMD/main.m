//
//  main.m
//  osxCMD
//
//  Created by sma11case on 9/22/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

int g_argc = 0;
const char **g_argv = NULL;

int main(int argc, const char * argv[])
{
    g_argc = argc;
    g_argv = argv;
    
    @autoreleasepool
    {
		[AppDelegate launchWithArgc:argc argv:argv];   
    }
    return 0;
}
