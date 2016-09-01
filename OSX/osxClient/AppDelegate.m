//
//  AppDelegate.m
//  LibraryDemo_OSX
//
//  Created by sma11case on 9/3/15.
//
//

#import "AppDelegate.h"
#import "../osxLibrary/staticLibrary_OSX.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}
@end
