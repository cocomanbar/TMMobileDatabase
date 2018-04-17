//
//  TMDatabaseTracker.m
//  TMProIphonex_safe
//
//  Created by cocomanber on 2018/4/16.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TMDatabaseTracker.h"
#import "TMAnalyticsConfig.h"
#import "TMAnalytics.h"
#import "TMLogsModel.h"

#import "TXLFMDBManagement.h"

@interface TMDatabaseTracker ()

//记录需要判断时间上传的key
@property (nonatomic, strong)NSMutableArray *tempKeys;
//记录无需判断时间上传的key
@property (nonatomic, strong)NSMutableArray *tempNoKeys;

//当前的时间戳
@property (nonatomic, assign)NSTimeInterval currentTimeInterval;

@end

@implementation TMDatabaseTracker

#pragma mark - delegate

- (void)track:(NSString *)eventName
{
    [self track:eventName properties:nil];
}

- (void)track:(NSString *)eventName properties:(NSString *)eventId
{
    [self track:eventName properties:eventId trackTime:[self getCurrentTimeWithFormatter:[TMAnalyticsConfig shareManager].formatter]];
}

- (void)track:(NSString *)eventName properties:(NSString *)eventId trackTime:(NSString *)trackTime
{
    TMLogsModel *model = [[TMLogsModel alloc]init];
    model.eventName = eventName;
    model.eventId = eventId;
    model.eventCreateTime = trackTime;
    
    //inSertOrReplace on data base
    //...
    if (![TMAnalyticsConfig shareManager].replaceEvet) {
        [[TXLFMDBManagement shareDatabase] jq_insertTable:@"logTable" dicOrModel:model];
    }else{
        NSArray *array = [[TXLFMDBManagement shareDatabase] jq_lookupTable:@"logTable" dicOrModel:[TMLogsModel class] whereFormat:[NSString stringWithFormat:@"where eventId = '%@'",eventId]];
        if (!array.count) {
            [[TXLFMDBManagement shareDatabase] jq_insertTable:@"logTable" dicOrModel:model];
        }else{
            [[TXLFMDBManagement shareDatabase] jq_updateTable:@"logTable" dicOrModel:model whereFormat:[NSString stringWithFormat:@"where eventId = '%@'",eventId]];
        }
    }
}

- (void)upLoadTrackersInfoFromLocalDataBase
{
    NSDictionary *timeDict = [TMAnalyticsConfig shareManager].timeDict;
    if (!timeDict.count) {
        return;
    }
    [self.tempKeys removeAllObjects];
    [self.tempNoKeys removeAllObjects];
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    self.currentTimeInterval = currentTimeInterval;
    
    /* 需要拿数据上传的key */
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *keyString in timeDict.allKeys) {
        NSInteger date = [timeDict[keyString] integerValue];
        if (date == 0) {
            /*
             代表对时间无要求,打开即刻上传
             */
            [tempArray addObject:keyString];
            [self.tempNoKeys addObject:keyString];
        }else{
            /*
             代表对时间有要求,同时时间满足了上传要求,无需考虑第一次安装app的情况
             */
            NSTimeInterval lastCheckTimeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:keyString];
            if ((currentTimeInterval - lastCheckTimeInterval) > 60 * 60 * 24 * date) {
                [tempArray addObject:keyString];
                [self.tempKeys addObject:keyString];
            }
        }
    }
    
    NSMutableArray *logs = [NSMutableArray array];
    /* 循环从数据库拿出对应的key的数据模型 */
    for (NSString *key in tempArray) {
        
        NSArray *array;
        
        // array = sqlite 操作.. key对应eventName
        array = [[TXLFMDBManagement shareDatabase] jq_lookupTable:@"logTable" dicOrModel:[TMLogsModel class] whereFormat:[NSString stringWithFormat:@"where eventName = '%@'",key]];
        
        
        if (array.count) {
            [logs addObjectsFromArray:array];
        }
    }
    
    if (!logs.count) {
        return;
    }
    
    //此时logs可能包括各种eventName的TMLogsModel模型的数据根据接口转字典后要求上传服务器
    //模拟器上传操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //上传成功判断
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"----%@",logs);
            NSLog(@"--->%@",self.tempKeys);
            NSLog(@"--->%@",self.tempNoKeys);
            
            if (self.tempKeys.count) {
                for (NSString *key in self.tempKeys) {
                    
                    //更改时间缓存
                    [[NSUserDefaults standardUserDefaults] setDouble:self.currentTimeInterval forKey:key];
                    
                    //清空上传成功后需时间校验的key
                    [[TXLFMDBManagement shareDatabase] jq_deleteTable:@"logTable" whereFormat:[NSString stringWithFormat:@"where eventName = '%@'",key]];
                }
            }
            
            if (self.tempNoKeys.count) {
                for (NSString *key in self.tempNoKeys) {
                    
                    //清空上传成功后无需时间校验的key
                    [[TXLFMDBManagement shareDatabase] jq_deleteTable:@"logTable" whereFormat:[NSString stringWithFormat:@"where eventName = '%@'",key]];
                }
            }
            
        });
    });
    
}

#pragma mark - private

- (NSString *)getCurrentTimeWithFormatter:(NSString *)formatter;{
    NSDateFormatter *formatterCurrent = [[NSDateFormatter alloc] init];
    [formatterCurrent setDateFormat:formatter];
    NSString *dateTime = [formatterCurrent stringFromDate:[NSDate date]];
    return dateTime;
}

- (NSMutableArray *)tempKeys{
    if (!_tempKeys) {
        _tempKeys = [NSMutableArray array];
    }
    return _tempKeys;
}

- (NSMutableArray *)tempNoKeys{
    if (!_tempNoKeys) {
        _tempNoKeys = [NSMutableArray array];
    }
    return _tempNoKeys;
}

@end





















