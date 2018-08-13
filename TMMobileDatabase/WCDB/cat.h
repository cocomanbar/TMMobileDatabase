//
//  cat.h
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/5/2.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cat : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *address;

//自定义自增主键
@property (nonatomic, assign)NSInteger privateId;
@property(nonatomic, assign) BOOL isAutoIncrement;

@end
