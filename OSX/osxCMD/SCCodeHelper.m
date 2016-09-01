//
//  SCCodeHelper.m
//  sma11case
//
//  Created by sma11case on 2/18/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import "SCCodeHelper.h"
#import "../osxLibrary/staticLibrary_OSX.h"

@interface SCCoderFixImportHeaderInfo : SCModel
@property (nonatomic, strong) NSString *codeFile;
@property (nonatomic, strong) NSMutableString *codeString;

@property (nonatomic, strong) NSArray *validHeaders;
@property (nonatomic, strong) NSString *originImportLine;

@property (nonatomic, strong, readonly) NSString *headerFileName;
@property (nonatomic, strong, readonly) NSString *codeFileDir;
@property (nonatomic, strong, readonly) NSString *codeFileName;
@end

@implementation SCCoderFixImportHeaderInfo
- (void)setValidHeaders:(NSArray *)validHeaders
{
    _validHeaders = validHeaders;
    _headerFileName = [_validHeaders.firstObject lastPathComponent];
}

- (void)setCodeFile:(NSString *)codeFile
{
    _codeFile = codeFile;
    _codeFileDir = [_codeFile regexpReplace:@"/[^/]+$" replace:@""];
    _codeFileName = [_codeFile lastPathComponent];
}
@end

@implementation SCCodeHelper
+ (void)fixHeaderWithSourceFolder: (NSString *)sourceDir fileTypes: (NSArray *)types ignoringCase: (BOOL)icase
{
    NSMutableArray *array = [NSFM getFilesWithRootFolder:sourceDir fileTypes:types ignoringCase:icase];
    
    BreakPointHere;
    
    [self fixHeaderWithSourceFiles:array validFiles:array rootDir:sourceDir];
}

+ (void)fixHeaderWithSourceFiles: (NSArray *)files validFiles: (NSArray *)sourceFiles rootDir: (NSString *)root
{
    SCCoderFixImportHeaderInfo *info = NewClass(SCCoderFixImportHeaderInfo);

    for (NSString *ecx in files)
    {
        if (0 == ecx.length) continue;
        
        NSMutableString *code = [NSMutableString stringWithContentsOfFile:ecx encoding:NSUTF8StringEncoding error:NULL];
        if (0 == code.length) continue;
        
//        [code addDeallocBlock:^{
//            BreakPointHere;
//        }];
        
        NSMutableDictionary *imports = [self getImports:code];
        if (0 == imports.count) continue;
        
        for (NSString *file in imports.allKeys)
        {
            // 跳过精确引用
//            if (StringHasSubstring(file, @"/"))
//            {
//                NSLog(@"PAS: %@", file);
//                continue;
//            }
            
            NSString *name = [file lastPathComponent];
            NSArray *finds = [self find:name map:sourceFiles];
            if (0 == finds.count) continue;
            
            info.codeFile = ecx;
            info.codeString = code;
            info.validHeaders = finds;
            info.originImportLine = imports[file];
            
            BOOL state = [self fixCodeWithModel:info fbackLevel:0 rootDir:root];
            if (state) [code writeToFile:ecx atomically:YES encoding:NSUTF8StringEncoding error:NULL];
            BreakPointHere;
        }
        
        BreakPointHere;
    }
}

+ (BOOL)fixCodeWithModel: (SCCoderFixImportHeaderInfo *)info fbackLevel: (NSUInteger)fbackLevel rootDir: (NSString *)root
{
    NSString *codeFile = info.codeFile;
    NSString *headerFileName = info.headerFileName;
    NSString *originImportLine = info.originImportLine;
    NSString *codeFileDir = info.codeFileDir;
    NSMutableString *codeString = info.codeString;
    NSArray *validHeaders = info.validHeaders;
    
    // 跳过精确引用
//    if (StringHasSubstring(originImportLine, @"/"))
//    {
//        NSLog(@"PAS: %@", originImportLine);
//        return NO;
//    }
    
    BOOL codeChanged = NO;
    BOOL result = NO;
    
    if (fbackLevel)
    {
        for (NSUInteger a = 0; a < fbackLevel; ++a)
        {
            codeFileDir = [codeFileDir regexpReplace:@"/[^/]+$" replace:@""];
        }
        BreakPointHere;
    }
    
    {
        NSString *c1 = [codeFileDir stringByAppendingString:@"/"];
        NSString *c2 = [root stringByAppendingString:@"/"];
        if (NO == StringHasSubstring(c1, c2)) return NO;
    }
    
    {
        // 看看同目录
        NSString *ebx = [NSString stringWithFormat:@"%@/%@", codeFileDir, headerFileName];
        for (NSString *eax in validHeaders)
        {
            if (NO == IsSameString(eax, ebx)) continue;
            
            NSString *ecx = @"";
            if (fbackLevel)
            {
                for (NSUInteger a = 0; a < fbackLevel; ++a)
                {
                    ecx = [NSString stringWithFormat:@"../%@", ecx];
                }
            }
            
            NSString *line = nil;
            if ([originImportLine regexpCheck:@"#\\s*import\\s+\\x22"])
            {
                line = [NSString stringWithFormat:@"#import \"%@%@\"", ecx, headerFileName];
            }
            else if ([originImportLine regexpCheck:@"#\\s*include\\s+\\x22"])
            {
                line = [NSString stringWithFormat:@"#include \"%@%@\"", ecx, headerFileName];
            }
            
            else if ([originImportLine regexpCheck:@"#\\s*import\\s+\\x3C"])
            {
                line = [NSString stringWithFormat:@"#import \"%@%@\"", ecx, headerFileName];
            }
            else if ([originImportLine regexpCheck:@"#\\s*include\\s+\\x3C"])
            {
                line = [NSString stringWithFormat:@"#include \"%@%@\"", ecx, headerFileName];
            }
            
            NSString *target = [NSString stringWithFormat:@"\"%@%@\"", ecx, headerFileName];
            if (line && NO == StringHasSubstring(originImportLine, target))
            {
                NSString *targetFile = [codeFile stringByReplacingOccurrencesOfString:root withString:@""];
                NSLog(@"src: %@", targetFile);
                NSLog(@"fix: %@", originImportLine);
                NSLog(@"to : %@", line);
                NSLog(@"=========================================================");
                [codeString replaceOccurrencesOfString:originImportLine withString:line options:0 range:NSMakeRange(0, codeString.length)];
                codeChanged = YES;
            }
            
            result = YES;
            break;
        }
        
        if (result) return codeChanged;
    }
    
    // 看看子目录
    {
        NSString *buffer = [NSString stringWithFormat:@"%@/", codeFileDir];
        for (NSString *eax in validHeaders)
        {
            if (NO == StringHasSubstring(eax, buffer)) continue;
            
            buffer = [eax stringByReplacingOccurrencesOfString:buffer withString:@""];
            
            NSString *ecx = @"";
            if (fbackLevel)
            {
                for (NSUInteger a = 0; a < fbackLevel; ++a)
                {
                    ecx = [NSString stringWithFormat:@"../%@", ecx];
                }
            }
            
            NSString *line = nil;
            if ([originImportLine regexpCheck:@"#\\s*import\\s+\\x22"])
            {
                line = [NSString stringWithFormat:@"#import \"%@%@\"", ecx, buffer];
            }
            else if ([originImportLine regexpCheck:@"#\\s*include\\s+\\x22"])
            {
                line = [NSString stringWithFormat:@"#include \"%@%@\"", ecx, buffer];
            }
            
            else if ([originImportLine regexpCheck:@"#\\s*import\\s+\\x3C"])
            {
                line = [NSString stringWithFormat:@"#import \"%@%@\"", ecx, buffer];
            }
            else if ([originImportLine regexpCheck:@"#\\s*include\\s+\\x3C"])
            {
                line = [NSString stringWithFormat:@"#include \"%@%@\"", ecx, buffer];
            }
            
            NSString *target = [NSString stringWithFormat:@"\"%@%@\"", ecx, buffer];
            if (line && NO == StringHasSubstring(originImportLine, target))
            {
                NSString *targetFile = [codeFile stringByReplacingOccurrencesOfString:root withString:@""];
                NSLog(@"src: %@", targetFile);
                NSLog(@"fix: %@", originImportLine);
                NSLog(@"to : %@", line);
                NSLog(@"=========================================================");
                [codeString replaceOccurrencesOfString:originImportLine withString:line options:0 range:NSMakeRange(0, codeString.length)];
                codeChanged = YES;
            }
            
            result = YES;
            break;
        }
        
        if (result) return codeChanged;
    }
    
    // 看看上层目录
    {
        if (NO == [codeFileDir isEqualToString:@"/"])
        {
            codeChanged = [self fixCodeWithModel:info fbackLevel:fbackLevel+1 rootDir:root];
            return codeChanged;
        }
    }
    
    LogAnything(codeFileDir);
    LogAnything(info.validHeaders);
    BreakPointHere;
    return NO;
}

+ (NSMutableArray *)find: (NSString *)file map: (NSArray *)map
{
    NSMutableArray *result = NewMutableArray();
    
    for (NSString *name in map)
    {
        NSString *eax = [NSString stringWithFormat:@"/%@", file];
        if ([name hasSuffix:eax])
        {
            [result addObject:name];
        }
    }
    
    if (0 == result.count) return nil;
    return result;
}

+ (NSMutableDictionary *)getImports: (NSString *)code
{
    NSMutableDictionary *result = nil;
    
    {
        NSArray *imps = [code regexpMatch:@"[\\r\\n]{0,1}\\s*#\\s*import\\s+\\x22[^\\x22]+\\x22"];
        
        if (imps.count)
        {
            if (nil == result) result = NewMutableDictionary();
            
            for (NSString *eax in imps)
            {
                NSString *file = [eax regexpMatch:@"\\x22[^\\x22]+\\x22"][0];
                file = [file stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                result[file] = [eax regexpReplace:@"[\\r\\n]+" replace:@""];
            }
        }
    }
    
    {
        NSArray *imps = [code regexpMatch:@"[\\r\\n]{0,1}\\s*#\\s*include\\s+\\x22[^\\x22]+\\x22"];
        
        if (imps.count)
        {
            if (nil == result) result = NewMutableDictionary();
            
            for (NSString *eax in imps)
            {
                NSString *file = [eax regexpMatch:@"\\x22[^\\x22]+\\x22"][0];
                file = [file stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                result[file] = [eax regexpReplace:@"[\\r\\n]+" replace:@""];
            }
        }
    }
    
    {
        NSArray *imps = [code regexpMatch:@"[\\r\\n]{0,1}\\s*#\\s*import\\s+\\x3C[^\\x3E]+\\x3E"];
        
        if (imps.count)
        {
            if (nil == result) result = NewMutableDictionary();
            
            for (NSString *eax in imps)
            {
                NSString *file = [eax regexpMatch:@"\\x3C[^\\x3E]+\\x3E"][0];
                file = [file regexpReplace:@"[\\x3C\\x3E]" replace:@""];
                
                result[file] = [eax regexpReplace:@"[\\r\\n]+" replace:@""];
            }
        }
    }
    
    {
        NSArray *imps = [code regexpMatch:@"[\\r\\n]{0,1}\\s*#\\s*include\\s+\\x3C[^\\x3E]+\\x3E"];
        
        if (imps.count)
        {
            if (nil == result) result = NewMutableDictionary();
            
            for (NSString *eax in imps)
            {
                NSString *file = [eax regexpMatch:@"\\x3C[^\\x3E]+\\x3E"][0];
                file = [file regexpReplace:@"[\\x3C\\x3E]" replace:@""];
                
                result[file] = [eax regexpReplace:@"[\\r\\n]+" replace:@""];
            }
        }
    }
    
    return result;
}
@end
