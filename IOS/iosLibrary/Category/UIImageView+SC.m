//
//  UIImageView+SC.m
//  sma11case
//
//  Created by sma11case on 11/13/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "UIImageView+SC.h"
#import "../../../Common/ShareClass/CrossPlatform/CPView.h"
#import "../ExternalsSource/ExternalsSource.h"

@implementation UIImageView(sma11case_IOS)
- (void)setSizeFromSelfImageWithScale: (CGFloat)scale
{
    [self setSizeFromImage:self.image scale:scale];
}

- (void)setSizeFromImage: (UIImage *)image scale: (CGFloat)scale
{
    self.size = CGSizeMake(image.size.width * scale, image.size.height * scale);
}
@end
