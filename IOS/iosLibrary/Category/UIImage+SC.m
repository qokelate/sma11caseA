//
//  UIImage+SC.m
//  sma11case
//
//  Created by sma11case on 8/29/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "UIImage+SC.h"
#import "../../../Common/ShareClass/ShareClass.h"
#import <float.h>
#import <Accelerate/Accelerate.h>

#define SCLog(...) MLog(__VA_ARGS__)

ImageType getImageTypeFromData(NSData *data)
{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c)
    {
        case 0xFF:
            return ImageTypeJPEG;
            
        case 0x89:
            return ImageTypePNG;
            
        case 0x47:
            return ImageTypeGIF;
            
        case 0x49:
        case 0x4D:
            return ImageTypeTIFF;
    }
    
    return ImageTypeUnknow;
}

UIImage *getScreenShot(BOOL onlyKeyWindow)
{
    UIView *screenWindow = (onlyKeyWindow ?
                            [[UIApplication sharedApplication] keyWindow] :
                            [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO]);
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@implementation UIImage(sma11case_IOS)
- (UIImage *)circleImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef    ctx = UIGraphicsGetCurrentContext();
    CGRect          rect = CGRectMake(0, 0, self.size.width, self.size.height);
    // 绘制一个内切圆
    CGContextAddEllipseInRect(ctx, rect);
    //按照上面的内切圆裁剪图形上下文
    CGContextClip(ctx);
    // 把image绘制到上述矩形框内部，由于矩形框内部已经被裁剪为一个内切圆，所以绘制上去的图片就是一个圆形
    [self drawInRect:rect];
    // 从图形上下文获取绘制好的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)saveToAlbumWithWaitFinished: (BOOL)wait block: (SaveAlbumBlock)block
{
    static dispatch_queue_t queue = nil;
    if (nil == queue) queue = dispatch_queue_create("sma11case.album.queue", NULL);
    
    if (NO == wait)
    {
        dispatch_async(queue, ^{
            UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), ObjectToPtr_Retain(block));
        });
        return;
    }

    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSDictionary *param = nil;
    if (block)
    {
        param = @{
                  @"block":block,
                  @"sema":sema,
                  };
    }
    else
    {
        param = @{
                  @"sema":sema,
                  };
    }
    
    dispatch_async(queue, ^{
        UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), ObjectToPtr_Retain(param));
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    id param = PtrToObject_Release(contextInfo);
    
    if ([param isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *pp = param;
        SaveAlbumBlock block = pp[@"block"];
        if (block) block(image, error);
        dispatch_semaphore_t sema = pp[@"sema"];
        dispatch_semaphore_signal(sema);
        return;
    }
    
    SaveAlbumBlock block = param;
    if (block) block(image, error);
}

- (BOOL)writeToFile: (NSString *)path
{
    NSData *data = nil;
    if (UIImagePNGRepresentation(self)) data = UIImagePNGRepresentation(self);
    else data = UIImageJPEGRepresentation(self, 1.0);
    if (nil == data) return NO;

    [NSFM removeItemAtPath:path error:NULL];
    return [NSFM createFileAtPath:path contents:data attributes:nil];
}

+ (UIImage *)generateImageWithColor:(UIColor *)color size: (CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)generateImageWithColor:(UIColor *)color
{
    return [self generateImageWithColor:color size:CGSizeMake(1, 1)];
}

- (NSData *)toData
{
    NSData* data = nil;
    data = UIImagePNGRepresentation(self);
    if (nil == data) data = UIImageJPEGRepresentation(self, 1.0);
    return data;
}

- (CGFloat)width
{
    return self.size.width;
}

- (CGFloat)height
{
    return self.size.height;
}
@end


