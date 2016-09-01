//
//  SCDrawView.h
//  sma11case
//
//  Created by sma11case on 2/17/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../Config.h"

typedef void(^DrawBlock)(CGRect rect);

@interface SCDrawView : NSView
- (void)setDrawBlock: (DrawBlock)block;
- (void)setLayoutSubviewsBlock: (CPViewBlock)block;
@end
