//
//  FMDBViewController.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/3/30.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "FMDBViewController.h"
#import "orange.h"

@interface FMDBViewController ()



@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"------>%@",TXLCachePath);
}

- (IBAction)createOrangeData:(UIButton *)sender
{
    NSArray *datas = @[@{@"name":@"Orange_1",
                                    @"addressss":@"guangzhou_1",
                                    @"proDate":@"2018-03-30 15:25",
                                    @"number":@"7"
                                    },
                                  @{@"name":@"Orange_2",
                                    @"addressss":@"guangzhou_2",
                                    @"proDate":@"2018-03-30 15:26",
                                    @"number":@"8"
                                    },
                                  @{@"name":@"Orange_3",
                                    @"addressss":@"guangzhou_3",
                                    @"proDate":@"2018-03-30 15:27",
                                    @"number":@"9"
                                    }
                       ];
    
    [[TXLFMDBManagement shareDatabase] jq_deleteAllDataFromTable:@"orangeTable"];
    [[TXLFMDBManagement shareDatabase] jq_deleteAllDataFromTable:@"messageTable"];
    for (NSDictionary *dict in datas) {
        orange *model = [orange mj_objectWithKeyValues:dict];
        
        [[TXLFMDBManagement shareDatabase] jq_insertTable:@"messageTable" dicOrModel:dict];
        [[TXLFMDBManagement shareDatabase] jq_insertTable:@"orangeTable" dicOrModel:model];
    }
}

- (IBAction)searchOrangeData:(UIButton *)sender
{
    NSArray *array = [[TXLFMDBManagement shareDatabase] jq_lookupTable:@"orangeTable" dicOrModel:[orange class] whereFormat:[NSString stringWithFormat:@"where addressss = '%@'",@"guangzhou_1"]];
    if(array.count){
        NSLog(@"---->>%@",array);
    }
    
    NSDictionary *dict = @{@"name":@"TEXT",
                           @"addressss":@"TEXT",
                           @"proDate":@"TEXT",
                           @"number":@"TEXT"};
    NSArray *array_1 = [[TXLFMDBManagement shareDatabase] jq_lookupTable:@"messageTable" dicOrModel:dict whereFormat:[NSString stringWithFormat:@"where addressss = '%@'",@"guangzhou_1"]];
    if(array_1.count){
        NSLog(@"---->>%@",array_1);
    }
}

- (IBAction)deleteOrangeData:(UIButton *)sender
{
    BOOL ret = [[TXLFMDBManagement shareDatabase] jq_deleteTable:@"orangeTable" whereFormat:[NSString stringWithFormat:@"where name = '%@'",@"guangzhou_1"]];
    if(ret){
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }

    BOOL ret_1 = [[TXLFMDBManagement shareDatabase] jq_deleteTable:@"messageTable" whereFormat:[NSString stringWithFormat:@"where name = '%@'",@"guangzhou_1"]];
    if(ret){
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}


























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end











































