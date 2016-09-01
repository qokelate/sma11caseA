//
//  SCDrawView.m
//  sma11case
//
//  Created by sma11case on 2/17/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import "SCDrawView.h"

@implementation SCDrawView
{
    DrawBlock _drawBlock;
    CPViewBlock _layoutSubviewsBlock;
}

- (void)setLayoutSubviewsBlock: (CPViewBlock)block
{
    _layoutSubviewsBlock = block;
}

- (void)setDrawBlock:(DrawBlock)block
{
    _drawBlock = block;
}

- (void)drawRect:(CGRect)rect
{
    if (_drawBlock) _drawBlock(rect);
}

- (void)layoutSubviews
{
    if (_layoutSubviewsBlock) _layoutSubviewsBlock(self);
}
@end
