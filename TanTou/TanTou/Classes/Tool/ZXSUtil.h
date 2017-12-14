//
//  ZXSUtil.h
//
//
//  Created by bailing on 2017/3/2.
//  Copyright © 2017年 到点网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ZXSUtil : NSObject

+ (instancetype)shareUtil;

// 通过订单标号得到时间
- (NSString *)getFormatterWithStr:(NSString *)str;

// 得到当前网络的状况
- (NSString *)getcurrentStatus;

// 通过时间戳获取时间
- (NSString *)getConfirmDateWithStr:(NSString *)dateStr;

// 格式化输出手机号码
- (NSString *)fomatterWithMoblie:(NSString *)moblieStr;

// 验证手机号码
- (BOOL)isMobile:(NSString *)mobileNumbel;

// 得到当期的时间(时)
- (NSString *)getCurrentHour;

// 得到当前的时间(分)
- (NSString *)getCurretnMin;

// 判断网络是否连接
-(BOOL)isNetworkConnect;

@end
