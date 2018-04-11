//
//  banana.h
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/4/2.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface banana : NSObject

@property (nonatomic, copy)   NSString  *userName;
@property (nonatomic, copy)   NSString  *userID;
@property (nonatomic, copy)   NSString  *telNum;
@property (nonatomic, copy)   NSString  *pinyin;

@property (nonatomic, copy)   NSString  *location;
@property (nonatomic, assign) NSInteger createdate;

@end
