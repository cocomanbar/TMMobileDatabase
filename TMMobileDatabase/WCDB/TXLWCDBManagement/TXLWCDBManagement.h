//
//  TXLWCDBManagement.h
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/3/30.
//  Copyright © 2018年 cocomanber. All rights reserved.
//
/*
 C 核心代码参考 WCTInterface 的 createTableAndIndexesOfName:withClass:andError: 方法,通过 WCTColumnBinding 和 WCTConstraintBinding 列表生成建表命令，再通过 WCTIndexBinding 列表添加对应索引。如果已存在表，建表过程则变成更新 column 操作，并忽略约束信息(SQLite 只实现 Alert Table 的有效子集)。
 R 核心代码参考 WCTSelect 的 extractPropertyToObject:atIndex:withColumnBinding: 方法，通过 WINQ 的链式调用获得最终查询结果，并调用上述方法将数据设置给对象属性。
 U 核心代码参考 WCTInsert 和 WCTUpdate 的初始化方法，通过 WCTTableCoding 获取 AllProperties 信息并配合当前实例属性进行链式调用，最后输出 SQL 语句执行。
 D 核心代码参考 WCTDelete 的 excute 方法，首先通过 WCTDelete 的链式调用生成最终的 WCTDelete 对象，最后输出 SQL 语句并执行。
 
 TXLWCDBManagement仅仅是做了最基本的CRUD，复杂sqlite操作语句建议用类扩展。
 
 注意为了项目隔离C++ 代码，封装此中间类，但是由于wcdb运用WCDB::Expr通过C++类转换条件， 多条件的拼接具体可以看这个类
 多条件封装起来有一定困难。如下面一种写法：

 WCDB::Expr contindation(WCDB::Column(@"userId").UTF8String);
 contindation = contindation > 3 && contindation < 9;
 
 对于操作相对复杂的条件语句进行update/search/delete/..时，
 可以针对该表类封装，直接将方法写在扩展类里，封装具体的操作数据库相关方法，具体请查看tomato+wcdb.h
 */

#import <Foundation/Foundation.h>

//数据库缓存的路径
#define TXLWCDBCachePath [NSString stringWithFormat:@"%@/database",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject]

@class WCTDatabase;
@interface TXLWCDBManagement : NSObject

@property (nonatomic, strong, readonly) WCTDatabase *dbDatabase;

#pragma mark - 类方法初始化数据库

/**
 单例方法创建数据库
 dbName 数据库的名称 如: @"Users.sqlite", 如果dbName = nil,则默认dbName=@"database.sqlite"
 dbPath 数据库的路径, 如果dbPath = nil, 则路径默认为NSDocumentDirectory
 */
+ (instancetype)shareDatabase;


/**
 数据库加密初始化
 使用加密功能请慎重!!!!!
 @param cipherKey <#cipherKey description#>
 @return <#return value description#>
 */
+ (instancetype)shareDatabaseWithCipherKey:(BOOL)cipherKey;

#pragma mark - 类方法销毁单例

/**
 对于不同的用户，需要创建不同的数据库。但是退出登录切换账号时，因为用单例创建数据，导致切换账号不会切换数据。所以，需要销毁单例。销毁单例时，调用以下的代码：
 另一种方案是一表多用户存储，看个人喜欢
 */
+(void)managerDealloc;

#pragma mark - 文件操作

/**
 删除当前数据库
 动库跑不了路了，兄弟，稳住，别手滑..
 
 @return <#return value description#>
 */
- (BOOL)removeAllTableFiles;


/**
 获取当前数据库存储大小

 @return 用int接收就ok
 */
- (size_t)getAllTableFilesSize;


/**
 移动数据库路径

 @param path <#path description#>
 @return <#return value description#>
 */
- (NSArray *)moveFilesToDirectory:(NSString *)path;

#pragma mark - 检查表是否存在

- (BOOL)isTableExists:(NSString *)tableName;

#pragma mark - 创建表 - 根据ORM的定义创建表或索引

- (BOOL)createTableName:(NSString *)tableName withClass:(Class)cls;

#pragma mark - 插入数据

/**
 插入单条数据
 数据库不存在该条主键数据
 
 @param tableName <#tableName description#>
 @param className <#className description#>
 @param model <#model description#>
 @return <#return value description#>
 */
- (BOOL)insertObjectWithTableName:(NSString *)tableName withClassName:(NSString *)className withModel:(id)model;

/**
 插入多条数据
 数据库不存在该部分主键数据
 
 @param tableName <#tableName description#>
 @param className <#className description#>
 @param models <#models description#>
 @return <#return value description#>
 */
- (BOOL)insertObjectsWithTableName:(NSString *)tableName withClassName:(NSString *)className withModels:(NSArray *)models;


/**
 插入单条数据，当主键存在时则更新数据该条数据

 @param tableName <#tableName description#>
 @param className <#className description#>
 @param model <#model description#>
 @return <#return value description#>
 */
- (BOOL)insertOrReplaceObjectWithTableName:(NSString *)tableName withClassName:(NSString *)className withModel:(id)model;


/**
 插入多条数据，当主键存在时则更新数据该部分数据

 @param tableName <#tableName description#>
 @param className <#className description#>
 @param models <#models description#>
 @return <#return value description#>
 */
- (BOOL)insertOrReplaceObjectsWithTableName:(NSString *)tableName withClassName:(NSString *)className withModels:(NSArray *)models;

#pragma mark - 删除数据

/**
 清空表里数据

 @param tableName <#tableName description#>
 @param className <#className description#>
 @return <#return value description#>
 */
- (BOOL)deleteAllObjectsFromTableName:(NSString *)tableName withClassName:(NSString *)className;


/**
 删除模型同字段单一条件数据 - where
 
 @param tableName 表名
 @param className 类名
 @param keyName 绑定的数据库参数
 @param key key 实参，id类型只接受NSString和NSNumber类型，其他会报错
 @return <#return value description#>
 */
- (BOOL)deleteObjectFromTableName:(NSString *)tableName withClassName:(NSString *)className withTableKeyName:(NSString *)keyName withPrimarykey:(id)key;

#pragma mark - 查询数据

/**
 单表查询：单一条件查询一般返回单个或多个模型
 主键 0 || 1，不是主键 >= 0
 
 @param tableName <#tableName description#>
 @param className <#className description#>
 @param keyName <#keyName description#>
 @param key <#key description#>
 @return <#return value description#>
 */
- (NSArray *)lookupObjectTable:(NSString *)tableName WithClassName:(NSString *)className withTableKeyName:(NSString *)keyName withPrimarykey:(id)key;

#pragma mark - 更新数据

/**
 更新表里的一行数据(主键外)

 @param tableName <#tableName description#>
 @param className <#className description#>
 @param object <#object description#>
 @return <#return value description#>
 */
- (BOOL)updateObjectInTableName:(NSString *)tableName withClassName:(NSString *)className withObject:(id)object;

@end








































