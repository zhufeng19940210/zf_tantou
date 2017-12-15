//
//  ChristmasAnswerViewController.m
//  TanTou
//
//  Created by StoneMan on 2017/11/15.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import "ChristmasAnswerViewController.h"
#import "ChristmasEndingViewController.h"
#import "ChristmasFoodItem.h"
#import "JX_GCDTimerManager.h"
@interface ChristmasAnswerViewController ()
//背景
@property (weak, nonatomic) UIImageView *backgroundImageView;
//返回
@property (weak, nonatomic) UIButton *backButton;
//containsdlrView
@property (weak, nonatomic) UIView *containsdlrView;
//sdlrImageView
@property (weak, nonatomic) UIImageView *sdlrImageView;
//秒数label
@property (weak, nonatomic) UILabel *secondLabel;
//foodQuestionIconImageView
@property (weak, nonatomic) UIImageView *foodQuestionIconImageView;
//foodQuestionTextLabel
@property (weak, nonatomic) UILabel *foodQuestionTextLabel;
//resultImageView
@property (weak, nonatomic) UIImageView *resultImageView;
//containOptionButtonView
@property (weak, nonatomic) UIView *containOptionButtonView;
//abutton
@property (weak, nonatomic) UIButton *aButton;
//bbutton
@property (weak, nonatomic) UIButton *bButton;
//cbutton
@property (weak, nonatomic) UIButton *cButton;
//dbutton
@property (weak, nonatomic) UIButton *dButton;
/**选择按钮数组*/
@property (strong, nonatomic) NSMutableArray *selectedButtons;
/**当前选中的按钮*/
@property (weak, nonatomic) UIButton *currentSelectedButton;

//返回选择框
@property (weak, nonatomic) UIView *containBackSelectedView;
//coverView
@property (weak, nonatomic) UIView *coverView;

/**screenWidth*/
@property (assign, nonatomic) CGFloat screenWidth;
/**screenHeight*/
@property (assign, nonatomic) CGFloat screenHeight;

/**用户*/
@property (weak, nonatomic) ChristmasUserItem *userItem;
/**考题数组*/
@property (strong, nonatomic) NSMutableArray *foodItems;
//当前食物考题
@property (weak, nonatomic) ChristmasFoodItem *currentfoodItem;

@end

static NSString * const myTimer = @"MyTimer";
static NSUInteger second = 0;
static NSUInteger foodItemIndex = 0;
static NSUInteger currentCorrectCount = 0;

@implementation ChristmasAnswerViewController

- (void)dealloc {
    [self.foodItems removeAllObjects];
    self.foodItems = nil;
    self.currentfoodItem = nil;
    second = 0;
    foodItemIndex = 0;
    //取消定时器
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:myTimer];
    NSLog(@"dealloc");
}
#pragma mark - 懒加载
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        
        UIImageView *backgroundImageView = [UIImageView zxs_imageViewWithImage:[UIImage imageNamed:@"beijing"] bounds:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        [self.view addSubview:backgroundImageView];
        _backgroundImageView = backgroundImageView;
    }
    return _backgroundImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        
        UIButton *backButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"fanhui-1"] highlightedImage:[UIImage imageNamed:@"fanhui-1"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(70), ZXSRealValueFit6SWidthPt(74)) target:self action:@selector(backButtonDidClick)];
        [self.view addSubview:backButton];
        _backButton = backButton;
    }
    return _backButton;
}

- (UIView *)containsdlrView {
    if (!_containsdlrView) {
        
        UIView *containsdlrView = [[UIView alloc] init];
        [self.view addSubview:containsdlrView];
        _containsdlrView = containsdlrView;
        containsdlrView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(452), ZXSRealValueFit6SWidthPt(968));
        
        //sdlrImageView
        UIImageView *sdlrImageView = [UIImageView zxs_imageViewWithImage:[UIImage imageNamed:@"sdlr"] bounds:containsdlrView.bounds];
        [containsdlrView addSubview:sdlrImageView];
        _sdlrImageView = sdlrImageView;
        sdlrImageView.origin = CGPointMake(0, 0);
        
        //秒数
        UILabel *secondLabel = [UILabel zxs_labelWithTextColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] font:ZXSSystemFontFit6WithPt(30.f) text:@"计时"];
        [containsdlrView addSubview:secondLabel];
        _secondLabel = secondLabel;
        secondLabel.centerX = containsdlrView.width * 0.5;
        secondLabel.top = ZXSRealValueFit6SWidthPt(190);
        
        //foodQuestionIconImageView
        UIImageView *foodQuestionIconImageView = [UIImageView zxs_imageViewWithImage:nil bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(208), ZXSRealValueFit6SWidthPt(208))];
        [containsdlrView addSubview:foodQuestionIconImageView];
        _foodQuestionIconImageView = foodQuestionIconImageView;
        foodQuestionIconImageView.centerX = containsdlrView.width * 0.5;
        foodQuestionIconImageView.bottom = containsdlrView.height - ZXSRealValueFit6SWidthPt(120);
        foodQuestionIconImageView.hidden = YES;
        
        //foodQuestionTextLabel
        UILabel *foodQuestionTextLabel = [UILabel zxs_labelWithTextColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] font:ZXSSystemFontFit6WithPt(30.f) text:@""];
        [containsdlrView addSubview:foodQuestionTextLabel];
        _foodQuestionTextLabel = foodQuestionTextLabel;
        foodQuestionTextLabel.numberOfLines = 0;
        foodQuestionTextLabel.textAlignment = NSTextAlignmentCenter;
        foodQuestionTextLabel.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(300), ZXSRealValueFit6SWidthPt(208));
        foodQuestionTextLabel.centerX = containsdlrView.width * 0.5;
        foodQuestionTextLabel.bottom = containsdlrView.height - ZXSRealValueFit6SWidthPt(120);
        foodQuestionTextLabel.hidden = YES;
        
        //resultImageView
        UIImageView *resultImageView = [UIImageView zxs_imageViewWithImage:nil bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(208), ZXSRealValueFit6SWidthPt(208))];
        [containsdlrView addSubview:resultImageView];
        _resultImageView = resultImageView;
        resultImageView.centerX = containsdlrView.width * 0.5;
        resultImageView.bottom = containsdlrView.height - ZXSRealValueFit6SWidthPt(120);
        resultImageView.hidden = YES;
    }
    return _containsdlrView;
}

- (NSMutableArray *)selectedButtons {
    if (!_selectedButtons) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}

- (UIView *)containOptionButtonView {
    if (!_containOptionButtonView) {
        
        UIView *containOptionButtonView = [[UIView alloc] init];
        [self.view addSubview:containOptionButtonView];
        _containOptionButtonView = containOptionButtonView;
        containOptionButtonView.bounds = CGRectMake(0, 0, self.screenWidth, ZXSRealValueFit6SWidthPt(296));
        
        //cbutton
        UIButton *cButton = [UIButton zxs_buttonWithBackGroundImage:[UIImage imageNamed:@"xuanxiangzz"] selectedBackGroundImage:[UIImage imageNamed:@"xuanxiangz"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(308), ZXSRealValueFit6SWidthPt(88)) titleColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] titleFont:ZXSSystemFontFit6WithPt(30.f) target:self action:@selector(selectButtonDidClick:) title:@""];
        [containOptionButtonView addSubview:cButton];
        _cButton = cButton;
        cButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cButton.contentEdgeInsets = UIEdgeInsetsMake(0, ZXSRealValueFit6SWidthPt(40), 0, 0);
        cButton.right = containOptionButtonView.width * 0.5 - ZXSRealValueFit6SWidthPt(20);
        cButton.bottom = containOptionButtonView.height - ZXSRealValueFit6SWidthPt(40);
        cButton.tag = 2;
        [self.selectedButtons addObject:cButton];
        cButton.userInteractionEnabled = NO;
        
        //dbutton
        UIButton *dButton = [UIButton zxs_buttonWithBackGroundImage:[UIImage imageNamed:@"xuanxiangzz"] selectedBackGroundImage:[UIImage imageNamed:@"xuanxiangz"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(308), ZXSRealValueFit6SWidthPt(88)) titleColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] titleFont:ZXSSystemFontFit6WithPt(30.f) target:self action:@selector(selectButtonDidClick:) title:@""];
        [containOptionButtonView addSubview:dButton];
        _dButton = dButton;
        dButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        dButton.contentEdgeInsets = UIEdgeInsetsMake(0, ZXSRealValueFit6SWidthPt(40), 0, 0);
        dButton.left = containOptionButtonView.width * 0.5 + ZXSRealValueFit6SWidthPt(20);
        dButton.bottom = cButton.bottom;
        dButton.tag = 3;
        [self.selectedButtons addObject:dButton];
        dButton.userInteractionEnabled = NO;
        
        //abutton
        UIButton *aButton = [UIButton zxs_buttonWithBackGroundImage:[UIImage imageNamed:@"xuanxiangzz"] selectedBackGroundImage:[UIImage imageNamed:@"xuanxiangz"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(308), ZXSRealValueFit6SWidthPt(88)) titleColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] titleFont:ZXSSystemFontFit6WithPt(30.f) target:self action:@selector(selectButtonDidClick:) title:@""];
        [containOptionButtonView addSubview:aButton];
        _aButton = aButton;
        aButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        aButton.contentEdgeInsets = UIEdgeInsetsMake(0, ZXSRealValueFit6SWidthPt(40), 0, 0);
        aButton.right = cButton.right;
        aButton.bottom = cButton.top - ZXSRealValueFit6SWidthPt(40);
        aButton.tag = 0;
        [self.selectedButtons addObject:aButton];
        aButton.userInteractionEnabled = NO;
        
        //bbutton
        UIButton *bButton = [UIButton zxs_buttonWithBackGroundImage:[UIImage imageNamed:@"xuanxiangzz"] selectedBackGroundImage:[UIImage imageNamed:@"xuanxiangz"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(308), ZXSRealValueFit6SWidthPt(88)) titleColor:[UIColor colorWithRed:1.0 green:238 / 255.0 blue:128 / 255.0 alpha:1.0] titleFont:ZXSSystemFontFit6WithPt(30.f) target:self action:@selector(selectButtonDidClick:) title:@""];
        [containOptionButtonView addSubview:bButton];
        _bButton = bButton;
        bButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bButton.contentEdgeInsets = UIEdgeInsetsMake(0, ZXSRealValueFit6SWidthPt(40), 0, 0);
        bButton.left = dButton.left;
        bButton.bottom = aButton.bottom;
        bButton.tag = 1;
        [self.selectedButtons addObject:bButton];
        bButton.userInteractionEnabled = NO;
        
        for (UIButton *tempButton in self.selectedButtons) {
            //保证所有touch事件button的highlighted属性为NO,即可去除高亮效果
            [tempButton addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
        }

    }
    return _containOptionButtonView;
}

- (UIView *)containBackSelectedView {
    if (!_containBackSelectedView) {
        
        UIView *containBackSelectedView = [[UIView alloc] init];
        [self.view addSubview:containBackSelectedView];
        _containBackSelectedView = containBackSelectedView;
        containBackSelectedView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(289 * 2), ZXSRealValueFit6SWidthPt(264 * 2));
        containBackSelectedView.hidden = YES;
        
        //bgImageView
        UIImageView *bgImageView = [UIImageView zxs_imageViewWithImage:[UIImage imageNamed:@"tuichutanchuang"] bounds:containBackSelectedView.bounds];
        [containBackSelectedView addSubview:bgImageView];
        bgImageView.origin = CGPointMake(0, 0);
        
        //在玩玩按钮
        UIButton *continueButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"zaiwanwan"] highlightedImage:[UIImage imageNamed:@"zaiwanwan"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(90 * 2), ZXSRealValueFit6SWidthPt(38 * 2)) target:self action:@selector(continueButtonDidClick)];
        [containBackSelectedView addSubview:continueButton];
        continueButton.right = containBackSelectedView.width * 0.5 - ZXSRealValueFit6SWidthPt(20);
        continueButton.bottom = containBackSelectedView.height - ZXSRealValueFit6SWidthPt(60);
        
        //退出按钮
        UIButton *cancelButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"tuichu"] highlightedImage:[UIImage imageNamed:@"tuichu"] bounds:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(90 * 2), ZXSRealValueFit6SWidthPt(38 * 2)) target:self action:@selector(cancelButtonDidClick)];
        [containBackSelectedView addSubview:cancelButton];
        cancelButton.left = containBackSelectedView.width * 0.5 + ZXSRealValueFit6SWidthPt(20);
        cancelButton.bottom = continueButton.bottom;
    }
    
    return _containBackSelectedView;
}
- (UIView *)coverView {
    if (!_coverView) {
        UIView *coverView = [UIView zxs_coverViewWithBounds:CGRectMake(0, 0, self.screenWidth, self.screenHeight) backgroundColor:[UIColor blackColor] alpha:0.3 hidden:YES target:self action:nil];
        [self.view addSubview:coverView];
        _coverView = coverView;
    }
    return _coverView;
}
- (NSMutableArray *)foodItems {
    if (!_foodItems) {
        _foodItems = [NSMutableArray array];
    }
    return _foodItems;
}
#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    //获取用户数据
    self.userItem = [ChristmasUserItem shareChristmasUserItem];
    [self.userItem userItemFromUserDefaults];
    //获取题目
    [self loadQuestionsFromServer];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    self.backButton.origin = CGPointMake(ZXSRealValueFit6SWidthPt(40), ZXSRealValueFit6SWidthPt(40));
    self.containsdlrView.centerX = self.screenWidth * 0.5;
    self.containsdlrView.top = 0;
    self.containOptionButtonView.left = 0;
    self.containOptionButtonView.bottom = self.screenHeight;
    self.coverView.origin = CGPointMake(0, 0);
    self.containBackSelectedView.centerX = self.containsdlrView.centerX;
    self.containBackSelectedView.centerY = self.screenHeight * 0.5;

}
 //获取题目
- (void)loadQuestionsFromServer {
    //正在获取题目
    //获取题目之前设置所有按钮不能交互
    for (UIButton *tempButton in self.selectedButtons) {
        tempButton.userInteractionEnabled = NO;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.userItem.uid;
    parameters[@"token"] = self.userItem.token;
    [[ZXSNetworkTool sharedNetworkTool] GET:[NSString stringWithFormat:@"%@/Tantou/Activity/question",ZXSBasicURL] parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //隐藏提示
        //解析json数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"loadQuestionsFromServerdict:%@",dict);
        NSLog(@"loadQuestionsFromServermsg:%@",dict[@"msg"]);
        NSNumber *status = [dict objectForKey:@"status"];
        if ([status intValue] == 1) { //登录成功
            [self.foodItems removeAllObjects];
            [self.foodItems addObjectsFromArray:[ChristmasFoodItem mj_objectArrayWithKeyValuesArray:dict[@"result"]]];
            if (self.foodItems.count <= 0) return;
            self.view.userInteractionEnabled = YES;
            for (UIButton *tempButton in self.selectedButtons) {
                tempButton.userInteractionEnabled = YES;
            }
            /* 启动一个timer，每隔1秒执行一次。每次执行显示秒数，在执行到秒数==10的时候切换到下一题，当秒数等于30的时候结束考试进入结果页*/
            [self startGCDTimer];
        } else { //登录失败
            [MBProgressHUD showError:dict[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:self.view];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:self.view];
    }];
}
/**
 回答问题
 */
- (void)sendAnswerToServerWithQuestion_id:(NSString *)question_id answer:(NSString *)answer {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.userItem.uid;
    parameters[@"token"] = self.userItem.token;
    parameters[@"id"] = question_id;
    parameters[@"answer"] = answer;
    NSLog(@"parameters%@",parameters);
    [[ZXSNetworkTool sharedNetworkTool] POST:[NSString stringWithFormat:@"%@/Tantou/Activity/answer",ZXSBasicURL] parameters:parameters success:^(id responseObject) {
        //解析json数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"sendAnswerToServerWithQuestion_iddict:%@",dict);
        NSLog(@"sendAnswerToServerWithQuestion_idmsg:%@",dict[@"msg"]);
        NSNumber *status = [dict objectForKey:@"status"];
        
        if ([status isEqualToNumber:@0]) { //操作失败
            [MBProgressHUD showError:dict[@"msg"] toView:self.view];
            return;
        }
        //操作成功
        NSNumber *correctOrerrorResult = dict[@"result"][@"correct"];
        if ([correctOrerrorResult isEqualToNumber:@1]) { //正确
            self.resultImageView.image = [UIImage imageNamed:@"daduila"];
            currentCorrectCount++;
        } else {
            self.resultImageView.image = [UIImage imageNamed:@"dacuole"];
        }
        self.resultImageView.hidden = NO;
        self.foodQuestionTextLabel.hidden = YES;
        self.foodQuestionIconImageView.hidden = YES;
        
        //重新开始计时
        switch (foodItemIndex) {
            case 1:
                second = 10;
                break;
            case 2:
                second = 20;
                break;
            case 3:
                second = 30;
                break;
            default:
                break;
        }
    
        //开始下一题
        [self startGCDTimer];

    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:self.view];
    }];
}

- (void)startGCDTimer{
    
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:myTimer timeInterval:1.0 queue:dispatch_get_main_queue() repeats:YES actionOption:AbandonPreviousAction action:^{
        [weakSelf doSomething];
    }];
}

/* 启动一个timer，每隔1秒执行一次。每次执行显示秒数，在执行到秒数==10的时候切换到下一题，当秒数等于30的时候结束考试进入结果页*/
- (void)doSomething {
    
    if (second == 30) {
        second = 0;
        foodItemIndex = 0;
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:myTimer];
        //跳转到结果页
        ChristmasEndingViewController *endingVC = [[ChristmasEndingViewController alloc] init];
        endingVC.currentCorrectCount = currentCorrectCount;
        [self.navigationController pushViewController:endingVC animated:YES];
        currentCorrectCount = 0;
        return;
    }
    
    self.secondLabel.text = [NSString stringWithFormat:@"%zd",10 - (second % 10)];
    
    //如果用户没有回答，当倒计时结束时显示错误
    if (second % 10 == 9) {
        self.resultImageView.image = [UIImage imageNamed:@"dacuole"];
        self.resultImageView.hidden = NO;
        self.foodQuestionTextLabel.hidden = YES;
        self.foodQuestionIconImageView.hidden = YES;
    } else {
        self.resultImageView.hidden = YES;
    }
    
    if (second % 10 == 0) {
        NSLog(@"foodItemIndex%zd",foodItemIndex);
        ChristmasFoodItem *foodItem = self.foodItems[foodItemIndex];
        self.currentfoodItem = foodItem;
        if ([foodItem.img_url isEqualToString:@""]) {
            
            self.foodQuestionTextLabel.hidden = NO;
            self.foodQuestionIconImageView.hidden = YES;
            self.resultImageView.hidden = YES;
            self.foodQuestionTextLabel.text = foodItem.question;
        } else {
            
            self.foodQuestionTextLabel.hidden = YES;
            self.foodQuestionIconImageView.hidden = NO;
            self.resultImageView.hidden = YES;
            [self.foodQuestionIconImageView sd_setImageWithURL:[NSURL URLWithString:foodItem.img_url] placeholderImage:nil];
        }
        
        [self.aButton setTitle:[NSString stringWithFormat:@"A.  %@",foodItem.choice[0]] forState:UIControlStateNormal];
        [self.bButton setTitle:[NSString stringWithFormat:@"B.  %@",foodItem.choice[1]] forState:UIControlStateNormal];
        [self.cButton setTitle:[NSString stringWithFormat:@"C.  %@",foodItem.choice[2]] forState:UIControlStateNormal];
        [self.dButton setTitle:[NSString stringWithFormat:@"D.  %@",foodItem.choice[3]] forState:UIControlStateNormal];
        
        foodItemIndex++;
        
//        //修改按钮的状态
//        self.currentSelectedButton.selected = NO;;
//        for (UIButton *tempButton in self.selectedButtons) {
//            tempButton.userInteractionEnabled = YES;
//        }
        self.currentSelectedButton.selected = NO;
        self.containOptionButtonView.userInteractionEnabled = YES;
    }
    
    NSLog(@"myTimer runs %lu times!", (unsigned long)second++);
    
}
#pragma mark - 触发事件
- (void)backButtonDidClick {
    //弹出选择框
    self.coverView.hidden = NO;
    self.containBackSelectedView.hidden = NO;
}
- (void)selectButtonDidClick:(UIButton *)button {
    //未设置题目前不可点击
    NSLog(@"self.foodItems.count%zd",self.foodItems.count);
    if (!self.currentfoodItem) {
        return;
    }
    
    self.containOptionButtonView.userInteractionEnabled = NO;
    button.selected = YES;
    self.currentSelectedButton = button;

    
//    self.containOptionButtonView.userInteractionEnabled = NO;
//
//    if (button != self.currentSelectedButton) {
//        self.currentSelectedButton.selected = NO;
//        button.selected = YES;
//        self.currentSelectedButton = button;
//    } else {
//        self.currentSelectedButton.selected = YES;
//    }
    

    
    //    button.selected = YES;
    //    self.currentSelectedButton = button;
    //    for (UIButton *tempButton in self.selectedButtons) {
    //        tempButton.userInteractionEnabled = NO;
    //    }
    

    
    
//    button.selected = YES;
//    self.currentSelectedButton = button;
    
//    //设置当前按钮为选中状态，其他按钮为正常状态，且所有按钮都不能交互
//    for (UIButton *tempButton in self.containOptionButtonView.subviews) {
//        if (tempButton.tag != button.tag) {
//            tempButton.selected = YES;
//        } else {
//            tempButton.selected = NO;
//        }
//    }
    
    //取消定时器
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:myTimer];
    //回答问题
    [self sendAnswerToServerWithQuestion_id:self.currentfoodItem.question_id answer:self.currentfoodItem.choice[button.tag]];
}

- (void)continueButtonDidClick {
    //隐藏选择框
    self.coverView.hidden = YES;
    self.containBackSelectedView.hidden = YES;
}

- (void)cancelButtonDidClick {
    // 退出当前控制器
    self.coverView.hidden = YES;
    self.containBackSelectedView.hidden = YES;
    self.userItem.today_times = [NSString stringWithFormat:@"%zd",[self.userItem.today_times integerValue] - 1];
    [[NSUserDefaults standardUserDefaults] setObject:self.userItem.today_times forKey:@"today_times"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:NO];
}

- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}

@end
