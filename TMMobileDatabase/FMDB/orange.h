//
//  orange.h
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/3/30.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orange : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *addressss;
@property (nonatomic, copy)NSString *proDate;
@property (nonatomic, assign)int number;

/* 数据库升级新字段 - 第一次运行时请屏蔽 */
@property (nonatomic, copy)NSString *descipt;

@end
