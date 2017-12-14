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
@property (weak, nonatomic) IBOutlet UIImageView *actionImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@end

@implementation FeedbackViewController1
- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"Banner viewWillDisappear");
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:@"FeedbackViewController1" bundle:nibBundleOrNil];
    if (self) {
        /*
         * 创建Banner广告View *
         * banner条的宽度开发者可以进行手动设置，用以满足开发场景需求或是适配最新版本的iphone
         * banner条的高度广点通侧强烈建议开发者采用推荐的高度，否则显示效果会有影响
         * 广点通提供3种尺寸供开发者在不同设备上使用，这里以320*50为例
         */
        _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, -100, ZXSSCREEN_WIDTH,100) appkey:@"1106337035" placementId:@"4000725589503736"];
//        _bannerView.backgroundColor=[UIColor greenColor];
    }
            return self;
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"反馈";
    _bannerView.delegate = self; // 设置Delegate
    _bannerView.currentViewController = self; //设置当前的ViewController
    _bannerView.interval =30; //【可选】设置广告轮播时间;范围为30~120秒，0表示不轮 播
    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭 _bannerView.showCloseBtn = YES; //【可选】展示关闭按钮;默认显示 _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;
//    默认开启
    [self.view addSubview:_bannerView]; //添加到当前的view中
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
-(void)back{

    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)btnAction:(UIButton *)sender {
    [self.suggestionView resignFirstResponder];
    NSString *suggestionStr = self.suggestionView.text;
    if (suggestionStr.length ==0 || [suggestionStr isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入反馈内容"];
        return;
    }
    if (suggestionStr.length<5) {
     
    
        [MBProgressHUD showError:@"反馈内容不能少于5个字"];
        return;
    
    }
    self.actionImageView.hidden = NO;
    [self myStartAnimating2];
    
    NSMutableDictionary *pararm = [NSMutableDictionary dictionary];
    pararm[@"action"] =@"complain";
    pararm[@"complain"] = suggestionStr;
    __weak typeof(self) WeakSelf = self;
//    [[DDNetworkTool sharedNetworkTool]POST:[NSString stringWithFormat:@"%@/Api/Users/tantou",DDBasicUrl] parameters:pararm success:^(id responseObject) {
//        [self myStopAnimating2];
//        self.actionImageView.hidden = YES;
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        NSString *msg = dict[@"msg"];
//        if ([msg isEqualToString:@"反馈成功"]) {
//            [MBProgressHUD showSuccess:@"反馈成功"];
//            [WeakSelf.navigationController popViewControllerAnimated:YES];
//        }else{
//          
//            [MBProgressHUD showError:@"请求失败"];
//            [WeakSelf.navigationController popViewControllerAnimated:YES];
//
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showError:@"请求失败"];
//        [WeakSelf.navigationController popViewControllerAnimated:YES];
//
//        [self myStopAnimating2];
//        self.actionImageView.hidden = YES;
//    }];
}

-(void)myStartAnimating2
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=1 ;i <=61 ; i++){
        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]]];
    }

    [self.actionImageView setAnimationImages:array];
    [self.actionImageView setAnimationRepeatCount:INTMAX_MAX];
    [self.actionImageView setAnimationDuration:0.5];
    [self.actionImageView startAnimating];
}

-(void)myStopAnimating2
{
    [self.actionImageView stopAnimating];
}



@end
