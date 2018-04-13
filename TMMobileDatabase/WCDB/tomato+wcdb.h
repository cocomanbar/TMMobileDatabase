//
//  tomato+wcdb.h
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/4/10.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "tomato.h"

@interface tomato (wcdb)

+ (BOOL)deleteAllitemIdBelowFromCatgory;

+ (BOOL)updateStatusAllMovingToStop;

+ (NSArray *)searchDatasWithSQL;

+ (BOOL)deleteAllDatasFromTable;

@end

/*
 复杂的SQLite语句可以写到专门开一个分类写。
 避免耦合本类，解决通用封装中间类封装困难、不实用的等特点
 */
