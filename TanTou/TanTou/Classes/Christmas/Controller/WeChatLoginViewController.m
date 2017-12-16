//
//  WeChatLoginViewController.m
//  TanTou
//
//  Created by StoneMan on 2017/11/15.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import "WeChatLoginViewController.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "ChristmasUserItem.h"
#import "ChristmasHomeViewController.h"
#import "MBProgressHUD+MJ.h"
#import "ZXSUtil.h"
@interface WeChatLoginViewController ()
//背景图片
@property (weak, nonatomic) UIImageView *backgroundImageView;
//返回按钮
@property (weak, nonatomic) UIButton *backButton;
//登录按钮
@property (weak, nonatomic) UIButton *loginButton;
/**screenWidth*/
@property (assign, nonatomic) CGFloat screenWidth;
/**screenHeight*/
@property (assign, nonatomic) CGFloat screenHeight;
/**用户*/
@property (strong, nonatomic) ChristmasUserItem *userItem;
/*mbproegress*/
@property (nonatomic,strong) MBProgressHUD *zfhud;
/**isLogin*/
@property (assign, nonatomic) BOOL isLogining;
@end
@implementation WeChatLoginViewController
#pragma mark - 懒加载
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [self.view addSubview:backgroundImageView];
        _backgroundImageView = backgroundImageView;
        backgroundImageView.image = [UIImage imageNamed:@"WeChat"];
        backgroundImageView.bounds = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    }
    return _backgroundImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        
        UIButton *backButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"fanhui"] highlightedImage:[UIImage imageNamed:@"fanhui"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(200), ZXSRealValueFit6SWidthPt(100)) target:self action:@selector(backButtonDidClick)];
        [self.view addSubview:backButton];
        _backButton = backButton;
    }
    return _backButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        UIButton *loginButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"denglu"] highlightedImage:[UIImage imageNamed:@"denglu"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(200), ZXSRealValueFit6SWidthPt(100)) target:self action:@selector(loginButtonDidClick:)];
        [self.view addSubview:loginButton];
        _loginButton = loginButton;
    }
    return _loginButton;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    self.userItem = [ChristmasUserItem shareChristmasUserItem];
    self.isLogining = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
#pragma mark - 自定义方法
- (void)setupUI {
    self.screenWidth = ZXSSCREEN_WIDTH;
    self.screenHeight = ZXSSCREEN_HEIGHT;
    self.backgroundImageView.origin = CGPointMake(0, 0);
    self.backButton.right = self.screenWidth * 0.5 - ZXSRealValueFit6SWidthPt(40);
    self.backButton.top = ZXSRealValueFit6SWidthPt(976);
    self.loginButton.left = self.screenWidth * 0.5 + ZXSRealValueFit6SWidthPt(40);
    self.loginButton.top = self.backButton.top;
}
#pragma mark - 触发事件
- (void)backButtonDidClick {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)loginButtonDidClick:(UIButton *)button {
    button.enabled = NO;
    if (self.isLogining) return;
    //发送网络请求
    [self sendLoginRequest];
}
- (void)sendLoginRequest {
    self.isLogining = YES;
    // 判断用户是否授权
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    }
    if (![[[ZXSUtil shareUtil]getcurrentStatus] isEqualToString:@"NotNet"]) {
        __weak typeof(self) weakSelf = self;
        MBProgressHUD *HUD = [MBProgressHUD showMessage:@"正在登录" toView:self.navigationController.view];
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                NSLog(@"uid=%@",user.uid);
                NSLog(@"%@",user.credential);
                NSLog(@"token=%@",user.credential.token);
                NSLog(@"nickname=%@",user.nickname);
                NSLog(@"icon=%@",user.icon);
                //保存头像
                weakSelf.userItem.icon = user.icon;
                //发起登录请求
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                parameters[@"login_type"] = @"weixin";
                parameters[@"access_token"] = user.credential.token;
                parameters[@"openid"] = user.uid;
                [[ZXSNetworkTool sharedNetworkTool] POST:[NSString stringWithFormat:@"%@/Tantou/Activity/login",ZXSBasicURL] parameters:parameters success:^(id responseObject){
                    [HUD removeFromSuperview];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    NSLog(@"weixinButtonDidClickdict:%@",dict);
                    NSLog(@"weixinButtonDidClickmsg:%@",dict[@"msg"]);
                    NSNumber *status = [dict objectForKey:@"status"];
                    if ([status intValue] == 1) { //登录成功
                        weakSelf.userItem = [ChristmasUserItem mj_objectWithKeyValues:dict[@"result"]];
                        NSLog(@"loginButtonDidClick %@",self.userItem);
                        //将用户数据偏好存储
                        [weakSelf.userItem saveUserItemToUserDefaults];
                        //跳转到圣诞活动首页
                        [MBProgressHUD showSuccess:@"登录成功" toView:weakSelf.view];
                        [weakSelf.navigationController pushViewController:[[ChristmasHomeViewController alloc] init] animated:YES];
                       
                    } else { //登录失败
                        [MBProgressHUD showError:dict[@"msg"] toView:weakSelf.view];
                        return;
                    }
                } failure:^(NSError *error) {
                    [HUD removeFromSuperview];
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:weakSelf.view];
                    return;
                }];
            } else {
                NSLog(@"weixinButtonDidClickmsg:%@",error);
                [HUD removeFromSuperview];
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:weakSelf.view];
                return;
            }
             self.isLogining = NO;
        }];
        
    }else{
        [MBProgressHUD showError:@"网络未连接" toView:self.view];
        return;
    }
}
@end
