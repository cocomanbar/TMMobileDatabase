//
//  tomato+wcdb.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/4/10.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "tomato+wcdb.h"
#import "tomato+WCTTableCoding.h"
#import "TXLWCDBManagement.h"

@implementation tomato (wcdb)

+ (BOOL)deleteAllitemIdBelowFromCatgory
{
    BOOL ret = [[TXLWCDBManagement shareDatabase].dbDatabase deleteObjectsFromTable:@"tomato" where:tomato.itemId.in({1, 2, 3})];
    return ret;
}

+ (BOOL)deleteAllDatasFromTable
{
    BOOL ret = [[TXLWCDBManagement shareDatabase].dbDatabase deleteAllObjectsFromTable:@"tomato"];
    return ret;
}

//更新当前状态
+ (BOOL)updateStatusAllMovingToStop
{
    BOOL ret = [[TXLWCDBManagement shareDatabase].dbDatabase updateRowsInTable:@"tomato" onProperty:tomato.tomatoTypeStatus withValue:@(tomatoTypeStop) where:tomato.tomatoTypeStatus < tomatoTypeStop];
    return ret;
}

//筛选已经完成的部分
+ (NSArray *)searchDatasWithSQL
{
    NSArray *array;
    
    //取出来未排序直接返回
    if (0) {
        array = [[TXLWCDBManagement shareDatabase].dbDatabase getObjectsOfClass:tomato.class fromTable:@"tomato" where:tomato.tomatoTypeStatus > 1];
    }
    
    //orderBy   并非内部排序，是指从表前面顺着拿 还是表后面倒着拿
    //limit     拿多少条数据
    //offset    偏移多少位开始拿
    
    //这种是按照itemId列在表里顺序拿出来前3列数据
    if (0) {
        array = [[TXLWCDBManagement shareDatabase].dbDatabase getObjectsOfClass:tomato.class fromTable:@"tomato" orderBy:tomato.itemId.order(WCTOrderedAscending) limit:3];
    }
    
    //这种是按照itemId列在表里倒序第5位开始倒序拿出来
    if (0) {
        array = [[TXLWCDBManagement shareDatabase].dbDatabase getObjectsOfClass:tomato.class
                                                                      fromTable:@"tomato"
                                                                        orderBy:tomato.itemId.order(WCTOrderedDescending)
                                                                          limit:3
                                                                         offset:4];
    }
    
    //拿表里 createdTime 字段>@"2018-04-13" 按照orderBy拿三条数据 - 未做排序
    if (1) {
        array = [[TXLWCDBManagement shareDatabase].dbDatabase getObjectsOfClass:tomato.class
                                                                      fromTable:@"tomato"
                                                                          where:tomato.createdTime > @"2018-04-13"
                                                                        orderBy:tomato.itemId.order(WCTOrderedDescending)
                                                                          limit:3];
    }
    
    
    
    return array;
}

@end












