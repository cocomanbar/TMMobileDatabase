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

//nsstring nsnunber
+ (BOOL)deleteAllitemIdBelowFromCatgory
{
    BOOL ret = [[TXLWCDBManagement shareDatabase].dbDatabase deleteObjectsFromTable:@"tomato" where:tomato.itemId.in({1, 2, 3})];
    return ret;
}

//更新当前状态
+ (BOOL)updateStatusAllMovingToStop
{
    BOOL ret = [[TXLWCDBManagement shareDatabase].dbDatabase updateRowsInTable:@"tomato" onProperty:tomato.tomatoTypeStatus withValue:@(tomatoTypeStop) where:tomato.tomatoTypeStatus < tomatoTypeStop];
    return ret;
}

@end
