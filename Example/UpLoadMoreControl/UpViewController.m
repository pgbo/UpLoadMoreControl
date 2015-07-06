//
//  UpViewController.m
//  UpLoadMoreControl
//
//  Created by pgbo on 07/06/2015.
//  Copyright (c) 2015 pgbo. All rights reserved.
//

#import "UpViewController.h"
#import <UpLoadMoreControl/UpLoadMoreControl.h>

@interface UpViewController ()

@property (nonatomic) UpLoadMoreControl *loadMoreControl;

@end

@implementation UpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loadMoreControl = [[UpLoadMoreControl alloc]initWithScrollView:self.tableView action:^(UpLoadMoreControl *control){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [control finishedLoadingWithStatus:@"Finished load" delay:1.f];
        });
    }];
    
    // 添加为列表的子视图
    [self.tableView addSubview:self.loadMoreControl];
    
    // 自定义颜色
    self.loadMoreControl.color = [UIColor blueColor];
    
    // 自定义触发加载更多的阀值
    self.loadMoreControl.threshold = 100.f;
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.loadMoreControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.loadMoreControl scrollViewDidEndDragging];
}

@end
