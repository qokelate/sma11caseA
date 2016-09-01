//
//  NSFileManager+SC.h
//  sma11case
//
//  Created by sma11case on 8/29/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSFM [NSFileManager defaultManager]
#define GetFileSize(x) [NSFM fileSizeAtPath:x]
#define GetFolderSize(x) [NSFM folderSizeWithPath:x type:FileSizeTypeFileSize]
#define DeleteFile(x) [NSFM removeItemAtPath:x error:NULL]
#define MoveFile(x, y) [NSFM moveItemAtPath:x toPath:y error:NULL]


#define NSMB [NSBundle mainBundle]
#define ResourceDirectory NSMB.resourcePath
#define ProgramDirectory NSMB.bundlePath
#define CurrentDirectory [NSFM currentDirectoryPath]

typedef NS_ENUM(NSUInteger, FileSizeType)
{
    FileSizeTypeFileSize = 0,
    FileSizeTypeDiskSize,
};

typedef BOOL(^EnumFileBlock)(NSString *dirPath, NSString *fileName, BOOL isDir, id userParam);

@interface NSFileManager(sma11case_ShareClass)
- (BOOL)enumFilesWithPath: (NSString *)path userParam: (id)param block: (EnumFileBlock)block;
- (NSMutableArray *)getFilesWithRootFolder: (NSString *)sourceDir fileTypes: (NSArray *)types ignoringCase: (BOOL)icase;
- (unsigned long long)fileSizeAtPath: (NSString *)path;
- (unsigned long long)folderSizeWithPath:(NSString *)filePath type:(FileSizeType)type;
@end
