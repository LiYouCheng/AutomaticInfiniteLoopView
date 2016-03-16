//
//  QJKJAutomaticInfiniteLoop.m
//  QJKJAutomaticInfiniteLoopDemo
//
//  Created by 城李 on 16/3/15.
//  Copyright © 2016年 LYC. All rights reserved.
//

#import "QJKJAutomaticInfiniteLoop.h"

#import "UIView+QJKJFrameQuick.h"

#define DCOLOR_RANDOM [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0]

@interface QJKJAutomaticInfiniteLoop ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *autoScrollView;//主view
@property (nonatomic, assign) CGFloat       scrollInterval;

/**
 *  资源view
 */
@property (nonatomic, assign) NSInteger     resourceCount;

/**
 *  保存可见的视图
 */
@property (nonatomic, strong) NSMutableSet  *visibleViews;

/**
 *  保存可重用的
 */
@property (nonatomic, strong) NSMutableSet  *reusedViews;


@property (nonatomic, assign) NSTimer           *autoTimer;


@property (nonatomic, strong) NSMutableArray    *resoureMArray;

@property (nonatomic, assign) NSInteger         currentLocation;

@property (nonatomic, assign) BOOL isAuto;//是否自动滚动

@end

@implementation QJKJAutomaticInfiniteLoop

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        _isAuto = NO;
        
        [self addSubview:self.autoScrollView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.autoScrollView.frame = self.bounds;
    
    BOOL flag = (self.cycleScrollViewDirection == QJKJCycleScrollViewDirectionHorizontalLeft) || (self.cycleScrollViewDirection == QJKJCycleScrollViewDirectionHorizontalRight);//水平方向

    self.autoScrollView.contentSize = (flag ? CGSizeMake(self.autoScrollView.width * self.resourceCount, 0) : CGSizeMake(0, self.autoScrollView.height * self.resourceCount));
    
    [self scrollLocationForPage:self.currentLocation];

}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self.autoTimer invalidate];
        self.autoTimer = nil;
    }
}

/**
 *  资源总量
 *
 *  @param contentCount
 */
- (void)setContentCount:(NSInteger)contentCount {
    self.resourceCount = (contentCount + 2);
}

/**
 *  设置初始化位置
 *
 *  @param currentIndex currentIndex description
 */
- (void)setCurrentIndex:(NSInteger)currentIndex {
    self.currentLocation = currentIndex + 1;
}

/**
 *  滚动到指定位置
 *
 *  @param page 页码
 */
- (void)scrollLocationForPage:(NSInteger)page {
    BOOL flag = (self.cycleScrollViewDirection == QJKJCycleScrollViewDirectionHorizontalLeft) || (self.cycleScrollViewDirection == QJKJCycleScrollViewDirectionHorizontalRight);//水平方向
    
    CGPoint point = (flag ? CGPointMake(self.autoScrollView.width * page, 0) : CGPointMake(0, self.autoScrollView.height * page));
    [self.autoScrollView setContentOffset:point animated:YES];
}

/**
 *  设置是否自动滚动
 *
 *  @param automaticScrollInterval 时间
 */
- (void)setAutomaticScrollInterval:(CGFloat)automaticScrollInterval {
    self.scrollInterval = automaticScrollInterval;
    
    _isAuto = YES;
    
    [self setupTimer];
}

/**
 *  显示当前页码
 *
 *  @param scrollView scrollView description
 */
- (void)showCurrentPageForScrollView:(UIScrollView *)scrollView {
    NSInteger page = (NSInteger)scrollView.contentOffset.x / self.autoScrollView.width;

    if (_delegate && [_delegate respondsToSelector:@selector(qjkjShowCurrenViewForPage:)]) {
        [_delegate qjkjShowCurrenViewForPage:page - 1];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showViews];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if ([self.autoTimer isValid]) {
        [self.autoTimer invalidate];
        self.autoTimer = nil;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setupTimer];
    
    NSInteger page = (NSInteger)scrollView.contentOffset.x/scrollView.width;
    if (page >= self.resourceCount - 1) {
        [self.autoScrollView setContentOffset:[self pointForPage:1] animated:NO];
    }
    else if (page <= 0) {
        [self.autoScrollView setContentOffset:[self pointForPage:(self.resourceCount - 2)] animated:NO];
    }
    else {
        
    }
    
    [self showCurrentPageForScrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger page = (NSInteger)scrollView.contentOffset.x/scrollView.width;
    if (page >= self.resourceCount - 1) {
        [self.autoScrollView setContentOffset:[self pointForPage:1] animated:NO];
    }
    else if (page <= 0) {
        [self.autoScrollView setContentOffset:[self pointForPage:(self.resourceCount - 2)] animated:NO];
    }
    else {
        
    }
    
    [self showCurrentPageForScrollView:scrollView];
}

#pragma mark - Custom Method

- (void)setupTimer
{
    if (_isAuto) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
        _autoTimer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)automaticScroll {
    
    CGPoint point;
    switch (self.cycleScrollViewDirection) {
        case QJKJCycleScrollViewDirectionHorizontalLeft:
        {
            CGFloat changeX = roundf(self.autoScrollView.contentOffset.x / self.autoScrollView.width) * self.autoScrollView.width;
            point = CGPointMake(changeX + self.autoScrollView.width, 0);
        }
            break;
        case QJKJCycleScrollViewDirectionHorizontalRight:
        {
            CGFloat changeX = roundf(self.autoScrollView.contentOffset.x / self.autoScrollView.width) * self.autoScrollView.width;
            point = CGPointMake(changeX - self.autoScrollView.width, 0);
        }
            break;
        case QJKJCycleScrollViewDirectionVerticalTop:
        {
            CGFloat changeY = roundf(self.autoScrollView.contentOffset.y / self.autoScrollView.height) * self.autoScrollView.height;
            point = CGPointMake(0, changeY + self.autoScrollView.height);
        }
            break;
        case QJKJCycleScrollViewDirectionVerticalBottom:
        {
            CGFloat changeY = roundf(self.autoScrollView.contentOffset.y / self.autoScrollView.height) * self.autoScrollView.height;
            point = CGPointMake(0, changeY - self.autoScrollView.height);
        }
            break;
        default:
            break;
    }
    
    [self.autoScrollView setContentOffset:point animated:YES];
}

- (CGPoint)pointForPage:(NSInteger)page {
    CGPoint point;
    switch (self.cycleScrollViewDirection) {
        case QJKJCycleScrollViewDirectionHorizontalLeft:
        {
            point = CGPointMake(self.autoScrollView.width * page, 0);
        }
            break;
        case QJKJCycleScrollViewDirectionHorizontalRight:
        {
            point = CGPointMake(self.autoScrollView.width * page, 0);
        }
            break;
        case QJKJCycleScrollViewDirectionVerticalTop:
        {
            point = CGPointMake(0, self.autoScrollView.height * page);
        }
            break;
        case QJKJCycleScrollViewDirectionVerticalBottom:
        {
            point = CGPointMake(0, self.autoScrollView.height * page);
        }
            break;
        default:
            break;
    }
    return point;
}

- (void)showViews {
    
    // 获取当前处于显示范围内的图片的索引
    CGRect visibleBounds = self.autoScrollView.bounds;

    NSInteger firstIndex = 0;
    if (self.cycleScrollViewDirection == QJKJCycleScrollViewDirectionHorizontalLeft || self.cycleScrollViewDirection == QJKJCycleScrollViewDirectionHorizontalRight) {
        firstIndex = (NSInteger)floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    }
    else {
        firstIndex = (NSInteger)floorf(CGRectGetMinY(visibleBounds) / CGRectGetHeight(visibleBounds));
    }
    
    
    NSInteger lastIndex  = 0;
    if (self.cycleScrollViewDirection == QJKJCycleScrollViewDirectionHorizontalLeft || self.cycleScrollViewDirection == QJKJCycleScrollViewDirectionHorizontalRight) {
        lastIndex = (NSInteger)floorf(CGRectGetMaxX(visibleBounds) / CGRectGetWidth(visibleBounds));
    }
    else {
        lastIndex = (NSInteger)floorf(CGRectGetMaxY(visibleBounds) / CGRectGetHeight(visibleBounds));
    }

    //越界啥也不干
    if (firstIndex < 0) {
        return;
    }
    
    if (lastIndex >= self.resourceCount) {
        return;
    }
    
    // 回收不再显示的view
    NSInteger viewIndex = 0;
    for (UIView *view in self.visibleViews) {
        viewIndex = view.tag;
        // 不在显示范围内
        if (viewIndex < firstIndex || viewIndex > lastIndex) {
            [self.reusedViews addObject:view];
            [view removeFromSuperview];
        }
    }
    [self.visibleViews minusSet:self.reusedViews];
    
    // 是否需要显示新的视图
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        BOOL isShow = NO;
        
        for (UIView *view in self.visibleViews) {
            if (view.tag == index) {
                isShow = YES;
            }
        }
        
        if (!isShow) {
            [self showImageViewAtIndex:index];
        }
    }
}

- (void)clickView:(UIGestureRecognizer *)tgr {
    if (_delegate && [_delegate respondsToSelector:@selector(qjkjClickViewForPage:)]) {
        [_delegate qjkjClickViewForPage:tgr.view.tag - 1];
    }
}

/**
 *  创建view
 *
 *  @param view  自定义的view
 *  @param index 位置
 */
- (void)creatView:(UIView *)view
        withIndex:(NSInteger)index {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
    
    [self showViewForView:view
                withIndex:index];
}

/**
 *  显示view
 *
 *  @param index 当前位置
 */
- (void)showImageViewAtIndex:(NSInteger)index {
    
    UIView *view = [self.reusedViews anyObject];
    
    if (view) {
        [self.reusedViews removeObject:view];
    } else {
        
        //创建对象
        if (_delegate && [_delegate respondsToSelector:@selector(qjkjGeneratingObject:)]) {
            [_delegate qjkjGeneratingObject:index];
        }
        return;
    }
    
    [self showViewForView:view withIndex:index];
    
}

/**
 *  显示展示的区域
 *
 *  @param view 需要展示的view
 */
- (void)showViewForView:(UIView *)view
              withIndex:(NSInteger)index {
    CGRect bounds = self.autoScrollView.bounds;
    CGRect viewFrame = bounds;
    
    switch (self.cycleScrollViewDirection) {
        case QJKJCycleScrollViewDirectionHorizontalLeft:
        {
            viewFrame.origin.x = CGRectGetWidth(bounds) * index;
        }
            break;
        case QJKJCycleScrollViewDirectionHorizontalRight:
        {
            viewFrame.origin.x = CGRectGetWidth(bounds) * index;
        }
            break;
        case QJKJCycleScrollViewDirectionVerticalTop:
        {
            viewFrame.origin.y = CGRectGetHeight(bounds) * index;
        }
            break;
        case QJKJCycleScrollViewDirectionVerticalBottom:
        {
            viewFrame.origin.y = CGRectGetHeight(bounds) * index;
        }
            break;
        default:
            break;
    }
    view.tag = index;
    view.frame = viewFrame;
    
    [self.visibleViews addObject:view];
    [self.autoScrollView addSubview:view];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(qjkjRefreshUIWithView:withIndex:)]) {
        [_delegate qjkjRefreshUIWithView:view withIndex:index];
    }
}


#pragma mark - getters or setters

- (UIScrollView *)autoScrollView {
    if (!_autoScrollView) {
        _autoScrollView = [[UIScrollView alloc] init];
        _autoScrollView.pagingEnabled = YES;
        _autoScrollView.delegate = self;
        _autoScrollView.showsHorizontalScrollIndicator = NO;
        _autoScrollView.showsVerticalScrollIndicator = NO;
    }
    return _autoScrollView;
}

- (NSMutableSet *)visibleViews {
    if (!_visibleViews) {
        _visibleViews = [[NSMutableSet alloc] init];
    }
    return _visibleViews;
}

- (NSMutableSet *)reusedViews {
    if (!_reusedViews) {
        _reusedViews = [[NSMutableSet alloc] init];
    }
    return _reusedViews;
}

@end
