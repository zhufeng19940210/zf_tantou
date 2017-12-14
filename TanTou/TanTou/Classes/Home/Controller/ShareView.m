//
//  ShareView.m
//  TYAlertControllerDemo
//
//  Created by tanyang on 15/10/26.
//  Copyright © 2015年 tanyang. All rights reserved.
// 分享弹窗

#import "ShareView.h"
#import "UIView+TYAlertView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
@interface  ShareView()

@property (nonatomic,assign)int shareType;

@end


@implementation ShareView

- (IBAction)weiboAction:(UIButton *)sender {
    self.shareType = SSDKPlatformTypeSinaWeibo;
    [self performSelector:@selector(shareWithCurrentScreen) withObject:nil afterDelay:1.0f];
}
- (IBAction)weixinAction:(UIButton *)sender {

    self.shareType = SSDKPlatformSubTypeWechatSession;
    [self hideView];
     [self performSelector:@selector(shareWithCurrentScreen) withObject:nil afterDelay:1.0f];
}
//QQ分享按钮的事件
- (IBAction)QQbtnAction:(UIButton *)sender {
    
    self.shareType = SSDKPlatformTypeQQ;
    [self hideView];

    [self performSelector:@selector(shareWithCurrentScreen) withObject:nil afterDelay:1.0f];
//    [self shareWithCurrentScreen];
}
- (IBAction)pengyouquanAction:(UIButton *)sender {
    [self hideView];
    self.shareType = SSDKPlatformSubTypeWechatTimeline;
    [self performSelector:@selector(shareWithCurrentScreen) withObject:nil afterDelay:1.0f];}

- (IBAction)cancelAction:(id)sender {
    //通知主界面显示
    NSNotification *notice=[NSNotification notificationWithName:@"yincang" object:nil   userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    [self hideView];

}


-(void)shareWithCurrentScreen{
    //通知主界面显示
    NSNotification *notice=[NSNotification notificationWithName:@"yincang" object:nil   userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    [SSEShareHelper screenCaptureShare:^(SSDKImage *image, SSEShareHandler shareHandler) {
        if (!image)
        {
            image = [[SSDKImage alloc] initWithImage:[UIImage imageNamed:@"testshare.png"] format:SSDKImageFormatJpeg settings:nil];
        }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"你好"
                                         images:@[image]
                                            url:[NSURL URLWithString:@"https://www.daodianwang.com/App/download-tantou.php"]
                                          title:@"分享食物评分"
                                           type:SSDKContentTypeImage];
        
        if (shareHandler)
        {
            shareHandler (self.shareType, shareParams);
        }
    }
                        onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                            
                            switch (state) {
                                case SSDKResponseStateSuccess:
                                {
                                    [MBProgressHUD showSuccess:@"分享成功"];
                                }
                                    break;
                                case SSDKResponseStateFail:
                                {
                                    [MBProgressHUD showError:@"分享失败"];
                                }
                                    break;
                                case SSDKResponseStateCancel:
                                {
                                    [MBProgressHUD showError:@"分享取消"];
                                }
                                    break;
                                default:
                                    break;
                            }
            
                        }];
}

@end
