//
//  UIView+QJKJFrameQuick.m
//  weiGuanJia
//
//  Created by 城李 on 15/10/26.
//  Copyright © 2015年 LYC. All rights reserved.
//

#import "UIView+QJKJFrameQuick.h"

@implementation UIView (QJKJFrameQuick)

- (CGPoint) origin
{
    return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (CGSize) size
{
    return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (void)sFrame
{
    CGFloat floatHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat floatWidth = [UIScreen mainScreen].bounds.size.width;
    
    // iPhone4
    CGFloat floatX1 = self.frame.origin.x;
    CGFloat floatY1 = self.frame.origin.y;
    CGFloat floatWidth1 = self.size.width;
    CGFloat floatHeight1 = self.size.height;
    
    // All
    CGFloat floatX2;
    CGFloat floatY2;
    CGFloat floatWidth2;
    CGFloat floatHeight2;
    
    // iPhone5
    if (floatHeight <= 568)
    {
        floatX2 = floatX1;
        floatY2 = floatY1;
        floatWidth2 = floatWidth1;
        floatHeight2 = floatHeight1;
    }
    // iPhone6
    else if (floatWidth == 375)
    {
        CGFloat floatMMMM = (375-320)/320.0+1;
        floatX2 = floatX1*floatMMMM;
        floatY2 = floatY1*floatMMMM;
        floatWidth2 = floatWidth1*floatMMMM;
        floatHeight2 = floatHeight1*floatMMMM;
    }
    // iPhone6P
    else if (floatWidth == 414)
    {
        CGFloat floatMMMM = (414-320)/320.0+1;
        
        floatX2 = floatX1*floatMMMM;
        floatY2 = floatY1*floatMMMM;
        floatWidth2 = floatWidth1*floatMMMM;
        floatHeight2 = floatHeight1*floatMMMM;
    }
    
    self.frame = CGRectMake(floatX2, floatY2, floatWidth2, floatHeight2);
}

@end
