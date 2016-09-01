//
//  NSWindow+SC.m
//  sma11case
//
//  Created by sma11case on 12/1/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "NSWindow+SC.h"

@implementation NSWindow(sma11case_OSX)
#pragma mark Frame

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGSize)size
{
    return self.frame.size;
}

#pragma mark Frame Origin

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)xx
{
    return (self.x + self.width);
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)yy
{
    return (self.y + self.height);
}

#pragma mark Frame Size

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

#pragma mark Frame Borders

- (CGFloat)left
{
    return self.x;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)top
{
    return self.y;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

#pragma mark Center Point
#if 0
- (CGPoint)center
{
    return CGPointMake(self.left + self.middleX, self.top + self.middleY);
}

- (CGFloat)centerX
{
    return self.x + self.width/2;
}

- (CGFloat)centerY
{
    return self.y + self.height/2;
}
#endif

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
