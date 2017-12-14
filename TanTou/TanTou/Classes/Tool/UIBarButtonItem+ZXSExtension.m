//
//  UIBarButtonItem+ZXSExtension.m
//  TanTou
//
//  Created by StoneMan on 2017/11/3.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import "UIBarButtonItem+ZXSExtension.h"

@implementation UIBarButtonItem (ZXSExtension)

/**
 获取带有高亮状态的UIBarButtonItem
 */
+ (instancetype)zxs_barButtonItemWithHighlightedStatusWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //使用UIView包裹button是为了防止button边界以外点击触发事件
    UIView *containView = [[UIView alloc] initWithFrame:button.bounds];
    [containView addSubview:button];
    return [[self alloc] initWithCustomView:containView];
}


/**
 获取带有选中状态的UIBarButtonItem
 */
+ (instancetype)zxs_barButtonItemWithSelectedStatusWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //使用UIView包裹button是为了防止button边界以外点击触发事件
    UIView *containView = [[UIView alloc] initWithFrame:button.bounds];
    [containView addSubview:button];
    return [[self alloc] initWithCustomView:containView];
}


/**
 获取带有高亮状态的返回功能的UIBarButtonItem
 */
+ (instancetype)zxs_barButtonItemWithBackFunctionWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //将内容向前挤压,以达到减少空格区间。使用户感觉更加友好美观。
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 10);
    
    //使用UIView包裹button是为了防止button边界以外点击触发事件
    UIView *containView = [[UIView alloc] initWithFrame:button.bounds];
    [containView addSubview:button];
    return [[self alloc] initWithCustomView:containView];
}

/**
 获取带有高亮状态的返回功能的UIBarButtonItem
 */
+ (instancetype)zxs_barButtonItemWithBackFunctionWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //使用UIView包裹button是为了防止button边界以外点击触发事件
    UIView *containView = [[UIView alloc] initWithFrame:button.bounds];
    [containView addSubview:button];
    return [[self alloc] initWithCustomView:containView];
}

/**
 设置带有颜色、大小和文字的UIBarButtonItem
 */
+ (instancetype)zxs_barButtonItemWithColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //使用UIView包裹button是为了防止button边界以外点击触发事件
    UIView *containView = [[UIView alloc] initWithFrame:button.bounds];
    [containView addSubview:button];
    return [[self alloc] initWithCustomView:containView];
}

@end
