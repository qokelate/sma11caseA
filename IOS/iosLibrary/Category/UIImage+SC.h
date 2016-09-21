//
//  UIImage+SC.h
//  sma11case
//
//  Created by sma11case on 8/29/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../Config.h"

typedef NS_ENUM(NSUInteger, ImageType)
{
    ImageTypeUnknow = 0,
    ImageTypeJPEG,
    ImageTypePNG,
    ImageTypeGIF,
    ImageTypeTIFF,
};

typedef void(^SaveAlbumBlock)(UIImage *image, NSError *error);

UIImage *getScreenShot(BOOL onlyKeyWindow);
ImageType getImageTypeFromData(NSData *data);

@interface UIImage(sma11case_IOS)
- (CGFloat)width;
- (CGFloat)height;
- (NSData *)toData;
- (UIImage *)circleImage;
- (BOOL)writeToFile: (NSString *)path;
- (void)saveToAlbumWithWaitFinished: (BOOL)wait block: (SaveAlbumBlock)block;

+ (UIImage *)generateImageWithColor:(UIColor *)color;
+ (UIImage *)generateImageWithColor:(UIColor *)color size: (CGSize)size;
@end



