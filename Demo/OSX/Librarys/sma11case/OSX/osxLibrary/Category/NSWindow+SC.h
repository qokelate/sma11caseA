//
//  NSWindow+SC.h
//  sma11case
//
//  Created by sma11case on 12/1/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSWindow(sma11case_OSX)
// Frame
@property (nonatomic, assign, readonly) CGPoint origin;
@property (nonatomic, assign, readonly) CGSize size;

// Frame Origin
@property (nonatomic, assign, readonly) CGFloat x;
@property (nonatomic, assign, readonly) CGFloat y;

@property (nonatomic, assign, readonly) CGFloat xx;
@property (nonatomic, assign, readonly) CGFloat yy;

// Frame Size
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;

// Frame Borders
@property (nonatomic, assign, readonly) CGFloat top;
@property (nonatomic, assign, readonly) CGFloat left;
@property (nonatomic, assign, readonly) CGFloat bottom;
@property (nonatomic, assign, readonly) CGFloat right;

// Center Point
#if 0
@property (nonatomic, assign, readonly) CGPoint center;
@property (nonatomic, assign, readonly) CGFloat centerX;
@property (nonatomic, assign, readonly) CGFloat centerY;
#endif

// Middle Point
@property (nonatomic, assign, readonly) CGPoint middlePoint;
@property (nonatomic, assign, readonly) CGFloat middleX;
@property (nonatomic, assign, readonly) CGFloat middleY;
@end
