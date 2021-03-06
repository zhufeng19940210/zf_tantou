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
#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate ()<GDTSplashAdDelegate,WXApiDelegate,UIAlertViewDelegate>
/**是否是第一次运行*/
@property (assign, nonatomic) BOOL isFirstRun; // yes是,no不是
//广告控件
@property (strong, nonatomic) GDTSplashAd *splash;
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //集成分享
    [self setupShareSDK];
    //设置状态栏的样式
    application.statusBarStyle = UIStatusBarStyleLightContent;
    //程序启动完后显示状态栏
    application.statusBarHidden = NO;
    // 判断用户是否是第一次使用app
    self.isFirstRun = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstRun"];
    if (!self.isFirstRun) {//第一次使用软件
        UIViewController *rootVc = [[WelcomeViewController alloc] init];
        self.window.rootViewController = rootVc;
        [self.window makeKeyAndVisible];
    } else { // 平时使用
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        ZFNavigtionController *nav = [[ZFNavigtionController alloc] initWithRootViewController:homeVC];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
        //启动广告页面了
        [self setupGuangGao];
    }
    //这里开始去检测版本
    [self setupVersion];
    return YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}
-(void)applicationDidEnterBackground:(UIApplication *)application {
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
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
    NSString *networkStatus = [[ZXSUtil shareUtil] getcurrentStatus];
    if ([networkStatus isEqualToString:@"NotNet"]) {
        [MBProgressHUD showError:@"网络未连接"];
        return;
    }
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
}
/**
 *  开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error{
    NSLog(@"开屏广告展示失败< == >splashAdFailToPresent");
    [[NSNotificationCenter defaultCenter]postNotificationName:ZF_Alter_HuoDong object:nil];
}
/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd{
}
/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd{
}
/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd{
    NSLog(@"点击以后全屏广告页已经关闭 <==> splashAdDidDismissFullScreenModal");
    [[NSNotificationCenter defaultCenter]postNotificationName:ZF_Alter_HuoDong object:nil];
}
/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd{
    NSLog(@"点击以后全屏广告页已经关闭 <==> splashAdDidDismissFullScreenModal");
    [[NSNotificationCenter defaultCenter]postNotificationName:ZF_Alter_HuoDong object:nil];
}
/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd{

}
/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd{

}
/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd{
    NSLog(@"点击以后全屏广告页将要关闭 <==> splashAdWillDismissFullScreenModal");
    [[NSNotificationCenter defaultCenter]postNotificationName:ZF_Alter_HuoDong object:nil];
}
/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd{
    NSLog(@"点击以后全屏广告页已经关闭 <==> splashAdDidDismissFullScreenModal");
    [[NSNotificationCenter defaultCenter]postNotificationName:ZF_Alter_HuoDong object:nil];
}
/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time{
    NSLog(@"开屏广告剩余时间回调<==>splashAdLifeTime");
    self.splash = nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:ZF_Alter_HuoDong object:nil];
}
#pragma mark 支付的回调方法
#pragma mark - 这里是回调的方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"openurl1 = %@" , url);
    //1.支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result1 = %@",resultDic);
            NSString *resultStatus =  [resultDic objectForKey:@"resultStatus"];
            if ([resultStatus isEqualToString: @"9000"]) {
                [MBProgressHUD showSuccess:@"订单支付成功"];
            }else if([resultStatus isEqualToString:@"8000"]) {
                [MBProgressHUD showSuccess:@"支付结果确认中"];
            }else{
                [MBProgressHUD showError:@"订单未支付"];
            }
        }];
    }
    //2.微信
    return  [WXApi handleOpenURL:url delegate:self];
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"openurl2 = %@" , url);
    //1.支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result2 = %@",resultDic);
            //支付宝回调在这里处理...
            NSString *resultStatus =  [resultDic objectForKey:@"resultStatus"];
            if ([resultStatus isEqualToString: @"9000"]) {
                [MBProgressHUD showSuccess:@"订单支付成功"];
            }else if([resultStatus isEqualToString:@"8000"]) {
                [MBProgressHUD showSuccess:@"支付结果确认中"];
            }else{
                [MBProgressHUD showError:@"订单未支付"];
            }
        }];
    }
    //2.微信
    return  [WXApi handleOpenURL:url delegate:self];
}
//更新版本的代码
-(void)setupVersion
{
    __weak AppDelegate *weakSelf = self;
    [[ZXSNetworkTool sharedNetworkTool]POST:@"http://itunes.apple.com/cn/lookup?id=1270665960" parameters:nil success:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict:%@",dict);
        //获取版本号与对应的下载链接
        NSArray * results = dict[@"results"];
        for (NSDictionary * dict in results) {
            weakSelf.appStoreVersion = dict[@"version"];
            NSLog(@"self.appStoreVersion:%@",weakSelf.appStoreVersion);
            weakSelf.urlStr = dict[@"trackViewUrl"];
            NSLog(@"self.urlStr:%@",weakSelf.urlStr);
            }
            weakSelf.localVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSLog(@"self.localVersion:%@",weakSelf.localVersion );
            weakSelf.type = [self checkVersion:weakSelf.localVersion isNewThanVersion:self.appStoreVersion];
            NSLog(@"self.type:%lu",(unsigned long)weakSelf.type);
            NSString * message = nil;
            if ( weakSelf.type == LocolVersionToAppStoreVersionEqual) {
                //当前是最新版本
                message = @"当前是最新版本";
            }
            else if (weakSelf.type == LocolVersionToAppStoreVersionSmall)
            {
                NSLog(@"更新版本");
                message = [NSString stringWithFormat:@"请点击更新最新版本:%@",self.appStoreVersion];
                UIAlertView *alterVC = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alterVC show];
            }
    } failure:^(NSError *error) {
    }];
}
#pragma mark - uialterViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlStr]];
    }
}
/**
 *  比较版本号的大小
 *  @param localVersion 当前版本号
 *  @param appSroreVersion appStore版本号
 *  @return appStore版本号与当前版本号大小关系
 *   当前版本号（用户为用户版本号，审核为Xcode开发版本号）
 appStore版本号是 大于或等于 当前版本号 显示更新
 */
- (CompareVersionType)checkVersion:(NSString *)localVersion isNewThanVersion:(NSString *)appSroreVersion{
    CompareVersionType compareVersion ;
    NSArray * locol = [localVersion componentsSeparatedByString:@"."];
    NSArray * appStore = [appSroreVersion componentsSeparatedByString:@"."];
    for (NSUInteger i = 0; i<locol.count; i++) {
        NSInteger locolV = [[locol objectAtIndex:i] integerValue];
        NSInteger appStoreV = appStore.count > i ? [[appStore objectAtIndex:i] integerValue] : 0;
        if (locolV > appStoreV) {
            compareVersion =  LocolVersionToAppStoreVersionLarge;
            return  compareVersion;
        }
        else if (locolV < appStoreV) {
            compareVersion =  LocolVersionToAppStoreVersionSmall;
            return compareVersion;
        }
        else if(i == locol.count - 1)
        {
            if (locolV == appStoreV) {
                compareVersion = LocolVersionToAppStoreVersionEqual;
                return compareVersion;
            }
        }
    }
    return compareVersion;
}
@end
