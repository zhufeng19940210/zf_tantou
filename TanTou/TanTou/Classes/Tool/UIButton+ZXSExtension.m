//
//  UIButton+ZXSExtension.m
//  TanTou
//
//  Created by StoneMan on 2017/11/4.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import "UIButton+ZXSExtension.h"

@implementation UIButton (ZXSExtension)

+ (instancetype)zxs_buttonWithTitleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:titleFont];
    [button sizeToFit];
    [button setClipsToBounds:YES];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (instancetype)zxs_buttonWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage bounds:(CGRect)bounds target:(id)target action:(SEL)action {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button setClipsToBounds:YES];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.bounds = bounds;
    return button;
    
}

+ (instancetype)zxs_buttonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage bounds:(CGRect)bounds target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button sizeToFit];
    [button setClipsToBounds:YES];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    button.bounds = bounds;
    return button;
    
}

+ (instancetype)zxs_buttonWithBackGroundImage:(UIImage *)backGroundImage highlightedBackGroundImage:(UIImage *)highlightedBackGroundImage bounds:(CGRect)bounds titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action attributedTitle:(NSString *)attributedTitle {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:backGroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBackGroundImage forState:UIControlStateHighlighted];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:attributedTitle attributes:@{NSForegroundColorAttributeName:titleColor ,NSFontAttributeName:titleFont}];
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    [button sizeToFit];
    [button setClipsToBounds:YES];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.bounds = bounds;
    return button;
}

+ (instancetype)zxs_buttonWithBackGroundImage:(UIImage *)backGroundImage highlightedBackGroundImage:(UIImage *)highlightedBackGroundImage bounds:(CGRect)bounds titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:backGroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBackGroundImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:titleFont];
    [button sizeToFit];
    [button setClipsToBounds:YES];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.bounds = bounds;
    return button;
}

+ (instancetype)zxs_buttonWithBackGroundImage:(UIImage *)backGroundImage selectedBackGroundImage:(UIImage *)selectedBackGroundImage bounds:(CGRect)bounds titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:backGroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:selectedBackGroundImage forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:titleFont];
    [button sizeToFit];
    [button setClipsToBounds:YES];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.bounds = bounds;
    return button;
}
@end
