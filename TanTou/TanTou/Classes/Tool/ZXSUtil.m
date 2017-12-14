//  ZXSUtil.m
//
//
//  Created by bailing on 2017/3/2.
//  Copyright © 2017年 到点网. All rights reserved.
//

#import "ZXSUtil.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"
#import "AFNetworking.h"

static ZXSUtil *util = nil;
@interface ZXSUtil ()
/** 网络状态检查者 */
@property(nonatomic,strong) AFNetworkReachabilityManager *networkMonitorManager;
@property(nonatomic,assign) BOOL netConnectStatus;

@end

@implementation ZXSUtil

+ (instancetype)shareUtil{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        util = [[ZXSUtil alloc] init];
    });
    return util;
}

/**
   将字符串转换成日期
 */
- (NSDate *)changeStr:(NSString *)str{
    str = [str substringToIndex:14];
    NSLog(@"str:%@",str);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:str];
    NSLog(@"date:%@",date);
    return  date;
}

// 通过订单标号得到时间
- (NSString *)getFormatterWithStr:(NSString *)str{
    NSDate *date = [self changeStr:str];
    NSLog(@"date:%@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *now = [dateFormatter stringFromDate:date];
    return now;
}

// 得到当前网络的状况
- (NSString *)getcurrentStatus{
    NSString *netconnType = @"";
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:{// 没有网络
            netconnType = @"NotNet";
        }
            break;
        case ReachableViaWiFi:{// Wifi
            netconnType = @"Wifi";
        }
            break;
        case ReachableViaWWAN:{// 手机自带网络
            
            // 获取手机网络具体类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentStatus = info.currentRadioAccessTechnology;
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                netconnType = @"4G";
            }
        }
            break;
        default:
            break;
    }
    
    return netconnType;
}

// 判断网络是否连接
- (BOOL)isNetworkConnect{
    self.networkMonitorManager = [AFNetworkReachabilityManager sharedManager];
    [self.networkMonitorManager startMonitoring];  //开始监听
    
    __weak typeof(self) weakSelf = self;
    [self.networkMonitorManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {// 没有网络
            weakSelf.netConnectStatus = NO;
        }else{// 有网络
            weakSelf.netConnectStatus = YES;
        }
    }];
    
    return weakSelf.netConnectStatus;
}

//通过时间戳获取时间
- (NSString *)getConfirmDateWithStr:(NSString *)dateStr{
    //获取时间戳
    NSTimeInterval time = [dateStr doubleValue] + 28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}


//格式化输出手机号码
- (NSString *)fomatterWithMoblie:(NSString *)moblieStr{
    NSLog(@"moblieStr:%@",moblieStr);
    return nil;
}

// 验证手机号码
- (BOOL)isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
        NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        /**
         10         * 中国移动：China Mobile
         11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         12         */
        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
        /**
         15         * 中国联通：China Unicom
         16         * 130,131,132,152,155,156,185,186
         17         */
        NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
        /**
         20         * 中国电信：China Telecom
         21         * 133,1349,153,180,189,181(增加)
         22         */
        NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
        if (([regextestmobile evaluateWithObject:mobileNumbel]
             || [regextestcm evaluateWithObject:mobileNumbel]
             || [regextestct evaluateWithObject:mobileNumbel]
             || [regextestcu evaluateWithObject:mobileNumbel])) {
            return YES;
        }
    
        return NO;
}


//得到当期的时间(时)
- (NSString *)getCurrentHour{
    //   获取今天的小时
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *hour = [formatter stringFromDate:date];
    NSString *curentHour =[hour substringWithRange:NSMakeRange(11,2)] ;
    NSLog(@"%@",curentHour);
    return curentHour;
}
//得到当前的时间(分)
- (NSString *)getCurretnMin{
    NSDate *date1 = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *min = [formatter1 stringFromDate:date1];
    NSString *currentMin = [min substringWithRange:NSMakeRange(14,2)] ;
    NSLog(@"currentMin:%@",currentMin);
    return currentMin;
}
- (void)myStartAnimating{

}

- (void)myStopAnimating{

}
@end
