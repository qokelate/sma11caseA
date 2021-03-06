//
//  SCFloatWindow.h
//  sma11case
//
//  Created by sma11case on 12/9/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Config.h"

@interface SCFloatWindow : UIWindow
@property (nonatomic, assign) BOOL movable;
@property (nonatomic, unsafe_unretained, readonly) UIView *contentView;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)locationChange:(UIPanGestureRecognizer*)p;

#if DisableNRM
- (instancetype)init SC_DISABLED;
- (instancetype)initWithCoder:(NSCoder *)aDecoder SC_DISABLED;
#endif
@end
