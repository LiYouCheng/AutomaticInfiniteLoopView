//
//  QJKJMessageAutomaticInfiteLoop.m
//  QJKJAutomaticInfiniteLoopDemo
//
//  Created by 城李 on 16/3/15.
//  Copyright © 2016年 LYC. All rights reserved.
//

#import "QJKJMessageAutomaticInfiteLoop.h"

#import "QJKJAutomaticInfiniteLoop.h"
#import "UIView+QJKJFrameQuick.h"

@interface QJKJMessageAutomaticInfiteLoop ()
<QJKJAutomaticInfiniteLoopDelegate>

@property (nonatomic, strong) QJKJAutomaticInfiniteLoop *infiniteLoop;

/**
 *  资源（image，url完全自定义）
 */
@property (nonatomic, strong) NSMutableArray *contentMArray;

@end

@implementation QJKJMessageAutomaticInfiteLoop


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        QJKJAutomaticInfiniteLoop *automaticInfiniteLoop = [[QJKJAutomaticInfiniteLoop alloc] initWithFrame:self.bounds];
        automaticInfiniteLoop.delegate = self;
        automaticInfiniteLoop.cycleScrollViewDirection = QJKJCycleScrollViewDirectionVerticalTop;
        automaticInfiniteLoop.contentCount = self.contentMArray.count - 2;
        automaticInfiniteLoop.automaticScrollInterval = 3;
        automaticInfiniteLoop.currentIndex = 0;
        [self addSubview:automaticInfiniteLoop];
        
        self.infiniteLoop = automaticInfiniteLoop;
        
    }
    return self;
}

#pragma mark - QJKJAutomaticInfiniteLoopDelegate

//自定义view
- (void)qjkjGeneratingObject:(NSInteger)index {
    [self.infiniteLoop creatView:[[UILabel alloc] init] withIndex:index];
}

//刷新自定义view数据
- (void)qjkjRefreshUIWithView:(UIView *)view withIndex:(NSInteger)index {
    UILabel *label = (UILabel *)view;
    label.backgroundColor = [UIColor greenColor];
    
    label.text = self.contentMArray[index];
    label.textColor = [UIColor redColor];
}

/**
 *  格式为 [最后一个，1，2，3...第一个]
 *
 *  @return return value description
 */
- (NSMutableArray *)contentMArray {
    if (!_contentMArray) {
        _contentMArray = [NSMutableArray array];
        
        //测试数据
        for (NSInteger i = 0; i < 10; i++) {
            [_contentMArray addObject:[NSString stringWithFormat:@"消息:有%ld条消息待处理",(long)i + 1]];
        }
        
        //注意资源格式
        [_contentMArray insertObject:[_contentMArray lastObject] atIndex:0];
        NSAssert(_contentMArray.count > 1, @"无数据");
        [_contentMArray addObject:_contentMArray[1]];
        
    }
    return _contentMArray;
}

@end
