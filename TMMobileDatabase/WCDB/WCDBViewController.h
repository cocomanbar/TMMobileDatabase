//
//  WCDBViewController.h
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/3/30.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCDBViewController : UIViewController

@end

//https://github.com/Tencent/wcdb/wiki/iOS-macOS使用教程
//WCDB 的最基础的调用过程大致分为三个步骤：
//1、模型绑定
//2、创建数据库与表
//3、操作数据

//将一个已有的ObjC类进行ORM绑定的过程如下：
//定义该类遵循WCTTableCoding协议。可以在类声明上定义，也可以通过文件模版在category内定义。
//使用WCDB_PROPERTY宏在头文件声明需要绑定到数据库表的字段。
//使用WCDB_IMPLEMENTATIO宏在类文件定义绑定到数据库表的类
//使用WCDB_SYNTHESIZE宏在类文件定义需要绑定到数据库表的字段


//WCDB_PRIMARY用于定义主键
//WCDB_INDEX用于定义索引
//WCDB_UNIQUE用于定义唯一约束
//WCDB_NOT_NULL用于定义非空约束

