//
//  ZXSNetworkTool.m
//  TanTou
//
//  Created by yejingtao on 16/8/19.
//  Copyright © 2016年 到点网. All rights reserved.
//

#import "ZXSNetworkTool.h"
#import "MBProgressHUD+MJ.h"

@interface ZXSNetworkTool ()

@end

@implementation ZXSNetworkTool
#pragma mark - 单例
static id _instance;
static AFHTTPSessionManager *_session;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedNetworkTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _session = [AFHTTPSessionManager manager];
        _session.responseSerializer = [AFHTTPResponseSerializer serializer];
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}


/**
 发送get请求
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    [_session GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 发送post请求
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {

    [_session POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 上传多张图片
+ (void)requestWithUrl:(NSString *)url withPostedImages:(NSArray *)imagesArray WithSuccessBlock:(void (^)(NSArray *resultArray))successBlock WithNeebHub:(BOOL)needHub WithView:(UIView *)viewWithHub WithData:(NSDictionary *)dataDic {
    if (imagesArray.count > 0) {
        
        // 创建一个临时的数组，用来存储回调回来的结果
        NSMutableArray *temArray = [NSMutableArray array];
        MBProgressHUD *hud =  [MBProgressHUD showMessage:@"正在上传图片，请稍候.."];
        // 取消遮罩
        hud.dimBackground = NO;
        
        for (int i = 0;  i < imagesArray.count; i++) {
            
            UIImage *imageObj = imagesArray[i];
            //截取图片
            NSData *imageData = UIImageJPEGRepresentation(imageObj, 0.5);
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            // 访问路径
            [manager POST:url parameters:dataDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                // 上传文件
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
//                NSLog(@"%@",uploadProgress);

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                [temArray addObject:dic];
                
                //当所有图片上传成功后再将结果进行回调
                if (temArray.count == imagesArray.count) {
                    [hud hide:YES];
                    [MBProgressHUD showSuccess:@"图片上传成功"];
                    successBlock(temArray);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    }
}

@end
