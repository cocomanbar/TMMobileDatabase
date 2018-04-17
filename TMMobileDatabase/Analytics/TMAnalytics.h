//
//  TMAnalytics.h
//  TMProIphonex_safe
//
//  Created by cocomanber on 2018/4/16.
//  Copyright © 2018年 cocomanber. All rights reserved.
//  统计入口类

#import <Foundation/Foundation.h>
#import "TMAnalyticsConfig.h"

@class TMAnalytics;
@protocol TMAnalyticsDelegate <NSObject>

- (void)track:(NSString *)eventName;
- (void)track:(NSString *)eventName properties:(NSString *)eventId;
- (void)track:(NSString *)eventName properties:(NSString *)eventId trackTime:(NSString *)trackTime;

- (void)upLoadTrackersInfoFromLocalDataBase;

@end

@interface TMAnalytics : NSObject


/**
 内置统计功能类种

 @return <#return value description#>
 */
+ (NSMutableArray *)trackers;

/**
 注册内置统计功能类
 目前有两个：统计存数据库类、打印类
 可扩展，兼容性好
 
 @param tracker <#tracker description#>
 */
+ (void)registerTracker:(id<TMAnalyticsDelegate>)tracker;

/**
 清理全部内置统计功能类
 */
+ (void)clearTracker;

/**
 执行统计方法，仅仅统计事件名

 @param eventName <#eventName description#>
 */
+ (void)track:(NSString *)eventName;

/**
 执行统计方法，统计事件名和事件ID

 @param eventName <#eventName description#>
 @param eventId <#eventId description#>
 */
+ (void)track:(NSString *)eventName properties:(NSString *)eventId;

/**
 执行统计方法，统计事件名、事件ID、触发时间
 
 @param eventName <#eventName description#>
 @param eventId <#eventId description#>
 @param trackTime <#trackTime description#>
 */
+ (void)track:(NSString *)eventName properties:(NSString *)eventId trackTime:(NSString *)trackTime;

/**
 上传tracker到服务器
 */
+ (void)upLoadTrackersInfoFromLocalDataBase;

@end






