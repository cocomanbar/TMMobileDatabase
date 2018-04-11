//
//  banana+WCTTableCoding.h
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/4/9.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "banana.h"
#import <WCDB/WCDB.h>

@interface banana (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(userName)
WCDB_PROPERTY(userID)
WCDB_PROPERTY(telNum)
WCDB_PROPERTY(pinyin)

WCDB_PROPERTY(location)
WCDB_PROPERTY(createdate)

@end
