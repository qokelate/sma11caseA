//
//  SCFloatWindow.m
//  sma11case
//
//  Created by sma11case on 12/9/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "SCFloatWindow.h"

@implementation SCFloatWindow
{
    CGPoint _offset;
    UIPanGestureRecognizer *_pan;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.rootViewController = NewClass(UIViewController);
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert;
        [self makeKeyAndVisible];
     }
    return self;
}

- (UIView *)contentView
{
    return self.rootViewController.view;
}

- (void)setMovable:(BOOL)movable
{
    _movable = movable;
    
    if (_movable && nil == _pan)
    {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        _pan = pan;
    }
    else if (NO == _movable && _pan)
    {
        [self removeGestureRecognizer:_pan];
        _pan = nil;
    }
}

-(void)locationChange:(UIPanGestureRecognizer*)p
{
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    if (UIGestureRecognizerStateBegan == p.state)
    {
        CGPoint pp = CGPointZero;
        pp.x = self.center.x - panPoint.x;
        pp.y = self.center.y - panPoint.y;
        _offset = pp;
        return;
    }
    
    self.center = CGPointMake(panPoint.x + _offset.x, panPoint.y + _offset.y);
}

@end
