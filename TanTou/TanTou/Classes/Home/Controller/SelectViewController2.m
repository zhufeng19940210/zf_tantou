//
//  SelectViewController.m
//  The  probe
//
//  Created by bailing on 2017/8/7.
//  Copyright © 2017年 daodian. All rights reserved.
//评分页面
#import "TheZoomImage.h"
#import "SelectViewController2.h"
#import "UIView+TYAlertView.h"
#import "TYAlertController+BlurEffects.h"
#import "ShareView.h"
#import "ModelTableViewCell.h"
#import "SelectHeaderView.h"
#import "SelectTableViewCell.h"
#import "SelectModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ZFCustomAlterView.h"
@interface SelectViewController2 ()<UITableViewDelegate,UITableViewDataSource,ZFCustomAlterViewDelegate,ShareViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *biaoyulabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgimageView;
@property (nonatomic,strong)UIImageView *activityImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTopLayout;
@property(nonatomic,strong) UIButton*shareBtn;
@property(nonatomic,strong)  UIView*views;
#pragma mark zhufeng
@property (nonatomic,strong)NSMutableArray *foodDataArray;
@property (nonatomic,strong)NSString *myscore;
@property (nonatomic,strong) ShareView *shareView;
@property (nonatomic,assign)int shareType;
@property (strong, nonatomic) UIImage *snapshotImage;
@property (nonatomic,strong)UIView *tantouRedPacketView;
@property (nonatomic,strong)ZFCustomAlterView *customAlterView;
// 定制一个view和imageView
@property (nonatomic,strong)UIView *actionView;
@property (nonatomic,strong)UIImageView *activityImageView;
//定制一个view
@property (nonatomic,strong)UIView *detailView;
@property (nonatomic,strong)UITableView *zfTableView;
@end
@implementation SelectViewController2
-(UIView *)detailView{
    if (!_detailView ) {
        UIView *tantouRedPacketView = [[UIView alloc] init];
        tantouRedPacketView.backgroundColor = [UIColor colorWithRed:(30/255.0f) green:(205/255.0f) blue:(205/255.0f) alpha:1.0];
        [self.view addSubview:tantouRedPacketView];
        _detailView = tantouRedPacketView;
        tantouRedPacketView.layer.cornerRadius = 20;
        tantouRedPacketView.layer.masksToBounds = YES;
        tantouRedPacketView.frame = CGRectMake(40, 64, ZXSSCREEN_WIDTH -80, ZXSSCREEN_HEIGHT - 130);
        tantouRedPacketView.hidden = YES;
        //背景图片
        UITableView *zftableView = [[UITableView alloc]init];
        zftableView.frame = CGRectMake(0, 0, ZXSSCREEN_WIDTH -80,ZXSSCREEN_HEIGHT - 210);
        [tantouRedPacketView addSubview:zftableView];
        _zfTableView = zftableView;
        zftableView.delegate = self;
        zftableView.dataSource = self;
        zftableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [zftableView registerNib:[UINib nibWithNibName:@"SelectHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"SelectHeaderView"];
        [zftableView registerNib:[UINib nibWithNibName:@"SelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SelectTableViewCell"];
        zftableView.backgroundColor=[UIColor whiteColor];
        //菜单详情
        UIView *myView = [[UIView alloc]init];
        myView.frame = CGRectMake(0, CGRectGetMaxY(zftableView.frame), ZXSSCREEN_WIDTH -80, 50);
        myView.backgroundColor = [UIColor colorWithRed:(30/255.0f) green:(205/255.0f) blue:(205/255.0f) alpha:1.0];
        myView.layer.cornerRadius = 20;
        myView.layer.masksToBounds = YES;
        [tantouRedPacketView addSubview:myView];
        UIButton *caidanBtn = [[UIButton alloc]init];
        caidanBtn.frame = CGRectMake(0, 0, ZXSSCREEN_WIDTH -80, 50);
        [caidanBtn setTitle:@"菜单详情" forState:UIControlStateNormal];
        [caidanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [myView addSubview:caidanBtn];
        //关闭按钮
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tantouRedPacketView addSubview:closeButton];
        closeButton.backgroundColor = [UIColor colorWithRed:(30/255.0f) green:(205/255.0f) blue:(205/255.0f) alpha:1.0];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"chacha"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(zfColoseButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        closeButton.frame = CGRectMake(0,CGRectGetMaxY(myView.frame) ,ZXSRealValueFit6SWidthPt(70), ZXSRealValueFit6SWidthPt(70));
        closeButton.centerX = tantouRedPacketView.width * 0.5;
        closeButton.top = myView.bottom - 10;
    }
    return _detailView;
}
#pragma  mark - zfColoseButtonDidClick
-(void)zfColoseButtonDidClick{
    [self ZFhiddenOtherView];
}
-(UIView *)actionView{
    if (!_actionView) {
        UIView *actionView = [[UIView alloc]init];
        [self.view addSubview:actionView];
        _actionView = actionView;
        actionView.hidden = YES;
        actionView.frame = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(250), ZXSRealValueFit6SWidthPt(250));
        actionView.hidden = YES;
        //背景图片
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [actionView addSubview:backgroundImageView];
        _activityImageV = backgroundImageView;
        backgroundImageView.image = [UIImage imageNamed:@"loading1"];
        backgroundImageView.frame = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(250), ZXSRealValueFit6SWidthPt(250));
    }
    return _actionView;
}
-(ZFCustomAlterView *)customAlterView{
    if (!_customAlterView) {
        _customAlterView = [[ZFCustomAlterView alloc]init];
        _customAlterView.delegate = self;
    }
    return _customAlterView;
}
//探头红包框
- (UIView *)tantouRedPacketView {
    if (!_tantouRedPacketView) {
        UIView *tantouRedPacketView = [[UIView alloc] init];
        [self.view addSubview:tantouRedPacketView];
        _tantouRedPacketView = tantouRedPacketView;
        tantouRedPacketView.frame = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(648));
        tantouRedPacketView.hidden = YES;
        //关闭按钮
        UIButton *closeButton = [UIButton zxs_buttonWithImage:[UIImage imageNamed:@"cha"] highlightedImage:[UIImage imageNamed:@"cha"] bounds:CGRectMake(ZXSRealValueFit6SWidthPt(500),0, ZXSRealValueFit6SWidthPt(60), ZXSRealValueFit6SWidthPt(120)) target:self action:@selector(ButtonCloseDidClick)];
        closeButton.frame = CGRectMake(ZXSRealValueFit6SWidthPt(500),0, ZXSRealValueFit6SWidthPt(60), ZXSRealValueFit6SWidthPt(120));
        [tantouRedPacketView addSubview:closeButton];
        //背景图片
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [tantouRedPacketView addSubview:backgroundImageView];
        backgroundImageView.image = [UIImage imageNamed:@"tanchuang1"];
        backgroundImageView.frame = CGRectMake(0, ZXSRealValueFit6SWidthPt(120), ZXSRealValueFit6SWidthPt(578), ZXSRealValueFit6SWidthPt(528));
    }
    return _tantouRedPacketView;
}
#pragma mark ButtonCloseDidClick
-(void)ButtonCloseDidClick{
    [self ZFhiddenOtherView];
}
-(NSMutableArray *)foodDataArray{
    if (!_foodDataArray) {
        _foodDataArray = [NSMutableArray array];
    }
    return _foodDataArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.detailView.center = CGPointMake(ZXSSCREEN_WIDTH * 0.5, ZXSSCREEN_HEIGHT * 0.5);
    self.actionView.center = CGPointMake(ZXSSCREEN_WIDTH * 0.5, ZXSSCREEN_HEIGHT * 0.5);
    self.tantouRedPacketView.center = CGPointMake(ZXSSCREEN_WIDTH * 0.5, ZXSSCREEN_HEIGHT * 0.5- 40);
    self.biaoyulabel.hidden=YES;
    self.bgimageView.image = self.selectImage;
     self.bgimageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [_bgimageView addGestureRecognizer:tapGestureRecognizer1];
    [_bgimageView setUserInteractionEnabled:YES];
    [self sendShareCommandWithType:self.selectImage];
}
- (void)setupNavigationBar {
    self.title = @"健康指数";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:33 / 255.0 green:203 / 255.0 blue:200 / 255.0 alpha:1.0]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem zxs_barButtonItemWithHighlightedStatusWithImage:[UIImage imageNamed:@"bai2"] highlightedImage:nil target:self action:@selector(leftBarButtonItemDidClick2)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zxs_barButtonItemWithColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] target:self action:@selector(saveBarButtonItemDidClick) title:@"保存"];
}
#pragma mark - 触发事件
- (void)leftBarButtonItemDidClick2 {
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)saveBarButtonItemDidClick {
    if (self.snapshotImage) {
        [MBProgressHUD showSuccess:@"亲，截图已保存！" toView:self.view];
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

#pragma mark - uitableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.foodDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    SelectModel *selectModel = [self.foodDataArray objectAtIndex:section];
    
    if ([selectModel.isExpend isEqualToString:@"0"]) {
        
        return 0;
        
    }else{
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectModel *model = self.foodDataArray[indexPath.section];
    return [self cellHeightWithStr:model.intro];
}

-(CGFloat)cellHeightWithStr:(NSString *)str{
    CGFloat cellHeight;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:13],
                              NSFontAttributeName,
                              paragraphStyle,
                              NSParagraphStyleAttributeName,
                              nil];
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    CGFloat textH = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrDict context:nil].size.height;
    cellHeight = textH +80;
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SelectHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SelectHeaderView"];
    SelectModel *selectModel = [self.foodDataArray objectAtIndex:section];
    header.xiaolvimage.hidden=YES;
    if ([selectModel.isExpend isEqualToString:@"0"])
    {
         [header.clickBttn setImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
        header.xiaolvimage.hidden=YES;
    }else
    {
        [header.clickBttn setImage:[UIImage imageNamed:@"xia"] forState:UIControlStateNormal];
        header.xiaolvimage.hidden=NO;
    }
    
    if (header == nil) {
        header = [[SelectHeaderView alloc]initWithReuseIdentifier:@"SelectHeaderView"];
    }
    header.contentView.backgroundColor = [UIColor whiteColor];
    SelectModel *model = self.foodDataArray[section];
    header.foodNameLabel.text = model.food_name;
    header.clickBttn.tag = section;
    [header.clickBttn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
    header.clickBtn.tag=section;
    [header.clickBtn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
    return header;
}
-(void)detailClick:(UIButton*)button{
    SelectModel *model = self.foodDataArray[button.tag];
    model.isExpend = [model.isExpend isEqualToString:@"0"] ? @"1":@"0";
    [self.zfTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectTableViewCell"];
    if (cell == nil) {
        cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectTableViewCell"];
    }
    cell.backgroundColor=[UIColor whiteColor];
    SelectModel *model = self.foodDataArray[indexPath.section];
    if ([model.kaluli isEqualToString:@"0"]) {
        cell.kaluliLabel.hidden = YES;
        cell.topLayout.constant = -30;
    }else{
        cell.kaluliLabel.text = [NSString stringWithFormat:@"卡路里:%@",model.kaluli];
    }
    cell.contentLabel.text = model.intro;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)sendShareCommandWithType:(UIImage*)photo{
    if ([[[ZXSUtil shareUtil] getcurrentStatus] isEqualToString:@"NotNet"]) {
        [MBProgressHUD showError:@"网络未连接" toView:self.view];
        return;
    }
    self.actionView.hidden = NO;
    [self.customAlterView showShareViewAddView:self.actionView tapGestureWithBool:NO];
    [self myStartAnimating];
    photo = [self imageCompressForWidth:photo targetWidth:200.0f];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user_id"] = @"其他";
    param[@"token"] = @"sb";
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/Tantou/Core/score",ZXSBasicURL] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        NSData *imageData = UIImageJPEGRepresentation(photo, 0.5);
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"dict:%@",dict);
        [weakSelf myStopAnimating];
        weakSelf.actionView.hidden = YES;
        [weakSelf.customAlterView hihhdenView];
        NSNumber*status  =[dict objectForKey:@"status"];
        int a=[status intValue];
        if(a==1)
        {
            NSMutableDictionary*result=[dict objectForKey:@"result"];
            weakSelf.myscore=[result objectForKey:@"score"];
            NSMutableArray*arrfood=[[NSMutableArray alloc]init];
            arrfood=[result objectForKey:@"food"];
            for (int i=0; i<arrfood.count; i++) {
                NSMutableDictionary*food=[arrfood objectAtIndex:i];
                SelectModel *model = [[SelectModel alloc]init];
                NSString *calorie = [food objectForKey:@"calorie"];
                NSString*foodname=[food objectForKey:@"food_name"];
                NSString*intro=[food objectForKey:@"intro"];
                model.food_name = foodname;
                model.intro = intro;
                model.kaluli = calorie;
                [self.foodDataArray addObject:model];
            }
            self.biaoyulabel.hidden = NO;
            weakSelf.biaoyulabel.text = [dict objectForKey:@"result"][@"food_name"];
        }else
        {
            self.biaoyulabel.hidden=NO;
            weakSelf.biaoyulabel.text = [NSString stringWithFormat:@"无法识别"];
            weakSelf.bgimageView.userInteractionEnabled = NO;
            weakSelf.tantouRedPacketView.hidden = NO;
            [weakSelf.customAlterView showShareViewAddView:self.tantouRedPacketView tapGestureWithBool:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf myStopAnimating];
        weakSelf.actionView.hidden = YES;
        [weakSelf.customAlterView hihhdenView];
        [MBProgressHUD showError:@"请求失败" toView:weakSelf.view];
        return;
    }];
}
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [TheZoomImage scanBigImageWithImageView:clickedImageView];
}
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth/width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)leftAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(UIImage*)getNormalImage:(UIView*)view
{
    UIGraphicsBeginImageContext(CGSizeMake(ZXSSCREEN_WIDTH, ZXSSCREEN_HEIGHT));
    CGContextRef context=UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage*image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)myStartAnimating
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=1 ;i <=61;  i++){
        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]]];
    }
    [self.activityImageV setAnimationImages:array];
    [self.activityImageV setAnimationRepeatCount:INTMAX_MAX];
    [self.activityImageV setAnimationDuration:0.2];
    [self.activityImageV startAnimating];
}
-(void)myStopAnimating
{
    [self.activityImageV stopAnimating];
    [self.activityImageV removeFromSuperview];
}
-(void)rightAction{
    UIImage*image=[self getNormalImage:self.view];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    [MBProgressHUD showSuccess:@"保存成功！" toView:self.view];
}
- (IBAction)sharebtnAction:(UIButton *)sender {
    self.shareView = [ShareView createViewFromNib];
    self.shareView.delegate = self;
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:self.shareView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:0.4];
//    [alertController setBlurEffectWithView:self.view];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -shareViewdelegate
#pragma mark - shareViewDelegate
-(void)clickMyShareButtonWithTag:(int)tag{
    if (tag == 0) {
        self.shareType = SSDKPlatformTypeSinaWeibo;
        [self.shareView hideView];
        [self performSelector:@selector(shareWithCurrentScreen) withObject:nil afterDelay:1.0f];
    }else if (tag == 1){
        self.shareType = SSDKPlatformSubTypeWechatSession;
        [self.shareView hideView];
        [self performSelector:@selector(shareWithCurrentScreen) withObject:nil afterDelay:1.0f];
    }else if(tag == 2){
        self.shareType = SSDKPlatformTypeQQ;
        [self.shareView hideView];
        [self performSelector:@selector(shareWithCurrentScreen) withObject:nil afterDelay:1.0f];
    }else if (tag == 3){
        self.shareType = SSDKPlatformSubTypeWechatTimeline;
        [self.shareView hideView];
        [self performSelector:@selector(shareWithCurrentScreen) withObject:nil afterDelay:1.0f];
    }else if (tag ==4){
        [self.shareView hideView];
    }
}
-(void)shareWithCurrentScreen{
    
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
                                   
                                    [MBProgressHUD showSuccess:@"分享成功" toView:self.view];
                                }
                                break;
                                case SSDKResponseStateFail:
                                {
                                   
                                    [MBProgressHUD showError:@"分享失败" toView:self.view];
                                }
                                break;
                                case SSDKResponseStateCancel:
                                {
                                    
                                    [MBProgressHUD showError:@"分享取消" toView:self.view];
                                }
                                break;
                              default:
                                break;
                            }
                            
                        }];
}
- (IBAction)dashangAction:(UIButton *)sender {
    if (self.myscore!=nil) {
        self.detailView.hidden = NO;
        [self.customAlterView showShareViewAddView:self.detailView tapGestureWithBool:YES];
        [self.zfTableView reloadData];
    }else{
        self.bgimageView.userInteractionEnabled = NO;
        self.tantouRedPacketView.hidden = NO;
        [self.customAlterView showShareViewAddView:self.tantouRedPacketView tapGestureWithBool:YES];
    }
}
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
#pragma mark - ZFCustomAlterViewDelegate
-(void)customAlterViewHidden{
    [self ZFhiddenOtherView];
}
#pragma mark --隐藏其他的东西
-(void)ZFhiddenOtherView{
    self.bgimageView.userInteractionEnabled = YES;
    self.tantouRedPacketView.hidden = YES;
    self.detailView.hidden = YES;
    [self.customAlterView hihhdenView];
}
@end
