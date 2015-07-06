//
//  UpLoadMoreControl.m
//  GalaToy
//
//  Created by guangbo on 15/5/12.
//
//

#import "UpLoadMoreControl.h"

/**
 *  这个值应该足够大，否则控件显示不充分
 */
static const CGFloat UpLoadMoreControlHeight = 60.f;

@interface UpLoadMoreControl ()

@property (nonatomic, readonly) UILabel *stateLabel;
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, copy) void(^loadMoreActionHandler)(UpLoadMoreControl *);

@property (nonatomic) CGFloat originalBottomContentInset;

@end

@implementation UpLoadMoreControl

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                            action:(void(^)(UpLoadMoreControl *))actionHandler
{
    if (self = [super initWithFrame:CGRectMake(0,
                                               [self bottomOfScrollView:scrollView],
                                               CGRectGetWidth(scrollView.bounds),
                                               UpLoadMoreControlHeight)]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _scrollView = scrollView;
        _loadMoreActionHandler = actionHandler;
        
        [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
        [self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:NULL];
        
        // setup sub views
        [self setupSubViews];
        
        // set default threshold
        [self setThreshold:UpLoadMoreControlHeight];
        
        // set default color
        [self setColor:[UIColor grayColor]];
        
        [self updateState:UpLoadMoreControlStateNormal];
    }
    return self;
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
}

- (void)setupSubViews
{
    _stateLabel = [[UILabel alloc]init];
    self.stateLabel.backgroundColor = [UIColor clearColor];
    self.stateLabel.font = [UIFont boldSystemFontOfSize:14.f];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.stateLabel];
    
    NSDictionary *views = @{@"stateLabel":self.stateLabel};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[stateLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[stateLabel]|" options:0 metrics:nil views:views]];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.activityIndicatorView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}


- (void)finishedLoadingWithStatus:(NSString *)status
                            delay:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.stateLabel.text = status;
        [self updateState:UpLoadMoreControlStateFinishing];
        
        NSTimeInterval nDelay = delay;
        if (nDelay < 0) {
            nDelay = 0;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(nDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 恢复到原来的位置
            
            UIEdgeInsets newInsets = self.scrollView.contentInset;
            newInsets.bottom = self.originalBottomContentInset;
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [UIView animateWithDuration:.3f animations:^{
                self.scrollView.contentInset = newInsets;
    
            } completion:^(BOOL finished){
                [[UIApplication sharedApplication]endIgnoringInteractionEvents];
                [self updateState:UpLoadMoreControlStateNormal];
            }];
        });
    });
}


- (void)setColor:(UIColor *)color
{
    _color = color;
    self.activityIndicatorView.color = color;
    self.stateLabel.textColor = color;
}


- (CGFloat)bottomOfScrollView:(UIScrollView *)scrollV
{
    CGFloat scrollRealHeight = CGRectGetHeight(scrollV.bounds) - scrollV.contentInset.top;
    CGFloat contentHeight = scrollV.contentSize.height;
    return scrollRealHeight > contentHeight ? scrollRealHeight : contentHeight;
}

- (BOOL)isContentFullVisiableOfScrollView:(UIScrollView *)scrollV
{
    CGFloat scrollRealHeight = CGRectGetHeight(scrollV.bounds) - scrollV.contentInset.top;
    CGFloat contentHeight = scrollV.contentSize.height;
    return scrollRealHeight > contentHeight;
}

#pragma mark - KVO handler

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self observeScrollViewContentSizeChanged];
        return;
    }
    
    if ([keyPath isEqualToString:@"contentInset"]) {
        [self observeScrollViewContentInsetChanged];
        return;
    }
}

- (void)updateState:(UpLoadMoreControlState)state
{
    _state = state;
    
    switch (state) {
        case UpLoadMoreControlStateNormal:
            [self.activityIndicatorView stopAnimating];
            self.stateLabel.alpha = 1.f;
//            self.stateLabel.text = NSLocalizedStringFromTable(@"Pull up to load more ...", @"UpLoadMoreControl", nil);
            self.stateLabel.text = UpLoadMoreControlLocalizedString(@"Pull up to load more ...");
            break;
        case UpLoadMoreControlStateReady:
            [self.activityIndicatorView stopAnimating];
            self.stateLabel.alpha = 1.f;
//            self.stateLabel.text = NSLocalizedStringFromTable(@"Release to load more ...", @"UpLoadMoreControl", nil);
            self.stateLabel.text = UpLoadMoreControlLocalizedString(@"Release to load more ...");
            break;
        case UpLoadMoreControlStateLoading:
            [self.activityIndicatorView startAnimating];
            self.stateLabel.alpha = 0.f;
            self.stateLabel.text = nil;
            break;
        case UpLoadMoreControlStateFinishing:
            [self.activityIndicatorView stopAnimating];
            self.stateLabel.alpha = 1.f;
            break;
        default:
            break;
    }
}

- (void)observeScrollViewContentSizeChanged
{
    if ([self isContentFullVisiableOfScrollView:self.scrollView]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(updateScrollContentSizeToSuitable)
                                                   object:nil];
        [self performSelector:@selector(updateScrollContentSizeToSuitable) withObject:nil];
    } else {
        [self updateFrame];
    }
}

- (void)updateScrollContentSizeToSuitable
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,
                                             [self bottomOfScrollView:self.scrollView]);
}

- (void)observeScrollViewContentInsetChanged
{
    [self updateFrame];
}

- (void)updateFrame
{
    self.frame = CGRectMake(0,
                            [self bottomOfScrollView:self.scrollView],
                            CGRectGetWidth(self.scrollView.bounds),
                            UpLoadMoreControlHeight);
}

- (void)scrollViewDidScroll
{
    if (self.state == UpLoadMoreControlStateLoading || self.state == UpLoadMoreControlStateFinishing) {
        return;
    }
    
    if (!self.scrollView.isDragging) {
        return;
    }
    
    CGFloat contentOffsetY = self.scrollView.contentOffset.y;

    if (contentOffsetY + self.scrollView.contentInset.top <= 0) {
        return;
    }
    
    
    CGFloat depend = 0;
    if ([self isContentFullVisiableOfScrollView:self.scrollView]) {
        depend = contentOffsetY + self.scrollView.contentInset.top;
        
    } else {
        depend = contentOffsetY - (self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds));
    }
    
    if (depend > 0 && depend < self.threshold) {
        // 还没有到达准备刷新的临界点
        if (self.state == UpLoadMoreControlStateReady) {
            [self updateState:UpLoadMoreControlStateNormal];
        }
        
    } else if (depend > self.threshold){
        // 超过刷新的临界点，改变状态刷新
        if (self.state == UpLoadMoreControlStateNormal) {
            [self updateState:UpLoadMoreControlStateReady];
        }
    }
}

- (void)scrollViewDidEndDragging
{
    if (!self.scrollView.isDragging) {
        if (self.state == UpLoadMoreControlStateReady) {
            [self updateState:UpLoadMoreControlStateLoading];
            
            _originalBottomContentInset = self.scrollView.contentInset.bottom;
            
            UIEdgeInsets newInsets = self.scrollView.contentInset;
            newInsets.bottom = self.originalBottomContentInset + UpLoadMoreControlHeight;
            self.scrollView.contentInset = newInsets;
            
            __weak typeof(self)weakSelf = self;
            if (self.loadMoreActionHandler) {
                self.loadMoreActionHandler(weakSelf);
            }
        }
    }
}

+ (NSBundle *)uploadMoreControlBundle
{
    return [NSBundle bundleWithPath:[self uploadMoreControlBundlePath]];
}

+ (NSString *)uploadMoreControlBundlePath
{
    return [[NSBundle bundleForClass:[UpLoadMoreControl class]]
            pathForResource:@"UpLoadMoreControl" ofType:@"bundle"];
}

@end
