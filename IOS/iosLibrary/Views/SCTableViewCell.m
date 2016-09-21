//
//  SCTableViewCell.m
//  sma11case
//
//  Created by sma11case on 10/25/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "SCTableViewCell.h"

@interface SCTableViewCell ()
@end

@implementation SCTableViewCell
{
    CustomDeleteViewBlock _customDeleteViewBlock;
}

#if IS_DEBUG_MODE
ImpDebugDeallocMethod()
ImpDebugAllocMethod()
#endif

- (void)setCustomDeleteViewBlock:(CustomDeleteViewBlock)customDeleteViewBlock
{
    _customDeleteViewBlock = customDeleteViewBlock;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *view = nil;
    
    for (UIView *v in self.subviews)
    {
        if ([v isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
        {
            view = v;
            break;
        }
    }
    
    if (view)
    {
        UIButton *button = [view findSubviewWithClass:NSClassFromString(@"_UITableViewCellActionButton") maxCount:1].firstObject;
        
        if (button)
        {
            if (_customDeleteViewBlock) _customDeleteViewBlock(view, button);
        }
    }
    
}
@end
