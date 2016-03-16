//
//  QJKJImageAutomaticInfiniteLoop.m
//  QJKJAutomaticInfiniteLoopDemo
//
//  Created by 城李 on 16/3/15.
//  Copyright © 2016年 LYC. All rights reserved.
//

#import "QJKJImageAutomaticInfiniteLoop.h"

#import "QJKJAutomaticInfiniteLoop.h"
#import "UIView+QJKJFrameQuick.h"

@interface QJKJImageAutomaticInfiniteLoop ()
<QJKJAutomaticInfiniteLoopDelegate>

@property (nonatomic, strong) QJKJAutomaticInfiniteLoop *infiniteLoop;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageLabel;
/**
 *  资源（image，url完全自定义）
 */
@property (nonatomic, strong) NSMutableArray *contentMArray;



@end

@implementation QJKJImageAutomaticInfiniteLoop

- (void)dealloc {
    self.infiniteLoop.delegate = nil;
    self.infiniteLoop = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        QJKJAutomaticInfiniteLoop *automaticInfiniteLoop = [[QJKJAutomaticInfiniteLoop alloc] initWithFrame:self.bounds];
        automaticInfiniteLoop.delegate = self;
        automaticInfiniteLoop.cycleScrollViewDirection = QJKJCycleScrollViewDirectionHorizontalLeft;
        automaticInfiniteLoop.contentCount = self.contentMArray.count - 2;
        automaticInfiniteLoop.automaticScrollInterval = 5;
        automaticInfiniteLoop.currentIndex = 0;
        [self addSubview:automaticInfiniteLoop];
        
        self.infiniteLoop = automaticInfiniteLoop;
        
        [self addSubview:self.pageControl];
        [self addSubview:self.pageLabel];

    }
    return self;
}

#pragma mark - QJKJAutomaticInfiniteLoopDelegate

- (void)qjkjGeneratingObject:(NSInteger)index {
    [self.infiniteLoop creatView:[[UIImageView alloc] init] withIndex:index];
}

- (void)qjkjRefreshUIWithView:(UIView *)view
                    withIndex:(NSInteger)index {
    UIImageView *imageView = (UIImageView *)view;
    imageView.image = [UIImage imageNamed:self.contentMArray[index]];
}

- (void)qjkjShowCurrenViewForPage:(NSInteger)page {
    NSLog(@"当前处于第%ld页",(long)page);
    [self.pageControl setCurrentPage:page];
}

- (void)qjkjClickViewForPage:(NSInteger)page {
    NSLog(@"当前点击第%ld页",(long)page);
    self.pageLabel.text = [NSString stringWithFormat:@"点击第%ld页",(long)page];
}


#pragma mark - getters or setters

/**
 *  格式为 最后一个，1，2，3...第一个
 *
 *  @return return value description
 */
- (NSMutableArray *)contentMArray {
    if (!_contentMArray) {
        _contentMArray = [NSMutableArray array];
        
        //测试数据
        for (NSInteger i = 0; i < 5; i++) {
            [_contentMArray addObject:[NSString stringWithFormat:@"image%ld",(long)i + 1]];
        }

        //注意资源格式
        [_contentMArray insertObject:[_contentMArray lastObject] atIndex:0];
        NSAssert(_contentMArray.count > 1, @"无数据");
        [_contentMArray addObject:_contentMArray[1]];
    }
    return _contentMArray;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, self.infiniteLoop.height - 30, self.infiniteLoop.width - 10 * 2 - 100, 20)];
//        _pageControl.backgroundColor = [UIColor greenColor];
        _pageControl.pageIndicatorTintColor = [UIColor yellowColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.numberOfPages = self.contentMArray.count - 2;
    }
    return _pageControl;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.infiniteLoop.width - 150, _pageControl.top, 140, _pageControl.height)];
        _pageLabel.textColor = [UIColor redColor];
        _pageLabel.font = [UIFont systemFontOfSize:14];
        _pageLabel.textAlignment = NSTextAlignmentRight;
        _pageLabel.text = [NSString stringWithFormat:@"点击第几页"];
    }
    return _pageLabel;
}

@end
