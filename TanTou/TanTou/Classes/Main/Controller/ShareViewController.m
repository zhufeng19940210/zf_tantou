//
//  ShareViewController.m
//  The  probe
//
//  Created by Sharon on 2017/8/8.
//  Copyright © 2017年 daodian. All rights reserved.
//分享页面

#import "ShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
@interface ShareViewController ()
@property(nonatomic,strong)UIImageView*tantouview;
@property(nonatomic,strong)UIImageView*titleview;
@property(nonatomic,strong)UIButton*weixinbtn;
@property(nonatomic,strong)UIButton*pengyouquanbtn;
@property(nonatomic,strong)UIButton*qqbtn;
@property(nonatomic,strong)UIButton*weibobtn;
@property(nonatomic,assign)int shareType;
@end
@implementation ShareViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"好友推荐";
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
//weixin
- (IBAction)onClickWenxinBtn:(UIButton *)sender {
    self.shareType =SSDKPlatformSubTypeWechatSession;
    [self myRealShareWithtag];
}
//朋友圈
- (IBAction)onClickPengyouquanBtn:(UIButton *)sender {
    self.shareType = SSDKPlatformSubTypeWechatTimeline;
    [self myRealShareWithtag];
}
//QQ
- (IBAction)onClickQQBtn:(UIButton *)sender {
    self.shareType = SSDKPlatformTypeQQ;
    [self myRealShareWithtag];
}
//微博
- (IBAction)onClickWeiboBtn:(UIButton *)sender {
    self.shareType = SSDKPlatformTypeSinaWeibo;
    NSString *url = @"https://www.daodianwang.com/App/download-tantou.php";
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:@"对焦食物，一探究竟！" title:@"探头" image:[UIImage imageNamed:@"testshare.png"] url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    
    [ShareSDK share:self.shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                
                [MBProgressHUD showSuccess:@"分享成功" toView:self.view];
            }
                break;
            case SSDKResponseStateFail:
            {
                [MBProgressHUD showError:@"分享失败" toView:self.view];
            }
                break;
            case SSDKResponseStateCancel:{
                
                [MBProgressHUD showError:@"分享取消" toView:self.view];
            }
            default:
                break;
        }
    }];
}
-(void)myRealShareWithtag{
//创建一个分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"testshare.png"]];
    NSString *title = @"对焦食物，一探究竟!";
    NSString *text  = @"探头App下载链接";
    NSString *url = @"https://www.daodianwang.com/App/download-tantou.php";
    
    [shareParams SSDKSetupShareParamsByText: text images:imageArray url:[NSURL URLWithString: url] title:title type:SSDKContentTypeAuto];
    [ShareSDK share:self.shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [MBProgressHUD showSuccess:@"分享成功" toView:self.view];
            }
                break;
            case SSDKResponseStateFail:
            {
                [MBProgressHUD showError:@"分享失败" toView:self.view];
            }
                break;
            case SSDKResponseStateCancel:{
            
                [MBProgressHUD showError:@"分享取消" toView:self.view];
            }
            default:
                break;
        }
    }];
}
@end
