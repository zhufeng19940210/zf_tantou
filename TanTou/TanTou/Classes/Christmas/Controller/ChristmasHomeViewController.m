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
#import "ChristmasAnswerViewController.h"
#import "ChristmasEndingViewController.h"
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
//分享
@property (nonatomic,strong)UIView *zfShareView;
//确定是分享还是直接挑战了
@property (nonatomic,assign)BOOL isTiaozhan;
//又加了一个东西了
@property (nonatomic,weak)UIView *zfAlterView;
//人数过多的情况
@property (nonatomic,assign)BOOL isMorePeople;
@end
@implementation ChristmasHomeViewController
//AlterView
-(UIView *)zfAlterView{
    if (!_zfAlterView) {
        UIView *alterView = [[UIView alloc] init];
        [self.view addSubview:alterView];
        _zfAlterView = alterView;
        alterView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(528));
        alterView.hidden = YES;
        //背景图片
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [alterView addSubview:backgroundImageView];
        backgroundImageView.image = [UIImage imageNamed:@"meiqianle"];
        backgroundImageView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(528));
        backgroundImageView.origin = CGPointMake(0, 0);
        //确定按钮
        UIButton *challengeButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"queding"] highlightedImage:[UIImage imageNamed:@"queding"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(180), ZXSRealValueFit6SWidthPt(76)) target:self action:@selector(ZFQuedingButtonDidClick)];
        [alterView addSubview:challengeButton];
        challengeButton.centerX = alterView.width * 0.5;
        challengeButton.bottom = alterView.height -20;
    }
    return _zfAlterView;
}
#pragma mark - ZFQuedingButtonDidClick (隐藏其他的button的东西了)
-(void)ZFQuedingButtonDidClick{
    [self hiddenOtherView];
}
//分享View
- (UIView *)zfShareView {
    if (!_zfShareView) {
        UIView *tantouRedPacketView = [[UIView alloc] init];
        [self.view addSubview:tantouRedPacketView];
        _zfShareView = tantouRedPacketView;
        tantouRedPacketView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(528));
        tantouRedPacketView.hidden = YES;
        //背景图片
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [tantouRedPacketView addSubview:backgroundImageView];
        backgroundImageView.image = [UIImage imageNamed:@"fenxiangz"];
        backgroundImageView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(528));
        backgroundImageView.origin = CGPointMake(0, 0);
        //取消按钮
        UIButton *challengeButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"quxiao"] highlightedImage:[UIImage imageNamed:@"quxiao"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(180), ZXSRealValueFit6SWidthPt(76)) target:self action:@selector(CancelButtonDidClick)];
        [tantouRedPacketView addSubview:challengeButton];
        challengeButton.right = tantouRedPacketView.width * 0.5 - ZXSRealValueFit6SWidthPt(30);
        challengeButton.bottom = CGRectGetMaxY(backgroundImageView.frame) - ZXSRealValueFit6SWidthPt(60);
        //分享按钮
        UIButton *cancelButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"fenxiang"] highlightedImage:[UIImage imageNamed:@"fenxiang"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(180), ZXSRealValueFit6SWidthPt(76)) target:self action:@selector(ShareButtonDidClick)];
        [tantouRedPacketView addSubview:cancelButton];
        cancelButton.left = tantouRedPacketView.width * 0.5 + ZXSRealValueFit6SWidthPt(30);
        cancelButton.bottom = challengeButton.bottom;
    }
    return _zfShareView;
}
#pragma mark CancelButtonDidClick
-(void)CancelButtonDidClick{
    [self hiddenOtherView];
}
#pragma mark - ShareButtonDidClick
-(void)ShareButtonDidClick{
    [self hiddenOtherView];
    [self userMobShareSDKForShareImage:[UIImage imageNamed:@"share.png"]];
}
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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self loadUserInfoFromServer];
    [self.userItem userItemFromUserDefaults];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
    self.backButton.origin = CGPointMake(ZXSRealValueFit6SWidthPt(50), ZXSRealValueFit6SWidthPt(50));//20,20
    self.redPacketButton.top = ZXSRealValueFit6SWidthPt(50);//16
    self.redPacketButton.right = self.screenWidth - ZXSRealValueFit6SWidthPt(40);//20
    self.startAnswerButton.centerX = self.screenWidth * 0.5;
    self.startAnswerButton.bottom = self.screenHeight - ZXSRealValueFit6SWidthPt(100);
    self.tomorrowBtn.centerX = self.screenWidth * 0.5;
    self.tomorrowBtn.bottom = self.screenHeight - ZXSRealValueFit6SWidthPt(100);
    self.shareActivityButton.centerX = self.startAnswerButton.centerX;
    self.shareActivityButton.bottom = self.startAnswerButton.top - ZXSRealValueFit6SWidthPt(20);
    self.tantouRedPacketView.center = CGPointMake(self.screenWidth * 0.5, self.screenHeight * 0.5);
    self.zfShareView.center = CGPointMake(self.screenWidth * 0.5, self.screenHeight * 0.5);
    self.zfAlterView.center = CGPointMake(self.screenWidth*0.5, self.screenHeight *0.5);
    self.challengeImageView.top = ZXSRealValueFit6SWidthPt(70);
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
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                    [alertView show];
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
            //[MBProgressHUD showError:dict[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:weakSelf.view];
    }];
}
//提现
- (void)sendCashMoneyRequestToServer {
    NSString *networkStatus = [[ZXSUtil shareUtil] getcurrentStatus];
    if ([networkStatus isEqualToString:@"NotNet"]) {
        [MBProgressHUD showError:@"网络未连接" toView:self.view];
        return;
    }
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
            [self hiddenOtherView];
            weakSelf.userItem.money = @"0.00";
            //保存新数据
            [weakSelf.userItem saveUserItemToUserDefaults];
            [MBProgressHUD showSuccess:@"提现成功" toView:self.view];
            self.moneyLabel.text = @"0.00";
        } else { //操作失败
            [weakSelf hiddenOtherView];
            [MBProgressHUD showError:dict[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [weakSelf hiddenOtherView];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:self.view];
    }];
}
//用户信息从服务器
- (void)loadUserInfoFromServer {
    NSString *networkStatus = [[ZXSUtil shareUtil] getcurrentStatus];
    if ([networkStatus isEqualToString:@"NotNet"]) {
        [MBProgressHUD showError:@"网络未连接" toView:self.view];
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
            if (challengeCount == 0 && ![share_time isEqualToString:@"2"]) {
                // 总的次数为空
                self.isMorePeople = NO;
                self.isTiaozhan = NO;
                self.startAnswerButton.hidden = NO;
                self.tomorrowBtn.hidden = YES;
            }else if (challengeCount == 0 && [share_time isEqualToString:@"2"]){
                self.startAnswerButton.hidden = YES;
                self.tomorrowBtn.hidden = NO;
            }else{
                if (can_challenge == 1 ) {
                    self.isMorePeople = NO;
                    self.isTiaozhan = YES;
                    self.startAnswerButton.hidden = NO;
                    self.tomorrowBtn.hidden = YES;
                }else{
                    //这里人说过多了
                    self.isMorePeople = YES;
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
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)redPacketButtonDidClick {
    self.tantouRedPacketView.hidden = NO;
    [self.alterView showShareViewAddView:self.tantouRedPacketView tapGestureWithBool:YES];
}
#pragma mark - 直接点击分享了
- (void)shareActivityButtonDidClick {
    [self userMobShareSDKForShareImage:[UIImage imageNamed:@"share.png"]];
}
#pragma mark -明天再来
-(void)TomoorowButtonDidClick{
    // 退出当前控制器
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)startAnswerButtonDidClick:(UIButton *)button {
    if (self.isTiaozhan == YES) {
        ChristmasAnswerViewController *answerVc = [[ChristmasAnswerViewController alloc]init];
        [self.navigationController pushViewController:answerVc animated:YES];
    }else{
        if (self.isMorePeople == YES) {
            //人数过多了
            self.zfAlterView.hidden = NO;
            [self.alterView showShareViewAddView:self.zfAlterView tapGestureWithBool:YES];
        }else{
            NSLog(@"显示的走的测试数据");
            self.zfShareView.hidden = NO;
            [self.alterView showShareViewAddView:self.zfShareView tapGestureWithBool:YES];
        }
    }
}
- (void)cashButtonDidClick {
    [self sendCashMoneyRequestToServer];
}
#pragma mark --ZFCustomAlterViewDelegate
-(void)customAlterViewHidden{
    [self hiddenOtherView];
}
-(void)hiddenOtherView{
    self.zfShareView.hidden = YES;
    self.zfAlterView.hidden = YES;
    self.tantouRedPacketView.hidden = YES;
    [self.alterView hihhdenView];
}
- (void)closeButtonDidClick {
    [self hiddenOtherView];
}
@end
