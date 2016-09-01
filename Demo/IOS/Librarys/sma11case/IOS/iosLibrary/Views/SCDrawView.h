//
//  SCDrawView.h
//  sma11case
//
//  Created by sma11case on 12/9/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Config.h"

typedef void(^DrawBlock)(CGContextRef context, CGRect rect);

@interface SCDrawView : UIView
- (void)setDrawBlock: (DrawBlock)block;
- (void)setLayoutSubviewsBlock: (CPViewBlock)block;
@end
