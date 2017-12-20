//
//  HomeViewController.m
//  TanTou
//
//  Created by bailing on 2017/8/10.
//  Copyright © 2017年 bailing. All rights reserved.
//  主页
#import "HomeViewController.h"
#import "WeChatLoginViewController.h"
#import "ChristmasHomeViewController.h"
#import "FoolCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "SelectViewController.h"
#import "ZFNavigtionController.h"
#import "DCPathButton.h"
#import "DCPathItemButton.h"
#import "ZFCustomAlterView.h"
#import "FeedbackViewController1.h"
#import "ShareViewController.h"
#import "ZFPayViewController.h"
#import "SelectViewController.h"
@interface HomeViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,DCPathButtonDelegate,ZFCustomAlterViewDelegate>
//背景
@property (weak, nonatomic) UIImageView *backgroundImageView;
//相机
@property (weak, nonatomic) UIButton *cameraButton;
//相册
@property (weak, nonatomic) UIButton *albumButton;
//头像containIconView
@property (weak, nonatomic) UIView *containIconView;
//头像按钮
@property (weak, nonatomic) UIButton *touxiangButton;
//照片
@property (strong, nonatomic) UIImage *photoImage;
//红包
@property (weak, nonatomic) UIButton *redPacketButton;
//屏宽
@property (assign, nonatomic) CGFloat screenWidth;
//屏高
@property (assign, nonatomic) CGFloat screenHeight;
/**用户*/
@property (weak, nonatomic) ChristmasUserItem *userItem;
//判断用户是否登录
@property (assign, nonatomic) BOOL isLogin;
//tantouRedPacketView
@property (weak, nonatomic) UIView *tantouRedPacketView;
//moneyLabel
@property (weak, nonatomic) UILabel *moneyLabel;
//活动框
@property (weak, nonatomic) UIView *shengdanhuodongView;
//底部的button
@property (weak,nonatomic) DCPathButton *dcPathButton;
@property (nonatomic,strong)ZFCustomAlterView *alterView;
@property (nonatomic,assign)BOOL isFirst;
@end
@implementation HomeViewController

-(instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ShowHuodong) name:ZF_Alter_HuoDong object:nil];
    }
    return self;
}
-(void)ShowHuodong{
    NSLog(@"1111");
    if (self.isFirst == NO) {
        self.isFirst = YES;
        self.shengdanhuodongView.hidden = NO;
        [self.alterView showShareViewAddView:self.shengdanhuodongView tapGestureWithBool:YES];
    }
}

-(ZFCustomAlterView *)alterView{
    if (!_alterView) {
        _alterView = [[ZFCustomAlterView alloc]init];
        _alterView.delegate = self;
    }
    return _alterView;
}
#pragma mark - 懒加载
//背景图片
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [self.view addSubview:backgroundImageView];
        _backgroundImageView = backgroundImageView;
        backgroundImageView.bounds = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
        backgroundImageView.image = [UIImage imageNamed:@"zhuye"];
    }
    return _backgroundImageView;
}
//相机
- (UIButton *)cameraButton {
    if (!_cameraButton) {
        UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:cameraButton];
        _cameraButton = cameraButton;
        cameraButton.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(160), ZXSRealValueFit6SWidthPt(160));
        [cameraButton setImage:[UIImage imageNamed:@"xiangji"] forState:UIControlStateNormal];
        [cameraButton addTarget:self action:@selector(cameraButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}
//相册
- (UIButton *)albumButton {
    if (!_albumButton) {
        UIButton *albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:albumButton];
        _albumButton = albumButton;
        albumButton.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(80), ZXSRealValueFit6SWidthPt(80));
        [albumButton setImage:[UIImage imageNamed:@"xiangce"] forState:UIControlStateNormal];
        [albumButton addTarget:self action:@selector(albumButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumButton;
}
// TODO
//头像
- (UIView *)containIconView {
    if (!_containIconView) {
        UIView *containIconView = [[UIView alloc] init];
        [self.view addSubview: containIconView];
        _containIconView = containIconView;
        containIconView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(120), ZXSRealValueFit6SWidthPt(120));
        containIconView.layer.cornerRadius = ZXSRealValueFit6SWidthPt(60);
        containIconView.layer.masksToBounds = YES;
        containIconView.backgroundColor = [UIColor clearColor];
        UIButton *touxiangButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"touxiang"] selectedImage:nil bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(120), ZXSRealValueFit6SWidthPt(120)) target:self action:@selector(touxiangButtonDidClick:)];
        [containIconView addSubview:touxiangButton];
        _touxiangButton = touxiangButton;
        touxiangButton.layer.cornerRadius = ZXSRealValueFit6SWidthPt(60);
        touxiangButton.layer.masksToBounds = YES;
    }
    return _containIconView;
}
//活动框
- (UIView *)shengdanhuodongView {
    if (!_shengdanhuodongView) {
        UIView *shengdanhuodongView = [[UIView alloc] init];
        [self.view addSubview:shengdanhuodongView];
        _shengdanhuodongView = shengdanhuodongView;
        shengdanhuodongView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(612), ZXSRealValueFit6SWidthPt(674));
        shengdanhuodongView.hidden = YES;
        //背景图片
        UIImageView *backgroundImageView = [UIImageView zxs_imageViewWithImage:[UIImage imageNamed:@"shengdanhuodong"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(612), ZXSRealValueFit6SWidthPt(574))];
        [shengdanhuodongView addSubview:backgroundImageView];
        backgroundImageView.origin = CGPointMake(0, ZXSRealValueFit6SWidthPt(50));

        //关闭按钮
        UIButton *closeButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"chacha"] selectedImage:[UIImage imageNamed:@"chacha"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(84), ZXSRealValueFit6SWidthPt(84)) target:self action:@selector(closeShengDanHuoDongViewDidClick)];
        [shengdanhuodongView addSubview:closeButton];
        closeButton.top = 0;
        closeButton.right = shengdanhuodongView.width;
        
        //立即挑战按钮
        UIButton *immediateChallengeButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"lijitiaozhan"] selectedImage:[UIImage imageNamed:@"lijitiaozhan"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(292), ZXSRealValueFit6SWidthPt(88)) target:self action:@selector(immediateChallengeButtonDidClick)];
        [shengdanhuodongView addSubview:immediateChallengeButton];
        immediateChallengeButton.centerX = shengdanhuodongView.width * 0.5;
        immediateChallengeButton.bottom = shengdanhuodongView.height;
    }
    return _shengdanhuodongView;
}
//红包
- (UIButton *)redPacketButton {
    if (!_redPacketButton) {
        UIButton *redPacketButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"zhuyehongbao"] highlightedImage:[UIImage imageNamed:@"zhuyehongbao"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(200), ZXSRealValueFit6SWidthPt(144)) target:self action:@selector(redPacketButtonDidClick)];
        [self.view addSubview:redPacketButton];
        _redPacketButton = redPacketButton;
    }
    return _redPacketButton;
}
//探头红包框
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
        backgroundImageView.image = [UIImage imageNamed:@"jinez"];
        backgroundImageView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(528));
        backgroundImageView.origin = CGPointMake(0, 0);
        //moneyLabel
        UILabel *moneyLabel = [UILabel zxs_labelWithTextColor:[UIColor colorWithRed:1.0 green:103 / 255.0 blue:103 / 255.0 alpha:1.0] font:ZXSSystemFontFit6WithPt(80.f) text:@"0.00"];
        [tantouRedPacketView addSubview:moneyLabel];
        _moneyLabel = moneyLabel;
        moneyLabel.top = ZXSRealValueFit6SWidthPt(170);
        moneyLabel.right = tantouRedPacketView.width - ZXSRealValueFit6SWidthPt(110);
        
        //挑战按钮
        UIButton *challengeButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"tiaozhan"] highlightedImage:[UIImage imageNamed:@"tiaozhan"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(180), ZXSRealValueFit6SWidthPt(76)) target:self action:@selector(challengeButtonDidClick)];
        [tantouRedPacketView addSubview:challengeButton];
        challengeButton.right = tantouRedPacketView.width * 0.5 - ZXSRealValueFit6SWidthPt(30);
        challengeButton.bottom = CGRectGetMaxY(backgroundImageView.frame) - ZXSRealValueFit6SWidthPt(60);
        //注销按钮
        UIButton *cancelButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"zhuxiao"] highlightedImage:[UIImage imageNamed:@"zhuxiao"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(180), ZXSRealValueFit6SWidthPt(76)) target:self action:@selector(cancelButtonDidClick)];
        [tantouRedPacketView addSubview:cancelButton];
        cancelButton.left = tantouRedPacketView.width * 0.5 + ZXSRealValueFit6SWidthPt(30);
        cancelButton.bottom = challengeButton.bottom;
        
        //关闭按钮
        UIButton *closeButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"chacha"] highlightedImage:[UIImage imageNamed:@"chacha"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(80), ZXSRealValueFit6SWidthPt(80)) target:self action:@selector(closeButtonDidClick)];
        [tantouRedPacketView addSubview:closeButton];
        closeButton.centerX = tantouRedPacketView.width * 0.5;
        closeButton.bottom = tantouRedPacketView.height;
    }
    return _tantouRedPacketView;
}
-(DCPathButton *) dcPathButton{
    if (!_dcPathButton) {
        DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"jia111"]
                                                             highlightedImage:[UIImage imageNamed:@"jia111"]];
        dcPathButton.delegate = self;
        DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"w"]
                                                               highlightedImage:[UIImage imageNamed:@"w"]
                                                                backgroundImage:nil
                                                     backgroundHighlightedImage:nil];
        DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"fankui111"]
                                                               highlightedImage:[UIImage imageNamed:@"fankui111"]
                                                                backgroundImage:nil
                                                     backgroundHighlightedImage:nil];
        DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"fenxiang111"]
                                                               highlightedImage:[UIImage imageNamed:@"fenxiang111"]
                                                                backgroundImage:nil
                                                     backgroundHighlightedImage:nil];
        [dcPathButton addPathItems:@[itemButton_1,
                                     itemButton_2,
                                     itemButton_3
                                     ]];
        dcPathButton.bloomRadius = 80.0f;
        dcPathButton.allowSounds = NO;
        dcPathButton.allowCenterButtonRotation = YES;
        dcPathButton.bottomViewColor = [UIColor grayColor];
        dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTopLeft;
        [self.view addSubview:dcPathButton];
        _dcPathButton = dcPathButton;
    }
    return _dcPathButton;
}
#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // 获取当前最新数据
    self.userItem = [ChristmasUserItem shareChristmasUserItem];
    [self.userItem userItemFromUserDefaults];
    // 发送网络请求获取服务器用户参数
    if (self.userItem.uid.length == 0 || self.userItem.uid == nil) return;
    [self loadUserInfoFromServer];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 超过圣诞时间就隐藏
    [self showorHideShengDanHuoDongView];
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
    self.cameraButton.bottom = self.screenHeight - ZXSRealValueFit6SWidthPt(194);
    self.cameraButton.centerX = self.screenWidth * 0.5;
    CGFloat margin = ZXSRealValueFit6SWidthPt(25);
    self.albumButton.right = self.cameraButton.left - margin;
    self.albumButton.centerY = self.cameraButton.centerY;
    self.containIconView.left = ZXSRealValueFit6SWidthPt(40);
    self.containIconView.top = ZXSRealValueFit6SWidthPt(40);
    self.redPacketButton.right = self.screenWidth;
    self.redPacketButton.centerY = self.screenHeight * 0.5 + ZXSRealValueFit6SWidthPt(60);
    self.shengdanhuodongView.centerX = self.screenWidth * 0.5;
    self.shengdanhuodongView.centerY = self.screenHeight * 0.5;
    self.tantouRedPacketView.center = CGPointMake(self.screenWidth * 0.5, self.screenHeight * 0.5);
    self.dcPathButton.dcButtonCenter = CGPointMake(self.screenWidth - 10 - self.dcPathButton.frame.size.width/2, self.screenHeight - self.dcPathButton.frame.size.height/2 - 10);
}
- (void)showorHideShengDanHuoDongView {
    //获取用户数据，判断用户是否登录
    [self.userItem userItemFromUserDefaults];
    self.isLogin = (self.userItem.uid != nil);
    //比较两个时间段
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger flagInt = [NSDate zxs_compareDateString:nowDateString otherDateString:@"2017-12-26 00:00:00"];
    switch (flagInt) {
        case 1:{
            BOOL isShow = [[NSUserDefaults standardUserDefaults]boolForKey:ZF_Alter_HuoDong2];
            if (isShow == YES) {
                self.shengdanhuodongView.hidden = NO;
                [self.alterView showShareViewAddView:self.shengdanhuodongView tapGestureWithBool:YES];
            } else{
            }
            if (self.isLogin) {//登录
                self.containIconView.hidden = NO;
                //设置头像
                NSURL *iconURL = [NSURL URLWithString:self.userItem.icon];
                [self.touxiangButton sd_setImageWithURL:iconURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                }];
            } else {//没有登录
                self.containIconView.hidden = YES;
            }
        }
            break;
        case 0:
        case -1:{
            self.shengdanhuodongView.hidden = YES;
            self.touxiangButton.hidden = YES;
        }
            break;
        default:
            break;
    }
}
- (void)clearUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"uid"];
    [userDefaults removeObjectForKey:@"token"];
    [userDefaults removeObjectForKey:@"openid"];
    [userDefaults removeObjectForKey:@"money"];
    [userDefaults removeObjectForKey:@"today_times"];
    [userDefaults removeObjectForKey:@"share_times"];
    [userDefaults removeObjectForKey:@"challenge_times"];
    [userDefaults removeObjectForKey:@"add_time"];
    [userDefaults removeObjectForKey:@"login_type"];
    [userDefaults removeObjectForKey:@"today_time"];
    [userDefaults removeObjectForKey:@"username"];
    [userDefaults removeObjectForKey:@"icon"];
    [userDefaults removeObjectForKey:@"last_money"];
    [userDefaults removeObjectForKey:@"can_challenge"];
}
- (void)loadUserInfoFromServer {
    NSString *networkStatus = [[ZXSUtil shareUtil] getcurrentStatus];
    if ([networkStatus isEqualToString:@"NotNet"]) {
        [MBProgressHUD showError:@"网络未连接"];
        return;
    }
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
            weakSelf.userItem.last_money = resultDict[@"can_challenge"];
            NSLog(@"self.userItem.last_money:%@",weakSelf.userItem.last_money);
            //保存新数据
            [self.userItem saveUserItemToUserDefaults];
            self.moneyLabel.text = weakSelf.userItem.money;
            NSLog(@"loadUserInfoFromServerresultlast_money%@",resultDict[@"last_money"]);
        } else { //操作失败
            [MBProgressHUD showError:dict[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:weakSelf.view];
    }];
}
#pragma mark - 触发事件
- (void)immediateChallengeButtonDidClick {
    [self hiddenAllView];
    if (self.isLogin) {
         [self.navigationController pushViewController:[[ChristmasHomeViewController alloc] init] animated:YES];
    } else {
         [self.navigationController pushViewController:[[WeChatLoginViewController alloc] init] animated:YES];
    }
}
- (void)closeShengDanHuoDongViewDidClick {
    [self hiddenAllView];
}
- (void)touxiangButtonDidClick:(UIButton *)button {
    //跳出红包框
    self.tantouRedPacketView.hidden = NO;
    [self.alterView showShareViewAddView:self.tantouRedPacketView tapGestureWithBool:YES];
    //获取本地用户数据
    [self.userItem userItemFromUserDefaults];
    self.moneyLabel.text = self.userItem.money;
}
- (void)challengeButtonDidClick {
    [self hiddenAllView];
    [self.navigationController pushViewController:[[ChristmasHomeViewController alloc] init] animated:YES];
}
- (void)redPacketButtonDidClick {
    if (self.isLogin) {
        [self.navigationController pushViewController:[[ChristmasHomeViewController alloc] init] animated:YES];
    } else {
        [self.navigationController pushViewController:[[WeChatLoginViewController alloc] init] animated:YES];
    }
}
- (void)cancelButtonDidClick {
    [self hiddenAllView];
    self.containIconView.hidden = YES;
    //清空本地数据
    [self clearUserDefaults];
    self.isLogin = NO;
}
- (void)cameraButtonDidClick:(UIButton *)sender {
    //跳转照相界面
    [self.navigationController pushViewController:[[FoolCameraViewController alloc] init] animated:NO];
}
#pragma mark closeBtn
-(void)closeButtonDidClick{
    [self hiddenAllView];
}
- (void)albumButtonDidClick:(UIButton*)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //设置导航栏背景颜色
    [imagePickerController.navigationBar  setBackgroundImage:[UIImage imageNamed:@"导航栏"] forBarMetrics:UIBarMetricsDefault];
    //设置右侧取消按钮的字体颜色
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:attrs];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.navigationBar.translucent = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:NO completion:nil];
}
#pragma mark- 选择相片回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.photoImage = info[UIImagePickerControllerOriginalImage];
    SelectViewController *selectVc = [[SelectViewController alloc]init];
    selectVc.selectImage = self.photoImage;
    [picker pushViewController:selectVc animated:YES];
}
#pragma mark DCPathButtonDelegate
- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@" at index : %lu",  (unsigned long)itemButtonIndex);
    if(itemButtonIndex==0)
    {
//       ZFPayViewController *paymoneyVc = [[ZFPayViewController alloc]init];
//      [self.navigationController pushViewController:paymoneyVc animated:NO];
    }else if(itemButtonIndex==1)
    {
        FeedbackViewController1*feedBackVC=[[FeedbackViewController1 alloc]init];
        [self.navigationController pushViewController:feedBackVC animated:NO];
    }else
    {
        ShareViewController*shareVC=[[ShareViewController alloc]init];
        [self.navigationController pushViewController:shareVC animated:NO];
    }
}
#pragma mark ZFCustomAlterViewDelegate
-(void)customAlterViewHidden{
    [self hiddenAllView];
}
// 隐藏keywindow
-(void)hiddenAllView{
    self.tantouRedPacketView.hidden = YES;
    self.shengdanhuodongView.hidden = YES;
    [self.alterView hihhdenView];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ZF_Alter_HuoDong2];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
