//
//  NSImage.m
//  sma11case
//
//  Created by sma11case on 11/13/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "NSImage+SC.h"
#import "../Config.h"

@implementation NSImage(sma11case_OSX)
- (BOOL)saveImageToFile: (NSString *)path fileType: (NSBitmapImageFileType)type
{
    CGImageRef temp = [self CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *buffer = [[NSBitmapImageRep alloc] initWithCGImage:temp];
    buffer.size = self.size;
    
    NSData *data = [buffer representationUsingType:type properties:@{}];
    if (nil == data) return NO;
    
    return [data writeToFile:path atomically:YES];
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
