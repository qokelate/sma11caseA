//
//  CPView.m
//  sma11case
//
//  Created by sma11case on 11/23/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "CPView.h"
#import "../Macros.h"

@implementation CPView(sma11case_ShareClass)
- (void)removeAllSubviews
{
#if PLAT_IOS
    UIView *view = nil;
    while ((view = self.subviews.lastObject))
    {
        [view removeFromSuperview];
    }
#endif
    
#if PLAT_OSX
    self.subviews = @[];
#endif
}

- (BOOL)hasSubview: (CPView *)view
{
    for (CPView *v in self.subviews)
    {
        if (v == view) return YES;
        return [v hasSubview:view];
    }
    return NO;
}

- (BOOL)isSubviewForView: (CPView *)view
{
    return [view hasSubview:self];
}

- (void)setBorderWithColor: (CPColor *)color width: (CGFloat)width
{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)setShadowWithColor: (CPColor *)color offset: (CGSize)offset
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = YES;
}

- (void)setRoundedRectWithArc: (CGFloat)arc
{
    self.layer.cornerRadius = arc;
    self.layer.masksToBounds = YES;
}

- (void)removeSubview:(CPView *)view
{
    for (CPView *sv in self.subviews)
    {
        if (IsSameObject(view, sv))
        {
            [sv removeFromSuperview];
            break;
        }
    }
}

- (void)addSubviewsWithVAList:(CPView *)first, ...
{
    va_list ap;
    va_start(ap, first);
    
    while (first)
    {
        [self addSubview:first];
        first = va_arg(ap, CPView *);
    }
    va_end(ap);
}

- (void)removeSubviewsWithVAList:(CPView *)first, ...
{
    va_list ap;
    va_start(ap, first);
    
    while (first)
    {
        [self removeSubview:first];
        first = va_arg(ap, CPView *);
    }
    va_end(ap);
}

- (NSMutableArray *)findSubviewWithClass: (Class)cls maxCount: (NSUInteger)count
{
    return [self findSubviewWithClassEx:cls maxCount:count mustNil:nil];
}

- (NSMutableArray *)findSubviewWithClassEx: (Class)cls maxCount: (NSUInteger)count mustNil: (id)mustNil
{
    if (0 == self.subviews.count) return nil;
    
    NSMutableArray *temp = mustNil;
    if (nil == temp) temp = NewMutableArray();
    
    for (CPView *view in self.subviews)
    {
        if (IsKindOfClass(view, cls))
        {
            [temp addObject:view];
            if (count && temp.count == count) return temp;
        }
        
        if (view.subviews.count)
        {
            [view findSubviewWithClassEx:cls maxCount:count mustNil:temp];
            if (count && temp.count == count) return temp;
        }
    }
    
    if (0 == temp.count) return nil;
    return temp;
}

- (CPView *)superviewWithClass: (Class)cls
{
    CPView *view = self.superview;
    while (view)
    {
        if (IsKindOfClass(view, cls)) return view;
        view = view.superview;
    }
    return nil;
}

#pragma mark Frame

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newOrigin
{
    CGRect newFrame = self.frame;
    newFrame.origin = newOrigin;
    self.frame = newFrame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)newSize
{
    CGRect newFrame = self.frame;
    newFrame.size = newSize;
    self.frame = newFrame;
}


#pragma mark Frame Origin

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)newX
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = newX;
    self.frame = newFrame;
}

- (CGFloat)xx
{
    return (self.x + self.width);
}

- (void)setXx:(CGFloat)xx
{
    xx -= self.width;
    self.x = xx;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)newY
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = newY;
    self.frame = newFrame;
}

- (CGFloat)yy
{
    return (self.y + self.height);
}

- (void)setYy:(CGFloat)yy
{
    yy -= self.height;
    self.y = yy;
}


#pragma mark Frame Size

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight
{
    CGRect newFrame = self.frame;
    newFrame.size.height = newHeight;
    self.frame = newFrame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth
{
    CGRect newFrame = self.frame;
    newFrame.size.width = newWidth;
    self.frame = newFrame;
}


#pragma mark Frame Borders

- (CGFloat)left
{
    return self.x;
}

- (void)setLeft:(CGFloat)left
{
    self.x = left;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    self.x = right - self.width;
}

- (CGFloat)top
{
    return self.y;
}

- (void)setTop:(CGFloat)top
{
    self.y = top;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    self.y = bottom - self.height;
}


#pragma mark Center Point

#if PLAT_OSX
- (CGPoint)center
{
    return CGPointMake(self.left + self.middleX, self.top + self.middleY);
}

- (void)setCenter:(CGPoint)newCenter
{
    self.left = newCenter.x - self.middleX;
    self.top = newCenter.y - self.middleY;
}
#endif

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)newCenterX
{
    self.center = CGPointMake(newCenterX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)newCenterY
{
    self.center = CGPointMake(self.center.x, newCenterY);
}


#pragma mark Middle Point

- (CGPoint)middlePoint
{
    return CGPointMake(self.middleX, self.middleY);
}

- (CGFloat)middleX
{
    return self.width / 2;
}

- (CGFloat)middleY
{
    return self.height / 2;
}
@end
