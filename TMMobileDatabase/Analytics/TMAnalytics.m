//
//  TMAnalytics.m
//  TMProIphonex_safe
//
//  Created by cocomanber on 2018/4/16.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TMAnalytics.h"
#import "TMDatabaseTracker.h"

@implementation TMAnalytics

+ (NSMutableArray *)trackers
{
    static NSMutableArray *trackers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        trackers = [NSMutableArray array];
    });
    return trackers;
}

+ (void)registerTracker:(id<TMAnalyticsDelegate>)tracker
{
    [[self trackers] addObject:tracker];
}

+ (void)clearTracker
{
    [[self trackers] removeAllObjects];
}

/**
 执行统计方法，仅仅统计事件名
 
 @param eventName <#eventName description#>
 */
+ (void)track:(NSString *)eventName
{
    for (id<TMAnalyticsDelegate> tracker in [self trackers]) {
        [tracker track:eventName];
    }
}


/**
 执行统计方法，统计事件名和事件ID
 
 @param eventName <#eventName description#>
 @param eventId <#eventId description#>
 */
+ (void)track:(NSString *)eventName properties:(NSString *)eventId
{
    for (id<TMAnalyticsDelegate> tracker in [self trackers]) {
        [tracker track:eventName properties:eventId];
    }
}


/**
 执行统计方法，统计事件名、事件ID、触发时间
 
 @param eventName <#eventName description#>
 @param eventId <#eventId description#>
 @param trackTime <#trackTime description#>
 */
+ (void)track:(NSString *)eventName properties:(NSString *)eventId trackTime:(NSString *)trackTime
{
    for (id<TMAnalyticsDelegate> tracker in [self trackers]) {
        [tracker track:eventName properties:eventId trackTime:trackTime];
    }
}


/**
 上传tracker到服务器
 */
+ (void)upLoadTrackersInfoFromLocalDataBase
{
    for (id<TMAnalyticsDelegate> tracker in [self trackers]) {
        [tracker upLoadTrackersInfoFromLocalDataBase];
    }
}

@end
