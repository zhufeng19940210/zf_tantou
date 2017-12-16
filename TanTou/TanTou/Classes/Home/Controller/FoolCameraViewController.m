//
//  FoolCameraViewController.m
//  TanTou
//
//  Created by 王文志 on 2017/10/19.
//  Copyright © 2017年 bailing. All rights reserved.
//  拍照页

#import "FoolCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SelectViewController2.h"
@interface FoolCameraViewController ()
/**
 * session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
 * AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (strong, nonatomic) AVCaptureSession *session;
/**
 * 捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
 */
@property (weak, nonatomic) AVCaptureDevice *device;
/**
 *  AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
 */
@property (weak, nonatomic) AVCaptureDeviceInput *input;
/**
 *  照片输出流
 */
@property (weak, nonatomic) AVCaptureStillImageOutput *imageOutput;
/**
 *  图像预览层，实时显示捕获的图像
 */
@property (weak, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
/**containView*/
@property (weak, nonatomic) UIView *containView;
//网格ImageView
@property (weak, nonatomic) UIImageView *gridImageView;
//网格按钮
@property (weak, nonatomic) UIButton *gridButton;
//闪光按钮
@property (weak, nonatomic) UIButton *flashButton;
//聚焦View
@property (weak, nonatomic) UIView *focusView;
/**buttomView*/
@property (weak, nonatomic) UIView *buttomView;
//相机按钮
@property (weak, nonatomic) UIButton *photoButton;
/**屏幕宽度*/
@property (assign, nonatomic) CGFloat screenwidth;
//闪光开关
@property (assign, nonatomic) BOOL isflashOn;
//网格开关
@property (assign, nonatomic) BOOL isgridOn;
//网格ImageView显示隐藏开关
@property (assign, nonatomic) BOOL isgridImageViewHidden;
//照片
@property (strong, nonatomic) UIImage *photoImage;


@end

@implementation FoolCameraViewController
#pragma mark - 懒加载
- (AVCaptureSession *)session {
    if (!_session) {
        // 创建Device,使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.device = device;
        if ([device lockForConfiguration:nil]) {// 配置相机设备,更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
            if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) { // 设置闪光灯为自动
                [device setFlashMode:AVCaptureFlashModeAuto];
            }
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) { //设置白平衡
                [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
            }
            [device unlockForConfiguration];
        }
        
        // 创建input,使用设备初始化输入
        NSError *error = nil;
        AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        self.input = input;
        if (error) {
            NSLog(@"error:%@",error);
            return nil;
        }
        
        // 创建imageOutput
        AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
        self.imageOutput = imageOutput;
        // 输出设置,输出jpeg格式图片
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [imageOutput setOutputSettings:outputSettings];
        
        //生成会话，用来结合输入输出
        _session = [[AVCaptureSession alloc] init];
        // 设置分辨率
        if ([_session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
             _session.sessionPreset = AVCaptureSessionPresetPhoto;
        }

        // 添加输入设备
        if ([_session canAddInput:input]) {
            [_session addInput:input];
        }
        // 添加输出设备
        if ([_session canAddOutput:imageOutput]) {
            [_session addOutput:imageOutput];
        }

    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        // 初始化预览层，session负责驱动input进行信息的采集，layer负责把图像渲染显示
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [self.containView.layer addSublayer:previewLayer];
        self.containView.layer.masksToBounds = YES;
        _previewLayer = previewLayer;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        // 到这里所有的初始化工作基本完成，运行程序可以看到镜头捕捉到得画面。接下来需要实现拍照按钮
    }
    return _previewLayer;
}

- (UIView *)containView {
    if (!_containView) {
        UIView *containView = [[UIView alloc] init];
        [self.view addSubview:containView];
        _containView = containView;
        CGFloat screenwidth = self.screenwidth;
        containView.size = CGSizeMake(screenwidth, screenwidth + ZXSRealValueFit6SWidthPt(125));
        // 预览层
        self.previewLayer.frame = CGRectMake(0, 0, screenwidth, screenwidth);
         //显示网格线ImageView
        UIImageView *gridImageView = [[UIImageView alloc] init];
        [containView addSubview:gridImageView];
        _gridImageView = gridImageView;
        gridImageView.image = [UIImage imageNamed:@"xian"];
        gridImageView.frame = self.previewLayer.frame;
        gridImageView.contentMode = UIViewContentModeScaleAspectFill;
        gridImageView.hidden = YES;
        gridImageView.userInteractionEnabled = YES;
        //网格按钮
        UIButton *gridButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [containView addSubview:gridButton];
        _gridButton = gridButton;
        [gridButton setImage:[UIImage imageNamed:@"jingxian"] forState:UIControlStateNormal];
        [gridButton setImage:[UIImage imageNamed:@"jingxianz"] forState:UIControlStateSelected];
        CGFloat gridButtonWidth = ZXSRealValueFit6SWidthPt(44);
        CGFloat gridButtonY = screenwidth + ZXSRealValueFit6SWidthPt(81) * 0.5;
        gridButton.frame = CGRectMake(screenwidth * 0.5 - ZXSRealValueFit6SWidthPt(134), gridButtonY, gridButtonWidth, gridButtonWidth);
        [gridButton addTarget:self action:@selector(gridButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //闪光按钮
        UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [containView addSubview:flashButton];
        _flashButton = flashButton;
        [flashButton setImage:[UIImage imageNamed:@"shanguang"] forState:UIControlStateNormal];
        [flashButton setImage:[UIImage imageNamed:@"shanguangz"] forState:UIControlStateSelected];
        flashButton.frame = CGRectMake(screenwidth * 0.5 + ZXSRealValueFit6SWidthPt(90), gridButtonY, gridButtonWidth, gridButtonWidth);
        [flashButton addTarget:self action:@selector(flashButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //点击时候的时候显示的正方形
        UIView *tempTapView = [[UIView alloc] init];
        [containView addSubview:tempTapView];
        tempTapView.frame = CGRectMake(0, 0, self.screenwidth, self.screenwidth);
        tempTapView.backgroundColor = [UIColor clearColor];
        
        UIView *focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(160), ZXSRealValueFit6SWidthPt(160))];
        [tempTapView addSubview:focusView];
        _focusView = focusView;
        focusView.layer.borderWidth = 1.0;
        focusView.layer.borderColor = [UIColor whiteColor].CGColor;
        focusView.backgroundColor = [UIColor clearColor];
        focusView.hidden = YES;
        
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
        [tempTapView addGestureRecognizer:tapGesture];
    }
    return _containView;
}

- (UIView *)buttomView {
    if (!_buttomView) {
        
        UIView *buttomView = [[UIView alloc] init];
        [self.view addSubview:buttomView];
        _buttomView = buttomView;
        buttomView.bounds = CGRectMake(0, 0, self.screenwidth, ZXSSCREEN_HEIGHT - CGRectGetMaxY(self.containView.frame));
        buttomView.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
        // 添加拍照按钮
        UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttomView addSubview:photoButton];
        _photoButton = photoButton;
        [photoButton setImage:[UIImage imageNamed:@"anjian"] forState:UIControlStateNormal];
        [photoButton setImage:[UIImage imageNamed:@"anjianz"] forState:UIControlStateHighlighted];
        [photoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];//拍照按钮
        photoButton.bounds = CGRectMake(0, 0, ZXSRealValueFit6SWidthPt(240), ZXSRealValueFit6SWidthPt(240));
        photoButton.center = CGPointMake(self.screenwidth * 0.5, buttomView.height * 0.5-20);
    }
    return _buttomView;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.session) {
       [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.session) {
        [self.session stopRunning];
    }
}

#pragma mark - 自定义方法
- (void)setupNavigationBar {
    self.title = @"拍照";
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)setupUI {
    self.screenwidth = ZXSSCREEN_WIDTH;
    self.view.backgroundColor = [UIColor whiteColor];
    self.containView.origin = CGPointMake(0, -20);
    self.buttomView.origin = CGPointMake(0, CGRectGetMaxY(self.containView.frame));
    // 获取闪光按钮和网格按钮默认设置值，并且设置闪光按钮和网格按钮
    [self setupGridButtonAndFlashButton];
}
// 获取闪光按钮和网格按钮默认设置值，并且设置闪光按钮和网格按钮
- (void)setupGridButtonAndFlashButton {
    // 获取网格按钮默认设置值，并且设置网格按钮
    self.isgridOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"isgridOn"];
    if (self.isgridOn) {
        self.gridImageView.hidden = NO;
        self.gridButton.selected = YES;
        self.isgridImageViewHidden = NO;
    }else {
        self.gridImageView.hidden = YES;
        self.gridButton.selected = NO;
        self.isgridImageViewHidden = YES;
    }
    // 获取闪光按钮默认设置值，并且设置闪光按钮
    self.isflashOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"isflashOn"];
    if ([self.device lockForConfiguration:nil]) {
        if (self.isflashOn) {
            if ([self.device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [self.device setFlashMode:AVCaptureFlashModeOn];
                self.flashButton.selected = YES;
            }
        } else {
            if ([self.device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [self.device setFlashMode:AVCaptureFlashModeOff];
                self.flashButton.selected = NO;
            }
        }
        [self.device unlockForConfiguration];
    }
}
#pragma mark - 触发事件
- (void)backBarButtonItemDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancelBarButtonItemDidClick {
    //设置拍照、闪光按钮和网格按钮能点击
    self.view.userInteractionEnabled = YES;
    //设置导航栏leftBarButtonItem
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem zxs_barButtonItemWithHighlightedStatusWithImage:[UIImage imageNamed:@"zf_back_height"] highlightedImage:nil target:self action:@selector(backBarButtonItemDidClick)];
    //设置导航栏rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    //设置将存储照片的imageView里面的照片移除
    self.gridImageView.image = [UIImage imageNamed:@"xian"];
    if (self.isgridImageViewHidden) {
        self.gridImageView.hidden = YES;
    } else {
        self.gridImageView.hidden = NO;
    }
}
- (void)completeBarButtonItemDidClick {
    // 保存图片
    [self saveImageToPhotoAlbum:self.photoImage];
    SelectViewController2 *selectVc2 = [[SelectViewController2 alloc]init];
    selectVc2.selectImage = self.photoImage;
    [self.navigationController pushViewController:selectVc2 animated:YES];
}
//网格线打开与关闭
- (void)gridButtonDidClick:(UIButton *)button {
    if (self.isgridOn) {
        self.isgridOn = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isgridOn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        button.selected = NO;
        self.gridImageView.hidden = YES;
        self.isgridImageViewHidden = YES;
    } else {
        self.isgridOn = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isgridOn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        button.selected = YES;
        self.gridImageView.hidden = NO;
        self.isgridImageViewHidden = NO;
    }
    
}

//闪光灯打开与关闭
- (void)flashButtonDidClick:(UIButton *)button {
    
    if ([_device lockForConfiguration:nil]) {
        if (_isflashOn) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isflashOn"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                button.selected = NO;
            }
        } else {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isflashOn"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                button.selected = YES;
            }
        }
        [_device unlockForConfiguration];
    }
}

//点击的时候出现黄色的小正方形
- (void)focusGesture:(UITapGestureRecognizer*)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    NSLog(@"NSStringFromCGPoint%@",NSStringFromCGPoint(point));
    // 设置正方形只能在画面区域显示
    NSInteger maxPointY = 44 + self.screenwidth;
    NSInteger minPointY = 44;
    if (point.y > minPointY && point.y < maxPointY) {
        [self focusAtPoint:point];
    }
    
}

- (void)focusAtPoint:(CGPoint)point {
    
    CGSize size = self.gridImageView.size;
    CGPoint focusPoint = CGPointMake(point.y / size.height ,1 - point.x / size.width);
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
}

- (void)shutterCamera {
    self.view.userInteractionEnabled = NO;
    //session通过AVCaptureConnection连接AVCaptureStillimageOutPut进行图片输出
    AVCaptureConnection *videoConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    // 捕捉静态图片
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        UIImage *tempImage = [UIImage imageWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer]];
        NSLog(@"tempImage%@",NSStringFromCGSize(tempImage.size));
        UIImage *squareImage = [self squareImageFromImage:tempImage scaledToSize:self.screenwidth];
        self.photoImage = squareImage;
        self.gridImageView.image = squareImage;
        
        if (self.gridImageView.hidden) {
            self.isgridImageViewHidden = YES; //记录先前是否隐藏
            self.gridImageView.hidden = NO;
        } else {
            self.isgridImageViewHidden = NO;
        }
        // 设置导航栏
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem zxs_barButtonItemWithColor:[UIColor whiteColor] font:nil target:self action:@selector(cancelBarButtonItemDidClick) title:@"取消"];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem zxs_barButtonItemWithColor:[UIColor whiteColor] font:nil target:self action:@selector(completeBarButtonItemDidClick) title:@"完成"];
    }];
}
/**
 *  剪切图片为正方形
 *  @param image   原始图片比如size大小为(400x200)pixels
 *  @param newSize 正方形的size比如400pixels
 *  @return 返回正方形图片(400x400)pixels
 */
- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        //image原始高度为200，缩放image的高度为400pixels，所以缩放比率为2
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        //设置绘制原始图片的画笔坐标为CGPoint(-100, 0)pixels
        origin = CGPointMake(- (image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        origin = CGPointMake(0, - (image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    //创建画板为(400x400)pixels
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将image原始图片(400x200)pixels缩放为(800x400)pixels
    CGContextConcatCTM(context, scaleTransform);
    //origin也会从原始(-100, 0)缩放到(-200, 0)
    [image drawAtPoint:origin];
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage *)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil;
    if (error != NULL) {
        msg = @"保存图片失败";
    } else {
        msg = @"保存图片成功";
    }
    NSLog(@"%@",msg);
}
@end
