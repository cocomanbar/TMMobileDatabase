//
//  tomato.h
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/4/9.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, tomatoType){
    tomatoTypeMoving = 0,
    tomatoTypeStop = 1,
    tomatoTypeMoved = 2,
};

@interface tomato : NSObject

@property (copy, nonatomic) NSString *itemId;
@property (copy, nonatomic) NSString *itemObject;
@property (copy, nonatomic) NSString *createdTime;
@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign)tomatoType tomatoTypeStatus;

@end
