//
//  cat+WCTTableCoding.h
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/5/2.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "cat.h"
#import <WCDB/WCDB.h>

@interface cat (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(name)
WCDB_PROPERTY(address)
WCDB_PROPERTY(privateId)
WCDB_PROPERTY(isAutoIncrement)

@end
