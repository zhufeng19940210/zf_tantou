//
//  UIBarButtonItem+ZXSExtension.h
//  TanTou
//
//  Created by StoneMan on 2017/11/3.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZXSExtension)

/**
 获取带有高亮状态的UIBarButtonItem
 */
+ (instancetype)zxs_barButtonItemWithHighlightedStatusWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action;

/**
 获取带有选中状态的UIBarButtonItem
 */
+ (instancetype)zxs_barButtonItemWithSelectedStatusWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;

/**
 获取带有高亮状态的返回功能的UIBarButtonItem
 */
+ (instancetype)zxs_barButtonItemWithBackFunctionWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action title:(NSString *)title;

/**
 获取带有高亮状态的返回功能的UIBarButtonItem
 */
+ (instancetype)zxs_barButtonItemWithBackFunctionWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action;

/**
 设置带有颜色、大小和文字的UIBarButtonItem
 */
+ (instancetype)zxs_barButtonItemWithColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action title:(NSString *)title;


@end
