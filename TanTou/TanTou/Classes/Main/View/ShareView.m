//
//  ShareView.m
//  TYAlertControllerDemo
//
//  Created by tanyang on 15/10/26.
//  Copyright © 2015年 tanyang. All rights reserved.
//分享弹窗

#import "ShareView.h"

@interface  ShareView()
    
@end

@implementation ShareView

- (IBAction)weiboAction:(UIButton *)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(clickMyShareButtonWithTag:)]) {
            [self.delegate clickMyShareButtonWithTag:(int)sender.tag];
        }
    }
}
- (IBAction)weixinAction:(UIButton *)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(clickMyShareButtonWithTag:)]) {
            [self.delegate clickMyShareButtonWithTag:(int)sender.tag];
        }
    }
}
- (IBAction)QQbtnAction:(UIButton *)sender {
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(clickMyShareButtonWithTag:)]) {
            [self.delegate clickMyShareButtonWithTag:(int)sender.tag];
        }
    }
    
}
- (IBAction)pengyouquanAction:(UIButton *)sender {
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(clickMyShareButtonWithTag:)]) {
            [self.delegate clickMyShareButtonWithTag:(int)sender.tag];
        }
    }
    
}
- (IBAction)cancelAction:(UIButton *)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(clickMyShareButtonWithTag:)]) {
            [self.delegate clickMyShareButtonWithTag:(int)sender.tag];
        }
    }
}
@end
