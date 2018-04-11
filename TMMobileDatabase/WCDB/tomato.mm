//
//  tomato.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/4/9.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "tomato.h"
#import "tomato+WCTTableCoding.h"

@implementation tomato

WCDB_IMPLEMENTATION(tomato)

WCDB_SYNTHESIZE(tomato, itemId)
WCDB_SYNTHESIZE(tomato, itemObject)
WCDB_SYNTHESIZE(tomato, createdTime)
WCDB_SYNTHESIZE(tomato, number)
WCDB_SYNTHESIZE(tomato, tomatoTypeStatus)

WCDB_PRIMARY(tomato, itemId)
WCDB_NOT_NULL(tomato, itemId)

/***** 头文件 *****/
//WCDB_PROPERTY宏在头文件声明需要绑定到数据库表的字段

/***** 类文件 *****/
//WCDB_SYNTHESIZE宏在类文件定义需要绑定到数据库表的字段。
//WCDB_IMPLEMENTATIO宏在类文件定义绑定到数据库表的类
//WCDB_PRIMARY用于定义主键
//WCDB_INDEX用于定义索引
//WCDB_UNIQUE用于定义唯一约束
//WCDB_NOT_NULL用于定义非空约束

- (NSString *)description
{
    return [NSString stringWithFormat:@"id=%@, value=%@, createTime=%@", _itemId, _itemObject, _createdTime];
}

@end
