//
//  ViewController.m
//  QJKJAutomaticInfiniteLoopDemo
//
//  Created by 城李 on 16/3/15.
//  Copyright © 2016年 LYC. All rights reserved.
//

#import "ViewController.h"

#import "QJKJAutomaticInfiniteLoop.h"
#import "UIView+QJKJFrameQuick.h"

#import "QJKJImageAutomaticInfiniteLoop.h"
#import "QJKJMessageAutomaticInfiteLoop.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义图片轮播,可以设置向右或者向左自动滚动
    QJKJImageAutomaticInfiniteLoop *automaticInfiniteLoop1 = [[QJKJImageAutomaticInfiniteLoop alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.view addSubview:automaticInfiniteLoop1];
    
    //自定义消息轮播,可以设置向右或者向左自动滚动
    QJKJMessageAutomaticInfiteLoop *automaticInfiniteLoop2 = [[QJKJMessageAutomaticInfiteLoop alloc] initWithFrame:CGRectMake(0, 350, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.view addSubview:automaticInfiniteLoop2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
