//
//  UIButton+ZXSExtension.h
//  TanTou
//
//  Created by StoneMan on 2017/11/4.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZXSExtension)

+ (instancetype)zxs_buttonWithTitleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action title:(NSString *)title;

+ (instancetype)zxs_buttonWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage bounds:(CGRect)bounds target:(id)target action:(SEL)action;

+ (instancetype)zxs_buttonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage bounds:(CGRect)bounds target:(id)target action:(SEL)action;

+ (instancetype)zxs_buttonWithBackGroundImage:(UIImage *)backGroundImage highlightedBackGroundImage:(UIImage *)highlightedBackGroundImage bounds:(CGRect)bounds titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action attributedTitle:(NSString *)attributedTitle;

+ (instancetype)zxs_buttonWithBackGroundImage:(UIImage *)backGroundImage highlightedBackGroundImage:(UIImage *)highlightedBackGroundImage bounds:(CGRect)bounds titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action title:(NSString *)title;

+ (instancetype)zxs_buttonWithBackGroundImage:(UIImage *)backGroundImage selectedBackGroundImage:(UIImage *)selectedBackGroundImage bounds:(CGRect)bounds titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action title:(NSString *)title;

@end
