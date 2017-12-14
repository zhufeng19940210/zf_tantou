//
//  UIImageView+ZXSExtension.m
//  TanTou
//
//  Created by StoneMan on 2017/11/11.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import "UIImageView+ZXSExtension.h"

@implementation UIImageView (ZXSExtension)

+ (instancetype)zxs_imageViewWithImage:(UIImage *)image bounds:(CGRect)bounds {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.bounds = bounds;
    imageView.image = image;
    return imageView;
}

@end
