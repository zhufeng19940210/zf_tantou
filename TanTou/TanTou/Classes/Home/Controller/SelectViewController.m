//
//  SelectViewController.m
//  The  probe
//
//  Created by bailing on 2017/8/7.
//  Copyright © 2017年 daodian. All rights reserved.
//评分页面

#import "TheZoomImage.h"
#import "SelectViewController.h"

#import "UIView+TYAlertView.h"
// if you want blur efffect contain this
#import "TYAlertController+BlurEffects.h"
#import "ShareView.h"
#import "ModelTableViewCell.h"
#import "SelectHeaderView.h"
#import "SelectTableViewCell.h"
#import "SelectModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface SelectViewController ()<UITableViewDelegate,UITableViewDataSource>
#define UIbili     [UIScreen mainScreen].bounds.size.width/750

@property (weak, nonatomic) IBOutlet UIImageView *yuandianimage;
@property (weak, nonatomic) IBOutlet UILabel *biaoyulabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgimageView;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (nonatomic,strong)UIImageView *activityImageV;
@property (weak, nonatomic) IBOutlet UIImageView *actionView;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTopLayout;
@property(nonatomic,strong) UIButton*shareBtn;
@property(nonatomic,strong)  UIView*views;
#pragma mark zhufeng
@property (weak, nonatomic) IBOutlet UIView *ZFAlterView;
@property (weak, nonatomic) IBOutlet UIView *ZFMyView;
@property (weak, nonatomic) IBOutlet UITableView *zfTableView;


//分享之后的界面
@property (strong, nonatomic) IBOutlet UIView *view2;
//布局view
@property (strong, nonatomic) IBOutlet UIView *FoolimageView;
//显示的食物
@property (strong, nonatomic) IBOutlet UIImageView *Foolimage;
//得分情况
@property (strong, nonatomic) IBOutlet UILabel *HealthScore;

@property (nonatomic,strong)NSMutableArray *foodDataArray;
@property (nonatomic,strong)NSString *myscore;
@end

@implementation SelectViewController

-(NSMutableArray *)foodDataArray{

    if (_foodDataArray == nil) {
        
        _foodDataArray = [NSMutableArray array];
    }
    return _foodDataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _yuandianimage.hidden=YES;
    _biaoyulabel.hidden=YES;
    _view2.hidden=YES;
    self.navigationController.navigationBar.frame=CGRectMake(0, 0, ZXSSCREEN_WIDTH, 64);
    [self.navigationController.navigationBar setNeedsLayout];
    self.navigationController.navigationBarHidden = NO;
    self.bgimageView.image = self.selectImage;
    self.Foolimage.image = self.selectImage;
    self.bgimageView.contentMode = UIViewContentModeScaleAspectFit;
    self.Foolimage.contentMode = UIViewContentModeScaleAspectFit;

//    self.Foolimage.clipsToBounds=YES;
//    self.Foolimage.contentMode =  UIViewContentModeScaleAspectFill;

    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [_bgimageView addGestureRecognizer:tapGestureRecognizer1];
    
    UITapGestureRecognizer *alterTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAlterView:)];
    [self.ZFAlterView addGestureRecognizer:alterTapGesture];
    [_bgimageView setUserInteractionEnabled:YES];
    [self createnav];
    [self sendShareCommandWithType:self.selectImage];
    //接受通知
    NSNotificationCenter  *center=[NSNotificationCenter    defaultCenter];
    [center    addObserver:self selector:@selector(tongzhiClickedxianshi) name:@"xianshi" object:nil];
    NSNotificationCenter  *center1=[NSNotificationCenter    defaultCenter];
    [center1    addObserver:self selector:@selector(tongzhiClickedyincang) name:@"yincang" object:nil];
    
}

-(void)hiddenAlterView:(UITapGestureRecognizer *)gsture{
    self.ZFAlterView.hidden = YES;
    self.ZFMyView.hidden = YES;
}

-(void)createTableView{
    self.zfTableView.delegate = self;
    self.zfTableView.dataSource = self;
    [self.zfTableView registerNib:[UINib nibWithNibName:@"SelectHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"SelectHeaderView"];
    [self.zfTableView registerNib:[UINib nibWithNibName:@"SelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SelectTableViewCell"];
    self.ZFMyView.layer.masksToBounds=YES;
    self.ZFMyView.layer.cornerRadius=20;
    self.zfTableView.backgroundColor=[UIColor whiteColor];
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
    cellHeight = textH +70;
    
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
    NSLog(@"%ld",(long)button.tag);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectTableViewCell"];
    if (cell == nil) {
        cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectTableViewCell"];
    }
    cell.backgroundColor=[UIColor whiteColor];
    SelectModel *model = self.foodDataArray[indexPath.section];
    cell.contentLabel.text = model.intro;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)createnav
{
   
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"健康分数";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"左-1"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"左-1"] forState:UIControlStateHighlighted];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    UIImage* image=[UIImage imageNamed:@"导航栏"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

-(void)sendShareCommandWithType:(UIImage*)photo{
    if ([[[ZXSUtil shareUtil] getcurrentStatus] isEqualToString:@"NotNet"]) {
        [MBProgressHUD showError:@"网络未连接"];
        return;
    }
    self.activityView.hidden = NO;
    [self myStartAnimating];
    photo = [self imageCompressForWidth:photo targetWidth:200.0f];//屏幕界面
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
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"dict:%@",dict);
        [weakSelf myStopAnimating];
        self.activityView.hidden = YES;
        NSNumber*status  =[dict objectForKey:@"status"];
        int a=[status intValue];
        if(a==1)
        {
            _yuandianimage.hidden=NO;
            NSMutableDictionary*result=[dict objectForKey:@"result"];
            weakSelf.myscore=[result objectForKey:@"score"];
            NSMutableArray*arrfood=[[NSMutableArray alloc]init];
            arrfood=[result objectForKey:@"food"];
            for (int i=0; i<arrfood.count; i++) {
                NSMutableDictionary*food=[arrfood objectAtIndex:i];
                SelectModel *model = [[SelectModel alloc]init];
                NSString*foodname=[food objectForKey:@"food_name"];
                NSString*intro=[food objectForKey:@"intro"];
                model.food_name = foodname;
                model.intro = intro;
                [self.foodDataArray addObject:model];
            }
                weakSelf.count.text = [NSString stringWithFormat:@"%@分",weakSelf.myscore];
                weakSelf.HealthScore.text =[NSString stringWithFormat:@"%@分",weakSelf.myscore];
        }else
        {
            _biaoyulabel.hidden=YES;
            _yuandianimage.hidden=YES;
            weakSelf.count.text = [NSString stringWithFormat:@"不是食物哦"];
            weakSelf.HealthScore.text = [NSString stringWithFormat:@"不是食物哦"];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"请求失败"];
    }];
}
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [TheZoomImage scanBigImageWithImageView:clickedImageView];
}
-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
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
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

    [self.actionView setAnimationImages:array];
    [self.actionView setAnimationRepeatCount:INTMAX_MAX];
    [self.actionView setAnimationDuration:0.5];
    [self.actionView startAnimating];
}
-(void)myStopAnimating
{
    [self.actionView stopAnimating];
    [self.actionView removeFromSuperview];
}
//保存的调用的方法
-(void)rightAction{
    [self loadImageFinished:[self captureImageFromView:self.view]];
}
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败";
    }else{
        msg = @"保存图片成功";
    }
    //需要更新
    UIAlertView *alterVC = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self  cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alterVC show];
}

//截图功能
-(UIImage *)captureImageFromView:(UIView *)view
{
    CGRect screenRect = [view bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)useMobShareSDKForShareImage:(UIImage *)shareImage {
    
    __weak typeof(self) weakSelf = self;
    //1、创建分享参数
    NSArray *imageArray = @[shareImage];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];//[NSURL URLWithString:@"http://mob.com"]
        [shareParams SSDKSetupShareParamsByText:@"下载探头APP,参与圣诞猜题抢红包活动,这里有海量红包等你拿回家哟,快来加入吧!" images:imageArray url:nil title:@"探头圣诞抢红包活动来啦" type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //showShareActionSheet:要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
            switch (state) {
                case SSDKResponseStateSuccess: {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
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

- (IBAction)sharebtnAction:(UIButton *)sender {
//    ShareView *shareView = [ShareView createViewFromNib];
//
//    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
//    [alertController setBlurEffectWithView:self.view];
//    //通知主界面显示
//    NSNotification *notice = [NSNotification notificationWithName:@"xianshi" object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notice];
//    [self presentViewController:alertController animated:YES completion:nil];
     UIImage *snapImage = [self captureImageFromView:self.view];
    [self useMobShareSDKForShareImage:snapImage];
}
//开始接受通知
-(void)tongzhiClickedxianshi
{
    self.view2.hidden=NO;
    self.navigationController.navigationBarHidden=YES;
}
//开始接受通知
-(void)tongzhiClickedyincang
{
    self.view2.hidden=YES;
    self.navigationController.navigationBarHidden=NO;
}
- (IBAction)dashangAction:(UIButton *)sender {
    if (self.myscore!=nil) {
        [self createTableView];
        self.ZFMyView.hidden = NO;
        self.ZFAlterView.hidden = NO;
        [self.zfTableView reloadData];
    }else{
        [MBProgressHUD showError:@"这个不是食物"];
    }
}
- (IBAction)backbtnAction:(UIButton *)sender {
    self.ZFAlterView.hidden = YES;
    self.ZFMyView.hidden = YES;
}

@end
