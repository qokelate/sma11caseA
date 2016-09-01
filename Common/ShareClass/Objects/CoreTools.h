//
//  CoreTools.h
//  sma11case
//
//  Created by sma11case on 9/2/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "SCObject.h"
#import "SCModel.h"

typedef NS_ENUM(NSUInteger, SystemSleepFeatureType)
{
    SystemSleepTypeUnknow = 0,
    SystemSleepTypeDisplaySleepOn,
    SystemSleepTypeDisplaySleepOff,
    SystemSleepTypeIdleSleepOn,
    SystemSleepTypeIdleSleepOff
};

size_t getAvailableMemory();
size_t getUsedMemory();

#if PLAT_OSX
NSArray *getAllProcessWorkDirs();
void disableSystemSleep(SystemSleepFeatureType type);
NSString *executeCommand(NSString *cmd, BOOL waitFinished);
#endif
