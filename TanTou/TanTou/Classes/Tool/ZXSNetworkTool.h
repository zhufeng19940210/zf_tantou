//
//  ZXSNetworkTool.h
//  TanTou
//
//  Created by yejingtao on 16/8/19.
//  Copyright © 2016年 到点网. All rights reserved.
//
//  在afn的基础上再封装网络

#import <Foundation/Foundation.h>

@interface ZXSNetworkTool : NSObject <NSCopying>

+ (instancetype)sharedNetworkTool;

/**
   发送get请求
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure;

/**
 发送post请求
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure;

@end
