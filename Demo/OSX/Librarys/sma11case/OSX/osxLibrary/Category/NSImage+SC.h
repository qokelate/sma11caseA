//
//  NSImage+SC.h
//  sma11case
//
//  Created by sma11case on 11/13/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface NSImage(sma11case_OSX)
- (CGFloat)width;
- (CGFloat)height;
- (BOOL)saveImageToFile: (NSString *)path fileType: (NSBitmapImageFileType)type;
@end
