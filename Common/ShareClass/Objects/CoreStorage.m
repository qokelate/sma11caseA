//
//  CoreStorage.m
//  sma11case
//
//  Created by sma11case on 15/8/18.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <sqlite3.h>
#import <objc/runtime.h>
#import "CoreStorage.h"

#if UseFMDB
#import "../ExternalsSource/ExternalsSource.h"
#import "../Category/Category.h"
#import "../Macros.h"
#import "../Functions.h"
#import "../IsRootClass.m"

#define SCLog(...) MLog(__VA_ARGS__)

NSString *const kDBColumnTypeText    = @"text DEFAULT ('')";
NSString *const kDBColumnTypeInteger = @"integer DEFAULT (0)";
NSString *const kDBColumnTypeFloat   = @"float DEFAULT (0.0)";
NSString *const kDBColumnTypeNumeric = @"numeric DEFAULT (0)";
NSString *const kDBColumnTypeDecimal = @"decimal DEFAULT (0)";
NSString *const kDBColumnTypeBit     = @"bit DEFAULT (0)";
NSString *const kDBColumnTypeBlob    = @"blob";
NSString *const kDBColumnTypeNull    = @"blob";

@implementation FMResultSet(sma11case_shareClass)
- (NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *temp = NewMutableDictionary();
    NSDictionary *buffer = [self columnNameToIndexMapEx];
    
    for (NSString *key in buffer.allKeys)
    {
        id obj = [self objectForColumnName:key.lowercaseString];
        [temp setObject:obj forKey:key];
    }
    
    return temp;
}

- (NSMutableDictionary *)columnNameToIndexMapEx
{
    static char gs_map = 0;
    
    NSMutableDictionary *map = objc_getAssociatedObject(self, &gs_map);
    
    if (nil == map)
    {
        int columnCount = sqlite3_column_count([_statement statement]);
        map = [[NSMutableDictionary alloc] initWithCapacity:(NSUInteger)columnCount];
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
            [map setObject:[NSNumber numberWithInt:columnIdx]
                    forKey:[NSString stringWithUTF8String:sqlite3_column_name([_statement statement], columnIdx)] ];
        }
        
        objc_setAssociatedObject(self, &gs_map, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return map;
}
@end

@implementation FMDatabase(SCStorage)

- (BOOL)executeUpdateWithSQL: (NSString *)sql params: (NSArray *)params block: (DataBaseUpdateBlock)block
{
#if IS_SMA11CASE_VERSION
    BOOL canExecute = YES;
    if (_dataBaseFilterBlock) canExecute = _dataBaseFilterBlock(_dataBase, @selector(executeUpdate:), params);
    if (YES == canExecute)
#endif
        
    {
        BOOL temp = [self executeUpdate:sql withArgumentsInArray:params];
        if (temp)
        {
            if (block) block(self, YES);
            return YES;
        }
        
        SCLog(@"SQL Error: code = %d, message = %@", [self lastErrorCode], [self lastErrorMessage]);
        if (block) block(self, NO);
    }
    
    return NO;
}

- (void)executeQueryWithSQL: (NSString *)sql params: (NSArray *)params block: (DataBaseQueryBlock)block
{
#if IS_SMA11CASE_VERSION
    BOOL canExecute = YES;
    if (_dataBaseFilterBlock) canExecute = _dataBaseFilterBlock(_dataBase, @selector(executeQuery:), params);
    if (YES == canExecute)
#endif
        
    {
        FMResultSet *rs = [self executeQuery:sql withArgumentsInArray:params];
        if (block) block(self, rs);
        [rs close];
    }
}

- (NSMutableArray *)queryAllTableNames
{
    __block NSMutableArray *result = nil;
    [self executeQueryWithSQL:@"SELECT name FROM sqlite_master WHERE type='table'" params:nil block:^(FMDatabase *database, FMResultSet *rs) {
        if (NO == [rs next]) return ;
        
        result = NewMutableArray();
        do
        {
            NSString *buffer = [rs stringForColumnIndex:0];
            [result addObject:buffer];
        }while ([rs next]);
    }];
    
    return result;
}

- (BOOL)existsTable: (NSString *)table
{
    NSString *temp = [NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type='table' AND name='%@' LIMIT 1", table];
    __block BOOL buffer = NO;
    [self executeQueryWithSQL:temp params:nil block:^(FMDatabase *database, FMResultSet *rs) {
        if (NO == [rs next]) return ;
        buffer = [rs boolForColumnIndex:0];
    }];
    return buffer;
}



- (BOOL)createTable: (NSString *)table fromTypeList: (NSDictionary *)data
{
    NSArray *keys = data.allKeys;
    NSString *key = keys[0];
    NSMutableString *buffer = NewMutableString();
    [buffer appendFormat:@"\"%@\" %@", key, data[key]];
    
    for (long a = 1; a < keys.count; ++a)
    {
        key = keys[a];
        [buffer appendFormat:@", \"%@\" %@", key, data[key]];
    }
    
    return [self createTable:table columnName:buffer, nil];
}

- (BOOL)createTable: (NSString *)table columnName: (NSString *)name, ...
{
    NSMutableString *temp = NewMutableString();
    [temp appendFormat:@"create table '%@' (%@", table, name];
    va_list ap;
    va_start(ap, name);
    name = va_arg(ap, NSString *);
    while (name)
    {
        [temp appendFormat:@", %@", name];
        name = va_arg(ap, NSString *);
    }
    va_end(ap);
    [temp appendString:@")"];
    
    return SQLExecuteUpdate(self, temp);
}

- (BOOL)removeTable: (NSString *)table
{
    NSString *temp = [NSString stringWithFormat:@"drop table '%@'", table];
    return SQLExecuteUpdate(self, temp);
}

- (BOOL)clearTable: (NSString *)table
{
    NSString *temp = [NSString stringWithFormat:@"delete from '%@'", table];
    return SQLExecuteUpdate(self, temp);
}

- (BOOL)renameTable: (NSString *)table to: (NSString *)name
{
    NSString *temp = [NSString stringWithFormat:@"ALTER TABLE '%@' RENAME TO '%@'", table, name];
    return SQLExecuteUpdate(self, temp);
}

- (NSString *)getTableCreateCMD: (NSString *)table
{
    NSString *temp = [NSString stringWithFormat:@"select * from 'sqlite_master' where tbl_name = '%@' LIMIT 1", table];
    __block NSString *buffer = nil;
    [self executeQueryWithSQL:temp params:nil block:^(FMDatabase *database, FMResultSet *rs) {
        if (NO == [rs next]) return ;
        
        buffer = [rs stringForColumn:@"sql"];
    }];
    return buffer;
}

- (NSMutableDictionary *)getTableColumnInfo: (NSString *)table
{
    NSString *temp = [NSString stringWithFormat:@"PRAGMA table_info([%@])", table];
    __block NSMutableDictionary *buffer = nil;
    [self executeQueryWithSQL:temp params:nil block:^(FMDatabase *database, FMResultSet *rs) {
        
        if (NO == [rs next]) return;
        
        buffer = NewMutableDictionary();
        do
        {
            [buffer setObject:[rs stringForColumn:@"type"] forKey:[rs stringForColumn:@"name"]];
        }while ([rs next]);
    }];
    return buffer;
}

- (BOOL)addColumnWithTable: (NSString *)table columnName: (NSString *)name
{
    NSString *temp = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN %@", table, name];
    return SQLExecuteUpdate(self, temp);
}

/*
 // 删除列
 ALTER TABLE "users" RENAME TO "oXHFcGcd04oXHFcGcd04_users"
 CREATE TABLE "users" ("gender" text,"age" integer,"isMan" integer,"name" text,"address" text,"addddd" TEXT DEFAULT (dd) ,"ad33443dddd" TEXT DEFAULT (dd) ,"ad3346643dddd" TEXT)
 INSERT INTO "users" SELECT "gender","age","isMan","name","address","addddd","ad33443dddd","ad3346643dddd" FROM "main"."oXHFcGcd04oXHFcGcd04_users"
 DROP TABLE "oXHFcGcd04oXHFcGcd04_users"
 

 // 改名列
 ALTER TABLE "users" RENAME TO "oXHFcGcd04oXHFcGcd04_users"
 CREATE TABLE "users" ("gender" text,"age" integer,"isMan" integer,"name" text,"address" text,"addddd" TEXT DEFAULT (dd) ,"aaaaaaaaa" TEXT DEFAULT (dd) ,"ad33443dddd" TEXT DEFAULT (dd) ,"ad3346643dddd" TEXT)
 INSERT INTO "users" SELECT "gender","age","isMan","name","address","addddd","ad333dddd","ad33443dddd","ad3346643dddd" FROM "main"."oXHFcGcd04oXHFcGcd04_users"
 DROP TABLE "oXHFcGcd04oXHFcGcd04_users"
 */

- (BOOL)removeColumnWithTable: (NSString *)table columnName: (NSString *)name
{
    return [self renameColumnWithTable:table oldName:name newName:nil];
}

- (BOOL)renameColumnWithTable: (NSString *)table oldName: (NSString *)oName newName: (NSString *)nName
{
    if (NO == [self existsTable:table]) return NO;
    
    NSArray *temp = [self queryAllDataFromTable:table];
    
    NSMutableDictionary *names = (id)[self getTableColumnInfo:table];
    if (0 == names.count) return NO;
    
    if (NO == IsKindOfClass(names, NSMutableDictionary)) names = [names mutableCopy];
    
    for (NSString *key in names.allKeys)
    {
        if (IsSameString(key, oName))
        {
            id obj = names[key];
            [names removeObjectForKey:key];
            if (nName.length) [names setObject:obj forKey:nName];
            break;
        }
    }
    
    for (NSString *key in names.allKeys)
    {
        if (IsSameString(names[key], @"text"))
        {
            [names setObject:kDBColumnTypeText forKey:key];
            continue;
        }
        
        if (IsSameString(names[key], @"float"))
        {
            [names setObject:kDBColumnTypeFloat forKey:key];
            continue;
        }
        
        if (IsSameString(names[key], @"numeric"))
        {
            [names setObject:kDBColumnTypeNumeric forKey:key];
            continue;
        }
        
        if (IsSameString(names[key], @"bit"))
        {
            [names setObject:kDBColumnTypeBit forKey:key];
            continue;
        }
        
        if (IsSameString(names[key], @"integer"))
        {
            [names setObject:kDBColumnTypeInteger forKey:key];
            continue;
        }
        
        if (IsSameString(names[key], @"blob"))
        {
            [names setObject:kDBColumnTypeBlob forKey:key];
            continue;
        }
        
        if (IsSameString(names[key], @"null"))
        {
            [names setObject:kDBColumnTypeNull forKey:key];
            continue;
        }
        
        if (IsSameString(names[key], @"decimal"))
        {
            [names setObject:kDBColumnTypeDecimal forKey:key];
            continue;
        }
    }
    
    [self removeTable:table];
    [self createTable:table fromTypeList:names];
    
    for (NSMutableDictionary *row in temp)
    {
        NSMutableDictionary *buffer = row;
        if (NO == IsKindOfClass(buffer, NSMutableDictionary)) buffer = [buffer mutableCopy];
        
        for (NSString *key in buffer)
        {
            if (IsSameString(key, oName))
            {
                id obj = buffer[key];
                [buffer removeObjectForKey:key];
                if (nName.length) [buffer setObject:obj forKey:nName];
                break;
            }
        }
        
        [self insertDataWithTable:table columnData:buffer];
    }
    
    return YES;
}

- (BOOL)removeRowWithTable: (NSString *)table indexName: (NSString *)name indexData: (id)data
{
    NSString *temp = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE \"%@\" = ?", table, name];
    return [self executeUpdateWithSQL:temp params:@[data] block:nil];
}

- (NSMutableDictionary *)removeInvalidKeyWithTable: (NSString *)table data: (NSDictionary *)data
{
    NSMutableDictionary *buffer = [self getTableColumnInfo:table];
    return (id)[data dictionaryWithValuesForKeys:buffer.allKeys];
}

- (NSUInteger)batchInsertWithTable: (NSString *)table columnData: (NSArray *)data
{
    NSUInteger count = 0;
    for (NSDictionary *temp in data)
    {
        if ([self insertDataWithTable:table columnData:temp]) count += 1;
    }
    return count;
}

- (NSUInteger)rowsCountWithTable: (NSString *)table
{
    NSString *temp = [NSString stringWithFormat:@"SELECT count(*) FROM '%@'", table];
    __block NSUInteger buffer = 0;
    [self executeQueryWithSQL:temp params:nil block:^(FMDatabase *database, FMResultSet *rs) {
        if (NO == [rs next]) return ;
        buffer = [rs longForColumnIndex:0];
    }];
    return buffer;
}

- (NSUInteger)rowsCountWithTable: (NSString *)table indexName: (NSString *)name indexData: (id)data
{
    NSString *temp = [NSString stringWithFormat:@"SELECT count(*) FROM '%@' WHERE \"%@\" = ?", table, name];
    __block NSUInteger buffer = 0;
    [self executeQueryWithSQL:temp params:@[data] block:^(FMDatabase *database, FMResultSet *rs) {
        if (NO == [rs next]) return ;
        buffer = [rs longForColumnIndex:0];
    }];
    return buffer;
}

- (BOOL)existsRowWithTable: (NSString *)table indexName: (NSString *)name indexData: (id)data
{
    NSString *temp = [NSString stringWithFormat:@"SELECT count(*) FROM '%@' WHERE \"%@\" = ? LIMIT 1", table, name];
    __block NSUInteger buffer = 0;
    [self executeQueryWithSQL:temp params:@[data] block:^(FMDatabase *database, FMResultSet *rs) {
        if (NO == [rs next]) return ;
        buffer = [rs longForColumnIndex:0];
    }];
    return (buffer);
}

- (BOOL)autoUpdateWithTable: (NSString *)table columnData: (NSDictionary *)data indexName: (NSString *)name indexData: (id)iData
{
    data = [self removeInvalidKeyWithTable:table data:data];
    
    if ([self existsRowWithTable:table indexName:name indexData:iData])
    {
        return [self updateDataWithTable:table indexName:name indexData:iData columnData:data];
    }
    
    return [self insertDataWithTable:table columnData:data];
}

- (BOOL)insertDataWithTable: (NSString *)table columnData: (NSDictionary *)data
{
    if (0 == data.count) return NO;
    
    NSArray *keys = data.allKeys;
    NSMutableArray *datas = NewMutableArray();
    
    NSMutableString *names = NewMutableString();
    [names appendFormat:@"'%@'", keys[0]];
    NSMutableString *values = NewMutableString();
    [values appendString: @"?"];
    
    for (long a = 1; a < keys.count; ++a)
    {
        NSString *key = keys[a];
        [names appendFormat:@", '%@'", key];
        [values appendString:@", ?"];
    }
    
    NSString *temp = [NSString stringWithFormat:@"insert into '%@' (%@) values(%@)", table, names, values];

    for (long a = 0; a < keys.count; ++a)
    {
         NSString *key = keys[a];
        [datas addObject:data[key]];
    }
    
    return [self executeUpdateWithSQL:temp params:datas block:nil];
}

- (BOOL)updateDataWithTable: (NSString *)table indexName: (NSString *)iName indexData: (id)iData columnData: (NSDictionary *)data
{
    NSArray *keys = data.allKeys;
    NSMutableArray *datas = NewMutableArray();
    
    NSString *key = keys[0];
    NSMutableString *temp = NewMutableString();
    [temp appendFormat:@"UPDATE '%@' SET '%@' = ?", table, key];
    
    for (long a = 1; a < keys.count; ++a)
    {
        key = keys[a];
        [temp appendFormat:@", '%@' = ?", key];
    }
    
    [temp appendFormat:@" WHERE \"%@\" = ?", iName];
    
    for (long a = 0; a < keys.count; ++a)
    {
        key = keys[a];
        [datas addObject:data[key]];
    }
    [datas addObject:iData];
    
    return [self executeUpdateWithSQL:temp params:datas block:nil];
}

- (NSMutableDictionary *)queryDataWithTable: (NSString *)table indexName: (NSString *)iName indexData: (id)iData
{
     NSString *buffer = [NSString stringWithFormat:@"select * from '%@' where \"%@\" = ? LIMIT 1", table, iName];
    
    __block NSMutableDictionary *temp = nil;
    [self executeQueryWithSQL:buffer params:@[iData] block:^(FMDatabase *database, FMResultSet *rs) {
        if (NO == [rs next]) return ;
        
        temp = [rs toDictionary];
    }];
    return temp;
}


- (NSMutableArray *)queryAllDataFromTable:(NSString *)table
{
    NSString *sql = [NSString stringWithFormat:@"select * from '%@'", table];
    
    __block NSMutableArray *result = nil;
    [self executeQueryWithSQL:sql params:nil block:^(FMDatabase *database, FMResultSet *rs) {
        if (NO == [rs next]) return;
        
        result = NewMutableArray();
        
        do
        {
            NSDictionary *temp = [rs toDictionary];
            [result addObject:temp];
        }while ([rs next]);
        
    }];
    
    return result;
}

- (NSMutableArray *)queryWithSQL: (NSString *)sql params: (NSArray *)params
{
    __block NSMutableArray *result = nil;
    [self executeQueryWithSQL:sql params:params block:^(FMDatabase *database, FMResultSet *rs) {
        if (NO == [rs next]) return;
        
        result = NewMutableArray();
        
        do
        {
            NSDictionary *temp = [rs toDictionary];
            [result addObject:temp];
        }while ([rs next]);
        
    }];
    
    return result;
}

@end
#endif

