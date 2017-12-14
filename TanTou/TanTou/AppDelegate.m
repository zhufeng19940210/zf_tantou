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
    self.window = [[UIWindow alloc] initWithFrame:ZXSSCREEN_BOUNDS];
    //集成分享
    [self setupShareSDK];
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
    [self setupGuangGao];
    return YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
-(void)applicationDidEnterBackground:(UIApplication *)application {

}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [GDTTrack activateApp];
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
    splash.fetchDelay = 2; //开发者可以设置开屏拉取时间，超时则放弃展示 //[可选]拉取并展示全屏开屏广告
    [splash loadAdAndShowInWindow:self.window];
    self.splash = splash;
}

#pragma mark - GDTSplashAdDelegate
/**
 *  开屏广告成功展示
 */
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
/**
 *  开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd{
    _splash = nil;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ZF_Alter_HuoDong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
