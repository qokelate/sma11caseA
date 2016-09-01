//
//  SCAppStatus.m
//  sma11case
//
//  Created by lianlian on 8/31/16.
//
//

#import "SCAppStatus.h"
#import "../Config.h"

@interface SCAppStatus : NSObject
@property (nonatomic, assign, readonly) AppState state;
@end

static SCAppStatus *gs_appState = nil;

BOOL isAppStateValid()
{
    return (gs_appState ? YES : NO);
}

void startUpdateAppState()
{
    gs_appState = NewClass(SCAppStatus);
}

void stopUpdateAppState()
{
    gs_appState = nil;
}

AppState getAppState()
{
    return gs_appState.state;
}

@implementation SCAppStatus
- (void)dealloc
{
    [NSNC removeObserver:self];
}

- (instancetype)init
{
    if (self = [super init])
    {
        _state = AppStateUnknow;
        
        [NSNC addObserver:self selector:@selector(notify:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [NSNC addObserver:self selector:@selector(notify:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)notify: (NSNotification *)sender
{
    NSString *type = sender.name;
    
    if (IsSameString(UIApplicationDidEnterBackgroundNotification, type))
    {
        _state = AppStateDidEnterBackgroundNotification;
    }
    else if (IsSameString(UIApplicationDidBecomeActiveNotification, type))
    {
        _state = AppStateDidBecomeActiveNotification;
    }
}
@end
