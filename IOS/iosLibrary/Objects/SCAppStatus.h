//
//  AppState.h
//  sma11case
//
//  Created by lianlian on 8/31/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AppState)
{
    AppStateUnknow = 0,
    AppStateDidEnterBackgroundNotification,
    AppStateDidBecomeActiveNotification,
};

// call startUpdateAppState() to initialze app state
// - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

void startUpdateAppState();
void stopUpdateAppState();

BOOL isAppStateValid();
AppState getAppState();

