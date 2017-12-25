//  ZFIntroductViewController.m
//  TanTou
//
//  Created by bailing on 2017/12/25.
//  Copyright © 2017年 bailing. All rights reserved.
//
#import "ZFIntroductViewController.h"
@interface ZFIntroductViewController ()
@end
@implementation ZFIntroductViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"探头介绍";
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
