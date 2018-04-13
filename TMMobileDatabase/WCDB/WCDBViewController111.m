//
//  WCDBViewController111.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/4/9.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "WCDBViewController111.h"
#import "tomato.h"
#import "MJExtension.h"
#import "tomato+wcdb.h"

@interface WCDBViewController111 ()

@property (weak, nonatomic) IBOutlet UITextField *numberTextF;
@property (weak, nonatomic) IBOutlet UITextField *statusTextF;
@property (weak, nonatomic) IBOutlet UITextField *dateTextF;

@end

@implementation WCDBViewController111

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.numberTextF.keyboardType = UIKeyboardTypeNumberPad;
}

- (IBAction)createObjects:(UIButton *)sender {
    
    if (self.numberTextF.text == nil ||
        self.statusTextF.text == nil ||
        self.dateTextF.text == nil) {
        return;
    }
    
    NSDictionary *dict = @{@"itemId":self.numberTextF.text,
                           @"itemObject":@"项目",
                           @"createdTime":self.dateTextF.text,
                           @"number":[NSNumber numberWithInteger:[self.numberTextF.text intValue]],
                           @"tomatoTypeStatus":[NSNumber numberWithInteger:[self.statusTextF.text intValue]],
                           };
    tomato *model = [tomato new];
    [model mj_setKeyValues:dict];
    [[TXLWCDBManagement shareDatabase] insertObjectWithTableName:@"tomato" withClassName:@"tomato" withModel:model];
}

//更新状态
- (IBAction)deleteObjects:(UIButton *)sender {
    
    BOOL ret = [tomato updateStatusAllMovingToStop];
    NSLog(@"--->>%d",ret);
}

//搜索
- (IBAction)searchData:(UIButton *)sender {
    
    NSArray *array = [tomato searchDatasWithSQL];
    NSLog(@"--->>%@",array);
}

//删除
- (IBAction)deleteButton:(UIButton *)sender {
    
    
}

//清空
- (IBAction)cleanButton:(UIButton *)sender {
    
    BOOL ret = [tomato deleteAllDatasFromTable];
    NSLog(@"--->>%d",ret);
}

//更新
- (IBAction)updateButton:(UIButton *)sender {
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end











































