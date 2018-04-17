//
//  AnalyticsViewController.m
//  TMMobileDatabase
//
//  Created by cocomanber on 2018/4/16.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "AnalyticsViewController.h"
#import "SDCycleScrollView.h"
#import "SDCollectionViewCell.h"
#import "TXLFMDBManagement.h"
#import "TMAnalytics.h"

#import "AnalyticsTestViewController.h"

@interface AnalyticsViewController ()
<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView1;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView2;

@end

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1
    _cycleScrollView1.localizationImageNamesGroup = @[@{@"image":@"1",@"eventId":@"23"},
                                                      @{@"image":@"2",@"eventId":@"24"},
                                                      @{@"image":@"3",@"eventId":@"25"}];
    _cycleScrollView1.autoScrollTimeInterval = 3;
    _cycleScrollView1.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView1.titleLabelBackgroundColor = [UIColor clearColor];
    _cycleScrollView1.delegate = self;
    
    //2
    _cycleScrollView2.localizationImageNamesGroup = @[@{@"image":@"10",@"eventId":@"33"},
                                                      @{@"image":@"11",@"eventId":@"34"},
                                                      @{@"image":@"12",@"eventId":@"35"},
                                                      @{@"image":@"2",@"eventId":@"36"}];
    _cycleScrollView2.autoScrollTimeInterval = 5;
    _cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView2.titleLabelBackgroundColor = [UIColor clearColor];
    _cycleScrollView2.delegate = self;
    
    [SDCycleScrollView clearImagesCache];
}

- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view
{
    return [SDCollectionViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    SDCollectionViewCell *sdCell = (SDCollectionViewCell *)cell;
    UIImage *image;
    if (view == _cycleScrollView1) {
        NSDictionary *dict = _cycleScrollView1.localizationImageNamesGroup[index];
        image = [UIImage imageNamed:dict[@"image"]];
    }else{
        NSDictionary *dict = _cycleScrollView2.localizationImageNamesGroup[index];
        image = [UIImage imageNamed:dict[@"image"]];
    }
    sdCell.imageView.image = image;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == _cycleScrollView1) {
        NSDictionary *dict = _cycleScrollView1.localizationImageNamesGroup[index];
        [TMAnalytics track:TMTopBanarData properties:dict[@"eventId"]];
        
    }else{
        NSDictionary *dict = _cycleScrollView2.localizationImageNamesGroup[index];
        [TMAnalytics track:TMAdvBanarData properties:dict[@"eventId"]];
        
    }
    
    AnalyticsTestViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalyticsTestViewController"];
    viewController.title = @"Analytics";
    [self.navigationController  pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
