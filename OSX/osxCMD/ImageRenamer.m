//
//  ImageRenamer.m
//  sma11case
//
//  Created by sma11case on 11/13/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "ImageRenamer.h"

@implementation ImageRenamer
+ (void)formatNameWithPath: (NSString *)path param: (id)param
{
    [NSFM enumFilesWithPath:path userParam:param block:^BOOL(NSString *dirPath, NSString *fileName, BOOL isDir, id userParam) {
        
        NSString *path = [dirPath stringByAppendingPathComponent:fileName];
        
        if ([fileName.lowercaseString isEqualToString:@"thumbs.db"])
        {
            DeleteFile(path);
            return YES;
        }
        
        if ([fileName regexpCheck:@"_\\d+x\\d+\\.[^\\.]+$"]) return YES;
        
        NSString *name = [fileName regexpReplace:@"\\.[^\\.]+$" replace:@""];
        NSString *exName = [fileName regexpFirstMatch:@"\\.[^\\.]+$"];
        NSString *mode = [name regexpFirstMatch:@"@\\d+[xX]$"];
        if (0 == mode.length) mode = @"";
        else name = [name regexpReplace:@"@\\d+[xX]$" replace:@""];
        
        if ([exName.lowercaseString isEqualToString:@".png"]
            || [exName.lowercaseString isEqualToString:@".jpg"])
        {
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
            
            NSString *temp = [NSString stringWithFormat:@"%@/%@_%lux%lu%@%@", dirPath, name, (unsigned long)image.size.width, (unsigned long)image.size.height, mode, exName];
            
            MoveFile(path, temp);
            MLog(@"%@ --> %@", fileName, temp.lastPathComponent);
        }
        
        return YES;
    }];
}
@end
