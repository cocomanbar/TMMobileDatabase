//
//  TMAnalyticsConfig.m
//  TMProIphonex_safe
//
//  Created by cocomanber on 2018/4/16.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TMAnalyticsConfig.h"

NSString *const TMTopBanarData = @"TMTopBanarData";
NSString *const TMAdvBanarData = @"TMAdvBanarData";

@implementation TMAnalyticsConfig

#pragma mark - 单例代码块

static TMAnalyticsConfig * _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copy {
    return _instance;
}

- (id)mutableCopy {
    return _instance;
}

+(instancetype)shareManager {
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isDebug = YES;
        _replaceEvet = NO;
        _formatter = @"yyyy-MM-dd HH:mm:ss";
        _timeDict = @{
                      TMTopBanarData:@0,
                      TMAdvBanarData:@1,
                      };
    }
    return self;
}

@end
