//
//  WelcomeViewController.m
//  TanTou
//
//  Created by bailing on 2017/8/11.
//  Copyright © 2017年 bailing. All rights reserved.
//  引导页

#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ZFNavigtionController.h"
@interface WelcomeViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myImageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end
@implementation WelcomeViewController
#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupWelcomeScrollView];
    [self setupWelceomPageView];
}
#pragma mark - 自定义方法
- (void)setupWelcomeScrollView {
    self.myImageScrollView.contentSize = CGSizeMake(ZXSSCREEN_WIDTH * 2, ZXSSCREEN_HEIGHT);
    self.myImageScrollView.pagingEnabled = YES;
    self.myImageScrollView.delegate = self;
    self.myImageScrollView.showsHorizontalScrollIndicator = NO;
    self.myImageScrollView.showsVerticalScrollIndicator = NO;
    self.myImageScrollView.bounces = NO;
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome_one.png"]];
    [self.myImageScrollView addSubview:imageView1];
    imageView1.frame = CGRectMake(0, 0, ZXSSCREEN_WIDTH, ZXSSCREEN_HEIGHT);
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome_two.png"]];
    [self.myImageScrollView addSubview:imageView2];
    imageView2.frame = CGRectMake(ZXSSCREEN_WIDTH, 0, ZXSSCREEN_WIDTH, ZXSSCREEN_HEIGHT);
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    imageView2.userInteractionEnabled = YES;
    
    UIButton *button = [[UIButton alloc] init];
    [imageView2 addSubview:button];
    [button setTitle:@"进入探头" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:(33.0f / 255.0f) green:(203.0f / 255.0f) blue:(200.0f / 255.0f) alpha:1.0] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.cornerRadius = ZXSRealValueFit6SWidthPt(40);
    button.frame = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(240), ZXSRealValueFit6SWidthPt(80));
    button.center = CGPointMake(imageView2.frame.size.width * 0.5, imageView2.frame.size.height * 0.92);
    [button addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupWelceomPageView {
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
}
#pragma mark - 触发事件
- (void)enterBtnClick {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    ZFNavigtionController *nav = [[ZFNavigtionController alloc] initWithRootViewController:homeVC];
    appDelegate.window.rootViewController = nav;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstRun"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong2];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark -UIScollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    long int page = lroundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSLog(@"page:%ld",page);
    self.pageControl.currentPage = page;
    if (page == 1) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
    }
}
@end
