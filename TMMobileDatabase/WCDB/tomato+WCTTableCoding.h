//
//  tomato+WCTTableCoding.h
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/4/9.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "tomato.h"
#import <WCDB/WCDB.h>

@interface tomato (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(itemId)
WCDB_PROPERTY(itemObject)
WCDB_PROPERTY(createdTime)

WCDB_PROPERTY(number)
WCDB_PROPERTY(tomatoTypeStatus)

@end

/***** 头文件 *****/
//WCDB_PROPERTY宏在头文件声明需要绑定到数据库表的字段

/***** 类文件 *****/
//WCDB_SYNTHESIZE宏在类文件定义需要绑定到数据库表的字段。
//WCDB_IMPLEMENTATIO宏在类文件定义绑定到数据库表的类
//WCDB_PRIMARY用于定义主键
//WCDB_INDEX用于定义索引
//WCDB_UNIQUE用于定义唯一约束
//WCDB_NOT_NULL用于定义非空约束
