//
//  QJKJAutomaticInfiniteLoop.h
//  QJKJAutomaticInfiniteLoopDemo
//
//  Created by 城李 on 16/3/15.
//  Copyright © 2016年 LYC. All rights reserved.
//

// --无限循坏滚动
#import <UIKit/UIKit.h>

/**
 滚动方向
 */
typedef NS_ENUM(NSUInteger, QJKJCycleScrollViewDirection) {
    QJKJCycleScrollViewDirectionVerticalTop = 1,//垂直向上
    QJKJCycleScrollViewDirectionHorizontalLeft,//水平向左
    QJKJCycleScrollViewDirectionVerticalBottom,//垂直向下
    QJKJCycleScrollViewDirectionHorizontalRight,//水平向右
};

@protocol QJKJAutomaticInfiniteLoopDelegate <NSObject>

@required
/**
 *  资源 顺序【最后一个-(1-2-3-4...)-第一个】
 *
 *  @param view  当前出现的view
 *  @param index 位置
 */
- (void)qjkjRefreshUIWithView:(UIView *)view
                    withIndex:(NSInteger)index;

/**
 *  需要创建对象
 *
 *  @param index 位置
 */
- (void)qjkjGeneratingObject:(NSInteger)index;

@optional

/**
 *  当前处于第多少页
 *
 *  @param page 页码
 */
- (void)qjkjShowCurrenViewForPage:(NSInteger)page;

/**
 *  点击某个view时的位置
 *
 *  @param page 位置
 */
- (void)qjkjClickViewForPage:(NSInteger)page;

@end

@interface QJKJAutomaticInfiniteLoop : UIView

/**
 *  滚动方向 上左下右
 */
@property (nonatomic, assign) QJKJCycleScrollViewDirection cycleScrollViewDirection;

/**
 *  设置初始位置
 */
@property (nonatomic, assign) NSInteger currentIndex;


/**
 *  滚动资源
 */
@property (nonatomic, assign) NSInteger contentCount;

/**
 *  滚动时间，不设置则不自动滚动
 */
@property (nonatomic, assign) CGFloat automaticScrollInterval;


@property (nonatomic, weak) id<QJKJAutomaticInfiniteLoopDelegate> delegate;

/**
 *  在回调的时候创建对象，只会创建两次
 *
 *  @param view  自定义对象
 *  @param index 位置
 */
- (void)creatView:(UIView *)view
        withIndex:(NSInteger)index;

@end
