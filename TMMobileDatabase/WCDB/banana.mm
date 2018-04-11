//
//  banana.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/4/2.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "banana.h"
#import "banana+WCTTableCoding.h"

@implementation banana

#pragma mark - 定义绑定到数据库表的类
WCDB_IMPLEMENTATION(banana)

#pragma mark - 定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(banana, userName)
WCDB_SYNTHESIZE(banana, userID)
WCDB_SYNTHESIZE(banana, telNum)
WCDB_SYNTHESIZE(banana, pinyin)

WCDB_SYNTHESIZE(banana, location)
WCDB_SYNTHESIZE(banana, createdate)

#pragma mark - 设置主键
WCDB_PRIMARY(banana, userID)

#pragma mark - 设置索引
WCDB_INDEX(banana, "_index", userID)

- (NSString *)description
{
    return [NSString stringWithFormat:@"_userID=%@", _userID];
}

@end
