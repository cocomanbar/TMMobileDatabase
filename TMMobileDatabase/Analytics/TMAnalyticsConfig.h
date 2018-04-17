//
//  TMAnalyticsConfig.h
//  TMProIphonex_safe
//
//  Created by cocomanber on 2018/4/16.
//  Copyright © 2018年 cocomanber. All rights reserved.
//  统计配置类

#import <Foundation/Foundation.h>

//导入需要记录的不同事件类型,统一放该头文件管理,更加方便于个性化订制上传时间类型
//比如首页轮播图(TMTopBanarData)5张,对应的每一张的EvetId需要模型从服务器拿。
//比如广告图(TMAdvBanarData)n张,对应的每一张的EvetId需要模型从服务器拿。
//...

extern NSString *const TMTopBanarData;
extern NSString *const TMAdvBanarData;

@interface TMAnalyticsConfig : NSObject

#warning 个性化配置不等同于不用配置,如果对时间无要求也必须要以key:@0方式写入字典,否则部分数据不会上传。
/*
 不同事件类型上传时间间隔要求 默认是打开App即刻上传
 个性化配置形式如下:
 @0 代表不参考时间,打开即刻上传
 @1 代表间隔时间为1天<这次打开app时间-下次打开app时间>
 @3 代表间隔时间为3天<这次打开app时间-下次打开app时间>
 
 _timeDict = @{
                TMTopBanarData:@0,
                TMAdvBanarData:@1,
                };
*/
@property (nonatomic, strong, readonly)NSDictionary *timeDict;

//数据库时间格式
@property (nonatomic, strong, readonly)NSString *formatter;

//是否对重复事件ID重置时间只统计最近一次事件 默认是NO
@property (nonatomic, assign, readonly)BOOL replaceEvet;

//驱动打印 默认是YES
@property (nonatomic, assign, readonly)BOOL isDebug;

/**
 单例
 
 @return <#return value description#>
 */
+ (instancetype)shareManager;

@end
