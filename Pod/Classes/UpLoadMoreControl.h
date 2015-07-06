//
//  UpLoadMoreControl.h
//  GalaToy
//
//  Created by guangbo on 15/5/12.
//
//

#import <UIKit/UIKit.h>

#define UpLoadMoreControlLocalizedString(key) \
NSLocalizedStringFromTableInBundle((key), @"UpLoadMoreControl", [UpLoadMoreControl uploadMoreControlBundle], nil)

typedef enum {
    UpLoadMoreControlStateNormal = 0,       // 正常
    UpLoadMoreControlStateReady,            // 准备load
    UpLoadMoreControlStateLoading,          // loading中
    UpLoadMoreControlStateFinishing,        // 结束中
} UpLoadMoreControlState;

@interface UpLoadMoreControl : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UpLoadMoreControlState state;
/**
 *  不能小于0
 */
@property (nonatomic) CGFloat threshold;
@property (nonatomic) UIColor *color;

/**
 *  初始化加载更多控件
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                            action:(void(^)(UpLoadMoreControl *))actionHandler;
/**
 *  结束加载，并显示特定时间的提示信息
 */
- (void)finishedLoadingWithStatus:(NSString *)status
                            delay:(NSTimeInterval)delay;

/**
 *  在scrollView的代理方法scrollViewDidScroll中调用本方法
 */
- (void)scrollViewDidScroll;

/**
 *  在scrollView的代理方法scrollViewDidScroll中调用本方法
 */
- (void)scrollViewDidEndDragging;

+ (NSBundle *)uploadMoreControlBundle;

@end
