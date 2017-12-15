//
//  ChristmasHomeViewController.m
//  TanTou
//
//  Created by StoneMan on 2017/11/15.
//  Copyright © 2017年 bailing. All rights reserved.
//
#import "ChristmasHomeViewController.h"
#import "ChristmasAnswerViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ZFCustomAlterView.h"
@interface ChristmasHomeViewController () <ZFCustomAlterViewDelegate>
//背景
@property (weak, nonatomic) UIImageView *backgroundImageView;
//返回
@property (weak, nonatomic) UIButton *backButton;
//红包
@property (weak, nonatomic) UIButton *redPacketButton;
//挑战ImageView
@property (weak, nonatomic) UIImageView *challengeImageView;
//countLabel
@property (weak, nonatomic) UILabel *countLabel;
//分享活动
@property (weak, nonatomic) UIButton *shareActivityButton;
//马上开始
@property (weak, nonatomic) UIButton *startAnswerButton;
//tantouRedPacketView
@property (weak, nonatomic) UIView *tantouRedPacketView;
//moneyLabel
@property (weak, nonatomic) UILabel *moneyLabel;
/**screenWidth*/
@property (assign, nonatomic) CGFloat screenWidth;
/**screenHeight*/
@property (assign, nonatomic) CGFloat screenHeight;
/**用户*/
@property (weak, nonatomic) ChristmasUserItem *userItem;
/*新加的一个东西了*/
@property (weak,nonatomic) UIButton *tomorrowBtn;
/*alterView*/
@property (nonatomic,strong)ZFCustomAlterView *alterView;
@end
@implementation ChristmasHomeViewController
-(ZFCustomAlterView *)alterView{
    if (!_alterView) {
        _alterView = [[ZFCustomAlterView alloc]init];
        _alterView.delegate = self;
    }
    return _alterView;
}
#pragma mark - 懒加载
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [self.view addSubview:backgroundImageView];
        _backgroundImageView = backgroundImageView;
        backgroundImageView.image = [UIImage imageNamed:@"gai"];
        backgroundImageView.bounds = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    }
    return _backgroundImageView;
}
- (UIButton *)tomorrowBtn {
    if (!_tomorrowBtn) {
        
        UIButton *tomorrowBtn = [UIButton zxs_buttonWithBackGroundImage:[UIImage imageNamed:@"xuanxiangzz"] highlightedBackGroundImage:[UIImage imageNamed:@"xuanxiangz"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(312), ZXSRealValueFit6SWidthPt(88)) titleColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] titleFont:ZXSSystemFontFit6WithPt(28.f) target:self action:@selector(TomoorowButtonDidClick) title:@"明天再来"];
        tomorrowBtn.hidden = YES;
        [self.view addSubview:tomorrowBtn];
        _tomorrowBtn = tomorrowBtn;
    }
    return _tomorrowBtn;
}
- (UIButton *)backButton {
    if (!_backButton) {
        UIButton *backButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"fanhui-1"] highlightedImage:[UIImage imageNamed:@"fanhui-1"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(70), ZXSRealValueFit6SWidthPt(74)) target:self action:@selector(backButtonDidClick)];
        [self.view addSubview:backButton];
        _backButton = backButton;
    }
    return _backButton;
}
- (UIButton *)redPacketButton {
    if (!_redPacketButton) {
        
        UIButton *redPacketButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"hongbao"] highlightedImage:[UIImage imageNamed:@"hongbao"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(72), ZXSRealValueFit6SWidthPt(88)) target:self action:@selector(redPacketButtonDidClick)];
        [self.view addSubview:redPacketButton];
        _redPacketButton = redPacketButton;
    }
    return _redPacketButton;
}
-(UIImageView *)challengeImageView {
    if (!_challengeImageView) {
        UIImageView *challengeImageView = [UIImageView zxs_imageViewWithImage:[UIImage imageNamed:@"tiaozhan-1"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(76), ZXSRealValueFit6SWidthPt(34))];
        [self.view addSubview:challengeImageView];
        _challengeImageView = challengeImageView;
    }
    return _challengeImageView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        UILabel *countLabel = [UILabel zxs_labelWithTextColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] font:ZXSSystemFontFit6WithPt(20.f) text:@"3"];
        [self.view addSubview:countLabel];
        _countLabel = countLabel;
        countLabel.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(40), ZXSRealValueFit6SWidthPt(24));
        countLabel.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:119 / 255.0 blue:121 / 255.0 alpha:1.0];
        countLabel.layer.cornerRadius = ZXSRealValueFit6SWidthPt(15);
        countLabel.layer.masksToBounds = YES;
    }
    return _countLabel;
}

- (UIButton *)shareActivityButton {
    if (!_shareActivityButton) {
        
        UIButton *shareActivityButton = [UIButton zxs_buttonWithBackGroundImage:[UIImage imageNamed:@"xuanxiangzz"] highlightedBackGroundImage:[UIImage imageNamed:@"xuanxiangz"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(312), ZXSRealValueFit6SWidthPt(88)) titleColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] titleFont:ZXSSystemFontFit6WithPt(28.f) target:self action:@selector(shareActivityButtonDidClick) title:@"分享活动"];
        [self.view addSubview:shareActivityButton];
        _shareActivityButton = shareActivityButton;
    }
    return _shareActivityButton;
}

- (UIButton *)startAnswerButton {
    if (!_startAnswerButton) {
        
        UIButton *startAnswerButton = [UIButton zxs_buttonWithBackGroundImage:[UIImage imageNamed:@"xuanxiangzz"] highlightedBackGroundImage:[UIImage imageNamed:@"xuanxiangz"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(312), ZXSRealValueFit6SWidthPt(88)) titleColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] titleFont:ZXSSystemFontFit6WithPt(28.f) target:self action:@selector(startAnswerButtonDidClick:) title:@"马上开始"];
        [self.view addSubview:startAnswerButton];
        _startAnswerButton = startAnswerButton;
    }
    return _startAnswerButton;
}
- (UIView *)tantouRedPacketView {
    if (!_tantouRedPacketView) {
        UIView *tantouRedPacketView = [[UIView alloc] init];
        [self.view addSubview:tantouRedPacketView];
        _tantouRedPacketView = tantouRedPacketView;
        tantouRedPacketView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(648));
        tantouRedPacketView.hidden = YES;
        //背景图片
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [tantouRedPacketView addSubview:backgroundImageView];
        backgroundImageView.image = [UIImage imageNamed:@"ttqianbaoz"];
        backgroundImageView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(528));
        backgroundImageView.origin = CGPointMake(0, 0);
        //moneyLabel
        UILabel *moneyLabel = [UILabel zxs_labelWithTextColor:[UIColor colorWithRed:1.0 green:103 / 255.0 blue:103 / 255.0 alpha:1.0] font:ZXSSystemFontFit6WithPt(80.f) text:@"0.00"];
        [tantouRedPacketView addSubview:moneyLabel];
        _moneyLabel = moneyLabel;
        moneyLabel.top = ZXSRealValueFit6SWidthPt(170);
        moneyLabel.right = tantouRedPacketView.width - ZXSRealValueFit6SWidthPt(110);
        //提现按钮
        UIButton *cashButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"tixian"] highlightedImage:[UIImage imageNamed:@"tixian"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(210), ZXSRealValueFit6SWidthPt(76)) target:self action:@selector(cashButtonDidClick)];
        [tantouRedPacketView addSubview:cashButton];
        cashButton.centerX = tantouRedPacketView.width * 0.5;
        cashButton.bottom = CGRectGetMaxY(backgroundImageView.frame) - ZXSRealValueFit6SWidthPt(60);
        //关闭按钮
        UIButton *closeButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"chacha"] highlightedImage:[UIImage imageNamed:@"chacha"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(80), ZXSRealValueFit6SWidthPt(80)) target:self action:@selector(closeButtonDidClick)];
        [tantouRedPacketView addSubview:closeButton];
        closeButton.centerX = tantouRedPacketView.width * 0.5;
        closeButton.bottom = tantouRedPacketView.height;
    }
    return _tantouRedPacketView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self loadUserInfoFromServer];
    [self.userItem userItemFromUserDefaults];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    //获取用户数据
    self.userItem = [ChristmasUserItem shareChristmasUserItem];
    [self.userItem userItemFromUserDefaults];
}
#pragma mark - 自定义
- (void)setupUI {
    self.screenWidth = ZXSSCREEN_WIDTH;
    self.screenHeight = ZXSSCREEN_HEIGHT;
    self.backgroundImageView.origin = CGPointMake(0, 0);
    self.backButton.origin = CGPointMake(ZXSRealValueFit6SWidthPt(40), ZXSRealValueFit6SWidthPt(40));//20,20
    self.redPacketButton.top = ZXSRealValueFit6SWidthPt(30);//16
    self.redPacketButton.right = self.screenWidth - ZXSRealValueFit6SWidthPt(40);//20
    self.startAnswerButton.centerX = self.screenWidth * 0.5;
    self.startAnswerButton.bottom = self.screenHeight - ZXSRealValueFit6SWidthPt(100);
    self.tomorrowBtn.centerX = self.screenWidth * 0.5;
    self.tomorrowBtn.bottom = self.screenHeight - ZXSRealValueFit6SWidthPt(100);
    self.shareActivityButton.centerX = self.startAnswerButton.centerX;
    self.shareActivityButton.bottom = self.startAnswerButton.top - ZXSRealValueFit6SWidthPt(20);
    self.tantouRedPacketView.center = CGPointMake(self.screenWidth * 0.5, self.screenHeight * 0.5);
    self.challengeImageView.top = ZXSRealValueFit6SWidthPt(60);
    self.challengeImageView.right = self.redPacketButton.left - ZXSRealValueFit6SWidthPt(80);
    self.countLabel.left = self.challengeImageView.right - ZXSRealValueFit6SWidthPt(10);
    self.countLabel.bottom = self.challengeImageView.top + ZXSRealValueFit6SWidthPt(10);
}
- (void)userMobShareSDKForShareImage:(UIImage *)shareImage {
     __weak typeof(self) weakSelf = self;
    //1、创建分享参数
    NSArray *imageArray = @[shareImage];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];//[NSURL URLWithString:@"http://mob.com"]
        [shareParams SSDKSetupShareParamsByText:@"猜美食，赢现金红包——探头APP\n黑科技助力食物属性一拍即成\n扫码下载探头，一款晒美食也能赚钱的APP" images:imageArray url:nil title:@"探头圣诞抢红包活动来啦" type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //showShareActionSheet:要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
            switch (state) {
                case SSDKResponseStateSuccess: {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    //通知服务器发送分享成功信息请求
                    [weakSelf sendShareActivityRequestToServer];
                    break;
                }
                case SSDKResponseStateFail: {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}
//分享的次数
- (void)sendShareActivityRequestToServer {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.userItem.uid;
    parameters[@"token"] = self.userItem.token;
    __weak typeof(self) weakSelf = self;
    [[ZXSNetworkTool sharedNetworkTool] POST:[NSString stringWithFormat:@"%@/Tantou/Activity/shareCount",ZXSBasicURL] parameters:parameters success:^(id responseObject) {
        //解析json数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"shareActivityButtonDidClickdict:%@",dict);
        NSLog(@"shareActivityButtonDidClickmsg:%@",dict[@"msg"]);
        NSNumber *status = [dict objectForKey:@"status"];
        if ([status intValue] == 1) { //操作成功
            [weakSelf loadUserInfoFromServer];
        } else { //操作失败
            [MBProgressHUD showError:dict[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:weakSelf.view];
    }];
}
//提现
- (void)sendCashMoneyRequestToServer {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.userItem.uid;
    parameters[@"token"] = self.userItem.token;
    __weak typeof(self) weakSelf = self;
    [[ZXSNetworkTool sharedNetworkTool] POST:[NSString stringWithFormat:@"%@/Tantou/Activity/wdDeposit",ZXSBasicURL] parameters:parameters success:^(id responseObject) {
        //解析json数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"sendCashMoneyRequestToServerdict:%@",dict);
        NSLog(@"sendCashMoneyRequestToServermsg:%@",dict[@"msg"]);
        NSNumber *status = [dict objectForKey:@"status"];
        if ([status intValue] == 1) { //操作成功
            weakSelf.userItem.money = @"0.00";
            //保存新数据
            [weakSelf.userItem saveUserItemToUserDefaults];
            [MBProgressHUD showSuccess:@"提现成功" toView:weakSelf.view];
            self.moneyLabel.text = @"0.00";
        } else { //操作失败
            [MBProgressHUD showError:dict[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:weakSelf.view];
    }];
}
//用户信息从服务器
- (void)loadUserInfoFromServer {
    NSString *networkStatus = [[ZXSUtil shareUtil] getcurrentStatus];
    if ([networkStatus isEqualToString:@"NotNet"]) {
        [MBProgressHUD showError:@"网络未连接"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.userItem.uid;
    parameters[@"token"] = self.userItem.token;
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ZXSNetworkTool sharedNetworkTool] POST:[NSString stringWithFormat:@"%@/Tantou/Activity/achieve",ZXSBasicURL] parameters:parameters success:^(id responseObject) {
        //解析json数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"dict:%@",dict);
        NSLog(@"loadUserInfoFromServerdict:%@",dict);
        NSLog(@"loadUserInfoFromServermsg:%@",dict[@"msg"]);
        NSNumber *status = [dict objectForKey:@"status"];
        if ([status intValue] == 1) { //操作成功
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *resultDict = dict[@"result"];
            weakSelf.userItem.add_time = resultDict[@"add_time"];
            weakSelf.userItem.can_challenge = resultDict[@"can_challenge"];
            weakSelf.userItem.login_type = resultDict[@"login_type"];
            weakSelf.userItem.openid = resultDict[@"openid"];
            weakSelf.userItem.today_time = resultDict[@"today_time"];
            weakSelf.userItem.token = resultDict[@"token"];
            weakSelf.userItem.uid = resultDict[@"uid"];
            weakSelf.userItem.username = resultDict[@"username"];
            weakSelf.userItem.money = resultDict[@"money"];
            weakSelf.userItem.today_times = resultDict[@"today_times"];
            weakSelf.userItem.challenge_times = resultDict[@"challenge_times"];
            weakSelf.userItem.share_times = resultDict[@"share_times"];
            weakSelf.userItem.last_money = resultDict[@"last_money"];
            //保存新数据
            [weakSelf.userItem saveUserItemToUserDefaults];
            weakSelf.moneyLabel.text = weakSelf.userItem.money;
            NSUInteger challengeCount = [weakSelf.userItem.today_times intValue] + [weakSelf.userItem.challenge_times intValue];
            NSLog(@"challengeCount:%lu",(unsigned long)challengeCount);
            weakSelf.countLabel.text = [NSString stringWithFormat:@"%zd",challengeCount];
            NSLog(@"Serverresultlast_money%@",resultDict[@"last_money"]);
            int can_challenge = [resultDict[@"can_challenge"] intValue];
            NSString *challenge_times  = resultDict[@"challenge_times"];
            NSString *share_time = resultDict[@"share_times"];
            NSLog(@"是否可以答题:%d",can_challenge);
            NSLog(@"挑战的次数:%@",challenge_times);
            NSLog(@"分享的次数:%@",share_time);
            //can_challenge: 1 是可以答题 0 是不能可以答题
            //challenge_times 挑战的次数
            //share_time  分享的次数
            if (challengeCount == 0 || [share_time isEqualToString:@"3"]) {
                // 总的次数为空
                self.startAnswerButton.hidden = YES;
                self.tomorrowBtn.hidden = NO;
            }else{
                if (can_challenge == 1) {
                    self.startAnswerButton.hidden = NO;
                    self.tomorrowBtn.hidden = YES;
                }
            }
        } else { //操作失败
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:dict[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:weakSelf.view];
    }];
}
#pragma mark - 触发事件
- (void)backButtonDidClick {
    // 退出当前控制器
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)redPacketButtonDidClick {
    self.tantouRedPacketView.hidden = NO;
    [self.alterView showShareViewAddView:self.tantouRedPacketView];
}
- (void)shareActivityButtonDidClick {
    [self userMobShareSDKForShareImage:[UIImage imageNamed:@"share.png"]];
}
#pragma mark -明天再来
-(void)TomoorowButtonDidClick{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)startAnswerButtonDidClick:(UIButton *)button {
    // 退出当前控制器
    ChristmasAnswerViewController *answerVc = [[ChristmasAnswerViewController alloc]init];
    [self.navigationController pushViewController:answerVc animated:YES];
}
- (void)cashButtonDidClick {
    [self sendCashMoneyRequestToServer];
}
#pragma mark --ZFCustomAlterViewDelegate
-(void)customAlterViewHidden{
    [self hiddenOtherView];
}
-(void)hiddenOtherView{
    self.tantouRedPacketView.hidden = YES;
    [self.alterView hihhdenView];
}
- (void)closeButtonDidClick {
    [self hiddenOtherView];
}
@end
