//
//  ZFNavigtionController.m
//  TanTou
//
//  Created by bailing on 2017/12/13.
//  Copyright © 2017年 bailing. All rights reserved.
//
#import "ZFNavigtionController.h"
@interface ZFNavigtionController ()<UIGestureRecognizerDelegate>
@end
@implementation ZFNavigtionController
-(void)viewDidLoad
{   [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dict =@{
                          NSForegroundColorAttributeName:[UIColor whiteColor],
                          NSFontAttributeName:[UIFont systemFontOfSize:18]
                          };
    [self.navigationBar setTitleTextAttributes:dict];
    //侧滑的代理方法
    //self.interactivePopGestureRecognizer.delegate = self;
}
/*
 * 重写push
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 不是第一个push进来的 左上角加上返回键
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setImage:[UIImage imageNamed:@"bai2"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"hei2"] forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        // 隐藏底部的工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
//返回按钮了
-(void)backClick{
    [super popViewControllerAnimated:NO];
}
#pragma mark UIGestureRecognizerDelegate 代理方法
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}
@end
