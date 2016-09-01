//
//  CoreStorage.h
//  sma11case
//
//  Created by sma11case on 15/8/18.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Config.h"

#ifndef HaveFMDB
#if __has_include( "FMDB.h" )
#define HaveFMDB 1UL
#import "FMDB.h"
#endif
#endif

#if IS_DEV_MODE
#if (!defined(HaveFMDB) && defined(PLAT_IOS))
#if __has_include( "../../../IOS/iosComponents/build/Headers/FMDB.h" )
#define HaveFMDB 1UL
#import "../../../IOS/iosComponents/build/Headers/FMDB.h"
#endif
#endif

#if (!defined(HaveFMDB) && defined(PLAT_OSX))
#if __has_include( "../../../OSX/osxComponents/build/Headers/FMDB.h" )
#define HaveFMDB 1UL
#import "../../../OSX/osxComponents/build/Headers/FMDB.h"
#endif
#endif
#endif

#if HaveFMDB
#ifndef UseFMDB
#define UseFMDB 1UL
#endif
#endif

#if UseFMDB
extern NSString *const kDBColumnTypeText;
extern NSString *const kDBColumnTypeInteger;
extern NSString *const kDBColumnTypeFloat;
extern NSString *const kDBColumnTypeNumeric;
extern NSString *const kkDBColumnTypeDecimal;
extern NSString *const kDBColumnTypeBit;
extern NSString *const kDBColumnTypeBlob;
extern NSString *const kDBColumnTypeNull;

typedef void(^DataBaseUpdateBlock)(FMDatabase *database, BOOL state);
typedef void(^DataBaseQueryBlock)(FMDatabase *database, FMResultSet *rs);

@interface FMResultSet(sma11case_shareClass)
- (NSMutableDictionary *)toDictionary;
- (NSMutableDictionary *)columnNameToIndexMapEx;
@end

@interface FMDatabase(SCStorage)

#if IS_SMA11CASE_VERSION
typedef BOOL(^DataBaseFilterBlok)(FMDatabase *database, SEL selector, NSArray *params);
@property (nonatomic, strong) DataBaseFilterBlok dataBaseFilterBlock;
#endif

// @[sql, arg1, arg2, arg3, ...]
- (BOOL)executeUpdateWithSQL: (NSString *)sql params: (NSArray *)params block: (DataBaseUpdateBlock)block;
- (void)executeQueryWithSQL: (NSString *)sql params: (NSArray *)params block: (DataBaseQueryBlock)block;

- (NSMutableArray *)queryAllTableNames;

- (BOOL)createTable: (NSString *)table fromTypeList: (NSDictionary *)data;
- (BOOL)createTable: (NSString *)table columnName: (NSString *)name, ...;

- (BOOL)existsTable: (NSString *)table;
- (NSMutableDictionary *)getTableColumnInfo: (NSString *)table;
- (NSString *)getTableCreateCMD: (NSString *)table;

- (BOOL)clearTable: (NSString *)table;
- (BOOL)removeTable: (NSString *)table;
- (BOOL)renameTable: (NSString *)table to: (NSString *)name;

- (BOOL)addColumnWithTable: (NSString *)table columnName: (NSString *)name;
- (BOOL)removeColumnWithTable: (NSString *)table columnName: (NSString *)name;
- (BOOL)renameColumnWithTable: (NSString *)table oldName: (NSString *)oName newName: (NSString *)nName;

- (NSUInteger)batchInsertWithTable: (NSString *)table columnData: (NSArray *)data;
- (BOOL)insertDataWithTable: (NSString *)table columnData: (NSDictionary *)data;
- (BOOL)updateDataWithTable: (NSString *)table indexName: (NSString *)iName indexData: (id)iData columnData: (NSDictionary *)data;
- (BOOL)autoUpdateWithTable: (NSString *)table columnData: (NSDictionary *)data indexName: (NSString *)name indexData: (id)iData;

- (NSMutableDictionary *)removeInvalidKeyWithTable: (NSString *)table data: (NSDictionary *)data;
- (BOOL)removeRowWithTable: (NSString *)table indexName: (NSString *)name indexData: (id)data;

- (NSUInteger)rowsCountWithTable: (NSString *)table;
- (NSUInteger)rowsCountWithTable: (NSString *)table indexName: (NSString *)name indexData: (id)data;
- (BOOL)existsRowWithTable: (NSString *)table indexName: (NSString *)name indexData: (id)data;

- (NSMutableDictionary *)queryDataWithTable: (NSString *)table indexName: (NSString *)iName indexData: (id)iData;

- (NSMutableArray *)queryAllDataFromTable:(NSString *)table;

- (NSMutableArray *)queryWithSQL: (NSString *)sql params: (NSArray *)params;
@end
#endif


