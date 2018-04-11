//
//  TXLWCDBManagement.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/3/30.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TXLWCDBManagement.h"
#import <WCDB/WCDB.h>

#import "banana.h"
#import "tomato.h"

@interface TXLWCDBManagement ()

@property (nonatomic, strong, readwrite) WCTDatabase *dbDatabase;

@end

@implementation TXLWCDBManagement

static TXLWCDBManagement *wcdb = nil;

#pragma mark - 类方法销毁单例

/**
 对于不同的用户，需要创建不同的数据库。但是退出登录切换账号时，因为用单例创建数据，导致切换账号不会切换数据。所以，需要销毁单例。销毁单例时，调用以下的代码：
 另一种方案是一表多用户存储，看个人喜欢
 */
+(void)managerDealloc{
    wcdb = nil;
}

#pragma mark - 文件操作

/**
 删除当前数据库

 @return <#return value description#>
 */
- (BOOL)removeAllTableFiles
{
    __block BOOL _ret;
    [self.dbDatabase close:^{
        _ret = [self.dbDatabase removeFilesWithError:nil];
    }];
    if (_ret) {
        //把判定标识清空
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:TXLWCDBVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return _ret;
}

/**
 获取当前数据库存储大小
 
 @return <#return value description#>
 */
- (size_t)getAllTableFilesSize
{
    __block WCTError *error = nil;
    __block size_t _fileSize;
    [self.dbDatabase close:^{
        //you can call [getFilesSizeWithError:] for an unclosed database, but you will an inaccurate result and a warning
        _fileSize = [self.dbDatabase getFilesSizeWithError:&error];
    }];
    if (!error) {
        return _fileSize;
    }
    NSLog(@"Get file size Error %@", error);
    return 0;
}

/**
 移动数据库路径
 
 @param path <#path description#>
 @return <#return value description#>
 */
- (NSArray *)moveFilesToDirectory:(NSString *)path
{
    __block BOOL _ret;
    __block  WCTError *error = nil;
    [self.dbDatabase close:^{
        _ret = [self.dbDatabase moveFilesToDirectory:path withError:&error];
    }];
    if (!_ret) {
        return nil;
    }
    return [self.dbDatabase getPaths];
}

#pragma mark - 类方法初始化数据库

/**
 单例方法创建数据库
 dbName 数据库的名称 如: @"Users.sqlite", 如果dbName = nil,则默认dbName=@"database.sqlite"
 dbPath 数据库的路径, 如果dbPath = nil, 则路径默认为NSDocumentDirectory
 */
+ (instancetype)shareDatabase
{
    return [TXLWCDBManagement shareDatabaseWithCipherKey:NO];
}

+ (instancetype)shareDatabaseWithCipherKey:(BOOL)cipherKey
{
    if (!wcdb) {
        NSString *dbName = [NSString stringWithFormat:@"/%@.sqlite",@"testWCDBDataBase"];
        NSString *dbPath = [TXLWCDBCachePath stringByAppendingPathComponent:dbName];
        WCTDatabase *dbbase = [[WCTDatabase alloc] initWithPath:dbPath];
        if (cipherKey) {
            NSData *password = [@"passwordKey" dataUsingEncoding:NSASCIIStringEncoding];
            [dbbase setCipherKey:password];
        }
        if ([dbbase canOpen]) {
            wcdb = [[TXLWCDBManagement alloc]init];
            wcdb.dbDatabase = dbbase;
            [self updateWCDB];
        }
    }
    return wcdb;
}

+ (void)updateWCDB
{
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:TXLWCDBVersion];
    if (!version || version.length <= 0) {
        [self createTablesForFirstInstallApp];
    }else{
        NSInteger ver = [[[NSUserDefaults standardUserDefaults] objectForKey:TXLWCDBVersion] integerValue];
        switch (ver) {
            case 1:
            {
                // 做V1升级到V2版本的事..
                
                
            }
            case 2:
            {
                // 做V2升级到V3版本的事..
                
                
            }
                break;
            default:
                break;
        }
    }
}

+ (void)createTablesForFirstInstallApp
{
    //表1
    if (![[TXLWCDBManagement shareDatabase] isTableExists:@"tomato"]) {
        [[TXLWCDBManagement shareDatabase] createTableName:@"tomato" withClass:[tomato class]];
    }
    //表2
    if (![[TXLWCDBManagement shareDatabase] isTableExists:@"banana"]) {
        [[TXLWCDBManagement shareDatabase] createTableName:@"banana" withClass:[banana class]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1VWCDBVersion" forKey:TXLWCDBVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 检查表是否存在

- (BOOL)isTableExists:(NSString *)tableName
{
    return [self.dbDatabase isTableExists:tableName];
}

#pragma mark - 创建表 - 根据ORM的定义创建表或索引

- (BOOL)createTableName:(NSString *)tableName withClass:(Class)cls
{
    if (![cls conformsToProtocol:@protocol(WCTTableCoding)]) {
        return NO;
    }
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        return NO;
    }
    return [self.dbDatabase createTableAndIndexesOfName:tableName withClass:cls];
}

#pragma mark - 插入数据

/**
 插入单个数据
 
 @param tableName <#tableName description#>
 @param className <#className description#>
 @param model <#model description#>
 @return <#return value description#>
 */
- (BOOL)insertObjectWithTableName:(NSString *)tableName withClassName:(NSString *)className withModel:(id)model
{
    if (!model) {
        return NO;
    }
    WCTTable *table = [self.dbDatabase getTableOfName:tableName withClass:[NSClassFromString(className) class]];
    if ([table insertObject:model]) {
        return YES;
    }
    return NO;
}

/**
 插入多个数据
 
 @param tableName <#tableName description#>
 @param className <#className description#>
 @param models <#models description#>
 @return <#return value description#>
 */
- (BOOL)insertObjectsWithTableName:(NSString *)tableName withClassName:(NSString *)className withModels:(NSArray *)models
{
    if (models.count <= 0) {
        return NO;
    }
    WCTTable *table = [self.dbDatabase getTableOfName:tableName withClass:[NSClassFromString(className) class]];
    BOOL ret;
    if (models.count == 1) {
        ret = [[TXLWCDBManagement shareDatabase] insertObjectWithTableName:tableName withClassName:className withModel:models.firstObject];
        return ret;
    }
    ret = [table insertObjects:models];
    return ret;
}

/**
 插入单条数据，当主键存在时则更新数据该条数据
 
 @param tableName <#tableName description#>
 @param className <#className description#>
 @param model <#model description#>
 @return <#return value description#>
 */
- (BOOL)insertOrReplaceObjectWithTableName:(NSString *)tableName withClassName:(NSString *)className withModel:(id)model
{
    if (!model) {
        return NO;
    }
    WCTTable *table = [self.dbDatabase getTableOfName:tableName withClass:[NSClassFromString(className) class]];
    BOOL ret = [table insertOrReplaceObject:model];
    return ret;
}

/**
 插入多条数据，当主键存在时则更新数据该部分数据
 
 @param tableName <#tableName description#>
 @param className <#className description#>
 @param models <#models description#>
 @return <#return value description#>
 */
- (BOOL)insertOrReplaceObjectsWithTableName:(NSString *)tableName withClassName:(NSString *)className withModels:(NSArray *)models
{
    if (models.count <= 0) {
        return NO;
    }
    
    WCTTable *table = [self.dbDatabase getTableOfName:tableName withClass:[NSClassFromString(className) class]];
    BOOL ret;
    if (models.count == 1) {
        ret = [table insertOrReplaceObject:models.firstObject];
        return ret;
    }
    ret = [table insertOrReplaceObjects:models];
    return ret;
}

#pragma mark - 删除数据


/**
 清空表数据
 
 @param tableName <#tableName description#>
 @param className <#className description#>
 @return <#return value description#>
 */
- (BOOL)deleteAllObjectsFromTableName:(NSString *)tableName withClassName:(NSString *)className
{
    if (!tableName || !className) {
        return NO;
    }
    WCTTable *table = [self.dbDatabase getTableOfName:tableName withClass:[NSClassFromString(className) class]];
    BOOL ret = [table deleteAllObjects];
    return ret;
}

/**
 删除模型同字段单一条件数据 - where
 
 @param tableName 表名
 @param className 类名
 @param keyName 绑定的数据库参数
 @param key key 实参，id类型只接受NSString和NSNumber类型，其他会报错
 @return <#return value description#>
 */
- (BOOL)deleteObjectFromTableName:(NSString *)tableName withClassName:(NSString *)className withTableKeyName:(NSString *)keyName withPrimarykey:(id)key
{
    if (!tableName || !className || !key) {
        return NO;
    }
    NSAssert([key isKindOfClass:[NSString class]] || [key isKindOfClass:[NSNumber class]] , @"Data error");
    WCDB::Expr contindation(WCDB::Column(keyName.UTF8String));
    if ([key isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)key;
        contindation = contindation == string.UTF8String;
    }else if ([key isKindOfClass:[NSNumber class]]){
        contindation = contindation == [key longLongValue];
    }
    WCTTable *table = [self.dbDatabase getTableOfName:tableName withClass:[NSClassFromString(className) class]];
    BOOL ret = [table deleteObjectsWhere:contindation];
    return ret;
}

#pragma mark - 查询数据

/**
 单表查询：单一条件查询一般返回单个或多个模型
 
 @param tableName <#tableName description#>
 @param className <#className description#>
 @param keyName <#keyName description#>
 @param key <#key description#>
 @return <#return value description#>
 */
- (NSArray *)lookupObjectTable:(NSString *)tableName WithClassName:(NSString *)className withTableKeyName:(NSString *)keyName withPrimarykey:(id)key
{
    if (!tableName || !className || !key) {
        return nil;
    }
    NSAssert([key isKindOfClass:[NSString class]] || [key isKindOfClass:[NSNumber class]] , @"Data error");
    WCDB::Expr contindation(WCDB::Column(keyName.UTF8String));
    if ([key isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)key;
        contindation = contindation == string.UTF8String;
    }else if ([key isKindOfClass:[NSNumber class]]){
        contindation = contindation == [key longLongValue];
    }
    WCTTable *table = [self.dbDatabase getTableOfName:tableName withClass:[NSClassFromString(className) class]];
    NSArray *array = [table getObjectsWhere:contindation];
    return array;
}

#pragma mark - 更新数据

/**
 更新表里的一行数据(主键外)
 
 @param tableName <#tableName description#>
 @param className <#className description#>
 @param object <#object description#>
 @return <#return value description#>
 */
- (BOOL)updateObjectInTableName:(NSString *)tableName withClassName:(NSString *)className withObject:(id)object
{
    if (!object) {
        return NO;
    }
    WCTTable *table = [self.dbDatabase getTableOfName:tableName withClass:[NSClassFromString(className) class]];
    BOOL ret = [table insertOrReplaceObject:object];
    return ret;
}

@end











































































