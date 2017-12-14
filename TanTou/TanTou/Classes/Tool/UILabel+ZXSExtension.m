//
//  UILabel+ZXSExtension.m
//  TanTou
//
//  Created by StoneMan on 2017/11/10.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import "UILabel+ZXSExtension.h"

@implementation UILabel (ZXSExtension)

+ (instancetype)zxs_labelWithTextColor:(UIColor *)textColor font:(UIFont *)font text:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    return label;
}

@end
