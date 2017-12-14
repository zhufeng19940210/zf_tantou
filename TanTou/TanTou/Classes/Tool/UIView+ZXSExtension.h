//
//  UIView+ZXSExtension.h
//  TanTou
//
//  Created by StoneMan on 7/28/16.
//  Copyright © 2016 StoneMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZXSExtension)

#pragma mark - 属性
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

#pragma mark - 方法
+ (instancetype)zxs_coverViewWithBounds:(CGRect)bounds backgroundColor:(UIColor *)backgroundColor alpha:(CGFloat)alpha hidden:(BOOL)hidden target:(id)target action:(SEL)action;
@end
