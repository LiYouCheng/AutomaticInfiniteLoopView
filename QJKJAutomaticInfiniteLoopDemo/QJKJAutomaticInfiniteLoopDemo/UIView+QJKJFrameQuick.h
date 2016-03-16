//
//  UIView+QJKJFrameQuick.h
//  weiGuanJia
//
//  Created by 城李 on 15/10/26.
//  Copyright © 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QJKJFrameQuick)

@property CGPoint origin;
@property CGSize size;
@property CGFloat height;
@property CGFloat width;
@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;

- (void)sFrame;

@end
