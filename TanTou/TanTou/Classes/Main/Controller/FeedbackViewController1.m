//
//  FeedbackViewController1.m
//  The  probe
//
//  Created by Sharon on 2017/8/7.
//  Copyright © 2017年 daodian. All rights reserved.
//反馈页面
#import "FeedbackViewController1.h"
#import "YJTComposeView.h"
#define  bannerH  ScreenH/10
@interface FeedbackViewController1 ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet YJTComposeView *suggestionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@end
@implementation FeedbackViewController1
- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"Banner viewWillDisappear");
}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//
//    self = [super initWithNibName:@"FeedbackViewController1" bundle:nibBundleOrNil];
//    if (self) {
//        _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, -100, ZXSSCREEN_WIDTH,100) appkey:@"1106337035" placementId:@"4000725589503736"];
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"反馈";
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    _bannerView.delegate = self; // 设置Delegate
//    _bannerView.currentViewController = self; //设置当前的ViewController
//    _bannerView.interval =30; //【可选】设置广告轮播时间;范围为30~120秒，0表示不轮 播
//    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭 _bannerView.showCloseBtn = YES; //【可选】展示关闭按钮;默认显示 _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;
////    默认开启
//    [self.view addSubview:_bannerView]; //添加到当前的view中
    [_bannerView loadAdAndShow]; //加载广告并展示
    self.suggestionView.placeholder = @"请留下宝贵的意见和建设,并留下你的联系方式，我们将不断努力改进(不少于5个字)";
    self.suggestionView.delegate = self;
    self.suggestionView.layer.cornerRadius = 10.0f;
    self.suggestionView.layer.masksToBounds = YES;
    self.suggestionView.returnKeyType = UIReturnKeyDone;
}
- (void)bannerViewMemoryWarning
{
    NSLog(@"did receive memory warning");
}
// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived
{
    NSLog(@"banner Received");
}
// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(NSError *)error
{
    NSLog(@"banner failed to Received : %@",error);
}
// 广告栏被点击后调用
//
// 详解:当接收到广告栏被点击事件后调用该函数
- (void)bannerViewClicked
{
    NSLog(@"banner clicked");
}
// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication
{
    NSLog(@"banner leave application");
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (IBAction)btnAction:(UIButton *)sender {
    [self.suggestionView resignFirstResponder];
    NSString *suggestionStr = self.suggestionView.text;
    if (suggestionStr.length ==0 || [suggestionStr isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入反馈内容" toView:self.view];
        return;
    }
    if (suggestionStr.length<5) {
        [MBProgressHUD showError:@"反馈内容不能少于5个字" toView:self.view];
        return;
    }
    NSMutableDictionary *pararm = [NSMutableDictionary dictionary];
    pararm[@"action"] =@"complain";
    pararm[@"complain"] = suggestionStr;
    __weak typeof(self) WeakSelf = self;
    [MBProgressHUD showMessage:@"提交中..." toView:self.view];
    [[ZXSNetworkTool sharedNetworkTool]POST:[NSString stringWithFormat:@"%@/Api/Users/tantou",ZXSBasicURL] parameters:pararm success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"dict:%@",dict);
        NSString *msg = dict[@"msg"];
        if ([msg isEqualToString:@"反馈成功"]) {
                [MBProgressHUD showSuccess:@"反馈成功" toView:WeakSelf.view];
            }else{
                [MBProgressHUD showError:@"反馈失败"toView:WeakSelf.view];
                return;
            }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请求失败" toView:self.view];
    }];
}
@end
