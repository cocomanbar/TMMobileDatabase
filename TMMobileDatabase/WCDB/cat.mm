//
//  cat.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/5/2.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "cat.h"
#import <WCDB/WCDB.h>
#import "cat+WCTTableCoding.h"

@implementation cat

WCDB_IMPLEMENTATION(cat)

WCDB_SYNTHESIZE(cat, name)
WCDB_SYNTHESIZE(cat, address)
WCDB_SYNTHESIZE(cat, privateId)
WCDB_SYNTHESIZE(cat, isAutoIncrement)

//WCDB_PRIMARY(cat,privateId)
WCDB_PRIMARY_ASC_AUTO_INCREMENT(cat,privateId)

@end
