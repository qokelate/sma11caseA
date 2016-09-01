//
//  CPView.h
//  sma11case
//
//  Created by sma11case on 11/23/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Config.h"
#import "CPColor.h"

#if PLAT_IOS
#define CPView UIView
#define CPTextField UITextField
#define CPEdgeInsets UIEdgeInsets
#define CPRect NSRect
#define CPSize NSSize
#endif

#if PLAT_OSX
#define CPView NSView
#define CPTextField NSTextField
#define CPEdgeInsets NSEdgeInsets
#define CPRect CGRect
#define CPSize CGSize
#endif

typedef void(^CPViewBlock)(CPView *view);

@interface CPView(sma11case_CrossPlatform)
// Frame
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

// Frame Origin
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat xx;
@property (nonatomic, assign) CGFloat yy;

// Frame Size
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

// Frame Borders
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

// Center Point
#if PLAT_OSX
@property (nonatomic, assign) CGPoint center;
#endif
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

// Middle Point
@property (nonatomic, readonly) CGPoint middlePoint;
@property (nonatomic, readonly) CGFloat middleX;
@property (nonatomic, readonly) CGFloat middleY;

- (void)removeAllSubviews;
- (void)setBorderWithColor: (CPColor *)color width: (CGFloat)width;
- (void)setShadowWithColor: (CPColor *)color offset: (CGSize)offset;
- (void)setRoundedRectWithArc: (CGFloat)arc;
- (BOOL)hasSubview: (CPView *)view;
- (BOOL)isSubviewForView: (CPView *)view;
- (void)removeSubview:(CPView *)view;
- (void)addSubviewsWithVAList:(CPView *)first, ...;
- (void)removeSubviewsWithVAList:(CPView *)first, ...;
- (NSMutableArray *)findSubviewWithClass: (Class)cls maxCount: (NSUInteger)count;
- (CPView *)superviewWithClass: (Class)cls;
@end

