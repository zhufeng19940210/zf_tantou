//
//  ZFCustomAlterView.m
//  BL6600
//
//  Created by bailing on 2017/9/8.
//  Copyright © 2017年 bailing. All rights reserved.
//
#import "ZFCustomAlterView.h"
@interface ZFCustomAlterView()
@end
@implementation ZFCustomAlterView
//显示
-(void)showShareViewAddView:(UIView *)myView tapGestureWithBool:(BOOL)isTapGesture{
    //背景图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ZXSSCREEN_WIDTH ,ZXSSCREEN_HEIGHT)];
    if (isTapGesture == YES) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
        [blackView addGestureRecognizer:tapGesture];
    }
    blackView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:0.4];
    blackView.tag = 440;
    [window addSubview:blackView];
    [window addSubview:myView];
}
-(void)hiddenView{
    NSLog(@"fdjskfskfldslflds");
    if ([self.delegate respondsToSelector:@selector(customAlterViewHidden)]) {
        [self.delegate customAlterViewHidden];
    }
}
//隐藏
-(void)hihhdenView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:440];
    //为了弹窗不那么生硬，这里加了个简单的动画
    [UIView animateWithDuration:0.1f animations:^{
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
    }];
}
@end
