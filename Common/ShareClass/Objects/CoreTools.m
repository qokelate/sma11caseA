//
//  CoreTools.m
//  sma11case
//
//  Created by sma11case on 9/2/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "CoreTools.h"
#import "../Macros.h"
#import "WeakArray.h"
#import "WeakDictionary.h"
#import "../IsRootClass.m"
#import "../Functions.h"
#import <mach/mach_host.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

#define SCLog(...) //MLog(__VA_ARGS__)

#if PLAT_OSX
#import <IOKit/pwr_mgt/IOPMLib.h>
static IOPMAssertionID displaySleepAssertionID = 0;
static IOPMAssertionID idleSleepAssertionID = 0;
#endif

size_t getAvailableMemory()
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    if (kernReturn != KERN_SUCCESS) return 0;
    return vmStats.free_count * PageSize;
}

size_t getUsedMemory()
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS ) return 0;
    return taskInfo.resident_size;
}

#if PLAT_OSX
NSString *executeCommand(NSString *cmd, BOOL waitFinished)
{
    FILE *pipe = popen( [cmd cStringUsingEncoding: NSASCIIStringEncoding], "r+" );
    if (NO == waitFinished) return nil;
    if (!pipe) return nil;
    
    NSString *output = @"";
    
    char buf[1024] = {0};
    while (fgets( buf, 1024, pipe ) )
    {
        output = [output stringByAppendingFormat: @"%s", buf];
        [NSThread sleepForTimeInterval:0.01];
    }
    
    pclose( pipe );
    return(output);
}

void disableSystemSleep(SystemSleepFeatureType type)
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    switch (type)
    {
        case SystemSleepTypeDisplaySleepOn:
            // Enable display sleep
            IOPMAssertionCreate(kIOPMAssertionTypeNoDisplaySleep, kIOPMAssertionLevelOn, &displaySleepAssertionID);
            break;
            
        case SystemSleepTypeDisplaySleepOff:
            // Disable display sleep
            IOPMAssertionRelease(displaySleepAssertionID);
            displaySleepAssertionID = 0;
            break;
            
            case SystemSleepTypeIdleSleepOn:
            // Enable idle sleep
            IOPMAssertionCreate(kIOPMAssertionTypeNoIdleSleep, kIOPMAssertionLevelOn, &idleSleepAssertionID);
            break;
            
            case SystemSleepTypeIdleSleepOff:
            // Disable idle sleep
            IOPMAssertionRelease(idleSleepAssertionID);
            idleSleepAssertionID = 0;
            break;
            
            case SystemSleepTypeUnknow:
            break;
    }
#pragma clang diagnostic pop
}

NSArray *getAllProcessWorkDirs()
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSWorkspace * ws = [NSWorkspace sharedWorkspace];
    NSArray * appsPids = [ws launchedApplications];
    
    if (0 == appsPids.count) return nil;
    return appsPids;
#pragma clang diagnostic pop
}
#endif
