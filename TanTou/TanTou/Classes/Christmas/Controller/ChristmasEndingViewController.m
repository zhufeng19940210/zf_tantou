//
//  ChristmasEndingViewController.m
//  TanTou
//
//  Created by StoneMan on 2017/11/16.
//  Copyright © 2017年 bailing. All rights reserved.
//
#import "ChristmasEndingViewController.h"
#import "ChristmasHomeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ChristmasUserItem.h"
#import "WeChatLoginViewController.h"
#import "ZFCustomAlterView.h"
#import "UIImageView+WebCache.h"
@interface ChristmasEndingViewController () <ZFCustomAlterViewDelegate>
/**screenWidth*/
@property (assign, nonatomic) CGFloat screenWidth;
/**screenHeight*/
@property (assign, nonatomic) CGFloat screenHeight;
//背景ImageView
@property (weak, nonatomic) UIImageView *backgroundImageView;
//中间ImageView
@property (weak, nonatomic) UIImageView *middleImageView;
//返回
@property (weak, nonatomic) UIButton *backButton;
//红包
@property (weak, nonatomic) UIButton *redPacketButton;
//tantouRedPacketView
@property (weak, nonatomic) UIView *tantouRedPacketView;
//moneyLabel
@property (weak, nonatomic) UILabel *moneyLabel;
//newaddMoneyLabel
@property (weak, nonatomic) UILabel *newaddMoneyLabel;
//resultLabel
@property (weak, nonatomic) UILabel *resultLabel;
//分享活动按钮
@property (weak, nonatomic) UIButton *shareActivityButton;
//结束挑战
@property (weak, nonatomic) UIButton *endChallengeButton;
/**用户*/
@property (weak, nonatomic) ChristmasUserItem *userItem;
@property (nonatomic,strong)ZFCustomAlterView *alterView;
@property (nonatomic,strong)UIView *tantouRedPacketView2;
@property (nonatomic,strong)UIImageView *centerView;
@property (nonatomic,copy)NSString *pushUrl;
@end
@implementation ChristmasEndingViewController
//懒加载
- (UIView *)tantouRedPacketView2 {
if (!_tantouRedPacketView2) {
        UIView *tantouRedPacketView = [[UIView alloc] init];
        [self.view addSubview:tantouRedPacketView];
        _tantouRedPacketView2 = tantouRedPacketView;
        tantouRedPacketView.frame = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(648));
        tantouRedPacketView.hidden = YES;
        //关闭按钮
        UIButton *closeButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"chacha2"] highlightedImage:[UIImage imageNamed:@"chacha2"] bounds:CGRectMake(ZXSRealValueFit6SWidthPt(540),0, ZXSRealValueFit6SWidthPt(80), ZXSRealValueFit6SWidthPt(80)) target:self action:@selector(EndCloseDidClick)];
        closeButton.frame = CGRectMake(ZXSRealValueFit6SWidthPt(550),10, ZXSRealValueFit6SWidthPt(80), ZXSRealValueFit6SWidthPt(80));
        [tantouRedPacketView addSubview:closeButton];
        //背景图片
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [tantouRedPacketView addSubview:backgroundImageView];
        backgroundImageView.image = [UIImage imageNamed:@"meicaiwangz"];
        backgroundImageView.frame = CGRectMake(0, ZXSRealValueFit6SWidthPt(48), ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(600));
        //中间的图片
        UIImageView *centerView = [[UIImageView alloc] init];
        [tantouRedPacketView addSubview:centerView];
        _centerView = centerView;
        centerView.frame = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(400), ZXSRealValueFit6SWidthPt(400));
        centerView.centerX = tantouRedPacketView.width * 0.5;
        centerView.centerY = tantouRedPacketView.height *0.5;
        //获取更多鼓励
        UIButton *moreButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"jiangli"] highlightedImage:[UIImage imageNamed:@"jiangli"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(260), ZXSRealValueFit6SWidthPt(80)) target:self action:@selector(MoreButtonDidClick)];
        [tantouRedPacketView addSubview:moreButton];
        moreButton.frame = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(260), ZXSRealValueFit6SWidthPt(100));
        moreButton.centerX = tantouRedPacketView.width * 0.5;
        moreButton.bottom = tantouRedPacketView.bottom - 8;
    }
    return _tantouRedPacketView2;
}
#pragma mark - MoreButtonDidClick
-(void)MoreButtonDidClick{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.pushUrl]];
}
#pragma mark -EndCloseDidClick
-(void)EndCloseDidClick{
    [self hidderOtherView];
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
        backgroundImageView.image = [UIImage imageNamed:@"bjzzz"];
        backgroundImageView.bounds = ZXSSCREEN_BOUNDS;
    }
    return _backgroundImageView;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        UIImageView *middleImageView = [[UIImageView alloc] init];
        [self.view addSubview:middleImageView];
        _middleImageView = middleImageView;
        middleImageView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(640), ZXSRealValueFit6SWidthPt(688));//334 * 2  359 * 2
    }
    return _middleImageView;
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
        UILabel *moneyLabel = [UILabel zxs_labelWithTextColor:[UIColor colorWithRed:1.0 green:103 / 255.0 blue:103 / 255.0 alpha:1.0] font:[UIFont systemFontOfSize:40.f] text:@"0.00"];
        [tantouRedPacketView addSubview:moneyLabel];
        _moneyLabel = moneyLabel;
        moneyLabel.top = ZXSRealValueFit6SWidthPt(160);
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

- (UILabel *)newaddMoneyLabel {
    if (!_newaddMoneyLabel) {
        
        UILabel *newaddMoneyLabel = [UILabel zxs_labelWithTextColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] font:ZXSSystemFontFit6WithPt(80.f) text:@"+ 0.00"];
        [self.view addSubview:newaddMoneyLabel];
        _newaddMoneyLabel = newaddMoneyLabel;
    }
    return _newaddMoneyLabel;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        
        UILabel *resultLabel = [UILabel zxs_labelWithTextColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] font:ZXSSystemFontFit6WithPt(40.f) text:@"答对0题"];
        [self.view addSubview:resultLabel];
        _resultLabel = resultLabel;
    }
    return _resultLabel;
}

- (UIButton *)shareActivityButton {
    if (!_shareActivityButton) {
        
        UIButton *shareActivityButton = [UIButton zxs_buttonWithBackGroundImage:[UIImage imageNamed:@"xuanxiangzz"] highlightedBackGroundImage:[UIImage imageNamed:@"xuanxiangz"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(312), ZXSRealValueFit6SWidthPt(88)) titleColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] titleFont:[UIFont systemFontOfSize:14.f] target:self action:@selector(shareActivityButtonDidClick) title:@"分享活动"];
        [self.view addSubview:shareActivityButton];
        _shareActivityButton = shareActivityButton;
    }
    return _shareActivityButton;
}

- (UIButton *)endChallengeButton {
    if (!_endChallengeButton) {
        
        UIButton *endChallengeButton = [UIButton zxs_buttonWithBackGroundImage:[UIImage imageNamed:@"xuanxiangzz"] highlightedBackGroundImage:[UIImage imageNamed:@"xuanxiangz"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(312), ZXSRealValueFit6SWidthPt(88)) titleColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] titleFont:[UIFont systemFontOfSize:14.f] target:self action:@selector(endChallengeButtonDidClick) title:@"结束挑战"];
        [self.view addSubview:endChallengeButton];
        _endChallengeButton = endChallengeButton;
    }
    return _endChallengeButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    //获取用户信息
    self.userItem = [ChristmasUserItem shareChristmasUserItem];
    // 获取当前最新数据
    [self.userItem userItemFromUserDefaults];
    // 发送网络请求获取服务器用户参数
    //[self loadUserInfoFromServer];
    [self loadAdFromSever];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    // 获取当前最新数据
//    [self.userItem userItemFromUserDefaults];
//    if ([self.userItem.last_money  isEqualToString:@"0.00"]) {//答错
//        NSLog(@"viewWillAppear答错");
//        self.errorbackgroundImageView.hidden = NO;
//        self.correctbackgroundImageView.hidden = YES;
//        self.newaddMoneyLabel.hidden = YES;
//        self.resultLabel.hidden = YES;
//    } else {//答对
//        NSLog(@"viewWillAppear答对");
//        self.correctbackgroundImageView.hidden = NO;
//        self.errorbackgroundImageView.hidden = YES;
//        self.newaddMoneyLabel.hidden = NO;
//        self.newaddMoneyLabel.text = [NSString stringWithFormat:@"+ %@",self.userItem.last_money];
//        [self.newaddMoneyLabel sizeToFit];
//        self.resultLabel.hidden = NO;
//        self.resultLabel.text = [NSString stringWithFormat:@"答对%zd题",self.currentCorrectCount];
//        [self.resultLabel sizeToFit];
//    }
//}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    // 获取当前最新数据
//    [self.userItem userItemFromUserDefaults];
//    if ([self.userItem.last_money  isEqualToString:@"0.00"]) {//答错
//        NSLog(@"viewDidAppear答错");
//        self.newaddMoneyLabel.hidden = YES;
//        self.resultLabel.hidden = YES;
//    } else {//答对
//        NSLog(@"viewDidAppear答对");
//        self.newaddMoneyLabel.hidden = NO;
//        self.newaddMoneyLabel.text = [NSString stringWithFormat:@"+ %@",self.userItem.last_money];
//        [self.newaddMoneyLabel sizeToFit];
//        self.resultLabel.hidden = NO;
//        self.resultLabel.text = [NSString stringWithFormat:@"答对%zd题",self.currentCorrectCount];
//        [self.resultLabel sizeToFit];
//    }
//}
#pragma mark - 自定义方法
- (void)setupUI {
    self.screenWidth = ZXSSCREEN_WIDTH;
    self.screenHeight = ZXSSCREEN_HEIGHT;
    self.backgroundImageView.origin = CGPointMake(0, 0);
    self.backButton.origin = CGPointMake(ZXSRealValueFit6SWidthPt(50), ZXSRealValueFit6SWidthPt(50));
    self.redPacketButton.top = ZXSRealValueFit6SWidthPt(50);
    self.redPacketButton.right = self.screenWidth - ZXSRealValueFit6SWidthPt(40);
    self.newaddMoneyLabel.top = ZXSRealValueFit6SWidthPt(300);
    self.newaddMoneyLabel.centerX = self.screenWidth * 0.5;
    self.middleImageView.centerX = self.screenWidth * 0.5;
    self.middleImageView.centerY = self.screenHeight * 0.5;
    self.resultLabel.top = ZXSRealValueFit6SWidthPt(870);
    self.resultLabel.centerX = self.screenWidth * 0.5;
    self.endChallengeButton.centerX = self.screenWidth * 0.5;
    self.endChallengeButton.bottom = self.screenHeight - ZXSRealValueFit6SWidthPt(100);
    self.shareActivityButton.centerX = self.endChallengeButton.centerX;
    self.shareActivityButton.bottom = self.endChallengeButton.top - ZXSRealValueFit6SWidthPt(20);
    self.tantouRedPacketView.center = CGPointMake(self.screenWidth * 0.5, self.screenHeight * 0.5);
    self.tantouRedPacketView2.center = CGPointMake(ZXSSCREEN_WIDTH * 0.5, ZXSSCREEN_HEIGHT * 0.5- 40);
}
// 获取广告了
-(void)loadAdFromSever{
    if (![[[ZXSUtil shareUtil]getcurrentStatus] isEqualToString:@"NotNet"]) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"uid"] = self.userItem.uid;
        parameters[@"token"] = self.userItem.token;
        __weak typeof(self) weakSelf = self;
        [[ZXSNetworkTool sharedNetworkTool]POST:[NSString stringWithFormat:@"%@/Tantou/Activity2/adver",ZXSBasicURL] parameters:parameters success:^(id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"dict:%@",dict);
            NSNumber *status = [dict objectForKey:@"status"];
            NSString *logonurl = [dict objectForKey:@"result"][@"logo_url"];
            weakSelf.pushUrl =  [dict objectForKey:@"result"][@"url"];
            if ([status intValue] ==1) {
                [weakSelf.centerView sd_setImageWithURL:[NSURL URLWithString:logonurl]];
                weakSelf.tantouRedPacketView2.hidden = NO;
                [weakSelf.alterView showShareViewAddView:weakSelf.tantouRedPacketView2 tapGestureWithBool:YES];
                [weakSelf loadUserInfoFromServer];
            }else{
               [MBProgressHUD showError:@"请求失败" toView:self.view];
               return;
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求失败" toView:self.view];
            return;
        }];
    }else{
        [MBProgressHUD showError:@"网络未连接" toView:self.view];
        return;
    }
}
//获取商家的信息
- (void)loadUserInfoFromServer {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.userItem.uid;
    parameters[@"token"] = self.userItem.token;
    __weak typeof(self) weakSelf = self;
    [[ZXSNetworkTool sharedNetworkTool] POST:[NSString stringWithFormat:@"%@/Tantou/Activity/achieve",ZXSBasicURL] parameters:parameters success:^(id responseObject) {
        //解析json数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"loadUserInfoFromServerdict:%@",dict);
        NSLog(@"loadUserInfoFromServermsg:%@",dict[@"msg"]);
        NSNumber *status = [dict objectForKey:@"status"];
        if ([status intValue] == 1) { //操作成功
            NSLog(@"self.userItem.last_money:%@",weakSelf.userItem.last_money);
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
            [self.userItem saveUserItemToUserDefaults];
            self.moneyLabel.text = weakSelf.userItem.money;
            NSLog(@"loadUrverresultlast_money%@",resultDict[@"last_money"]);
            if ([self.userItem.last_money  isEqualToString:@"0.00"]) {//答错
                NSLog(@"viewDidAppear答错");
                //测试了
                self.newaddMoneyLabel.hidden = YES;
                self.resultLabel.hidden = YES;
                self.middleImageView.image = [UIImage imageNamed:@"zjzlzzz"];
            } else {//答对
                NSLog(@"viewDidAppear答对");
                self.newaddMoneyLabel.hidden = NO;
                self.newaddMoneyLabel.text = [NSString stringWithFormat:@"+ %@",self.userItem.last_money];
                [self.newaddMoneyLabel sizeToFit];
                self.resultLabel.hidden = NO;
                self.resultLabel.text = [NSString stringWithFormat:@"答对%zd题",self.currentCorrectCount];
                [self.resultLabel sizeToFit];
                self.middleImageView.image = [UIImage imageNamed:@"daduizzz"];
            }
            
        } else {
            return ;
            //操作失败
            //[MBProgressHUD showError:dict[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        return;
       // [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:weakSelf.view];
    }];
}
//提现红包了
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
            [weakSelf hidderOtherView];
            weakSelf.userItem.money = @"0.00";
            //保存新数据
            [weakSelf.userItem saveUserItemToUserDefaults];
            [MBProgressHUD showSuccess:@"提现成功" toView:weakSelf.view];
            self.moneyLabel.text = @"0.00";
        } else { //操作失败
            [weakSelf hidderOtherView];
            [MBProgressHUD showError:dict[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [weakSelf hidderOtherView];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:weakSelf.view];
    }];
}
//分享次数
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
        } else { //操作失败
           // [MBProgressHUD showError:dict[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:weakSelf.view];
    }];
}
- (void)useMobShareSDKForShareImage:(UIImage *)shareImage {
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
//动画帧
- (void)moveAndScalemoneyLabel {
    //当前金额动画
    /* 移动 */
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    // 起始帧和终了帧的设定
    animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(ZXSSCREEN_WIDTH - 40, 40)]; // 终了帧
    animation1.duration = 1.0;
    /* 放大缩小 */
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.toValue = [NSNumber numberWithFloat:0.0001];
    animation2.duration = 1.0;
    [self.newaddMoneyLabel.layer addAnimation:animation1 forKey:nil];
    [self.newaddMoneyLabel.layer addAnimation:animation2 forKey:nil];
}
#pragma mark - 触发事件
- (void)backButtonDidClick {
    [self showMyBackAnimation];
}
- (void)redPacketButtonDidClick {
    self.tantouRedPacketView.hidden = NO;
    [self.alterView showShareViewAddView:self.tantouRedPacketView tapGestureWithBool:YES];
}
#pragma mark -ZFCustomAlterViewDelegate
-(void)customAlterViewHidden{
    [self hidderOtherView];
}
-(void)hidderOtherView{
    self.tantouRedPacketView2.hidden = YES;
    self.tantouRedPacketView.hidden = YES;
    [self.alterView hihhdenView];
}
-(void)cashButtonDidClick {
    //提现
    [self sendCashMoneyRequestToServer];
}
- (void)closeButtonDidClick {
    [self hidderOtherView];
}
- (void)shareActivityButtonDidClick {
    [self useMobShareSDKForShareImage:[UIImage imageNamed:@"share.png"]];
}
- (void)endChallengeButtonDidClick {
    [self showMyBackAnimation];
}
-(void)showMyBackAnimation{
    [self moveAndScalemoneyLabel];
    [self performSelector:@selector(zfback) withObject:self afterDelay:1.0];
}
-(void)zfback{
    if ([self.navigationController.childViewControllers[1] isKindOfClass:[WeChatLoginViewController class]]) {
        [self.navigationController popToViewController:self.navigationController.childViewControllers[2] animated:YES];
    } else {
        [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
    }
}
@end
