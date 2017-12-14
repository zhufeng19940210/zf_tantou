//
//  AppDelegate.m
//  TanTou
//
//  Created by bailing on 2017/8/10.
//  Copyright © 2017年 bailing. All rights reserved.
//
#import "AppDelegate.h"
//广告
#import "GDTSplashAd.h"
#import "GDTTrack.h"
//Mob平台下ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "WelcomeViewController.h"
#import "HomeViewController.h"
#import "ZFNavigtionController.h"
@interface AppDelegate ()<GDTSplashAdDelegate,WXApiDelegate>
/**是否是第一次运行*/
@property (assign, nonatomic) BOOL isFirstRun; // yes是,no不是
//广告控件
@property (strong, nonatomic) GDTSplashAd *splash;
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //集成分享
    [self setupShareSDK];
    self.window = [[UIWindow alloc] initWithFrame:ZXSSCREEN_BOUNDS];
    UIViewController *rootVC = nil;
    //设置状态栏的样式
    application.statusBarStyle = UIStatusBarStyleLightContent;
    //程序启动完后显示状态栏
    application.statusBarHidden = NO;
    // 判断用户是否是第一次使用app
    self.isFirstRun = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstRun"];
    if (!self.isFirstRun) {//第一次使用软件
        rootVC = [[WelcomeViewController alloc] init];
    } else { // 平时使用
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        ZFNavigtionController *nav = [[ZFNavigtionController alloc] initWithRootViewController:homeVC];
        rootVC = nav;
        self.homeVC = homeVC;
    }
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    //self.homeVC.coverView.hidden = NO;
    //self.homeVC.shengdanhuodongView.hidden = NO;
    [self setupGuangGao];
    return YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isEnterForeground"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"applicationWillEnterForeground");
    //self.homeVC.coverView.hidden = NO;
    //self.homeVC.shengdanhuodongView.hidden = NO;
}
-(void)applicationDidEnterBackground:(UIApplication *)application {
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isEnterForeground"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"applicationDidEnterBackground");
    //self.homeVC.coverView.hidden = YES;
    //self.homeVC.shengdanhuodongView.hidden = YES;
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [GDTTrack activateApp];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isEnterForeground"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"applicationDidBecomeActive");
    //self.homeVC.coverView.hidden = NO;
    //self.homeVC.shengdanhuodongView.hidden = NO;
}
#pragma mark - 自定义方法
//初始化ShareSDK应用
- (void)setupShareSDK {
    /**初始化ShareSDK应用
     @param activePlatforms
     使用的分享平台集合
     @param importHandler (onImport)
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     @param configurationHandler (onConfiguration)
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeSinaWeibo)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:ZXSWXAppID appSecret:ZXSWXAppSerect];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:ZXSQQAppID appKey:ZXSQQAppKey authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                //http://www.sharesdk.cn
                //https://www.daodianwang.com/App/download-tantou.php
                [appInfo SSDKSetupSinaWeiboByAppKey:ZXSSinaWeiboAppKey appSecret:ZXSSinaWeiboAppSerect redirectUri:@"http://www.sharesdk.cn" authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}
- (void)setupGuangGao {
    //开屏广告初始化并展示代码
    GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppkey:@"1106337035" placementId:@"8060621589607712"];
    splash.delegate = self; //设置代理 //根据iPhone设备不同设置不同背景图
    if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
        splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568h"]];
    } else {
        splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage"]];
    }
    splash.fetchDelay = 3; //开发者可以设置开屏拉取时间，超时则放弃展示 //[可选]拉取并展示全屏开屏广告
    [splash loadAdAndShowInWindow:self.window];
    self.splash = splash;
}

#pragma mark - GDTSplashAdDelegate
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    NSLog(@"%s%@",__FUNCTION__,error);
}

- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClosed:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
    _splash = nil;
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}


@end
