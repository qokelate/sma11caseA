//
//  FireFoxBookmarkManager.m
//  sma11case
//
//  Created by sma11case on 11/8/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "FireFoxBookmarkManager.h"

NSString *const kChildren = @"children";
NSString *const kRoot = @"root";
NSString *const kTitle = @"title";
NSString *const kUri = @"uri";
NSString *const kType = @"type";

NSString *const kPlaceType = @"text/x-moz-place";
NSString *const kFolderType = @"text/x-moz-place-container";

@implementation FireFoxBookmarkModel
@end

@implementation FireFoxBookmarkManager
+ (NSDictionary *)loadBookmarksWithFile: (NSString *)file
{
    NSData *data = [NSData dataWithContentsOfFile:file];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return json;
}

+ (BOOL)saveBookmark: (NSDictionary *)json toFile: (NSString *)file
{
    DeleteFile(file);
    NSData *dataN = [NSJSONSerialization dataWithJSONObject:json options:0 error:NULL];
    return [dataN writeToFile:file atomically:NO];
}

+ (void)mergeRootFolder: (NSMutableArray *)bookmark
{
    NSUInteger count = bookmark.count;
    for (NSUInteger a = 0; a < count; ++a)
    {
        NSDictionary *value = bookmark[a];
        if (NO == IsKindOfClass(value, NSDictionary)) continue;
        
        NSString *root = value[kRoot];
        if (0 == root.length) continue;
        
        for (NSUInteger b = a + 1; b < count; ++b)
        {
            NSDictionary *buffer = bookmark[b];
            if (NO == IsKindOfClass(buffer, NSDictionary)) continue;
            
            NSString *sroot = buffer[kRoot];
            if (NO == [sroot isEqualToString:root]) continue;
            
            NSMutableArray *life = NewMutableArray();
            NSMutableDictionary *v1 = [value mutableCopy];
            v1[kChildren] = life;
            
            for (id object in value[kChildren])
            {
                [life addObject:object];
            }
            for (id object in buffer[kChildren])
            {
                [life addObject:object];
            }
            
            [bookmark removeObjectAtIndex:b];
            bookmark[a] = v1;
            count -= 1;
            if (b > a+1) b -= 1;
            else b = a + 1;
        }
    }
}

+ (void)removeDuplication: (NSMutableDictionary *)bookmark
{
    LogFunctionName();
    
    NSString *t1 = bookmark[kType];
    if (NO == [t1 isEqualToString:kFolderType]) return;
    
    NSMutableArray *array = bookmark[kChildren];
    NSUInteger count = array.count;
    for (NSUInteger a = 0; a < count; ++a)
    {
        NSMutableDictionary *value = array[a];
        if (NO == IsKindOfClass(value, NSDictionary)) continue;
        
        NSString *r1 = value[kRoot];
        NSString *t1 = value[kType];
        NSString *t2 = value[kTitle];
        NSString *u1 = value[kUri];
        
        for (NSUInteger b = a + 1; b < count; ++b)
        {
            NSMutableDictionary *buffer = array[b];
            if (NO == IsKindOfClass(buffer, NSDictionary)) continue;
            
            NSString *r1a = buffer[kRoot];
            NSString *t1a = buffer[kType];
            NSString *t2a = buffer[kTitle];
            NSString *u1a = buffer[kUri];
            
            // 如果是ROOT
            if (r1.length)
            {
                if ([r1a isEqualToString:r1])
                {
                    for (id obj in buffer[kChildren])
                    {
                        [FType(NSMutableArray *, value[kChildren]) addObject:obj];
                    }
                    [array removeObjectAtIndex:b];
                    count -= 1;
                    if (b > a + 1) b -= 1;
                    else b = a + 1;
                }
                continue;
            }
            
            // 如果是目录
            if ([t1 isEqualToString:kFolderType])
            {
                if (NO == [t1a isEqualToString:kFolderType]) continue;
                
                if ([t2 isEqualToString:t2a])
                {
                    for (id obj in buffer[kChildren])
                    {
                        [FType(NSMutableArray *, value[kChildren]) addObject:obj];
                    }
                    [array removeObjectAtIndex:b];
                    count -= 1;
                    if (b > a + 1) b -= 1;
                    else b = a + 1;
                }
                continue;
            }
            
            // 如果是站点
            if ([kPlaceType isEqualToString:t1])
            {
                if (NO == [kPlaceType isEqualToString:t1a]) continue;
                
                if ([u1 isEqualToString:u1a])
                {
                    [array removeObjectAtIndex:b];
                    count -= 1;
                    if (b > a + 1) b -= 1;
                    else b = a + 1;
                }
                continue;
            }
        }
    }
    
    for (id value in array)
    {
        [self removeDuplication:value];
    }
}

+ (NSMutableDictionary *)removeDuplicationElement: (NSDictionary *)bookmark
{
    NSMutableDictionary *b1 = [self copyAsMutable:bookmark];
    [self removeDuplication:b1];
    return b1;
}

+ (NSMutableDictionary *)mergeBookmarks: (NSDictionary *)source other: (NSDictionary *)bookmark
{
    NSString *root = source[kRoot];
    NSString *sroot = bookmark[kRoot];
    
    if (0 == root.length) return nil;
    if (0 == sroot.length) return nil;
    
    if (NO == [root isEqualToString:sroot])
    {
        NSMutableArray *buffer = [@[source, bookmark] mutableCopy];
        [self mergeRootFolder:buffer];
        
        NSMutableDictionary *result = NewMutableDictionary();
        result[kChildren] = buffer;
        result[kRoot] = @"NewRoot";
        return result;
    }
    
    NSMutableDictionary *result = [source mutableCopy];
    NSMutableArray *buffer = NewMutableArray();
    result[kChildren] = buffer;
    for (id value in source[kChildren])
    {
        [buffer addObject:value];
    }
    for (id value in bookmark[kChildren])
    {
        [buffer addObject:value];
    }
    [self mergeRootFolder:buffer];
    return result;
}

+ (NSMutableDictionary *)mergeBookmarksWithVAList: (NSDictionary *)first, ...
{
    NSMutableDictionary *result = nil;
    
    va_list ap;
    va_start(ap, first);
    
    NSDictionary *second = va_arg(ap, NSDictionary *);
    while (second)
    {
        result = [self mergeBookmarks:first other:second];
        second = va_arg(ap, NSDictionary *);
        first = result;
    }
    
    return result;
}

+ (id)copyAsMutable: (id)object
{
    if (IsKindOfClass(object, NSDictionary))
    {
        NSMutableDictionary *result = [object mutableCopy];
        for (NSString *key in result.allKeys)
        {
            id value = result[key];
            value = [self copyAsMutable:value];
            result[key] = value;
        }
        return result;
    }
    
    if (IsKindOfClass(object, NSArray))
    {
        NSMutableArray *result = [object mutableCopy];
        NSUInteger count = result.count;
        for (NSUInteger a = 0; a < count; ++a)
        {
            id value = result[a];
            value = [self copyAsMutable:value];
            result[a] = value;
        }
        return result;
    }
    
    return object;
}
@end
