//
//  ViewController.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/3/30.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "ViewController.h"
#import "FMDBViewController.h"
#import "WCDBViewController.h"
#import "AnalyticsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)fmdb:(UIButton *)sender
{
    FMDBViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FMDBViewController"];
    viewController.title = @"FMDB";
    [self.navigationController  pushViewController:viewController animated:YES];
}

- (IBAction)wcdb:(UIButton *)sender
{
    WCDBViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WCDBViewController"];
    viewController.title = @"WCDB";
    [self.navigationController  pushViewController:viewController animated:YES];
}

- (IBAction)AnalticsButtonClick:(UIButton *)sender {
    
    AnalyticsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalyticsViewController"];
    viewController.title = @"Analytics";
    [self.navigationController  pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
