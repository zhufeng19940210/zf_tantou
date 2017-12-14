//
//  HealthScoreViewController.m
//  TanTou
//
//  Created by StoneMan on 2017/10/23.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import "AlbumHealthScoreViewController.h"
#import "FoodItem.h"
#import "WeChatLoginViewController.h"

@interface AlbumHealthScoreViewController ()

//显示图片ImageView
@property (weak, nonatomic) UIImageView *photoImageView;
//动画ImageView
@property (weak, nonatomic) UIImageView *animationImageView;
//底部containView
@property (weak, nonatomic) UIView *buttomContainView;
//分数
@property (weak, nonatomic) UILabel *scoreLabel;
//蒙版
@property (weak, nonatomic) UIView *coverView;
//所有食物
@property (strong, nonatomic) NSMutableArray *foodItems;
//截图
@property (strong, nonatomic) UIImage *snapshotImage;
//屏宽
@property (assign, nonatomic) CGFloat screenwidth;
//动画图片数组
@property (strong, nonatomic) NSMutableArray *animationimagesM;
//食物名称
@property (weak, nonatomic) UILabel *foodNameLabel;

@end

@implementation AlbumHealthScoreViewController
-(void)dealloc {
    [self.animationimagesM removeAllObjects];
    self.animationImageView.animationImages = nil;
}

#pragma mark - 懒加载
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        
        UIImageView *photoImageView = [[UIImageView alloc] init];
        [self.view addSubview:photoImageView];
        _photoImageView = photoImageView;
        photoImageView.bounds = CGRectMake(0, 0, self.screenwidth, self.screenwidth);
        photoImageView.image = self.photoImage;
    }
    return _photoImageView;
}

- (UIImageView *)animationImageView {
    if (!_animationImageView) {
        
        UIImageView *animationImageView = [[UIImageView alloc] init];
        [self.view insertSubview:animationImageView aboveSubview:self.photoImageView];
        _animationImageView = animationImageView;
        animationImageView.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(300), ZXSRealValueFit6SWidthPt(300));
    }
    return _animationImageView;
}

- (UIView *)buttomContainView {
    if (!_buttomContainView) {
        
        UIView *buttomContainView = [[UIView alloc] init];
        [self.view addSubview:buttomContainView];
        _buttomContainView = buttomContainView;
        buttomContainView.bounds = CGRectMake(0, 0, self.screenwidth, ZXSSCREEN_HEIGHT - 64 - ZXSRealValueFit6SWidthPt(80) - self.screenwidth);
        
        //背景图片
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [buttomContainView addSubview: backgroundImageView];
        backgroundImageView.image = [UIImage imageNamed:@"dibu"];
        backgroundImageView.frame = CGRectMake(0, 0, self.screenwidth, buttomContainView.height);
        
        //分数
        UILabel *scoreLabel = [[UILabel alloc] init];
        [buttomContainView addSubview: scoreLabel];
        _scoreLabel = scoreLabel;
        scoreLabel.textColor = [UIColor whiteColor];
        scoreLabel.font = ZXSSystemFontFit6WithPt(36.f);
        scoreLabel.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(132), ZXSRealValueFit6SWidthPt(132));
        scoreLabel.centerX = self.screenwidth * 0.5;
        scoreLabel.top = ZXSRealValueFit6SWidthPt(22);
        scoreLabel.numberOfLines = 0;
        scoreLabel.layer.cornerRadius = ZXSRealValueFit6SWidthPt(66);
        scoreLabel.layer.masksToBounds = YES;
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        
//        //发布
//        CGFloat buttonWidthHeight = ZXSRealValueFit6SWidthPt(122);
//        UIButton *publishButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"fabu"] highlightedImage:nil bounds:CGRectMake(0, 0, buttonWidthHeight, buttonWidthHeight) target:self action:@selector(publishButtonDidClick)];
//        [buttomContainView addSubview: publishButton];
//        publishButton.left = ZXSRealValueFit6SWidthPt(40);
//        publishButton.bottom = buttomContainView.height - ZXSRealValueFit6SWidthPt(15);
//
//        //菜品
//        UIButton *foodButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"caipin"] highlightedImage:nil bounds:CGRectMake(0, 0, buttonWidthHeight, buttonWidthHeight) target:self action:@selector(foodButtonDidClick)];
//       [buttomContainView addSubview: foodButton];
//       foodButton.centerX = self.screenwidth * 0.5;
//       foodButton.bottom = buttomContainView.height - ZXSRealValueFit6SWidthPt(15);
//
//        //分享
//       UIButton *shareButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"fenxiang"] highlightedImage:nil bounds:CGRectMake(0, 0, buttonWidthHeight, buttonWidthHeight) target:self action:@selector(shareButtonDidClick)];
//       [buttomContainView addSubview: shareButton];
//        shareButton.right = self.screenwidth - ZXSRealValueFit6SWidthPt(40);
//        shareButton.bottom = buttomContainView.height - ZXSRealValueFit6SWidthPt(15);
        UILabel *foodNameLabel = [UILabel zxs_labelWithTextColor:[UIColor whiteColor] font:ZXSSystemFontFit6WithPt(80.f) text:@""];
        [buttomContainView addSubview: foodNameLabel];
        _foodNameLabel = foodNameLabel;
        foodNameLabel.bounds = CGRectMake(0, 0, buttomContainView.width, ZXSRealValueFit6SWidthPt(180));
        foodNameLabel.backgroundColor = [UIColor colorWithRed:33 / 255.0 green:203 / 255.0 blue:200 / 255.0 alpha:1.0];
        foodNameLabel.centerX = buttomContainView.width * 0.5;
        foodNameLabel.bottom = buttomContainView.height;
        
        UIView *lineView = [[UIView alloc] init];
        [buttomContainView addSubview: lineView];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.frame = CGRectMake(0, foodNameLabel.top, buttomContainView.width, 1);
        

    }
    return _buttomContainView;
}

- (UIView *)coverView {
    if (!_coverView) {
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenwidth, ZXSSCREEN_HEIGHT)];
        [self.view insertSubview:coverView belowSubview:self.animationImageView];
        _coverView = coverView;
        coverView.hidden = YES;
        coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _coverView;
}

- (NSMutableArray *)foodItems {
    if (!_foodItems) {
        _foodItems = [NSMutableArray array];
    }
    return _foodItems;
}

- (NSMutableArray *)animationimagesM {
    if (!_animationimagesM) {
        
        NSMutableArray *tempArrayM = [NSMutableArray array];
        for (int i = 1 ;i < 62;  i++) {
            [tempArrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]]];
        }
        _animationimagesM = tempArrayM;
    }
    return _animationimagesM;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupUI];
    
    //识别图片
    [self loadRequestForIdentifyingPictureWithImage:self.photoImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 自定义方法
- (void)setPhotoImage:(UIImage *)photoImage {
    _photoImage = photoImage;
}

- (void)setupNavigationBar {
    self.title = @"健康得分";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:33 / 255.0 green:203 / 255.0 blue:200 / 255.0 alpha:1.0]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem zxs_barButtonItemWithHighlightedStatusWithImage:[UIImage imageNamed:@"左-1"] highlightedImage:nil target:self action:@selector(leftBarButtonItemDidClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zxs_barButtonItemWithColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] target:self action:@selector(saveBarButtonItemDidClick) title:@"保存"];
}

- (void)setupUI {
    
    self.screenwidth = ZXSSCREEN_WIDTH;
    self.view.backgroundColor = [UIColor whiteColor];
    self.photoImageView.origin = CGPointMake(0, ZXSRealValueFit6SWidthPt(40));
    self.buttomContainView.origin = CGPointMake(0, ZXSRealValueFit6SWidthPt(80) + self.screenwidth);
    self.animationImageView.center = CGPointMake(self.screenwidth * 0.5, self.screenwidth * 0.5 + ZXSRealValueFit6SWidthPt(40));
    
    // 配置帧动画
    [self.animationImageView setAnimationImages:self.animationimagesM];
    [self.animationImageView setAnimationRepeatCount:INTMAX_MAX];
    [self.animationImageView setAnimationDuration:0.5];
}

- (void)startAnimatingForAnimationImageView {
    self.coverView.hidden = NO;
    [self.animationImageView startAnimating];
}

- (void)stopAnimatingForAnimationImageView {
    self.coverView.hidden = YES;
    [self.animationImageView stopAnimating];
    [self.animationImageView removeFromSuperview];
}

#pragma mark - 发送网络请求
// 识别图片
- (void)loadRequestForIdentifyingPictureWithImage:(UIImage *)photoImage{
    
    // 判断是否联网
    if ([[[ZXSUtil shareUtil] getcurrentStatus] isEqualToString:@"NotNet"]) {
        [MBProgressHUD showError:@"网络未连接"];
        return;
    }

    // 开始动画
    [self startAnimatingForAnimationImageView];

    // 发送请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [manager POST:[NSString stringWithFormat:@"%@/Tantou/Core/score",ZXSBasicURL] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        NSData *imageData = UIImageJPEGRepresentation(photoImage, 0.5);
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 关闭动画
        [weakSelf stopAnimatingForAnimationImageView];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSNumber *status = [dict objectForKey:@"status"];
        if ([status intValue] == 1) { //获取服务器数据成功
            NSMutableDictionary *result = [dict objectForKey:@"result"];
            weakSelf.scoreLabel.text = [NSString stringWithFormat:@"%@分",[result objectForKey:@"score"]];
            weakSelf.foodItems = [FoodItem mj_objectArrayWithKeyValuesArray:[result objectForKey:@"food"]];
            FoodItem *foodItem = weakSelf.foodItems[0];
            weakSelf.foodNameLabel.text = [NSString stringWithFormat:@"%@",foodItem.food_name];
        }else{ //获取服务器数据失败
            weakSelf.scoreLabel.text = [NSString stringWithFormat:@"不是食物"];
            weakSelf.foodNameLabel.text = [NSString stringWithFormat:@"请重新拍摄"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"请求失败"];
        [weakSelf stopAnimatingForAnimationImageView];
    }];
}

#pragma mark - 触发事件
- (void)leftBarButtonItemDidClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveBarButtonItemDidClick {
    if (self.snapshotImage) {
        [MBProgressHUD showMessage:@"亲，截图已保存！" toView:self.view];
        return;
    } else {
        // 截图
        CGRect rect = [UIScreen mainScreen].bounds;
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(currentContext, - CGRectGetMinX(rect), - CGRectGetMinY(rect));
        [self.view.layer renderInContext:currentContext];
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self saveImageToPhotoAlbum:snapshotImage];
        self.snapshotImage = snapshotImage;

        // 截图动画
        UIImageView *screenImageView = [[UIImageView alloc] initWithImage:snapshotImage];
        [self.view addSubview:screenImageView];
        [UIView animateWithDuration:0.5 animations:^{
            screenImageView.transform = CGAffineTransformScale(self.view.transform, 0.5, 0.5);
        } completion:^(BOOL finished) {
            [screenImageView removeFromSuperview];
            [MBProgressHUD showSuccess:@"截图保存成功！" toView:self.view];
        }];
    }
}

//- (void)publishButtonDidClick {
//
//    if (self.foodItems.count == 0) {
//        [MBProgressHUD showMessage:@"只有检查到食物才能分享的探头圈哦!" toView:self.view];
//        return;
//    } else { //进入探头圈
//        // 判断用户是否登录
//        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"]) {//没有登录
//            [self.navigationController pushViewController:[[WeChatLoginViewController alloc] init] animated:YES];
//        } else {//查看详情
//            [self.navigationController pushViewController:[[WeChatLoginViewController alloc] init] animated:YES];
//        }
//    }
//}

//- (void)foodButtonDidClick {
//
//    if (self.foodItems.count == 0) {
//        [MBProgressHUD showMessage:@"只有检查到食物才能查看详情哦!" toView:self.view];
//        return;
//    } else {
//        // 判断用户是否登录
//        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"]) {//没有登录
//            [self.navigationController pushViewController:[[WeChatLoginViewController alloc] init] animated:YES];
//        } else {//查看详情
//            [self.navigationController pushViewController:[[WeChatLoginViewController alloc] init] animated:YES];
//        }
//    }
//}

//- (void)shareButtonDidClick {
//
//    if (self.foodItems.count == 0) {
//        [MBProgressHUD showMessage:@"只有检查到食物才能分享哦!" toView:self.view];
//        return;
//    } else {
//        NSLog(@"分享");
//    }
//}

#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage *)savedImage {
   UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
  
    NSString *msg = nil;
   if(error != NULL){
       msg = @"保存图片失败";
   }else{
       msg = @"保存图片成功";
   }
   NSLog(@"%@",msg);
}


@end
