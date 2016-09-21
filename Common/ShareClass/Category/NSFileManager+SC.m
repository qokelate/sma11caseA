//
//  NSFileManager+SC.m
//  sma11case
//
//  Created by sma11case on 8/29/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "NSFileManager+SC.h"
#import "../Macros.h"
#import "NSString+SC.h"
#import <sys/stat.h>

@implementation NSFileManager(sma11case_ShareClass)
- (NSMutableArray *)getFilesWithRootFolder: (NSString *)sourceDir fileTypes: (NSArray *)types ignoringCase: (BOOL)icase
{
    NSMutableArray *array = NewMutableArray();
    
    [self enumFilesWithPath:sourceDir block:^BOOL(NSString *dirPath, NSString *fileName, BOOL isDir) {
        
        if (isDir) return YES;
        
        BOOL state = NO;
        for (NSString *type in types)
        {
            if (icase)
            {
                if ([type.lowercaseString isEqualToString:[fileName regexpFirstMatch:@"\\.[^\\.]+$"].lowercaseString])
                {
                    state = YES;
                    break;
                }
                continue;
            }
            
            if ([type isEqualToString:[fileName regexpFirstMatch:@"\\.[^\\.]+$"]])
            {
                state = YES;
                break;
            }
        }
        
        if (NO == state) return YES;
        
        [array addObject:[NSString stringWithFormat:@"%@/%@", dirPath, fileName]];
        
        return YES;
    }];
    
    if (0 == array.count) return nil;
    return array;
}

- (unsigned long long)fileSizeAtPath: (NSString *)path
{
    NSDictionary *fileAttributes = [self attributesOfItemAtPath:path error:NULL];
    unsigned long long length = [fileAttributes fileSize];
    return length;
}

- (BOOL)enumFilesWithPath: (NSString *)path block: (EnumFileBlock)block
{
    NSArray *buffer = [self contentsOfDirectoryAtPath:path error:NULL];
    if (0 == buffer.count) return YES;
    
    for (NSString *aPath in buffer)
    {
        NSString * fullPath = [path stringByAppendingPathComponent:aPath];
        BOOL isDir = NO;
        [self fileExistsAtPath:fullPath isDirectory:&isDir];
        BOOL temp = block(path, aPath, isDir);
        if (NO == temp) return NO;
        
        if (isDir) temp = [self enumFilesWithPath:fullPath block:block];
        if (NO == temp) return NO;
    }
    return YES;
}

- (unsigned long long)folderSizeWithPath:(NSString *)filePath type:(FileSizeType)type
{
    unsigned long long totalSize = 0;
    NSMutableArray *searchPaths = [NSMutableArray arrayWithObject:filePath];
    while ([searchPaths count])
    {
        @autoreleasepool
        {
            NSString *fullPath = [searchPaths objectAtIndex:0];
            [searchPaths removeObjectAtIndex:0];
            
            struct stat fileStat;
            if (lstat([fullPath fileSystemRepresentation], &fileStat) == 0)
            {
                if (fileStat.st_mode & S_IFDIR)
                {
                    NSArray *childSubPaths = [self contentsOfDirectoryAtPath:fullPath error:NULL];
                    for (NSString *childItem in childSubPaths)
                    {
                        NSString *childPath = [fullPath stringByAppendingPathComponent:childItem];
                        [searchPaths insertObject:childPath atIndex:0];
                    }
                }else
                {
                    if (FileSizeTypeFileSize == type) totalSize += fileStat.st_blocks * 512;
                    else if (FileSizeTypeDiskSize == type) totalSize += fileStat.st_size;
                }
            }
        }
    }
    
    return totalSize;
}
@end
