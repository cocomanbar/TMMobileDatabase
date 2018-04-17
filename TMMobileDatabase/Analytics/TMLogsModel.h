//
//  TMLogsModel.h
//  TMProIphonex_safe
//
//  Created by cocomanber on 2018/4/16.
//  Copyright © 2018年 cocomanber. All rights reserved.
//  分析数据模型 - 字段应该囊括所有种类的统计字段
//  大而全的类
//  如果后期增加统计字段,这个类最有可能会导致数据库升级,所以前期做的时候要小心考虑。

#import <Foundation/Foundation.h>

@interface TMLogsModel : NSObject

@property (nonatomic, copy)NSString *eventName;
@property (nonatomic, copy)NSString *eventId;

//如果用数据库的话,建议以时间为主键(WCDB/FMDB...具体请查看我的github)
@property (nonatomic, copy)NSString *eventCreateTime;

@end
