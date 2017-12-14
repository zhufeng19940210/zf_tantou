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
    self.navigationItem.title=@"好友推荐";
    [self createUI];
}
-(void)createUI
{
    self.tantouview = [[UIImageView alloc]init];
    self.tantouview.frame = CGRectMake(0, 0, ZXSSCREEN_WIDTH, ZXSSCREEN_HEIGHT);
    self.tantouview.image = [UIImage imageNamed:@"好友推荐"];
    [self.view addSubview:self.tantouview];
    self.weixinbtn = [[UIButton alloc]init];
    self.weixinbtn.size = CGSizeMake(180*REDIO, 180*REDIO);
    self.weixinbtn.left = 70*REDIO;
    self.weixinbtn.bottom = ZXSSCREEN_HEIGHT - 250*REDIO;
    [self.weixinbtn setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [self.weixinbtn addTarget:self action:@selector(weixinbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.weixinbtn];
    
    self.pengyouquanbtn= [[UIButton alloc]init];
    self.pengyouquanbtn.size = CGSizeMake(180*REDIO, 180*REDIO);
    self.pengyouquanbtn.left = self.weixinbtn.right + 80*REDIO;
    self.pengyouquanbtn.bottom = ZXSSCREEN_HEIGHT - 250*REDIO;
    [self.pengyouquanbtn setBackgroundImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
    [self.pengyouquanbtn addTarget:self action:@selector(pengyouquanbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pengyouquanbtn];
    
    self.qqbtn = [[UIButton alloc]init];
    self.qqbtn.size = CGSizeMake(180*REDIO, 180*REDIO);
    self.qqbtn.left = self.pengyouquanbtn.right + 80*REDIO;
    self.qqbtn.bottom = ZXSSCREEN_HEIGHT - 250*REDIO;
    [self.qqbtn setBackgroundImage:[UIImage imageNamed:@"qq-3"] forState:UIControlStateNormal];
    [self.qqbtn addTarget:self action:@selector(qqbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.qqbtn];
    
    self.weibobtn= [[UIButton alloc]init];
    self.weibobtn.size = CGSizeMake(180*REDIO, 180*REDIO);
    self.weibobtn.left = self.qqbtn.right + 80*REDIO;
    self.weibobtn.bottom = ZXSSCREEN_HEIGHT - 250*REDIO;
    [self.weibobtn setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    [self.weibobtn addTarget:self action:@selector(weibobtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.weibobtn];
}

-(void)weixinbtnAction:(UIButton *)sender{
    
    self.shareType =SSDKPlatformSubTypeWechatSession;
    [self myRealShareWithtag];
    
}
-(void)pengyouquanbtn:(UIButton *)sender{
    
   self.shareType = SSDKPlatformSubTypeWechatTimeline;
    [self myRealShareWithtag];
}
-(void)qqbtnAction:(UIButton *)sender{
 
    self.shareType = SSDKPlatformTypeQQ;
    [self myRealShareWithtag];
}
-(void)weibobtnAction:(UIButton *)sender{
    
    self.shareType = SSDKPlatformTypeSinaWeibo;
     NSString *url = @"https://www.daodianwang.com/App/download-tantou.php";
     NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:@"对焦食物，一探究竟！" title:@"探头" image:[UIImage imageNamed:@"testshare.png"] url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    
    [ShareSDK share:self.shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
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
            case SSDKResponseStateCancel:{
                
                [MBProgressHUD showError:@"分享取消"];
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
          
                [MBProgressHUD showSuccess:@"分享成功"];
            }
                break;
            case SSDKResponseStateFail:
            {
                [MBProgressHUD showError:@"分享失败"];
            }
                break;
            case SSDKResponseStateCancel:{
            
                [MBProgressHUD showError:@"分享取消"];
            }
            default:
                break;
        }
    }];
}

@end
