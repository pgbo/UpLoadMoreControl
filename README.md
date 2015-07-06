# UpLoadMoreControl

## 简介

使用Objective-c编写的上拉加载更多控件，适用于各种UIScrollView，UITableView，UICollectionView，其特点是简洁大方。当上拉ScrollView时，上拉加载控件才会显示，滚动停止后控件自动隐藏到底部。

## 效果图
上拉状态：  
![上拉可以加载更多...](/Snapshoot/snapshoot_0.jpg)

准备加载状态：    
![释放将会加载更多...](/Snapshoot/snapshoot_1.jpg)

加载更多中状态：    
![加载更多中...](/Snapshoot/snapshoot_2.jpg)

## 安装
### cocoapods
 将下面的语句加入到你的Podfile：
```ruby
pod "UpLoadMoreControl", :git => "https://github.com/pgbo/UpLoadMoreControl.git"
```

### 手动安装
 拷贝并添加或推拽UpLoadMoreControl目录到你的项目目录里即可。

## 使用
### 初始化并添加到UIScrollView中
```` objective-c
_loadMoreControl = [[UpLoadMoreControl alloc]initWithScrollView:self.tableView action:^(UpLoadMoreControl *control){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [control finishedLoadingWithStatus:@"Finished load" delay:1.f];
        });
    }];
[self.tableView addSubview:self.loadMoreControl];
````

### 结束加载
```` objective-c
[self.loadMoreControl finishedLoadingWithStatus:@"Finished load" delay:1.f];
````

### 在UIScrollView相关代理方法中调用UpLoadMoreControl的相关方法
```` objective-c
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.loadMoreControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.loadMoreControl scrollViewDidEndDragging];
}
````

### 自定义
```` objective-c
// 自定义颜色
self.loadMoreControl.color = [UIColor blueColor];

// 自定义触发加载更多的阀值
self.loadMoreControl.threshold = 100.f;
````

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

pgbo, 460667915@qq.com

## License

UpLoadMoreControl is available under the MIT license. See the LICENSE file for more info.
