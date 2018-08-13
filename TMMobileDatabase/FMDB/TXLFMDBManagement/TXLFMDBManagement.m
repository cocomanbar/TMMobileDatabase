//
//  TXLFMDBManagement.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/3/30.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TXLFMDBManagement.h"
#import "FMDB.h"
#import <objc/runtime.h>

//宏字段
NSString *const TXLFMDBVersion = @"TXLFMDBVersion";
NSString *const TXLWCDBVersion = @"TXLWCDBVersion";

//建表需要的资源
#import "orange.h"
#import "TMLogsModel.h"

// 数据库中常见的几种类型
#define SQL_TEXT     @"TEXT"        //文本
#define SQL_INTEGER  @"INTEGER"     //int long integer ...
#define SQL_REAL     @"REAL"        //浮点
#define SQL_BLOB     @"BLOB"        //data

@interface TXLFMDBManagement ()

@property (nonatomic, strong)NSString *dbName;
@property (nonatomic, strong)FMDatabaseQueue *dbQueue;
@property (nonatomic, strong)FMDatabase *db;

@end

@implementation TXLFMDBManagement

#pragma mark - 类方法初始化数据库

+(void)managerDealloc{
    jqdb = nil;
}

- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue) {
        NSString *path = [TXLCachePath stringByAppendingPathComponent:_dbName];
        FMDatabaseQueue *fmdb = [FMDatabaseQueue databaseQueueWithPath:path];
        self.dbQueue = fmdb;
        [_db close];
        self.db = [fmdb valueForKey:@"_db"];
    }
    return _dbQueue;
}

//这个是CTMFMDBManager的单例

static TXLFMDBManagement *jqdb = nil;

+ (instancetype)shareDatabase
{
    return [TXLFMDBManagement shareDatabase:nil];
}

+ (instancetype)shareDatabase:(NSString *)dbName
{
    return [TXLFMDBManagement shareDatabase:dbName path:nil];
}

+ (instancetype)shareDatabase:(NSString *)dbName path:(NSString *)dbPath
{
    if (!jqdb) {
        NSString *path;
        if (!dbName) {
            dbName = [NSString stringWithFormat:@"/%@.sqlite",@"database"];
        }
        if (!dbPath) {
            path = [TXLCachePath stringByAppendingPathComponent:dbName];
        } else {
            path = dbPath;
        }
        FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
        if ([fmdb open]) {
            jqdb = TXLFMDBManagement.new;
            jqdb.db = fmdb;
            jqdb.dbName = dbName;
            [self updateDB];
        }
    }
    if (![jqdb.db open]) {
        return nil;
    };
    return jqdb;
}

#pragma mark - 升级数据库

+ (void)updateDB{
    NSString *FMDBVersion = [[NSUserDefaults standardUserDefaults] objectForKey:TXLFMDBVersion];
    if (!FMDBVersion || FMDBVersion.length <= 0) {
        [self createTablesForFirstInstallApp];
    }else{
        NSInteger ver = [FMDBVersion integerValue];
        switch (ver) {
            case 1:
            {
                // 做V1升级到V2版本的事..测试加表
                [self updateServerlocalDataBaseForV1];
                
            }
            case 2:
            {
                // 做V2升级到V3版本的事..测试加字段
                [self updateServerlocalDataBaseForV2];
                
            }
            case 3:
            {
                // 做V3升级到V4版本的事..
                
                
            }
            break;
            default:
            break;
        }
    }
}

/* 第一次安装 */
+ (void)createTablesForFirstInstallApp{
    
    //表1
    if (![[TXLFMDBManagement shareDatabase] jq_isExistTable:@"orangeTable"]) {
        [[TXLFMDBManagement shareDatabase] jq_createTable:@"orangeTable" dicOrModel:[orange class]];
    }
    //表2
    if (![[TXLFMDBManagement shareDatabase] jq_isExistTable:@"messageTable"]) {
        NSDictionary *dict = @{@"name":@"TEXT",
                               @"addressss":@"TEXT",
                               @"proDate":@"TEXT",
                               @"number":@"TEXT"};
        [[TXLFMDBManagement shareDatabase] jq_createTable:@"messageTable" dicOrModel:dict];
    }
    //
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1VDBVersion" forKey:TXLFMDBVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /* [很重要] */
    /* 再次调用本身继续升级数据库 - 防止第一次安装后else情况 */
    [TXLFMDBManagement updateDB];
}

//升级数据库 - 加一个logTable表
+ (void)updateServerlocalDataBaseForV1
{
    if (![[TXLFMDBManagement shareDatabase] jq_isExistTable:@"logTable"]) {
        [[TXLFMDBManagement shareDatabase] jq_createTable:@"logTable" dicOrModel:[TMLogsModel class]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"2VDBVersion" forKey:TXLFMDBVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//升级数据库 - 加一个orangeTable表 + 加一个字段
+ (void)updateServerlocalDataBaseForV2{
    
    if (![[TXLFMDBManagement shareDatabase] jq_isExistTable:@"orangeTable"]) {
        [[TXLFMDBManagement shareDatabase] jq_createTable:@"orangeTable" dicOrModel:[orange class]];
    }
    
    BOOL ret = [[TXLFMDBManagement shareDatabase] jq_alterTable:@"orangeTable" dicOrModel:[orange class]];
    if (ret) {
        [[NSUserDefaults standardUserDefaults] setObject:@"3VDBVersion" forKey:TXLFMDBVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - 以model或字典创建表

- (BOOL)jq_createTable:(NSString *)tableName dicOrModel:(id)parameters
{
    return [self jq_createTable:tableName dicOrModel:parameters excludeName:nil];
}

- (BOOL)jq_createTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(NSArray *)nameArr
{
    
    NSDictionary *dic;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
    } else {
        Class CLS;
        if ([parameters isKindOfClass:[NSString class]]) {
            if (!NSClassFromString(parameters)) {
                CLS = nil;
            } else {
                CLS = NSClassFromString(parameters);
            }
        } else if ([parameters isKindOfClass:[NSObject class]]) {
            CLS = [parameters class];
        } else {
            CLS = parameters;
        }
        dic = [self modelToDictionary:CLS excludePropertyName:nameArr];
    }
    
    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (pkid  INTEGER PRIMARY KEY,", tableName];
    int keyCount = 0;
    for (NSString *key in dic) {
        
        keyCount++;
        if ((nameArr && [nameArr containsObject:key]) || [key isEqualToString:@"pkid"]) {
            continue;
        }
        if (keyCount == dic.count) {
            [fieldStr appendFormat:@" %@ %@)", key, dic[key]];
            break;
        }
        
        [fieldStr appendFormat:@" %@ %@,", key, dic[key]];
    }
    BOOL creatFlag;
    creatFlag = [_db executeUpdate:fieldStr];
    return creatFlag;
}

- (NSString *)createTable:(NSString *)tableName dictionary:(NSDictionary *)dic excludeName:(NSArray *)nameArr
{
    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (pkid  INTEGER PRIMARY KEY,", tableName];
    
    int keyCount = 0;
    for (NSString *key in dic) {
        
        keyCount++;
        if ((nameArr && [nameArr containsObject:key]) || [key isEqualToString:@"pkid"]) {
            continue;
        }
        if (keyCount == dic.count) {
            [fieldStr appendFormat:@" %@ %@)", key, dic[key]];
            break;
        }
        
        [fieldStr appendFormat:@" %@ %@,", key, dic[key]];
    }
    
    return fieldStr;
}

- (NSString *)createTable:(NSString *)tableName model:(Class)cls excludeName:(NSArray *)nameArr
{
    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (pkid INTEGER PRIMARY KEY,", tableName];
    
    NSDictionary *dic = [self modelToDictionary:cls excludePropertyName:nameArr];
    int keyCount = 0;
    for (NSString *key in dic) {
        
        keyCount++;
        
        if ([key isEqualToString:@"pkid"]) {
            continue;
        }
        if (keyCount == dic.count) {
            [fieldStr appendFormat:@" %@ %@)", key, dic[key]];
            break;
        }
        
        [fieldStr appendFormat:@" %@ %@,", key, dic[key]];
    }
    return fieldStr;
}

#pragma mark - *************** runtime

- (NSDictionary *)modelToDictionary:(Class)cls excludePropertyName:(NSArray *)nameArr
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if ([nameArr containsObject:name]) continue;
        
        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        
        id value = [self propertTypeConvert:type];
        if (value) {
            [mDic setObject:value forKey:name];
        }
        
    }
    free(properties);
    return mDic;
}

// 获取model的key和value

- (NSDictionary *)getModelPropertyKeyValue:(id)model tableName:(NSString *)tableName clomnArr:(NSArray *)clomnArr
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if (![clomnArr containsObject:name]) {
            continue;
        }
        
        id value = [model valueForKey:name];
        if (value) {
            [mDic setObject:value forKey:name];
        }
    }
    free(properties);
    
    return mDic;
}

#pragma mark - 根据项目字典转模型库的需求配置
//JSONModel库:@"T@\"NSString<Optional>\""  @"T@\"NSString\"<Ignore>"
//MJ库如下：

- (NSString *)propertTypeConvert:(NSString *)typeStr
{
    NSString *resultStr = nil;
    if ([typeStr hasPrefix:@"T@\"NSString\""] || [typeStr hasPrefix:@"T@\"NSString\""]) {
        resultStr = SQL_TEXT;
    } else if ([typeStr hasPrefix:@"T@\"NSData\""]) {
        resultStr = SQL_BLOB;
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"TB"]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        resultStr = SQL_INTEGER;
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]){
        resultStr= SQL_REAL;
    }
    
    return resultStr;
}

// 得到表里的字段名称
- (NSArray *)getColumnArr:(NSString *)tableName db:(FMDatabase *)db
{
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    
    FMResultSet *resultSet = [db getTableSchema:tableName];
    
    while ([resultSet next]) {
        [mArr addObject:[resultSet stringForColumn:@"name"]];
    }
    
    return mArr;
}

#pragma mark - *************** 增删改查
- (BOOL)jq_insertTable:(NSString *)tableName dicOrModel:(id)parameters
{
    NSArray *columnArr = [self getColumnArr:tableName db:_db];
    return [self insertTable:tableName dicOrModel:parameters columnArr:columnArr];
}

- (BOOL)insertTable:(NSString *)tableName dicOrModel:(id)parameters columnArr:(NSArray *)columnArr
{
    BOOL flag;
    NSDictionary *dic;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
    }else {
        dic = [self getModelPropertyKeyValue:parameters tableName:tableName clomnArr:columnArr];
    }
    
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (", tableName];
    NSMutableString *tempStr = [NSMutableString stringWithCapacity:0];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        
        if (![columnArr containsObject:key] || [key isEqualToString:@"pkid"]) {
            continue;
        }
        [finalStr appendFormat:@"%@,", key];
        [tempStr appendString:@"?,"];
        
        [argumentsArr addObject:dic[key]];
    }
    
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (tempStr.length)
    [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length-1, 1)];
    
    [finalStr appendFormat:@") values (%@)", tempStr];
    
    flag = [_db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    return flag;
}

- (BOOL)jq_deleteTable:(NSString *)tableName whereFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    BOOL flag;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"delete from %@  %@", tableName,where];
    flag = [_db executeUpdate:finalStr];
    
    return flag;
}

- (BOOL)jq_updateTable:(NSString *)tableName dicOrModel:(id)parameters whereFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    BOOL flag;
    NSDictionary *dic;
    NSArray *clomnArr = [self getColumnArr:tableName db:_db];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
    }else {
        dic = [self getModelPropertyKeyValue:parameters tableName:tableName clomnArr:clomnArr];
    }
    
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"update %@ set ", tableName];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        
        if (![clomnArr containsObject:key] || [key isEqualToString:@"pkid"]) {
            continue;
        }
        [finalStr appendFormat:@"%@ = %@,", key, @"?"];
        [argumentsArr addObject:dic[key]];
    }
    
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (where.length) [finalStr appendFormat:@" %@", where];
    
    
    flag =  [_db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    
    return flag;
}

- (NSArray *)jq_lookupTable:(NSString *)tableName dicOrModel:(id)parameters whereFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"select * from %@ %@", tableName, where?where:@""];
    NSArray *clomnArr = [self getColumnArr:tableName db:_db];
    
    FMResultSet *set = [_db executeQuery:finalStr];
    
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
        
        while ([set next]) {
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
            for (NSString *key in dic) {
                
                if ([dic[key] isEqualToString:SQL_TEXT]) {
                    id value = [set stringForColumn:key];
                    if (value)
                    [resultDic setObject:value forKey:key];
                } else if ([dic[key] isEqualToString:SQL_INTEGER]) {
                    [resultDic setObject:@([set longLongIntForColumn:key]) forKey:key];
                } else if ([dic[key] isEqualToString:SQL_REAL]) {
                    [resultDic setObject:[NSNumber numberWithDouble:[set doubleForColumn:key]] forKey:key];
                } else if ([dic[key] isEqualToString:SQL_BLOB]) {
                    id value = [set dataForColumn:key];
                    if (value)
                    [resultDic setObject:value forKey:key];
                }
                
            }
            
            if (resultDic) [resultMArr addObject:resultDic];
        }
        
    }else {
        
        Class CLS;
        if ([parameters isKindOfClass:[NSString class]]) {
            if (!NSClassFromString(parameters)) {
                CLS = nil;
            } else {
                CLS = NSClassFromString(parameters);
            }
        } else if ([parameters isKindOfClass:[NSObject class]]) {
            CLS = [parameters class];
        } else {
            CLS = parameters;
        }
        
        if (CLS) {
            NSDictionary *propertyType = [self modelToDictionary:CLS excludePropertyName:nil];
            
            while ([set next]) {
                
                id model = CLS.new;
                for (NSString *name in clomnArr) {
                    if ([propertyType[name] isEqualToString:SQL_TEXT]) {
                        id value = [set stringForColumn:name];
                        if (value)
                        [model setValue:value forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_INTEGER]) {
                        [model setValue:@([set longLongIntForColumn:name]) forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_REAL]) {
                        [model setValue:[NSNumber numberWithDouble:[set doubleForColumn:name]] forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_BLOB]) {
                        id value = [set dataForColumn:name];
                        if (value)
                        [model setValue:value forKey:name];
                    }
                }
                
                [resultMArr addObject:model];
            }
        }
        
    }
    
    return resultMArr;
}

// 直接传一个array插入
- (NSArray *)jq_insertTable:(NSString *)tableName dicOrModelArray:(NSArray *)dicOrModelArray
{
    
    int errorIndex = 0;
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    NSArray *columnArr = [self getColumnArr:tableName db:_db];
    for (id parameters in dicOrModelArray) {
        
        BOOL flag = [self insertTable:tableName dicOrModel:parameters columnArr:columnArr];
        if (!flag) {
            [resultMArr addObject:@(errorIndex)];
        }
        errorIndex++;
    }
    
    return resultMArr;
}

- (BOOL)jq_deleteTable:(NSString *)tableName
{
    
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        return NO;
    }
    return YES;
}

- (BOOL)jq_deleteAllDataFromTable:(NSString *)tableName
{
    
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)jq_isExistTable:(NSString *)tableName
{
    
    FMResultSet *set = [_db executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
    while ([set next])
    {
        NSInteger count = [set intForColumn:@"count"];
        if (count == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)jq_columnNameArray:(NSString *)tableName
{
    return [self getColumnArr:tableName db:_db];
}

- (int)jq_tableItemCount:(NSString *)tableName
{
    
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *set = [_db executeQuery:sqlstr];
    while ([set next])
    {
        return [set intForColumn:@"count"];
    }
    return 0;
}

- (void)close
{
    [_db close];
}

- (void)open
{
    [_db open];
}

- (NSInteger)lastInsertPrimaryKeyId:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT * FROM %@ where pkid = (SELECT max(pkid) FROM %@)", tableName, tableName];
    FMResultSet *set = [_db executeQuery:sqlstr];
    while ([set next])
    {
        return [set longLongIntForColumn:@"pkid"];
    }
    return 0;
}

- (BOOL)jq_alterTable:(NSString *)tableName dicOrModel:(id)parameters
{
    return [self jq_alterTable:tableName dicOrModel:parameters excludeName:nil];
}

- (BOOL)jq_alterTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(NSArray *)nameArr
{
    __block BOOL flag;
    [self jq_inTransaction:^(BOOL *rollback) {
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in parameters) {
                if ([nameArr containsObject:key]) {
                    continue;
                }
                flag = [_db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, parameters[key]]];
                if (!flag) {
                    *rollback = YES;
                    return;
                }
            }
            
        } else {
            Class CLS;
            if ([parameters isKindOfClass:[NSString class]]) {
                if (!NSClassFromString(parameters)) {
                    CLS = nil;
                } else {
                    CLS = NSClassFromString(parameters);
                }
            } else if ([parameters isKindOfClass:[NSObject class]]) {
                CLS = [parameters class];
            } else {
                CLS = parameters;
            }
            NSDictionary *modelDic = [self modelToDictionary:CLS excludePropertyName:nameArr];
            NSArray *columnArr = [self getColumnArr:tableName db:_db];
            for (NSString *key in modelDic) {
                if (![columnArr containsObject:key] && ![nameArr containsObject:key]) {
                    flag = [_db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, modelDic[key]]];
                    if (!flag) {
                        *rollback = YES;
                        return;
                    }
                }
            }
        }
    }];
    
    return flag;
}

// =============================   线程安全操作    ===============================

- (void)jq_inDatabase:(void(^)(void))block
{
    
    [[self dbQueue] inDatabase:^(FMDatabase *db) {
        block();
    }];
}

- (void)jq_inTransaction:(void(^)(BOOL *rollback))block
{
    
    [[self dbQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        block(rollback);
    }];
    
}

@end
