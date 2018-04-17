//
//  TMConsoleTracker.m
//  TMProIphonex_safe
//
//  Created by cocomanber on 2018/4/16.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TMConsoleTracker.h"
#import "TMAnalytics.h"
#import "TMAnalyticsConfig.h"

@interface TMConsoleTracker ()

@end

@implementation TMConsoleTracker

- (void)track:(NSString *)eventName
{
    [self track:eventName properties:nil];
}

- (void)track:(NSString *)eventName properties:(NSString *)eventId
{
    [self track:eventName properties:eventId trackTime:nil];
}

- (void)track:(NSString *)eventName properties:(NSString *)eventId trackTime:(NSString *)trackTime
{
    if (![TMAnalyticsConfig shareManager].isDebug) {
        return;
    }
    
    NSLog(@"\n<---- tracker ---->\nTrack事件名称: %@\n事件Id: %@\n触发时间: %@", eventName, eventId, trackTime);
}

- (void)upLoadTrackersInfoFromLocalDataBase {
    return;
}

@end
