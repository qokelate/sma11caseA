//
//  UIImageView+SC.h
//  sma11case
//
//  Created by sma11case on 11/13/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView(sma11case_IOS)
- (void)setSizeFromSelfImageWithScale: (CGFloat)scale;
- (void)setSizeFromImage: (UIImage *)image scale: (CGFloat)scale;
@end
