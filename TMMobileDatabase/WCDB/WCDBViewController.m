//
//  WCDBViewController.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/3/30.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "WCDBViewController.h"
#import "WCDBViewController111.h"
#import "WCDBViewController222.h"

#import "banana.h"

@interface WCDBViewController ()

@property (weak, nonatomic) IBOutlet UITextField *create_userName;
@property (weak, nonatomic) IBOutlet UITextField *create_userID;
@property (weak, nonatomic) IBOutlet UITextField *create_userNum;

@property (weak, nonatomic) IBOutlet UITextField *search_userId;

@property (weak, nonatomic) IBOutlet UITextField *delete_userID;

@property (weak, nonatomic) IBOutlet UITextField *update_userID;
@property (weak, nonatomic) IBOutlet UITextField *update_userName;
@property (weak, nonatomic) IBOutlet UITextField *update_userNum;

@end

@implementation WCDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"-->TXLWCDBCachePath---<< %@",TXLWCDBCachePath);
}


- (IBAction)createDataModels:(UIButton *)sender
{
    if (self.create_userName.text == nil
        || self.create_userID.text == nil
        || self.create_userNum.text == nil
        ) {
        return;
    }
    banana *model = [banana new];
    model.userName = self.create_userName.text;
    model.userID = self.create_userID.text;
    model.telNum = self.create_userNum.text;
    model.pinyin = @"F";
    model.location = @"G";
    model.createdate = 3;
    [[TXLWCDBManagement shareDatabase] insertObjectWithTableName:@"tomato" withClassName:@"banana" withModel:model];
}


- (IBAction)searchButtonClick:(UIButton *)sender {
    NSArray *array = [[TXLWCDBManagement shareDatabase] lookupObjectTable:@"tomato" WithClassName:@"banana" withTableKeyName:@"pinyin" withPrimarykey:@"F"];
    NSLog(@"-->>%@",array);
}

- (IBAction)deleteButtonClick:(UIButton *)sender {
    
    BOOL ret = [[TXLWCDBManagement shareDatabase] deleteObjectFromTableName:@"tomato" withClassName:@"banana" withTableKeyName:@"userID" withPrimarykey:@"3"];
    NSLog(@"-->>%d",ret);
}

- (IBAction)updateButtonClick:(UIButton *)sender {
    NSArray *array = [[TXLWCDBManagement shareDatabase] lookupObjectTable:@"tomato" WithClassName:@"banana" withTableKeyName:@"userID" withPrimarykey:@"3"];
    if (array.count) {
        banana *model = array[0];
        model.pinyin = @"10086";
        BOOL ret = [[TXLWCDBManagement shareDatabase] updateObjectInTableName:@"tomato" withClassName:@"banana" withObject:model];
        NSLog(@"-->>%d",ret);
        
        NSArray *array1 = [[TXLWCDBManagement shareDatabase] lookupObjectTable:@"tomato" WithClassName:@"banana" withTableKeyName:@"pinyin" withPrimarykey:@"10086"];
        NSLog(@"-array1->>%@",array1);
    }
}

- (IBAction)removeAllDatasFromTable:(UIButton *)sender {
    
    BOOL ret = [[TXLWCDBManagement shareDatabase] deleteAllObjectsFromTableName:@"tomato" withClassName:@"banana"];
    if (ret)NSLog(@"--->清空表了");
}

- (IBAction)getFilesSize:(UIButton *)sender {
    
    int count = [[TXLWCDBManagement shareDatabase] getAllTableFilesSize];
    NSLog(@"--->%d",count);
}

- (IBAction)deleteCurrentDataBase:(UIButton *)sender {
    
    BOOL count = [[TXLWCDBManagement shareDatabase] removeAllTableFiles];
    NSLog(@"--->%d",count);
}


- (IBAction)moveDataBase:(UIButton *)sender {
    WCDBViewController111 *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WCDBViewController111"];
    vc.title = @"扩展";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)searchIntwoTable:(UIButton *)sender {
    WCDBViewController222 *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WCDBViewController222"];
    vc.title = @"扩展";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
